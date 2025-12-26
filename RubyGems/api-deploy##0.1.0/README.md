# ApiDeploy

## Console tools

### LDAP
Opens a ruby shell with a ldap query object
```
$> VP='vault_pass' NAP_BIND_USER='' NAP_BIND_PASS='' YOOX_BIND_USER='' YOOX_BIND_PASS='' make ldap

[1] pry(main)> ldap.user 'hawkinsf'
....

[1] pry(main)> ldap.group 'cicd'
...
```

### Shell
Opens a bash shell in the api_deployer
```
$> VP='vault_pass' make shell

$>
```

### Interactive
Opens a ruby shell in the api_deployer
```
$> VP='vault_pass' make interactive

[1] pry(main)>
```

### Apply restrictions
Applies bitbucket repo restrictions
```
$> VP='vault_pass' make apply_restrictions
...
```
