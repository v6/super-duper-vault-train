export POLICIES="\"${1}\""
export DISALLOWED_POLICIES="\"${2}\""

echo "${POLICIES}"

curl -k \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data "{ \"allowed_policies\": [ ${POLICIES} ], \"disallowed_policies\": [ ${DISALLOWED_POLICIES} ], \"name\": \"db_monitoring_toolset_readonly\", \"ttl\": \"350h\", \"renewable\": true }" \
    "${VAULT_ADDR}"/v1/auth/token/roles/db_monitoring_toolset_readonly | jq
