#!/usr/bin/env bash

  ##  Example usage: 
  ##      ./rotate_key.sh mykey

KEY_NAME=$1

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    "${VAULT_ADDR}/v1/transit/keys/${KEY_NAME}/rotate"
