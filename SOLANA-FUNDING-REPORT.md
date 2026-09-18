# Solana Deployment — Community Funding Accountability Report

**Governance proposal #12222** · *Hyperlane Warp Routes - Solana Mainnet Deployment
Funding (LUNC/USTC/CW20)* · Community Pool spend of **9,873,590 LUNC**

> **Final report — 2026-09-18.** Every figure below was read directly from the
> Terra Classic and Solana chains (transaction hashes and account balances are
> linked so anyone can re-verify). It supersedes the interim
> [MAINNET-DEPLOY-COST-REPORT.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/archive/MAINNET-DEPLOY-COST-REPORT.md)
> of July 2026, which was written before the production LUNC/USTC routes existed.

## Summary

| | |
|---|---|
| Community Pool spend approved | **9,873,590 LUNC** (proposal #12222, passed 2026-07-01) |
| Converted to | **585.894783 USDC** on Terra Classic → **585.702903 USDC** on Solana → **7.449271196 SOL** (net credited **7.449181881 SOL**) — all on 2026-07-02 |
| What the community SOL paid for | the four items of the proposal — **IGP** 1.622 SOL, **ISM** 1.134 SOL, **Warp LUNC** 2.285 SOL, **Warp USTC** 2.285 SOL — plus the test/failed deploys needed to get them live (0.151 SOL) = **7.478 SOL** |
| Leftover to return | **none** — the community SOL was consumed in full by the proposal items; the developer covered the missing 0.029 SOL |
| Additional infrastructure paid by the developer (not the community) | the **relayer-reward vault program on Solana** (2.153 SOL), relayer gas top-ups (0.142 SOL net), agent transaction fees (0.046 SOL) — **≈ 2.38 SOL from the developer's own funds** |
| Payer wallet balance today | **0.024428093 SOL** (`BirXd4Q…DEf1j`) |
| Recoverable rent locked in live programs | **8.885755440 SOL** (closable by the upgrade authority if the infra is ever torn down) |

The proposal budgeted **9.08 SOL** (priced at $80/SOL). Between the proposal date
(2026-06-15) and the payout (2026-07-01) the LUNC price fell, so the 9,873,590 LUNC
bought **7.449 SOL** (82 % of the SOL budget). The shortfall, and everything outside the
proposal's scope, was funded by the deploy developer as shown in §5.

---

## 1. The governance proposal

| Field | Value |
|---|---|
| Proposal id | **12222** on `columbus-5` — [LCD](https://lcd.terra-classic.hexxagon.io/cosmos/gov/v1/proposals/12222) · [finder](https://finder.terraclassic.community/mainnet/proposal/12222) · [station](https://station.terraclassic.community/proposal/columbus-5/12222) |
| Title | Hyperlane Warp Routes - Solana Mainnet Deployment Funding (LUNC/USTC/CW20) |
| Type | `MsgCommunityPoolSpend` — **9,873,590,000,000 uluna** (9,873,590 LUNC) to `terra1run9wz09uhh6pu7ggcwwetrgye4wu7wn26mawp` |
| Proposer | `terra1run9wz09uhh6pu7ggcwwetrgye4wu7wn26mawp` (deploy developer) |
| Submitted / voting | submitted 2026-06-15 17:46 UTC · voting 2026-06-24 → **2026-07-01 23:55 UTC** |
| Result | **PASSED** — yes 307.43 B · no 174.90 B · abstain 128.85 B · veto 4.23 B (LUNC voting power; 63.2 % yes excluding abstain) |
| Proposal text | [funding-proposal.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/archive/funding-proposal.md) · [forum thread](https://discourse.luncgoblins.com/t/funding-proposal-hyperlane-warp-routes-deployment-on-solana-mainnet-v-2/503) |
| Scope promised | ISM program, Warp LUNC, Warp USTC, IGP program, oracle/PDA accounts — 9.08 SOL incl. buffer and contingency |

The Community Pool payout is executed by the chain at the end of the voting period
(it is not a transaction). The 9,873,590 LUNC were credited to the recipient wallet when
voting closed (2026-07-01 23:55 UTC) and converted about 3 hours later.

## 2. LUNC → SOL conversion trail (2026-07-02)

All four steps happened within **8 minutes** on 2026-07-02, as promised in the proposal
("converted to SOL immediately upon approval"):

| # | Where | Operation | In | Out | Time (UTC) | Tx |
|---|---|---|---|---|---|---|
| 1 | Terra Classic | LUNC → USDC swap, **two legs of 4,936,795 LUNC** in one tx (TerraSwap router + pair) | **9,873,590 LUNC** | 293.010052 + 292.884731 = **585.894783 USDC** | 03:16:39 | [`FE10F019…D8236`](https://finder.terraclassic.community/mainnet/tx/FE10F019AABE5E4F67EB5E09AD29386E6F7B85E2D78AAA5B22B4E229951D8236) |
| 2 | Terra Classic → Noble | IBC transfer (`channel-113`) | 585.902200 USDC (incl. 0.007417 USDC already in the wallet) | 585.902200 USDC on Noble | 03:19:15 | [`11AD2400…563ED`](https://finder.terraclassic.community/mainnet/tx/11AD2400D72C5960D51A0F92948996B64C5DE9095161FFE342ABD5A90E8563ED) |
| 3 | Noble → Solana | USDC via CCTP (Range) | 585.902200 USDC | **585.702903 USDC** (bridge fee 0.199297) | ~03:2x | [range.org](https://usdc.range.org/transactions?sc=INTERCHAIN&s=noble1act45umsc0nwj570qfe8zumarwws5jz9ml2tdl) |
| 4 | Solana | USDC → SOL swap (DEX aggregator; 4.978474 USDC platform commission) | 585.702903 USDC | **7.449271196 SOL** | 03:24:02 | [`44jqir…oooYQwR`](https://solscan.io/tx/44jqirx58q6t7Ey81b5h1WQQPNgvqrVw4Amnp8QkhRopD3DL4tbn7cvC84t9kdA7MVrGqJAAMecyojHQvoooYQwR) |

Terra-side fees: 34.560602 LUNC (swap tx) + 4.265491 LUNC (IBC tx), paid by the wallet.
Effective rates: **$0.0000593 per LUNC** · **78.6255 USDC per SOL**. The wallet's SOL
balance went from **2.102883914 → 9.552065795 SOL** in step 4 (net credit
**7.449181881 SOL** after the 0.000089 SOL of tx fee/account costs).

> The July interim report described step 1 as "≈ 4,936,795 LUNC". That was the size of
> **one** of the two swap legs; the transaction swapped **both legs = 9,873,590 LUNC**,
> i.e. the whole Community Pool grant. Corrected here.

## 3. Wallets and separation of funds

| Role | Address | Owner |
|---|---|---|
| Recipient of the CP spend (Terra Classic) | `terra1run9wz09uhh6pu7ggcwwetrgye4wu7wn26mawp` | deploy developer (also the relayer wallet) |
| Noble hop | `noble1act45umsc0nwj570qfe8zumarwws5jz9ml2tdl` | deploy developer |
| **Solana payer / upgrade authority** | [`BirXd4QDxfq2vx9LGqgXXSgZrjT81rhoFGUbQRWDEf1j`](https://solscan.io/account/BirXd4QDxfq2vx9LGqgXXSgZrjT81rhoFGUbQRWDEf1j) | deploy developer |
| Relayer Solana signer (delivery gas) | `PbEo7Fn2eJ6LYa4B8YU4MexB6s1BEQquWKCM1cwwrkS` | relayer operator (= deploy developer) |

The community money is the **value** (7.449 SOL), routed through the developer's wallets.
The Solana payer wallet also held the developer's own SOL, so this report tracks the
two sources separately. Money that entered the payer wallet since the grant:

| Date (UTC) | Amount (SOL) | Source | Classification |
|---|---|---|---|
| before 2026-07-02 03:24 | **2.102883914** (balance) | developer's funds from June testing | developer |
| 2026-07-02 03:24 | **+7.449181881** | step 4 above | **community** |
| 2026-08-29 04:49 | +0.182027880 | transfer from an exchange hot wallet ([`3aD3Mm…dXZZT`](https://solscan.io/tx/3aD3Mmx62yvaPDvgQBRtH6oQvcNx6aLGeJRWSK4tLK6mh3tFbpjdWCcgxfXPCUnqPSQVjb2K2xUCwo5qHARdXZZT)) | developer (the community LUNC had already been converted in full on 2026-07-02) |
| 2026-08-29 05:13 | +0.457863580 | same source ([`2kxwtt…9Kgiu`](https://solscan.io/tx/2kxwttpTNziniXLvadWx41SCFdoGPyH63u1WnFSAnUsXztcAiTAkNqt9r3h8wHucVTsMMBWT4mBUQpZKv1T9Kgiu)) | developer |
| 2026-09-18 09:46 | +0.019000000 | returned from the relayer signer | relayer operator |
| **Total available** | **10.210957255** | | |

## 4. What the SOL paid for — item by item

Rent = the rent-exempt deposit locked inside on-chain accounts (recoverable when the
account/program is closed). Fees = burned transaction/priority fees. All rents were
re-read from the chain on 2026-09-18 and match the deploy transactions.

### 4.1 Proposal scope — shared infrastructure (live)

| Item | Deployed | Accounts | Rent locked (SOL) | Fees (SOL) | **Cost (SOL)** |
|---|---|---|---|---|---|
| **IGP** program (`FLZuKRsfdovLqd8n1AYhPCwLqBjfFyZY3A2edgnjdJoR`) | 2026-07-03 17:38 | programdata `FGQB8B…4JBu` 1.614699120 · program 0.001141440 · program-data PDA `4H9xr4…xA1a` 0.001016160 · inner IGP `FPTvDs…mYKFk` 0.003459120 · overhead IGP `FXacR7…3RCJ` 0.001663440 | 1.621979280 | 0.000059305 | **1.622038585** |
| **ISM** multisig program (`4MzF7HCfxuwj4EFHqZSEpvkcZZvv1mF37DP4pDHwR5VQ`) | 2026-07-03 17:44 | programdata `4CFMLb…o8GJ` 1.123712880 · program 0.001141440 · access-control PDA `3v1B25…BE1r` 0.001134480 · domain-data PDA `7YypjZ…V1gJ` 0.008017920 | 1.134006720 | 0.000030000 | **1.134036720** |

Deploy txs: IGP [`59Bkyj…GyZV8`](https://solscan.io/tx/59Bkyjj5wPBdNWQcUfTFk7h7YdEJNeVoLsxWZfpDjyAbJFbetj933xhxYPpYMmw3xQHnuoUeW3JrodmVJJwGyZV8) (buffer) → [`4kXnQV…tRrvz`](https://solscan.io/tx/4kXnQVqepWLMAnQE8iniFNEHVDmshKSLgEmNEsbF79MWBD9ErSyLTG4op7jtYYY62qrAsJwBCoJ57DHUKFutRrvz) (finalize); a first IGP buffer of the same size was written and reclaimed the same day (net 0.000016 SOL). ISM [`kCFt8P…UU3aQ`](https://solscan.io/tx/kCFt8PmsTTsCsLqcypjh6A4TYAcZvXWbTHc2nX2gDrQpwNNiPEjge2ssdeNCWsxifqkKsnfbsHxyzr53NyUU3aQ) → [`5NUVMv…An8s1`](https://solscan.io/tx/5NUVMv28QhHfcUMdp9SzKK9dZdSoYJE3sMZehGgjCv3DCWADDMqUCG5FEHqyHTuL2JcAbXAHrSJZjhBijcGAn8s1).

### 4.2 Proposal scope — production warp routes (live since 2026-08-29)

| Item | Accounts | Rent locked (SOL) | Fees + IGP payment (SOL) | **Cost (SOL)** |
|---|---|---|---|---|
| **Warp LUNC** (`Dd3ajD8WbEyx7z3HqPnDyvUgFqEBzvF1VePjYd1NGnbr`) | programdata `EUaj56…E4wG` 2.221054320 · program 0.001141440 · mint `8dxTo5…sLFKG` 0.004029840 · token store `A4kSqq…DP2w3` 0.002582160 · ATA payer `G7VKP5…UZDyL` 0.050000000 · account-metas PDA `GHTpXW…uePdK` 0.000890880 · remote-router/gas PDAs 0.004113360 | 2.283812000 | 0.001651880 | **2.285463880** |
| **Warp USTC** (`7CUdBt1Qn2R2StE7MDPhQW2EhmnGg8zKK8oJXwAGEoyf`) | programdata `FakL3N…n8jf6` 2.221054320 · program 0.001141440 · mint `GNUbsF…9frjF` 0.004064640 · token store `5Qw5Pn…DEqej` 0.002582160 · ATA payer `2PJy1M…56WHF` 0.050000000 · account-metas PDA `ByVPdh…JpVTR` 0.000890880 · remote-router/gas PDAs 0.004113360 | 2.283846800 | 0.001652939 | **2.285499739** |

Deploy txs: LUNC [`59fk8f…kW32n`](https://solscan.io/tx/59fk8fKpETwEVmRSLm2dn88zuAPXBt1ezFjZnrnLqzZ5gqdBWvhBbgrb8m4nsCaNS7ycTmuicWpJ84vDTYxkW32n) (program) · [`VyGwdx…sbcgt`](https://solscan.io/tx/VyGwdxguKhHHbcUB1xvvgTKEpZ4Z2obdYPMgdL4eU5iMwMGsBTG47QhBVdksgxMehnyeGxMHyMiVfTooAQsbcgt) (atomic init + mint) · [`4Tk8Vs…oe8Qf`](https://solscan.io/tx/4Tk8VssWV8tXo85cgQ4pSe8Sc1uNSbUrAfmK5rMMA3nuN4Bcy7ztkzTDnkGe2MaMGtFJ24Z1QvhSgNHX8DDoe8Qf) (enroll TC router). USTC [`2jRAFq…x1WKj`](https://solscan.io/tx/2jRAFq6vNYpEimPvfBHC51TvsYpkyR8wQudEhQNKWTQw3YMJS1So295is9GVfAuKy3yMCbiAM5mVp9kPCWVx1WKj) (buffer) · [`WYpXYQ…1W8m9`](https://solscan.io/tx/WYpXYQ248Wm3BCP1yaEBVNH797Up9M7vRiE7FEyTDjSwXTpWztLD49QNurCtMRoJFmeCtQZ3hLsiFKTJfm1W8m9) (program) · [`jDxAwc…1RGsV`](https://solscan.io/tx/jDxAwckae7Vr8sqXRd5b6itnZdY5wyyfsgoTzQC8soYJhkBQ7KxuaMmXGWTB8bg5btJ8eW6cGAZb1rREGD1RGsV) (atomic init + mint) · [`5TxLTB…mdmyYF5`](https://solscan.io/tx/5TxLTBpa84vVXTmnz5iLQnhhnzUDqPQ5FsHDg8jBiMoPVo76GrD9m8uVbr4wfp1h92XwxJ2qiAKhDS58gmdmyYF5) (enroll). Routes on the Terra Classic side and the byte-for-byte program hashes are in
[DEPLOY-HASHES.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/install/DEPLOY-HASHES.md) §4.

### 4.3 Proposal scope — tests and failed attempts on the way to production

Solana programs cannot be "fixed in place" when the initialisation goes wrong: the
program is closed (rent reclaimed) and redeployed under a new id. Only the small PDAs
created by the failed init stay locked. These costs were necessary to reach the live
routes above and are charged to the community grant.

| Item | Dates | What happened | Net cost (SOL) |
|---|---|---|---|
| **IGORFAKE** end-to-end test warp (`EPJNrr…45zcL`) | deployed 2026-07-03 18:05 · closed 2026-08-29 05:03 ([`NuGCLM…yFujc`](https://solscan.io/tx/NuGCLMvKmhx4Kj2YGr6kknUEdXo77s91uv7FUTmYaoHPGkqoKZa4GQs2Q7n4YJj2aJp6zqFuhFyjprthY2yFujc)) | validated the full TC↔Solana flow on mainnet; 2.221049320 SOL reclaimed on close; mint/store/ATA-payer/router PDAs (0.071012240) stay orphaned | **0.073922240** |
| Two LUNC deploys that failed at init (`4QENiZ…dx27b`, `EQA88M…Dye4Lt`) | 2026-08-29 05:17 and 05:53 | the standard client's init failed (`IncorrectProgramId`); both programs closed, 2.221 SOL reclaimed each; 0.008024880 orphaned each | **0.017523912** |
| First complete LUNC route (`4SA1eK…pECmR`) | deployed 2026-08-29 13:24 · closed 15:11 ([`5A7vBe…4Lioh`](https://solscan.io/tx/5A7vBeRTArkvmNACMrgy9TMpPSDomvnxWwa6A7yUBVyRWXjhdFsVZdkDYqzXjbVuLqF4CpBfGkdrAJjKUPV4Lioh)) | deployed and wired, then closed to redo the route under `Dd3ajD…`; 2.221049320 reclaimed; mint `3NmtME…7kws`, store, ATA payer (0.058644320) orphaned | **0.059730489** |
| **Subtotal tests** | | | **0.151176641** |

### 4.4 Outside the proposal scope — paid from the developer's funds

| Item | Dates | Detail | Cost (SOL) |
|---|---|---|---|
| **Relayer-reward vault + governor program on Solana** (`2mQZcHYLFCXL1XnmmQdgCinYZW7yvuksqrdoHmNfZUFj`, the *proof-of-delivery* "pod" program) | 2026-08-18 → 2026-08-28 | programdata `5bcf2V…KrqB` 1.705234800 (initial 1.288 + three upgrades that extended it) · program 0.001141440 · pool PDA `Eq1mJG…Dwb9w` 0.008017920 + **0.300 SOL seed** · governor PDA `4sZAfq…naaA` 0.008017920 + **0.050 SOL seed** · operator/epoch/config PDAs 0.080763840 · fees 0.000175000. Four upgrade buffers (1.44–1.67 SOL each) were written and reclaimed the same day. | **2.153350920** |
| Relayer Solana signer top-ups (`PbEo7F…wwrkS`) | 2026-07-03, 08-20, 08-28 | 0.060675 + 0.050005 + 0.050005 = 0.160685 sent; 0.019 returned on 2026-09-18 | **0.141685000** |
| Agent transactions (epoch reporter, IGORFAKE/route config, ~8,300 small txs) and their fees | continuous | derived by reconciliation (§5); ≈ 0.000005 SOL each | **0.046072085** |
| Other activity of the developer (Wormhole transactions, 2026-07-09) | 2026-07-09 | unrelated to the bridge infra | **0.010554950** |
| Transfer to the developer's own account (swapped to 35.32 USDC) | 2026-09-13 ([`3UHfUr…Sk8qC`](https://solscan.io/tx/3UHfUrDPa55Vnk1gzsr9AfWfdVUvDEFBffUUFLfdGhjcjsnSPKqEsqoqdcAzAyCkLNCMULifv7DABPMphYnSk8qC)) | partial recovery of the developer's own contribution (§5) | **0.356650642** |

The vault program is what pays relayers and validators from the bridge fees
([VAULT.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/VAULT.md)).
It was not in proposal #12222, so it is **not charged to the community grant**.

## 5. Reconciliation — sources vs. uses

Everything the payer wallet received and spent between the grant (2026-07-02 03:24 UTC)
and 2026-09-18, closing exactly to the current balance:

| | SOL |
|---|---|
| Balance before the grant (developer) | 2.102883914 |
| Community grant (step 4) | 7.449181881 |
| Developer top-ups (2026-08-29) | 0.639891460 |
| Returned by the relayer signer (2026-09-18) | 0.019000000 |
| **Total sources** | **10.210957255** |
| IGP (§4.1) | −1.622038585 |
| ISM (§4.1) | −1.134036720 |
| Warp LUNC (§4.2) | −2.285463880 |
| Warp USTC (§4.2) | −2.285499739 |
| Tests / failed attempts (§4.3) | −0.151176641 |
| Vault + governor program (§4.4) | −2.153350920 |
| Relayer signer top-ups, net (§4.4) | −0.141685000 |
| Agent transactions and fees (§4.4) | −0.046072085 |
| Developer's other activity (§4.4) | −0.010554950 |
| Transfer to the developer (§4.4) | −0.356650642 |
| **Balance on 2026-09-18** | **0.024428093** ✓ |

### Community grant vs. developer's funds

| | SOL |
|---|---|
| **Community grant** | **7.449181881** |
| Proposal-scope items (IGP + ISM + LUNC + USTC + tests) | 7.478215565 |
| → covered by the developer | 0.029033684 |
| **Leftover from the grant to return** | **0.000000000** |
| | |
| **Developer's own funds in** (2.102883914 + 0.639891460 + 0.019) | 2.761775374 |
| Vault program + relayer gas + agent fees + other + shortfall above | 2.380696639 |
| Taken back by the developer (2026-09-13) + still in the wallet | 0.381078735 |
| **Net contribution of the developer to the live infrastructure** | **≈ 2.38 SOL** |

The proposal committed to return any leftover LUNC or SOL to the community. There is
none: the grant bought 7.449 SOL instead of the 9.08 SOL budgeted (LUNC price drop
between proposal and payout), and the four proposal items plus the test deploys cost
7.478 SOL. The relayer-reward vault on Solana, relayer gas and agent fees were paid
by the developer.

## 6. Recoverable vs. permanently locked

| | SOL | Note |
|---|---|---|
| Programdata rent of the 5 live programs (IGP 1.614699120 · ISM 1.123712880 · LUNC 2.221054320 · USTC 2.221054320 · vault 1.705234800) | **8.885755440** | recoverable with `solana program close` by the upgrade authority — only if the infra is ever decommissioned |
| Operational seeds in the vault (pool 0.30 · governor 0.05) | 0.350000000 | working capital of the reward system, paid out to operators over time |
| Small PDAs of the live programs (mints, token stores, ATA payers, IGP/ISM/vault accounts) | 0.241065280 | closable by their programs; in use |
| Orphaned PDAs of closed test programs (IGORFAKE 0.071012240 · `4SA1eK` 0.058644320 · two failed inits 0.016049760) | **0.145706320** | permanently locked |
| Burned fees (deploys 0.009039445 + agent txs ≈ 0.046) | ≈ 0.055 | non-recoverable |

## 7. State on 2026-09-18 and open items

| | |
|---|---|
| Payer wallet `BirXd4Q…DEf1j` | 0.024428093 SOL |
| Relayer signer `PbEo7F…wwrkS` | 0.099513262 SOL |
| Live programs | IGP `FLZuKR…`, ISM `4MzF7H…`, Warp LUNC `Dd3ajD…`, Warp USTC `7CUdBt…`, vault `2mQZcH…` — all `Authority: BirXd4Q…DEf1j` |
| Routes | LUNC and USTC live TC ↔ Solana both ways since 2026-08-29; UI at https://bridge.terra-classic.io |
| **Ownership handoff** | still the deployer key. The proposal and [TRANSFER-SOLANA-OWNERSHIP.md](https://github.com/terra-classic-hyperlane/cw-hyperlane/blob/main/terraclassic/doc/archive/TRANSFER-SOLANA-OWNERSHIP.md) commit to moving the upgrade authorities, IGP/ISM owners and warp owners to a validators' multisig — **pending** (tracked in hub §5) |

## 8. How to verify

```bash
# Governance proposal, tally and the CP spend message
curl -s https://lcd.terra-classic.hexxagon.io/cosmos/gov/v1/proposals/12222 | jq .proposal

# The LUNC → USDC swap (two legs of 4,936,795 LUNC) and the IBC transfer to Noble
curl -s https://terra-classic-lcd.publicnode.com/cosmos/tx/v1beta1/txs/FE10F019AABE5E4F67EB5E09AD29386E6F7B85E2D78AAA5B22B4E229951D8236 | jq '.tx.body.messages'
curl -s https://terra-classic-lcd.publicnode.com/cosmos/tx/v1beta1/txs/11AD2400D72C5960D51A0F92948996B64C5DE9095161FFE342ABD5A90E8563ED | jq '.tx.body.messages'

# Solana: rents of the live programs and the payer wallet balance
RPC=https://api.mainnet-beta.solana.com
for p in FLZuKRsfdovLqd8n1AYhPCwLqBjfFyZY3A2edgnjdJoR 4MzF7HCfxuwj4EFHqZSEpvkcZZvv1mF37DP4pDHwR5VQ \
         Dd3ajD8WbEyx7z3HqPnDyvUgFqEBzvF1VePjYd1NGnbr 7CUdBt1Qn2R2StE7MDPhQW2EhmnGg8zKK8oJXwAGEoyf \
         2mQZcHYLFCXL1XnmmQdgCinYZW7yvuksqrdoHmNfZUFj; do solana program show $p -u $RPC; done
solana balance BirXd4QDxfq2vx9LGqgXXSgZrjT81rhoFGUbQRWDEf1j -u $RPC

# Closed test programs (rent reclaimed)
solana program show EPJNrrpCeZGqDPoFtdV9u9uDWBNW3Xqh84LfM7345zcL -u $RPC   # "has been closed"
solana program show 4SA1eK3vp9Ez2HvTftyh5k1vL6zkXJyMe6UCaRipECmR -u $RPC   # "has been closed"
```

Every transaction of the payer wallet is public at
https://solscan.io/account/BirXd4QDxfq2vx9LGqgXXSgZrjT81rhoFGUbQRWDEf1j.

---

## Resumo em português

- A proposta **#12222** (aprovada em 01/07/2026) liberou **9.873.590 LUNC** do
  Community Pool. Em 02/07/2026 todo o LUNC foi convertido em **585,89 USDC** na Terra
  Classic → Noble → Solana, virando **7,449 SOL** (a proposta previa 9,08 SOL; a queda
  do LUNC entre a proposta e o pagamento reduziu o valor obtido).
- Os 7,449 SOL foram **integralmente** usados nos itens da proposta: **IGP** (1,622),
  **ISM** (1,134), **warp LUNC** (2,285), **warp USTC** (2,285) e os testes/tentativas
  necessários para colocá-los no ar (0,151) = **7,478 SOL**. A diferença de 0,029 SOL e
  tudo o que ficou fora da proposta — o programa do **cofre de recompensas do relayer**
  na Solana (2,153 SOL), o gás do relayer (0,142) e as taxas dos agentes (0,046) —
  foram pagos com recursos próprios do desenvolvedor (**≈ 2,38 SOL líquidos**).
- **Não há sobra a devolver.** Saldo atual da carteira pagadora: **0,024 SOL**.
- **8,886 SOL** de rent continuam recuperáveis (programas ao vivo) se a infraestrutura
  um dia for desativada. As rotas LUNC e USTC estão no ar desde 29/08/2026.
- **Pendente:** transferir a autoridade dos programas (hoje na chave do deployer) para o
  multisig dos validadores.
