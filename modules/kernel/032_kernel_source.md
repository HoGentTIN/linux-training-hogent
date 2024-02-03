# Linux kernel source

## ftp.kernel.org

The home of the Linux kernel source is `ftp.kernel.org`.
It contains all official releases of the Linux kernel source code from
1991. It provides free downloads over http, ftp and rsync of all these
releases, as well as changelogs and patches. More information can be
otained on the website `www.kernel.org`.

Anyone can anonymously use an ftp client to access ftp.kernel.org

    paul@laika:~$ ftp ftp.kernel.org
    Connected to pub3.kernel.org.
    220 Welcome to ftp.kernel.org.
    Name (ftp.kernel.org:paul): anonymous
    331 Please specify the password.
    Password:
    230-                Welcome to the
    230-
    230-            LINUX KERNEL ARCHIVES
    230-                ftp.kernel.org

All the Linux kernel versions are located in the pub/linux/kernel/
directory.

    ftp> ls pub/linux/kernel/v*
    200 PORT command successful. Consider using PASV.
    150 Here comes the directory listing.
    drwxrwsr-x    2 536      536          4096 Mar 20  2003 v1.0
    drwxrwsr-x    2 536      536         20480 Mar 20  2003 v1.1
    drwxrwsr-x    2 536      536          8192 Mar 20  2003 v1.2
    drwxrwsr-x    2 536      536         40960 Mar 20  2003 v1.3
    drwxrwsr-x    3 536      536         16384 Feb 08  2004 v2.0
    drwxrwsr-x    2 536      536         53248 Mar 20  2003 v2.1
    drwxrwsr-x    3 536      536         12288 Mar 24  2004 v2.2
    drwxrwsr-x    2 536      536         24576 Mar 20  2003 v2.3
    drwxrwsr-x    5 536      536         28672 Dec 02 08:14 v2.4
    drwxrwsr-x    4 536      536         32768 Jul 14  2003 v2.5
    drwxrwsr-x    7 536      536        110592 Dec 05 22:36 v2.6
    226 Directory send OK.
    ftp>

## /usr/src

On your local computer, the kernel source is located in
`/usr/src`. Note though that the structure inside /usr/src
might be different depending on the distribution that you are using.

First let\'s take a look at `/usr/src on Debian`. There appear to be two
versions of the complete Linux source code there. Looking for a specific
file (e1000_main.c) with find reveals it\'s exact location.

    paul@barry:~$ ls -l /usr/src/
    drwxr-xr-x 20 root root     4096 2006-04-04 22:12 linux-source-2.6.15
    drwxr-xr-x 19 root root     4096 2006-07-15 17:32 linux-source-2.6.16
    paul@barry:~$ find /usr/src -name e1000_main.c
    /usr/src/linux-source-2.6.15/drivers/net/e1000/e1000_main.c
    /usr/src/linux-source-2.6.16/drivers/net/e1000/e1000_main.c

This is very similar to `/usr/src on Ubuntu`, except there is only one
kernel here (and it is newer).

    paul@laika:~$ ls -l /usr/src/
    drwxr-xr-x 23 root root     4096 2008-11-24 23:28 linux-source-2.6.24
    paul@laika:~$ find /usr/src -name "e1000_main.c"
    /usr/src/linux-source-2.6.24/drivers/net/e1000/e1000_main.c

Now take a look at `/usr/src on Red Hat Enterprise Linux`.

    [paul@RHEL52 ~]$ ls -l /usr/src/
    drwxr-xr-x 5 root root 4096 Dec  5 19:23 kernels
    drwxr-xr-x 7 root root 4096 Oct 11 13:22 redhat

We will have to dig a little deeper to find the kernel source on Red
Hat!

    [paul@RHEL52 ~]$ cd /usr/src/redhat/BUILD/
    [paul@RHEL52 BUILD]$ find . -name "e1000_main.c"
    ./kernel-2.6.18/linux-2.6.18.i686/drivers/net/e1000/e1000_main.c

## downloading the kernel source

### Debian

Installing the kernel source on Debian is really simple with
`aptitude install linux-source`. You can do a search for
all linux-source packeges first, like in this screenshot.

    root@barry:~# aptitude search linux-source
    v   linux-source           -
    v   linux-source-2.6       -
    id  linux-source-2.6.15    - Linux kernel source for version 2.6.15
    i   linux-source-2.6.16    - Linux kernel source for version 2.6.16
    p   linux-source-2.6.18    - Linux kernel source for version 2.6.18
    p   linux-source-2.6.24    - Linux kernel source for version 2.6.24

And then use `aptitude install` to download and install the Debian Linux
kernel source code.

    root@barry:~# aptitude install linux-source-2.6.24

When the aptitude is finished, you will see a new file named
`/usr/src/linux-source-<version>.tar.bz2`

    root@barry:/usr/src# ls -lh
    drwxr-xr-x 20 root root 4.0K 2006-04-04 22:12 linux-source-2.6.15
    drwxr-xr-x 19 root root 4.0K 2006-07-15 17:32 linux-source-2.6.16
    -rw-r--r--  1 root root  45M 2008-12-02 10:56 linux-source-2.6.24.tar.bz2

### Ubuntu

Ubuntu is based on Debian and also uses `aptitude`, so the task is very
similar.

    root@laika:~# aptitude search linux-source
    i   linux-source           - Linux kernel source with Ubuntu patches
    v   linux-source-2.6       -
    i A linux-source-2.6.24    - Linux kernel source for version 2.6.24
    root@laika:~# aptitude install linux-source

And when aptitude finishes, we end up with a
`/usr/src/linux-source-<version>.tar.bz` file.

    oot@laika:~# ll /usr/src
    total 45M
    -rw-r--r--  1 root root  45M 2008-11-24 23:30 linux-source-2.6.24.tar.bz2

### Red Hat Enterprise Linux

The Red Hat kernel source is located on the fourth source cdrom. The
file is called `kernel-2.6.9-42.EL.src.rpm` (example for RHELv8u4). It
is also available online at
ftp://ftp.redhat.com/pub/redhat/linux/enterprise/5Server/en/os/SRPMS/
(example for RHEL5).

To download the kernel source on RHEL, use this long wget command (on
one line, without the trailing \\).

    wget ftp://ftp.redhat.com/pub/redhat/linux/enterprise/5Server/en/os/\
    SRPMS/kernel-`uname -r`.src.rpm

When the wget download is finished, you end up with a 60M .rpm file.

    [root@RHEL52 src]# ll
    total 60M
    -rw-r--r-- 1 root root  60M Dec  5 20:54 kernel-2.6.18-92.1.17.el5.src.rpm
    drwxr-xr-x 5 root root 4.0K Dec  5 19:23 kernels
    drwxr-xr-x 7 root root 4.0K Oct 11 13:22 redhat

We will need to perform some more steps before this can be used as
kernel source code.

First, we issue the `rpm -i kernel-2.6.9-42.EL.src.rpm` command to
install this Red Hat package.

    [root@RHEL52 src]# ll
    total 60M
    -rw-r--r-- 1 root root  60M Dec  5 20:54 kernel-2.6.18-92.1.17.el5.src.rpm
    drwxr-xr-x 5 root root 4.0K Dec  5 19:23 kernels
    drwxr-xr-x 7 root root 4.0K Oct 11 13:22 redhat
    [root@RHEL52 src]# rpm -i kernel-2.6.18-92.1.17.el5.src.rpm

Then we move to the SPECS directory and perform an `rpmbuild`.

    [root@RHEL52 ~]# cd /usr/src/redhat/SPECS
    [root@RHEL52 SPECS]# rpmbuild -bp -vv --target=i686 kernel-2.6.spec

The rpmbuild command put the RHEL Linux kernel source code in
`/usr/src/redhat/BUILD/kernel-<version>/`.

    [root@RHEL52 kernel-2.6.18]# pwd
    /usr/src/redhat/BUILD/kernel-2.6.18
    [root@RHEL52 kernel-2.6.18]# ll
    total 20K
    drwxr-xr-x  2 root root 4.0K Dec  6  2007 config
    -rw-r--r--  1 root root 3.1K Dec  5 20:58 Config.mk
    drwxr-xr-x 20 root root 4.0K Dec  5 20:58 linux-2.6.18.i686
    drwxr-xr-x 19 root root 4.0K Sep 20  2006 vanilla
    drwxr-xr-x  8 root root 4.0K Dec  6  2007 xen

