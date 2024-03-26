# Login logging

## local and remote logins


Local logins can be on a text based terminal that is directly attached
to the Debian 10 server. This will show up as a **tty** connection.
There are six of these **tty** terminals available on Debian 10 and you
can reach them by typing **alt-F1** to **alt-F6** on the terminal
keyboard. The process that is performing these logins on a **tty** is
called **/bin/login**.

If you install Debian on a desktop or laptop computer then you will be
presented with a graphical login on **tty7** . Using **Ctrl-alt-F1** to
**Ctrl-alt-F6** enables you to switch to text based terminals. Typing
**alt-F7** brings you back to the GUI.

Remote logins (via ssh or putty) will connect to a **pseudo terminal
service** or **pts**. These connections are numbered starting from
**/pts/0**.

Connecting to embedded devices with Debian 10 is often done via a serial
cable to the **serial console**. This will connect to **/dev/ttyS0**.

## who


The **who** command reads **/var/log/wtmp** and shows you the currently
logged on users, their terminal, and the location (ip) from which they
logged on.

    paul@debian10:$ who
    root     tty1         2019-09-07 13:29
    paul     pts/0        2019-09-07 15:17 (192.168.1.28)
    paul@debian10:$

If you have a Debian 10 computer with a graphical login, then the logged
on terminal will show as **tty7** and the origin as **:0** . You can
reach **tty7** by typing **Ctrl-Alt-F7**, and likewise **tty1** can be
reached by typing **Ctrl-Alt-F1** .

    paul@debian10~$ who
    paul     tty7         2019-09-07 11:13 (:0)


Typing **watch who** will constantly display who is logged on to the
computer.

## last


The **last** command will also read **/var/log/wtmp** to display the
last successful logons to the system. It will also show the duration of
the logon.

    paul@debian10:$ last | head -6
    paul     pts/0        192.168.1.28     Sat Sep  7 16:14   still logged in
    paul     pts/0        192.168.1.28     Sat Sep  7 15:17 - 15:18  (00:00)
    paul     pts/0        192.168.1.28     Sat Sep  7 13:29 - 15:07  (01:37)
    root     tty1                          Sat Sep  7 13:29   still logged in
    reboot   system boot  4.19.0-5-amd64   Sat Sep  7 13:29   still running
    paul     pts/0        192.168.56.1     Sat Sep  7 11:45 - 13:28  (01:43)
    paul@debian10:$

## lastb


The **lastb** command reads from **/var/log/btmp** and shows you the
last bad login attempts. The screenshot shows a server under a **brute
force** attack, over 100 attempts per minute to log on as root.

    root@debian10:/var/log# lastb | head
    root     ssh:notty    35.0.127.52      Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    218.92.0.175     Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    35.0.127.52      Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    218.92.0.175     Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    218.92.0.175     Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    89.234.157.254   Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    218.92.0.175     Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    89.234.157.254   Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    89.234.157.254   Thu Aug 22 23:21 - 23:21  (00:00)
    root     ssh:notty    218.92.0.175     Thu Aug 22 23:21 - 23:21  (00:00)
    root@debian10:/var/log#

Logging of **lastb** can be disabled by removing the **/var/log/btmp**
file. This is done because people sometimes type their password instead
of their userid, and a file containing clear text passwords is never a
good idea.

## lastlog


The **lastlog** command will read the **/var/log/lastlog** file and
display the most recent logons of all registered users. You may wonder
why some users have an account on this system (or maybe you see a laid
off user still logging on?).

    paul@debian10:$ lastlog | tail
    paul             pts/0    192.168.1.28     Sat Sep  7 16:14:46 +0200 2019
    systemd-coredump                           **Never logged in**
    geert                                      **Never logged in**
    david                                      **Never logged in**
    linda                                      **Never logged in**
    annik                                      **Never logged in**
    laura                                      **Never logged in**
    tania                                      **Never logged in**
    valentina                                  **Never logged in**
    Debian-exim                                **Never logged in**
    paul@debian10:$

## ssh


When using **ssh** (or putty) to log on remotely to a Debian 10 Linux
computer, then your login (attempt) is registered in the
**/var/log/auth.log** file.

    root@debian10:# tail /var/log/auth.log | grep ssh
    Sep  7 16:14:46 debian10 sshd[2170]: Accepted password for paul from 192.168.1.28 port 57952 ssh2
    Sep  7 16:14:46 debian10 sshd[2170]: pam_unix(sshd:session): session opened for user paul by (uid=0)
    root@debian10:#

## su


When switching user account with **su** or **su -**, then this is also
logged in the **/var/log/auth.log** file. Failed attempts with **su**
are likewise logged in this file.

    root@debian10:# tail /var/log/auth.log | grep 'su:'
    Sep  7 16:25:59 debian10 su: (to root) paul on pts/0
    Sep  7 16:25:59 debian10 su: pam_unix(su-l:session): session opened for user root by paul(uid=1000)
    root@debian10:#

## loginctl


The **loginctl** utility, which is part of **systemd**, displays logged
on users including a new **seat** field. I guess this is useful on
**multi-seat** computers.

    root@debian10:# loginctl
    SESSION  UID USER SEAT  TTY
          1    0 root seat0 tty1
         19 1000 paul       pts/0

    2 sessions listed.
    root@debian10:#

There are many arguments that you can give to **loginctl** (see the man
page). The **user-state** argument can be useful to see a (process) tree
concerning your user (for example the fact the user **paul** did an **su
-** to root).

    root@debian10:# loginctl user-status | head -18
    paul (1000)
               Since: Sat 2019-09-07 17:36:53 CEST; 12s ago
               State: active
            Sessions: *19
              Linger: no
                Unit: user-1000.slice
                      |-session-19.scope
                      | |-2495 sshd: paul [priv]
                      | |-2508 sshd: paul@pts/0
                      | |-2509 -bash
                      | |-2512 su -
                      | |-2513 -bash
                      | |-2516 loginctl user-status
                      | `-2517 head -19
                      `-user@1000.service
                        `-init.scope
                          |-2498 /lib/systemd/systemd --user
                          `-2499 (sd-pam)
    root@debian10:#

## getent

You can query for user information in the **passwd** and **shadow**
files with the **getent** command. The screenshot shows a query in the
**passwd** file, but as **root** you can also type **getent shadow
paul** .

    root@debian10:# getent passwd paul
    paul:x:1000:1000:Paul Cobbaut,,,:/home/paul:/bin/bash
    root@debian10:#

## PAM

**PAM** is short for **Pluggable Authentication Module** and is
responsible for a high-level API to low-level authentication schemes.
PAM can be configured via **/etc/pam.conf** and the files in
**/etc/pam.d/**, but in my 20-plus years of Linux consulting I never
needed to change PAM configuration. Sometimes stuff just works.

    root@debian10:# ls /etc/pam.* 
    /etc/pam.conf

    /etc/pam.d:
    atd       common-account   common-session-noninteractive  other      sshd
    chfn      common-auth      cron                           passwd     su
    chpasswd  common-password  login                          runuser    su-l
    chsh      common-session   newusers                       runuser-l  systemd-user
    root@debian10:#

## Cheat sheet

<table>
<caption>Login logging</caption>
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
<td style="text-align: left;"><p>who</p></td>
<td style="text-align: left;"><p>Display a list of logged on
users.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>last</p></td>
<td style="text-align: left;"><p>Display the last successful logons on
this computer.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>lastb</p></td>
<td style="text-align: left;"><p>Display the last failed logon
attempts.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>touch /var/log/btmp</p></td>
<td style="text-align: left;"><p>Enable logging of failed logon
attempts.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>lastlog</p></td>
<td style="text-align: left;"><p>Display the last login of every user
account.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/var/log/auth.log</p></td>
<td style="text-align: left;"><p>Contains authentication
messages.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>loginctl</p></td>
<td style="text-align: left;"><p>The <strong>systemd</strong> command to
display logged on users.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>getent</p></td>
<td style="text-align: left;"><p>Get information about a user in a
database.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>getent passwd paul</p></td>
<td style="text-align: left;"><p>Get information about user
<strong>paul</strong> in the <strong>passwd</strong> file.</p></td>
</tr>
</tbody>
</table>

Login logging

## Practice

1.  If you have local access to a Debian computer, then login on
    **tty1** and **tty3** and issue a **who** command.

2.  Display the last ten successful logins.

3.  Display the last ten failed logins.

4.  Stop the logging of bad login attempts.

5.  Display the last login of the **david** user.

6.  Log in with **ssh** to your computer and show the logging of this
    login.

7.  Look at the man page of **loginctl** and explore the many options.

## Solution

1.  If you have local access to a Debian computer, then login on
    **tty1** and **tty3** and issue a **who** command.

        alt-F1            # login here
        alt-F3            # also login here
        who

    Or in case of a laptop or desktop

        Ctrl-alt-F1       # login here
        alt-F3            # also login here
        who
        alt-F7            # back to the GUI

2.  Display the last ten successful logins.

        last | head

3.  Display the last ten failed logins.

        lastb | head

4.  Stop the logging of bad login attempts.

        rm /var/log/btmp

5.  Display the last login of the **david** user.

        lastlog | grep david

6.  Log in with **ssh** to your computer and show the logging of this
    login.

        ssh user@ip
        tail /var/log/auth.log | grep ssh

7.  Look at the man page of **loginctl** and explore the many options.

        man loginctl
