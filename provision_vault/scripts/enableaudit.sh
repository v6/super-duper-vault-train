  ##  Make sure to set the VAULT_TOKEN to a root token id.
  ##  Also make sure you have already set the 
  ##  VAULT_ADDR environment variable to the 
  ##  target Vault's IP address and port, 
  ##  e.g. 192.168.13.37:8200, before running this.

  ##  List the Enabled Audit Devices
  ##  https://www.vaultproject.io/api/system/audit.html#list-enabled-audit-devices

  ##  Prefix, if any
VAULT_FOLDER_PREFIX=$1
echo "  ##  Using VAULT_ADDR=${VAULT_ADDR}"
echo "  ##  Using prefix ${VAULT_FOLDER_PREFIX}"
VAULT_AUDIT_FILE_PATH="${VAULT_FOLDER_PREFIX}/var/log/vault_audit.log"

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    "${VAULT_ADDR}/v1/sys/audit"

  ##  Enable File Audit Device
  ##  https://www.vaultproject.io/api/system/audit.html#enable-audit-device
curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request PUT \
    --data "{\"type\": \"file\", \"options\": {\"path\": \"${VAULT_AUDIT_FILE_PATH}\"}}" \
    "${VAULT_ADDR}/v1/sys/audit/audit-file"
