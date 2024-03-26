# File system tree

## Filesystem Hierarchy Standard

All files on a Linux system should have a well defined directory to
reside in. Debian Linux conforms to many parts of the Filesystem
Hierarchy Standard (FHS) which can be found at
<http://www.pathname.com/fhs/> .

There is an alphabetical list of directories (describing their purpose)
in the **man hier** manual (*hier* is short for hierarchy). In this
chapter we discuss the most common directories on a Debian Linux system.

## Data directories

### /home


The first directory to explore is the **/home** directory. In this
directory there can be a sub-directory for each user, usually identical
in name to the user name. Each user can put personal files in his or her
**home directory**.

In the screenshot below we list the contents of the **/home** directory
on a Debian system with five users.

Chances are that on your system there is only one user home directory,
namely yours.

    paul@debian10:~$ ls -l /home
    total 20
    drwxr-xr-x 2 annik annik 4096 Jul 29 14:31 annik
    drwxr-xr-x 2 david david 4096 Jul 29 14:31 david
    drwxr-xr-x 2 geert geert 4096 Jul 29 14:31 geert
    drwxr-xr-x 2 linda linda 4096 Jul 29 14:31 linda
    drwxr-xr-x 5 paul  paul  4096 Jul 29 13:52 paul
    paul@debian10:~$

You cannot (and should not) store files in **/home/** directly. Always
store personal files in **/home/yourusername**.

### /root


Each Linux system has a unique user named **root**. This **root** user
can manage the system, install software, add users and much more. Since
this is a special user, he or she also has a special **home directory**
named **/root**.

As a normal user, you do not have access to the **/root** directory.

    paul@debian10:~$ ls /root
    ls: cannot open directory /root: Permission denied
    paul@debian10:~$

The real reason that **/root** is not in **/home** is that **/home** can
be mounted from the network and the network is not available when
troubleshooting a system in *single user mode*.

### /srv


File servers can share many files (and directories) on the network.
Whenever a directory is shared, it should reside in the **/srv**
directory. You can read the **/srv** directory as *served by your
system*.

The screenshot below shows an empty **/srv** directory, so I assume this
computer is not sharing directories on the (local) network.

    paul@debian10:~$ ls -l /srv/
    total 0
    paul@debian10:~$

I have often encountered organisations that use **/mnt** for this
purpose. Don’t do that, it is wrong.

### /mnt


The **/mnt** directory should be empty. It serves as a **temporary**
mount point for filesystems.

    paul@debian10:~$ ls /mnt
    paul@debian10:~$

We will discuss **mounting** of filesystems in the storage section of
this book.

### /media


The **/media** directory is used to **mount** removable media such as
compact discs or USB sticks. On a graphical interface of an end user
Linux computer this will happen automatically so the user can access the
media. On a Linux server this directory can be empty.

This Debian 10 server has a CD-ROM drive, so the directory
**/media/cdrom** is present.

    paul@debian10:~$ ls -l /media/
    total 4
    lrwxrwxrwx 1 root root    6 Jul 24 18:07 cdrom -> cdrom0
    drwxr-xr-x 2 root root 4096 Jul 24 18:07 cdrom0
    paul@debian10:~$

The cdrom file is a **symbolic link**, we will discuss **links** in the
Links chapter.

### /tmp


Both users and applications can store **temporary** data in **/tmp**. A
regular Debian Linux will empty this directory each time it is booted.

## Binary directories

### /bin


According to the FHS **/bin** holds commands for normal users and for
the administrator. In Debian 10 the **/bin** directory is a link to
**/usr/bin** (We will discuss links in the Links chapter).

    paul@debian10:~$ ls -ld /bin
    lrwxrwxrwx 1 root root 7 Jul 24 18:07 /bin -> usr/bin
    paul@debian10:~$

The **/bin** directory contains many simple commands like **head**,
**tail**, **tac**, **cat**, **ls**, and **pwd** (and many more).

    paul@debian10:~$ cd /bin
    paul@debian10:/bin$ ls -l head tail tac cat ls pwd
    -rwxr-xr-x 1 root root  43744 Feb 28 16:30 cat
    -rwxr-xr-x 1 root root  47840 Feb 28 16:30 head
    -rwxr-xr-x 1 root root 138856 Feb 28 16:30 ls
    -rwxr-xr-x 1 root root  39616 Feb 28 16:30 pwd
    -rwxr-xr-x 1 root root  43744 Feb 28 16:30 tac
    -rwxr-xr-x 1 root root  72608 Feb 28 16:30 tail
    paul@debian10:/bin$

### /sbin


The **/sbin** directory contains utilities for the **root** user to
manage the system. On Debian 10 this directory is a link to
**/usr/sbin**.

    paul@debian10:~$ ls -ld /sbin
    lrwxrwxrwx 1 root root 8 Jul 24 18:07 /sbin -> usr/sbin
    paul@debian10:~$

We will use many of the commands in **/sbin** in this book when we reach
the system administration chapters.

### /lib


The **/lib** directory (again a symbolic link to **/usr/lib**) contains
libraries. Libraries are executables that do not run by themselves, but
instead are called by other executables.

The screenshot below shows information about the **ssh-keysign** library
file.

    paul@debian10:~$ file /lib/openssh/ssh-keysign
    /lib/openssh/ssh-keysign: setuid ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=d3eb93acd1467d5e04b65d5bcc35ceb5b0d1ff90, stripped
    paul@debian10:~$

### /opt


The **/opt** directory is there for *optional* packages. This means
packages that are not part of Debian (they are not in the Debian
repositories), but can be installed on Debian. Examples are **/opt/ora**
for Oracle software and **/opt/ibm** for IBM packages.

By default on Debian **/opt** is empty.

    paul@debian10:~$ ls -l /opt
    total 0
    paul@debian10:~$

## Configuration directory

### /etc


The **/etc** directory contains configuration files, in fact it contains
almost all configuration files for the local system. There are many
sub-directories in **/etc** to group configuration files by application
or by protocol.

Below is a small view of some of the configuration files in **/etc**.

    paul@debian10:~$ ls /etc/*.conf
    /etc/adduser.conf            /etc/kernel-img.conf          /etc/reportbug.conf
    /etc/ca-certificates.conf    /etc/ld.so.conf               /etc/resolv.conf
    /etc/debconf.conf            /etc/libaudit.conf            /etc/rsyslog.conf
    /etc/deluser.conf            /etc/logrotate.conf           /etc/sysctl.conf
    /etc/discover-modprobe.conf  /etc/mke2fs.conf              /etc/ucf.conf
    /etc/gai.conf                /etc/nsswitch.conf            /etc/xattr.conf
    /etc/hdparm.conf             /etc/pam.conf
    /etc/host.conf               /etc/popularity-contest.conf
    paul@debian10:~$

## Boot directory

### /boot


The **/boot** directory contains the necessary files to **boot** the
system from **power on** to a running **Linux kernel**. The **Linux
kernel** file is called **vmlinuz** followed by a version number. We
will discuss these files in the Booting Linux chapter.

    paul@debian10:~$ ls -l /boot
    total 33576
    -rw-r--r-- 1 root root   206212 Jul 19 10:45 config-4.19.0-5-amd64
    drwxr-xr-x 5 root root     4096 Jul 24 18:16 grub
    -rw-r--r-- 1 root root 25563597 Jul 24 18:12 initrd.img-4.19.0-5-amd64
    -rw-r--r-- 1 root root  3371025 Jul 19 10:45 System.map-4.19.0-5-amd64
    -rw-r--r-- 1 root root  5225712 Jul 19 10:45 vmlinuz-4.19.0-5-amd64
    paul@debian10:~$

## Directories in RAM memory

### /dev


The **/dev** directory is populated with real and pseudo **devices**
when the computer is starting. You can for example find information
about attached hard disk devices in **/dev/disk/**.

    paul@debian10:~$ ls /dev/disk
    by-id  by-partuuid  by-path  by-uuid
    paul@debian10:~$

#### /dev/random


One useful *pseudo* device in **/dev** is **/dev/random**. This file is
a random number generator that will generate random numbers if there is
enough entropy. This file can be used to generate secure private keys.

#### /dev/urandom


You can also use **/dev/urandom** which will continuously generate
random numbers that can be used for games and other non-security related
actions. It will spawn random numbers even if there is not enough
entropy on the system.

#### /dev/zero


The **/dev/zero** *pseudo* device will generate an endless amount of
zeroes when used. This is useful for example when overwriting a hard
disk before you sell it on eBay.

#### /dev/null


The **/dev/null** *pseudo* device is often used as a target file for
data that has to be discarded immediately.

### /proc


The **/proc** directory provides a means to talk with the kernel and
contains a directory for every **process** on the system. We will
discuss processes in the Processes chapters.

    paul@debian10:~$ ls /proc
    1     135  21   322  41   6     buddyinfo    interrupts   misc          sysrq-trigger
    10    14   22   33   42   65    bus          iomem        modules       sysvipc
    1065  15   24   34   43   66    cgroups      ioports      mounts        thread-self
    1068  16   241  35   431  76    cmdline      irq          mtrr          timer_list
    1069  17   25   36   432  8     consoles     kallsyms     net           tty
    11    171  258  365  44   9     cpuinfo      kcore        pagetypeinfo  uptime
    114   176  26   369  46   967   crypto       keys         partitions    version
    115   177  27   37   481  969   devices      key-users    sched_debug   vmallocinfo
    117   19   289  374  482  974   diskstats    kmsg         schedstat     vmstat
    118   2    29   376  486  977   dma          kpagecgroup  self          zoneinfo
    119   20   3    378  492  978   driver       kpagecount   slabinfo
    12    203  30   38   493  982   execdomains  kpageflags   softirqs
    129   205  31   39   500  987   fb           loadavg      stat
    13    206  32   4    546  988   filesystems  locks        swaps
    134   207  321  40   58   acpi  fs           meminfo      sys
    paul@debian10:~$

Using **/proc** you can query for a lot of information about the
computer like its **interrupts**, its **uptime** or **cpuinfo**.

    paul@debian10:~$ head /proc/cpuinfo
    processor       : 0
    vendor_id       : GenuineIntel
    cpu family      : 6
    model           : 70
    model name      : Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz
    stepping        : 1
    cpu MHz         : 2194.918
    cache size      : 6144 KB
    physical id     : 0
    siblings        : 4
    paul@debian10:~$

### /sys


The **/sys** directory has similar information about the kernel like
**/proc** but is structured differently. When hot plugging devices then
the necessary files are automatically created in **/sys**. This
directory is not part of FHS, but is always present in RAM memory on a
Debian Linux system.

    paul@debian10:~$ ls -l /sys
    total 0
    drwxr-xr-x   2 root root 0 Jul 29 16:27 block
    drwxr-xr-x  29 root root 0 Jul 29 16:27 bus
    drwxr-xr-x  46 root root 0 Jul 29 16:27 class
    drwxr-xr-x   4 root root 0 Jul 29 16:27 dev
    drwxr-xr-x  15 root root 0 Jul 29 16:27 devices
    drwxr-xr-x   5 root root 0 Jul 29 16:27 firmware
    drwxr-xr-x   6 root root 0 Jul 29 16:27 fs
    drwxr-xr-x   2 root root 0 Jul 29 21:02 hypervisor
    drwxr-xr-x  12 root root 0 Jul 29 16:27 kernel
    drwxr-xr-x 101 root root 0 Jul 29 16:27 module
    drwxr-xr-x   2 root root 0 Jul 29 16:27 power
    paul@debian10:~$

### /usr


The **/usr** directory, short for Unix System Resources (a backronym)
stores read-only, shareable data. It is possible to mount **/usr** from
the network and to share it across multiple Linux computers.

    paul@debian10:~$ ls /usr
    bin  games  include  lib  lib32  lib64  libx32  local  sbin  share  src
    paul@debian10:~$

#### /usr/bin and /usr/sbin


We have already seen that Debian by default will create a link between
**/bin** and **/usr/bin** and between **/sbin** and **/usr/sbin**. So
naturally these directories contain the same commands.

    paul@debian10:~$ ls -ld /bin
    lrwxrwxrwx 1 root root 7 Jul 24 18:07 /bin -> usr/bin
    paul@debian10:~$ ls -ld /sbin
    lrwxrwxrwx 1 root root 8 Jul 24 18:07 /sbin -> usr/sbin
    paul@debian10:~$

#### /usr/include and /usr/src


Source code should be placed in the **/usr/src** directory and include
files in the **/usr/include** directory.

Below a screenshot of some header files in **/usr/include**.

    paul@debian10:~$ find /usr/include/
    /usr/include/
    /usr/include/reglib
    /usr/include/reglib/reglib.h
    /usr/include/reglib/nl80211.h
    /usr/include/reglib/regdb.h
    /usr/include/iproute2
    /usr/include/iproute2/bpf_elf.h
    /usr/include/clif.h
    paul@debian10:~$

The **/usr/src** directory can be empty until you install source code
from the repository.

    paul@debian10:~$ ls /usr/src/
    paul@debian10:~$

#### /usr/local


The **/usr/local** directory can be used by software that is installed
locally (often after local compilation) by the **root** user.

You may recognise some of the directories in **/usr/local** and they can
be empty on a fresh install of Debian 10.

    paul@debian10:~$ ls /usr/local/
    bin  etc  games  include  lib  man  sbin  share  src
    paul@debian10:~$

#### /usr/share


The **/usr/share** directory contains shareable architecture independent
files. For example the **man pages** are in **/usr/share**.

    paul@debian10:~$ ls /usr/share/man
    cs  de  fi  fr.ISO8859-1  hu  it  ko    man2  man4  man6  man8  pl  pt_BR  sl  sv  zh_CN
    da  es  fr  fr.UTF-8      id  ja  man1  man3  man5  man7  nl    pt  ru     sr  tr  zh_TW
    paul@debian10:~$

### /var


The **/var** directory contains files that are unpredictable in size. In
the past this used to be a separate partition on the hard disk, to
prevent filling the root file system to 100 percent.

    paul@debian10:~$ ls /var
    backups  cache  lib  local  lock  log  mail  opt  run  spool  tmp
    paul@debian10:~$

The **/var** directory contains several notable sub-directories.

#### /var/cache


Applications that use a cache should store this in **/var/cache/**. For
example the cache of a DNS server or the cache of the **apt** system
(see Software Management).

    paul@debian10:~$ ls /var/cache/
    apparmor  apt  debconf  dictionaries-common  ldconfig  man  private
    paul@debian10:~$

#### /var/log


Log files should be stored in **/var/log**, either in a **.log** file or
in a sub-directory. We will see later how to access these log files.

    paul@debian10:~$ ls /var/log
    alternatives.log  daemon.log  installer  popularity-contest.0     private
    apt               debug       kern.log   popularity-contest.1.gz  syslog
    auth.log          dpkg.log    lastlog    popularity-contest.2.gz  user.log
    btmp              faillog     messages   popularity-contest.new   wtmp
    paul@debian10:~$

#### /var/run


The **/var/run** directory is a symbolic link to **/run**.

    paul@debian10:~$ ls -ld /var/run
    lrwxrwxrwx 1 root root 4 Jul 24 18:07 /var/run -> /run
    paul@debian10:~$

This directory contains run-state information about programs that are
running (since the system was booted). For example **.pid** files should
be stored here.

    paul@debian10:~$ ls /var/run
    agetty.reload  dbus                 lock          network          sshd.pid    user
    console-setup  dhclient.enp0s3.pid  log           sendsigs.omit.d  systemd     utmp
    crond.pid      initctl              motd.dynamic  shm              tmpfiles.d
    crond.reboot   initramfs            mount         sshd             udev
    paul@debian10:~$

#### /var/spool


The **/var/spool** directory contains data that is waiting to be
processed, like for example a print queue or an outgoing mail queue.

    paul@debian10:~$ ls /var/spool/
    anacron  cron  mail  rsyslog
    paul@debian10:~$

## Cheat sheet

<table>
<caption>Filesystem hierarchy</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>location</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/home</p></td>
<td style="text-align: left;"><p>location for home directories</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/home/paul</p></td>
<td style="text-align: left;"><p>home directory for
<strong>paul</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/root</p></td>
<td style="text-align: left;"><p>home directory for the
<strong>root</strong> user</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/srv</p></td>
<td style="text-align: left;"><p>location for directories that are
<strong>served</strong> on the network</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/mnt</p></td>
<td style="text-align: left;"><p>temporary mount point</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/media</p></td>
<td style="text-align: left;"><p>location for removable media</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/media/cdrom</p></td>
<td style="text-align: left;"><p>mount point for CD-ROM</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/tmp</p></td>
<td style="text-align: left;"><p>location for temporary files</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/bin</p></td>
<td style="text-align: left;"><p>location for commands
(executables)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/sbin</p></td>
<td style="text-align: left;"><p>location for commands to manage the
system</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/lib</p></td>
<td style="text-align: left;"><p>location for libraries (shared
objects)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/opt</p></td>
<td style="text-align: left;"><p>location for <strong>optional</strong>
software from outside the repository</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc</p></td>
<td style="text-align: left;"><p>contains configuration</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/boot</p></td>
<td style="text-align: left;"><p>contains files necessary to boot the
system</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/dev</p></td>
<td style="text-align: left;"><p>contains real and pseudo
devices</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/dev/random</p></td>
<td style="text-align: left;"><p>secure random number generator</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/dev/urandom</p></td>
<td style="text-align: left;"><p>quick random number generator</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/dev/zero</p></td>
<td style="text-align: left;"><p>endless source of zeroes</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/dev/null</p></td>
<td style="text-align: left;"><p>black hole (anything copied to it is
discarded)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/proc</p></td>
<td style="text-align: left;"><p>contains kernel information
(interfaces)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/proc/cpuinfo</p></td>
<td style="text-align: left;"><p>contains CPU information</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/proc/meminfo</p></td>
<td style="text-align: left;"><p>contains memory information</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/sys</p></td>
<td style="text-align: left;"><p>system information (since kernel
2.6)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/usr</p></td>
<td style="text-align: left;"><p>read only shared data</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/usr/bin</p></td>
<td style="text-align: left;"><p>/bin links to this location</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/usr/sbin</p></td>
<td style="text-align: left;"><p>/sbin links to this location</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/usr/games</p></td>
<td style="text-align: left;"><p>location for games</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/usr/lib</p></td>
<td style="text-align: left;"><p>/lib links to this location</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/usr/local</p></td>
<td style="text-align: left;"><p>default location for locally compiled
files</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/usr/share</p></td>
<td style="text-align: left;"><p>data that can be shared across
architectures</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/usr/share/dict</p></td>
<td style="text-align: left;"><p>dictionaries location</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/usr/share/man</p></td>
<td style="text-align: left;"><p>location for man pages</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/usr/src</p></td>
<td style="text-align: left;"><p>location for system source
files</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/var</p></td>
<td style="text-align: left;"><p>directory for files variable in
size</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/var/cache</p></td>
<td style="text-align: left;"><p>location for cache files</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/var/log</p></td>
<td style="text-align: left;"><p>location for log files</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/var/run</p></td>
<td style="text-align: left;"><p>location for run-state
information</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/var/spool</p></td>
<td style="text-align: left;"><p>location for spool directories (e.g.
mail or print queue)</p></td>
</tr>
</tbody>
</table>

Filesystem hierarchy

## Practice

1.  List the contents of the ssh configuration directory.

2.  List the contents of your home directory.

3.  Try to enter the home directory of the root user.

4.  List the data directories that are shared on the network by this
    computer.

5.  Create a temporary test directory.

6.  List the commands to manage the Linux system.

7.  List the man-db libraries.

8.  List third party package providers.

9.  List the size of the kernel in human readable format.

## Solution

1.  List the contents of the ssh configuration directory.

        ls /etc/ssh

2.  List the contents of your home directory.

        ls ~

3.  Try to enter the home directory of the root user.

        cd /root

4.  List the data directories that are shared on the network by this
    computer.

        ls /srv

5.  Create a temporary test directory.

        mkdir /tmp/test

6.  List the commands to manage the Linux system.

        ls /sbin
        ls /usr/sbin

7.  List the man-db libraries.

        ls /lib/man-db

8.  List third party package providers.

        ls /opt

9.  List the size of the kernel in human readable format.

        ls -lh /boot/vmlinuz*
