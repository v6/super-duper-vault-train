  ##  example usage: ./create_approle.sh approle_name_for_my_app

APPROLE=$1

curl -v --request PUT --header "X-Vault-Token: ${VAULT_TOKEN}" --data @$APPROLE.json "${VAULT_ADDR}/v1/auth/approle/role/${APPROLE}"

curl -v --request GET --header "X-Vault-Token: ${VAULT_TOKEN}" "${VAULT_ADDR}/v1/auth/approle/role/${APPROLE}" | jq

echo done
