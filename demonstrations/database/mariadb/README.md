

The database secrets engine generates database credentials dynamically based on configured roles. It works with a number of different databases through a plugin interface. There are a number of builtin database types and an exposed framework for running custom database types for extendability. This means that services that need to access a database no longer need to hardcode credentials: they can request them from Vault, and use Vault's leasing mechanism to more easily roll keys.

https://www.vaultproject.io/docs/secrets/databases/index.html


# MariaDB Demo

Skip forward to **Attempt to Connect** if you see that mysql is already installed on the db. 

You can check as follows: 

    [vagrant@bdload2 ~]$ mysql
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 13
    Server version: 5.5.60-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]>

If you see command not found, you need to install MySQL. If you see the above output, skip forward to **Attempt to Connect**

If Ansible hasn't done this already, create a database on the db machine: 

    vagrant ssh db
    sudo yum install -y mysql-server mysql-contrib
    sudo mysql-setup initdb
    sudo systemctl start mysql
    sudo systemctl enable mysql
    sudo passwd postgres
    su - postgres

Now we need to make the DB allow remote connections (Skip forward to if Ansible has run): 

https://stackoverflow.com/a/14779244/2146138

Next, search for mysql.conf and edit it as desired. 

    sudo find / -name "mysql.conf"
    vi /var/lib/pgsql/data/mysql.conf

You can also try searching for my.cnf

Add a line to the end: 

    echo "listen_addresses = '*'" >> /var/lib/pgsql/data/mysql.conf

Or replace as follows: 

    sudo sed -i.bak "s/bind-address = 127.0.0.1/#bind-address = '*'/g" /etc/mysql/my.cnf


Now find a way to set up grants for remote users as desired

Follow these instructions:  
https://stackoverflow.com/a/8348560/2146138

Restart MariaDB as follows: 

    sudo systemctl restart mysql

# Attempt to connect: 

    mysql -u root -h 192.168.13.187 --pass

Suggested password: 

    errydayimSNUFFLIN


Once you connect, set up a database called testdb


https://wiki.mysql.org/wiki/First_steps

    CREATE DATABASE testdb;

https://www.tutorialspoint.com/mysql/mysql_create_database.htm

Example: 

    [vagrant@bdload2 vagrant]$ mysql -u root -h 192.168.13.187 --pass
    Enter password:
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 12
    Server version: 5.5.60-MariaDB MariaDB Server
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> CREATE DATABASE testdb
        -> ;
    Query OK, 1 row affected (0.00 sec)

https://mariadb.com/kb/en/library/create-database/ 
https://www.tutorialspoint.com/mariadb/mariadb_create_database.htm

Then create tables (link later?):

    MariaDB [(none)]> CREATE TABLE mastertable (a int DEFAULT (1+1), b int DEFAULT (a+1));
    MariaDB [(none)]> CREATE TABLE slavetable (a bigint primary key DEFAULT UUID_SHORT());

https://www.tutorialspoint.com/mariadb/mariadb_create_tables.htm
https://mariadb.com/kb/en/library/create-table/

 # Vault

Now it's time to connect to Vault, using the guide at the following link:

https://learn.hashicorp.com/vault/secrets-management/sm-dynamic-secrets

Add the `vault_db_engine_admin` policy, make a token from it, and use that token to log in: 


    (mariadb-demo) 👾 ls
    README.md			mariadb.json			readonly.sql
    apps-policy.hcl			readonly.json			vault_db_engine_admin.hcl
    (mariadb-demo) 👾
    (mariadb-demo) 👾 vagrant ssh instance7
    Last login: Fri Nov  2 18:52:44 2018 from 10.0.2.2
    [vagrant@instance7 ~]$ cd /vagrant/demonstrations/database/mariadb
    [vagrant@instance7 mariadb]$ pwd
    /vagrant/demonstrations/database/mariadb
    [vagrant@instance7 mariadb]$ ls
    apps-policy.hcl  mariadb.json  README.md  readonly.json  readonly.sql  vault_db_engine_admin.hcl
    [vagrant@instance7 mariadb]$ vault policy write vault_db_engine_admin vault_db_engine_admin.hcl
    Success! Uploaded policy: vault_db_engine_admin
    [vagrant@instance7 mariadb]$ cat vault_db_engine_admin
    cat: vault_db_engine_admin: No such file or directory
    [vagrant@instance7 mariadb]$ cat vault_db_engine_admin.hcl
    # Mount secret engines
    path "sys/mounts/*" {
      capabilities = [ "create", "read", "update", "delete", "list" ]
    }
    
    # Configure the database secret engine and create roles
    path "database/*" {
      capabilities = [ "create", "read", "update", "delete", "list" ]
    }
    
    # Configure the mariadb database secret engine and create roles
    path "mariadb/*" {
      capabilities = [ "create", "read", "update", "delete", "list" ]
    }

    # Write ACL policies
    path "sys/policy/*" {
      capabilities = [ "create", "read", "update", "delete", "list" ]
    }
    
    # Manage tokens for verification
    path "auth/token/create" {
      capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
    }
    [vagrant@instance7 mariadb]$


    vault token create -policy=vault_db_engine_admin
    Key                  Value
    ---                  -----
    token                e49fd95b-36e5-edd8-535f-588e96b456ab
    token_accessor       bfd3e36b-707d-dfee-8251-f1b0d29d82e6
    token_duration       768h
    token_renewable      true
    token_policies       ["default" "vault_db_engine_admin"]
    identity_policies    []
    policies             ["default" "vault_db_engine_admin"]



    vault login e49fd95b-36e5-edd8-535f-588e96b456ab
    vault write database/config/mysql plugin_name=mysql-database-plugin       allowed_roles=readonly connection_url='mysql://postgres:r00tp-ssbuckphrase@192.168.13.187:5432/testdb?sslmode=disable' verify_connection=false
    WARNING! The following warnings were returned from Vault:
    
      * Password found in connection_url, use a templated url to enable root
      rotation and prevent read access to password information.

OR
    export VAULT_DBA_TOKEN=e49fd95b-36e5-edd8-535f-588e96b456ab
    export VAULT_TOKEN=$VAULT_DBA_TOKEN
    [vagrant@instance7 mariadb]$ cat mariadb.json
    {
        "db_name": "mariadb",
        "plugin_name": "mysql-database-plugin",
        "allowed_roles": "readonly",
        "connection_url": "mysql://{{username}}:{{password}}@192.168.13.187:3306/testdb",
        "max_open_connections": 5,
        "max_connection_lifetime": "30s",
        "username": "root",
        "password": "errydayimSNUFFLIN",
        "verify_connection": false
    }
    [vagrant@instance7 mariadb]$ curl --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST --data @mariadb.json     http://127.0.0.1:8200/v1/database/config/mariadb | jq
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   505  100   162  100   343  15841  33541 --:--:-- --:--:-- --:--:-- 34300
    {
      "request_id": "074c93bb-8a8d-75be-2068-72d8361d52a7",
      "lease_id": "",
      "renewable": false,
      "lease_duration": 0,
      "data": null,
      "wrap_info": null,
      "warnings": null,
      "auth": null
    }
    [vagrant@instance7 mariadb]$



# Enable MariaDB Database Secrets Engine

Related Docs: https://www.vaultproject.io/api/system/mounts.html#enable-secrets-engine

    cat enable_mariadb_secrets_engine.json
    {
      "type": "database",
      "config": {
        "force_no_cache": true
      }
    }

    curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @enable_mariadb_secrets_engine.json \
    "${VAULT_ADDR}/v1/sys/mounts/mariadb"
    
    curl -sk \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    "${VAULT_ADDR}/v1/sys/mounts/mariadb/tune" | jq

Example Output: 


    [vagrant@instance7 mariadb]$     curl \
    >     --header "X-Vault-Token: ${VAULT_TOKEN}" \
    >     --request POST \
    >     --data @enable_mariadb_secrets_engine.json \
    >     http://127.0.0.1:8200/v1/sys/mounts/mariadb
    [vagrant@instance7 mariadb]$ curl -sk \
    >     --header "X-Vault-Token: ${VAULT_TOKEN}" \
    >     "${VAULT_ADDR}/v1/sys/mounts/mariadb/tune" | jq
    {
      "default_lease_ttl": 2764800,
      "max_lease_ttl": 2764800,
      "force_no_cache": true,
      "request_id": "8db2c8ad-3679-c9ae-5b1d-b984d5808b07",
      "lease_id": "",
      "renewable": false,
      "lease_duration": 0,
      "data": {
        "default_lease_ttl": 2764800,
        "force_no_cache": true,
        "max_lease_ttl": 2764800
      },
      "wrap_info": null,
      "warnings": null,
      "auth": null
    }

Then: 

 # Configure MariaDB Mount

    curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @mariadb.json \
    http://127.0.0.1:8200/v1/mariadb/config/mariadb

Example: 

    [vagrant@instance7 mariadb]$ curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @mariadb.json     http://127.0.0.1:8200/v1/mariadb/config/mariadb
    {"request_id":"93aee9eb-34e4-2220-e330-9400ccb8efd6","lease_id":"","renewable":false,"lease_duration":0,"data":null,"wrap_info":null,"warnings":null,"auth":null}
    [vagrant@instance7 mariadb]$

 # Create the Role

    curl --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST --data @readonly.json "${VAULT_ADDR}/v1/mariadb/roles/readonly"

Example: 


    [vagrant@instance7 mariadb]$ curl --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST --data @readonly.json "${VAULT_ADDR}/v1/mariadb/roles/readonly"  ##  Has no output, just a silent HTTP 200 response
    [vagrant@instance7 mariadb]$


Create Apps policy: 

    [vagrant@instance7 mariadb]$ ls
    apps-policy.hcl  mariadb.json  README.md  readonly.json  readonly.sql  vault_db_engine_admin.hcl
    [vagrant@instance7 mariadb]$ vault policy write apps apps-policy.hcl
    Success! Uploaded policy: apps
    [vagrant@instance7 mariadb]$


Now switch to the apps policy.

    [vagrant@instance7 mariadb]$ vault token create -policy=apps
    Key                  Value
    ---                  -----
    token                41f4a763-0b2d-fd56-1354-1519540cd3f0
    token_accessor       9bcc7812-090a-3b32-1e8e-9920e2df2a35
    token_duration       768h
    token_renewable      true
    token_policies       ["apps" "default"]
    identity_policies    []
    policies             ["apps" "default"]
    [vagrant@instance7 mariadb]$
    
    export VAULT_APPS_TOKEN=41f4a763-0b2d-fd56-1354-1519540cd3f0
    export VAULT_TOKEN=$VAULT_APPS_TOKEN


Get a dynamic DB credential: 

    [vagrant@instance7 mariadb]$ curl --header "X-Vault-Token: ${VAULT_TOKEN}"        --request GET        http://127.0.0.1:8200/v1/mariadb/creds/readonly | jq
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   300  100   300    0     0  13280      0 --:--:-- --:--:-- --:--:-- 13636
    {
      "request_id": "0a1a3ab7-7d37-4769-3f55-a8e44c952e40",
      "lease_id": "mariadb/creds/readonly/6dab49a3-cc75-a632-75ea-fe72a1550b9b",
      "renewable": true,
      "lease_duration": 3600,
      "data": {
        "password": "A1a-1Lw2J0TnC5WdgF9W",
        "username": "v-token-readonly-m3RFNstLKnZgRvz"
      },
      "wrap_info": null,
      "warnings": null,
      "auth": null
    }

Use it to log in, and check that you can't drop tables: 

    [vagrant@instance7 mariadb]$ mysql -h 192.168.13.187 -U v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143
    Password for user v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143:
    mysql: FATAL:  database "v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143" does not exist
    [vagrant@instance7 mariadb]$ mysql -h 192.168.13.187 -U v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143 testdb
    Password for user v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143:
    mysql (9.2.24)
    Type "help" for help.
    
    testdb=> \l
                                      List of databases
       Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
    -----------+----------+----------+-------------+-------------+-----------------------
     postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
     template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
               |          |          |             |             | postgres=CTc/postgres
     template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
               |          |          |             |             | postgres=CTc/postgres
     testdb    | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres         +
               |          |          |             |             | postgres=CTc/postgres
    (4 rows)
    
    testdb=> \d
              List of relations
     Schema |  Name   | Type  |  Owner
    --------+---------+-------+----------
     public | company | table | postgres
    (1 row)
    
    testdb=> DROP TABLE company
    testdb-> \d
              List of relations
     Schema |  Name   | Type  |  Owner
    --------+---------+-------+----------
     public | company | table | postgres
    (1 row)
    
    testdb->


On your vagrant ssh session to the vagrant VM named db: 


    [vagrant@bdload2 vagrant]$ mysql -h 192.168.13.187 -U postgres --pass
    Password for user postgres:
    mysql (9.2.24)
    Type "help" for help.
    
    postgres=# \d
              List of relations
     Schema |  Name   | Type  |  Owner
    --------+---------+-------+----------
     public | company | table | postgres
    (1 row)
    
    postgres=# help
    You are using mysql, the command-line interface to PostgreSQL.
    Type:  \copyright for distribution terms
           \h for help with SQL commands
           \? for help with mysql commands
           \g or terminate with semicolon to execute query
           \q to quit
    postgres=# \du
                                                     List of roles
                        Role name                     |                   Attributes                   | M
    ember of
    --------------------------------------------------+------------------------------------------------+--
    ---------
     postgres                                         | Superuser, Create role, Create DB, Replication | {
    }
     v-root-readonly-2Um53obdQLRpbsoEUbVh-1541182007  | Password valid until 2018-11-02 19:06:52+00    | {
    }
     v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143 | Password valid until 2018-11-02 19:09:08+00    | {
    }
    
    postgres=#


# Rotate the Root Passphrase

We're going to have Vault rotate the  
passphrase without telling us what it is, because  
it's probably not a good idea to leave a  
pass phrase the same as the contents of a JSON payload or CLI input. 

    vault write -force mariadb/rotate-root/mariadb
