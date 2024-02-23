## solution : logging

1\. Display the /var/run/utmp file.

    who

2\. Display the /var/log/wtmp file.

    last

3\. Use the lastlog and lastb commands, understand the difference.

    lastlog : when users last logged on

    lastb: failed (bad) login attempts

4\. Examine syslog to find the location of the log file containing ssh
failed logins.

Answer depends on whether you machine uses `syslog` or `rsyslog`
(newer).

    [root@linux ~]# grep authpriv /etc/syslog.conf
    authpriv.*                                              /var/log/secure

    [root@linux ~]# grep ^authpriv /etc/rsyslog.conf
    authpriv.*                                              /var/log/secure

    student@linux:~$ grep ^auth /etc/rsyslog.conf
    auth,authpriv.*                   /var/log/auth.log

5\. Configure syslog to put local4.error and above messages in
/var/log/l4e.log and local4.info only .info in /var/log/l4i.log. Test
that it works with the logger tool!

With `syslog:`

    echo local4.error /var/log/l4e.log >> /etc/syslog.conf
    echo local4.=info /var/log/l4i.log >> /etc/syslog.conf
    service syslog restart

With `rsyslog:`

    echo local4.error /var/log/l4e.log >> /etc/rsyslog.conf
    echo local4.=info /var/log/l4i.log >> /etc/rsyslog.conf
    service rsyslog restart

On both:

    logger -p local4.error "l4 error test"
    logger -p local4.alert "l4 alert test"
    logger -p local4.info "l4 info test"
    cat /var/log/l4e.log
    cat /var/log/l4i.log

6\. Configure /var/log/Mysu.log, all the su to root messages should go
in that log. Test that it works!

    echo authpriv.*  /var/log/Mysu.log >> /etc/syslog.conf

This will log more than just the `su` usage.

7\. Send the local5 messages to the syslog server of your neighbour.
Test that it works.

On RHEL5, edit `/etc/sysconfig/syslog` to enable remote listening on the
server.

On RHEL7, uncomment these two lines in `/etc/rsyslog.conf` to enable
\'UDP syslog reception\'.

    # Provides UDP syslog reception
    $ModLoad imudp
    $UDPServerRun 514

On Debian/Ubuntu edit `/etc/default/syslog` or `/etc/default/rsyslog`.

    on the client: logger -p local5.info "test local5 to neighbour"

8\. Write a script that executes logger to local4 every 15 seconds
(different message). Use tail -f and watch on your local4 log files.

    root@linux scripts# cat logloop 
    #!/bin/bash

    for i in `seq 1 10`
    do
    logger -p local4.info "local4.info test number $i"
    sleep 15
    done

    root@linux scripts# chmod +x logloop
    root@linux scripts# ./logloop &
    [1] 8264
    root@linux scripts# tail -f /var/log/local4.all.log 
    Mar 28 13:13:36 rhel53 root: local4.info test number 1
    Mar 28 13:13:51 rhel53 root: local4.info test number 2
    ...

