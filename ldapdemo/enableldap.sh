  ##  Enable LDAP
  ##  https://www.vaultproject.io/api/system/auth.html


VAULT_ADDR='http://192.168.13.37:8200'
MOUNT_NAME='ldap3'


curl -sk \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @enableldappayload.json \
    "${VAULT_ADDR}/v1/sys/auth/${MOUNT_NAME}" | jq


curl -sk \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    "${VAULT_ADDR}/v1/sys/auth" | jq
