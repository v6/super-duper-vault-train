export VAULT_CONSUL_HTTP_TOKEN=$(tac $(ls /vagrant/*vault_consul_http_token.txt | head -n 1) | egrep -m 1 .)
echo VAULT_CONSUL_HTTP_TOKEN
sudo bash -c "cat >/etc/vault.d/vault.hcl" << 'EOF'
backend "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
  token   = "a4c878e5-a0eb-48ef-b6b4-00e18a146bf2"
}
listener "tcp" {
  address     = "0.0.0.0:8200"
  # tls_disable = 1
  tls_disable = 0
  tls_cert_file = "/etc/vault.d/tls/vault.crt"
  tls_key_file  = "/etc/vault.d/tls/vault.key"
}
api_addr = "https://192.168.13.35:8200"
plugin_directory = "/etc/vault.d/plugin"
ui=true
EOF

echo "sed without -i"
sed "s%VAULT_CONSUL_HTTP_TOKEN%${VAULT_CONSUL_HTTP_TOKEN}%" "/etc/vault.d/vault.hcl"
echo "sed -i"
sed -i "s%VAULT_CONSUL_HTTP_TOKEN%${VAULT_CONSUL_HTTP_TOKEN}%" "/etc/vault.d/vault.hcl"

