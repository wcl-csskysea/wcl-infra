### Usage
# The secret is guinan.huang's DNSPOD apikey. 
```
pip3 install -i https://mirrors.tencent.com/pypi/simple/ --upgrade tencentcloud-sdk-python
chmod +x addTxtrecord.py
chmod +x delTxtrecord.py
ansible-vault decrypt secret.py  #find in bitwardon `ansible vault for infrastructure`
certbot certonly --manual --preferred-challenges=dns --manual-auth-hook /scripts/certbot/addTxtrecord.py  -d teleport.wiredcraft.cn
python3 delTxtrecord.py
```