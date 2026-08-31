# Run a Relayer Operator — complete setup

This is the **end-to-end guide** to become a paid relayer operator on the
Terra Classic Hyperlane bridge. An operator runs two things on one VPS:

1. **The official Hyperlane relayer** — delivers the cross-chain messages (it is
   the *unmodified* Hyperlane binary), and
2. **The three proof-of-delivery agents** — the support crew that turns those
   deliveries into on-chain **payments** and keeps gas prices honest:
   `oracle-agent`, `claim-agent`, `epoch-reporter`.

You get paid from the **relayer-reward vault** on each chain: users pay
interchain gas (IGP) at the origin, the fees accumulate in the vault pool, and a
proof of delivery (the chain's own execution record) releases your commission.

> Already run a **validator**? Good — the relayer usually rides on the same VPS.
> Validator setup is a separate guide:
> [hyperlane-validator](https://github.com/terra-classic-hyperlane/hyperlane-validator).
> This document covers the **relayer + POD agents**.

---

## 0. Prerequisites

- A Linux VPS (root), Node.js **≥ 20**, and `git`. For the relayer binary you
  need **either** a working Rust toolchain to compile it (Option A) **or** Docker
  just to extract the prebuilt binary (Option B) — see §1.
- The two code repos on the VPS:
  ```bash
  git clone https://github.com/terra-classic-hyperlane/proof-of-delivery.git
  git clone https://github.com/terra-classic-hyperlane/hyperlane-validator.git
  ```
- **Two separate wallets** (this matters — see the box below), each funded with
  gas on all four chains:
  - **Relayer wallet** — signs message delivery on TC · BSC · ETH · Solana.
  - **Tooling wallet** — signs the claim-agent / epoch-reporter transactions.
- Per-chain addresses of your operator wallet: `terra1…` (TC), `0x…` (BSC/ETH),
  base58 pubkey (Solana). Key generation: see the validator repo's
  [HYPERLANE-PRIVATE-KEYS-HEX.md](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/HYPERLANE-PRIVATE-KEYS-HEX.md).

> ⚠️ **Never reuse the relayer wallet for the agents.** The relayer and the
> claim-agent both sign on Terra Classic; sharing one account causes sequence
> contention (one bumps the nonce under the other). Use a dedicated tooling
> wallet for the agents, and after any manual script that signs with the relayer
> wallet, `systemctl restart hyperlane-relayer` to resync its sequence.

---

## 1. Install the official relayer

The relayer is the **official Hyperlane binary, with zero code changes**, and it
runs as a **native `systemd` service** — not in Docker. There are two ways to get
the binary onto the VPS; both end at the same native `hyperlane-relayer.service`.
Pick **A** if you can compile, **B** if the VPS toolchain fails.

### Option A — native binary via the automated installer (recommended)

The [hyperlane-validator](https://github.com/terra-classic-hyperlane/hyperlane-validator)
repo ships `install-vps.sh`, which builds the **validator and relayer from source**
and installs both as native systemd services in one shot — no Docker. This is how
the production VPS is set up.

```bash
# on the machine that has ~/hyperlane-monorepo checked out:
cd hyperlane-validator
./install-vps.sh --vps <VPS_IP> --mode native --network mainnet
#   --user root  --dir /root/hyperlane   (defaults)
#   --force-rebuild   to recompile even if binaries already exist
```

What it does: generates the JSON configs from your `.env` + templates, syncs
block heights, then per-agent `cargo build --release`
(`~/hyperlane-monorepo/rust/main/agents/relayer`), uploads the binary to
`/root/hyperlane/bin/relayer`, and installs the systemd unit. If a compiled
binary already exists it offers to **reuse it and skip the 15–30 min build**.
Full flow: the validator repo's
[README](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/README.md)
and [manual VPS guide](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/hyperlane-validator-relayer-vps-english.md)
(the same script installs the validator — §"validators" — so one run sets up both).

To build the relayer binary by hand instead (what the installer automates):

```bash
cd ~/hyperlane-monorepo/rust/main/agents/relayer
cargo build --release          # → ../../target/release/relayer
cp ~/hyperlane-monorepo/rust/main/target/release/relayer /root/hyperlane/bin/relayer
```

> ⚠️ Compiling on the VPS itself can hit a **rustc 1.84 vs edition2024** mismatch
> in newer deps. Build on a machine with a current toolchain, or use Option B.

### Option B — extract the official binary from the Docker image (no compiling)

When you can't compile, take the prebuilt binary straight out of the official
image. Docker is used **only to extract the file** — the relayer still runs
natively via systemd, never as a container.

```bash
# 1. pull the official image (agents-v2.0.0)
docker pull gcr.io/abacus-labs-dev/hyperlane-agent:agents-v2.0.0
#    verified digest: sha256:e953983fee85fd01432f9e6a40e192cafc2c39db4a180aac34e55f8f624c964a

# 2. extract the relayer binary (does not run the container)
C=$(docker create gcr.io/abacus-labs-dev/hyperlane-agent:agents-v2.0.0)
docker cp $C:/app/relayer /root/hyperlane/bin/relayer
docker rm $C
chmod +x /root/hyperlane/bin/relayer
```

### The native systemd service (both options)

However you got the binary, it runs from `/root/hyperlane/bin/relayer` under
`hyperlane-relayer.service`. The unit as configured on the production VPS:

```ini
[Service]
WorkingDirectory=/root/hyperlane/runtime
EnvironmentFile=/root/hyperlane/.env
Environment=CONFIG_FILES=/root/hyperlane/config/agent-config.mainnet.json,/root/hyperlane/config/relayer.mainnet.json
ExecStartPre=/bin/bash -c 'mkdir -p /tmp/hyp/relayer/cache'
ExecStart=/root/hyperlane/bin/relayer --db /tmp/hyp/relayer/cache --allowLocalCheckpointSyncers false --metrics 0.0.0.0:9091
Restart=always
# drop-in .../hyperlane-relayer.service.d/limits.conf:
LimitNOFILE=1048576
```

`WorkingDirectory` must contain a `config/` subdir with the monorepo's
`mainnet_config.json` (the binary reads `./config/*.json` at startup); keys come
from the `.env` via `EnvironmentFile`, never hardcoded. `install-vps.sh` writes
this unit for you.

Config lives in `/root/hyperlane/config/` (chain registry + relayer config). Use
the templates in the validator repo (`hyperlane/relayer.mainnet.json.template`,
`hyperlane/agent-config.mainnet.json`) and mind these **non-negotiable settings**:

| Setting | Value | Why |
|---|---|---|
| `metricsPort` | **9091** | v2.0.0 reads this key (default 9090); 9090 belongs to the validator — a clash panics the server and silently **kills the message processors** (indexes but never delivers) |
| `relayApiEnabled` / `relayApiPort` | `false` / `9092` | the HTTP control API is unused; keep it off and off-port |
| `LimitNOFILE` (systemd drop-in) | `1048576` | file-descriptor headroom |
| RPCs (`agent-config.mainnet.json`) | BSC official dataseeds first (`index.chunk = 50`), Solana **Helius** ahead of public, TC hexxagon + backups | public RPCs limit `eth_getLogs` to ≤50 blocks and rate-limit Solana |

Install it as `hyperlane-relayer.service` (systemd, `EnvironmentFile` for the
keys — never hardcode them). Full unit design and the block-height sync step are
in the validator repo's install flow
([README](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/README.md)
· [manual VPS guide](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/hyperlane-validator-relayer-vps-english.md)).
Version/update/rollback specifics:
[proof-of-delivery/docs/RELAYER-VPS.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/RELAYER-VPS.md).

**Verify the relayer:**

```bash
systemctl is-active hyperlane-relayer                              # active
journalctl -u hyperlane-relayer -n 200 | grep -c panicked         # 0
ss -tlnp | grep -E ':(9090|9091)'                                 # 9091 relayer · 9090 validator
journalctl -u hyperlane-relayer | grep 'starting up with version' # c117895a…
```

---

## 2. Install the proof-of-delivery agents (one shot)

The three agents install together with a single script that mirrors the
production layout. It is **idempotent**: re-running updates the code but never
touches your `.env`, `config.json` or state.

```bash
cd proof-of-delivery
sudo bash deploy/install-operator.sh
```

What it does (`deploy/install-operator.sh`):

1. Copies the code into `/root/oracle-agent` and `/root/claim-agent` and installs
   npm deps.
2. Writes **template** `.env` / `config.json` / `rpc.env` only if missing
   (existing files are never overwritten).
3. Installs three systemd units — **enabled but NOT started**:

| Service | Loop | Role |
|---|---|---|
| `oracle-agent` | 4 h | proposes gas prices to the 4 governors (a quorum applies them) |
| `claim-agent` | 5 min | emits receipts and collects commissions (tooling wallet) |
| `epoch-reporter` | 1 h | submits the TC→Solana epoch quorum reports |

4. Adds hourly log rotation (1 GB cap per log).

### 2.1 Fill in the config

```bash
# oracle-agent signing keys — names must match the *Env fields in config.json
$EDITOR /root/oracle-agent/.env        # TC_PRIVATE_KEY / BSC_PRIVATE_KEY / ETH_PRIVATE_KEY / SOL_PRIVATE_KEY
$EDITOR /root/oracle-agent/config.json # review governors, RPCs, domains, intervals

# claim-agent + epoch-reporter (TOOLING wallet — not the relayer wallet)
$EDITOR /root/claim-agent/.env         # TC_PRIVATE_KEY / BSC_PRIVATE_KEY / SOLANA_PRIVATE_KEY
$EDITOR /root/claim-agent/rpc.env      # TC / BSC / ETH / Solana RPCs
```

Reference: [oracle-agent/config.example.json](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/oracle-agent/config.example.json).
When a **new warp route** is later added, its sender must be appended to
`originSenders` in the oracle-agent config so its deliveries get swept.

### 2.2 Start and verify

```bash
systemctl start oracle-agent claim-agent epoch-reporter
tail -f /root/oracle-agent/logs/agent.log \
        /root/claim-agent/logs/agent.log \
        /root/claim-agent/logs/reporter.log
```

---

## 3. Register on-chain as an operator (the quorum)

Running the agents is not enough — your operator address must be **in the
contract's operator set** on each chain for your submissions to count. The
**quorum** is how many distinct operators must submit/approve before a contract
acts (apply a price; on Solana also close a credit epoch and execute vault
proposals). Invariant everywhere: `1 ≤ quorum ≤ number of operators`.

Only the **owner** changes the set — **governance** on Terra Classic, the
**validators' multisig** on the remotes. So registering a new operator is a
governance/multisig action, not something the operator does alone.

**Terra Classic — oracle-governor (CosmWasm):**
```bash
# who is in the quorum:
terrad q wasm contract-state smart <GOVERNOR> '{"operators":{}}' --node $NODE
terrad q wasm contract-state smart <GOVERNOR> '{"config":{}}'    --node $NODE   # includes quorum
# owner adds an operator (governance proposal in production):
terrad tx wasm execute <GOVERNOR> '{"set_operators":{"add":["terra1NEW"],"remove":[]}}' $TXFLAGS
terrad tx wasm execute <GOVERNOR> '{"set_quorum":{"quorum":2}}' $TXFLAGS
```

**BSC / Ethereum — GasOracleGovernor.sol:**
```bash
cast call $GOVERNOR "isOperator(address)(bool)" 0xOPERATOR --rpc-url $RPC
cast call $GOVERNOR "quorum()(uint256)"         --rpc-url $RPC
# owner (multisig) adds: setOperator(address,bool) / setQuorum(uint256)
```

**Solana — pod program:** register the operator pubkey and adjust the epoch
quorum via the pod admin instructions
([register-solana-operator.mjs](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/deploy/register-solana-operator.mjs)).

Full procedure, per-chain queries and add/remove ordering (always lower the
quorum before removing an operator — the contracts forbid `quorum > operators`):
[proof-of-delivery/docs/OPERATORS.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/OPERATORS.md).

> The TC **vault** has no operator list by design: `Claim` is open and pays only
> whoever the Mailbox recorded as the executor of the delivery — so delivery
> rewards are permissionless; the operator set only gates the **gas oracle** (and
> Solana epochs/vault proposals).

---

## 4. Monitor

```bash
node deploy/monitor.mjs            # full health view — 4 chains + VPS services (SSH)
node deploy/monitor.mjs --no-vps   # on-chain only
node deploy/monitor.mjs --watch    # refresh every 60s
node deploy/monitor-web.mjs        # same panel in the browser (http://localhost:8787)
```

The panel shows wallets/gas (⚠ LOW alerts), vault pools (when to sweep),
per-chain relayer cursor and stuck messages, epochs and the prices the
oracle-agent wrote on-chain, and whether every service is active.

---

## 5. How you get paid (the money flow)

1. A user bridges a token → pays the interchain gas fee (IGP) on the origin chain.
2. The **official relayer (you)** delivers the message to the destination Mailbox.
3. The chain records the delivery (TC storage / EVM `processor()` / Solana epoch).
4. `claim-agent` reads that record, emits the **receipt**, and claims your
   commission from the destination/origin vault. The IGP fee that funded it is a
   **pass-through tariff** (the reward equals the tariff, never a fixed number).

Deep dives: [VAULT.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/VAULT.md) ·
[FEES-AND-REWARDS.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/FEES-AND-REWARDS.md) ·
[ORACLE-AGENT.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/ORACLE-AGENT.md) ·
[TRUSTLESS-RECEIPT.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/TRUSTLESS-RECEIPT.md).

---

## Checklist

- [ ] VPS with Node ≥ 20 + Docker; both repos cloned
- [ ] Separate **relayer** and **tooling** wallets, funded on all 4 chains
- [ ] Official relayer extracted, configured (`metricsPort 9091`), running, 0 panics
- [ ] `install-operator.sh` run; `.env` / `config.json` / `rpc.env` filled
- [ ] `oracle-agent`, `claim-agent`, `epoch-reporter` started and logging
- [ ] Operator address registered on-chain (governance/multisig) and quorum set
- [ ] `monitor.mjs` green; a test transfer is delivered and the commission is paid
