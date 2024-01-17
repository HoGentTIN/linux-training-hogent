# find

The `find` command can be very useful at the start of a
pipe to search for files. Here are some examples. You might want to add
`2>/dev/null` to the command lines to avoid cluttering your screen with
error messages.

Find all files in `/etc` and put the list in etcfiles.txt

    find /etc > etcfiles.txt

Find all files of the entire system and put the list in allfiles.txt

    find / > allfiles.txt

Find files that end in .conf in the current directory (and all subdirs).

    find . -name "*.conf"

Find files of type file (not directory, pipe or etc.) that end in .conf.

    find . -type f -name "*.conf"

Find files of type directory that end in .bak .

    find /data -type d -name "*.bak"

Find files that are newer than file42.txt

    find . -newer file42.txt

Find can also execute another command on every file found. This example
will look for \*.odf files and copy them to /backup/.

    find /data -name "*.odf" -exec cp {} /backup/ \;

Find can also execute, after your confirmation, another command on every
file found. This example will remove \*.odf files if you approve of it
for every file found.

    find /data -name "*.odf" -ok rm {} \;

# locate

The `locate` tool is very different from `find` in that it
uses an index to locate files. This is a lot faster than traversing all
the directories, but it also means that it is always outdated. If the
index does not exist yet, then you have to create it (as root on Red Hat
Enterprise Linux) with the `updatedb` command.

    [paul@RHEL8b ~]$ locate Samba
    warning: locate: could not open database: /var/lib/slocate/slocate.db:...
    warning: You need to run the 'updatedb' command (as root) to create th...
    Please have a look at /etc/updatedb.conf to enable the daily cron job.
    [paul@RHEL8b ~]$ updatedb 
    fatal error: updatedb: You are not authorized to create a default sloc...
    [paul@RHEL8b ~]$ su -
    Password: 
    [root@RHEL8b ~]# updatedb
    [root@RHEL8b ~]#

Most Linux distributions will schedule the `updatedb` to run once every
day.

# date

The `date` command can display the date, time, time zone
and more.

    paul@rhel55 ~$ date
    Sat Apr 17 12:44:30 CEST 2010

A date string can be customised to display the format of your choice.
Check the man page for more options.

    paul@rhel55 ~$ date +'%A %d-%m-%Y'
    Saturday 17-04-2010

Time on any Unix is calculated in number of seconds since 1969 (the
first second being the first second of the first of January 1970). Use
`date +%s` to display Unix time in seconds.

    paul@rhel55 ~$ date +%s
    1271501080

When will this seconds counter reach two thousand million ?

    paul@rhel55 ~$ date -d '1970-01-01 + 2000000000 seconds'
    Wed May 18 04:33:20 CEST 2033

# cal

The `cal` command displays the current month, with the
current day highlighted.

    paul@rhel55 ~$ cal
         April 2010     
    Su Mo Tu We Th Fr Sa
                 1  2  3
     4  5  6  7  8  9 10
    11 12 13 14 15 16 17
    18 19 20 21 22 23 24
    25 26 27 28 29 30

You can select any month in the past or the future.

    paul@rhel55 ~$ cal 2 1970
       February 1970    
    Su Mo Tu We Th Fr Sa
     1  2  3  4  5  6  7
     8  9 10 11 12 13 14
    15 16 17 18 19 20 21
    22 23 24 25 26 27 28

# sleep

The `sleep` command is sometimes used in scripts to wait a
number of seconds. This example shows a five second `sleep`.

    paul@rhel55 ~$ sleep 5
    paul@rhel55 ~$

# time

The `time` command can display how long it takes to
execute a command. The `date` command takes only a little time.

    paul@rhel55 ~$ time date
    Sat Apr 17 13:08:27 CEST 2010

    real    0m0.014s
    user    0m0.008s
    sys     0m0.006s

The `sleep 5` command takes five `real` seconds to execute, but consumes
little `cpu time`.

    paul@rhel55 ~$ time sleep 5

    real    0m5.018s
    user    0m0.005s
    sys     0m0.011s

This `bzip2` command compresses a file and uses a lot of
`cpu time`.

    paul@rhel55 ~$ time bzip2 text.txt 

    real    0m2.368s
    user    0m0.847s
    sys     0m0.539s

# gzip - gunzip

Users never have enough disk space, so compression comes in handy. The
`gzip` command can make files take up less space.

    paul@rhel55 ~$ ls -lh text.txt 
    -rw-rw-r-- 1 paul paul 6.4M Apr 17 13:11 text.txt
    paul@rhel55 ~$ gzip text.txt 
    paul@rhel55 ~$ ls -lh text.txt.gz 
    -rw-rw-r-- 1 paul paul 760K Apr 17 13:11 text.txt.gz

You can get the original back with `gunzip`.

    paul@rhel55 ~$ gunzip text.txt.gz 
    paul@rhel55 ~$ ls -lh text.txt
    -rw-rw-r-- 1 paul paul 6.4M Apr 17 13:11 text.txt

# zcat - zmore

Text files that are compressed with `gzip` can be viewed
with `zcat` and `zmore`.

    paul@rhel55 ~$ head -4 text.txt 
    /
    /opt
    /opt/VBoxGuestAdditions-3.1.6
    /opt/VBoxGuestAdditions-3.1.6/routines.sh
    paul@rhel55 ~$ gzip text.txt 
    paul@rhel55 ~$ zcat text.txt.gz | head -4
    /
    /opt
    /opt/VBoxGuestAdditions-3.1.6
    /opt/VBoxGuestAdditions-3.1.6/routines.sh

# bzip2 - bunzip2

Files can also be compressed with `bzip2` which takes a
little more time than `gzip`, but compresses better.

    paul@rhel55 ~$ bzip2 text.txt 
    paul@rhel55 ~$ ls -lh text.txt.bz2 
    -rw-rw-r-- 1 paul paul 569K Apr 17 13:11 text.txt.bz2

Files can be uncompressed again with `bunzip2`.

    paul@rhel55 ~$ bunzip2 text.txt.bz2 
    paul@rhel55 ~$ ls -lh text.txt 
    -rw-rw-r-- 1 paul paul 6.4M Apr 17 13:11 text.txt

# bzcat - bzmore

And in the same way `bzcat` and `bzmore` can
display files compressed with `bzip2`.

    paul@rhel55 ~$ bzip2 text.txt 
    paul@rhel55 ~$ bzcat text.txt.bz2 | head -4
    /
    /opt
    /opt/VBoxGuestAdditions-3.1.6
    /opt/VBoxGuestAdditions-3.1.6/routines.sh
