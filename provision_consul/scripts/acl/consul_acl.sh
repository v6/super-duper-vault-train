#!/usr/bin/env bash

#export CONSUL_ADDR=http://127.0.0.1:8500
#
#echo 'ps -ef | grep consul'
#ps -ef | grep consul
#
#echo "Now attempting to 'bootstrap' Consul ACLs for the Consul cluster with an API accessible at the following address:"
#echo "${CONSUL_ADDR}"
#echo "export CONSUL_HTTP_TOKEN=$(curl -k --request PUT \"${CONSUL_ADDR}/v1/acl/bootstrap\" | jq -r '.ID')"
#curl -k --request PUT "${CONSUL_ADDR}/v1/acl/bootstrap"  ##  Test Only
#export CONSUL_HTTP_TOKEN=$(curl -k --request PUT "${CONSUL_ADDR}/v1/acl/bootstrap" | jq -r '.ID')
#echo "CONSUL_HTTP_TOKEN=${CONSUL_HTTP_TOKEN}"
#echo "${CONSUL_HTTP_TOKEN}" > "/vagrant/${HOSTNAME}_consul_http_token.txt"

  ##  Should display a Consul token, and write it to a file.
  ##  That file should be deleted ASAP, and its contents saved to a secure location
  ##  at the end of Consul & Vault setup. 
