Install Consul: 

Mac:
 
    wget https://releases.hashicorp.com/consul/1.4.0-rc1/consul_1.4.0-rc1_darwin_amd64.zip; unzip consul_1.4.0-rc1_darwin_amd64.zip

Linux: 

    wget https://releases.hashicorp.com/consul/1.4.0-rc1/consul_1.4.0-rc1_linux_amd64.zip

Windows: 

    You're on your own, but maybe:
    wget https://releases.hashicorp.com/consul/1.4.0-rc1/consul_1.4.0-rc1_windows_amd64.zip; start consul_1.4.0-rc1_windows_amd64.zip


To show Consul ACL, run this: 

    ./consul agent -dev -server -data-dir=. -config-file=consul.json; export CONSUL_ADDR=http://127.0.0.1:8500

Then either run this: 

    curl -k --request PUT \"${CONSUL_ADDR}/v1/acl/bootstrap\" | jq -r '.ID'

or this: 

    ../../provision_consul/scripts/acl/consul_acl.sh


After you run one of the above 2 lines of code, you'll see an ID value somewhere that looks a little like this one: 

    3be89fa6-80bf-e924-d65f-0fb89b1f42a2

Copy it down for later. 
