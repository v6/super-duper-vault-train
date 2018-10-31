  ##  VAULT AUTHENTICATION ADMINISTRATOR
  ##  Enables new authentication methods, and
  ##  creates specific new types of Vault Policies for
  ##  Application Provisioners.


  ##  Most auth method enabling requires "sudo" permissions
  ##  https://www.vaultproject.io/api/system/auth.html#enable-auth-method
path "sys/auth/*"
{
  capabilities = ["create", "list", "sudo"]
}

  ##  Create Vault Application Provisioner Policies allowing use
  ##  and configuration of the above authentication methods
path "sys/policies/acl/provisioner_of_*"
{
  capabilities = ["create", "list", "delete"]
}
