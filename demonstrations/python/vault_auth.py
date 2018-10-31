#!/usr/bin/env python3
'''Authenticate to Vault

Accept credentials interactively, and
use them to authenticate to Vault on
behalf of a user.

The User Name and Pass Phrase do not touch the disk. 

Preconditions: 
    User knows AD Password and user name.
    User is available for interactive use.
    VAULT_ADDR is set to a working Vault.

Postconditions:
    Environment Variable VAULT_TOKEN
    is populated with a valid Vault
    Token.'''

import os
import requests
import json

VAULT_ADDR = os.environ['VAULT_ADDR']

user_name = input('  ##  Enter your username or Group') 

pass_phrase = input('  ##  Enter your passphrase')

testdict = {'password': pass_phrase}
print(testdict)

string_of_json_input = '{"password": "' + pass_phrase + '"}'

vault_auth_method_name = 'ldap-login-method'  ##  E.g. 'ldap' or 'duomfa'

print (VAULT_ADDR + '/v1/auth/ldap/login' + user_name)
auth_response = requests.post(VAULT_ADDR + '/v1/auth/' + vault_auth_method_name + '/login/' + user_name, data = string_of_json_input, verify=False)
parsed_auth_response = json.dumps(auth_response.json(), indent=4)
print(parsed_auth_response)
client_token = json.loads(auth_response.text)['auth']['client_token']
print(client_token)
os.environ['VAULT_TOKEN'] = client_token
