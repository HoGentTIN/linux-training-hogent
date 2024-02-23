## whoami

The `whoami` command tells you your username.

    [student@linux ~]$ whoami
    paul
    [student@linux ~]$

## who

The `who` command will give you information about who is
logged on the system.

    [student@linux ~]$ who
    root     pts/0        2014-10-10 23:07 (10.104.33.101)
    paul     pts/1        2014-10-10 23:30 (10.104.33.101)
    laura    pts/2        2014-10-10 23:34 (10.104.33.96)
    tania    pts/3        2014-10-10 23:39 (10.104.33.91)
    [student@linux ~]$

## who am i

With `who am i` the `who` command will display only the
line pointing to your current session.

    [student@linux ~]$ who am i
    paul     pts/1        2014-10-10 23:30 (10.104.33.101)
    [student@linux ~]$

## w

The `w` command shows you who is logged on and what they
are doing.

    [student@linux ~]$ w
     23:34:07 up 31 min,  2 users,  load average: 0.00, 0.01, 0.02
    USER     TTY        LOGIN@   IDLE   JCPU   PCPU WHAT
    root     pts/0     23:07   15.00s  0.01s  0.01s top
    paul     pts/1     23:30    7.00s  0.00s  0.00s w
    [student@linux ~]$

## id

The `id` command will give you your user id, primary group
id, and a list of the groups that you belong to.

    student@linux:~$ id
    uid=1000(paul) gid=1000(paul) groups=1000(paul)

On RHEL/CentOS you will also get `SELinux` context information with this
command.

    [root@linux ~]# id
    uid=0(root) gid=0(root) groups=0(root) context=unconfined_u:unconfined_r\
    :unconfined_t:s0-s0:c0.c1023

## su to another user

The `su` command allows a user to run a shell as another
user.

    laura@linux:~$ su tania
    Password:
    tania@linux:/home/laura$

## su to root

Yes you can also `su` to become `root`, when you know the
`root password`.

    laura@linux:~$ su root
    Password:
    root@linux:/home/laura#

## su as root

You need to know the password of the user you want to substitute to,
unless your are logged in as `root`. The `root` user can become any
existing user without knowing that user\'s password.

    root@linux:~# id
    uid=0(root) gid=0(root) groups=0(root)
    root@linux:~# su - valentina
    valentina@linux:~$

## su - \$username

By default, the `su` command maintains the same shell environment. To
become another user and also get the target user\'s environment, issue
the `su -` command followed by the target username.

    root@linux:~# su laura
    laura@linux:/root$ exit
    exit
    root@linux:~# su - laura
    laura@linux:~$ pwd
    /home/laura

## su -

When no username is provided to `su` or `su -`, the command will assume
`root` is the target.

    tania@linux:~$ su -
    Password:
    root@linux:~#

## run a program as another user

The sudo program allows a user to start a program with the credentials
of another user. Before this works, the system administrator has to set
up the `/etc/sudoers` file. This can be useful to delegate
administrative tasks to another user (without giving the root password).

The screenshot below shows the usage of `sudo`. User
`paul` received the right to run `useradd` with the credentials of
`root`. This allows `paul` to create new users on the
system without becoming `root` and without knowing the `root password`.

First the command fails for `paul`.

    student@linux:~$ /usr/sbin/useradd -m valentina
    useradd: Permission denied.
    useradd: cannot lock /etc/passwd; try again later.

But with `sudo` it works.

    student@linux:~$ sudo /usr/sbin/useradd -m valentina
    [sudo] password for paul:
    student@linux:~$

## visudo

Check the man page of `visudo` before playing with the
`/etc/sudoers` file. Editing the `sudoers` is out of scope for this
fundamentals book.

    student@linux:~$ apropos visudo
    visudo               (8)  - edit the sudoers file
    student@linux:~$

## sudo su -

On some Linux systems like Ubuntu and Xubuntu, the `root`
user does not have a password set. This means that it is not possible to
login as `root` (extra security). To perform tasks as `root`, the first
user is given all `sudo rights` via the
`/etc/sudoers`. In fact all users that are members of the
admin group can use sudo to run all commands as root.

    root@linux:~# grep admin /etc/sudoers 
    # Members of the admin group may gain root privileges
    %admin ALL=(ALL) ALL

The end result of this is that the user can type
`sudo su -` and become root without having to enter the
root password. The sudo command does require you to enter your own
password. Thus the password prompt in the screenshot below is for sudo,
not for su.

    student@linux:~$ sudo su -
    Password:
    root@linux:~#

## sudo logging

Using `sudo` without authorization will result in a severe warning:

    student@linux:~$ sudo su -

    We trust you have received the usual lecture from the local System
    Administrator. It usually boils down to these three things:

        #1) Respect the privacy of others.
        #2) Think before you type.
        #3) With great power comes great responsibility.

    [sudo] password for paul:
    paul is not in the sudoers file.  This incident will be reported.
    student@linux:~$

The root user can see this in the `/var/log/secure` on Red Hat and in
`/var/log/auth.log` on Debian).

    root@linux:~# tail /var/log/secure | grep sudo | tr -s ' '
    Apr 13 16:03:42 rhel65 sudo: paul : user NOT in sudoers ; TTY=pts/0 ; PWD=\
    /home/paul ; USER=root ; COMMAND=/bin/su -
    root@linux:~#

