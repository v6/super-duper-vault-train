  ##  Vault Admin
  ##  
  ##  Replace "super-duper" with your organization name.
  ##  
  ##  Vault Admin permissions: Don't grant to local accounts 
  ##  in any production environments, e.g. use AD.
  ##  Manages the Vault infrastructure for a team or organizations
  ##  
  ##  This role is a step removed from the 'Vault Root'.
  ##  
  ##  Things like '/sys/init` should be restricted for one.
  ##  
  ##  Which standard paths and actions to include and what to exclude?
  ##  
  ##  "auth/*", "sys/auth/*", "sys/policy", "sys/policy/*", "secret/*", "sys/mounts/*", "sys/health", "ssh/*"
  ##  
  ##  We can either make a "standard" admin policy, or whitelist endpoints we find we need instead of making global whitelist policy for admins.
  ##  
  ##  Vault Policy file: <organization_that_owns_vault>_vault_admin.hcl
  ##  Examples: myorg_vault_admin.hcl, bitcoin.com_vault_admin.hcl, digitalonus_vault_admin.hcl


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
  capabilities = ["read", "list"]
}

path "sys/policies/acl*"
{
  capabilities = ["read", "list"]
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
 
path "sys/*"
{
  capabilities = ["create", "read", "update", "delete", "sudo"]
}
