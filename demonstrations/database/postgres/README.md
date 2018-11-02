# PostGreSQL Demo

    vagrant up

Create database on the db machine: 

    vagrant ssh db
    sudo yum install -y postgresql-server postgresql-contrib
    sudo postgresql-setup initdb
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    sudo passwd postgres
    su - postgres

Now we need to make the DB allow remote connections: 

https://blog.bigbinary.com/2016/01/23/configure-postgresql-to-allow-remote-connection.html

Next, search for postgresql.conf and edit it as desired. 

    sudo find / -name "postgresql.conf"
    vi /var/lib/pgsql/data/postgresql.conf

Add a line to the end: 

    echo "listen_addresses = '*'" >> /var/lib/pgsql/data/postgresql.conf

Or replace as follows: 

    sudo sed -i.bak "s/#listen_addresses = '127.0.0.1'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

Now find and modify pg_hba.conf as desired

    sudo find / -name "pg_hba.conf"
    vi /var/lib/pgsql/data/postgresql.conf

Follow these instructions:  
http://www.andrew-kirkpatrick.com/2017/05/allow-connection-postgresql-server-outside-localhost/

Edit the file to make sure a line like the following exists at the end: 

    host    all             all             0.0.0.0/0               md5

Restart PostGreSQL as follows: 

    sudo systemctl restart postgresql

Attempt to connect: 

    psql -h 192.168.13.187 -U postgres --pass

Suggested password: 

    r00tp-ssbuckphrase


Once you connect, set up a database called testdb


https://wiki.postgresql.org/wiki/First_steps

    CREATE TABLE testdb

https://www.tutorialspoint.com/postgresql/postgresql_create_database.htm

Example: 

    [vagrant@bdload2 vagrant]$ psql -h 192.168.13.187 -U postgres --pass
    Password for user postgres:
    psql (9.2.24)
    Type "help" for help.
    
    postgres=# select testdb
    postgres-# \d
    No relations found.
    postgres-# create database testdb
    postgres-# \d
    No relations found.
    postgres-# \l
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
    
    postgres-#


Then create a table called Company

    postgres=# CREATE TABLE COMPANY(
    postgres(#    ID INT PRIMARY KEY     NOT NULL,
    postgres(#    NAME           TEXT    NOT NULL,
    postgres(#    AGE            INT     NOT NULL,
    postgres(#    ADDRESS        CHAR(50),
    postgres(#    SALARY         REAL
    postgres(# );
    NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "company_pkey" for table "company"
    CREATE TABLE
    postgres=#

https://www.tutorialspoint.com/postgresql/postgresql_create_table.htm


 # Vault

Now it's time to connect to the Database from one of the Vault servers in this cluster.

Run `vagrant status`: 

     ~/proj/pubvault/duper/demonstrations/database |  (postgres-demo) 👾 vagrant status
    Current machine states:
    
    instance5                 running (virtualbox)
    instance6                 running (virtualbox)
    instance7                 running (virtualbox)
    db                        running (virtualbox)
    
    This environment represents multiple VMs. The VMs are all listed
    above with their current state. For more information about a specific
    VM, run `vagrant status NAME`.
    ~/proj/pubvault/duper/demonstrations/database |  (postgres-demo) 👾

Then pick one of the Vault instances, and `vagrant ssh` to it, e.g. `vagrant ssh instance7`: 

    ~/proj/pubvault/duper/demonstrations/database |  (postgres-demo) 👾 vagrant ssh instance7
    Last login: Fri Nov  2 01:01:35 2018 from 10.0.2.2
    [vagrant@instance7 ~]$

We can use the guide at the following link:

https://learn.hashicorp.com/vault/secrets-management/sm-dynamic-secrets

[Add this policy](https://www.vaultproject.io/docs/concepts/policies.html#creating-policies), make a token from it, and use that token to log in: 

vault_db_engine_admin.hcl


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
    vault write database/config/postgresql plugin_name=postgresql-database-plugin       allowed_roles=readonly connection_url='postgresql://postgres:r00tp-ssbuckphrase@192.168.13.187:5432/testdb?sslmode=disable' verify_connection=false
    WARNING! The following warnings were returned from Vault:
    
      * Password found in connection_url, use a templated url to enable root
      rotation and prevent read access to password information.

OR
    export VAULT_DBA_TOKEN=e49fd95b-36e5-edd8-535f-588e96b456ab
    export VAULT_TOKEN=$VAULT_DBA_TOKEN
    curl --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST --data @postgres.json     http://127.0.0.1:8200/v1/database/config/postgresql | jq


Then: 

    curl --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST --data @readonly.json "${VAULT_ADDR}/v1/database/roles/readonly"

Now switch to the apps policy.

    vault token create -policy=apps
    Key                  Value
    ---                  -----
    token                f1642613-cdb0-3a30-c3c2-d688b4353d48
    token_accessor       5c37ba0a-f7e2-6baa-e061-90c4f6faf761
    token_duration       768h
    token_renewable      true
    token_policies       ["apps-policy" "default"]
    identity_policies    []
    policies             ["apps-policy" "default"]
    export VAULT_APPS_TOKEN=f1642613-cdb0-3a30-c3c2-d688b4353d48
    export VAULT_TOKEN=$VAULT_APPS_TOKEN


Get a dynamic DB credential: 

    [vagrant@instance7 postgres]$ curl --header "X-Vault-Token: ${VAULT_TOKEN}"        --request GET        http://127.0.0.1:8200/v1/database/creds/readonly | jq
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   317  100   317    0     0  13534      0 --:--:-- --:--:-- --:--:-- 13782
    {
      "request_id": "1c3c2f54-e9d6-9ccc-631f-2f8e28df47f7",
      "lease_id": "database/creds/readonly/c32f9cc9-1788-1ca9-63e9-b45ed8c887ad",
      "renewable": true,
      "lease_duration": 3600,
      "data": {
        "password": "A1a-5PoFoXocupy7wEGL",
        "username": "v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143"
      },
      "wrap_info": null,
      "warnings": null,
      "auth": null
    }

Use it to log in, and check that you can't drop tables: 

    [vagrant@instance7 postgres]$ psql -h 192.168.13.187 -U v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143
    Password for user v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143:
    psql: FATAL:  database "v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143" does not exist
    [vagrant@instance7 postgres]$ psql -h 192.168.13.187 -U v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143 testdb
    Password for user v-token-readonly-7eJeIr7oXGdQQctzekch-1541182143:
    psql (9.2.24)
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


    [vagrant@bdload2 vagrant]$ psql -h 192.168.13.187 -U postgres --pass
    Password for user postgres:
    psql (9.2.24)
    Type "help" for help.
    
    postgres=# \d
              List of relations
     Schema |  Name   | Type  |  Owner
    --------+---------+-------+----------
     public | company | table | postgres
    (1 row)
    
    postgres=# help
    You are using psql, the command-line interface to PostgreSQL.
    Type:  \copyright for distribution terms
           \h for help with SQL commands
           \? for help with psql commands
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
