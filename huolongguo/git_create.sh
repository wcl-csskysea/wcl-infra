#!/bin/bash
####################################
# git create script based on user input
#
####################################
# Contact:
#	vincent@wiredcraft.com
####################################

#
# Retrieve input from user
#	TODO: check validity of user inputs
#
echo -n "Enter the domain name : "
read DOMAIN

echo -n "Enter repository location : "
read REPOSITORY

echo -n "Enter branch (default: MASTER) : "
read BRANCH

echo -n "Enter revision (default: current) : "
read REVISION

######
# Default webroot location :
# 	/var/www/sites/$DOMAIN/
######

# Create script - check that webroot doesn't exist
WEBROOT="/var/www/sites/$DOMAIN"
if [ ! -e "$WEBROOT" ]; then
	mkdir -p "$WEBROOT"
	if [ $? -ne 0 ]; then
		echo "Error - can not create $WEBROOT folder"
		exit 1
	else
		echo "$WEBROOT folder has been created"
	fi
fi

cd "$WEBROOT"

#
# Display some extra details to ensure the git commands will succeed.
#	- display the current user
#   - display the public SSH key
#

echo "Current user : $(whoami)"
echo "Current SSH public key - add it to the remote GIT repository to allow clone / pull :"
echo "	$(cat ~/.ssh/id_rsa.pub)"

#
# Wait for confirmation the key has been added on the remote server
#

echo "Once your key has been added - press [Enter to continue / Ctrl+C to cancel]"
read 

git clone "$REPOSITORY" .
