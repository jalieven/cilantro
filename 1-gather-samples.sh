#!/bin/bash -e
# See hosts.db for command definition on multiple hosts
# The name of every command can be used in this script
# -> calling this script: ./create-log.sh <samples>
# if no samples argument was given it will loop indefinitely
# The resulting log-files will be inside the data-directory

# This script can perform different sample-commands remotely on different hosts
# The hosts.db file that is to be parsed should follow the following record structure:
# user@host
# 	command-id-field	command		command-unit-title	graph-title	legend-title	time-start	zero-start-y-axis-boolean	sleep-seconds-interval	
# <blank_line>

# Parse the ini section and declare as variables in the scope of this script
CONFIG_FILE="cilantro.ini"
SECTION="general"

eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
    -e 's/;.*$//' \
    -e 's/[[:space:]]*$//' \
    -e 's/^[[:space:]]*//' \
    -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
   < $CONFIG_FILE \
    | sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

# Make sure the data folder exists
mkdir -p $data_folder

if [ -z "$1" ]
	then 
		echo "Start sampling indefinitely in the foreground...";
		while true;
			do
				awk -f ./monitor/monitor.awk -v "samples=1" -v "folder=$data_folder" -v "interval=0" hosts.db;
				sleep $sample_interval;
		done
	else
		echo "Start taking $1 samples in the background...";
		awk -f ./monitor/monitor.awk -v "samples=$1" -v "folder=$data_folder" -v "interval=$sample_interval" hosts.db
fi