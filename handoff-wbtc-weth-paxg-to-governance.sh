#!/usr/bin/env bash
# =============================================================================
# Step 1 of the governance handoff of the WBTC / WETH / PAXG warp routers
# (Terra Classic, columbus-5):
#   - owner  : init_ownership_transfer { next_owner: governance }   (hpl_ownable, step 1 of 2)
#   - admin  : MsgUpdateAdmin -> governance                          (CosmWasm migration admin)
# Step 2 (claim_ownership by governance) is the proposal in
# claim-ownership-wbtc-weth-paxg-proposal.json — submit it only after this script
# reports all six checks green.
#
# Signs with the key that is the current owner/admin (default: contratos-hyperlane =
# terra1s0a2lyhcl44yg63epx5x0n5qqdwjtg93cfs8me, keyring "file"). Idempotent: a router
# whose pending_owner / admin is already governance is skipped.
#
#   usage:  DRY=1 bash handoff-wbtc-weth-paxg-to-governance.sh   # only shows the state
#           bash handoff-wbtc-weth-paxg-to-governance.sh         # executes
#   env:    KEY (default contratos-hyperlane) · NODE · LCD
# =============================================================================
set -euo pipefail

KEY="${KEY:-contratos-hyperlane}"; KEYRING="file"
NODE="${NODE:-https://terra-classic-rpc.publicnode.com:443}"
LCD="${LCD:-https://terra-classic-lcd.publicnode.com}"
CHAIN_ID="columbus-5"
GOV="terra10d07y265gmmuvt4z0w9aw880jnsr700juxf95n"   # x/gov module account
EXPECTED_SIGNER="terra1s0a2lyhcl44yg63epx5x0n5qqdwjtg93cfs8me"
DRY="${DRY:-0}"

declare -A ROUTER=(
  [WBTC]=terra1gepfs6d5kp6uvpq3w8s65n3fz77tuceze962wel50tznenq49ckssgt4s7
  [WETH]=terra14nna7hca7t9h7u39gumlplw92j7syavull70ju0haz80akqcsxsqp5s2kr
  [PAXG]=terra1k099akkvt99hr8f633ywecwmk4c2etcgg9y8lead24qxseq97mnspxzlyq
)
ORDER=(WBTC WETH PAXG)

TX=(--from "$KEY" --keyring-backend "$KEYRING" --chain-id "$CHAIN_ID" --node "$NODE"
    --gas auto --gas-adjustment 1.5 --gas-prices 28.325uluna -y --output json --broadcast-mode sync)
# MsgUpdateAdmin simulates ~40% below its real cost (WritePerByte) — use a fixed gas limit for it
ADMIN_GAS="${ADMIN_GAS:-200000}"

say(){ printf '\n\033[1;36m== %s ==\033[0m\n' "$*"; }
smart(){ # smart(contract, json) -> data
  local b64; b64=$(printf '%s' "$2" | base64 -w0)
  curl -s "$LCD/cosmwasm/wasm/v1/contract/$1/smart/$b64" | python3 -c 'import json,sys; print(json.dumps(json.load(sys.stdin)["data"]))'
}
admin_of(){ curl -s "$LCD/cosmwasm/wasm/v1/contract/$1" | python3 -c 'import json,sys; print(json.load(sys.stdin)["contract_info"].get("admin",""))'; }
owner_of(){ smart "$1" '{"ownable":{"get_owner":{}}}' | python3 -c 'import json,sys; print(json.load(sys.stdin)["owner"])'; }
pending_of(){ smart "$1" '{"ownable":{"get_pending_owner":{}}}' | python3 -c 'import json,sys; print(json.load(sys.stdin).get("pending_owner") or "")'; }

show(){
  for n in "${ORDER[@]}"; do
    local r=${ROUTER[$n]}
    printf '%-5s owner=%s\n      pending=%s\n      admin=%s\n' "$n" "$(owner_of "$r")" "$(pending_of "$r")" "$(admin_of "$r")"
  done
}

say "state BEFORE"; show
if [ "$DRY" = "1" ]; then echo; echo "DRY — nothing sent."; exit 0; fi

read -rs -p "Keyring password (key $KEY): " PASS; echo
sign(){ printf '%s\n%s\n' "$PASS" "$PASS" | terrad "$@" 2>/dev/null; }
ADDR=$(sign keys show "$KEY" -a --keyring-backend "$KEYRING")
[ "$ADDR" = "$EXPECTED_SIGNER" ] || { echo "❌ key $KEY = $ADDR, expected $EXPECTED_SIGNER"; exit 1; }
echo "✓ signer $ADDR"

wait_tx(){ # wait_tx(hash) -> prints code
  local h=$1 r
  for _ in $(seq 1 30); do
    r=$(terrad q tx "$h" --node "$NODE" --output json 2>/dev/null) && { echo "$r" | python3 -c 'import json,sys; r=json.load(sys.stdin); print(r.get("code",-1)); sys.exit(0 if r.get("code")==0 else 1)' && return 0 || { echo "$r" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("raw_log","")[:300])'; return 1; }; }
    sleep 3
  done
  echo "timeout waiting for $h"; return 1
}
send(){ # send(label, terrad args...) — broadcast and wait; extra flags after the args win over TX
  local label=$1; shift
  local out hash extra=()
  case "$label" in set-contract-admin*) extra=(--gas "$ADMIN_GAS");; esac
  out=$(sign tx "$@" "${TX[@]}" "${extra[@]}") || { echo "❌ $label: broadcast failed"; echo "$out" | head -c 300; return 1; }
  hash=$(echo "$out" | python3 -c 'import json,sys; print(json.load(sys.stdin)["txhash"])')
  printf '  %s → %s ' "$label" "$hash"
  if wait_tx "$hash" >/dev/null; then echo "✓"; else echo "❌ (see raw_log above)"; return 1; fi
}

for n in "${ORDER[@]}"; do
  r=${ROUTER[$n]}
  say "$n $r"
  own=$(owner_of "$r"); [ "$own" = "$ADDR" ] || { echo "⚠ owner is $own, not the signer — skipping init_ownership_transfer"; }
  if [ "$own" = "$ADDR" ]; then
    if [ "$(pending_of "$r")" = "$GOV" ]; then echo "  init_ownership_transfer: already pending to governance — skip"
    else send "init_ownership_transfer → governance" wasm execute "$r" "{\"ownable\":{\"init_ownership_transfer\":{\"next_owner\":\"$GOV\"}}}" || true; fi
  fi
  adm=$(admin_of "$r")
  if [ "$adm" = "$GOV" ]; then echo "  admin: already governance — skip"
  elif [ "$adm" = "$ADDR" ]; then send "set-contract-admin → governance" wasm set-contract-admin "$r" "$GOV" || true
  else echo "⚠ admin is $adm, not the signer — skipping set-contract-admin"; fi
done

say "state AFTER"; show
ok=1
for n in "${ORDER[@]}"; do
  r=${ROUTER[$n]}
  [ "$(pending_of "$r")" = "$GOV" ] || { echo "❌ $n pending_owner is not governance"; ok=0; }
  [ "$(admin_of "$r")" = "$GOV" ] || { echo "❌ $n admin is not governance"; ok=0; }
done
if [ $ok = 1 ]; then
  say "ALL GREEN — step 1 done. Now submit the proposal:"
  echo "  terrad tx gov submit-proposal claim-ownership-wbtc-weth-paxg-proposal.json ${TX[*]}"
else
  echo "some checks failed — fix before submitting the proposal"; exit 1
fi
