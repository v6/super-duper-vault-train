export VAULT_CONSUL_HTTP_TOKEN=$(cat $(ls /vagrant/*vault_consul_http_token.txt | head -n 1))
echo VAULT_CONSUL_HTTP_TOKEN
sudo bash -c "cat >/etc/vault.d/vault.hcl" << 'EOF'
backend "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}
plugin_directory = "/etc/vault.d/plugin"
ui=true
EOF

sed "s%VAULT_CONSUL_HTTP_TOKEN%${VAULT_CONSUL_HTTP_TOKEN}%" /etc/vault.d/vault.hcl
sed -i "s%VAULT_CONSUL_HTTP_TOKEN%${VAULT_CONSUL_HTTP_TOKEN}%" /etc/vault.d/vault.hcl
