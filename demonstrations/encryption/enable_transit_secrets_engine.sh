#!/usr/bin/env bash


curl --header "X-Vault-Token: ${VAULT_TOKEN}" \
       --request POST \
       --data @sys_mounts_transit.json \
       "${VAULT_ADDR}/v1/sys/mounts/transit" | jq
