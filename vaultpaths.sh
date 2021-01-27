#!/usr/bin/env bash

VAULT_BINARY_FOLDER=$1
VAULT_FOLDER_PREFIX=$2
  ##  If someone passes the last argument, put all files other than the binary under 
  ##  a specific folder.
  ##  If no one passes in a third argument, this has no effect. 
  ##  Usage: 
  ##          vaultpaths.sh <VAULT_BINARY_FOLDER> [VAULT_FOLDER_PREFIX]
  ##  
  ##  Example Usage: 
  ##          vaultpaths.sh "/usr/local/bin" "/opt/vault"

mkdir -p -v -m 0755 "${VAULT_BINARY_FOLDER:-/usr/local/bin}"
echo "Vault Path: ${VAULT_BINARY_FOLDER}/vault"

  ## Set up paths and a file for logging
mkdir -p -v -m 0700 "${VAULT_LOG_FOLDER}"
touch "${VAULT_LOG_FOLDER}/vault_audit.log"
chmod 0600 "${VAULT_LOG_FOLDER}/vault_audit.log"
chown vault:vault "${VAULT_LOG_FOLDER}"
chown vault:vault "${VAULT_LOG_FOLDER}/vault_audit.log"

  ## Set up paths for TLS Certificates
mkdir -p -v -m 0755 "${VAULT_FOLDER_PREFIX}/etc/ssl/vault/"
chown -R vault:vault "${VAULT_FOLDER_PREFIX}/etc/vault.d" "${VAULT_FOLDER_PREFIX}/etc/ssl/vault/"

  ## Set up paths for the Vault Configuration & Plugins
mkdir -p -v -m 755 "${VAULT_FOLDER_PREFIX}/etc/vault.d"
mkdir -p -v -m 755 "${VAULT_FOLDER_PREFIX}/etc/vault.d/plugin"

  ## Set permissions for the Vault Configuration File
touch "${VAULT_FOLDER_PREFIX}/etc/vault.d/vault.hcl"
chmod -R 0644 "$VAULT_FOLDER_PREFIX"/etc/vault.d/*



  ## Set paths for the Vault Data, in case there is any
mkdir -p -v -m 0700 "${VAULT_FOLDER_PREFIX}/opt/data/vault/"
chmod -R 0644 "$VAULT_FOLDER_PREFIX/opt/data/vault/"

  ## Set permissions for the Vault Binary
touch "${VAULT_BINARY_FOLDER}/vault"
chown vault:vault "${VAULT_BINARY_FOLDER}/vault"
chmod 755 "${VAULT_BINARY_FOLDER}/vault"

echo 'export VAULT_ADDR=http://localhost:8200  ##  Add Vault address to startup script'|sudo tee '/etc/profile.d/vault.sh'
