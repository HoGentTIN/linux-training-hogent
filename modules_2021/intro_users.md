# Introduction to users

## who am i


We already saw the **who am i** command in the Start chapter. This
command displays the user that we used to log on to this system.

    paul@debian10:~$ who am i
    paul     pts/0        2019-08-11 11:44 (192.168.1.28)
    paul@debian10:~$

This user, **paul** in my case, does not exist by default. An
administrator has created this user on this system.

## whoami


There is a simple command named **whoami** which will show you your
current **username**. By default this is also displayed in your command
prompt.

    paul@debian10:~$ whoami
    paul
    paul@debian10:~$

## id


The **id** command will give you a lot more information. We will look at
the **groups** later, for now we can see that the user **paul** has
**uid** 1000 and **gid** 1000. So besides a username every user also has
a **uid** and **gid** (as in a primary group).

    paul@debian10:~$ id
    uid=1000(paul) gid=1000(paul) groups=1000(paul),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev),109(netdev),111(bluetooth)
    paul@debian10:~$

## su


If you know the password of another **user account** on this computer,
then you can issue an **su** command to switch to this user. In the
screenshot below we **switch user** from **paul** to **annik**.

    paul@debian10:~$ whoami
    paul
    paul@debian10:~$ su annik
    Password:
    annik@debian10:/home/paul$ whoami
    annik
    annik@debian10:/home/paul$

When you type **exit** or **Ctrl-d** then you go back to the previous
user.

After the **su** we did not arrive in the correct home directory.

## su -


You can also use **su -** instead of **su** to switch to another user.
The difference (for now) is that with **su -** you also arrive in the
environment of the target user. See the screenshot below.

    paul@debian10:~$ whoami
    paul
    paul@debian10:~$ su - annik
    Password:
    annik@debian10:~$ whoami
    annik
    annik@debian10:~$

We will see later what exactly differs when executing **su** or **su
-**.

## root


There is a special user account, named **root**, on every Debian Linux
system. This is the user with **uid 0** and is created at installation
time. This **root** user has the power to create other users (and to
manage all aspects of the Linux system).

If you know the **root** password, then you can **su -** to this special
user.

    paul@debian10:~$ su - root
    Password:
    root@debian10:~# whoami
    root
    root@debian10:~#

There is no need to specify the username when you **su** to **root**, as
can be seen in this screenshot.

    paul@debian10:~$ su -
    Password:
    root@debian10:~#

## sudo


Debian does not install **sudo** by default, but a lot of derivatives of
Debian, like Ubuntu do install **sudo**. In short this **sudo** command
allows you to execute a program as another user (often this is the root
user).

When using **sudo** you need to provide your own password.

## ssh


When you use **ssh** (or **putty**) to connect to a Linux computer then
you need to provide a hostname and a username. For example **ssh
paul@herrdebby** will attempt to connect to the **herrdebby** computer
with the username **paul**. It will then ask for my password on that
computer.

The screenshot below shows how to use **ssh** to connect to another
computer. This only works if you have a user account on that computer.

    paul@debian10:~$ ssh paul@herrdebby
    paul@herrdebby's password:
    Linux herrdebby 4.19.0-5-amd64 #1 SMP Debian 4.19.37-5+deb10u1 (2019-07-19) x86_64

    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Sun Jul 21 00:29:03 2019 from 109.130.74.182
    paul@herrdebby~$ whoami
    paul
    paul@herrdebby~$ hostname
    herrdebby2
    paul@herrdebby~$

## w


To finish this introductory chapter on users we show you the **w**
command. It will show all logged on users and the command they are
executing.

    paul@debian10:~$ w
     16:12:13 up  4:29,  2 users,  load average: 0.00, 0.00, 0.00
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    root     tty1     -                16:12   13.00s  0.03s  0.01s -bash
    paul     pts/0    192.168.1.28     11:44    0.00s  0.46s  0.00s w
    paul@debian10:~$

## Cheat sheet

<table>
<caption>Introduction to users</caption>
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
<td style="text-align: left;"><p>who am i</p></td>
<td style="text-align: left;"><p>Display your login
information.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>whoami</p></td>
<td style="text-align: left;"><p>Display your current username.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>id</p></td>
<td style="text-align: left;"><p>Display your username and userid, and
list group membership details.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>su foo</p></td>
<td style="text-align: left;"><p>Switch to the <strong>foo</strong> user
account.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>su - foo</p></td>
<td style="text-align: left;"><p>Switch to the <strong>foo</strong> user
account and the <strong>foo</strong> environment.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>su - root</p></td>
<td style="text-align: left;"><p>Switch to the <strong>root</strong>
user account and the <strong>root</strong> environment.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sudo</p></td>
<td style="text-align: left;"><p>Execute a command as another user (not
by default in Debian).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ssh <a
href="mailto:foo@bar">foo@bar</a></p></td>
<td style="text-align: left;"><p>Connect to a user account
<strong>foo</strong> on another computer named
<strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>w</p></td>
<td style="text-align: left;"><p>Display all logged on users on this
computer and their current command.</p></td>
</tr>
</tbody>
</table>

Introduction to users

## Practice

1.  Display a list of logged on users.

2.  Display your username.

3.  Display your **uid** and the list of groups that you are a member
    of.

4.  If you have the password of another user, then switch to that user.

5.  If you have the password of another user, then switch to that user
    and its environment.

## Solution

1.  Display a list of logged on users.

        w
        who
        who | cut -d' ' -f1

2.  Display your username.

        whoami

3.  Display your **uid** and the list of groups that you are a member
    of.

        id

4.  If you have the password of another user, then switch to that user.

        su username

5.  If you have the password of another user, then switch to that user
    and its environment.

        su - username
