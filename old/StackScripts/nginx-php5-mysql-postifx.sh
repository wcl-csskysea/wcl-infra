#!/bin/bash
########################
# StackScript for Linode setup
########################
#
# Define the user input during installation
#
# <UDF name="db_password" Label="MySQL root Password" />

# Import default functions
source <ssinclude StackScriptID=1>

function install_tools {
    aptitude -y install git sysstat screen htop iftop
}

function php_install_with_fpm {
    aptitude -y install php5-fpm php5-mysql php5-mysql php-apc php5-cli php5-gd php5-xmlrpc php-pear php-devel
}

function php_tune {
    # Tunes PHP to utilize up to 32M per process
    sed -i'-orig' 's/memory_limit = [0-9]\+M/memory_limit = 32M/' /etc/php5/fpm/php.ini

    # Change log PATH
    sed -i'-orig' 's/error_log = \/var\/log\/php5-fpm.log/error_log = \/var\/log\/php-fpm\/php5-fpm.log/' /etc/php5/fpm/php-fpm.conf
    sed -i'-orig' 's/error_log = \/var\/log\/php5-fpm.log/error_log = \/var\/log\/php-fpm\/php5-fpm.log/' /etc/php5/fpm/php-fpm.conf
    sed -i'-orig' 's/pm = dynamic/pm = static/' /etc/php5/fpm/pool.d/www.conf
    sed -i'-orig' 's/pm.max_children = [0-9]\+/pm.max_children = 8/' /etc/php5/fpm/pool.d/www.conf
    sed -i'-orig' 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 5s/' /etc/php5/fpm/pool.d/www.conf
    sed -i'-orig' 's/;slowlog = log\/$pool.log.slow/slowlog = \/var\/log\/php-fpm\/$pool.log.slow/' /etc/php5/fpm/pool.d/www.conf
		
		# Create log folder
		mkdir /var/log/php-fpm

    update-rc.d php5-fpm enable
    touch /tmp/restart-php5-fpm
}

function install_nginx {
    aptitude -y install nginx
    update-rc.d nginx enable
}

function install_drush {
    mkdir -p /var/www/tools/
    cd /var/www/tools
    git clone git://github.com/Wiredcraft/drush.git drush
    ln -s /var/www/tools/drush/drush /usr/local/bin/.
}

function setup_nginx {
    # backup old config
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

    # Fetch the default configuration file for nginx
    wget --no-check-certificate https://raw.github.com/Wiredcraft/infrastructure/master/nginx/nginx.conf -O /etc/nginx/nginx.conf
    wget --no-check-certificate https://raw.github.com/Wiredcraft/infrastructure/master/nginx/conf.d/default.conf -O /etc/nginx/conf.d/default.conf

    mkdir /var/www

    touch /tmp/restart-nginx
}

function system_tuning {
    # open files
    echo 'root  soft  nofile  65536' >> /etc/security/limits.conf
    echo 'root  hard  nofile  65536' >> /etc/security/limits.conf
    echo '*  soft  nofile  65536' >> /etc/security/limits.conf
    echo '*  hard  nofile  65536' >> /etc/security/limits.conf

    # swappiness
    echo 'vm.swappiness = 0' >> /etc/sysctl.conf
    sysctl -p

    # I hate nano and alikes
    update-alternatives --set editor /usr/bin/vim.nox
}

function add_privileged_user {
    user=$1
    useradd -m -s /bin/bash $user

    # SSH key
    su - $user -c "ssh-keygen -q -b 2048 -t rsa -N '' -f ~$user/.ssh/id_rsa"

    # sudo
    echo "$user   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 

    # Add SSH public key to authorized_keys
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArRNGxicwYhP+9lgE+2IgqI4ANXNJCCa+jXONNBUrsfizJkTMIVlMXzvvdz6+CHXlnBsM2Ztu09EBrDFJFxqaDh6LVuTCDrSzSq1c1jKYBaww8woJHfhnEwfuyr0eifaJq3TPo2GwwUmhPPCrQhQZ+zyiDrRxg7zULMdJAGmtU47nMbqGJf7z+JKd8Xgd1EC35Xyuk7e5vq3uVUEPZvkkPW5ics6IpJJ1ssQo1RXFxNTpuiOgAJZJO1p9iHL9pcntKW8f5yhh0hp0LNh8w+VMbCr9cecK/VVap17VPHA7OSP2TkR3InrVJIyOMu0isTXzBdfM3fRNRQ0fmsWvWsafZQ== balou@localhost' > /home/$user/.ssh/authorized_keys
    chown $user. /home/$user/.ssh/authorized_keys
    chmod 600 /home/$user/.ssh/authorized_keys
}

system_update
system_tuning
install_tools
add_privileged_user wiredcraft

# Install services
postfix_install_loopback_only
mysql_install "$DB_PASSWORD" && mysql_tune 40
php_install_with_fpm && php_tune
install_nginx && setup_nginx

install_drush

goodstuff
restartServices
