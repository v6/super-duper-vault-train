curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request GET \
    "${VAULT_ADDR}/v1/sys/audit" | jq
