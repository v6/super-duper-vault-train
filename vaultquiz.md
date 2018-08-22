# Some questions related to Vault topics



What is the general definition of a Secrets Management System? 
Similar to LastPass, Secrets Management is the discipline of protecting logins using a remotely accessible service.
Secrets Management deals with restricting access to resources or data which, without that restriction, would cause harm to the company. 
A Secrets Management System (SMS) is a trusted entity that issues digital certificates, which are data files used to cryptographically link an entity with a public key.
A Secrets Management System protects everyone by making sure that no one can access root privileges on PAM restricted devices for corporate security systems. 

Which of the following commands for initializing Vault are correct? 
curl --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST --data '{ "secret_shares": 3, "secret_threshold": 5 }' "${VAULT_ADDR}/v1/sys/init"
curl --request PUT --data "{ \"secret_shares\": 5, \"secret_threshold\": 2, \"root_token_pgp_key\": \"${PGP_PUBLIC_KEY}\"}" "${VAULT_ADDR}/v1/sys/auth/init"
vault init 3 5
curl --request PUT --data "{ \"secret_shares\": 5, \"secret_threshold\": 2, \"root_token_pgp_key\": \"${PGP_PUBLIC_KEY}\"}" "${VAULT_ADDR}/v1/sys/init"
vault initialize --secret-shares 3 --secret-threshold 5

Which of the following commands will correctly upload a Vault policy using the CLI? 
vault policy write mypolicy.hcl --name mypolicy
/vault/policy write mypolicy mypolicy.hcl
vault policy upload mypolicy mypolicy.hcl
vault policy write mypolicy mypolicy.hcl
Policy .hcl files are not directly uploadable using the CLI due to JSON formatting
2, 3, and 4 are correct

Which of the following are correct ways to upload a Vault policy using the API? 
Take .hcl file and convert it into the correct JSON formatted string, then curl --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST --data "{\"policy\": \"${JSON_SERIALIZED_POLICY}\"}" "${VAULT_ADDR}/v1/sys/init/policy"
Put the entire .hcl file on one string, concatenate (cat command) it with the correct JSON boilerplate, then initialize the policy by curl --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST --data "{\"policy\": \"${JSON_SERIALIZED_POLICY}\"}" "${VAULT_ADDR}/v1/sys/init/mypolicy"
Policies are never uploadable using the API due to formatting issues
Take .hcl file and convert it into the correct JSON formatted string, then curl --header "X-Vault-Token: ${VAULT_ADDR}" --request POST --data "{\"policy\": \"${JSON_SERIALIZED_POLICY}\"}" "${VAULT_TOKEN}/v1/sys/init/policy"
Take .hcl file and convert it into the correct JSON formatted string, then curl --header "X-Vault-Token: ${VAULT_ADDR}" --request POST --data "{\"policy\": \"${JSON_SERIALIZED_POLICY}\"}" "${VAULT_TOKEN}/v1/sys/policy/mypolicy"
Take .hcl file and convert it into the correct JSON formatted string, then curl --header "X-Vault-Token: ${VAULT_ADDR}" --request POST --data "{\"name\": \"mypolicy\", \"policy\": \"${JSON_SERIALIZED_POLICY}\"}" "${VAULT_TOKEN}/v1/sys/policy"
All of the above

Which of the following are correct comparisons of Vault with other Secrets Management tools? 
Vault is often a better choice than Post-It Notes, because Post-It Notes are not a Secrets Management tool.
Vault is has far more centralized Cryptographic security in its model than CyberArk.
Unlike Secrets Management tools from Cloud Providers, Vault is designed from the ground up for a Policy as Code approach to RBAC. 
Azure Key Vault is superior to Vault because of Azure's tighter integration with C# plugins.
Terraform, as a Secrets Management System, has one advantage over vault, that it has a better API integration to AWS.
Unlike Azure Key Vault, Vault can be used as an internal Certificate Authority.
CyberArk's open source plugin system does not allow use of Golang plugins, but Vault's does. 
Vault's more flexible than CyberArk, because Vault requires Golang for its plugins, but CyberArk requires a domain-specific-language. 
Vault is more platform-independent than Cloud Provider Secrets Management solutions.
Vault uses HEREDOCS, similarly to Amazon IAM, to control Policy as Data approaches combined with Policy as code. 
Vault's plugins can be in any language, which helps make it more platform independent than solutions like KeyWhiz or CyberArk. 

What is a Vault Token? 
A Vault token is a administrative UUID issued during the Vault Init procedure, which allows root policy access to Vault for API calls, UI access, and the Vault CLI's direct management interface.
 A Vault token is a secret, attached to a policy, that gives direct access to Vault, limited by a specific policy, similarly to a session token for web applications. 
A Vault token is a surrogate value with which the Primary Account Number (PAN) is replaced by Vault. De-tokenization is the reverse process of redeeming a token for its associated PAN value from Vault.
A Vault Token is a value produced by Vault which can be directly exchanged for a secret stored within HashiCorp Vault. 
