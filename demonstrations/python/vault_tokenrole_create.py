#!/usr/bin/env python3.7
'''This creates a TokenRole authentication method
based on environment variables'''
import os
import json
import requests

VAULT_ADDR = os.getenv('VAULT_ADDR', 'http://192.168.13.37:8200')
TOKENROLE_NAME = 'mongo1a_monitoring'
ALLOWED_POLICIES = ['dev']
CIDR = ["127.0.0.1/32", "128.252.0.0/16"]
VAULT_TOKEN = os.environ['VAULT_TOKEN']
VAULT_TOKEN = '7cd2c06c-b0e7-c3df-13c1-d1d4cd92189d'

data = {
  "allowed_policies": ALLOWED_POLICIES,
  "name": "mongo",
  "orphan": False,
  "bound_cidrs": CIDR,
  "renewable": True 
}

headers = {'X-Vault-Token': VAULT_TOKEN}

print(headers)
print(VAULT_ADDR + '/v1/auth/token/roles/' + TOKENROLE_NAME)
tokenrole_creation_response = requests.post(
    VAULT_ADDR + '/v1/auth/token/roles/' + TOKENROLE_NAME, data=json.dumps(data), verify=False, headers=headers
)

tokenrole_read_response = requests.get(
    VAULT_ADDR + '/v1/auth/token/roles/' + TOKENROLE_NAME, verify=False, headers=headers
)

print(json.dumps(tokenrole_read_response.json(), indent=4))

try: 
    print(json.dumps(tokenrole_creation_response.json(), indent=4))
except json.decoder.JSONDecodeError: 
    print(tokenrole_creation_response.text)
