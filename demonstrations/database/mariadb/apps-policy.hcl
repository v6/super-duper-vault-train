# Get credentials from the database secret engine
path "database/creds/readonly" {
  capabilities = [ "read" ]
}
path "mariadb/creds/readonly" {
  capabilities = [ "read" ]
}
