# super-duper-vault-train
▼🚄

# OS-Specific Prerequisites
* MacOS: OSX 10.13 or later  
* Windows: Windows must have [Powershell 3.0](https://stackoverflow.com/a/32385347/2146138) or later. If you're on Windows 7, I recommend Windows Management Framework 4.0

# Vagrant  

### Install Tools  
1. Make sure you have [Git](https://git-scm.com/downloads) installed  
2. Install Vagrant  ([NOTE: NOT COMPATIBLE WITH WINDOWS 7 OR WINDOWS 8](https://blogs.technet.microsoft.com/heyscriptingguy/2013/06/02/weekend-scripter-install-powershell-3-0-on-windows-7/))  
3. Install VMWare or [Virtualbox](https://www.virtualbox.org/wiki/Downloads)  

### Download the Code for this  

_Related Vendor Documentation Link: https://help.github.com/articles/cloning-a-repository_  

`git clone https://github.com/v6/super-duper-vault-train.git`  

### Use this Code to Make a Vault Cluster  

_Related Vendor Documentation Link: https://www.vagrantup.com/intro/index.html#why-vagrant-_  

`cd super-duper-vault-train`  
`vagrant up`  
`vagrant status`  
`vagrant ssh instance5`  
After you do this, you'll see your command prompt change to show `vagrant`.  
You can also `vagrant ssh` to other VMs listed in the output of `vagrant status`.  

You can now use Vault or Consul from within the VM for which you ran `vagrant ssh`.  

# Vault

### Explore the Vault Cluster  

`ps -ef | grep vault`  ##  Check the Vault process (run while inside a Vagrant-managed Instance)  
`ps -ef | grep consul`  ##  Check the Consul process (run while inside a Vagrant-managed Instance)  
`vault version`  ##  Output should be `Vault v0.10.2 ('3ee0802ed08cb7f4046c2151ec4671a076b76166')`  
`consul version`  ##  Output should show Consul Agent version and Raft Protocol version


### Start Vault Data  

_Related Vendor Documentation Link: https://www.vaultproject.io/api/system/init.html_  

Start Vault.  
Run this command on one of the Vagrant-managed VMs, or somewhere on your computer that has `curl` installed.  
```
    curl -s --request PUT -d '{"secret_shares": 3,"secret_threshold": 2}' http://192.168.13.35:8200/v1/sys/init
```

### Unseal Vault  

_Related Vendor Documentation Link: https://www.vaultproject.io/api/system/unseal.html_  

This will unseal the Vault at `192.168.13.35:8200`.  You can use the same process for `192.168.13.36:8200` and `192.168.13.37:8200`.

1. Use your unseal key to replace the value for key `abcd1430890...`, and run this on the Vagrant-managed VM.  

```
    curl --request PUT --data '{"key":"abcd12345678..."}' http://192.168.13.35:8200/v1/sys/unseal
```

2. Run that `curl` command again. But use a different value for `"key":`. Replace `efgh2541901...` with a different key than you used in the previous step, from the keys you received when running the `v1/sys/init` endpoint.  

```
    curl --request PUT --data '{"key":"efgh910111213..."}' http://192.168.13.35:8200/v1/sys/unseal
```
