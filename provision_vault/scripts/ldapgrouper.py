#!/usr/bin/env python3.7
'''Vault LDAP Linker

Vault LDAP Linker Maps a list of LDAP Groups
to Vault Policies.
You can run this periodically to keep our mappings
up to date, or use it as the basis for another
integration

Usage:
  ldapgrouper.py --ldap_group <group> --vault_policy <policy>
  ldapgrouper.py list
  ldapgrouper.py goodbye <name>
  ldapgrouper.py (-h | --help)

Options:
  -h --help     Show this screen.

'''

import json
import os
#from hvac import api.auth.Ldap.read_group, read_user, login, Client, create_or_update_group
from docopt import docopt
import hvac
import requests

arguments = docopt(__doc__)  ##  Parse the docstring for CLI usage.
group = arguments['<group>']
policy = arguments['<policy>']

print ('Linking ' + group + ' to Vault Policy ' + policy)

# Using plaintext
client = hvac.Client()
vault_client_001 = hvac.Client(url='http://localhost:8200')
client = hvac.Client(url='http://localhost:8200', token=os.environ['VAULT_TOKEN'])

example_payload = {
    "key": "",
}

VAULT_DEFAULT_TOKEN = os.environ['VAULT_TOKEN']
VAULT_DEFAULT_URL = os.environ['VAULT_ADDR']
VAULT_HEADERS=headers = {"X-Vault-Token": os.environ['VAULT_TOKEN']}

  ##  LDAP

ldap_client = hvac.Client(url=VAULT_DEFAULT_URL, token=VAULT_DEFAULT_TOKEN)
assert ldap_client.is_authenticated() # => True

  ##  Create an LDAP Group Mapping

ldap_client.ldap.create_or_update_group(
    name=group,
    policies=[policy]
)

  ##  List LDAP Group Mappings
  ##  https://hvac.readthedocs.io/en/latest/usage/auth_methods/ldap.html
response = requests.get(VAULT_DEFAULT_URL + '/v1/sys/health', headers=VAULT_HEADERS)
print(json.dumps(json.loads(response.text), indent=4, sort_keys=False))
ldap_groups = ldap_client.ldap.list_groups()
print('The following groups are configured in the LDAP auth method: {groups}'.format(groups=','.join(ldap_groups['data']['keys'])))

  ##  List policies associated with the ldap_groups
for ldap_group in ldap_groups['data']['keys']: 
    print('  ##  LDAP Group ' + str(ldap_group))
    print(ldap_client.ldap.read_group(ldap_group, 'ldap')['data']['policies'])
