# Contact — bridge@terra-classic.io

> **Status: DRAFT (2026-09-21).** The address is being set up. The custodian
> table below is filled in once the four validators confirm and the public
> announcement is posted; this notice is removed at the same time.

> **Official contact address of the Terra Classic Hyperlane bridge:**
> **bridge@terra-classic.io**
>
> Terra Classic is a 100 % decentralized, community-governed blockchain. There is
> no company, foundation or legal entity behind it, and therefore no corporate
> mailbox. This address exists so that explorers, listing sites and other
> projects have one verifiable channel on the project's official domain. It is
> **not** controlled by any single person.

## How the address works

- `bridge@terra-classic.io` is a **forwarding address** on the official domain
  `terra-classic.io` (Cloudflare Email Routing). Nothing is stored in a central
  mailbox.
- Every message sent to it is delivered **simultaneously** to the custodians
  listed below — the validators of the bridge's **3-of-4 multisig ISM**, the same
  set that signs every cross-chain message.
- Replies are sent from the same address by any custodian (DKIM-signed for
  `terra-classic.io`, DMARC `p=reject`), so a reply from `bridge@terra-classic.io`
  can only originate from a custodian.

## Custodians

The custodians are the validators of the production ISM (3-of-4, identical on
BSC, Ethereum, Solana and Terra Classic — see
[ISM-VALIDATORS.md](https://github.com/terra-classic-hyperlane/proof-of-delivery/blob/main/docs/ISM-VALIDATORS.md)).

| # | Validator | Public identity | Validator address (ISM) | Receives bridge@ |
|---|---|---|---|---|
| 1 | _name_ | _X / GitHub / Telegram_ | `0x…` | ✅ |
| 2 | _name_ | _X / GitHub / Telegram_ | `0x…` | ✅ |
| 3 | _name_ | _X / GitHub / Telegram_ | `0x…` | ✅ |
| 4 | _name_ | _X / GitHub / Telegram_ | `0x…` | ✅ |

Announced publicly on _YYYY-MM-DD_: _link to the Discord/Telegram announcement_.

## Rules

1. **Custodians = ISM validators.** When the validator set of the ISM changes
   (rotation documented in ISM-VALIDATORS.md), the recipient list of
   `bridge@terra-classic.io` is updated to match, and this file is updated in the
   same change.
2. **Every change is public.** Adding or removing a recipient is announced in the
   community channels and recorded here (git history is the audit trail).
3. **Cloudflare access is shared.** At least two custodians are members of the
   Cloudflare account of `terra-classic.io` with the role needed to manage Email
   Routing, so the address does not depend on one login.
4. **Scope.** The address is for: explorer and listing-site verifications
   (Etherscan, BscScan, Solscan, CoinMarketCap, CoinGecko, registries), security
   disclosures about the bridge, and contact from other projects/integrators.
   It is **not** a support desk — user support happens in the public channels
   below.
5. **No secrets by email.** Custodians never send private keys, seed phrases or
   signed authorizations by email. Anything that changes the bridge (ISM, IGP,
   routes, ownership) goes through the multisig or on-chain governance, never
   through this mailbox.

## Known limitation

DNS for `terra-classic.io` is managed in a Cloudflare account, and whoever
administers that account can change the forwarding. This cannot be tied to the
on-chain multisig today. The mitigations are rule 3 (shared account access) and
rule 2 (every change is public and reviewable here).

## Public channels

| Channel | Link |
|---|---|
| Website (official, listed on CoinMarketCap / CoinGecko) | https://terra-classic.io |
| Bridge UI | https://bridge.terra-classic.io |
| Telegram | https://t.me/classicluna |
| Discord | https://discord.gg/2bnBrnrUEG |
| GitHub | https://github.com/terra-classic-hyperlane |
| Governance (proposals 12200 and 12222) | https://finder.terraclassic.community/mainnet/proposal/12200 · https://finder.terraclassic.community/mainnet/proposal/12222 |
| Bridge maintainer | Igor Soares Veras — [GitHub](https://github.com/igorv43) · [X](https://x.com/igorsoares62) · [KYC (SolidProof)](https://github.com/solidproof/Projects/blob/main/2026/Igor%20Soares/KYC_Certificate_Igor_Soares.jpg) |

## How to verify

```bash
# The address lives on the official domain (Cloudflare Email Routing)
dig +short MX terra-classic.io
dig +short TXT terra-classic.io          # SPF
dig +short TXT _dmarc.terra-classic.io  # DMARC p=reject

# The custodians are the current ISM validators
# (compare the table above with the on-chain validator set — commands in ISM-VALIDATORS.md)
```
