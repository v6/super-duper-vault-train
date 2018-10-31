  ##  Configures new secret engine mounts and creates new sets of policies, 
  ##  including those for the Vault Application Provisioner Role, 
  ##  for client apps.
  ##  
  ##  Does not have root or admin access to Vault
  ##  
  ##  Vault Policy file: vault_provisioner.hcl


  ##  Because this is a _provisioner_ account, we want to 
  ##  authorize the creation of _new_ authentication methods,
  ##  and prevent any interference with existing methods.

  ##  And the provisioner account can do any necessary testing
  ##  on a sandbox environment.

  ##  Acceptance testing can happen in concert with the 
  ##  owner of a given Application that needs access to Vault.

  ##  This requires that a Vault Admin or Vault Authentication Administrator
  ##  has already enabled a type of authentication method.

  ##  Create new Approle authentication methods
  ##  https://www.vaultproject.io/api/system/auth.html#enable-auth-method
  ##  NOTE: Normally "sys/auth/*" would give the same authorization for
  ##        modifying Vault as the Authentication Administrator has.
  ##        This is partly why I have omitted the "delete" capability
  ##        from this path's list of allowed capabilities.
  ##        But the allowed_parameters field limits this policy to 
  ##        only enabling new Auth Methods of type "approle". 
  ##        Also, for most applications, this can be replaced by the
  ##        creation of a new AppRole, rather than enabling a new
  ##        AppRole Authentication Method: 
  ##        https://www.vaultproject.io/api/auth/approle/index.html#create-new-approle
path "sys/auth/*"
{
  capabilities = ["create", "list", "sudo"]
  allowed_parameters = {
    "type" = "approle"
  }
}

  ##  Create new AppRoles
  ##  Use this whenever possible in stead of enabling new 
  ##  AppRole Authentication Methods.
path "auth/approle/role/*"
{
  capabilities = ["create", "list", "delete"]
}


  ##  Create new authentication mounts on existing authentication methods
  ##  https://www.vaultproject.io/api/auth/ldap/index.html#configure-ldap
  ##  
path "auth/*"
{
  capabilities = ["create", "list", "delete"]
}

  ##  Tie LDAP groups to Vault Policies
  ##  https://www.vaultproject.io/api/auth/ldap/index.html#create-update-ldap-group
  ##  Make sure that the Provisioner is only tying LDAP groups to
  ##  Vault Application Provisioner Policies, because otherwise anyone
  ##  with this policy could grant themselves blanket permissions.
path "auth/ldap/groups/*"
{
  capabilities = ["create", "list"]
  allowed_parameters = {
    "policies" = ["provisioner_of_*"]
  }
}

  ##  Tie LDAP users to Vault Policies
  ##  https://www.vaultproject.io/api/auth/ldap/index.html#create-update-ldap-user
path "auth/ldap/users/*"
{
  capabilities = ["create", "list"]
}
