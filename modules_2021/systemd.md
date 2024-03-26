# systemd

## About systemd


The **systemd software suite** replaces the **SysV Init system** on most
modern Linux distributions and this includes Debian 10. We will see that
**systemd** does a lot more than **init**.

    root@debian10:# systemd-analyze
    Startup finished in 2.382s (kernel) + 489ms (userspace) = 2.871s
    graphical.target reached after 480ms in userspace
    root@debian10:#

It’s a bit strange that **systemd** reports **graphical.target reached**
on a server without any graphical applications. It is nice though that
you can **blame** the slow services from when the system started.

    root@debian10:# systemd-analyze blame | head -5
               261ms dev-sda1.device
               132ms systemd-timesyncd.service
               118ms networking.service
                77ms keyboard-setup.service
                66ms apparmor.service
    root@debian10:#

## targets for runlevels


Instead of **runlevels** in **init**, there are now many **targets** in
**systemd**. You can list all targets with the **systemctl list-units -t
target -a** command. These target files are located in the
**/usr/lib/systemd/system/** directory.

    root@debian10:# systemctl list-units -t target -a | head -6
    UNIT                   LOAD   ACTIVE   SUB    DESCRIPTION
    basic.target           loaded active   active Basic System
    cryptsetup.target      loaded active   active Local Encrypted Volumes
    emergency.target       loaded inactive dead   Emergency Mode
    getty-pre.target       loaded inactive dead   Login Prompts (Pre)
    getty.target           loaded active   active Login Prompts
    root@debian10:#

The default target can be displayed with **systemctl get-default**.

    root@debian10:# systemctl get-default
    graphical.target
    root@debian10:#

## dependencies

There were no real dependencies with the legacy **init** system, just an
order for scripts to start. With **systemd** now a target can require
one or more targets or services. The legacy runlevels, for example, all
require a systemd target or service.

    root@debian10:/usr/lib/systemd/system# grep 'Requires=' runlevel?.target
    runlevel0.target:Requires=systemd-poweroff.service
    runlevel1.target:Requires=sysinit.target rescue.service
    runlevel2.target:Requires=basic.target
    runlevel3.target:Requires=basic.target
    runlevel4.target:Requires=basic.target
    runlevel5.target:Requires=multi-user.target
    runlevel6.target:Requires=systemd-reboot.service
    root@debian10:/usr/lib/systemd/system#

Dependencies can also be defined in the **services** themselves. See for
example the dependencies of the **ssh.service**.

    root@debian10:/usr/lib/systemd/system# grep target ssh.service
    After=network.target auditd.service
    WantedBy=multi-user.target
    root@debian10:/usr/lib/systemd/system#

All dependencies for a services can be listed with the **systemctl
list-dependencies** command, followed by the service name. On modern
terminals you get a Unicode colour output to quickly see whether a
dependency is properly active.

    root@debian10:# systemctl list-dependencies ssh | head -6
    ssh.service
    * |--.mount
    * |-system.slice
    * `-sysinit.target
    *   |-apparmor.service
    *   |-dev-hugepages.mount
    root@debian10:#

## systemctl enable


To **enable** a service, this means to have it automatically start at
boot time and to have it stay active, you can issue the **systemctl
enable** command followed by the service name. The service name can be
abbreviated.

    root@debian10:# systemctl enable ssh.service
    Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
    Executing: /lib/systemd/systemd-sysv-install enable ssh
    root@debian10:# systemctl enable ssh
    Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
    Executing: /lib/systemd/systemd-sysv-install enable ssh
    root@debian10:~#

Note that an **enable** command will not immediately start the service.

## systemctl start

To **start** a service there is **systemctl start** followed by the name
of the service. This will start the service immediately, and is
independent of the **enabled** or **disabled** state of this service.
The same is true when **stopping** a service.

    root@debian10:# systemctl stop ssh
    root@debian10:# systemctl start ssh
    root@debian10:~#

Remember when there is no output after executing a command, then all
went well.

## systemctl status

The **systemctl status** command will give a lot of information about
the status of a service, including the last logging messages for this
service.

    root@debian10:# systemctl status ssh
    * ssh.service - OpenBSD Secure Shell server
       Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
       Active: active (running) since Thu 2019-09-05 13:41:22 CEST; 2h 37min ago
         Docs: man:sshd(8)
               man:sshd_config(5)
      Process: 1133 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
     Main PID: 1134 (sshd)
        Tasks: 1 (limit: 1149)
       Memory: 2.8M
       CGroup: /system.slice/ssh.service
               `-1134 /usr/sbin/sshd -D

    Sep 05 13:41:22 debian10 systemd[1]: Starting OpenBSD Secure Shell server...
    Sep 05 13:41:22 debian10 sshd[1134]: Server listening on 0.0.0.0 port 22.
    Sep 05 13:41:22 debian10 sshd[1134]: Server listening on :: port 22.
    Sep 05 13:41:22 debian10 systemd[1]: Started OpenBSD Secure Shell server.
    Sep 05 16:16:57 debian10 sshd[1318]: Accepted password for paul from 192.168.56.1 port 39
    Sep 05 16:16:57 debian10 sshd[1318]: pam_unix(sshd:session): session opened for user paul
    root@debian10:#

## systemctl poweroff

The SysV init commands **halt**, **poweroff**, **shutdown**, and
**reboot** can still be used, but are handled by **systemd** now.
Remember also that **reboot -h** does not print a help message ;-)

    root@debian10:~# reboot -h
    Connection to 192.168.56.101 closed by remote host.
    Connection to 192.168.56.101 closed.

## remote systemd

The **systemctl** tool can access remote hosts and execute **systemctl**
commands there. You can also start, stop, enable and disable remote
services. And of course you can also remotely reboot etcetera.

    root@debian10:# systemctl -H root@10.0.2.102 status ssh
    root@10.0.2.102's password:
    * ssh.service - OpenBSD Secure Shell server
       Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
       Active: active (running) since Thu 2019-09-05 16:36:31 CEST; 49s ago
         Docs: man:sshd(8)
               man:sshd_config(5)
      Process: 551 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
     Main PID: 559
        Tasks: 1 (limit: 2359)
       Memory: 5.8M
       CGroup: /system.slice/ssh.service
               `-559 /usr/sbin/sshd -D
    root@debian10:#

## creating a service

This humble process of creating your own service explains a bit how the
systemd service model works. First we create a script that logs some
messages, you can put this script anywhere.

    root@debian10:# cat /etc/init.d/myservice.sh
    echo Starting my service...

    while true
    do
            echo "The service still runs..."
            sleep 60
    done
    root@debian10:#

Then we need to create a **.service** file in **/etc/systemd/system/**.
Do not put your file in **/lib/systemd/system/**. Then we enable and
start the service.

    root@debian10:# cat /etc/systemd/system/myservice.service
    [Unit]
    Description=My Service

    [Service]
    Type=simple
    ExecStart=/bin/bash /etc/init.d/myservice.sh

    [Install]
    WantedBy=multi-user.target
    root@debian10:# systemctl enable myservice
    Created symlink /etc/systemd/system/multi-user.target.wants/myservice.service -> /etc/systemd/system/myservice.service.
    root@debian10:# systemctl start myservice
    root@debian10:#

The last action is to check that the service is running properly.

    root@debian10:# systemctl status myservice
    * myservice.service - My Service
       Loaded: loaded (/etc/systemd/system/myservice.service; enabled; vendor preset: enabled
       Active: active (running) since Thu 2019-09-05 17:21:11 CEST; 4s ago
     Main PID: 957 (bash)
        Tasks: 2 (limit: 1149)
       Memory: 720.0K
       CGroup: /system.slice/myservice.service
               |-957 /bin/bash /etc/init.d/myservice.sh
               `-958 sleep 60

    Sep 05 17:21:11 debian10 systemd[1]: Started My Service.
    Sep 05 17:21:11 debian10 bash[957]: Starting my service...
    Sep 05 17:21:11 debian10 bash[957]: The service still runs...
    root@debian10:#

Stopping and disabling the service is trivial.

    root@debian10:# systemctl stop myservice
    root@debian10:# systemctl disable myservice
    Removed /etc/systemd/system/multi-user.target.wants/myservice.service.
    root@debian10:~#

## Cheat sheet

<table>
<caption>systemd</caption>
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
<td style="text-align: left;"><p>systemd-analyze blame</p></td>
<td style="text-align: left;"><p>Display statistics about the last
boot.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>systemctl list-units -t target
-a</p></td>
<td style="text-align: left;"><p>Lists all systemd
<strong>targets</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>systemctl get-default</p></td>
<td style="text-align: left;"><p>Name the default target.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>systemctl list-dependencies
foo</p></td>
<td style="text-align: left;"><p>Show all dependencies for service
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>systemctl enable foo</p></td>
<td style="text-align: left;"><p>Enable the <strong>foo</strong>
service.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>systemctl disable foo</p></td>
<td style="text-align: left;"><p>Disable the <strong>foo</strong>
service.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>systemctl start foo</p></td>
<td style="text-align: left;"><p>Start the <strong>foo</strong>
service.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>systemctl stop foo</p></td>
<td style="text-align: left;"><p>Stop the <strong>foo</strong>
service.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>systemctl status foo</p></td>
<td style="text-align: left;"><p>Show the status of the service
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>poweroff</p></td>
<td style="text-align: left;"><p>Poweroff handled by systemd.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>reboot</p></td>
<td style="text-align: left;"><p>Reboot handled by systemd.</p></td>
</tr>
</tbody>
</table>

systemd

## Practice

1.  Display the top ten services that delayed the boot sequence.

2.  List all **systemd** targets.

3.  List all dependencies of the **cron** service.

4.  List all services that are dependant on **cron**. (Hint: This is the
    reverse of the previous question.)

5.  Stop the cron service. Check its status. Start the cron service
    again. And check its status again.

6.  Query the status of the cron service on a remote server.

7.  Create you own service, enable it and start it and check its status.

## Solution

1.  Display the top ten services that delayed the boot sequence.

        systemd-analyze blame | head

2.  List all **systemd** targets.

        systemctl list-units -t target -a

3.  List all dependencies of the **cron** service.

        systemctl list-dependencies cron

4.  List all services that are dependant on **cron**. (Hint: This is the
    reverse of the previous question.)

        systemctl --reverse list-dependencies cron

5.  Stop the cron service. Check its status. Start the cron service
    again. And check its status again.

        systemctl stop cron
        systemctl status cron
        systemctl start cron
        systemctl status cron

6.  Query the status of the cron service on a remote server.

        systemctl -H root@10.0.42.42 status cron   ## Use a relevant ip-address

7.  Create you own service, enable it and start it and check its status.

        See the last part of the theory.
