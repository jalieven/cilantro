BEGIN {
	FS = "\n"
	RS = ""
    OFS = "\t"
}
{
	"echo "$1" | awk 'BEGIN{FS=\"@\"} {print $2}'" |& getline host
	count = split($0, fields)
	for(i=2; i <= count; ++i) {
		splits = split(fields[i], typecommand, "\t+")
		if(splits == 7) {
			if(length(commands[typecommand[2]]) == 0) {
				commands[typecommand[2]] = host
			} else {
				commands[typecommand[2]] = commands[typecommand[2]] "," host
			}
			data[typecommand[2]"@unit"] = typecommand[4];
			data[typecommand[2]"@title"] = typecommand[5];
			data[typecommand[2]"@startx"] = typecommand[6];
			data[typecommand[2]"@zeroy"] = typecommand[7];
		} else {
			print "line with id: ["$1 " "typecommand[2]"] is not valid: should contain 7 fields (are your tabs in order?)!"
		}
	}
}
END {
	print "Found duplicate id's:"
	for (i in commands) {
		# for every duplicate gather all the data-files and
		hostcount = split(commands[i], hosts,",")
		if(hostcount >= 2) {
			for(h = 1; h <= hostcount; ++h) {
				#print i ": " hosts[h]
				#print "data: "data[i"@unit"]
			}
			"./graph/run-graphs.sh '"inputfolder"' '" commands[i] "' '"i"' '"outputfolder"/aggregate_"i".png' '" data[i"@unit"] "' '" data[i"@title"] "' '" data[i"@startx"] "' '" data[i"@zeroy"] "'" |& getline result
			print result
		}

	}
}