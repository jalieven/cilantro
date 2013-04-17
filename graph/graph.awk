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
			"./graph/run-graphs.sh '"inputfolder"' '" host "' '"typecommand[2]"' '"outputfolder"/"host"_"typecommand[2]".png' '" typecommand[4] "' '" typecommand[5] "' '" typecommand[6] "' '" typecommand[7] "'" |& getline result
			print result
		} else {
        	print "line with id: ["$1 " "typecommand[2]"] is not valid: should contain 7 fields (are your tabs in order?)!"
       	}
	}
}