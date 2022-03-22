## requirement
- teleport cli `tsh`
- login to `teleport-admin` cluster with `tsh`

## run
```sh
ansible-playbook ping.yaml --ask-vault-password
# or
ansible-playbook ping.yaml --vault-password-file VAULT_PASSWORD_FILES
```

