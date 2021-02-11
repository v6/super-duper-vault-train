## Vault Certificates

Vagrant will create self-signed
certificates for each of the
Vault nodes, install them,
and add them to the root trust store.

If you want to see these certificates,
check this folder after Vagrant
has provisioned the Vault cluster. 

The `generate-sslcerts.sh` script
also downloads and modifies a
a CA bundle to include the newly
generated Vault certificates, at
`certs/anchors`.
