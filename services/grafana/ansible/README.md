how to run ansible with teleport

1. make sure you installed tsh and login to teleport-admin cluster
1. make sure you are in the directory `services/grafana/ansible`
1.
    ```sh
    ansible-playbook ping.yaml --ask-vault-password
    # or
    ansible-playbook ping.yaml --vault-password-file VAULT_PASSWORD_FILES
    ```
