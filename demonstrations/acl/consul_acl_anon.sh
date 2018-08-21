#!/usr/bin/env bash

  ##  Set an anonymous policy according 
  ##  to the docs at the following URL's link result: 
  ##  https://www.consul.io/docs/guides/acl.html#set-an-anonymous-policy-optional-

curl \
    --request PUT \
    --header "X-Consul-Token: ${CONSUL_HTTP_TOKEN}" \
    --data \
'{
  "ID": "anonymous",
  "Type": "client",
  "Rules": "node \"\" { policy = \"read\" }"
}' http://127.0.0.1:8500/v1/acl/update

  ##  Should show something like {"ID":"anonymous"}


  ##  Now set the Anon policy for looking up the Consul service: 

echo "${CONSUL_HTTP_TOKEN}"
curl \
    --request PUT \
    --header "X-Consul-Token: ${CONSUL_HTTP_TOKEN}" \
    --data \
'{
  "ID": "anonymous",
  "Type": "client",
  "Rules": "node \"\" { policy = \"read\" } service \"consul\" { policy = \"read\" }"
}' http://127.0.0.1:8500/v1/acl/update
echo ''
