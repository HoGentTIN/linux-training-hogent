# init

## About System-V style init


The **init** system discussed in this chapter is (or rather was) since
the 1980s a standard way to start several daemons on SysV Unix and
derivatives. The **Linux** project was started in 1991 and adopted this
**init** style.

The past couple of years most Linux distributions have migrated to
**systemd** (this is the next chapter). Debian 10 is still backwards
compatible with **services** that use **init** instead of **systemd**,
so we will first discuss this **init** system.

The Linux kernel still starts **/sbin/init** as PID 1, but this is a
link to **systemd**.

    root@server2:# ls -l /sbin/init
    lrwxrwxrwx 1 root root 20 May 24 22:58 /sbin/init -> /lib/systemd/systemd
    root@server2:#

## /etc/init.d


Services or daemons that still use **init** have a script in
**/etc/init.d**. This script expects a **start** or **stop** as
parameter to start or stop the service. Often keywords like **status**
and **restart** are also supported.

Most services however are integrated in **systemd** even if they have a
script here.

    root@server2:# /etc/init.d/ssh status | head -2
    ● ssh.service - OpenBSD Secure Shell server
       Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
    root@server2:#

Typing **service ssh restart** used to just run the script in
**/etc/init.d**, but is now captured by **systemctl** if the service is
present in **systemd**.

## runlevel


Typical for **init** style systems is that they are running in a
**runlevel**. Runlevel 0 is shutdown, runlevel 6 is reboot, runlevel S
and 1 are single user mode, runlevel 2 to 5 are multiuser modes. The two
runlevel commands, **runlevel** and **who -r** still report this
runlevel.

    root@server2:# runlevel
    N 5
    root@server2:# who -r
             run-level 5  2019-09-04 22:50
    root@server2:~#

## /etc/rc?.d


To see which init scripts are run in **runlevel 5**, execute an **ls**
in **/etc/rc5.d**. In that directory are symbolic links to
**/etc/init.d**.

    root@server2:# ls -l /etc/rc5.d/ | head -6
    total 0
    lrwxrwxrwx 1 root root 17 Aug 22 17:42 S01anacron -> ../init.d/anacron
    lrwxrwxrwx 1 root root 19 Aug 22 17:42 S01bluetooth -> ../init.d/bluetooth
    lrwxrwxrwx 1 root root 26 Aug 22 17:37 S01console-setup.sh -> ../init.d/console-setup.sh
    lrwxrwxrwx 1 root root 14 Aug 22 17:36 S01cron -> ../init.d/cron
    lrwxrwxrwx 1 root root 14 Aug 22 17:42 S01dbus -> ../init.d/dbus
    root@server2:#

The **init runlevel** is replaced in **systemd** by a **systemd
target**.

## init 6 and reboot


Commands like **init 1** to go to single user mode or **init 6** to
reboot are still supported. But remember that **/sbin/init** is a
symbolic link to **systemd** so it is **systemd** that is performing
these **runlevel** changes.

    root@server2:# file $(which init)
    /usr/sbin/init: symbolic link to /lib/systemd/systemd
    root@server2:# init 6
    Connection to 192.168.56.102 closed by remote host.
    Connection to 192.168.56.102 closed.

The commands **reboot**, **shutdown** and **poweroff** are also
performed by **systemd** now.

## update-rc.d

The **update-rc.d** tool manages the runlevels in which daemons are
started or stopped. It will do this by creating (and removing) links in
the **/etc/rc?.d** directories.

    root@server2:# find /etc/rc?.d/  -name '*ssh' -exec ls -l {} \;
    lrwxrwxrwx 1 root root 13 Aug 22 17:43 /etc/rc2.d/S01ssh -> ../init.d/ssh
    lrwxrwxrwx 1 root root 13 Aug 22 17:43 /etc/rc3.d/S01ssh -> ../init.d/ssh
    lrwxrwxrwx 1 root root 13 Aug 22 17:43 /etc/rc4.d/S01ssh -> ../init.d/ssh
    lrwxrwxrwx 1 root root 13 Aug 22 17:43 /etc/rc5.d/S01ssh -> ../init.d/ssh
    root@server2:# update-rc.d ssh remove
    root@server2:# find /etc/rc?.d/  -name '*ssh' -exec ls -l {} \;
    root@server2:# update-rc.d ssh defaults
    root@server2:# find /etc/rc?.d/  -name '*ssh' -exec ls -l {} \;
    lrwxrwxrwx 1 root root 13 Sep  5 11:41 /etc/rc2.d/S01ssh -> ../init.d/ssh
    lrwxrwxrwx 1 root root 13 Sep  5 11:41 /etc/rc3.d/S01ssh -> ../init.d/ssh
    lrwxrwxrwx 1 root root 13 Sep  5 11:41 /etc/rc4.d/S01ssh -> ../init.d/ssh
    lrwxrwxrwx 1 root root 13 Sep  5 11:41 /etc/rc5.d/S01ssh -> ../init.d/ssh
    root@server2:#

Disabling ssh with **update-rc.d** has no effect anymore since the ssh
service is still enabled via **systemd**, while enabling ssh with
**update-rc.d** will also enable ssh with **systemd**.

This chapter will be removed in future editions of this book.

## Cheat sheet

<table>
<caption>init</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/sbin/init</p></td>
<td style="text-align: left;"><p>The first process started by the
kernel.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/etc/init.d</p></td>
<td style="text-align: left;"><p>Legacy location for daemon/application
startup scripts.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>runlevel</p></td>
<td style="text-align: left;"><p>Legacy command to display the current
runlevel.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>who -r</p></td>
<td style="text-align: left;"><p>Legacy command to display the current
runlevel.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>init 6</p></td>
<td style="text-align: left;"><p>Legacy <strong>reboot</strong>
command.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>update-rc.d</p></td>
<td style="text-align: left;"><p>Legacy command to configure
runlevels.</p></td>
</tr>
</tbody>
</table>

init
