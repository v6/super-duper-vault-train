#!/usr/bin/env bash
  ##  Create a policy in Vault
  ##  Make sure to have the $VAULT_TOKEN variable already set.
POLICY_NAME=$1
ENVIRONMENT_NAME=$2
echo Current directory is $PWD

ls "../"
stat "../data${ENVIRONMENT_NAME}/sys/policies/acl/${POLICY_NAME}.hcl"
BASH_SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BASH_SOURCE="${BASH_SOURCE[0]}"

cd $BASH_SOURCE_DIR
pwd
./hclpolicy2json.sh "../data${ENVIRONMENT_NAME}/sys/policies/acl/${POLICY_NAME}.hcl" > "../data${ENVIRONMENT_NAME}/sys/policies/acl/${POLICY_NAME}.json"

if [ -n POLICY_NAME ] ; then
    echo "  ##  ${0}: Provisioning Vault at ${VAULT_ADDR} with the Vault Policy named ${POLICY_NAME} from the file ../data${ENVIRONMENT_NAME}/sys/policies/acl/${POLICY_NAME}.hcl"
    echo "curl -k \
           --header \"X-Vault-Token: ${VAULT_TOKEN}\" \
           --request PUT \
           --data @../data$ENVIRONMENT_NAME/sys/policies/acl/$POLICY_NAME.json \
           \"${VAULT_ADDR}/v1/sys/policies/acl/${POLICY_NAME}\""
    curl -k \
           --header "X-Vault-Token: ${VAULT_TOKEN}" \
           --request PUT \
           --data @../data$ENVIRONMENT_NAME/sys/policies/acl/$POLICY_NAME.json \
           "${VAULT_ADDR}/v1/sys/policies/acl/${POLICY_NAME}"
./checkpolicy.sh $POLICY_NAME
else
    echo "../data/sys/policies/acl/POLICY_NAME is missing. Make sure to provide a policy name as a parameter, e.g. admin.sh admin, and have a .hcl file, e.g. admin.hcl, with that same name."
fi
