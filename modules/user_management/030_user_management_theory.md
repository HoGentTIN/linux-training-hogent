## user management

User management on Linux can be done in three complementary ways. You can use the `graphical` tools provided by your distribution. These tools have a look and feel that depends on the distribution. If you are a novice Linux user on your home system, then use the graphical tool that is provided by your distribution. This will make sure that you do not run into problems.

Another option is to use *command line tools* like `useradd`, `usermod`, `passwd`, `gpasswd` and others. Server administrators are likely to use these tools, since they are familiar and very similar across many different distributions. This chapter will focus on these command line tools.

A third and rather extremist way is to *edit the local configuration files* directly using a text editor like `vi` or `nano`. This is strongly discouraged, though, since a small mistake in the configuration file format may make your system unusable.

## /etc/passwd

The local user database on Linux (and on most Unixes) is `/etc/passwd`.

```console
student@linux:~$ tail /etc/passwd
systemd-timesync:x:997:997:systemd Time Synchronization:/:/usr/sbin/nologin
messagebus:x:100:107::/nonexistent:/usr/sbin/nologin
sshd:x:101:65534::/run/sshd:/usr/sbin/nologin
_rpc:x:102:65534::/run/rpcbind:/usr/sbin/nologin
statd:x:103:65534::/var/lib/nfs:/usr/sbin/nologin
vagrant:x:1000:1000:vagrant,,,:/home/vagrant:/bin/bash
vboxadd:x:999:1::/var/run/vboxadd:/bin/false
student:x:1001:1001::/home/student:/bin/bash
tcpdump:x:104:109::/nonexistent:/usr/sbin/nologin
polkitd:x:994:994:polkit:/nonexistent:/usr/sbin/nologin
```

This file contains seven columns separated by a colon. The columns contain the username, an x, the user id (a number that uniquely identifies a user), the primary group id, a description, the name of the user's home directory, and the login shell.

More information can be found in man page `passwd(5)`:

```console
student@linux:~$ man 5 passwd
```

Searching for information about a user in the passwd database can be done with the `getent` command. The example below shows the information for the user `student`.

```console
student@linux:~$ getent passwd student
student:x:1001:1001::/home/student:/bin/bash
```

Since the `passwd` database is a plain text file, `grep` works as well.

```console
student@linux:~$ grep student /etc/passwd
student:x:1001:1001::/home/student:/bin/bash
```

It may be counterintuitive, but the `passwd` file does *not* contain the field it's named after, viz. the user's password. Originally, it was kept in the second field. Since the `passwd` file is world readable, realisation dawned that this was a bad idea, even if the password is stored in an encrypted (hashed) format. The password is now stored in the `shadow` file.

## /etc/shadow

The `shadow` file contains additional information about users, specifically the encrypted password and password-related settings. The file is only readable by the root user.

```console
student@debian:~$ ls -l /etc/shadow
-rw-r----- 1 root shadow 944 Oct 15 14:38 /etc/shadow
```

On Enterprise Linux, even the owner's permissions are turned off!

```console
[student@el ~]$ ls -l /etc/shadow
----------. 1 root root 1234 Oct 15 10:16 /etc/shadow
```

However, root ignores file permissions and still can read (and edit) the file.

Finding information about a user from the shadow file can also be done with `getent`, however, you need superuser privileges.

```console
student@debian:~$ getent shadow student
student@debian:~$ sudo !!
sudo getent shadow student
student:$y$j9T$k/zvYGDp1caN0p50aa9QI.$svec3ZhaLcxykbHKh6SMb4VnhYiJKgdN2ZhDGBLApa6:20007:0:99999:7:::
```

Without the `sudo` password, the command does not return any output.

The second field is the hashed password, with the other fields you can configure password expiration and more. See the `shadow(5)` man page for details.

## root

The `root` user also called the `superuser` is the most powerful account on your Linux system. This user can do almost anything, including the creation of other users. The root user always has user id 0 (regardless of the name of the account).

```console
student@linux:~$ getent passwd root
root:x:0:0:root:/root:/bin/bash
```

## useradd

You can add users with the `useradd` command. The example below shows how to add a user named yanina (last parameter) and at the same time forcing the creation of the home directory (`-m`), setting the login shell (`-s`), and setting the comment field that usually contains the user's real name (`-c`).

After that, we test whether the user was created correctly.

```console
student@debian:~$ sudo useradd -m -s /bin/bash -c "Yanina Wickmayer" yanina
student@debian:~$ getent passwd yanina
yanina:x:1002:1002:Yanina Wickmayer:/home/yanina:/bin/bash
```

The user named yanina received userid 1002 and `primary group` id 1002 (a newly created group with name `yanina`).

Remark that on **Debian**-based systems, the `useradd` command does **not** automatically create a home directory and sets the login shell to `/bin/sh`. Consequently, the `-m` and `-s` options are necessary for creating a user that can log in. On **Enterprise Linux**, `useradd` does create a home directory and `/bin/bash` is the default login shell, so `useradd <user>` is sufficient.

At this time, the user is not yet able to log in.

```console
student@debian:~$ getent shadow yanina
yanina:!:20011:0:99999:7:::
```

The password field contains a `!`, which means that the account is locked. The password must be set with the `passwd` command.

```console
student@debian:~$ sudo passwd yanina
New password: 
Retype new password: 
passwd: password updated successfully
student@debian:~$ sudo getent shadow yanina
yanina:$y$j9T$mUV.AmwvCHj8RlVknMJxi0$zkYFDtn4oHWhGqd8kTlw5sWr8/xnykHwGBVIzBGLRg6:20011:0:99999:7:::
```

The password field now contains a hashed password, so we can test whether the user can log in.

```console
student@debian:~$ su - yanina
Password: 
yanina@debian:~$ pwd
/home/yanina
```

### /etc/default/useradd

Both *Enterprise Linux* and *Debian/Ubuntu* have a file called `/etc/default/useradd` that contains some default user options. Besides using cat to display this file, you can also use `useradd -D`.

```console
student@debian:~$ /sbin/useradd -D
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/sh
SKEL=/etc/skel
CREATE_MAIL_SPOOL=no
LOG_INIT=yes
```

## usermod

You can modify the properties of a user like the comment field, login shell, password expiration, etc. with the `usermod` command. 

The `usermod` command can also be used to change group membership of users. This is discussed in the chapter about groups.

### changing the comment field

This example uses `usermod` to change the description of a new user tux.

```console
student@debian:~$ sudo useradd -m -s /bin/bash tux
student@debian:~$ getent passwd tux
tux:x:1003:1003::/home/tux:/bin/bash
student@debian:~$ sudo usermod -c "Tuxedo T. Penguin" tux
student@debian:~$ getent passwd tux
tux:x:1003:1003:Tuxedo T. Penguin:/home/tux:/bin/bash
```

### locking an account

The command can also be used with the `-L` option to temporarily lock the account of a user.

```console
student@debian:~$ sudo passwd tux
New password: 
Retype new password: 
passwd: password updated successfully
student@debian:~$ su - tux
Password: 
tux@debian:~$ 
logout
student@debian:~$ sudo usermod -L tux
student@debian:~$ su - tux
Password: 
su: Authentication failure
```

To re-enable the account, use the `-U` option.

```console
student@debian:~$ sudo usermod -U tux
student@debian:~$ su - tux
Password: 
tux@debian:~$ 
logout
```

### login shell

The `/etc/passwd` file specifies the `login shell` for the user. In the screenshot below you can see that user annelies will log in with the `/bin/bash` shell, and user laura with the `/bin/ksh` shell.

```console
student@debian:~$ getent passwd annelies
annelies:x:1006:1006:sword fighter:/home/annelies:/bin/bash
student@debian:~$ getent passwd laura
laura:x:1007:1007:art dealer:/home/laura:/bin/ksh
```

You can use the usermod command to change the shell for a user.

```console
student@debian:~$ sudo usermod -s /bin/ksh annelies
student@debian:~$ getent passwd annelies
annelies:x:1006:1006:sword fighter:/home/annelies:/bin/ksh
```

## chsh

Users can change their own login shell with the `chsh` command. 

In the example below, user `yanina` obtains a list of available shells and then changes their login shell to the Z shell (`/bin/zsh`). First install `zsh` before trying this yourself.

```console
yanina@debian:~$ cat /etc/shells
# /etc/shells: valid login shells
/bin/sh
/usr/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash
/usr/bin/rbash
/bin/dash
/usr/bin/dash
/bin/zsh
/usr/bin/zsh
/usr/bin/zsh
yanina@debian:~$ getent passwd yanina
yanina:x:1002:1002:Yanina Wickmayer:/home/yanina:/bin/bash
yanina@debian:~$ chsh -s /usr/bin/zsh 
Password: 
yanina@debian:~$ exit
logout
student@debian:~$ su - yanina
Password: 
yanina@debian ~ % echo $SHELL
/usr/bin/zsh
yanina@debian ~ % getent passwd yanina 
yanina:x:1002:1002:Yanina Wickmayer:/home/yanina:/usr/bin/zsh
```

On Enterprise Linux, `chsh` has an option `-l` option that lists the available shells. This option is not available on Debian.

```console
[student@el ~]$ chsh -l
/bin/sh
/bin/bash
/usr/bin/sh
/usr/bin/bash
/usr/bin/zsh
/bin/zsh
```

## userdel

You can delete the user yanina with `userdel`. The `-r` option of userdel will also remove the home directory.

```console
student@debian:~$ sudo userdel -r yanina
```

## managing home directories

The easiest way to create a home directory is to supply the `-m` option with `useradd`. If you forgot the option on a Debian system, you could delete the user and start again, or create the directory yourself. This also requires setting the owner and the permissions on the directory with `chmod` and `chown` (both commands are discussed in detail in another chapter).

```console
student@debian:~$ sudo useradd -s /bin/bash laura
student@debian:~$ getent passwd laura
laura:x:1004:1004::/home/laura:/bin/bash
student@debian:~$ sudo mkdir /home/laura
student@debian:~$ sudo chown laura:laura /home/laura
student@debian:~$ sudo chmod -R 700 /home/laura
student@debian:~$ ls -ld /home/laura/
drwx------ 2 laura laura 4096 Jun 24 15:17 /home/laura/
```

### /etc/skel/

When using `useradd` the `-m` option, the `/etc/skel/` directory is copied to the newly created home directory. The `/etc/skel/` directory contains some (usually hidden) files that contain profile settings and default values for applications. In this way `/etc/skel/` serves as a default home directory and as a default user profile.

```console
student@debian:~$ ls -la /etc/skel
total 20
drwxr-xr-x  2 root root 4096 Jan 31  2024 .
drwxr-xr-x 81 root root 4096 Oct 15 14:07 ..
-rw-r--r--  1 root root  220 Apr 23  2023 .bash_logout
-rw-r--r--  1 root root 3526 Apr 23  2023 .bashrc
-rw-r--r--  1 root root  807 Apr 23  2023 .profile
```

### deleting home directories

The `-r` option of `userdel` will make sure that the home directory is deleted together with the user account.

```console
student@debian:~$ sudo useradd -m -s /bin/bash wim
student@debian:~$ getent passwd wim
wim:x:1005:1005::/home/wim:/bin/bash
student@debian:~$ sudo userdel -r wim
student@debian:~$ ls -ld /home/wim/
ls: cannot access '/home/wim/': No such file or directory
```

## adduser, deluser (debian/ubuntu)

On Debian/Ubuntu, an additional command to manage users is available: `adduser`
and `deluser`. The `adduser` command is a more user-friendly frontend to `useradd` and does all that is necessary to create a new user that can immediately log in to the system. The disadvantage is that it's an interactive command, so it's not suited to use in a script to automate the installation of a machine.

```console
student@debian:~$ sudo adduser kim
Adding user `kim' ...
Adding new group `kim' (1003) ...
Adding new user `kim' (1003) with group `kim (1003)' ...
Creating home directory `/home/kim' ...
Copying files from `/etc/skel' ...
New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for kim
Enter the new value, or press ENTER for the default
        Full Name []: Kim Clijsters
        Room Number []: 
        Work Phone []: 
        Home Phone []: 
        Other []: 
Is the information correct? [Y/n] 
Adding new user `kim' to supplemental / extra groups `users' ...
Adding user `kim' to group `users' ...
student@debian:~$ su - kim
Password: 
kim@debian:~$ pwd
/home/kim
```

The `deluser` command is a frontend to `userdel` and `groupdel` and removes a user and the associated group. The home directory is not removed by default.

```console
student@debian:~$ sudo deluser kim
Removing crontab ...
Removing user `kim' ...
Done.
student@debian:~$ ls /home/
kim  student  yanina
student@debian:~$ sudo rm -rf /home/kim/
```

