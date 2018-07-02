#!/usr/bin/env bash

  ##  This script can unseal the Vault for you if you don't want to use the CLI or GUI.


  ##  Replace values in here with output from initalization (init.sh):
KEY1=''  
KEY2=''


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
