#!/usr/bin/env bash

VAULT_RELEASE=$1
VAULT_BINARY_FOLDER=$2
VAULT_FOLDER_PREFIX=$3
  ##  If someone passes in a third argument, put all files other than the binary under 
  ##  a specific folder.
  ##  If no one passes in a third argument, this has no effect. 

  ##  Version determined by $1, e.g. 0.10.2
curl -s -o "/tmp/vault_${1}_linux_amd64.zip" "https://releases.hashicorp.com/vault/${1}/vault_${1}_linux_amd64.zip"
mkdir -p -v -m 0755 "${VAULT_BINARY_FOLDER}"
echo "unzip -o /tmp/vault_${1}_linux_amd64.zip -d ${VAULT_BINARY_FOLDER}"
unzip -o /tmp/vault_${1}_linux_amd64.zip -d "${VAULT_BINARY_FOLDER}"
echo "Vault Release: ${1}"
echo "Vault Download: https://releases.hashicorp.com/vault/${1}/vault_${1}_linux_amd64.zip"
echo "Vault Path: ${2}"

mkdir -p -v -m 0755 "${VAULT_FOLDER_PREFIX}/etc/ssl/vault/"
mkdir -p -v -m 755 "${VAULT_FOLDER_PREFIX}/etc/vault.d"
mkdir -p -v -m 755 "${VAULT_FOLDER_PREFIX}/etc/vault.d/plugin"
chown -R vault:vault "${VAULT_FOLDER_PREFIX}/etc/vault.d" "${VAULT_FOLDER_PREFIX}/etc/ssl/vault"
touch "${VAULT_FOLDER_PREFIX}/etc/vault.d/vault.hcl"
chmod -R 0644 $VAULT_FOLDER_PREFIX/etc/vault.d/*
chown vault:vault "${VAULT_BINARY_FOLDER}/vault"
chmod 755 "${VAULT_BINARY_FOLDER}/vault"

echo 'export VAULT_ADDR=http://localhost:8200  ##  Add Vault address to startup script'|sudo tee /etc/profile.d/vault.sh
