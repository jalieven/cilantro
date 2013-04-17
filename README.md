Cilantro
========

A straightforward performance monitor tool for the data-center written in tru Taco-Bell style (awk, sed, ssh and your
pick of monitoring commands) sugarcoated with Bootstrap and AngularJs.
So basically Cilantro is a bunch of scripts that will ssh to a bunch of hosts and perform a bunch of sampling commands
and then generate a bunch of graphs from those samples. Those generated graphs can then be viewed in the web-interface.
The most erratic/temporarily high-valued graphs will appear in the carousel this way you'll only look at graphs that matter.

## Dependencies

```
ssh
awk
sed
```
It needn't be said that the all the sampling commands you configure need their own dependencies. It is your responsibility
to install those dependencies on the monitored machines.

## Structure

The first part you should check out is the *hosts.db* file. This is the central config file that contains the configuration
to monitor your server-park and the config info to mark-up the associated graphs that are to be generated from the sampling data.

The hosts.db file should follow the following record structure (tabbed separated):

```
user@host
    command-id	sample-command		command-unit      graph-title 	time-start  zero-start-y-axis-boolean	sleep-seconds-interval
<blank_line>
```

* **command-id**: User-defined id that will be used in the sample-data and graph filenames. The id does not have to be unique for the whole file.
    **It is the combination host/command-id that must be unique over the whole file!!!** When providing the same command-id in different host-records
    an aggregate graph will be generated containing all the hosts samples. This way meaningful comparing-graphs between hosts can be achieved,
    provided the sample-commands are equal in meaning of course. *Make sure to not use weird characters in this id since it will be used in filenames.*

* **sample-command**: This can be anything really as long as the command always results in a number with the same meaning!
    Some examples:
    ```bash
    free -m | awk '/Mem:/ {print $4}'           # wich samples the free memory in megabytes on an Ubuntu machine
    cat /proc/loadavg | awk '{ print $1 }'      # which samples the 1 minute average cpu load on an Ubuntu machine
    ```

* **command-unit**: This value will be used as a title on the y-axis of the generated graph and simply states the units of the sampled data.
    eg. kilobytes, percentage, load averages, MB/s, ...

* **graph-title**: This value will be used as the title for the generated graph. Note that in case of comparing-graphs the graph-title of the first
    record will be used.

* **time-start**: This human readable indication points to the left most timestamp on the x-axis. Values can be any human readable date string.
    Refer to manpages of the *nix date-command, more specifically the date string section.
    Some examples:

    + '1 day ago'       which results in a graph that depicts samples from yesterday until the most recent sample timestamp
    + 'last Fri'        which results in a graph that depicts samples from last friday until the most recent sample timestamp
    + '-'               when the dash is used you indicate you want the graph to span all the gathered samples
    + '@2147483647'     if you want to be really specific about your starting x-coordinate


* **zero-start-y-axis-boolean**: The name says it all, if set to true the y-axis will start at zero any other value will result
    in a graph which starts at the lowest sample value for the provided time-interval.

* **sleep-seconds-interval**: Seconds to sleep between samples being taken. Note that this does not mean the timestamps of the samples
    will be exactly spaced by the sleep-seconds-interval because ssh'ing into the server can sometimes take some time.
    It is generally a good idea to set this to a value to something like 5 seconds.

Cilantro consists of 3 script parts:
* The *lets-push-our-ssh-rsa-key-file-to-all-our-servers* script aka '0-push-rsa-key.sh'. Needless to say you'll want to perform this one first.
* The *lets-gather-some-samples* script aka '1-gather-samples.sh'. This script will fork for every line in your hosts.db file and sample via the provided command.
* The *lets-unleash-gnuplot* script aka '2-generate-graphs.sh'. This script will transform the raw samples into a graph.

### Push RSA key

The 0-push-rsa-key.sh can be used to propagate your rsa-key to all the hosts in your hosts.db file.
If you need to use multiple pem files to login your server collection you need to use a ssh client config file
So you do not need to execute this script if you have a config file in your .ssh directory.
In case of an amazon aws this file could be:

```
Host amazon-one
	Hostname	ec2-50-16-6-230.compute-1.amazonaws.com
	User		ubuntu
	IdentityFile	~/.ssh/amazon-one.pem
```

In this example you could use *amazon-one* as the host for your hosts.db record.
When executing the '0-push-rsa-key.sh' script be prepared to provide all the passwords for all the configured hosts.

### Gathering samples

When performing the '1-gather-samples.sh' the sampled data will be appended to a file inside the data-folder (the location of this data-folder can be configured in the cilantro.conf file)

### Generating graphs



