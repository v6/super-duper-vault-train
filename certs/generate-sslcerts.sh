#!/bin/bash
# input IP address 
IP=$1

# Set the TLD domain we want to use
BASE_DOMAIN="digitalonus.com"

# Days for the cert to live
DAYS=1095

# A blank passphrase
PASSPHRASE=""

# Generated configuration file
CONFIG_FILE="config-${IP}.txt"

cat > $CONFIG_FILE <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
x509_extensions = v3_req
distinguished_name = dn

[dn]
C = US
ST = CA
L = SanJose
O = DigitalOnUs
OU = DevOps
emailAddress = devops@$BASE_DOMAIN
CN = $BASE_DOMAIN

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.$BASE_DOMAIN
DNS.2 = $BASE_DOMAIN
IP = ${IP}
EOF

# The file name can be anything
FILE_NAME="$BASE_DOMAIN-${IP}"

# Remove previous keys
echo "Removing existing certs like $FILE_NAME.*"
chmod 770 $FILE_NAME.*
rm $FILE_NAME.*

echo "Generating certs for $BASE_DOMAIN"

# Generate our Private Key, CSR and Certificate
# Use SHA-2 as SHA-1 is unsupported from Jan 1, 2017

openssl req -new -x509 -newkey rsa:2048 -sha256 -nodes -keyout "$FILE_NAME.key" -days $DAYS -out "$FILE_NAME.crt" -passin pass:$PASSPHRASE -config "$CONFIG_FILE"

# OPTIONAL - write an info to see the details of the generated crt
openssl x509 -noout -fingerprint -text < "$FILE_NAME.crt" > "$FILE_NAME.info"

# Protect the key
chmod 400 "$FILE_NAME.key"



