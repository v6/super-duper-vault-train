# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
  ##  This example uses three boxes. instance5, instance6, and instance7. 
    (5..7).each do |i|
        config.vm.define "instance#{i}" do |server|
            server.vm.box = "bento/centos-7.5"
            server.vm.box_version = "201805.15.0"
            server.vm.hostname = "instance#{i}"
            server.vm.network :private_network, ip: "192.168.13.3#{i}"
            server.vm.provision "shell", path: "account.sh", args: "vault"
            server.vm.provision "shell", path: "account.sh", args: "consul"
            server.vm.provision "shell", path: "prereqs.sh"
            server.vm.provision "shell", path: "consulsystemd.sh"
            server.vm.provision "shell", path: "vaultsystemd.sh"
            server.vm.provision "shell", path: "consuldownload.sh"
            server.vm.provision "shell", path: "configureconsul.sh"
            server.vm.provision "shell", inline: "sudo systemctl enable consul.service"
            server.vm.provision "shell", inline: "sudo systemctl start consul"
            server.vm.provision "shell", inline: "sudo cp /vagrant/certs/digitalonus.com-192.168.13.3#{i}.crt /etc/vault.d/tls/vault.crt"
            server.vm.provision "shell", inline: "sudo cp /vagrant/certs/digitalonus.com-192.168.13.3#{i}.key /etc/vault.d/tls/vault.key"
            server.vm.provision "shell", path: "vaultdownload.sh", args: ["1.0.0-rc1", "/usr/local/bin"]
            server.vm.provision "shell", inline: "sudo chmod 0600 /etc/vault.d/tls/vault.key"
            
              ##  API Provisioning
            if "#{i}" == "7"
                server.vm.provision "shell", inline: "consul members; curl localhost:8500/v1/catalog/nodes ; sleep 15"
                server.vm.provision "shell", inline: "echo 'Provisioning Consul ACLs via this host: '; hostname"
                server.vm.provision "shell", path: "provision_consul/scripts/acl/consul_acl.sh"
                server.vm.provision "shell", path: "provision_consul/scripts/acl/consul_acl_vault.sh"
                else
                server.vm.provision "shell", inline: "echo 'Not provisioning Consul ACLs via this host: '; hostname"
            end
        end
    end


    config.vm.define "instance7" do |consul_acl|
#        consul_acl.vm.provision "shell", preserve_order: true, inline: "echo 'Provisioning Consul ACLs via this host: '; hostname"
#        consul_acl.vm.provision "shell", preserve_order: true, path: "provision_consul/scripts/acl/consul_acl.sh"
#        consul_acl.vm.provision "shell", preserve_order: true, path: "provision_consul/scripts/acl/consul_acl_vault.sh"
    end

    (5..7).each do |i|
        config.vm.define "instance#{i}" do |vault|
            vault.vm.provision "shell", preserve_order: true, path: "configurevault.sh"
            vault.vm.provision "shell", preserve_order: true, inline: "sudo systemctl enable vault.service"
            vault.vm.provision "shell", preserve_order: true, inline: "sudo systemctl start vault"
        end
    end

  ##  Consul ACL Configuration
  ##  You'll notice that Consul ACL bootstrapping only succeeds on the first VM.
  ##  Choice of instance5 is not arbitrary. It could be done from within any instance
  ##  running one of the members of the Consul cluster, but instance5
  ##  gets provisioned first.

  ##  Vault's start may only happen after Consul ACL Configuration, because
  ##  it requires a Consul ACL to exist on a running Consul Cluster.

  ##  DB Secret backend
    config.vm.define "db" do |db|
        db.vm.box = "bento/centos-7.5"
        db.vm.box_version = "201805.15.0"
        db.vm.network :private_network, ip: "192.168.13.187"
        db.vm.provision "ansible_local" do |ansible|
            ansible.playbook = "/vagrant/playbooks/prereqs.yaml"
        end
        db.vm.provision "ansible_local" do |ansible|
            ansible.playbook = "/vagrant/playbooks/mariadb.yaml"
            ansible.extra_vars = {'enable_external_conn': true, 'add_root_priv': !ARGV.include?('provision')}
        end
    end
end
