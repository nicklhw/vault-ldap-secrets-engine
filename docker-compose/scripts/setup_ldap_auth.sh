#!/bin/bash
set -euo pipefail

export VAULT_ADDR=http://localhost:8200
export VAULT_INIT_OUTPUT=vault.json
export VAULT_TOKEN=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.root_token')

vault policy write vault-super-admin ./super_admin_policy.hcl

vault auth enable ldap

vault write auth/ldap/config \
  url="ldap://ldap" \
  userdn="ou=Users,dc=hashicorp,dc=com" \
  groupdn="ou=Groups,dc=hashicorp,dc=com" \
  binddn="cn=admin,dc=hashicorp,dc=com" \
  bindpass="admin" \
  userattr="uid" \
  discoverdn=false \
  token_ttl=1h \
  token_max_ttl=8h

vault write auth/ldap/groups/"Customer Success Vault Super Admins" \
  policies=vault-super-admin

vault namespace create demo

export VAULT_NAMESPACE=demo

vault policy write vault-admin ./demo_admin.hcl

vault auth enable ldap

vault write auth/ldap/config \
  url="ldap://ldap" \
  userdn="ou=Users,dc=hashicorp,dc=com" \
  groupdn="ou=Groups,dc=hashicorp,dc=com" \
  binddn="cn=admin,dc=hashicorp,dc=com" \
  bindpass="admin" \
  userattr="uid" \
  discoverdn=false \
  token_ttl=1h \
  token_max_ttl=8h

vault write -namespace=demo auth/ldap/groups/"Customer Success US East Vault Admins" \
  policies=vault-admin

vault write -namespace=demo auth/ldap/groups/"Customer Success US West Vault Admins" \
  policies=vault-admin