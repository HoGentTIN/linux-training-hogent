## sticky bit on directory

You can set the `sticky bit` on a directory to prevent
users from removing files that they do not own as a user owner. The
sticky bit is displayed at the same location as the x permission for
others. The sticky bit is represented by a `t` (meaning x is also there)
or a `T` (when there is no x for others).

    root@RHELv8u4:~# mkdir /project55
    root@RHELv8u4:~# ls -ld /project55
    drwxr-xr-x  2 root root 4096 Feb  7 17:38 /project55
    root@RHELv8u4:~# chmod +t /project55/
    root@RHELv8u4:~# ls -ld /project55
    drwxr-xr-t  2 root root 4096 Feb  7 17:38 /project55
    root@RHELv8u4:~#

The `sticky bit` can also be set with octal permissions, it is binary 1
in the first of four triplets.

    root@RHELv8u4:~# chmod 1775 /project55/
    root@RHELv8u4:~# ls -ld /project55
    drwxrwxr-t  2 root root 4096 Feb  7 17:38 /project55
    root@RHELv8u4:~#

You will typically find the `sticky bit` on the `/tmp`
directory.

    root@barry:~# ls -ld /tmp
    drwxrwxrwt 6 root root 4096 2009-06-04 19:02 /tmp

## setgid bit on directory

`setgid` can be used on directories to make sure that all
files inside the directory are owned by the group owner of the
directory. The `setgid` bit is displayed at the same location as the x
permission for group owner. The `setgid` bit is represented by an `s`
(meaning x is also there) or a `S` (when there is no x for the group
owner). As this example shows, even though `root` does not belong to the
group proj55, the files created by root in /project55 will belong to
proj55 since the `setgid` is set.

    root@RHELv8u4:~# groupadd proj55
    root@RHELv8u4:~# chown root:proj55 /project55/
    root@RHELv8u4:~# chmod 2775 /project55/
    root@RHELv8u4:~# touch /project55/fromroot.txt
    root@RHELv8u4:~# ls -ld /project55/
    drwxrwsr-x  2 root proj55 4096 Feb  7 17:45 /project55/
    root@RHELv8u4:~# ls -l /project55/
    total 4
    -rw-r--r--  1 root proj55 0 Feb  7 17:45 fromroot.txt
    root@RHELv8u4:~#

You can use the `find` command to find all
`setgid` directories.

    paul@laika:~$ find / -type d -perm -2000 2> /dev/null
    /var/log/mysql
    /var/log/news
    /var/local
    ...

## setgid and setuid on regular files

These two permissions cause an executable file to be executed with the
permissions of the `file owner` instead of the `executing owner`. This
means that if any user executes a program that belongs to the
`root user`, and the `setuid` bit is set on that program,
then the program runs as `root`. This can be dangerous, but sometimes
this is good for security.

Take the example of passwords; they are stored in
`/etc/shadow` which is only readable by `root`. (The
`root` user never needs permissions anyway.)

    root@RHELv8u4:~# ls -l /etc/shadow
    -r--------  1 root root 1260 Jan 21 07:49 /etc/shadow
            

Changing your password requires an update of this file, so how can
normal non-root users do this? Let\'s take a look at the permissions on
the `/usr/bin/passwd`.

    root@RHELv8u4:~# ls -l /usr/bin/passwd 
    -r-s--x--x  1 root root 21200 Jun 17  2005 /usr/bin/passwd
            

When running the `passwd` program, you are executing it
with `root` credentials.

You can use the `find` command to find all
`setuid` programs.

    paul@laika:~$ find /usr/bin -type f -perm -04000
    /usr/bin/arping
    /usr/bin/kgrantpty
    /usr/bin/newgrp
    /usr/bin/chfn
    /usr/bin/sudo
    /usr/bin/fping6
    /usr/bin/passwd
    /usr/bin/gpasswd
    ...
            

In most cases, setting the `setuid` bit on executables is sufficient.
Setting the `setgid` bit will result in these programs to run with the
credentials of their group owner.

## setuid on sudo

The `sudo` binary has the `setuid` bit set, so any user
can run it with the effective userid of root.

    paul@rhel65:~$ ls -l $(which sudo)
    ---s--x--x. 1 root root 123832 Oct  7  2013 /usr/bin/sudo
    paul@rhel65:~$

