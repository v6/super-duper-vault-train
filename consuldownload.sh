release="$(curl -s https://releases.hashicorp.com/consul/index.json|jq -r '.versions[].version'|grep -v 'ent\|rc\|beta'|tail -n 1)"
#release="$(curl -s https://releases.hashicorp.com/consul/index.json|jq -r '.versions[].version'|tail -n 1)"
download="https://releases.hashicorp.com/consul/${release}/consul_${release}_linux_amd64.zip"
echo "Consul Release: ${release}"
echo "Consul Download: ${download}"
curl -s -o /tmp/consul_${release}_linux_amd64.zip ${download}
unzip -o /tmp/consul_${release}_linux_amd64.zip -d /usr/local/bin/
chmod 755 /usr/local/bin/consul
chown consul:consul /usr/local/bin/consul
mkdir -p -v -m 755 /etc/consul.d
touch /etc/consul.d/consul.json
mkdir -p -v -m 755 /opt/consul/data
chown -R consul:consul /etc/consul.d /opt/consul
chmod -R 0644 /etc/consul.d/*
