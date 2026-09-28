#!/usr/bin/env bash
# Admin tool — invocations that require the issuer/admin key to sign.
# Replace placeholders before running on testnet.

set -euo pipefail

NETWORK="${NETWORK:-testnet}"
ADMIN_KEY="${ADMIN_KEY:-juanjo}"
CONTRACT_ID="${CONTRACT_ID:-CCXKJFZJ37OLBJ23VK3IYLIX2GZDEWFHXBACKJUMUB4CQXBWJGFGGBAK}"
PAYMENT_TOKEN="${PAYMENT_TOKEN:-CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC}"
INVESTOR="${INVESTOR:-GCA7QQ6FRH5AN4RCGIUU7WWBFM4RCLFKZK55K7BUCWNHOL4AA6NXTLUH}"
TREASURY="${TREASURY:-GCA7QQ6FRH5AN4RCGIUU7WWBFM4RCLFKZK55K7BUCWNHOL4AA6NXTLUH}"

echo "=== initialize (run once after deploy) ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  initialize \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --asset '{"name":"RWATokenJJ","total_supply":"100000","price_per_unit":"100","payment_token":"'"$PAYMENT_TOKEN"'","paused":false}'

echo "=== set_whitelist ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  set_whitelist \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --investor "$INVESTOR" \
  --approved true

echo "=== mint (admin-only; optional if using invest) ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  mint \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --to "$INVESTOR" \
  --amount 100

echo "=== withdraw collected payment tokens ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  withdraw \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --to "$TREASURY" \
  --amount 500

echo "=== pause ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  pause \
  --admin "$(stellar keys address "$ADMIN_KEY")"

echo "=== unpause ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  unpause \
  --admin "$(stellar keys address "$ADMIN_KEY")"
