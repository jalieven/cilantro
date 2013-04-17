#!/bin/bash -e

# parse the general ini section and declare as variables in the scope of this script
CONFIG_FILE="cilantro.ini"
SECTION="general"

eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
    -e 's/;.*$//' \
    -e 's/[[:space:]]*$//' \
    -e 's/^[[:space:]]*//' \
    -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
   < $CONFIG_FILE \
    | sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

# Calculating trends from the data files
echo "Calculating trends..."
awk -f ./trend/trend.awk -v "inputfolder=$data_folder" hosts.db