## practice: init

1\. Change `/etc/inittab` so that only two mingetty\'s are respawned.
Kill the other `mingetty's` and verify that they don\'t come back.

2\. Use the Red Hat Enterprise Linux virtual machine. Go to runlevel 5,
display the current and previous runlevel, then go back to runlevel 3.

3\. Is the sysinit script on your computers setting or changing the PATH
environment variable ?

4\. List all init.d scripts that are started in runlevel 2.

5\. Write a script that acts like a daemon script in `/etc/init.d/`. It
should have a case statement to act on start/stop/restart and status.
Test the script!

6\. Use `chkconfig` to setup your script to start in runlevels 3,4 and
5, and to stop in any other runlevel.

