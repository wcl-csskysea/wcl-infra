# Zabbix Server

## Usage

Used to monitor every customer.

## Details

**Will** run with:
- nginx (web service)
- mysql/percona (database)
- php-fpm (for the web interface)
- zabbix-server (daemon)

**But** currently runs with:
- apache + php
- zabbix-server

## Install

```
# Install roles locally
mkdir -p roles
ansible-galaxy install -r requirements.yml -p roles

# Run setup
ansible-playbook -i hosts zabbix.yml

# This step fails the first time, but succeeds when ran a second time...
ansible-playbook -i hosts zabbix.yml
```
