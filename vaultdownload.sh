#!/usr/bin/env bash


  ##  Version determined by $1, e.g. 0.10.2
curl -s -o "/tmp/vault_${1}_linux_amd64.zip" "https://releases.hashicorp.com/vault/${1}/vault_${1}_linux_amd64.zip"
unzip -o /tmp/vault_${1}_linux_amd64.zip -d /usr/local/bin/
echo "Vault Release: ${1}"
echo "Vault Download: https://releases.hashicorp.com/vault/${1}/vault_${1}_linux_amd64.zip"

mkdir -p -v -m 0755 /etc/ssl/vault/
mkdir -p -v -m 755 /etc/vault.d
mkdir -p -v -m 755 /etc/vault.d/plugin
chown -R vault:vault /etc/vault.d /etc/ssl/vault
touch /etc/vault.d/vault.hcl
chmod -R 0644 /etc/vault.d/*
chown vault:vault /usr/local/bin/vault
chmod 755 /usr/local/bin/vault

echo 'export VAULT_ADDR=http://localhost:8200  ##  Add Vault address to startup script'|sudo tee /etc/profile.d/vault.sh
