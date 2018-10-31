export POLICIES="\"${1}\""
POLICIES=secrets_consumer_of_db_monitoring_toolset

curl -k \
    --header "X-Vault-Token: ${VAULT_TOKEN}"
    --request POST \
    --data "{ \"policies\": [ \"${POLICIES}\" ], \"ttl\": \"350h\", \"renewable\": true }" \
    "${VAULT_ADDR}"/v1/auth/token/create/secrets_consumer_of_db_monitoring_toolset | jq
