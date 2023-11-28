{{ with secret "ldap/static-cred/learn" }}
<html>
<head>
</head>
  <body>
    <li><strong>username</strong> &#58; {{ .Data.username }}</li>
    <li><strong>dn</strong> &#58; {{ .Data.dn }}</li>
    <li><strong>last_password</strong> &#58; {{ .Data.last_password }}</li>
    <li><strong>password</strong> &#58; {{ .Data.password }}</li>
    <li><strong>ttl</strong> &#58; {{ .Data.ttl }}</li>
    <li><strong>rotation_period</strong> &#58; {{ .Data.rotation_period }}</li>
    <li><strong>last_vault_rotation</strong> &#58; {{ .Data.last_vault_rotation }}</li>
</body>
</html>
{{ end }}
