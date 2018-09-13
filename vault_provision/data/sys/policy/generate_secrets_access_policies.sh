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
