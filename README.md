# Vault LDAP Secrets Engine Demo

# Run

```shell
# export Vault license
export VAULT_LICENSE=$(cat ~/Downloads/vault.hclic)     

# Start all containers and minikube
make all

open http://127.0.0.1:8080
```

# LDAP Admin
```shell
Login DN: cn=admin,dc=hashicorp,dc=com
Password: admin
```

# Reference
- [LDAP container reference](https://github.com/Crivaledaz/Mattermost-LDAP)
- [Active Directory management tip](https://activedirectorypro.com/active-directory-management-tips/)