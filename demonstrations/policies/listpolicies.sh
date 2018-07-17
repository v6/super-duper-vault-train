export VAULT_TOKEN=$1

  ##  Get global list of policies
curl -k \
    --request GET \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    "$VAULT_ADDR/v1/sys/policy" | jq

  ##  List specific policy
curl -k \
    --request GET \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    "$VAULT_ADDR/v1/sys/policy/admin" | jq
