#!/usr/local/bin/bash

  ##  Example usage:
  ##      ./decrypt.sh 'vault:3:SUFNIGFuZCBFbmNyeXB0aW9uIGF0IEdhcDogRW5jcnlwdGlvbiBTZXJ2aWNlcyBHYWxvcmUh' 'mykey'

CIPHERTEXT_TO_TEST=$1
KEY_NAME=$2

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
     --data "{\"ciphertext\": \"${CIPHERTEXT_TO_TEST}\"}" \
    "${VAULT_ADDR}/v1/transit/decrypt/${KEY_NAME}"
