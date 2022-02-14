how to run ansible with teleport

1. make sure you installed tsh and login to teleport-admin cluster
2. `echo "GITHUB_USERNAME=you_github_username" > .env`
3. `mkdir ~/.tsh/wcl` && `curl https://wcl-download.sh1a.qingstor.com/teleport/darwin/bin/tsh > ~/.tsh/wcl/tsh`
> if you use linux, then use `https://wcl-download.sh1a.qingstor.com/teleport/linux/bin/tsh`
4. `chmod +x ~/.tsh/wcl/tsh`
5. ansible-playbook -i inventory ping.yaml
