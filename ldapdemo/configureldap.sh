VAULT_ADDR=http://192.168.13.37:8200

  ##  Make sure to have VAULT_TOKEN set before using this script
  ##  Copy sampleldap.json to secretldap.json: 
  ##  cp sampleldap.json secretldap.json
  ##  Edit secretldap.json to replace the values for your org.
  ##  Run this script.


curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @secretldap.json \
    "${VAULT_ADDR}/v1/auth/ldap1/config" | jq


curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    "${VAULT_ADDR}/v1/auth/ldap1/config" | jq
