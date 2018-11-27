# Grant permissions on the group specific path
# The region is specified in the group metadata
path "group-kv/data/education/{{identity.groups.names.education.metadata.region}}/*" {
    capabilities = [ "create", "update", "read", "delete", "list" ]
}

# Group member can update the group information
path "identity/group/id/{{identity.groups.names.education.id}}" {
  capabilities = [ "update", "read" ]
}

# For Web UI usage
path "group-kv/metadata" {
  capabilities = ["list"]
}

path "identity/group/id" {
  capabilities = [ "list" ]
}
