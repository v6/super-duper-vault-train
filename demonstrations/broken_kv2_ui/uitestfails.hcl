  ##  Works in the Vault UI
path "kv1/mykv1secret" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  Doesn't work in the Vault UI, even if I navigate to a specific
  ##  URL, http://192.168.13.37:8200/ui/vault/secrets/kv2/show/mykv2secret
path "kv2/data/mykv2secret*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
path "kv2/mykv2secret*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  But works in cURL: 

  ##  curl --header "X-Vault-Token: s.11gAdHULHUd0cJNppKCSLmNp" --request POST --data '{"data":{"floo": "blar", "zilp": "zalp"}}' "${VAULT_ADDR}/v1/kv2/data/mykv2secret" | jq
  ##  curl --silent --header "X-Vault-Token: s.11gAdHULHUd0cJNppKCSLmNp" --request GET "${VAULT_ADDR}/v1/kv2/data/mykv2secret" | jq
