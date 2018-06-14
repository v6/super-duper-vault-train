# super-duper-vault-train
▼🚄

# OS-Specific Prerequisites
MacOS: OSX 10.13 or later
Windows: Windows must have Powershell 3.0 or later

# Vagrant

## Install Tools
Make sure you have [Git](https://git-scm.com/downloads) installed
Install Vagrant  ([NOTE: NOT COMPATIBLE WITH WINDOWS 7 OR WINDOWS 8](https://blogs.technet.microsoft.com/heyscriptingguy/2013/06/02/weekend-scripter-install-powershell-3-0-on-windows-7/))  
Install VMWare or [Virtualbox](https://www.virtualbox.org/wiki/Downloads)  

## Download the Code for this

`git clone https://github.com/v6/super-duper-vault-train.git`  

## Use this Code to Make a Vault Cluster
`cd super-duper-vault-train`  
`vagrant up`  
`vagrant status`  
`vagrant ssh instance5`  
You can also `vagrant ssh` to other VMs listed in the output of `vagrant status`.

You can now use Vault or Consul from within the VM for which you ran `vagrant ssh`.


`ps -ef | grep vault`  ##  Check the Vault process (run while inside a Vagrant-managed Instance)
`ps -ef | grep consul`  ##  Check the Consul process (run while inside a Vagrant-managed Instance)
`vault operator init`  ## Start Vault (run while inside a Vagrant-managed Instance)
