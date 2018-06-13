# super-duper-vault-train
▼🚄

# Vagrant
Install Vagrant  
Install VMWare or Virtualbox  
`vagrant up`  
`vagrant status`  
`vagrant ssh instance5`  
You can also `vagrant ssh` to other VMs listed in the output of `vagrant status`.

You can now use Vault or Consul from within the VM for which you ran `vagrant ssh`.


`ps -ef | grep vault`  
`ps -ef | grep consul`  
`vault operator init`  
