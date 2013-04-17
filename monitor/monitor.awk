BEGIN {
	FS = "\n"
	RS = ""
	OFS = "\t"
}
{
	"echo "$1" | awk 'BEGIN{FS=\"@\"} {print $2}'" |& getline host
	count = split($0, fields)
	for(i=2; i <= count; ++i) {
		splits = split(fields[i], typecommand, "([\t])+")
		if(splits == 7) {
			# sampling in the background
			system("for i in $(seq 1 "samples"); do echo $(date +'%m-%d-%H:%M:%S') $(ssh -n "$1" "typecommand[3]") >> "folder"/"host"_"typecommand[2]".data; sleep "interval"; done &")
		} else {
			print "line with id: ["$1 " "typecommand[2]"] is not valid: should contain 7 fields (are your tabs in order?)!"
		}
	}
}

