# ACL Policy Path Templating

  ##  Check this: 
  ##  https://learn.hashicorp.com/vault/identity-access-management/policy-templating

Vault operates on a secure by default standard, and as such, an empty policy grants no permissions in the system. Therefore, policies must be created to govern the behavior of clients and instrument Role-Based Access Control (RBAC) by specifying access privileges (authorization).

Since everything in Vault is path based, policy authors must be aware of all existing paths as well as paths to be created.

The Policies guide walks you through the creation of ACL policies in Vault.

This guide highlights the use of ACL templating which was introduced in Vault 0.11.

# Challenge

The only way to specify non-static paths in ACL policies was to use globs (*) at the end of paths.

    path "transit/keys/*" {
      capabilities = [ "read" ]
    }

    path "secret/webapp_*" {
      capabilities = [ "create", "read", "update", "delete", "list" ]
    }

This makes many management and delegation tasks challenging. For example, allowing a user to change their own password by invoking the auth/userpass/users/<user_name>/password endpoint can require either a policy for every user or requires the use of Sentinel which is a part of Vault Enterprise.

# Solution

As of Vault 0.11, ACL templating capability is available to allow a subset of user information to be used within ACL policy paths.

NOTE: This feature leverages Vault Identities to inject values into ACL policy paths.
