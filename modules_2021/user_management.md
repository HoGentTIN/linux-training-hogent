# User management

For this chapter you need your own (virtual) Debian Linux server, as you
will be executing commands as **root**.

## useradd


The **useradd** command is used to add users to a Debian Linux computer.
There are several options that can be used while creating a user.

<table style="width:60%;">
<caption>useradd options</caption>
<colgroup>
<col style="width: 9%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>option</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>-c</p></td>
<td style="text-align: left;"><p>Set an optional comment for this
user.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>-e</p></td>
<td style="text-align: left;"><p>Set an expiry date for this
account.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>-m</p></td>
<td style="text-align: left;"><p>Create a home directory for this
user.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>-p</p></td>
<td style="text-align: left;"><p>Set an <strong>encrypted</strong>
password.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>-s</p></td>
<td style="text-align: left;"><p>Set the default shell for this
user.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>-u</p></td>
<td style="text-align: left;"><p>Set the <strong>uid</strong> for this
user.</p></td>
</tr>
</tbody>
</table>

useradd options

In the screenshot below we create three users, and use some of the
options from the table above. It is a custom in Linux to use lowercase
characters for the username.

    root@debian10:~# useradd -m -s /bin/bash tania
    root@debian10:~# useradd -m laura
    root@debian10:~# useradd valentina
    root@debian10:~#

When verifying the **home directories** we can see that there is no
directory created for **valentina** (because the **-m** option was not
used).

    root@debian10:~# ls /home
    annik  david  geert  laura  linda  paul  tania
    root@debian10:~#

## su - as root


When you are the **root** user then you can **su** to any other account,
without knowing the password. In the screenshot below we use **su -** to
verify that the users have the bash shell.

    root@debian10:~# su - tania
    tania@debian10:~$ echo $SHELL
    /bin/bash
    tania@debian10:~$ exit
    logout
    root@debian10:~# su - laura
    $ echo $SHELL
    /bin/sh
    $ exit
    root@debian10:~#

As you can see the **bash** shell was correctly set for **tania**, but
not for **laura**.

## usermod


Luckily we can correct our omissions with the **usermod** command. The
**usermod** command works on existing user accounts and has the same
options as **useradd**, so the solution is trivial.

    root@debian10:~# usermod -s /bin/bash laura
    root@debian10:~# usermod -d /home/valentina -m -s /bin/bash valentina
    root@debian10:~#

## userdel


A user account can be deleted using the **userdel** command. By default
the **home directory** of that user will remain. You can force deletion
of the home directory using the **-r** option.

    root@debian10:~# userdel -r tania
    userdel: tania mail spool (/var/mail/tania) not found
    root@debian10:~#

The **-r** option will also (try to) remove the user’s mail spool.

## /etc/passwd


Information about users on a Debian Linux system is kept in the
**/etc/passwd** file. The screenshot below shows the last three lines of
this file.

    root@debian10:~# tail -3 /etc/passwd
    annik:x:1004:1004::/home/annik:/bin/bash
    laura:x:1006:1006::/home/laura:/bin/bash
    valentina:x:1007:1007::/home/valentina:/bin/bash
    root@debian10:~#

There are seven fields in this file, separated by a colon. Below is a
summary of the seven fields in order of appearance.

<table style="width:60%;">
<caption>/etc/passwd fields</caption>
<colgroup>
<col style="width: 9%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>field</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>annik</p></td>
<td style="text-align: left;"><p>the username</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>x</p></td>
<td style="text-align: left;"><p>x (long ago the encrypted password was
here)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>1004</p></td>
<td style="text-align: left;"><p>the uid</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>1004</p></td>
<td style="text-align: left;"><p>the gid</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>an optional comment</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/home/annik</p></td>
<td style="text-align: left;"><p>the name of the home directory</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/bin/bash</p></td>
<td style="text-align: left;"><p>the default shell for this
user</p></td>
</tr>
</tbody>
</table>

/etc/passwd fields

## chsh


Any user can change their own shell with the **chsh** command. The root
user can, of course, change anyone’s shell, as can be seen in this
screenshot.

    root@debian10:~# chsh -s /bin/sh laura
    root@debian10:~# grep laura /etc/passwd
    laura:x:1006:1006::/home/laura:/bin/sh
    root@debian10:~# chsh -s /bin/bash laura
    root@debian10:~#

## home directories


When using the **useradd -m** option, Debian Linux will create a home
directory for the user in the **/home** parent directory. The default
home directory appears empty, but there are hidden files.

    root@debian10:~# useradd -m -s /bin/bash tania
    root@debian10:~# ls -la /home/tania/
    total 20
    drwxr-xr-x 2 tania tania 4096 Aug 11 17:43 .
    drwxr-xr-x 9 root  root  4096 Aug 11 17:43 ..
    -rw-r--r-- 1 tania tania  220 Apr 18 06:12 .bash_logout
    -rw-r--r-- 1 tania tania 3526 Apr 18 06:12 .bashrc
    -rw-r--r-- 1 tania tania  807 Apr 18 06:12 .profile
    root@debian10:~#

## /etc/skel


There is a skeleton directory named **/etc/skel** on Debian which
contains the default files that are copied into any new home directory
(when using **useradd -m**).

    root@debian10:~# ls -la /etc/skel/
    total 20
    drwxr-xr-x  2 root root 4096 Jul 24 18:08 .
    drwxr-xr-x 74 root root 4096 Aug 11 17:43 ..
    -rw-r--r--  1 root root  220 Apr 18 06:12 .bash_logout
    -rw-r--r--  1 root root 3526 Apr 18 06:12 .bashrc
    -rw-r--r--  1 root root  807 Apr 18 06:12 .profile
    root@debian10:~#

If you place files in **/etc/skel** then those files will be copied to
the home directory of any user you create. This copy happens at creation
time, files will not be copied to existing users!

## adduser


Some administrators prefer to use the **adduser** tool instead of
**useradd**. The end result is the same, a user will be created in
**/etc/passwd**.

## Cheat sheet

<table>
<caption>User management</caption>
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
<td style="text-align: left;"><p>useradd foo</p></td>
<td style="text-align: left;"><p>Create a new user named
<strong>foo</strong> on this computer.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>useradd -m foo</p></td>
<td style="text-align: left;"><p>Create a new user with a home directory
(/home/foo).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>useradd -s /bin/bash foo</p></td>
<td style="text-align: left;"><p>Create a new user with the
<strong>bash</strong> shell as default shell.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>usermod -s /bin/bash foo</p></td>
<td style="text-align: left;"><p>Change the default shell for the user
<strong>foo</strong> to bash.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>userdel foo</p></td>
<td style="text-align: left;"><p>Delete the user <strong>foo</strong>,
the home directory is untouched.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>userdel -r foo</p></td>
<td style="text-align: left;"><p>Delete the user <strong>foo</strong>,
also delete the home directory.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chsh -s /bin/bash foo</p></td>
<td style="text-align: left;"><p>Change the default shell for user
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/passwd</p></td>
<td style="text-align: left;"><p>The list of all users on this
computer.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/home</p></td>
<td style="text-align: left;"><p>The default location for home
directories.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/skel</p></td>
<td style="text-align: left;"><p>The skeleton (template) directory for
home directories.</p></td>
</tr>
</tbody>
</table>

User management

## Practice

1.  Create a user named **serena** with a home directory, a comment and
    the bash shell.

2.  Verify in **/etc/passwd** that this user was created.

3.  Use **su -** to verify that this user has the bash shell and a home
    directory.

4.  Change the comment for the **serena** user to **tennis** .

5.  Verify that there is a **serena** home directory in **/home** .

6.  Delete the **serena** user and the user’s home directory.

## Solution

1.  Create a user named **serena** with a home directory, a comment and
    the bash shell.

        useradd -m -s /bin/bash -c Serena Williams serena

2.  Verify in **/etc/passwd** that this user was created.

        grep serena /etc/passwd

3.  Use **su -** to verify that this user has the bash shell and a home
    directory.

        su - serena
        echo $SHELL
        ls -la
        exit

4.  Change the comment for the **serena** user to **tennis** .

        usermod -c tennis serena

5.  Verify that there is a **serena** home directory in **/home** .

        ls -l /home

    or

        ls -ld /home/serena/

6.  Delete the **serena** user and the user’s home directory.

        userdel -r serena
