KEY_NAME='my-key'
PLAINTEXT='Access Control, Secrets Management, Secure Introduction and Encryption from Nathan Basanese: Encryption Services Galore!'
PLAINTEXT_BASE64='QWNjZXNzIENvbnRyb2wsIFNlY3JldHMgTWFuYWdlbWVudCwgU2VjdXJlIEludHJvZHVjdGlvbiBhbmQgRW5jcnlwdGlvbiBmcm9tIE5hdGhhbiBCYXNhbmVzZTogRW5jcnlwdGlvbiBTZXJ2aWNlcyBHYWxvcmUh'

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
     --data "{\"plaintext\": \"${PLAINTEXT_BASE64}\"}" \
    "${VAULT_ADDR}/v1/transit/encrypt/${KEY_NAME}/2"
