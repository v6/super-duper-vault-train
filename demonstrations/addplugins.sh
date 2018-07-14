#!/usr/bin/env bash

echo '  ##  Vault Health'
curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request GET \
    "${VAULT_ADDR}/v1/sys/health" | jq


echo '  ##  Current plugins:  '
curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request LIST \
    "${VAULT_ADDR}/v1/sys/plugins/catalog" | jq


curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request PUT \
    --data '{"sha_256": "2c74a3dffc11e557c8d2b75612a37dae1c46dc22f8fa7982cdbfee8276aa37b0", "command": "vault-plugin-auth-jwt"}' \
    "${VAULT_ADDR}/v1/sys/plugins/catalog/vault-plugin-auth-jwt" | jq

