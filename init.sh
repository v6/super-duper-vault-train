VAULT_ADDR='http://192.168.13.37:8200'

echo "  ##  Initializing Vault"
echo "  ##  https://www.vaultproject.io/api/system/init.html"

curl -s \
    --request PUT \
    --data @initpayload.json \
    "${VAULT_ADDR}/v1/sys/init" | jq
