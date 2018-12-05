#!/bin/bash

  ##  Create namespaces based on the contents of  ##
  ##  provision_vault/data/sys/namespaces  ##

  ##  Make sure to have VAULT_TOKEN and VAULT_ADDR  ##
  ##  set before running.  ##

for filename in ../data/sys/namespaces/*; do
    echo '  ##  Create Namespace  ##  '
    filename=$(echo $filename | cut -c 24-)
    echo "${filename}" 
    curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    "${VAULT_ADDR}/v1/sys/namespaces/${filename}" | jq
    echo '  ##  Read Namespace Information  ##  '
    curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    "${VAULT_ADDR}/v1/sys/namespaces/${filename}" | jq
done

echo '  ##  Resulting Namespaces  ##  '
    curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request LIST \
    "${VAULT_ADDR}/v1/sys/namespaces" | jq
