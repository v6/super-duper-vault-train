user0="Christiano Ronaldo"
user0email=christiano@worldcup.com
user0ldap=crronal


tokendata0=$(curl -k \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data "{ \"policies\": [ \"chef_storage_tester\" ], \"meta\": { \"user\": \"${user0}\", \"email\": \"${user0email}\", \"ldap_username\": \"${user0ldap}\" }, \"ttl\": \"700h\", \"renewable\": true }" \
    "${VAULT_ADDR}"/v1/auth/token/create)


echo "${tokendata0}" | jq
