#!/usr/bin/env bash

export CONSUL_ADDR=http://127.0.0.1:8500

curl -k \
        --request PUT \
        "${CONSUL_ADDR}/v1/acl/bootstrap"
