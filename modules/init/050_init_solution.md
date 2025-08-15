## solution : init

1. Change `/etc/inittab` so that only two mingetty's are respawned.
Kill the other `mingetty's` and verify that they don't come back.

Killing the mingetty's will result in init respawning them. You can
edit `/etc/inittab` so it looks like the screenshot below. Don't forget
to also run `kill -1 1`.

    [root@linux ~]# grep tty /etc/inittab 
    # Run gettys in standard runlevels
    1:2345:respawn:/sbin/mingetty tty1
    2:2345:respawn:/sbin/mingetty tty2
    3:2:respawn:/sbin/mingetty tty3
    4:2:respawn:/sbin/mingetty tty4
    5:2:respawn:/sbin/mingetty tty5
    6:2:respawn:/sbin/mingetty tty6
    [root@linux ~]# 
        

2. Use the Red Hat Enterprise Linux virtual machine. Go to runlevel 5,
display the current and previous runlevel, then go back to runlevel 3.

    init 5 (watch the console for the change taking place)
    runlevel
    init 3 (again you can follow this on the console)
        

3. Is the sysinit script on your computers setting or changing the PATH
environment variable ?

On Red Hat, grep for PATH in `/etc/rc.sysinit`, on Debian/Ubuntu check
`/etc/rc.local` and `/etc/ini.t/rc.local`. The answer is probably no,
but on RHEL5 the `rc.sysinit` script does set the HOSTNAME variable.

    [root@linux etc]# grep HOSTNAME rc.sysinit
        

4. List all init.d scripts that are started in runlevel 2.

    root@linux ~# chkconfig --list | grep '2:on'
        

5. Write a script that acts like a daemon script in `/etc/init.d/`. It
should have a case statement to act on start/stop/restart and status.
Test the script!

The script could look something like this.

    #!/bin/bash
    #
    # chkconfig: 345 99 01 
    # description: pold demo script
    #
    # /etc/init.d/pold
    #

    case "$1" in
      start)
         echo -n "Starting pold..."
         sleep 1;
         touch /var/lock/subsys/pold
         echo "done."
         echo pold started >> /var/log/messages
         ;;
      stop)
         echo -n "Stopping pold..."
         sleep 1;
         rm -rf /var/lock/subsys/pold
         echo "done."
         echo pold stopped >> /var/log/messages
         ;;
      *)
         echo "Usage: /etc/init.d/pold {start|stop}"
         exit 1
         ;;
    esac
    exit 0
        

The `touch /var/lock/subsys/pold` is mandatory and must be the same
filename as the script name, if you want the stop sequence (the K01pold
link) to be run.

6. Use `chkconfig` to setup your script to start in runlevels 3,4 and
5, and to stop in any other runlevel.

    chkconfig --add pold

The command above will only work when the `# chkconfig:` and
`# description:` lines in the pold script are there.

