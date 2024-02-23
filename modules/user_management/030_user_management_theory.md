## user management

User management on Linux can be done in three complementary ways. You
can use the `graphical` tools provided by your distribution. These tools
have a look and feel that depends on the distribution. If you are a
novice Linux user on your home system, then use the graphical tool that
is provided by your distribution. This will make sure that you do not
run into problems.

Another option is to use `command line tools` like useradd, usermod,
gpasswd, passwd and others. Server administrators are likely to use
these tools, since they are familiar and very similar across many
different distributions. This chapter will focus on these command line
tools.

A third and rather extremist way is to
`edit the local configuration files` directly using vi (or vipw/vigr).
Do not attempt this as a novice on production systems!

## /etc/passwd

The local user database on Linux (and on most Unixes) is
`/etc/passwd`.

    [root@linux ~]# tail /etc/passwd
    inge:x:518:524:art dealer:/home/inge:/bin/ksh
    ann:x:519:525:flute player:/home/ann:/bin/bash
    frederik:x:520:526:rubius poet:/home/frederik:/bin/bash
    steven:x:521:527:roman emperor:/home/steven:/bin/bash
    pascale:x:522:528:artist:/home/pascale:/bin/ksh
    geert:x:524:530:kernel developer:/home/geert:/bin/bash
    wim:x:525:531:master damuti:/home/wim:/bin/bash
    sandra:x:526:532:radish stresser:/home/sandra:/bin/bash
    annelies:x:527:533:sword fighter:/home/annelies:/bin/bash
    laura:x:528:534:art dealer:/home/laura:/bin/ksh

As you can see, this file contains seven columns separated by a colon.
The columns contain the username, an x, the user id, the primary group
id, a description, the name of the home directory, and the login shell.

More information can be found by typing `man 5 passwd`.

    [root@linux ~]# man 5 passwd

## root

The `root` user also called the `superuser`
is the most powerful account on your Linux system. This user can do
almost anything, including the creation of other users. The root user
always has userid 0 (regardless of the name of the account).

    [root@linux ~]# head -1 /etc/passwd
    root:x:0:0:root:/root:/bin/bash

## useradd

You can add users with the `useradd` command. The example
below shows how to add a user named yanina (last parameter) and at the
same time forcing the creation of the home directory (-m), setting the
name of the home directory (-d), and setting a description (-c).

    [root@linux ~]# useradd -m -d /home/yanina -c "yanina wickmayer" yanina
    [root@linux ~]# tail -1 /etc/passwd
    yanina:x:529:529:yanina wickmayer:/home/yanina:/bin/bash

The user named yanina received userid 529 and
`primary group` id 529.

## /etc/default/useradd

Both Red Hat Enterprise Linux and Debian/Ubuntu have a file called
`/etc/default/useradd` that contains some default user
options. Besides using cat to display this file, you can also use
`useradd -D`.

    [root@RHEL4 ~]# useradd -D
    GROUP=100
    HOME=/home
    INACTIVE=-1
    EXPIRE=
    SHELL=/bin/bash
    SKEL=/etc/skel

## userdel

You can delete the user yanina with `userdel`. The -r
option of userdel will also remove the home directory.

    [root@linux ~]# userdel -r yanina

## usermod

You can modify the properties of a user with the `usermod`
command. This example uses `usermod` to change the description of the
user harry.

    [root@RHEL4 ~]# tail -1 /etc/passwd
    harry:x:516:520:harry potter:/home/harry:/bin/bash
    [root@RHEL4 ~]# usermod -c 'wizard' harry
    [root@RHEL4 ~]# tail -1 /etc/passwd
    harry:x:516:520:wizard:/home/harry:/bin/bash

## creating home directories

The easiest way to create a home directory is to supply the `-m` option
with `useradd` (it is likely set as a default option on
Linux).

A less easy way is to create a home directory manually with
`mkdir` which also requires setting the owner and the
permissions on the directory with `chmod` and
`chown` (both commands are discussed in detail in another
chapter).

    [root@linux ~]# mkdir /home/laura
    [root@linux ~]# chown laura:laura /home/laura
    [root@linux ~]# chmod 700 /home/laura
    [root@linux ~]# ls -ld /home/laura/
    drwx------ 2 laura laura 4096 Jun 24 15:17 /home/laura/

## /etc/skel/

When using `useradd` the `-m` option, the `/etc/skel/`
directory is copied to the newly created home directory. The
`/etc/skel/` directory contains some (usually hidden) files that contain
profile settings and default values for applications. In this way
`/etc/skel/` serves as a default home directory and as a default user
profile.

    [root@linux ~]# ls -la /etc/skel/
    total 48
    drwxr-xr-x  2 root root  4096 Apr  1 00:11 .
    drwxr-xr-x 97 root root 12288 Jun 24 15:36 ..
    -rw-r--r--  1 root root    24 Jul 12  2006 .bash_logout
    -rw-r--r--  1 root root   176 Jul 12  2006 .bash_profile
    -rw-r--r--  1 root root   124 Jul 12  2006 .bashrc

## deleting home directories

The -r option of `userdel` will make sure that the home
directory is deleted together with the user account.

    [root@linux ~]# ls -ld /home/wim/
    drwx------ 2 wim wim 4096 Jun 24 15:19 /home/wim/
    [root@linux ~]# userdel -r wim
    [root@linux ~]# ls -ld /home/wim/
    ls: /home/wim/: No such file or directory

## login shell

The `/etc/passwd` file specifies the `login shell` for the
user. In the screenshot below you can see that user annelies will log in
with the `/bin/bash` shell, and user laura with the `/bin/ksh` shell.

    [root@linux ~]# tail -2 /etc/passwd
    annelies:x:527:533:sword fighter:/home/annelies:/bin/bash
    laura:x:528:534:art dealer:/home/laura:/bin/ksh

You can use the usermod command to change the shell for a user.

    [root@linux ~]# usermod -s /bin/bash laura
    [root@linux ~]# tail -1 /etc/passwd
    laura:x:528:534:art dealer:/home/laura:/bin/bash

## chsh

Users can change their login shell with the `chsh`
command. First, user harry obtains a list of available shells (he could
also have done a `cat /etc/shells`) and then changes his
login shell to the `Korn shell` (/bin/ksh). At the next
login, harry will default into ksh instead of bash.

    [laura@linux ~]$ chsh -l
    /bin/sh
    /bin/bash
    /sbin/nologin
    /usr/bin/sh
    /usr/bin/bash
    /usr/sbin/nologin
    /bin/ksh
    /bin/tcsh
    /bin/csh
    [laura@linux ~]$

Note that the `-l` option does not exist on Debian and that the above
screenshot assumes that `ksh` and `csh` shells are installed.

The screenshot below shows how `laura` can change her default shell
(active on next login).

    [laura@linux ~]$ chsh -s /bin/ksh
    Changing shell for laura.
    Password: 
    Shell changed.

