

# store the code on chain
RES=$(osmosisd tx wasm store artifacts/cw_tpl_osmosis.wasm --from thomas --gas-prices 0.1uosmo --gas auto --gas-adjustment 1.3 -y --output json -b block)

CODE_ID=$(echo $RES | jq -r '.logs[0].events[-1].attributes[1].value')
echo $CODE_ID

# set the initial state of the instance
INIT='{"name":"ushirt", "symbol":"ushirt", "decimals":6, "reserve_denom":"uosmo", "reserve_decimals":6, "curve_type":{"constant":{"value":"15", "scale":1}}}'

# instantiate the contract
osmosisd tx wasm instantiate $CODE_ID "$INIT" \
    --from thomas --label "cw-bonding contract" --gas-prices 0.025uosmo --gas auto --gas-adjustment 1.3 -b block -y --admin thomas

CONTRACT_ADDR=$(osmosisd query wasm list-contract-by-code $CODE_ID --output json | jq -r '.contracts[0]')
echo $CONTRACT_ADDR

osmo1qc6x5zahdm53hnr07sgcj8l8p70r5mxl9p7ujg467qe6d39nqcsqhcytfr

QUERY='{"balance":{"address":"osmo1x4e4hprrqu458dcymvf2mvh4wtz6w6gl9f93ng"}}'
osmosisd query wasm contract-state smart $CONTRACT_ADDR "$QUERY" --output json

QUERY='{"token_info":{}}'
osmosisd query wasm contract-state smart $CONTRACT_ADDR "$QUERY" --output json

BUY='{"burn": {"amount": "5"}}'
osmosisd tx wasm execute $CONTRACT_ADDR "$BUY" --from thomas --gas-prices 0.025uosmo --gas auto --gas-adjustment 1.3 -y