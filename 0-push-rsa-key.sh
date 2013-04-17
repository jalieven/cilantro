#!/bin/bash -e
# This script will create a rsa-key without a passphrase and push it to all the hosts in the hosts.db file
# Call this script like so (only providing your rsa-file location): ./0-create-login.sh ~/.ssh/cilantro_rsa
if [ -z "$1" ];
	then
		echo "Please provide a key file location!";
		echo "USAGE: 0-push-rsa-key ~/.ssh/cilantro_rsa";
	else
		ssh-keygen -t rsa -b 2048 -f $1 -N '';
		awk -f ./ssh/ssh-copy.awk -v "key_file=$1" hosts.db;
fi

