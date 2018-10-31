#!/usr/bin/env bash

echo '  ##  ReWrap Data  ##  '

KEY_NAME=myapp

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @rewrap_payload.json \
    "${VAULT_ADDR}/v1/transit/rewrap/${KEY_NAME}"
