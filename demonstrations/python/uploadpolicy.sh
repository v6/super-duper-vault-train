#!/usr/bin/env bash
  ##  Create a policy in Vault
  ##  Make sure to have the $VAULT_TOKEN variable already set.
POLICY_NAME=$1

../hclpolicy2json.sh "${POLICY_NAME}".hcl > "${POLICY_NAME}.json"

if [ -n POLICY_NAME ] ; then
    echo "  ##  ${0}: Provisioning Vault at ${VAULT_ADDR} with the Vault Policy named ${POLICY_NAME}"
    echo "curl -k \
           --header \"X-Vault-Token: ${VAULT_TOKEN}\" \
           --request PUT \
           --data @$POLICY_NAME.json \
           \"${VAULT_ADDR}/v1/sys/policy/${POLICY_NAME}\""
    curl -k \
           --header "X-Vault-Token: ${VAULT_TOKEN}" \
           --request PUT \
           --data @$POLICY_NAME.json \
           "${VAULT_ADDR}/v1/sys/policy/${POLICY_NAME}"
else
    echo "POLICY_NAME is missing. Make sure to provide a policy name as a parameter, e.g. admin.sh admin, and have a .hcl file, e.g. admin.hcl, with that same name."
fi
