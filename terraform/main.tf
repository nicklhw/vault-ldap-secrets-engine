provider "vault" {
}

resource "vault_ldap_secret_backend" "config" {
  path         = "ldap"
  binddn       = "cn=admin,dc=hashicorp,dc=com"
  bindpass     = var.ldap_bindpass
  url          = var.ldap_url
  insecure_tls = "true"
  userdn       = "ou=users,dc=hashicorp,dc=com"
}

resource "vault_ldap_secret_backend_static_role" "role" {
  mount           = vault_ldap_secret_backend.config.path
  username        = "alice"
  dn              = "cn=alice,ou=users,dc=hashicorp,dc=com"
  role_name       = "learn"
  rotation_period = 60
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "app1" {
  backend        = vault_auth_backend.approle.path
  role_name      = "vault-agent"
  token_policies = ["ldap-static-read"]
}

resource "vault_policy" "ldap_static_read" {
  name   = "ldap-static-read"
  policy = <<EOF
  # Request OpenLDAP credential from the learn role
path "ldap/static-cred/learn" {
  capabilities = [ "read" ]
}
EOF
}

data "vault_approle_auth_backend_role_id" "app1" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.app1.role_name
}

resource "vault_approle_auth_backend_role_secret_id" "app1" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.app1.role_name
}

resource "local_file" "approle_id" {
  content  = data.vault_approle_auth_backend_role_id.app1.role_id
  filename = "../docker-compose/vault-agent/app1_role_id"
}

resource "local_file" "approle_secret" {
  content  = vault_approle_auth_backend_role_secret_id.app1.secret_id
  filename = "../docker-compose/vault-agent/app1_secret_id"
}