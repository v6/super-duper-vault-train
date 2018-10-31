#!/usr/bin/env bash

  ##  Example use: ./readkey.sh mykey

KEY_NAME=$1


echo '  ##  Read an Encryption Key with Vault  ##  '

echo "  ##  4.	Hands-on Demo Key Generation (5-10 minutes)
  ##  a.	https://www.vaultproject.io/api/secret/transit/index.html#create-key (Vault analogy to openssl genrsa or openssl ecparam)


echo "curl \
    --header \"X-Vault-Token: ${VAULT_TOKEN}\" \
    --request GET \
    \"${VAULT_ADDR}/v1/transit/keys/${KEY_NAME}\""

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request GET \
    "${VAULT_ADDR}/v1/transit/keys/${KEY_NAME}" | jq
