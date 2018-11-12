#!/usr/bin/env python3.7
'''Vault LDAP Linker

Vault LDAP Linker Maps a list of LDAP Groups
to Vault Policies.
You can run this periodically to keep our mappings
up to date, or use it as the basis for another
integration

Usage:
  ldapgrouper.py (--ldap_group <group> | --ldap_user <user>) --vault_policy <policy> [<MOUNT_POINT>]
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

ARGUMENTS = docopt(__doc__)  ##  Parse the docstring for CLI usage.
GROUP = ARGUMENTS['<group>']
USER = ARGUMENTS['<user>']
POLICY = ARGUMENTS['<policy>']
if POLICY: 
    POLICY_LIST = POLICY.split()
else: 
    print ("No Policy Defined, listing policies and such")
MOUNT_POINT = ARGUMENTS['<MOUNT_POINT>']

VAULT_DEFAULT_TOKEN = os.environ['VAULT_TOKEN']
VAULT_DEFAULT_URL = os.environ['VAULT_ADDR']
VAULT_HEADERS = {"X-Vault-Token": os.environ['VAULT_TOKEN']}

if not MOUNT_POINT:
    MOUNT_POINT = 'ldap'

if GROUP:
    print('Linking group ' + GROUP + ' to Vault Policy ' + POLICY \
     + ' at Vault Authentication Mount Point ' + MOUNT_POINT)
elif USER:
    print('Linking user ' + USER + ' to Vault Policy ' + POLICY \
     + ' at Vault Authentication Mount Point ' + MOUNT_POINT)
else: 
    print ('No USER or GROUP defined, listing info.')

# Using plaintext
CLIENT = hvac.Client(url='http://localhost:8200', token=os.environ['VAULT_TOKEN'])

EXAMPLE_PAYLOAD = {
    "key": "",
}

  ##  LDAP
LDAP_CLIENT = hvac.Client(url=VAULT_DEFAULT_URL, token=VAULT_DEFAULT_TOKEN)
assert LDAP_CLIENT.is_authenticated() # => True

if GROUP:
  ##  Create an LDAP Group Mapping
    LDAP_CLIENT.ldap.create_or_update_group(
        name=GROUP,
        policies=POLICY_LIST,
        mount_point='ldap'
    )
elif USER:
  ##  Map an LDAP User to a Vault Policy
    LDAP_CLIENT.ldap.create_or_update_user(
        username=USER,
        policies=POLICY_LIST,
        groups=None,
        mount_point='ldap'
    )
else: 
    print ('No USER or GROUP defined, listing info.')

  ##  List LDAP Group Mappings
  ##  https://hvac.readthedocs.io/en/latest/usage/auth_methods/ldap.html
RESPONSE = requests.get(VAULT_DEFAULT_URL + '/v1/sys/health', headers=VAULT_HEADERS)
print(json.dumps(json.loads(RESPONSE.text), indent=4, sort_keys=False))
LDAP_GROUPS = LDAP_CLIENT.ldap.list_groups()
print('The following groups are configured in the LDAP auth method:\
       {groups}'.format(groups=','.join(LDAP_GROUPS['data']['keys'])))

  ##  List policies associated with the ldap_groups
for ldap_group in LDAP_GROUPS['data']['keys']:
    print('  ##  LDAP Group ' + str(ldap_group))
    print(LDAP_CLIENT.ldap.read_group(ldap_group, 'ldap')['data']['policies'])
