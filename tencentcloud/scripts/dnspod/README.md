### Usage
# The secret is guinan.huang's DNSPOD apikey. 
```
chmod +x addTxtrecord.py
chmod +x delTxtrecord.py
ansible-vault decrypt secret.py
certbot certonly --manual --preferred-challenges=dns --manual-auth-hook /scripts/certbot/addTxtrecord.py --manual-cleanup-hook /scripts/certbot/delTxtrecord.py -d teleport.wiredcraft.cn
```