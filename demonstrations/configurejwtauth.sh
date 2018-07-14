#!/usr/bin/env bash

  ##  Configure JWT Auth, like OIDC

  ##  https://github.com/hashicorp/vault/blob/6b4f6b93613dc2bf335860dc890ce4000f92f13a/website/source/api/auth/jwt/index.html.md#jwt-auth-method-api
  ##  Configures the validation information to be used globally across all roles. One (and only one) of oidc_discovery_url and jwt_validation_pubkeys must be set.


curl -s \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data '{ "oidc_discovery_url": "https://myco.auth0.com/", "bound_issuer": "https://myco.auth0.com/" }' \
    "${VAULT_ADDR}/v1/auth/jwt/config"

curl -s \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request GET \
    "${VAULT_ADDR}/v1/auth/jwt/config"  | jq
