#!/usr/bin/env bash

echo '  ##  Generate an Encryption Key with Vault  ##  '

echo "
  ##	Hands-on Demo Key Generation (5-10 minutes)
  ##	https://www.vaultproject.io/api/secret/transit/index.html#create-key
  ##                    Vault analogy to openssl genrsa or openssl ecparam

  ##  Don't forget to set up your VAULT_TOKEN and VAULT_ADDR variables, first.
  ##  For example: 
  ##  export VAULT_TOKEN=7999a32a-15a8-ecab-2f2c-b65c52018de8
  ##  export VAULT_ADDR=https://vault.mysite.com:8200"

KEY_NAME=$1

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data '{ "type": "rsa-4096", "derived": false, "exportable": true, "allow_plaintext_backup": true }' \
    "${VAULT_ADDR}/v1/transit/keys/${KEY_NAME}"
