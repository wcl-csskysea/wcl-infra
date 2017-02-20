# Pipelines for Wiredcraft

Based on the bare pipelines image, we add Ansible

## Ansible build

You can rely on ansible to build the image, tag it and push it.

```
ansible-playbook -i hosts build.yml -u user
```

## Docker build

Manual steps:

- `docker build -t registry.service.wiredcraft.com/wiredcraft/pipelines .`
- `docker push registry.service.wiredcraft.com/wiredcraft/pipelines`