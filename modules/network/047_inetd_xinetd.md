# xinetd and inetd

## the superdaemon

Back when resources like RAM memory were limited, a super-server was
devised to listen to all sockets and start the appropriate daemon only
when needed. Services like `swat`, `telnet`
and `ftp` are typically served by such a super-server. The
`xinetd` superdaemon is more recent than
`inetd`. We will discuss the configuration both daemons.

Recent Linux distributions like RHEL5 and Ubuntu10.04 do not activate
`inetd` or `xinetd` by default, unless an application requires it.

## inetd or xinetd

First verify whether your computer is running `inetd` or `xinetd`. This
Debian 4.0 Etch is running `inetd`.

    root@linux:~# ps fax | grep inet
     3870 ?        Ss     0:00 /usr/sbin/inetd
            

This Red Hat Enterprise Linux 4 update 4 is running `xinetd`.

    [root@linux ~]# ps fax | grep inet
     3003 ?        Ss     0:00 xinetd -stayalive -pidfile /var/run/xinetd.pid
            

Both daemons have the same functionality (listening to many ports,
starting other daemons when they are needed), but they have different
configuration files.

## xinetd superdaemon

The `xinetd` daemon is often called a superdaemon because
it listens to a lot of incoming connections, and starts other daemons
when they are needed. When a connection request is received, `xinetd`
will first check TCP wrappers (/etc/hosts.allow and /etc/hosts.deny) and
then give control of the connection to the other daemon. This
superdaemon is configured through `/etc/xinetd.conf` and
the files in the directory `/etc/xinetd.d`. Let\'s first
take a look at /etc/xinetd.conf.

    student@linux:~$ cat /etc/xinetd.conf 
    #
    # Simple configuration file for xinetd
    #
    # Some defaults, and include /etc/xinetd.d/
                    
    defaults
    {
    instances               = 60
    log_type                = SYSLOG authpriv
    log_on_success          = HOST PID
    log_on_failure          = HOST
    cps                     = 25 30
    }
                    
    includedir /etc/xinetd.d
                    
    student@linux:~$ 
            

According to the settings in this file, xinetd can handle 60 client
requests at once. It uses the `authpriv` facility to log the host
ip-address and pid of successful daemon spawns. When a service (aka
protocol linked to daemon) gets more than 25 cps (connections per
second), it holds subsequent requests for 30 seconds.

The directory `/etc/xinetd.d` contains more specific configuration
files. Let\'s also take a look at one of them.

    student@linux:~$ ls /etc/xinetd.d
    amanda     chargen-udp  echo      klogin       rexec   talk
    amandaidx  cups-lpd     echo-udp  krb5-telnet  rlogin  telnet
    amidxtape  daytime      eklogin   kshell       rsh     tftp
    auth       daytime-udp  finger    ktalk        rsync   time
    chargen    dbskkd-cdb   gssftp    ntalk        swat    time-udp
    student@linux:~$ cat /etc/xinetd.d/swat 
    # default: off
    # description: SWAT is the Samba Web Admin Tool. Use swat \
    #              to configure your Samba server. To use SWAT, \
    #              connect to port 901 with your favorite web browser.
    service swat
    {
    port            = 901
    socket_type     = stream
    wait            = no
    only_from       = 127.0.0.1
    user            = root
    server          = /usr/sbin/swat
    log_on_failure  += USERID
    disable         = yes
    }
    student@linux:~$
            

The services should be listed in the `/etc/services` file.
Port determines the service port, and must be the same as the port
specified in /etc/services. The `socket_type` should be set to `stream`
for tcp services (and to dgram for udp). The `log_on_failure +=` concats
the userid to the log message formatted in /etc/xinetd.conf. The last
setting `disable` can be set to yes or no. Setting this to `no` means
the service is enabled!

Check the xinetd and xinetd.conf manual pages for many more
configuration options.

## inetd superdaemon

This superdaemon has only one configuration file
`/etc/inetd.conf`. Every protocol or daemon that it is
listening for, gets one line in this file.

    root@linux:~# grep ftp /etc/inetd.conf 
    tftp dgram udp wait nobody /usr/sbin/tcpd /usr/sbin/in.tftpd /boot/tftp
    root@linux:~#
            

You can disable a service in inetd.conf above by putting a \# at the
start of that line. Here an example of the disabled vmware web interface
(listening on tcp port 902).

    student@linux:~$ grep vmware /etc/inetd.conf 
    #902 stream tcp nowait root /usr/sbin/vmware-authd vmware-authd
            

