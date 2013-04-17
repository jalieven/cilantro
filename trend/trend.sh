#!/bin/bash -e

# This script can be called like so: ./trend.sh data-folder	host command
# It will write its calculations into the trend_file

# parse the trends ini section and declare as variables in the scope of this script
CONFIG_FILE="cilantro.ini"
SECTION="trends"

eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
    -e 's/;.*$//' \
    -e 's/[[:space:]]*$//' \
    -e 's/^[[:space:]]*//' \
    -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
   < $CONFIG_FILE \
    | sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

file_to_trend=$1"/"$2"_"$3".data"
echo "file:" $file_to_trend
cat $file_to_trend | awk "{sum+=\$2; sumsq+=\$2*\$2} END { print \"stdev: \t\",sqrt(sumsq/NR - (sum/NR)**2); print \"avg: \t\",sum/NR }"

# why not adding this to the data and showing it in the single plots?
# moving average:
# cat $file_to_trend | awk "BEGIN{size=5} {mod=NR%size; if(NR<=size){count++}else{sum-=array[mod]};sum+=\$2;array[mod]=$2;print sum/count}"