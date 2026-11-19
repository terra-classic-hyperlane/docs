# Proposal: Claim ownership of the WBTC, WETH and PAXG warp routes for governance

**Type:** on-chain governance proposal (3 × `MsgExecuteContract`, executed by the x/gov module account)
**Proposer:** Igor Veras (Terra Classic Hyperlane bridge operator)
**Precedent:** proposal #12229, which handed the Hyperlane mailbox, ISMs, hooks, IGP and the LUNC/USTC routes to governance

## Summary

This proposal completes the handoff of the three Hyperlane warp routers on Terra Classic for **WBTC, WETH and PAXG** (Ethereum ↔ Terra Classic) to the chain's own governance. It is the second and final step of the standard two-step `hpl_ownable` transfer: the current owner has already proposed governance as the next owner; this proposal makes governance accept it (`claim_ownership`).

After execution, these three contracts belong to the Terra Classic community, exactly like the LUNC and USTC routes already do.

## Why

- **These are third-party assets.** WBTC, WETH and PAXG are not tokens issued by Terra Classic builders. The bridge contracts that bring them to Terra Classic should belong to the community, through governance, rather than to any single operator or individual.
- **No single point of control.** A warp router's owner decides which ISM it trusts (that is, which validators are allowed to approve incoming transfers), which hook it uses and which remote routers are enrolled. Under governance, each of those changes requires a community vote. Under a single wallet, it requires one signature.
- **Consistency.** The mailbox, the default ISM, the hooks, the IGP and the LUNC/USTC routes are already governance-owned (#12229). Leaving three routes outside that model would be the exception, not the rule.
- **Security for holders.** For anyone holding WBTC, WETH or PAXG on Terra Classic, governance ownership of the router is the strongest on-chain guarantee available that the rules of the bridge cannot be changed quietly.

## Contracts in scope (code `hpl_warp_cw20`, domain 132556)

| Token | Router on Terra Classic |
|---|---|
| WBTC | `terra1gepfs6d5kp6uvpq3w8s65n3fz77tuceze962wel50tznenq49ckssgt4s7` |
| WETH | `terra14nna7hca7t9h7u39gumlplw92j7syavull70ju0haz80akqcsxsqp5s2kr` |
| PAXG | `terra1k099akkvt99hr8f633ywecwmk4c2etcgg9y8lead24qxseq97mnspxzlyq` |

New owner: `terra10d07y265gmmuvt4z0w9aw880jnsr700juxf95n`, the Terra Classic **x/gov module account** (the same recipient as in #12229).

## Current state (already done, verifiable now)

| Field | Value |
|---|---|
| `owner` | `terra1s0a2lyhcl44yg63epx5x0n5qqdwjtg93cfs8me` (current operator key) |
| `pending_owner` | `terra10d07y265gmmuvt4z0w9aw880jnsr700juxf95n` (governance), via `init_ownership_transfer` |
| contract admin (migrations) | `terra10d07y265gmmuvt4z0w9aw880jnsr700juxf95n` (governance) |
| ISM | `terra1uhzzvt9x3u8hjnkp695hklexx2uywjvfqv454d93ds92sgtpwk7qrpxdg0` (the governance-owned routing ISM, same as LUNC/USTC) |

On the Ethereum side, the three collateral routers are owned by the validators' Safe multisig (`0x4d78A2182a7Cd3a370D73E6651EF4B32C2dd8BDb`, 4 of 6).

## What the proposal does

Three messages, one per router, all identical in shape:

```json
{
  "@type": "/cosmwasm.wasm.v1.MsgExecuteContract",
  "sender": "terra10d07y265gmmuvt4z0w9aw880jnsr700juxf95n",
  "contract": "<router>",
  "msg": { "ownable": { "claim_ownership": {} } },
  "funds": []
}
```

**Nothing else changes.** No ISM, hook, enrolled route, token metadata or balance is touched. The proposal does not move funds and does not migrate code.

## How to verify before voting

Anyone can check the two facts this proposal depends on, for each router:

```bash
LCD=https://terra-classic-lcd.publicnode.com
for R in terra1gepfs6d5kp6uvpq3w8s65n3fz77tuceze962wel50tznenq49ckssgt4s7 \
         terra14nna7hca7t9h7u39gumlplw92j7syavull70ju0haz80akqcsxsqp5s2kr \
         terra1k099akkvt99hr8f633ywecwmk4c2etcgg9y8lead24qxseq97mnspxzlyq; do
  # pending owner must be the governance module account
  curl -s "$LCD/cosmwasm/wasm/v1/contract/$R/smart/$(echo -n '{"ownable":{"get_pending_owner":{}}}' | base64 -w0)"
  # admin must be the governance module account
  curl -s "$LCD/cosmwasm/wasm/v1/contract/$R" | grep -o '"admin":"[^"]*"'
done
```

Expected: `pending_owner` = `terra10d07y265gmmuvt4z0w9aw880jnsr700juxf95n` and `"admin":"terra10d07y265gmmuvt4z0w9aw880jnsr700juxf95n"` for all three.

The `init_ownership_transfer` and admin transactions (2026-11-19):

| Router | `init_ownership_transfer` | admin → governance |
|---|---|---|
| WBTC | `B4A96B242C37D68DBF1700D303F247BBB6218B8070D3936888E5BE66041D90BF` | `47CEA916283F0CFE2773FE06CEC3EC634CE1AFF8D28DCB8A7EB4DA2B2B4A4F46` |
| WETH | `F4C87CE214C0EC6C2B1E3E5FF9F1C9675EC7BDD0559AA3DCD8642DD1B11D1425` | `FCAE7F3C462AA5038942B3A73107C18D114C625ACF7D7554FB98E9A75D85BE4F` |
| PAXG | `56CB0C88AC1170FF1F60B534A358259EEDEFB27CF486570FB29425AA9FED3B7C` | `4CAF3962FF803BD7563942DE6FB3521CC914090D6E8A16CAA556CCD6DACCD996` |

## After it passes

- Any future change to these routers (ISM, hook, routes, migration) goes through a governance proposal, as for LUNC and USTC.
- The operator keeps running the relayer and validator infrastructure; that does not require ownership of the contracts.
- The transfer is one-way: governance can later hand ownership elsewhere only by its own vote.

## Deposit

The proposal will be submitted with an initial deposit of 1,000,000 LUNC (the chain-enforced minimum initial deposit, 20% of the total). The minimum to enter the voting period is 5,000,000 LUNC; any wallet can top it up within the 14-day deposit period. Voting period: 7 days.

Questions and review are welcome in this thread before the on-chain submission.
