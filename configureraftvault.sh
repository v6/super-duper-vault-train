#!/usr/bin/env bash

NODE_ID=$1

sudo bash -c "cat >/etc/vault.d/vault.hcl" << EOF
## Vault Configuration File ##

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
#  tls_cert_file = ""
#  tls_key_file  = ""
#  tls_min_version = ""
}

storage "raft" {
  path    = "/opt/data/vault/"
  node_id = $NODE_ID
  retry_join {
    leader_api_addr = "192.168.13.35:8200"
  }
  retry_join {
    leader_api_addr = "192.168.13.36:8200"
  }
  retry_join {
    leader_api_addr = "192.168.13.37:8200"
  }
}
plugin_directory = "/etc/vault.d/plugin"
ui=true
EOF
