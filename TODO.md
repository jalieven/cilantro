# TODO's

## general

* make debian package (that installs the 2-generate-graphs script in cron for example and the 1-gather-samples scripts as a daemon) usinf FPM

## gather-samples

* comparing-graphs functionality (how to solve clashing graph-titles when same command-id was provided?)
* fix forking structure:
    can we gather all samples in one ssh-session so that we don't generate so many ssh-sessions on the servers? or do we
    than make the sleep-seconds-interval field obsolete on a per command basis?

## generate graphs

* cleanup timespan to make sure the data-files can be cleaned and old data can be removed (compressed maybe?)
* make sure this sentence is correct: zero-start-y-axis-boolean -> any other value will result in a graph which starts
    at the lowest sample value FOR THE PROVIDED time-interval, not the lowest sample of all available samples!
* fix possible bug in date-compare.awk drops first line?

## web interface

* erratic/unusual-valued graphs algorithm for controlling the carousel
* plug-in AngularJs to propel the form-parts of the interface
* think about a responsive interface, how to best display en filter the graphs