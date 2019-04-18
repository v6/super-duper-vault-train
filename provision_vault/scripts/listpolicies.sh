#!/usr/bin/env bash

  ##  Get global list of policies
curl -k \
    --request LIST \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    "$VAULT_ADDR/v1/sys/policies/acl" | jq '.data.keys'

  ##  List specific policy
curl -k \
    --request LIST \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    "$VAULT_ADDR/v1/sys/policies/acl/admin" | jq
