# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  ##  Note: can be used with either VMWare or Virtualbox
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
            server.vm.provision "shell", path: "vaultdownload.sh", args: "0.10.3"
            server.vm.provision "shell", path: "configurevault.sh"
            server.vm.provision "shell", path: "unpackplugin.sh", args: "vault-plugin-auth-jwt-linux_amd64.zip"
            server.vm.provision "shell", inline: "sudo systemctl enable consul.service"
            server.vm.provision "shell", inline: "sudo systemctl start consul"
            server.vm.provision "shell", inline: "sudo systemctl enable vault.service"
            server.vm.provision "shell", inline: "sudo systemctl start vault"
        end
    end

  ##  I have added a variable here in case you want to try out Vault's
  ##  DB Secret backend.
  ##  It's false by default.
  ##  If set to true, Vagrant will add a machine called db when you run vagrant up.
  db = false

  if db == true
    config.vm.define "db" do |db|
          ##  Setup VM for Secret Engine testing:
          ##  https://www.vaultproject.io/docs/secrets/databases/index.html
          ##  
        db.vm.box = "bento/centos-7.5"
        db.vm.box_version = "201805.15.0"
        db.vm.hostname = "db"
        db.vm.network :private_network, ip: "192.168.133.7"
          ##  Install and run DB
        db.vm.provision "shell", path: "account.sh", args: "mariadb"
        db.vm.provision "shell", path: "prereqs.sh"
        db.vm.provision "shell", path: "demonstrations/mariadb.sh", args: ["errydayimSNUFFLIN", "true", "false"]
        db.vm.provision "shell", inline: "sudo systemctl enable mariadb.service"
        db.vm.provision "shell", inline: "sudo systemctl start mariadb"
    end
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
