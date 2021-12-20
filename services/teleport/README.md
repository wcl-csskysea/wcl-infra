[Teleport Official Website](https://goteleport.com/docs/)
* version: ~~7.03~~ | 7.3.3

## Distribution roles
* All roles must be deployed on both Root and Leaf Cluster admin servers
* The default trusted_cluster mapping rule is:    
 ```   
role_map:
  - remote: "^(.*)$"
    local: [$1] 
```
* This means that the role names are one-to-one, such as root:devops -> leaf:devops
* Command: ```$ ansible-playbook -i inventory.admin setup/distribution-role.yaml ```
* This command will update all ```templates/public/roles/*.yaml``` role files


## Github SSO
* Enable local port proxy to speed up github access. use scripts 
* ```teleport/ansible/setup/templates/root-cluster/scripts/github-proxy-tunnel.sh```

## Deployment
> Note:  
> This play-book already encrypted add this at the end of the following command  
> `-b --vault-password-file= <secret file path> `  
> Devops requires only the ```leaf-cluster``` and ```agent``` to be installed.   
> Install leaf-cluster first,this command will establish a link with root-cluster,  
> then install agent,this will establish a link from agent to leaf-cluster.  
> The list of the files or directory and users that will be created: 

| filr & dir & users | note |
| ---- | ---- |
|/etc/teleport.yaml| the main config file|
|/etc/teleport.d|config file directory|
|/etc/teleport.d/cluster.yml| the trusted cluster config file|
|/usr/lib/systemd/system/teleport.service| systemd service file|
|/run/teleport.pid| pid file|
|/var/lib/teleport| the main work directory|
|/etc/sudoers.d/devops| the devops sudo file|  
|devops && developer| the server users|
#### The white list
* Provide your admin server external ip to `Kaleo` for add access to port `443 3024` of `teleport-admin`  
* The Agent needs to access port `3000` of `leaf-admin`
#### The install command  
* root-cluster
  ```$ ansible-playbook -i inventory.admin setup/root-cluster-admin.yaml```
* leaf-cluster
  ```$ ansible-playbook -i inventory.admin setup/leaf-cluster-admin.yaml```
* agent
  * mv `infrastructure/services/teleport/agent` to your project repo
  * this directory inculde a `teleport-agent.yaml` file and a `templates` directory
  * Modify `teleport-agent.yaml` env according to your project
* token:
  * trusted_tokens:  This token needs to be generated on root-cluster-admin server
    * ```[root_cluster_admin]$ tctl tokens add --type=trusted_cluster --ttl=30m ```
  * agent_tokens: This token needs to be generated on leaf-cluster-admin server
    * ```[leaf_cluster_admin]$ tctl tokens add --type=node --ttl=30m ```

## Access kubernetes
```$ ansible-playbook -i inventory.admin setup/k8s.yaml```
* [generate kubeconfig](https://goteleport.com/docs/kubernetes-access/guides/standalone-teleport/)


## Quick start
#### [client install](https://docs.ansible.com/ansible/latest/user_guide/playbooks_prompts.html#id1)
* Mac ```$ brew install teleport ```

#### Login
* Github account login  ```$ tsh --proxy=teleport.wiredcraft.cn --auth=wiredcraft_github_connector --user=<github account> login```
* Web gui login `https://teleport.wiredcraft.cn`

#### SSH 
* ```$ tsh ls```
* ```$ tsh ssh devops@bby-admin```
* ```$ tsh ssh -A devops@bby-admin #use ssh-forward mode``` 
  
#### Switch cluster
* ```$ tsh clusters```
* ```$ tsh login bby-admin```

#### Login kubernetes
* ```# login the specified cluster then```
* ```$ tsh kube ls ```
* ```$ tsh kube login k8s-staging ```

> More usage visit [command tool](https://goteleport.com/docs/server-access/guides/tsh/)