# Terra Classic Hyperlane — Documentation Hub

Community-run [Hyperlane](https://hyperlane.xyz) interoperability for
**Terra Classic** (`columbus-5`, domain **132556**) — bridging **LUNC** and
**USTC** to **BSC**, **Ethereum** and **Solana**, secured by a community
validator set and paid through an on-chain relayer-reward vault.

**🌉 Just want to bridge? → https://terraclassic-bridge.xyz**

This page is the single entry point for everything else — each section sends
you to the right guide in the right repository.

| I want to… | Go to |
|---|---|
| Run a **validator** | [§1](#1-run-a-validator) |
| Run the **relayer** (and its vault / agents) | [§2](#2-run-the-relayer--vault--agents) |
| Understand **fees, rewards and the gas oracle** (quorum) | [§3](#3-gas-oracle-fees--rewards) |
| Create a **warp route** (bridge a token) | [§4](#4-create-a-warp-route) |
| Change **ISM or IGP** on any chain | [§5](#5-changing-ism--igp--who-can-change-what) |
| **Audit** contracts, hashes and live routes | [§6](#6-audit-deployment-records--hashes) |
| Use the **bridge UI / explorer / registry** | [§7](#7-live-infrastructure) |

---

## 1. Run a Validator

Repository: [**hyperlane-validator**](https://github.com/terra-classic-hyperlane/hyperlane-validator)

- **Start here:** [README](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/README.md) — what a validator does and the full setup path
- [Docker installation guide](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/DOCKER-INSTALLATION-GUIDE.md) · [VPS without Docker](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/hyperlane-validator-relayer-vps-english.md)
- [AWS S3 + keys guide](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/GUIDE-AWS-S3-AND-KEYS.md) — checkpoint storage the relayers read
- [Private keys in hex format](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/HYPERLANE-PRIVATE-KEYS-HEX.md) · [Configuration files reference](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/hyperlane-configuration-files-guide.md)
- **Become a rewarded TCV validator** (announce, register as operator, earn from the vault): [TCV Validator Mainnet Guide](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/TCV-VALIDATOR-MAINNET-GUIDE.md) and [Operators & Validators guide](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/OPERATORS-VALIDATORS-GUIDE.md)

## 2. Run the Relayer — vault & agents

The relayer delivers messages between chains and is **paid from the
relayer-reward-vault**: users pay interchain gas (IGP) on the origin chain, the
fees flow into the vault pool, and delivery proofs unlock the rewards.

- **▶ Complete operator setup (relayer + POD agents, end to end):**
  [RELAYER-OPERATOR.md](RELAYER-OPERATOR.md) — the one guide that installs the
  official relayer **and** the three proof-of-delivery agents together, with the
  on-chain operator registration
- **Relayer setup (detail):** [validator/relayer VPS guide](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/hyperlane-validator-relayer-vps-english.md) · [Docker guide](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/DOCKER-INSTALLATION-GUIDE.md) · [relayer on the production VPS](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/RELAYER-VPS.md) · [relayer API guide](https://github.com/terra-classic-hyperlane/hyperlane-validator/blob/main/hyperlane-relayer-api-guide.md)
- **The vault (how the relayer gets paid):** [VAULT.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/VAULT.md)
- **Run the agents** (claim-agent / receipts — sweep deliveries and claim rewards): [INSTALL-AND-RUN.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/INSTALL-AND-RUN.md) (full install: [docs/install/INSTALL.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/install/INSTALL.md)) · [Remote claim](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/REMOTE-CLAIM.md) ([security model](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/REMOTE-CLAIM-SECURITY.md)) · [Trustless receipt](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/TRUSTLESS-RECEIPT.md)
- **Operating reference:** [OPERATORS.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/OPERATORS.md) · [architecture](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/ARCHITECTURE.md)

## 3. Gas oracle, fees & rewards

Gas prices are **never set by hand**: the oracle-agent proposes them, and a
**quorum of validator operators** approves before the governor applies them
on-chain — on every chain.

- **Oracle agent (how prices are proposed/approved — quorum):** [ORACLE-AGENT.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/ORACLE-AGENT.md)
- **Quorum / governance parameters:** [PROPOSAL-PARAMETERS.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/PROPOSAL-PARAMETERS.md)
- **What users pay and what operators earn:** [FEES-AND-REWARDS.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/FEES-AND-REWARDS.md)
- Contract-level operations (vault/governor calls): [CONTRACT-OPERATION.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/CONTRACT-OPERATION.md)

## 4. Create a Warp Route

Repository: [**cw-hyperlane**](https://github.com/terra-classic-hyperlane/cw-hyperlane) → [`terraclassic/`](https://github.com/terra-classic-hyperlane/cw-hyperlane/tree/main/terraclassic)

One script per target chain deploys **only the token's own contracts** and wires
the shared production ISM/IGP/hooks automatically:

- **Start here:** [terraclassic/doc/install/](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/README.md)
- [WARP-EVM.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-EVM.md) — BSC / Ethereum (prerequisites incl. Foundry install, step-by-step, manual mode, troubleshooting)
- [WARP-SOLANA.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-SOLANA.md) — Solana sealevel (Agave/Rust setup, the atomic-init deploy flow, costs, troubleshooting)
- [WARP-UI-PR.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-UI-PR.md) — make your route appear in the bridge UI
- **Live examples** (audit-grade, per chain): [WARP-LUNC.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-LUNC.md) · [WARP-USTC.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-USTC.md)

## 5. Changing ISM / IGP — who can change what

The security model in one paragraph:

> **On the synthetics (BSC, Ethereum, Solana): only the validators' multisig
> account can change the ISM or the IGP** of a warp route. **On Terra Classic:
> changes go through on-chain governance** (community proposal + vote). No
> single operator — including the deployer — is meant to hold these controls.

Per-chain mechanics:

| Chain | ISM | IGP / gas prices |
|---|---|---|
| **BSC / Ethereum** | EVM multisig ISMs are **static** contracts — a validator-set change means deploying a new ISM and repointing the warp (`setInterchainSecurityModule`), authorized by the multisig | prices governed by the oracle-agent quorum (§3); the IGP contract itself is repointed only by the multisig |
| **Solana** | the MultisigISM is **mutable** — the validator set/threshold is updated in place by the authorized account | same governed-price model; `set-interchain-security-module` / `igp set` authorized by the warp owner (multisig) |
| **Terra Classic** | ISM routing + per-domain multisig ISMs changed via **governance proposal** | IGP oracle updated via governance (`update-igp-oracle.sh` has a governance mode that only generates the proposal JSON) |

References:

- **Current validator sets & rotation procedure:** [ISM-VALIDATORS.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/ISM-VALIDATORS.md)
- **TC-side governance flow** (proposals, exec messages, verification): [deployment record §Configuration-via-Governance](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/HYPERLANE_DEPLOYMENT-MAINNET_EN.md)
- **Vault/governor operations:** [CONTRACT-OPERATION.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/CONTRACT-OPERATION.md)

## 6. Audit: deployment records & hashes

Everything deployed is verifiable byte-for-byte against the chains:

- **Core deployment record** (TC code_ids + `data_hash`, instantiation,
  governance config, mailbox wiring, ISM validator sets):
  [HYPERLANE_DEPLOYMENT-MAINNET_EN.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/HYPERLANE_DEPLOYMENT-MAINNET_EN.md)
- **Live contract inventory with hashes** (TC core + every warp/ISM/IGP/hook on
  BSC · ETH · Solana, with the verify commands):
  [DEPLOY-HASHES.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/DEPLOY-HASHES.md)
- **Per-route audit references:** [WARP-LUNC.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-LUNC.md) · [WARP-USTC.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-USTC.md)
- **Vault & governor contracts audit:** [proof-of-delivery AUDIT.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/install/AUDIT.md)

## 7. Live infrastructure

| What | Where |
|---|---|
| Bridge UI (transfer LUNC/USTC) | https://terraclassic-bridge.xyz |
| Message explorer | [hyperlane-explorer](https://github.com/terra-classic-hyperlane/hyperlane-explorer) |
| Registry the UI reads | [hyperlane-registry, branch `terra-classic-warp`](https://github.com/terra-classic-hyperlane/hyperlane-registry/tree/terra-classic-warp/deployments/warp_routes) |
| Official Hyperlane registry | `columbus-5` canonical since [PR #1559](https://github.com/hyperlane-xyz/hyperlane-registry/pull/1559) (2026-08-20) |

## Repositories

| Repo | Purpose |
|---|---|
| [cw-hyperlane](https://github.com/terra-classic-hyperlane/cw-hyperlane) | Core contracts on Terra Classic + warp route scripts, docs and deployment records |
| [hyperlane-validator](https://github.com/terra-classic-hyperlane/hyperlane-validator) | Validator & relayer installation (Docker / VPS) |
| [proof-of-delivery](https://github.com/terra-classic-hyperlane/proof-of-delivery) | Relayer-reward vault, oracle-agent (governed gas prices), claim agents, operator guides |
| [hyperlane-registry](https://github.com/terra-classic-hyperlane/hyperlane-registry) | Registry fork — branch `terra-classic-warp` feeds the bridge UI |
| [hyperlane-explorer](https://github.com/terra-classic-hyperlane/hyperlane-explorer) | Cross-chain message explorer |
| [docs](https://github.com/terra-classic-hyperlane/docs) | This hub |
