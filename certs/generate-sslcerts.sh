#!/usr/bin/env bash

# input IP address 
IP=$1

# Set the TLD domain we want to use
BASE_DOMAIN="basanese.com"

# Days for the cert to live
DAYS=365

# A blank passphrase
PASSPHRASE=""

# The file name can be anything
FILE_NAME="/vagrant/certs/$BASE_DOMAIN-${IP}"

# Remove previous keys
echo "Removing existing certs like $FILE_NAME.*"
chmod 770 $FILE_NAME.crt || true
chmod 770 $FILE_NAME.info || true
chmod 770 $FILE_NAME.key || true
rm $FILE_NAME.*
rm -f $FILE_NAME.crt
rm -f $FILE_NAME.info
rm -f $FILE_NAME.key

# Generated configuration file
CONFIG_FILE="$FILE_NAME.conf"

cat > $CONFIG_FILE <<-EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
x509_extensions = v3_req
distinguished_name = dn

[dn]
C = US
ST = CA
L = SanJose
O = Basanese
OU = InformationSecurity
emailAddress = devops@$BASE_DOMAIN
CN = $BASE_DOMAIN

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.$BASE_DOMAIN
DNS.2 = $BASE_DOMAIN
IP = ${IP}
EOF

echo "Generating certs for $BASE_DOMAIN"

# Generate our Private Key, CSR and Certificate
# Use SHA-2 as SHA-1 is unsupported from Jan 1, 2017

openssl req -new -x509 -newkey rsa:4096 \
	-sha256 -nodes -keyout "$FILE_NAME.key" \
	-days $DAYS -out "$FILE_NAME.crt" \
	-passin pass:$PASSPHRASE -config "$CONFIG_FILE"

# OPTIONAL - write an info to see the details of the generated crt
openssl x509 -noout -fingerprint -text < "$FILE_NAME.crt" > "$FILE_NAME.info"

# Protect the key
chmod 400 "$FILE_NAME.key"

##  Deploy the Vault Certificate

cp "$FILE_NAME.key" /etc/vault.d/tls/vault.key
cp "$FILE_NAME.crt" /etc/vault.d/tls/vault.crt
chown vault:vault /etc/vault.d/tls/vault.key
chown vault:vault /etc/vault.d/tls/vault.crt


# Create a Certificate Bundle
# Update root trust store
# Set environment variable for CLI use

  ##  Create a separate place to work with Trust Anchors
mkdir -p /vagrant/certs/anchors/

  ##  Download a CA bundle to the Trust Anchors folder, and combine Vault certs there, too. 
curl --silent https://curl.haxx.se/ca/cacert.pem -o /vagrant/certs/anchors/cacert.pem
cat /vagrant/certs/*.crt >> /vagrant/certs/anchors/vault_certs_bundle.crt

  ##  Update OS Root Trust Store
  ##  Add Curl's default cert bundle to the root trust store, and
  ##  add the combined Vault certificates to it.
cat /vagrant/certs/anchors/vault_certs_bundle.crt >> /vagrant/certs/anchors/cacert.pem
cp /vagrant/certs/anchors/cacert.pem /etc/pki/tls/certs/ca-bundle.crt
cp /vagrant/certs/anchors/vault_certs_bundle.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

##  In case update-ca-trust is being unreliable: 
cp $FILE_NAME.crt /etc/pki/tls/certs/
cd /etc/pki/tls/certs/
ls "${BASE_DOMAIN}-${IP}.crt"
echo "${BASE_DOMAIN}-${IP}.crt"
sudo ln -sv "${BASE_DOMAIN}-${IP}.crt" $(openssl x509 -in "${BASE_DOMAIN}-${IP}.crt" -noout -hash).0

##  Update some Environment Variables for 
##  convenient use of Vault from the CLI.

echo "export CURL_CA_BUNDLE=/vagrant/certs/anchors/cacert.pem" >> /home/vagrant/.bashrc
echo "export CURL_CA_BUNDLE=/vagrant/certs/anchors/cacert.pem" >> ~/.bashrc
echo "export VAULT_CACERT=/vagrant/certs/anchors/cacert.pem" >> /home/vagrant/.bashrc
echo "export VAULT_CACERT=/vagrant/certs/anchors/cacert.pem" >> ~/.bashrc
echo "export VAULT_CAPATH=/vagrant/certs/anchors/" >> /home/vagrant/.bashrc
echo "export VAULT_CAPATH=/vagrant/certs/anchors/" >> ~/.bashrc
echo "export VAULT_ADDR=https://${IP}:8200" >> /home/vagrant/.bashrc
echo "export VAULT_ADDR=https://${IP}:8200" >> ~/.bashrc
