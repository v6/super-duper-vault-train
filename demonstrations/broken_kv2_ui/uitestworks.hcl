  ##  Works in the Vault UI
path "kv1/mykv1secret" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  Reading from a specific URI works in the Vault UI, as long
  ##  as I navigate to http://192.168.13.37:8200/ui/vault/secrets/kv2/show/mykv2secret
  ##  But even still, I can't reach the Create Secret dialog
  ##  from http://192.168.13.37:8200/ui/vault/secrets/kv2/list
path "kv2/data/mykv2secret*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
path "kv2/metadata/mykv2secret*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
path "kv2/mykv2secret*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

#path "kv2/" {
#    capabilities = ["list"]
#}
path "kv2/data/" {
    capabilities = ["list"]
}
path "kv2/metadata/" {
    capabilities = ["list"]
}

  ##  And works in cURL:


  ##  curl --header "X-Vault-Token: s.11gAdHULHUd0cJNppKCSLmNp" --request POST --data '{"data":{"floo": "blar", "zilp": "zalp"}}' "${VAULT_ADDR}/v1/kv2/data/mykv2secret" | jq
  ##  curl --silent --header "X-Vault-Token: s.11gAdHULHUd0cJNppKCSLmNp" --request GET "${VAULT_ADDR}/v1/kv2/data/mykv2secret" | jq
