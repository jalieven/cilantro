#!/bin/bash -e

# parse the ini section and declare as variables in the scope of this script
CONFIG_FILE="cilantro.ini"
SECTION="general"

eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
    -e 's/;.*$//' \
    -e 's/[[:space:]]*$//' \
    -e 's/^[[:space:]]*//' \
    -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
   < $CONFIG_FILE \
    | sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

# Make sure the graph folder exists
mkdir -p $graph_folder

# Generate graphs from the data files
echo "Generating single graph files..."
awk -f ./graph/graph.awk -v "inputfolder=$data_folder" -v "outputfolder=$graph_folder" hosts.db

echo "Searching for data to aggregate..."
awk -f ./graph/aggregate.awk -v "inputfolder=$data_folder" -v "outputfolder=$graph_folder" hosts.db