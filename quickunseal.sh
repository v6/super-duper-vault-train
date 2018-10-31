#!/usr/bin/env bash

  ##  You likely should only
  ##  use this for the test env,
  ##  because it bypasses
  ##  an important part of the Vault
  ##  seal and encryption process.
  ##  You probably don't want that
  ##  in Production.

KEY1=$1
KEY2=$2

VAULT_ADDR='http://192.168.13.35:8200'
echo "  ##  Unseal"
echo "  ##  https://www.vaultproject.io/api/system/unseal.html"
echo ""
echo "  ##  Unsealing ${VAULT_ADDR}"
curl \
    --request PUT \
    --data "{\"key\": \"${KEY1}\"}" \
    "${VAULT_ADDR}/v1/sys/unseal" | jq
curl \
    --request PUT \
    --data "{\"key\": \"${KEY2}\"}" \
    "${VAULT_ADDR}/v1/sys/unseal" | jq

VAULT_ADDR='http://192.168.13.36:8200'
echo "  ##  Unsealing ${VAULT_ADDR}"
curl \
    --request PUT \
    --data "{\"key\": \"${KEY1}\"}" \
    "${VAULT_ADDR}/v1/sys/unseal" | jq
curl \
    --request PUT \
    --data "{\"key\": \"${KEY2}\"}" \
    "${VAULT_ADDR}/v1/sys/unseal" | jq

VAULT_ADDR='http://192.168.13.37:8200'
echo "  ##  Unsealing ${VAULT_ADDR}"
curl \
    --request PUT \
    --data "{\"key\": \"${KEY1}\"}" \
    "${VAULT_ADDR}/v1/sys/unseal" | jq
curl \
    --request PUT \
    --data "{\"key\": \"${KEY2}\"}" \
    "${VAULT_ADDR}/v1/sys/unseal" | jq
