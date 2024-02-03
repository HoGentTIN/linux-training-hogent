## man \$command

Type `man` followed by a command (for which you want help)
and start reading. Press `q` to quit the manpage. Some man pages contain
examples (near the end).

    paul@laika:~$ man whois
    Reformatting whois(1), please wait...

## man \$configfile

Most `configuration files` have their own manual.

    paul@laika:~$ man syslog.conf
    Reformatting syslog.conf(5), please wait...

## man \$daemon

This is also true for most `daemons` (background programs)
on your system..

    paul@laika:~$ man syslogd
    Reformatting syslogd(8), please wait...

## man -k (apropos)

`man -k` (or `apropos`) shows a list of man
pages containing a string.

    paul@laika:~$ man -k syslog
    lm-syslog-setup (8)  - configure laptop mode to switch syslog.conf ...
    logger (1)           - a shell command interface to the syslog(3) ...
    syslog-facility (8)  - Setup and remove LOCALx facility for sysklogd
    syslog.conf (5)      - syslogd(8) configuration file
    syslogd (8)          - Linux system logging utilities.
    syslogd-listfiles (8) - list system logfiles

## whatis

To see just the description of a manual page, use `whatis`
followed by a string.

    paul@u810:~$ whatis route
    route (8)            - show / manipulate the IP routing table

## whereis

The location of a manpage can be revealed with `whereis`.

    paul@laika:~$ whereis -m whois
    whois: /usr/share/man/man1/whois.1.gz

This file is directly readable by `man`.

    paul@laika:~$ man /usr/share/man/man1/whois.1.gz

## man sections

By now you will have noticed the numbers between the round brackets.
`man man` will explain to you that these are section
numbers. Executable programs and shell commands reside in section one.

    1 Executable programs or shell commands
    2 System calls (functions provided by the kernel)
    3 Library calls (functions within program libraries)
    4 Special files (usually found in /dev)
    5 File formats and conventions eg /etc/passwd
    6 Games
    7 Miscellaneous (including macro packages and conventions), e.g. man(7)
    8 System administration commands (usually only for root)
    9 Kernel routines [Non standard]

## man \$section \$file

Therefor, when referring to the man page of the passwd command, you will
see it written as `passwd(1)`; when referring to the
`passwd file`, you will see it written as `passwd(5)`. The
screenshot explains how to open the man page in the correct section.

    [paul@RHEL52 ~]$ man passwd      # opens the first manual found
    [paul@RHEL52 ~]$ man 5 passwd    # opens a page from section 5

## man man

If you want to know more about `man`, then Read The Fantastic Manual
(RTFM).

*Unfortunately, manual pages do not have the answer to everything\...*

    paul@laika:~$ man woman
    No manual entry for woman

## mandb

Should you be convinced that a man page exists, but you can\'t access
it, then try running `mandb` on Debian/Mint.

    root@laika:~# mandb
    0 man subdirectories contained newer manual pages.
    0 manual pages were added.
    0 stray cats were added.
    0 old database entries were purged.

Or run `makewhatis` on CentOS/Redhat.

    [root@centos65 ~]# apropos scsi
    scsi: nothing appropriate
    [root@centos65 ~]# makewhatis 
    [root@centos65 ~]# apropos scsi
    hpsa                 (4)  - HP Smart Array SCSI driver
    lsscsi               (8)  - list SCSI devices (or hosts) and their attributes
    sd                   (4)  - Driver for SCSI Disk Drives
    st                   (4)  - SCSI tape device

