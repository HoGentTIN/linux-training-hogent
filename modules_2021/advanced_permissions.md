# Advanced file permissions

## sticky bit


A **sticky bit** is a special permission bit that you can set on a
directory so that users can only remove files of which they are the user
owner. This effectively prevents users from deleting files from other
users, even if they have 777 permissions on the directory and on the
file.

The **sticky bit** is set using **chmod +t** on the directory.

    root@debian10:~# mkdir /srv/project42
    root@debian10:~# ls -l /srv
    total 4
    drwxr-xr-x 2 root root 4096 Aug 14 02:23 project42
    root@debian10:~# chmod +t /srv/project42
    root@debian10:~# ls -l /srv
    total 4
    drwxr-xr-t 2 root root 4096 Aug 14 02:23 project42
    root@debian10:~#

You can see the **sticky bit** as a letter **t** (if the x is also
there) or as an uppercase **T** (in case x is not set). You can also use
the octal notation **1** to set permission and sticky bit in one
command.

    root@debian10:~# chmod 1750 /srv/project42/
    root@debian10:~# ls -l /srv
    total 4
    drwxr-x--T 2 root root 4096 Aug 14 02:23 project42
    root@debian10:~#

By default the **sticky bit** is set on the **/tmp** directory. You can
find all directories with a sticky bit using this **find** command.

    root@debian10:~# find / -type d -perm -1000 2>/dev/null

## setgid directory


The **setgid bit** is a special permission bit that can be set on a
directory to force group ownership on all files created in that
directory. The purpose is to share this directory in a group project,
where all files created in this directory belong to the group project.

The **setgid bit** on a directory can be set using **chmod g+s**, as
seen in this screenshot.

    root@debian10:~# ls -l /srv
    total 4
    drwxrwx--T 2 root root 4096 Aug 14 02:23 project42
    root@debian10:~# chmod g+s /srv/project42/
    root@debian10:~# ls -l /srv
    total 4
    drwxrws--T 2 root root 4096 Aug 14 02:23 project42
    root@debian10:~#

You can **find** all directories with a **setgid bit** using this find
command. <span class="indexterm"></span>

    root@debian10:~# find / -type d -perm -2000 2>/dev/null

## project directories

It is common for project directories (that are shared over the network)
to have a common group owner and to not be able to remove other files
(as in both **sticky bit** and **setgid bit** set on the directory).
This can be done using a one **chmod** command.

    root@debian10:~# chmod 3770 /srv/project42/
    root@debian10:~# ls -l /srv/
    total 4
    drwxrxs--T 2 root root 4096 Aug 14 02:23 project42
    root@debian10:~#

Of course to make this example complete, we also need to create a group
for this **project42** and make that group the owner of the directory.

    root@debian10:~# groupadd project42
    root@debian10:~# chgrp project42 /srv/project42/
    root@debian10:~# ls -l /srv
    total 4
    drwxrxs--T 2 root project42 4096 Aug 14 02:23 project42
    root@debian10:~#

Now when we make a user a member of the group **project42** then that
user can create files in **/srv/project42** that automatically belong to
the group **project42**. And she can only delete her own files.

    root@debian10:~# usermod -a -G project42 valentina
    root@debian10:~# su - valentina
    valentina@debian10:~$ touch /srv/project42/test.txt
    valentina@debian10:~$ ls -l /srv/project42/
    total 0
    -rw-r--r-- 1 valentina project42 0 Aug 14 03:05 test.txt
    valentina@debian10:~$

## setuid binary


The **setuid bit** is a special permission bit that can be set on an
executable file. The **setuid bit** is visible as an **s** in the user
owner triplet. It is set by default on some binaries in **/usr/bin/**.

    valentina@debian10:~$ find /usr/bin/ -type f -perm -4000 -exec ls -l {} \;
    -rwsr-xr-x 1 root root 34888 Jan 10  2019 /usr/bin/umount
    -rwsr-xr-x 1 root root 84016 Jul 27  2018 /usr/bin/gpasswd
    -rwsr-xr-x 1 root root 63568 Jan 10  2019 /usr/bin/su
    -rwsr-xr-x 1 root root 63736 Jul 27  2018 /usr/bin/passwd
    -rwsr-xr-x 1 root root 44440 Jul 27  2018 /usr/bin/newgrp
    -rwsr-xr-x 1 root root 54096 Jul 27  2018 /usr/bin/chfn
    -rwsr-xr-x 1 root root 44528 Jul 27  2018 /usr/bin/chsh
    -rwsr-xr-x 1 root root 51280 Jan 10  2019 /usr/bin/mount
    valentina@debian10:~$

Setting this bit will make sure that a binary is started with the
credentials of the **owner** of the binary instead of the user starting
the binary. Normally any program you start will run with the credentials
of your user account. Not so for **setuid bit** files, they **always**
run with owner credentials.

For example **/usr/bin/passwd**, the command to change your password.
This change has to be done in **/etc/shadow**, but a normal user has no
permissions to write changes to this file. So when you type **passwd**,
you become **root** on the computer for as long as the **passwd**
command is running.

    valentina@debian10:~$ ls -l /etc/shadow
    -rw-r----- 1 root shadow 1482 Aug 14 02:43 /etc/shadow
    valentina@debian10:~$ passwd
    Changing password for valentina.
    Current password:
    New password:
    Retype new password:
    passwd: password updated successfully
    valentina@debian10:~$ ls -l /etc/shadow
    -rw-r----- 1 root shadow 1482 Aug 14 03:24 /etc/shadow
    valentina@debian10:~$

Note the time stamp of the **shadow file** in the above screenshot. The
**valentina** user changed a file without having permissions on that
file.

## setgid binary

The **setgid bit** is equivalent to the **setuid bit** on binaries in
that it preserves group credentials when executing the file in question.
The **setgid bit** is visible as an **s** in the group owner triplet.

You can **find** all the **setgid** executables using this command.

    root@debian10:~# find / -type f -perm -2000 2>/dev/null
    /usr/bin/ssh-agent
    /usr/bin/bsd-write
    /usr/bin/wall
    /usr/bin/chage
    /usr/bin/crontab
    /usr/bin/dotlockfile
    /usr/bin/expiry
    /usr/sbin/unix_chkpwd
    root@debian10:~#

We will look at **crontab** in the Scheduling chapter. You should
remember **chage** from the Password management chapter. The **chage**
command can read fields in the **/etc/shadow** file thanks to its
**setgid bit**.

    paul@debian10:~$ ls -l /etc/shadow
    -rw-r----- 1 root shadow 1482 Aug 14 03:24 /etc/shadow
    paul@debian10:~$ ls -l /usr/bin/chage
    -rwxr-sr-x 1 root shadow 71816 Jul 27  2018 /usr/bin/chage
    paul@debian10:~$

## attributes


Files on a Debian Linux have **attributes** which can have several
purposes. A list is available in the man page of the **chattr** command.
We will discuss two attribute flags.

### immutable

The **root** user can decide to set the **immutable** flag on a file.
This file can no longer be renamed, moved or changed in any way.

    root@debian10:~# touch imfile
    root@debian10:~# chattr +i imfile
    root@debian10:~# ls -l imfile
    -rw-r--r-- 1 root root 0 Aug 14 04:10 imfile
    root@debian10:~# lsattr imfile
    ----i---------e---- imfile
    root@debian10:~# rm -rf imfile
    rm: cannot remove imfile: Operation not permitted
    root@debian10:~#

Use **chattr -i** to remove the immutable flag.

    root@debian10:~# chattr -i imfile
    root@debian10:~# rm -rf imfile
    root@debian10:~#

### appendable

Another flag that may be useful is the **appendable** flag. With this
**appendable** flag the file can not be renamed or moved, but data can
be appended to it, so this can be set on a log file.

    root@debian10:~# touch apfile
    root@debian10:~# chattr +a apfile
    root@debian10:~# mv apfile test
    mv: cannot move 'apfile' to 'test': Operation not permitted
    root@debian10:~# echo "The answer is 42" > apfile
    -bash: apfile: Operation not permitted
    root@debian10:~# echo "The answer is 42" >> apfile
    root@debian10:~# rm -rf apfile
    rm: cannot remove 'apfile': Operation not permitted
    root@debian10:~#

Don’t randomly set this on existing log files as **logrotate** will
fail.

By default there are no files on Debian Linux with **appendable** or
**immutable** flag.

## Cheat sheet

<table>
<caption>Advanced permissions</caption>
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
<td style="text-align: left;"><p>chmod +t</p></td>
<td style="text-align: left;"><p>Set the sticky bit.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>chmod g+s</p></td>
<td style="text-align: left;"><p>Set the setgid bit.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chmod 3770</p></td>
<td style="text-align: left;"><p>Set the sticky bit and the setgid bit
and 770 octal permissions.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>chmod ug+s</p></td>
<td style="text-align: left;"><p>Set the setuid and setgid bit (on an
executable file).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>find / -perm 1000</p></td>
<td style="text-align: left;"><p>Find all files with sticky bit
set.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>find / -perm 2000</p></td>
<td style="text-align: left;"><p>Find all files with setgid bit
set.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>find / -perm 4000</p></td>
<td style="text-align: left;"><p>Find all files with setuid bit
set.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chattr</p></td>
<td style="text-align: left;"><p>Tool to set attributes on a
file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>chattr +i</p></td>
<td style="text-align: left;"><p>Set the <strong>immutable</strong>
attribute.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chattr -i</p></td>
<td style="text-align: left;"><p>Unset the <strong>immutable</strong>
attribute.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>chattr +a</p></td>
<td style="text-align: left;"><p>Set the <strong>appendable</strong>
attribute.</p></td>
</tr>
</tbody>
</table>

Advanced permissions

## Practice

1.  Create a **project33** directory and make sure users can only delete
    their own files.

2.  Make sure the group owner **pro33** is set for all files created in
    the **project33** directory.

3.  Test with the **laura** user that all files created in the
    **project33** directory have the correct group owner.

4.  Find all **setuid** binaries in **/usr/bin** .

5.  Display the **setgid** bit on a binary in **/usr/bin** .

6.  List the attributes of **/etc/passwd** .

7.  What is the result of setting the **immutable** flag on
    **/etc/shadow**.

## Solution

1.  Create a **project33** directory and make sure users can only delete
    their own files.

        mkdir /srv/project33
        chmod +t /srv/project33

2.  Make sure the group owner **pro33** is set for all files created in
    the **project33** directory.

        groupadd pro33
        chgrp pro33 /srv/project33
        chmod g+s /srv/project33

3.  Test with the **laura** user that all files created in the
    **project33** directory have the correct group owner.

        usermod -a -G pro33 laura
        su - laura
        touch /srv/project33/test
        ls -l /srv/project33/

4.  Find all **setuid** binaries in **/usr/bin** .

        find /usr/bin -type f -perm -4000 \;

5.  Display the **setgid** bit on a binary in **/usr/bin** .

        find /usr/bin -type f -perm -2000 \;
        ls -l /usr/bin/crontab

6.  List the attributes of **/etc/passwd** .

        lsattr /etc/passwd

7.  What is the result of setting the **immutable** flag on
    **/etc/shadow**.

        Passwords cannot be changed (and no new user passwords can be added).
