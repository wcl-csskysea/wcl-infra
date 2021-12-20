#!/bin/bash
sudo -u wcladmin -s /usr/bin/autossh -f -M 22000 -D 127.0.0.1:1112 -N -i /home/wcladmin/.ssh/weblate.pub wcladmin@103.61.38.70 -p 40022 >> /var/log/reverse_tunnel_github_proxy.log 2>&1