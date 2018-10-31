  ##  EXAMPLE SANDBOX TESTER POLICY  ##

  ##  This would be created by a Vault account with
  ##  Vault Monitoring Tool Set for Oracle Metrics Sandbox Tester permissions.

  ##  The Vault Monitoring Tool Set for Oracle Metrics Sandbox Tester Provisioner, e.g. provisioner_of_db_monitoring_toolset.hcl,
  ##  would request that the Vault Authentication Administrator associate
  ##  this policy with a specific Active Directory group.

  ##  Policies like this need to be validated for the following:
  ##  Path Naming Convention (Check against documentation or Regex)
  ##  Least Privilege (Check that paths are specific, and none of
  ##  the paths listed go unused in tests of the Application
  ##  to which this policy would apply)

  ##  Policy for reading static secrets in a KV store
  ##  Secrets must be created by a Secrets Owner for Monitoring Tool Set for Oracle Metrics.
  ##  https://www.vaultproject.io/api/secret/kv/kv-v2.html

  ##  It will also give access to Encryption as a Service testing

  ##  VAULT POLICY  ##

  ##  This is a policy for testing out
  ##  Vault consumption mehods to see which one will work
  ##  for the Monitoring Tool Set for Oracle Metrics.

  ##  Temporarily grant access to List other folders in Vault to be able
  ##  to explore what it is.

  ##  See contents of all KV secret storage paths
path "secret/*"
{
  capabilities = ["list"]
}

  ##  See lists of all transit methods, keys, etc.
path "transit/*"
{
  capabilities = ["list"]
}

  ##  See list of all authentication methods
path "auth/*"
{
  capabilities = ["list"]
}

  ##  See list of all policies
path "policy*"
{
  capabilities = ["list"]
}

  ##  Policy for managing static secrets in a KV store
  ##  https://www.vaultproject.io/api/secret/kv/kv-v2.html
path "secret/data/db_monitoring_toolset/pci/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/db_monitoring_toolset/prod/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/db_monitoring_toolset/test/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/db_monitoring_toolset/dev/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  Policy for managing static EaaS secrets in a KV store
path "secret/data/db_monitoring_toolset/pci/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/db_monitoring_toolset/prod/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/db_monitoring_toolset/test/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/db_monitoring_toolset/dev/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}


  ##  Policy for testing Monitoring Tool Set for Oracle Metrics Encryption Keys
  ##  Create a key, read it, updated it, rotate, export, etc.
path "transit/keys/db_monitoring_toolset_encryption*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  This can be safely given out even to untrusted clients
path "transit/rewrap*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  Allow backup and restore of the db_monitoring_toolset_encryption keys
path "transit/backup/db_monitoring_toolset_encryption*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "transit/restore/db_monitoring_toolset_encryption*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  Allow some generic utility functions
  ##  Some of these are limited to db_monitoring_toolset
  ##  Others, like verification, can
  ##  be safely given for all keys.

path "transit/datakey/plaintext/db_monitoring_toolset_encryption*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/datakey/wrapped/db_monitoring_toolset_encryption*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/hash*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/hmac/db_monitoring_toolset_encryption*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/sign/db_monitoring_toolset_encryption*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/verify/*"
{
  capabilities = ["create", "read", "update", "list"]
}
  ##  Policy for encryption / decryption
  ##  An update permission allows the app to request data encryption and decryption using the db_monitoring_toolset_encryption encryption key in Vault.
path "transit/decrypt/db_monitoring_toolset_encryption*" {
  capabilities = ["update"]
}

path "transit/encrypt/db_monitoring_toolset_encryption*" {
  capabilities = ["update"]
}


path "secret/data/prod/db_monitoring_toolset/database/oracle/*"
{
  capabilities = ["read", "list"]
}

path "secret/data/acceptance/db_monitoring_toolset/database/oracle*"
{
  capabilities = ["read", "list"]
}

path "secret/data/test/db_monitoring_toolset/database/oracle/*"
{
  capabilities = ["read", "list"]
}

path "secret/data/dev/db_monitoring_toolset/database/oracle/*"
{
  capabilities = ["read", "list"]
}
