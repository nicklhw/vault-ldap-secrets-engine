pid_file = "./pidfile"

auto_auth {
  method {
    type = "approle"
    config = {
      role_id_file_path = "/vault-agent/app1_role_id"
      secret_id_file_path = "/vault-agent/app1_secret_id"
      remove_secret_id_file_after_reading = false
    }
  }
}

template {
  source = "/vault-agent/ldap.tpl"
  destination = "/vault-agent/ldap.html"
}

vault {
  address = "http://vault:8200"
}
