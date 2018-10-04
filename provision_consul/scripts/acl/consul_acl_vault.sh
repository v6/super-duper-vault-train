#!/usr/bin/env bash

  ##  Set a Vault policy according 
  ##  to the docs at the following URL's link result: 
  ##  https://www.consul.io/docs/guides/acl.html#create-tokens-for-ui-use-optional-

  ##  Make sure to set the following environment variables before running this:
  ##          CONSUL_ADDR
  ##          CONSUL_HTTP_TOKEN

echo "   ##  Make sure to set the following environment variables before running this:
  ##          CONSUL_ADDR=${CONSUL_ADDR}
  ##          CONSUL_HTTP_TOKEN=${CONSUL_HTTP_TOKEN}"

export CONSUL_ADDR='http://127.0.0.1:8500'
export CONSUL_HTTP_TOKEN=$(cat "/vagrant/${HOSTNAME}_consul_http_token.txt")
echo $CONSUL_HTTP_TOKEN
echo $CONSUL_ADDR

printf 'curl \
    --request PUT \
    --header "X-Consul-Token: ${CONSUL_HTTP_TOKEN}" \
    --data @/vagrant/provision_consul/data/acl/vault.json \
    http://127.0.0.1:8500/v1/acl/create'

echo "Now attempting to set a Consul ACL for the Vault cluster with an API accessible at the following address: ${CONSUL_ADDR} on ${HOSTNAME}"

export VAULT_CONSUL_HTTP_TOKEN=$(curl \
    --request PUT \
    --header "X-Consul-Token: ${CONSUL_HTTP_TOKEN}" \
    --data @/vagrant/provision_consul/data/acl/vault.json \
    http://127.0.0.1:8500/v1/acl/create | jq -r '.ID')

echo ''
echo "${VAULT_CONSUL_HTTP_TOKEN}"

echo "${VAULT_CONSUL_HTTP_TOKEN}" > "/vagrant/${HOSTNAME}_vault_consul_http_token.txt"

  ##  Should display a Consul token for the Vault cluster, and write it to a file.
  ##  That file should be deleted ASAP, and its contents saved to a secure location
  ##  at the end of Consul & Vault setup.

  ##  Result should be something like this: d0a9f330-2f9d-0a8c-d2af-1e9ceda354e6
