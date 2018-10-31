#!/usr/bin/env bash
  ##  See a policy in Vault
  ##  Usage: ./checkpolicy.sh my_policy_name
POLICY_NAME=$1
curl -sk \
       --header "X-Vault-Token: ${VAULT_TOKEN}" \
       "${VAULT_ADDR}/v1/sys/policy/${POLICY_NAME}"
