#!/usr/bin/env bash
  ##  Batch Input Encryption

  ##  Example usage: 
  ##      ./batch_encrypt.sh mykey

KEY_NAME=$1

curl -k \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @batchencryptpayload.json \
    "${VAULT_ADDR}/v1/transit/encrypt/${KEY_NAME}"
