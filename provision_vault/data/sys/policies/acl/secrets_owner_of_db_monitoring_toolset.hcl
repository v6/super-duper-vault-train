  ##  EXAMPLE SECRETS OWNER POLICY  ##

  ##  This would be created by a Vault account with
  ##  Vault Provisioner permissions.

  ##  The Vault Application Provisioner, e.g. provisioner_of_db_monitoring_toolset.hcl,
  ##  would request that the Vault Authentication Administrator associate
  ##  this policy with a specific Active Directory group.

  ##  Policies like this need to be validated for the following:
  ##  Path Naming Convention (Check against documentation or Regex)
  ##  Least Privilege (Check that paths are specific, and none of
  ##  the paths listed go unused in tests of the Application
  ##  to which this policy would apply)

  ##  Policy for managing static secrets in a KV store
  ##  https://www.vaultproject.io/api/secret/kv/kv-v2.html

  ##  The part after database should be something like mongo, oracle, or mysql
path "secret/data/prod/db_monitoring_toolset/database/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}

  ##  The part after database should be something like mongo, oracle, or mysql
path "secret/data/acceptance/db_monitoring_toolset/database/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}

  ##  The part after database should be something like mongo, oracle, or mysql
path "secret/data/test/db_monitoring_toolset/database/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}

  ##  The part after database should be something like mongo, oracle, or mysql
path "secret/data/dev/db_monitoring_toolset/database/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}
