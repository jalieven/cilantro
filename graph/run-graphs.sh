#!/bin/bash -e
# This script must be called: ./run-graphs.sh	inputfolder		hosts	command-id 	output.png 	y-label 	graph-title		human-readable-start-time-x-axis	zero-start-y-axis-boolean
# ./graph/run-graphs.sh './data' 	'multivac,localhost' 	'io-read' './png/aggregate_io-read.png' 'megabytes' 'SDA IO read/s' '10 minutes ago' 'true'

if [ -z "$1" ]; then echo "No data folder supplied"; else echo "Using data folder: '"$1"'"; fi
if [ -z "$2" ]; then echo "No hosts list supplied"; else echo "Generating for hosts: '"$2"'"; fi
if [ -z "$3" ]; then echo "No command supplied"; else echo "Generating for command: '"$3"'"; fi
if [ -z "$4" ]; then echo "No output file file supplied"; else echo "Generating file: '"$4"'"; fi
if [ -z "$5" ]; then echo "No unit supplied"; else echo "Using unit: '"$5"'"; fi
if [ -z "$6" ]; then echo "No graph title supplied"; else echo "Using graph title: '"$6"'"; fi
if [ -z "$7" ]; then echo "No start time x-axis supplied"; else echo "Generating with start time x-axis: '"$7"'"; fi
if [ -z "$8" ]; then echo "No zero start y-axis boolean supplied"; else echo "Generating with zero start y-axis boolean: '"$8"'"; fi

# parse the ini section and declare as variables in the scope of this script
CONFIG_FILE="cilantro.ini"
SECTION="graphs"

eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
    -e 's/;.*$//' \
    -e 's/[[:space:]]*$//' \
    -e 's/^[[:space:]]*//' \
    -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
   < $CONFIG_FILE \
    | sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

# first calculate moving averages


# TODO cat all data-files and calculate all ranges
hosts=$(echo $2 | tr "," "\n")
hostsspaced=$(echo $2 | tr "," " ")

for host in $hosts
do
	#echo $1"/"$host"_"$3".data"

	y_curr_min=$(cat $1"/"$host"_"$3".data" | awk '{print $2}' | sort | head -n 1)
    y_curr_max=$(cat $1"/"$host"_"$3".data" | awk '{print $2}' | sort -r | head -n 1)

	x_curr_min=$(cat $1"/"$host"_"$3".data" | sort | head -n 1 | awk '{print $1}')
    x_curr_max=$(cat $1"/"$host"_"$3".data" | sort -r | head -n 1 | awk '{print $1}')

    if [ -z "$x_range_max" ]; then x_range_max=$x_curr_max; fi
    if [ -z "$x_range_min" ]; then x_range_min=$x_curr_min; fi

    if [ -z "$y_range_max" ]; then y_range_max=$y_curr_max; fi
    if [ -z "$y_range_min" ]; then y_range_min=$y_curr_min; fi

	x_range_min=$(echo $x_curr_min"@"$x_range_min | tr "@" "\n" | sort | head -n 1 | awk '{print $1}')
    x_range_max=$(echo $x_curr_max"@"$x_range_max | tr "@" "\n" | sort -r | head -n 1 | awk '{print $1}')

    y_range_min=$(echo $y_curr_min"@"$y_range_min | tr "@" "\n" | sort | head -n 1 | awk '{print $1}')
    y_range_max=$(echo $y_curr_max"@"$y_range_max | tr "@" "\n" | sort -r | head -n 1 | awk '{print $1}')

done

#echo "X-range-min: "$x_range_min
#echo "X-range-max: "$x_range_max

#echo "Y-range-min: "$y_range_min
#echo "Y-range-max: "$y_range_max

# add one to make flat high values appear
y_range_max=$(echo $y_range_max + 1 |bc)

if [ "$7" = "-" ]; then echo "No start time x-axis: using minimum in data"; else x_range_min=$(date --date="$7" "+%m-%d-%H:%M:%S"); fi
if [ "$8" != "true" ]; then echo "No zero y-axis start: using min in data"; else y_range_min=0; fi

(sed -e "s|%output-file%|$4|g"  \
	-e "s|%format%|$graph_format|g"  \
	-e "s|%x-size%|$x_size|g"  \
	-e "s|%y-size%|$y_size|g"  \
	-e "s|%line-type%|$line_type|g"  \
	-e "s|%line-width%|$line_width|g"  \
	-e "s|%point-interval-gap%|$point_interval_gap|g"  \
	-e "s|%point-type%|$point_type|g"  \
	-e "s|%point-size%|$point_size|g"  \
	-e "s|%x-axis-time-format%|$x_time_format|g"  \
	-e "s|%y-label%|$5|g" \
	-e "s|%graph-title%|$6|g" \
	-e "s|%x-range-start%|$x_range_min|g"  \
	-e "s|%x-range-end%|$x_range_max|g"  \
	-e "s|%y-range-start%|$y_range_min|g"  \
	-e "s|%y-range-end%|$y_range_max|g" ./graph/prepare.conf

	sed -e "s|%hosts%|$hostsspaced|g" -e "s|%input-folder%|$1|g" -e "s|%command%|$3|g" ./graph/plot.conf

) | gnuplot
