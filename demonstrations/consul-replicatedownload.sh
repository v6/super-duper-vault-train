#!/usr/bin/env bash
VERSION=$1
INSTALLDIR='/usr/local/bin/'
curl --version

echo "  ##  Consul Replicate Release: ${VERSION}"
echo "  ##  Consul Replicate Download: https://releases.hashicorp.com/consul-replicate/${VERSION}/consul-replicate_${VERSION}_linux_amd64.zip"
echo '  ##  https://github.com/hashicorp/consul-replicate#installation'
curl -s -o "/tmp/consul-replicate_${VERSION}_linux_amd64.zip" "https://releases.hashicorp.com/consul-replicate/${VERSION}/consul-replicate_${VERSION}_linux_amd64.zip"

unzip -o "/tmp/consul-replicate_${VERSION}_linux_amd64.zip" -d "${INSTALLDIR}"
mkdir -v -m 755 '/etc/consul-replicate.d'
chown -R consul-replicate:consul-replicate '/etc/consul-replicate.d'
touch '/etc/consul-replicate.d/consul-replicate.hcl'
chmod -R 0644 /etc/consul-replicate.d/*
chown consul-replicate:consul-replicate '/usr/local/bin/consul-replicate'
echo 'consul-replicate --version  ##  Result should contain v0.4.0'
consul-replicate --version
