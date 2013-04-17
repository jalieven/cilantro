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
			"./trend/trend.sh '"inputfolder"' '"host"' '"typecommand[2]"'" |& getline result
			print result
		} else {
        	print "line with id: ["$1 " "typecommand[2]"] is not valid: should contain 7 fields (are your tabs in order?)!"
       	}
	}
}