## whoami

The `whoami` command tells you your username.

```console
student@debian:~$ whoami
student
```

## who

The `who` command will give you information about who is logged on the system.

```console
student@debian:~$ who
yanina   tty1         2024-10-15 18:59
student  pts/0        2024-10-15 18:55 (192.168.56.1)
vagrant  pts/1        2024-10-15 18:56 (10.0.2.2)
serena   pts/2        2024-10-15 18:57 (192.168.56.11)
venus    pts/3        2024-10-15 18:57 (192.168.56.15)
```

In this example, the `who` command shows that the user `yanina` is logged in on the physical machine (no IP address is shown), the other students are logged in via SSH. The IP addresses are shown in the output.

In the second column, `tty` is short for *teletype*. This term refers to a [teleprinter](https://en.wikipedia.org/wiki/Teleprinter#Teleprinters_in_computing), a device that was in the past used to interact with a computer. The `pts` stands for *pseudo terminal slave* and refers to a virtual terminal that is used to interact with the system over a network connection.

## who am i

With `who am i` the `who` command will display only the line pointing to your current session.

```console
student@debian:~$ who am i
student  pts/0        2024-10-15 18:55 (192.168.56.1)
```

In fact, any two words would work here with the same result. The following is also common:

```console
student@debian:~$ who mom loves
student  pts/0        2024-10-15 18:55 (192.168.56.1)
```

## w

The `w` command shows you who is logged on and what they are doing.

```console
student@debian:~$ w
 19:13:30 up 18 min,  5 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
yanina   tty1     -                18:59   14:34   0.03s  0.01s -bash
student  pts/0    192.168.56.1     18:55    1.00s  0.06s  0.01s w
vagrant  pts/1    10.0.2.2         18:56    7.00s  0.02s   ?    pager
serena   pts/2    192.168.56.1     18:57   16:29   0.02s  0.02s -zsh
venus    pts/3    192.168.56.1     18:57   42.00s  0.02s   ?    nano README.md
```

## id

The `id` command will give you your user id, primary group id, and a list of the groups that you belong to.

```console
student@debian:~$ id
uid=1001(student) gid=1001(student) groups=1001(student),27(sudo),100(users)
```

On Enterprise Linux you will also get `SELinux` context information with this command.

```console
[student@el ~]$ id
uid=1001(student) gid=1001(student) groups=1001(student),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

## su to another user

The `su` command (*substitute user*) allows a user to run a shell as another user. You need to know the password of the user you want to become.

```console
student@debian:~$ su venus
Password: 
venus@debian:/home/student$ pwd
/home/student
```

In this example, the user `student` becomes the user `venus`. The prompt changes to reflect the new user. The `pwd` command shows that the current directory is still the home directory of the original user. In fact, the only thing that changed is the current user id, the rest of the environment is still the same.

Used like this, the `su` command is actually not very useful. Use `su -` instead (see below).

## su - $username

To become another user and also get the target user's environment, as you would when you log in as that user, issue the `su -` command followed by the target username.

```console
venus@debian:/home/student$ su - venus
Password: 
venus@debian:~$ pwd
/home/venus
```

## su -

When no username is provided to `su` or `su -`, the command will assume `root` is the target.

```console
student@debian:~$ su -
Password: 
root@debian:~# pwd
/root
```

Remark that this assumes that the root user has a password set. On modern Linux distributions, more often than not, the root user does not have a password and you will not be able to use `su` to become root. Instead, use `sudo` (see below).

## run a program as another user

The `sudo` program allows a user to start a program with the credentials of another user. Before this works, the system administrator has to set up the `/etc/sudoers` file. This can be useful to delegate administrative tasks to another user (without giving the root password). Nowadays, this is the preferred way to run commands with superuser privileges instead of logging in as the root user.

The screenshot below shows the usage of `sudo`. User `student` received the right to run `useradd` with the credentials of `root`. This allows `student` to create new users on the system without becoming `root` and without knowing the *root password*.

First the command fails:

```console
student@debian:~$ /sbin/useradd -m -s /bin/bash valentina
useradd: Permission denied.
useradd: cannot lock /etc/passwd; try again later.
```

But with `sudo` it works. The first time a user executes `sudo`, they have to enter their own password to confirm the action. The `sudo` command will remember the password for a short time (usually 15 minutes) so that they don't have to enter the password for every command.

```console
student@debian:~$ sudo useradd -m -s /bin/bash valentina
student@debian:~$ getent passwd valentina
valentina:x:1006:1006::/home/valentina:/bin/bash
```

For more information about the commands used in this example, see the chapter about user management.

## visudo

The `/etc/sudoers` file can be edited with the `visudo` command. This command will check the syntax of the file before saving it.

Check the man page of `visudo(8)` before playing with the `/etc/sudoers` file. Editing the `sudoers` is out of scope for this fundamentals book.

The default configuration of the `sudoers` file on *Enterprise Linux* is to give all users in the `wheel` group the right to use `sudo`. On *Debian*-based systems, users in the group `sudo` get these rights. In both cases, users have to enter their own password on first use. VMs created with [Vagrant](https://www.vagrantup.com) are set up in such a way that the default user `vagrant` can use `sudo` without entering a password.

## sudo su -

On most modern Linux systems, the `root` user does not have a password set. This means that it is not possible to login as `root` from the login screen, or via SSH. In order to get a root prompt, one of the users with `sudo` rights can type `sudo su -` and become root without having to enter the root password.

```console
student@linux:~$ sudo su -
Password:
root@linux:~#
```

## sudo logging

Using `sudo` without authorization will result in a severe warning:

```console
paul@linux:~$ sudo su -

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for paul:
paul is not in the sudoers file.  This incident will be reported.
paul@linux:~$
```

On `systemd` based distributions, use `journalctl` (with superuser privileges) to see the logs:

```console
student@debian:~$ sudo journalctl -et sudo 
[... some output omitted ...]
Oct 15 19:21:30 debian sudo[1669]:    paul : user NOT in sudoers ; TTY=pts/0 ; PWD=/home/paul ; USER=root ; COMMAND=/usr/bin/su -
```

On *Enterprise Linux*, there is a separate log file for `sudo`, `/var/log/secure`:

```console
[vagrant@el ~]$ sudo grep 'NOT in sudoers' /var/log/secure 
Oct 16 07:00:19 el sudo[7458]:  paul : user NOT in sudoers ; TTY=pts/1 ; PWD=/home/paul ; USER=root ; COMMAND=/bin/su -
```

On older *Debian* systems, the log file is `/var/log/auth.log`, with similar content. If this file does not exist, this is an indication that you're on a newer system and that `journalct` should be used.

