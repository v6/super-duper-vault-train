#!/usr/bin/env python3
import os
import json
import psycopg2
import requests


  ##  Make sure the environment variables VAULT_ADDR and VAULT_TOKEN are both set before running this.
VAULT_URL = os.environ['VAULT_ADDR']
VAULT_TOKEN = os.environ['VAULT_TOKEN']

  ##  Make sure that the PostGRESQL database is running, and provisioned with
  ##  the password used below, before running this. 


def get_from_vault(vault_path='cubbyhole/default'):
    headers = {'X-Vault-Token': VAULT_TOKEN}
    print('  ##  Get a Secret from Vault  ##')
    print('  ##  Path: ' + vault_path)
    response = requests.get(VAULT_URL + '/v1/' + vault_path, headers=headers)
    print(response.text)
    return json.loads(response.text)['data']['postgres_passphrase']

conn = psycopg2.connect(host="localhost",user="postgres", password=get_from_vault('cubbyhole/postgres'))

data_cursor = conn.cursor()
data_cursor.execute("CREATE TABLE IF NOT EXISTS stats (id serial PRIMARY KEY, num integer, data varchar);")
data_cursor.execute("INSERT INTO stats (num, data) VALUES (%s, %s)",(100, "abc'def"))


data_cursor.execute("SELECT * FROM stats;")
print(data_cursor.fetchone())


conn.commit()

data_cursor.close()
conn.close()
