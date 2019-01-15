chef_gem 'vault' do
  compile_time true
end

  ##  This is adapted to a role-id only authentication method from the following HashiCorp Sample code: 
  ##  https://github.com/hashicorp/vault-guides/blob/master/identity/vault-chef-approle/chef/cookbooks/vault_chef_approle_demo/recipes/default.rb
  
  ##  There is an even more sophisticated example here: 
  ##  https://gist.github.com/sethvargo/6f1a315094fbd1a18c6d

require 'vault'

# Configure address for Vault Gem
Vault.address = "https://vault.digitalonus.com"

# Get Vault token from data bag (used to retrieve the SecretID)
vault_token_data = data_bag_item('roleid_token', 'approle_roleid_token')

# Set Vault token (used to retrieve the SecretID)
Vault.token = vault_token_data['auth']['client_token']

# Get AppRole RoleID from Vault
var_role_id = Vault.approle.role_id('new_relic')

# Send the RoleID to Vault for AppRole authentication, and receive a token. 
# Then assign it to a variable that's specific to the secret backend
secret = Vault.auth.approle( var_role_id )

# Read our secrets
var_secrets = Vault.logical.read("secret/data/dev/monitoringagent/database/oracle/montest")

var_rbbt_secrets = Vault.logical.read("secret/data/dev/monitoringagent/datastore/rabbitmq/montest")

# Output our info to a Ruby template, tada we're done!
template '/var/www/html/index.html' do
  source 'index.html.erb'
  variables(
    :password => var_secrets.data[:data][:db_password],
    :rbbt_username => var_secrets.data[:data][:username],
    :rbbt_password => var_secrets.data[:data][:password],
    :uri => var_secrets.data[:data][:db_uri],
    :var_role_id => var_role_id
  )
end
