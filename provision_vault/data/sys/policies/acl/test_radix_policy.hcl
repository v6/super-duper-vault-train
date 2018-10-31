path "*"
{
  capabilities = ["read", "list"]
}

path "secret/data/vdev/*/license/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}

path "secret/data/vdev/*/database/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}
