  # Use for Production Installation
  
  ##  Edit `configureconsul.sh`
  
  ### Replace IP Addresses
  In the `configureconsul.sh` file, replace the IP Addresses listed with the hosts on which you're actually running Consul in Server Mode.
  
  ### Replace Data Center
  Also replace the value for the `"datacenter"` key with the name of your data center, e.g. `eastus`.
  
  ##  Separate Consul and Vault
  
To install ONLY consul on a server: Don't run the scripts with the word Vault.  
Just omit scripts with `vault` in the name.  

To install ONLY Vault on a server: There's no need to omit any scripts.  
But change the consul configuration. Replace `  "server": true,` with `  "server": false,`.

  ##  Run Scripts

If you want to install this in a production cluster, run the [`*.sh` scripts named inside the Vagrantfile](https://github.com/v6/super-duper-vault-train/blob/develop/Vagrantfile#L22-L36) in the order that they're listed, on each host, using the arguments listed as bash arguments. 

For example, for [`server.vm.provision "shell", path: "account.sh", args: "consul-replicate"`](https://github.com/v6/super-duper-vault-train/blob/develop/Vagrantfile#L24), you would run `# account.sh consul-replicate` as root.

After running `# account.sh consul-replicate`, you would run the next listed `.sh` file, `prereqs.sh`, and so on.

  ##  Send Hostnames & IP Addresses

Once provisioned using the above instructions, send the Host Names and IP addresses to whoever will own and manage Vault further. 

They'll then use the Vault API to initialize the Vault using `init.sh` and set up a cluster with it. 


  ##  Conveniences
  
  
  Here's the content of the /etc/profile.d/vault.sh that I have on my latest Vagrant setup: 

export VAULT_ADDR=http://127.0.0.1:8200  ##  Add local Vault address to startup script

Yours could be this: 

export VAULT_ADDR=http://vaultlb.mycorp.com  ##  Add Vault Load Balancer address to startup script


or 

export VAULT_ADDR=https://hostfqdn:8200  ##  Add Vault FQDN address to startup script

Without an environment variable, Vault will default to this: 

https://github.com/hashicorp/vault/blob/934ec9305bd3ef9399894b5c4ba2950f69594c94/api/client.go#L117-L123

Note: The above will affect all users of a Linux system. But if it's just one user, you can update ~/.bash_profile to the same effect. 
