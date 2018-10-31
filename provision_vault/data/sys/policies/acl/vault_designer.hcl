  ##  The primary role of the Vault Designer
  ##  is to set guidelines for how Vault should be
  ##  used, and, after initial provisioning,
  ##  verify that use of Vault follows 
  ##  those basic guidelines.
  ##  To that end, I've allowed list and
  ##  create permissions for core systems and 
  ##  backends.
  ##  This role still needs further testing,
  ##  so reach out to the Vault Admin if 
  ##  something is missing, or, more importantly,
  ##  if any permissions beyond the minimum needed
  ##  are present. 

path "sys/*"
{
  capabilities = ["create", "list", "sudo"]
}

path "auth/*"
{
  capabilities = ["create", "list", "sudo"]
}

path "transit/*"
{
  capabilities = ["create", "list"]
}
