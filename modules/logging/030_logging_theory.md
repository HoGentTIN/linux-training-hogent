## login logging

To keep track of who is logging into the system, Linux can maintain the
`/var/log/wtmp`, `/var/log/btmp`,
`/var/run/utmp` and `/var/log/lastlog`
files.

### /var/run/utmp (who)

Use the `who` command to see the /var/run/utmp file. This
command is showing you all the `currently` logged in users. Notice that
the utmp file is in /var/run and not in /var/log .

    [root@rhel4 ~]# who
    paul     pts/1        Feb 14 18:21 (192.168.1.45)
    sandra   pts/2        Feb 14 18:11 (192.168.1.42)
    inge     pts/3        Feb 14 12:01 (192.168.1.33)
    els      pts/4        Feb 14 14:33 (192.168.1.19)

### /var/log/wtmp (last)

The /var/log/wtmp file is updated by the `login program`.
Use `last` to see the /var/run/wtmp file.

    [root@RHEL8a ~]# last | head
    paul     pts/1       192.168.1.45     Wed Feb 14 18:39   still logged in
    reboot   system boot 2.6.9-42.0.8.ELs Wed Feb 14 18:21          (01:15) 
    nicolas  pts/5       pc-dss.telematic Wed Feb 14 12:32 - 13:06  (00:33) 
    stefaan  pts/3       pc-sde.telematic Wed Feb 14 12:28 - 12:40  (00:12) 
    nicolas  pts/3       pc-nae.telematic Wed Feb 14 11:36 - 12:21  (00:45) 
    nicolas  pts/3       pc-nae.telematic Wed Feb 14 11:34 - 11:36  (00:01) 
    dirk     pts/5       pc-dss.telematic Wed Feb 14 10:03 - 12:31  (02:28) 
    nicolas  pts/3       pc-nae.telematic Wed Feb 14 09:45 - 11:34  (01:48) 
    dimitri  pts/5       rhel4            Wed Feb 14 07:57 - 08:38  (00:40) 
    stefaan  pts/4       pc-sde.telematic Wed Feb 14 07:16 - down   (05:50) 
    [root@RHEL8a ~]#

The last command can also be used to get a list of last reboots.

    [paul@rekkie ~]$ last reboot 
    reboot   system boot  2.6.16-rekkie   Mon Jul 30 05:13     (370+08:42)  

    wtmp begins Tue May 30 23:11:45 2006
    [paul@rekkie ~]

### /var/log/lastlog (lastlog)

Use `lastlog` to see the /var/log/lastlog file.

     [root@RHEL8a ~]# lastlog | tail
    tim              pts/5  10.170.1.122     Tue Feb 13 09:36:54 +0100 2007
    rm               pts/6  rhel4            Tue Feb 13 10:06:56 +0100 2007
    henk                                     **Never logged in**
    stefaan          pts/3  pc-sde.telematic Wed Feb 14 12:28:38 +0100 2007
    dirk             pts/5  pc-dss.telematic Wed Feb 14 10:03:11 +0100 2007
    arsene                                   **Never logged in**
    nicolas          pts/5  pc-dss.telematic Wed Feb 14 12:32:18 +0100 2007
    dimitri          pts/5  rhel4            Wed Feb 14 07:57:19 +0100 2007
    bashuserrm       pts/7  rhel4            Tue Feb 13 10:35:40 +0100 2007
    kornuserrm       pts/5  rhel4            Tue Feb 13 10:06:17 +0100 2007
    [root@RHEL8a ~]#

### /var/log/btmp (lastb)

There is also the `lastb` command to display the
`/var/log/btmp` file. This file is updated by the login
program when entering the wrong password, so it contains failed login
attempts. Many computers will not have this file, resulting in no
logging of failed login attempts.

    [root@RHEL8b ~]# lastb
    lastb: /var/log/btmp: No such file or directory
    Perhaps this file was removed by the operator to prevent logging lastb\
     info.
    [root@RHEL8b ~]#

The reason given for this is that users sometimes type their password by
mistake instead of their login, so this world readable file poses a
security risk. You can enable bad login logging by simply creating the
file. Doing a chmod o-r /var/log/btmp improves security.

    [root@RHEL8b ~]# touch /var/log/btmp
    [root@RHEL8b ~]# ll /var/log/btmp
    -rw-r--r--  1 root root 0 Jul 30 06:12 /var/log/btmp
    [root@RHEL8b ~]# chmod o-r /var/log/btmp 
    [root@RHEL8b ~]# lastb

    btmp begins Mon Jul 30 06:12:19 2007
    [root@RHEL8b ~]#

Failed logins via ssh, rlogin or su are not registered in /var/log/btmp.
Failed logins via tty are.

    [root@RHEL8b ~]# lastb
    HalvarFl tty3                  Mon Jul 30 07:10 - 07:10  (00:00)    
    Maria    tty1                  Mon Jul 30 07:09 - 07:09  (00:00)    
    Roberto  tty1                  Mon Jul 30 07:09 - 07:09  (00:00)    

    btmp begins Mon Jul 30 07:09:32 2007
    [root@RHEL8b ~]#

### su and ssh logins

Depending on the distribution, you may also have the
`/var/log/secure` file being filled with messages from the
auth and/or authpriv syslog facilities. This log will include su and/or
ssh failed login attempts. Some distributions put this in
`/var/log/auth.log`, verify the syslog configuration.

    [root@RHEL8b ~]# cat /var/log/secure
    Jul 30 07:09:03 sshd[4387]: Accepted publickey for paul from ::ffff:19\
    2.168.1.52 port 33188 ssh2
    Jul 30 05:09:03 sshd[4388]: Accepted publickey for paul from ::ffff:19\
    2.168.1.52 port 33188 ssh2
    Jul 30 07:22:27 sshd[4655]: Failed password for Hermione from ::ffff:1\
    92.168.1.52 port 38752 ssh2
    Jul 30 05:22:27 sshd[4656]: Failed password for Hermione from ::ffff:1\
    92.168.1.52 port 38752 ssh2
    Jul 30 07:22:30 sshd[4655]: Failed password for Hermione from ::ffff:1\
    92.168.1.52 port 38752 ssh2
    Jul 30 05:22:30 sshd[4656]: Failed password for Hermione from ::ffff:1\
    92.168.1.52 port 38752 ssh2
    Jul 30 07:22:33 sshd[4655]: Failed password for Hermione from ::ffff:1\
    92.168.1.52 port 38752 ssh2
    Jul 30 05:22:33 sshd[4656]: Failed password for Hermione from ::ffff:1\
    92.168.1.52 port 38752 ssh2
    Jul 30 08:27:33 sshd[5018]: Invalid user roberto from ::ffff:192.168.1\
    .52
    Jul 30 06:27:33 sshd[5019]: input_userauth_request: invalid user rober\
    to
    Jul 30 06:27:33 sshd[5019]: Failed none for invalid user roberto from \
    ::ffff:192.168.1.52 port 41064 ssh2
    Jul 30 06:27:33 sshd[5019]: Failed publickey for invalid user roberto \
    from ::ffff:192.168.1.52 port 41064 ssh2
    Jul 30 08:27:36 sshd[5018]: Failed password for invalid user roberto f\
    rom ::ffff:192.168.1.52 port 41064 ssh2
    Jul 30 06:27:36 sshd[5019]: Failed password for invalid user roberto f\
    rom ::ffff:192.168.1.52 port 41064 ssh2
    [root@RHEL8b ~]#

You can enable this yourself, with a custom log file by adding the
following line tot syslog.conf.

    auth.*,authpriv.*                 /var/log/customsec.log

## syslogd

### about syslog

The standard method of logging on Linux was through the
`syslogd` daemon. Syslog was developed by
`Eric Allman` for sendmail, but quickly became a standard
among many Unix applications and was much later written as rfc 3164. The
syslog daemon can receive messages on udp `port 514` from many
applications (and appliances), and can append to log files, print,
display messages on terminals and forward logs to other syslogd daemons
on other machines. The syslogd daemon is configured in
`/etc/syslog.conf`.

### about rsyslog

The new method is called `reliable and extended syslogd` and uses the
`rsyslogd` daemon and the `/etc/rsyslogd.conf`
configuration file. The syntax is backwards compatible.

Each line in the configuration file uses a `facility` to determine where
the message is coming from. It also contains a `priority` for the
severity of the message, and an `action` to decide on what to do with
the message.

### modules

The new `rsyslog` has many more features that can be expanded by using
modules. Modules allow for example exporting of syslog logging to a
database.

Se the manuals for more information (when you are done with this
chapter).

    root@rhel65:/etc# man rsyslog.conf
    root@rhel65:/etc# man rsyslogd
    root@rhel65:/etc#

### facilities

The `man rsyslog.conf` command will explain the different default
facilities for certain daemons, such as mail, lpr, news and kern(el)
messages. The local0 to local7 facility can be used for appliances (or
any networked device that supports syslog). Here is a list of all
facilities for rsyslog.conf version 1.3. The security keyword is
deprecated.

    auth (security)
    authpriv
    cron
    daemon
    ftp
    kern
    lpr mail
    mark (internal use only)
    news
    syslog
    user
    uucp
    local0-7

### priorities

The worst severity a message can have is `emerg` followed by `alert` and
`crit`. Lowest priority should go to `info` and `debug` messages.
Specifying a severity will also log all messages with a higher severity.
You can prefix the severity with = to obtain only messages that match
that severity. You can also specify `.none` to prevent a specific action
from any message from a certain facility.

Here is a list of all priorities, in ascending order. The keywords warn,
error and panic are deprecated.

    debug
    info
    notice
    warning (warn)
    err (error)
    crit
    alert
    emerg (panic)

### actions

The default action is to send a message to the username listed as
action. When the action is prefixed with a `/` then rsyslog will send
the message to the file (which can be a regular file, but also a printer
or terminal). The `@` sign prefix will send the message on to another
syslog server. Here is a list of all possible actions.

    root,user1      list of users, separated by comma's
    *               message to all logged on users
    /               file (can be a printer, a console, a tty, ...)
    -/              file, but don't sync after every write
    |               named pipe
    @               other syslog hostname

In addition, you can prefix actions with a - to omit syncing the file
after every logging.

### configuration

Below a sample configuration of custom local4 messages in
`/etc/rsyslog.conf`.

    local4.crit                            /var/log/critandabove
    local4.=crit                           /var/log/onlycrit
    local4.*                               /var/log/alllocal4

### restarting rsyslogd

Don\'t forget to restart the server after changing its configuration.

    root@rhel65:/etc# service rsyslog restart
    Shutting down system logger:                               [  OK  ]
    Starting system logger:                                    [  OK  ]
    root@rhel65:/etc#

## logger

The logger command can be used to generate syslog test messages. You can
also use it in scripts. An example of testing syslogd with the
`logger` tool.

    [root@RHEL8a ~]# logger -p local4.debug "l4 debug"
    [root@RHEL8a ~]# logger -p local4.crit "l4 crit"
    [root@RHEL8a ~]# logger -p local4.emerg "l4 emerg"
    [root@RHEL8a ~]#

The results of the tests with logger.

    [root@RHEL8a ~]# cat /var/log/critandabove 
    Feb 14 19:55:19 RHEL8a paul: l4 crit
    Feb 14 19:55:28 RHEL8a paul: l4 emerg
    [root@RHEL8a ~]# cat /var/log/onlycrit 
    Feb 14 19:55:19 RHEL8a paul: l4 crit
    [root@RHEL8a ~]# cat /var/log/alllocal4 
    Feb 14 19:55:11 RHEL8a paul: l4 debug
    Feb 14 19:55:19 RHEL8a paul: l4 crit
    Feb 14 19:55:28 RHEL8a paul: l4 emerg
    [root@RHEL8a ~]#

## watching logs

You might want to use the `tail -f` command to look at the
last lines of a log file. The `-f` option will dynamically display lines
that are appended to the log.

    paul@ubu1010:~$ tail -f /var/log/udev 
    SEQNUM=1741
    SOUND_INITIALIZED=1
    ID_VENDOR_FROM_DATABASE=nVidia Corporation
    ID_MODEL_FROM_DATABASE=MCP79 High Definition Audio
    ID_BUS=pci
    ID_VENDOR_ID=0x10de
    ID_MODEL_ID=0x0ac0
    ID_PATH=pci-0000:00:08.0
    SOUND_FORM_FACTOR=internal

You can automatically repeat commands by preceding them with the
`watch` command. When executing the following:

    [root@rhel6 ~]# watch who

Something similar to this, repeating the output of the `who` command
every two seconds, will appear on the screen.

    Every 2.0s: who                Sun Jul 17 15:31:03 2011

    root     tty1         2011-07-17 13:28
    paul     pts/0        2011-07-17 13:31 (192.168.1.30)
    paul     pts/1        2011-07-17 15:19 (192.168.1.30)

## rotating logs

A lot of log files are always growing in size. To keep this within
bounds, you may want to use `logrotate` to rotate,
compress, remove and mail log files. More info on the logrotate command
in `/etc/logrotate.conf.`. Individual configurations can be found in the
`/etc/logrotate.d/` directory.

Below a screenshot of the default Red Hat logrotate.conf file.

    root@rhel65:/etc# cat logrotate.conf
    # see "man logrotate" for details
    # rotate log files weekly
    weekly

    # keep 4 weeks worth of backlogs
    rotate 4

    # create new (empty) log files after rotating old ones
    create

    # use date as a suffix of the rotated file
    dateext

    # uncomment this if you want your log files compressed
    #compress

    # RPM packages drop log rotation information into this directory
    include /etc/logrotate.d

    # no packages own wtmp and btmp -- we'll rotate them here
    /var/log/wtmp {
        monthly
        create 0664 root utmp
            minsize 1M
        rotate 1
    }

    /var/log/btmp {
        missingok
        monthly
        create 0600 root utmp
        rotate 1
    }

    # system-specific logs may be also be configured here.
    root@rhel65:/etc#

