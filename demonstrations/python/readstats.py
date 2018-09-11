#!/usr/bin/env python3
import os
import json
import psycopg2
import requests

VAULT_URL = 'http://192.168.13.37:8200'
VAULT_TOKEN = os.environ['VAULT_TOKEN']

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
