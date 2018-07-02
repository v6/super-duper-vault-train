  ##  Vault Admin permissions: Don't grant to local accounts in prod, e.g. use AD.
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/auth/*"
{
  capabilities = ["create", "read", "update", "delete", "sudo"]
}

path "sys/policy"
{
  capabilities = ["read"]
}

path "sys/policy/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/health"
{
  capabilities = ["read", "sudo"]
}

path "sys/capabilities"
{
  capabilities = ["create", "update"]
}

path "sys/capabilities-self"
{
  capabilities = ["create", "update"]
}
