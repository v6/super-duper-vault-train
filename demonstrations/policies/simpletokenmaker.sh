export POLICIES="\"${1}\""


curl -k \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data "{ \"policies\": [ ${POLICIES} ], \"ttl\": \"350h\", \"renewable\": true }" \
    "${VAULT_ADDR}"/v1/auth/token/create
