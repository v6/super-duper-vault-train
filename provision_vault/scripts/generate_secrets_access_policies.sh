#!/usr/bin/env bash

APPLICATION_SHORTNAME=$1
  ##  Example Application Short Name: myapp
APPLICATION_PATH=$2
  ##  Example Application Path: 'myapp/api_keys/myappservice'
APPLICATION_NAME=$3
  ##  Example Application Name: MyApp Purchase System

  ##  Examples of use: 
  ##  ./generate_secrets_access_policies.sh vaas 'vaas/api_keys/vaultservice' 'Vault as a Service'
  ##  ./generate_secrets_access_policies.sh myapp 'myapp/api_keys/myappservice' 'My Web App'
  ##  NOTE: The above examples assume the following naming convention: 
  ##          secret/<ENVIRONMENT>/<PRODUCT_USING_SECRETS>/<TYPE>/<SYSTEM_TO_WHICH_THE_SECRETS_GIVE_ACCESS>

  ##  If you need to push the heredoc to a variable,
  ##  use read -r -d '' part from the following Stack Overflow post: 
  ##  https://stackoverflow.com/a/1655389/2146138

##  This produces a .hcl file like secrets_owner_of_myapp.hcl
bash -c "cat >./secrets_owner_of_${APPLICATION_SHORTNAME}".hcl << EOF
  ##  EXAMPLE SECRETS OWNER POLICY  ##

  ##  This would be created by a Vault account with
  ##  Vault Provisioner permissions.

  ##  The Vault Application Provisioner, e.g. provisioner_of_${APPLICATION_SHORTNAME}.hcl,
  ##  would request that the Vault Authentication Administrator associate
  ##  this policy with a specific Active Directory group.

  ##  Policies like this need to be validated for the following:
  ##  Path Naming Convention (Check against documentation or Regex)
  ##  Least Privilege (Check that paths are specific, and none of
  ##  the paths listed go unused in tests of the Application
  ##  to which this policy would apply)

  ##  Policy for managing static secrets in a KV store
  ##  https://www.vaultproject.io/api/secret/kv/kv-v2.html

path "secret/data/prod/${APPLICATION_PATH}/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}

path "secret/data/acceptance/${APPLICATION_PATH}*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}

path "secret/data/test/${APPLICATION_PATH}/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}

path "secret/data/dev/${APPLICATION_PATH}/*"
{
  capabilities = ["create", "read", "update", "list", "delete"]
}
EOF

##  This produces a .hcl file like secrets_consumer_of_myapp.hcl
bash -c "cat >./secrets_consumer_of_${APPLICATION_SHORTNAME}".hcl << EOF
  ##  EXAMPLE SECRETS CONSUMER POLICY  ##

  ##  This would be created by a Vault account with
  ##  Vault ${APPLICATION_NAME} Application Provisioner permissions.

  ##  The Vault ${APPLICATION_NAME} Application Provisioner, e.g. provisioner_of_${APPLICATION_SHORTNAME}.hcl,
  ##  would request that the Vault Authentication Administrator associate
  ##  this policy with a specific Active Directory group.

  ##  Policies like this need to be validated for the following:
  ##  Path Naming Convention (Check against documentation or Regex)
  ##  Least Privilege (Check that paths are specific, and none of
  ##  the paths listed go unused in tests of the Application
  ##  to which this policy would apply)

  ##  Policy for reading static secrets in a KV store
  ##  Secrets must be created by a Secrets Owner for ${APPLICATION_NAME}.
  ##  https://www.vaultproject.io/api/secret/kv/kv-v2.html

path "secret/data/prod/${APPLICATION_PATH}/*"
{
  capabilities = ["read", "list"]
}

path "secret/data/acceptance/${APPLICATION_PATH}*"
{
  capabilities = ["read", "list"]
}

path "secret/data/test/${APPLICATION_PATH}/*"
{
  capabilities = ["read", "list"]
}

path "secret/data/dev/${APPLICATION_PATH}/*"
{
  capabilities = ["read", "list"]
}
EOF



  ##  SANDBOX  ##  

  ##  This role would give a separate area for developers being onboarded to play around with Vault, and allow them easier migration without affecting the rest of the production secrets.


##  This produces a .hcl file like sandbox_tester_of_myapp.hcl
bash -c "cat >./vault_sandbox_tester_for_${APPLICATION_SHORTNAME}".hcl << EOF
  ##  EXAMPLE SANDBOX TESTER POLICY  ##

  ##  This would be created by a Vault account with
  ##  Vault ${APPLICATION_NAME} Sandbox Tester permissions.

  ##  The Vault ${APPLICATION_NAME} Sandbox Tester Provisioner, e.g. provisioner_of_${APPLICATION_SHORTNAME}.hcl,
  ##  would request that the Vault Authentication Administrator associate
  ##  this policy with a specific Active Directory group.

  ##  Policies like this need to be validated for the following:
  ##  Path Naming Convention (Check against documentation or Regex)
  ##  Least Privilege (Check that paths are specific, and none of
  ##  the paths listed go unused in tests of the Application
  ##  to which this policy would apply)

  ##  Policy for reading static secrets in a KV store
  ##  Secrets must be created by a Secrets Owner for ${APPLICATION_NAME}.
  ##  https://www.vaultproject.io/api/secret/kv/kv-v2.html

  ##  It will also give access to Encryption as a Service testing

  ##  VAULT POLICY  ##

  ##  This is a policy for testing out
  ##  Vault consumption mehods to see which one will work
  ##  for the ${APPLICATION_NAME}.

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
path "secret/data/${APPLICATION_SHORTNAME}/pci/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/${APPLICATION_SHORTNAME}/prod/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/${APPLICATION_SHORTNAME}/test/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/${APPLICATION_SHORTNAME}/dev/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  Policy for managing static EaaS secrets in a KV store
path "secret/data/${APPLICATION_SHORTNAME}/pci/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/${APPLICATION_SHORTNAME}/prod/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/${APPLICATION_SHORTNAME}/test/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/${APPLICATION_SHORTNAME}/dev/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}


  ##  Policy for testing ${APPLICATION_NAME} Encryption Keys
  ##  Create a key, read it, updated it, rotate, export, etc.
path "transit/keys/${APPLICATION_SHORTNAME}_encryption*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  This can be safely given out even to untrusted clients
path "transit/rewrap*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  Allow backup and restore of the ${APPLICATION_SHORTNAME}_encryption keys
path "transit/backup/${APPLICATION_SHORTNAME}_encryption*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "transit/restore/${APPLICATION_SHORTNAME}_encryption*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

  ##  Allow some generic utility functions
  ##  Some of these are limited to ${APPLICATION_SHORTNAME}
  ##  Others, like verification, can
  ##  be safely given for all keys.

path "transit/datakey/plaintext/${APPLICATION_SHORTNAME}_encryption*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/datakey/wrapped/${APPLICATION_SHORTNAME}_encryption*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/hash*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/hmac/${APPLICATION_SHORTNAME}_encryption*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/sign/${APPLICATION_SHORTNAME}_encryption*"
{
  capabilities = ["create", "read", "update", "list"]
}

path "transit/verify/*"
{
  capabilities = ["create", "read", "update", "list"]
}
  ##  Policy for encryption / decryption
  ##  An update permission allows the app to request data encryption and decryption using the ${APPLICATION_SHORTNAME}_encryption encryption key in Vault.
path "transit/decrypt/${APPLICATION_SHORTNAME}_encryption*" {
  capabilities = ["update"]
}

path "transit/encrypt/${APPLICATION_SHORTNAME}_encryption*" {
  capabilities = ["update"]
}


path "secret/data/prod/${APPLICATION_PATH}/*"
{
  capabilities = ["read", "list"]
}

path "secret/data/acceptance/${APPLICATION_PATH}*"
{
  capabilities = ["read", "list"]
}

path "secret/data/test/${APPLICATION_PATH}/*"
{
  capabilities = ["read", "list"]
}

path "secret/data/dev/${APPLICATION_PATH}/*"
{
  capabilities = ["read", "list"]
}
EOF
