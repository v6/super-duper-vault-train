#!/usr/bin/env bash

  ##  Get global list of policies
curl -k \
    --request GET \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    "$VAULT_ADDR/v1/sys/policies/acl" | jq

  ##  List specific policy
curl -k \
    --request GET \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    "$VAULT_ADDR/v1/sys/policies/acl/admin" | jq
