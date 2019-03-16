
  ##  Self-Signed Root Certificate  ##
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem -config csr_config.conf

  ##  Device Certificate  ##
openssl genrsa -out device.key 2048
openssl req -new -key device.key -out device.csr -config csr_config.conf
openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 500 -sha256
