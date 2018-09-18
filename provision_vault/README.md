# Vault API Provisioning

This has code for provisioning Vault via its API.

The layout and design of this repository is
simple - everything after the v1/ in the API 
becomes a folder, and each payload becomes 
a JSON or HCL file.

DO NOT commit or store actual secrets or sensitive 
data in this layout, because that would defeat the 
purpose of using Vault to manage secrets.
These secrets should still be configured manually, 
generated via Vault's Secret Backends, or 
uploaded via another tool.

I modeled this approach after the post 
on HashiCorp.com's blog, titled
"Codifying Vault Policies and Configuration".

https://www.hashicorp.com/blog/codifying-vault-policies-and-configuration#layout-and-design
