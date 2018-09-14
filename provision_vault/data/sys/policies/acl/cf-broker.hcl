  ##  This is a policy for the Vault Service Broker
  ##  It makes sure that the Vault Service Broker
  ##  has capabilities mentioned here: 
  ##  https://github.com/hashicorp/vault-service-broker#architecture-and-assumptions

  ##  This section of the policy allows creation of new 
  ##  authentication mounts.
  ##  When a new service instance is provisioned using the broker, it will mount the following paths:

  ##  Mount the generic backend at /cf/<organization_id>/secret/
  ##  Mount the generic backend at /cf/<space_id>/secret/
  ##  Mount the generic backend at /cf/<instance_id>/secret/
  ##  Mount the transit backend at /cf/<instance_id>/transit/

path "secret/*" {
    capabilities = ["deny"]
}

path "sys/auth/secret" {
    capabilities = ["deny"]
}

path "sys/auth/transit" {
    capabilities = ["deny"]
}

path "sys/auth/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

  ##  And here are the permissions recommended by 
  ##  the Broker documentation: 
  ##  https://github.com/hashicorp/vault-service-broker#broker-vault-token-permissions

# Manage internal state under "/broker", but since this token is going to
# generate children, it needs full management of the "/cf/*" space
path "/cf/" {
  capabilities = ["list"]
}

path "/cf/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# List all mounts
path "sys/mounts" {
  capabilities = ["read", "list"]
}

# Create mounts under the "/cf/" prefix
path "sys/mounts/cf/*" {
  capabilities = ["create", "update", "delete"]
}

# Create policies with the "cf-*" prefix
path "sys/policy/cf-*" {
  capabilities = ["create", "update", "delete"]
}

# Create token role
path "/auth/token/roles/cf-*" {
  capabilities = ["create", "update", "delete"]
}

# Create tokens from role
path "/auth/token/create/cf-*" {
  capabilities = ["create", "update"]
}

# Revoke tokens by accessor
path "/auth/token/revoke-accessor" {
  capabilities = ["create", "update"]
}
