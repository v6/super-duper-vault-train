#!/usr/bin/env bash

  ##  Set an anonymous policy according 
  ##  to the docs at the following URL's link result: 
  ##  https://www.consul.io/docs/guides/acl.html#create-tokens-for-ui-use-optional-

  ##  Make sure to set the following environment variables before running this:
  ##          CONSUL_ADDR
  ##          CONSUL_HTTP_TOKEN

curl \
    --request PUT \
    --header "X-Consul-Token: ${CONSUL_HTTP_TOKEN}" \
    --data \
'{
  "Name": "Vault Token",
  "Type": "client",
  "Rules": "{ \"key\": { \"vault/\": { \"policy\": \"write\" } }, \"node\": { \"\": { \"policy\": \"write\" } }, \"service\": { \"vault\": { \"policy\": \"write\" } }, \"agent\": { \"\": { \"policy\": \"write\" } }, \"session\": { \"\": { \"policy\": \"write\" } } }"
}' http://127.0.0.1:8500/v1/acl/create
echo ''
  ##  Result should be something like this: {"ID":"d0a9f330-2f9d-0a8c-d2af-1e9ceda354e6"}


