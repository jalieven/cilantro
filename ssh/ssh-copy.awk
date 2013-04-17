BEGIN {
	FS = "\n"
	RS = ""
        OFS = "\t"
}
{
	count = split($0, fields)
	for(i=2; i <= count; ++i) {
		splits = split(fields[i], typecommand, "\t+")
		if(splits == 5 || splits == 6 || splits == 7) {
                        "ssh-copy-id -i " key_file " " $1 |& getline result
			print result
		}
	}
}