#!/bin/bash
####################################
# git create script based on user input
#
####################################
# Contact:
#	vincent@wiredcraft.com
####################################
version=0.1

# Load client config file
[ -f /etc/huolongguo.conf ] && . /etc/huolongguo.conf

# Load JSON file (dirty)
# TODO : need real JSON parsing

print_version() {
	echo "$(basename $0) - version: $version"
}

help() {
	print_version
	cat << EOF
	
Usage :
  -c | --config FILE -- specify client configuration file, override defaults
  -j | --json FILE   -- specify client JSON build file, if none specified prompt user

EOF
}

#
# Get command line options
#
get_options() {
        # Note that we use `"$@"' to let each command-line parameter expand to a 
        # separate word. The quotes around `$@' are essential!
        # We need TEMP as the `eval set --' would nuke the return value of getopt.
        TEMP=`getopt --options hvj:c: \
                                 --long help,version,json:,config: \
                                 -- "$@"`

        if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

        # Note the quotes around `$TEMP': they are essential!
        eval set -- "$TEMP"

        while true ; do
                case "$1" in
                        -h|--help) help ; exit ;;
                        -v|--version) print_version ; exit ;;
                        -j|--json) JSON=$2 ; shift 2 ;;
                        -c|--config) CONFIG=$2 ; shift 2 ;;
                        --) shift ; break ;;
                        *) echo "Internal error!" ; exit 1 ;;
                esac
        done
}

#
# prompt user when no JSON file provided
#
prompt_user_json() {
	#
	# Retrieve input from user
	#	TODO: check validity of user inputs
	#
	echo -n "Enter the domain name : "
	read DOMAIN
	
	echo -n "Enter repository location : "
	read REPOSITORY
	
	echo -n "Enter branch (default: master) : "
	read BRANCH
	if [ -z "$BRANCH" ]; then
		BRANCH='master'
	fi	

	echo -n "Enter revision (default: current) : "
	read REVISION
	if [ -z "$REVISION" ]; then
		REVISION='current'
	fi
}

#
# prompt user when no configuration file provided 
#
prompt_user_config() {
	echo -n "Enter PATH of virtual hosts (default: /var/www/html) : "
	read ROOT
	if [ -z "$ROOT" ]; then
		ROOT='/var/www/html'
	fi
}

#
# Load JSON file and extract paramters
# TODO : do REAL JSON parsing - switch to python ?
#
load_json() {
	if [ ! -f "$JSON" ]; then
		echo "$JSON file does not exist or is not readable"
		exit 1
	fi

	DOMAIN=$(cat $JSON | grep '"domain":' | awk '{print $2}' | cut -f2 -d'"')
	REPOSITORY=$(cat $JSON | grep '"repository":' | awk '{print $2}' | cut -f2 -d'"')
	BRANCH=$(cat $JSON | grep '"branch":' | awk '{print $2}' | cut -f2 -d'"')
	AUTOMATIC=$(cat $JSON | grep '"automatic":' | awk '{print $2}' | cut -f2 -d'"')
	TAG=$(cat $JSON | grep '"tag":' | awk '{print $2}' | cut -f2 -d'"')
}

#
# Load config file (environment variables)
#
load_config() {
	if [ ! -f "$CONFIG" ]; then
		echo "$CONFIG file does not exist or is not readable"
		exit 1
	fi
	
	source "$CONFIG"
}

#
# Provide extra details to setup the repository
# ex. display SSH keys for git retrieve over SSH
#
config_repository() {
	#
	# Display some extra details to ensure the git commands will succeed.
	#	- display the current user
	#   - display the public SSH key
	#

	echo "Current user : $(whoami)"
	echo
	echo "Current SSH public key - add it to the remote GIT repository to allow clone / pull :"
	echo
	echo "	$(cat ~/.ssh/id_rsa.pub)"
	echo
}

build() {
	WEBROOT="$VHOST_ROOT/$DOMAIN"

	if [ ! -w "$VHOST_ROOT" ]; then
		echo "$VHOST_ROOT is not writable - build aborted"
		exit 1
	fi
	
	git clone "$REPOSITORY" "$WEBROOT"
}



#
# MAIN
#
get_options "$@"

[ -z "$JSON" ] && prompt_user_json || load_json
[ -z "$CONFIG" ] && prompt_user_config || load_config

echo "Do you want to apply / build - press [Enter to continue / Ctrl+C to cancel]"
	read 

build

