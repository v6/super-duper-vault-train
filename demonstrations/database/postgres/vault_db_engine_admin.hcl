# Mount secret engines
path "sys/mounts/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# Configure the database secret engine and create roles
path "database/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# Write ACL policies
path "sys/policy/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# Manage tokens for verification
path "auth/token/create" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
