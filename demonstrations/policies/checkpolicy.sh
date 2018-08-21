#!/usr/bin/env bash
  ##  Create a policy in Vault
POLICY_NAME=$1
curl -sk \
       --header "X-Vault-Token: ${VAULT_TOKEN}" \
       "${VAULT_ADDR}/v1/sys/policy/${POLICY_NAME}"
