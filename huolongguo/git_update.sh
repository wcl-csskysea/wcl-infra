#!/bin/bash
####################################
# git update script based on user input
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
if [ ! -d "$WEBROOT" ]; then
	echo "Error - can not access $WEBROOT folder"
	exit 1
else
	echo "$WEBROOT folder has been created"
fi

cd "$WEBROOT"

#
# Wait for confirmation the key has been added on the remote server
#

echo "Do you want to retrieve the code ? [Enter to continue / Ctrl+C to cancel]"
read 

git pull "$REPOSITORY" .