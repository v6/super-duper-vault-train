#!/usr/bin/env bash

  ##  Get a list of LDAP groups and auth methods


  ##  List Auth Methods

printf "curl -k \
    --header \"X-Vault-Token: ${VAULT_TOKEN}\" \
    --request LIST \
    \"${VAULT_ADDR}/v1/sys/auth\" | jq"

curl -k \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request GET \
    "${VAULT_ADDR}/v1/sys/auth" | jq


  ##  List LDAP Groups

printf "curl -k \
    --header \"X-Vault-Token: ${VAULT_TOKEN}\" \
    --request LIST \
    \"${VAULT_ADDR}/v1/auth/ldap/groups\""


curl -k \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request LIST \
    "${VAULT_ADDR}/v1/auth/ldap/groups"
