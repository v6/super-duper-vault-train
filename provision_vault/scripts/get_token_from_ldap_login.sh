#!/usr/bin/env bash

  ##  Sets VAULT_TOKEN after logging in with
  ##  LDAP passphrase. 

  ##  Make sure that these environment variables are set beforehand: 
  ##  LDAP_USER=
  ##  LDAP_PASS=
  ##  VAULT_ADDR=

export VAULT_TOKEN=$(curl -sk -d "{\"password\": \"${LDAP_PASS}\"}" "${VAULT_ADDR}/v1/auth/ldap/login/${LDAP_USER}" | jq '.auth.client_token' | cut -d'"' -f 2); echo $VAULT_TOKEN; curl -sk --header "X-Vault-Token: ${VAULT_TOKEN}" --request GET "${VAULT_ADDR}/v1/auth/token/lookup-self | jq '.data.id'

  ##  Get details about the token just generated
curl -k --header "X-Vault-Token: ${VAULT_TOKEN}" \
        --request GET \
        "${VAULT_ADDR}/v1/auth/token/lookup-self" | jq
