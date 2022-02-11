how to run ansible with teleport

1. make sure you installed tsh and login to teleport-admin cluster
2. mkdir ~/.tsh/wcl && curl https://wcl-download.sh1a.qingstor.com/teleport/bin/tsh > ~/.tsh/wcl/tsh
3. chmod +x ~/.tsh/wcl/tsh
4. ansible-playbook -i inventory ping.yaml
