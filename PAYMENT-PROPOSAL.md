<div align="center">

# Hyperlane on Terra Classic — Delivery Report & Payment Proposal

**Community Pool spend of 245,000,427.67 LUNC** for the completed integration approved in
[proposal #12200](https://finder.terraclassic.community/mainnet/proposal/12200)

*Terra Classic (`columbus-5`, Hyperlane domain 132556) ⇄ Ethereum · BNB Smart Chain · Solana*

Author: **Igor Veras** ([@igorv43](https://github.com/igorv43)) · KYC: [SolidProof certificate](https://github.com/solidproof/Projects/blob/main/2026/Igor%20Soares/KYC_Certificate_Igor_Soares.jpg) · October 2026

</div>

---

## Cover — the documents behind this proposal

Every claim below can be checked on-chain or in a public repository. This page is the cover; the
documents it summarises are:

| # | Document | What it proves |
|---|---|---|
| 1 | [Original proposal (Discourse)](https://discourse.luncgoblins.com/t/new-proposal-hyperlane-integration-on-terra-classic-multichain-connectivity-with-ethereum-bsc-and-solana/243) → on-chain [#12200](https://finder.terraclassic.community/mainnet/proposal/12200) (passed 2025-11-17) | scope, budget (**USD 12,000**) and the condition "payment only after full production deployment, verification and KYC" |
| 2 | [HYPERLANE_DEPLOYMENT-MAINNET_EN.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/HYPERLANE_DEPLOYMENT-MAINNET_EN.md) | Terra Classic core deployment record: code IDs, `data_hash`, instantiation, governance configuration |
| 3 | [GOVERNANCE-PROPOSAL-CLAIM-OWNERSHIP-AUDIT.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/GOVERNANCE-PROPOSAL-CLAIM-OWNERSHIP-AUDIT.md) → on-chain [#12229](https://finder.terraclassic.community/mainnet/proposal/12229) (**passed** 2026-10-06) | `owner` of the Hyperlane infrastructure handed to on-chain governance |
| 4 | [GOVERNANCE-PROPOSAL-MIGRATE-CONTRACTS-AUDIT.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/GOVERNANCE-PROPOSAL-MIGRATE-CONTRACTS-AUDIT.md) → on-chain [#12230](https://finder.terraclassic.community/mainnet/proposal/12230) (**passed** 2026-10-08) | every migratable contract moved to audited code with the multisig-ISM duplicate-signature fix (upstream #142) |
| 5 | [DEPLOY-HASHES.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/DEPLOY-HASHES.md) · [WARP-LUNC.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-LUNC.md) · [WARP-USTC.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/WARP-USTC.md) | byte-level inventory of every contract on all four chains, with verify commands |
| 6 | [SOLANA-FUNDING-REPORT.md](https://github.com/terra-classic-hyperlane/docs/blob/main/SOLANA-FUNDING-REPORT.md) (proposal [#12222](https://finder.terraclassic.community/mainnet/proposal/12222)) | accountability for the 9,873,590 LUNC spent on Solana rent — every transaction, nothing to return |
| 7 | [Documentation hub](https://github.com/terra-classic-hyperlane/docs/blob/main/README.md) ([github.com/terra-classic-hyperlane/docs](https://github.com/terra-classic-hyperlane/docs)) | validator, relayer, warp-route, fee and audit guides |
| 8 | [Live bridge monitor](https://monitor.terraclassic-bridge.xyz/) ([JSON API](https://monitor.terraclassic-bridge.xyz/api/status)) | live validators, relayer, balances, IGP quotes and contract ownership |

---

## 1. Summary

The Hyperlane integration approved in #12200 is **complete and in production**:

- **Native LUNC and USTC** move between Terra Classic and **Ethereum, BNB Smart Chain and Solana**
  through Hyperlane warp routes with real collateral locked on Terra Classic.
- The Terra Classic infrastructure is **owned and administered by on-chain governance** — not by the
  developer (proposals #12229 and #12230, both passed).
- The synthetic side is controlled by **4-of-6 multisigs of the bridge validators** (Safe on EVM,
  Squads on Solana).
- Messages are signed by a **6-validator community set (threshold 4)** and relayed by an operator paid
  from an on-chain relayer-reward vault — no manual fees, no single point of control.
- The original proposal's payment condition — production deployment, public verification and KYC —
  is met. This proposal requests the agreed payment.

## 2. What was delivered

| Item of #12200 | Status | Where |
|---|---|---|
| Hyperlane core on Terra Classic: Mailbox, IGP, ValidatorAnnounce, ISMs, hooks | ✅ live, owner + admin = governance | §4.1 |
| Validators | ✅ 6 community validators, threshold 4 | §3 |
| Relayer for cross-chain delivery | ✅ running, paid by the relayer-reward vault ([proof-of-delivery](https://github.com/terra-classic-hyperlane/proof-of-delivery)) | [RELAYER-OPERATOR.md](https://github.com/terra-classic-hyperlane/docs/blob/main/RELAYER-OPERATOR.md) |
| Bridge contracts: LUNC and USTC to ETH, BSC, Solana | ✅ live | §4.2 |
| Warp UI customised for Terra Classic (CW20 balances, `transfer_from` approvals) | ✅ https://bridge.terra-classic.io (also https://terraclassic-bridge.xyz) | [UI](https://github.com/terra-classic-hyperlane/UI) |
| Complete documentation (install, validators, warp creation) | ✅ | [docs hub](https://github.com/terra-classic-hyperlane/docs/blob/main/README.md) |
| KYC via SolidProof | ✅ | [certificate](https://github.com/solidproof/Projects/blob/main/2026/Igor%20Soares/KYC_Certificate_Igor_Soares.jpg) |
| Multisig management of the bridge contracts | ✅ Safe 4-of-6 (EVM), Squads 4-of-6 (Solana) | §4.2 |

**Delivered beyond the original scope:**

- **Hyperlane explorer** adapted to Terra Classic: https://explorer.terraclassic-bridge.xyz ([repo](https://github.com/terra-classic-hyperlane/hyperlane-explorer)).
- **Bridge monitor** ([hyperlane-monitoring](https://github.com/terra-classic-hyperlane/hyperlane-monitoring)): validators and checkpoints, relayer deliveries per route, operator balances, IGP quotes, contract owners and admins on every chain — https://monitor.terraclassic-bridge.xyz.
- **Relayer-reward vault and governed gas oracle** (proof-of-delivery): users pay interchain gas on the origin chain, delivery proofs unlock the relayer's reward, and gas prices are approved by a quorum of validator operators before they are applied.
- **Terra Classic in the official Hyperlane registry**: `columbus-5` became canonical with [hyperlane-registry PR #1559](https://github.com/hyperlane-xyz/hyperlane-registry/pull/1559) (2026-08-20).
- **Security fix**: the multisig-ISM duplicate-signature issue found by community researcher **Fragwuerdig** was fixed on Terra Classic through #12230.
- **Token recognition**:
  - **Phantom** approved the LUNC and USTC Solana tokens.
  - LUNC and USTC are registered and recognised on **BscScan** and **Etherscan**.
  - Recognition on **Solscan** is in progress.

  The token pages are linked in §4.2.

## 3. Validators

The original proposal named four validators: Vegas Node, StrathCole, Highstakes.ch and LUNA Classic DAO.
**Vegas Node, StrathCole and LUNA Classic DAO later decided not to validate.** Highstakes.ch continues,
operating as **TCV**. The set was completed with new community validators and is now **6 validators,
threshold 4** (checkpoint signers for messages leaving Terra Classic):

| Validator | Checkpoint signer |
|---|---|
| Igor Veras | `0x71b2b8c36a0c76b74be92eb7915e26a69b3b03eb` |
| TCV (Highstakes.ch) | `0x1afd3d07abd2aaa19a9f7993f334a926e253b90c` |
| DarkSun | `0xe6bb040164a0ebbcb7e2d584f066c8b57dd74383` |
| BurnItAll | `0x5c374754892ebac52702475726b67f822efdfacc` |
| LuncGoblins | `0x0c737caf34a1b8ae4a285c5e94726de6d9b7e028` |
| bumeo | `0xa10f3648366fe14b2e6253a0aebb9103512fa808` |

All six are synced: signed index 100, lag 0. Live status: https://monitor.terraclassic-bridge.xyz.
Messages arriving on Terra Classic are verified against Hyperlane's own validator sets for each origin
chain: BSC 4-of-6, Ethereum 6-of-9 and Solana 3-of-5.

## 4. Contracts

### 4.1 Terra Classic — all owned and administered by governance

**Governance module account:** `terra10d07y265gmmuvt4z0w9aw880jnsr700juxf95n`

- **`owner`:** claimed by governance in **#12229**.
- **`admin`** (migration authority): transferred to governance on 2026-09-29/30.
- **Code:** every migratable contract was moved to audited code in **#12230**.

All values below were read on-chain on 2026-10-08.

| Contract | Address | Code ID | Owner | Admin |
|---|---|---|---|---|
| Mailbox | `terra1fwg35n5esjgny7d8pxnz8usjpwsvpguk0txsy6cnqxy58x9fdlksjpx3p9` | 11687 | governance | governance |
| Validator Announce | `terra1gtnmdevekgxpvzej3wfy20e2n335gm3muwj6geduxxa86j3x70cq00asmy` | 11688 | — (not ownable) | governance |
| ISM Routing (default ISM) | `terra1uhzzvt9x3u8hjnkp695hklexx2uywjvfqv454d93ds92sgtpwk7qrpxdg0` | 11692 | governance | governance |
| ISM Multisig — Ethereum (domain 1) | `terra187rzjc3dznfxqtqqrwh796e5q4khmvp5av8mka6zhp98zjfk2z2qneldar` | 11690 | governance | governance |
| ISM Multisig — BSC (domain 56) | `terra1nqj7qlnt2sty0dgnu3ss5z4u6wr7hjfea7cn6wpwjt2uymts8ucsmuj9xw` | 11690 | governance | governance |
| ISM Multisig — Solana (domain 1399811149) | `terra10s3p36tjek8amhlc4krxpzln6g8n0qy9jq82wyda434l3rv89wfsucl50t` | 11690 | governance | governance |
| Hook Aggregate — default (Merkle + IGP) | `terra1026v947k2jn58t09ppw003xujj92vp3lxv0fg3xk8ccz42r8d2sqvnmvel` | 11694 | governance | governance |
| Hook Aggregate — required (Pausable + Fee) | `terra1xmdd7yhu3qdlfhrcku8srfvtday6efymj54gqz0daxsmn8pvqygq0nxq04` | 11694 | governance | governance |
| Hook Merkle | `terra183lq6yqp8km3p34cxgk6k3u78uy4plqahey6rne7n9gy98delr9qyp0n2p` | 11696 | — (not ownable) | governance |
| Hook Pausable | `terra1x8s9qtw9355pfckywkns4e8f9zyfjaf8w5e5s8vh28ph5gzwwlks9tjcnf` | 11697 | governance | governance |
| Hook Fee (0.283215 LUNC/msg) | `terra1sud5xyknr93wmxem6kxdfd0vxcju47wuh7zdm5uecavrm36w669sp7j8ag` | 11695 | governance | governance |
| IGP | `terra1taunhg629rssf3g939nqr0h594q5mssrzdj5lkx2hygmxmh72ghqeqqnvz` | 11693 | governance | governance |
| IGP Oracle | `terra1j8xzgzk7vds5uzrplmnln4vcz6f205t9atdyflypzrr43cd5eh7scwqj0d` | 11704 | oracle-governor `terra1z7jmlky2cmsd9aslm4uxrsase2yjwz8k9rlk00ga8s7pxgljczjq9sv4hj` (validator-operator quorum) | governance |
| Warp **LUNC** (native collateral) | `terra1m7jcqxfn4hd7q4sywhw508nxshaf078c4vh83y0ts43y9tlp9dcs50cggy` | 11390 | governance | none — immutable |
| Warp **USTC** (native collateral) | `terra1qu3x6vhk4y6w6erhmedzfp2ug53qm5nwpyarxveqa7tvwg0telxqvd3ccf` | 11390 | governance | none — immutable |

The two warp contracts have no admin at all. CosmWasm cannot assign an admin once it is empty, so
**nobody can ever migrate them**. Their owner is governance.

### 4.2 Ethereum, BNB Smart Chain and Solana — IGP, ISM and LUNC/USTC warp routes

**Multisigs:**

| Chain | Multisig |
|---|---|
| EVM | Safe `0x4d78A2182a7Cd3a370D73E6651EF4B32C2dd8BDb`, 4-of-6, same address on BSC and Ethereum |
| Solana | Squads vault `UyvAB4vzpbzUfSQP4uStLPz2Td1coSJcosCRGV4vHmr`, 4-of-6 |

**Ethereum (domain 1):**

| Contract | Address | Controlled by |
|---|---|---|
| Warp **LUNC** (HypERC20) | [`0xA4bc47a4C5461eB0E59A585a21A1222EF7544Ac6`](https://etherscan.io/token/0xA4bc47a4C5461eB0E59A585a21A1222EF7544Ac6) | owner Safe · ProxyAdmin owned by Safe |
| Warp **USTC** (HypERC20) | [`0xf49408beb319aeCe3E8B3550a5C750C19b3F1e51`](https://etherscan.io/token/0xf49408beb319aeCe3E8B3550a5C750C19b3F1e51) | owner Safe · ProxyAdmin owned by Safe |
| ISM (4-of-6 multisig) | `0x3ba17675f0D319C89D70722f6eb07790DF0B254B` | owner Safe |
| IGP | `0x69b3A7C507014fd6E87E7b58a6b037e0EEe0e096` | owner Safe · fees go to the relayer-reward vault `0x04096dCBbBB0FA58a312761c38E1d3B9F64631F1` |
| Warp hook (Merkle + IGP) | `0xDC9FF1B50d04792bf7730032F1763501D5669420` | immutable (no owner) |
| Gas oracle | `0x3987cCE8f08037EBF93Ef3a934753540A94196cE` | oracle governor (validator-operator quorum) |

**BNB Smart Chain (domain 56):**

| Contract | Address | Controlled by |
|---|---|---|
| Warp **LUNC** (HypERC20) | [`0x481095ecEd7A907e7f390b6226F53a66D379e6e2`](https://bscscan.com/token/0x481095ecEd7A907e7f390b6226F53a66D379e6e2) | owner Safe · ProxyAdmin owned by Safe |
| Warp **USTC** (HypERC20) | [`0xfC067fd98FD123fC2cAd72d040AF60a523274339`](https://bscscan.com/token/0xfC067fd98FD123fC2cAd72d040AF60a523274339) | owner Safe · ProxyAdmin owned by Safe |
| ISM (4-of-6 multisig) | `0xF6b0cDD33A7d2895a3F18b85569Ed9A8278cD151` | owner Safe |
| IGP | `0xc3593dD54274A4CDa8fEBDa343A63A7331154138` | owner Safe · fees go to the relayer-reward vault `0x34E06a7793877EC5251b1dC230aD7cD577d231f4` |
| Warp hook (Merkle + IGP) | `0x4AE5fd735Fe1a987756366F7FFeE754C061839d4` | immutable (no owner) |
| Gas oracle | `0x7dE950f8F0a037783989a6BE84B3620916552306` | oracle governor (validator-operator quorum) |

**Solana (domain 1399811149).** Every program's upgrade authority is the Squads vault (read on-chain
on 2026-10-08).

| Contract | Address | Controlled by |
|---|---|---|
| Warp **LUNC** program | `Dd3ajD8WbEyx7z3HqPnDyvUgFqEBzvF1VePjYd1NGnbr` — mint [`8dxTo5reLtvRDx3Q8WEP33Uj2C5u6372EygJdNbsLFKG`](https://solscan.io/token/8dxTo5reLtvRDx3Q8WEP33Uj2C5u6372EygJdNbsLFKG) | owner + upgrade authority Squads |
| Warp **USTC** program | `7CUdBt1Qn2R2StE7MDPhQW2EhmnGg8zKK8oJXwAGEoyf` — mint [`GNUbsF5mrurtDzNc65HipN5Fyzzzqbj5UonLNhj9frjF`](https://solscan.io/token/GNUbsF5mrurtDzNc65HipN5Fyzzzqbj5UonLNhj9frjF) | owner + upgrade authority Squads |
| ISM program (4-of-6 multisig) | `4MzF7HCfxuwj4EFHqZSEpvkcZZvv1mF37DP4pDHwR5VQ` | upgrade authority Squads |
| IGP program | `FLZuKRsfdovLqd8n1AYhPCwLqBjfFyZY3A2edgnjdJoR` | upgrade authority Squads |
| Overhead IGP account | `FXacR73HiuNyvW7x34KYCDyv8XxM86pz31Ap8t2v3RCJ` | owner Squads |
| IGP account | `FPTvDsowMHXFKktoLgy2a2qfr5yL6846JHKwvk2mYKFk` | owner: oracle-governor PDA `4sZAfqDqEmR7LMWjrdNmoEkv8S6BDdnDkh5mfADenaaA` · fees to pool PDA `Eq1mJGTSbLb8s6gfoyg5aovxFAhXpnVudXXSAmbDwb9w` |

The Mailbox and ValidatorAnnounce on BSC, Ethereum and Solana are **Hyperlane's canonical deployments**,
operated by Hyperlane, not by this project.

## 5. Open source, open to the community

Everything lives in the [terra-classic-hyperlane](https://github.com/terra-classic-hyperlane) organisation:

| Repository | Purpose |
|---|---|
| [cw-hyperlane](https://github.com/terra-classic-hyperlane/cw-hyperlane) | Terra Classic core contracts, warp scripts, deployment records and governance audits |
| [UI](https://github.com/terra-classic-hyperlane/UI) | Bridge UI adapted to Terra Classic (https://bridge.terra-classic.io) |
| [hyperlane-explorer](https://github.com/terra-classic-hyperlane/hyperlane-explorer) | Message explorer (https://explorer.terraclassic-bridge.xyz) |
| [hyperlane-monitoring](https://github.com/terra-classic-hyperlane/hyperlane-monitoring) | Live monitor of validators, relayer, balances, IGP and ownership (https://monitor.terraclassic-bridge.xyz) |
| [proof-of-delivery](https://github.com/terra-classic-hyperlane/proof-of-delivery) | Relayer-reward vault, governed gas oracle, claim agents |
| [hyperlane-validator](https://github.com/terra-classic-hyperlane/hyperlane-validator) | Validator and relayer installation guides (Docker / VPS) |
| [hyperlane-registry](https://github.com/terra-classic-hyperlane/hyperlane-registry) | Registry fork that feeds the bridge UI |
| [docs](https://github.com/terra-classic-hyperlane/docs) | Documentation hub, funding report and this proposal |

**Bringing in more maintainers.** Today the organisation has two members:

- [@igorv43](https://github.com/igorv43), owner;
- [@fragwuerdig](https://github.com/fragwuerdig) (Till Ziegler), member.

I invited six Terra Classic developers: @nghuyenthevinh2000, @inon-man, @TropicalDog17, @StrathCole,
@kien6034 and @hoank101. The invitations expired after 7 days without being accepted. I will invite them
again. If they still do not join, I will invite the bridge validators, so that the repositories are
maintained by more people than the original developer.

## 6. Payment requested

| | |
|---|---|
| Amount | **245,000,427.67 LUNC** (`245000427670000uluna`) |
| Source | Community Pool |
| Recipient | `terra14yvuxm40affmkt36m2ummvzvlka25u3ucurxjl` |
| Basis | the USD 12,000 budget approved in #12200 (USD 9,000 infrastructure + USD 3,000 Warp UI), converted at ≈ USD 0.0000490 per LUNC |

The payment covers only the scope approved in #12200. Solana deployment costs were funded separately
through #12222 and are fully accounted for in [SOLANA-FUNDING-REPORT.md](https://github.com/terra-classic-hyperlane/docs/blob/main/SOLANA-FUNDING-REPORT.md).
The explorer, the monitor, the reward vault, the registry listing and the security migration are
included at no extra cost.

## 7. Thank you

Thank you to the Terra Classic community for the trust you placed in this work. In particular:

- the voters who approved #12200, #12222, #12229 and #12230;
- the validators who agreed to run the bridge: TCV, DarkSun, BurnItAll, LuncGoblins and bumeo;
- Fragwuerdig, for the careful security review;
- everyone who tested the bridge and reported problems.

Terra Classic lost its bridges when Wormhole stopped supporting the chain. A bridge controlled by a
company can be switched off by that company. That is the importance of a **100% decentralised bridge**:

- the Terra Classic side belongs to on-chain governance;
- the synthetic side belongs to multisigs of community validators;
- messages are signed by an independent validator set;
- the relayer is paid by an on-chain vault, not by a person;
- every contract, configuration and line of code is public and verifiable.

No company and no single person — including me — can switch it off or take it over. The bridge now
belongs to the Terra Classic community.

— Igor Veras
