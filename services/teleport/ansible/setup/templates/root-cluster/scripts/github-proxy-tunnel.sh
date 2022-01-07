#!/bin/bash
/usr/bin/autossh -f -M 22000 -D 127.0.0.1:1112 -N -i /home/wcladmin/.ssh/weblate wcladmin@103.61.38.70 -p 40022 