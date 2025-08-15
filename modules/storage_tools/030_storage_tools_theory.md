## lsof

List open files with `lsof`.

When invoked without options, `lsof` will list all open files. You can
see the command (init in this case), its PID (1) and the user (root) has
openend the root directory and `/sbin/init`. The FD (file descriptor)
columns shows that / is both the root directory (rtd) and current
working directory (cwd) for the /sbin/init command. The FD column
displays `rtd` for root directory, `cwd` for current directory and `txt`
for text (both including data and code).

    root@linux:~# lsof | head -4
    COMMAND PID  TID   USER   FD    TYPE     DEVICE SIZE/OFF      NODE NAME
    init      1        root  cwd     DIR      254,0     4096         2 /
    init      1        root  rtd     DIR      254,0     4096         2 /
    init      1        root  txt     REG      254,0    36992    130856 /sbin/init

Other options in the FD column besides w for writing, are r for reading
and u for both reading and writing. You can look at open files for a
process id by typing `lsof -p PID`. For `init` this would look like
this:

    lsof -p 1

The screenshot below shows basic use of `lsof` to prove that `vi` keeps
a `.swp` file open (even when stopped in background) on our freshly
mounted file system.

    [root@linux ~]# df -h | grep sdb
    /dev/sdb1                     541M   17M  497M   4% /srv/project33
    [root@linux ~]# vi /srv/project33/busyfile.txt
    [1]+  Stopped                 vi /srv/project33/busyfile.txt
    [root@linux ~]# lsof /srv/*
    COMMAND  PID USER  FD  TYPE DEVICE SIZE/OFF NODE NAME
    vi      3243 root   3u  REG   8,17   4096   12 /srv/project33/.busyfile.txt.swp

Here we see that `rsyslog` has a couple of log files open
for writing (the FD column).

    root@linux:~# lsof /var/log/*
    COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
    rsyslogd 2013 root    1w   REG  254,0   454297 1308187 /var/log/syslog
    rsyslogd 2013 root    2w   REG  254,0   419328 1308189 /var/log/kern.log
    rsyslogd 2013 root    5w   REG  254,0   116725 1308200 /var/log/debug
    rsyslogd 2013 root    6w   REG  254,0   309847 1308201 /var/log/messages
    rsyslogd 2013 root    7w   REG  254,0    17591 1308188 /var/log/daemon.log
    rsyslogd 2013 root    8w   REG  254,0   101768 1308186 /var/log/auth.log

You can specify a specific user with `lsof -u`. This example shows the
current working directory for a couple of command line programs.

    [student@linux ~]$ lsof -u paul | grep home
    bash    3302 paul  cwd    DIR  253,0     4096  788024 /home/paul
    lsof    3329 paul  cwd    DIR  253,0     4096  788024 /home/paul
    grep    3330 paul  cwd    DIR  253,0     4096  788024 /home/paul
    lsof    3331 paul  cwd    DIR  253,0     4096  788024 /home/paul

The -u switch of `lsof` also supports the \^ character meaning 'not'.
To see all open files, but not those open by root:

    lsof -u^root

## fuser

The `fuser` command will display the 'user' of a file
system.

In this example we still have a vi process in background and we use
`fuser` to find the process id of the process using this
file system.

    [root@linux ~]# jobs
    [1]+  Stopped                 vi /srv/project33/busyfile.txt
    [root@linux ~]# fuser -m /srv/project33/
    /srv/project33/:      3243

Adding the `-u` switch will also display the user name.

    [root@linux ~]# fuser -m -u /srv/project33/
    /srv/project33/:      3243(root)

You can quickly kill all processes that are using a specific file (or
directory) with the -k switch.

    [root@linux ~]# fuser -m -k -u /srv/project33/
    /srv/project33/:      3243(root)
    [1]+  Killed                  vi /srv/project33/busyfile.txt
    [root@linux ~]# fuser -m -u /srv/project33/
    [root@linux ~]#

This example shows all processes that are using the current directory
(bash and vi in this case).

    root@linux:~/test42# vi file42

    [1]+  Stopped                 vi file42
    root@linux:~/test42# fuser -v .
                         USER        PID ACCESS COMMAND
    /root/test42:        root       2909 ..c.. bash
                         root       3113 ..c.. vi

This example shows that the `vi` command actually accesses
`/usr/bin/vim.basic` as an `executable` file.

    root@linux:~/test42# fuser -v $(which vi)
                         USER        PID ACCESS COMMAND
    /usr/bin/vim.basic:  root       3113 ...e. vi

The last example shows how to find the process that is accessing a
specific file.

    [root@linux ~]# vi /srv/project33/busyfile.txt

    [1]+  Stopped                 vi /srv/project33/busyfile.txt
    [root@linux ~]# fuser -v -m /srv/project33/busyfile.txt
                         USER        PID ACCESS COMMAND
    /srv/project33/busyfile.txt:
                         root      13938 F.... vi
    [root@linux ~]# ps -fp 13938
    UID        PID  PPID  C STIME TTY          TIME CMD
    root     13938  3110  0 15:47 pts/0    00:00:00 vi /srv/project33/busyfile.txt

## chroot

The `chroot` command creates a shell with an alternate
root directory. It effectively hides anything outside of this directory.

In the example below we assume that our system refuses to start (maybe
because there is a problem with `/etc/fstab` or the mounting of the root
file system).

We start a live system (booted from cd/dvd/usb) to troubleshoot our
server. The live system will not use our main hard disk as root device

    root@livecd:~# df -h | grep root
    rootfs          186M   11M  175M   6% /
    /dev/loop0      807M  807M     0 100% /lib/live/mount/rootfs/filesystem.squashfs
    root@livecd:~# mount | grep root
    /dev/loop0 on /lib/live/mount/rootfs/filesystem.squashfs type squashfs (ro)

We create some test file on the current rootfs.

    root@livecd:~# touch /file42
    root@livecd:~# mkdir /dir42
    root@livecd:~# ls /
    bin   dir42   home        lib64  opt   run      srv  usr
    boot  etc     initrd.img  media  proc  sbin     sys  var
    dev   file42  lib         mnt    root  selinux  tmp  vmlinuz

First we mount the root file system from the disk (which is on
`lvm` so we use `/dev/mapper` instead of `/dev/sda5`).

    root@livecd:~# mount /dev/mapper/packer--debian--7-root /mnt

We are now ready to `chroot` into the rootfs on disk.

    root@livecd:~# cd /mnt
    root@livecd:/mnt# chroot /mnt
    root@livecd:/# ls /
    bin   dev   initrd.img  lost+found  opt   run      srv  usr      vmlinuz
    boot  etc   lib         media       proc  sbin     sys  vagrant
    data  home  lib64       mnt         root  selinux  tmp  var

Our test files (file42 and dir42) are not visible because they are out
of the `chrooted` environment.

Note that the `hostname` of the chrooted environment is identical to the
existing hostname.

To exit the `chrooted` file system:

    root@livecd:/# exit
    exit
    root@livecd:~# ls /
    bin   dir42   home        lib64  opt   run      srv  usr
    boot  etc     initrd.img  media  proc  sbin     sys  var
    dev   file42  lib         mnt    root  selinux  tmp  vmlinuz

## iostat

`iostat` reports IO statitics every given period of time.
It also includes a small cpu usage summary. This example shows `iostat`
running every ten seconds with `/dev/sdc` and `/dev/sde` showing a lot
of write activity.

    [root@linux ~]# iostat 10 3
    Linux 2.6.32-431.el6.x86_64 (RHEL65)  06/16/2014    _x86_64_    (1 CPU)

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
               5.81    0.00    3.15    0.18    0.00   90.85

    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    sda              42.08      1204.10      1634.88    1743708    2367530
    sdb               1.20         7.69        45.78      11134      66292
    sdc               0.92         5.30        45.82       7672      66348
    sdd               0.91         5.29        45.78       7656      66292
    sde               1.04         6.28        91.49       9100     132496
    sdf               0.70         3.40        91.46       4918     132440
    sdg               0.69         3.40        91.46       4918     132440
    dm-0            191.68      1045.78      1362.30    1514434    1972808
    dm-1             49.26       150.54       243.55     218000     352696

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
              56.11    0.00   16.83    0.10    0.00   26.95

    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    sda             257.01     10185.97        76.95     101656        768
    sdb               0.00         0.00         0.00          0          0
    sdc               3.81         1.60      2953.11         16      29472
    sdd               0.00         0.00         0.00          0          0
    sde               4.91         1.60      4813.63         16      48040
    sdf               0.00         0.00         0.00          0          0
    sdg               0.00         0.00         0.00          0          0
    dm-0            283.77     10185.97        76.95     101656        768
    dm-1              0.00         0.00         0.00          0          0

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
              67.65    0.00   31.11    0.11    0.00    1.13

    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    sda             466.86     26961.09       178.28     238336       1576
    sdb               0.00         0.00         0.00          0          0
    sdc              31.45         0.90     24997.29          8     220976
    sdd               0.00         0.00         0.00          0          0
    sde               0.34         0.00         5.43          0         48
    sdf               0.00         0.00         0.00          0          0
    sdg               0.00         0.00         0.00          0          0
    dm-0            503.62     26938.46       178.28     238136       1576
    dm-1              2.83        22.62         0.00        200          0

    [root@linux ~]#

Other options are to specify the disks you want to monitor (every 5
seconds here):

    iostat sdd sde sdf 5

Or to show statistics per partition:

    iostat -p sde -p sdf 5

## iotop

`iotop` works like the `top` command but orders processes
by input/output instead of by CPU.

By default `iotop` will show all processes. This example uses `iotop -o`
to only display processes with actual I/O.

    [root@linux ~]# iotop -o

    Total DISK READ: 8.63 M/s | Total DISK WRITE: 0.00 B/s
      TID  PRIO  USER  DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
    15000 be/4 root     2.43 M/s    0.00 B/s  0.00 % 14.60 % tar cjf /srv/di...
    25000 be/4 root     6.20 M/s    0.00 B/s  0.00 %  6.15 % tar czf /srv/di...
    24988 be/4 root     0.00 B/s    7.21 M/s  0.00 %  0.00 % gzip
    25003 be/4 root     0.00 B/s 1591.19 K/s  0.00 %  0.00 % gzip
    25004 be/4 root     0.00 B/s  193.51 K/s  0.00 %  0.00 % bzip2

Use the `-b` switch to create a log of `iotop` output (instead of the
default interactive view).

    [root@linux ~]# iotop -bod 10
    Total DISK READ: 12.82 M/s | Total DISK WRITE: 5.69 M/s
      TID  PRIO  USER  DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
    25153 be/4 root     2.05 M/s    0.00 B/s  0.00 %  7.81 % tar cjf /srv/di...
    25152 be/4 root    10.77 M/s    0.00 B/s  0.00 %  2.94 % tar czf /srv/di...
    25144 be/4 root   408.54 B/s    0.00 B/s  0.00 %  0.05 % python /usr/sbi...
    12516 be/3 root     0.00 B/s 1491.33 K/s  0.00 %  0.04 % [jbd2/sdc1-8]
    12522 be/3 root     0.00 B/s   45.48 K/s  0.00 %  0.01 % [jbd2/sde1-8]
    25158 be/4 root     0.00 B/s    0.00 B/s  0.00 %  0.00 % [flush-8:64]
    25155 be/4 root     0.00 B/s  493.12 K/s  0.00 %  0.00 % bzip2
    25156 be/4 root     0.00 B/s    2.81 M/s  0.00 %  0.00 % gzip
    25159 be/4 root     0.00 B/s  528.63 K/s  0.00 %  0.00 % [flush-8:32]

This is an example of `iotop` to track disk I/O every ten seconds for
one user named `vagrant` (and only one process of this user, but this
can be omitted). The `-a` switch accumulates I/O over time.

    [root@linux ~]# iotop -q -a -u vagrant -b -p 5216 -d 10 -n 10
    Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
      TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
     5216 be/4 vagrant       0.00 B      0.00 B  0.00 %  0.00 % gzip
    Total DISK READ: 818.22 B/s | Total DISK WRITE: 20.78 M/s
     5216 be/4 vagrant       0.00 B    213.89 M  0.00 %  0.00 % gzip
    Total DISK READ: 2045.95 B/s | Total DISK WRITE: 23.16 M/s
     5216 be/4 vagrant       0.00 B    430.70 M  0.00 %  0.00 % gzip
    Total DISK READ: 1227.50 B/s | Total DISK WRITE: 22.37 M/s
     5216 be/4 vagrant       0.00 B    642.02 M  0.00 %  0.00 % gzip
    Total DISK READ: 818.35 B/s | Total DISK WRITE: 16.44 M/s
     5216 be/4 vagrant       0.00 B    834.09 M  0.00 %  0.00 % gzip
    Total DISK READ: 6.95 M/s | Total DISK WRITE: 8.74 M/s
     5216 be/4 vagrant       0.00 B    920.69 M  0.00 %  0.00 % gzip
    Total DISK READ: 21.71 M/s | Total DISK WRITE: 11.99 M/s

## vmstat

While `vmstat` is mainly a memory monitoring tool, it is
worth mentioning here for its reporting on summary I/O data for block
devices and swap space.

This example shows some disk activity (underneath the `-----io----`
column), without swapping.

    [root@linux ~]# vmstat 5 10
    procs ----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
     r  b  swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
     0  0  5420   9092  14020 340876    7   12   235   252   77  100  2  1 98  0  0
     2  0  5420   6104  13840 338176    0    0  7401  7812  747 1887 38 12 50  0  0
     2  0  5420  10136  13696 336012    0    0 11334    14 1725 4036 76 24  0  0  0
     0  0  5420  14160  13404 341552    0    0 10161  9914 1174 1924 67 15 18  0  0
     0  0  5420  14300  13420 341564    0    0     0    16   28   18  0  0 100  0  0
     0  0  5420  14300  13420 341564    0    0     0     0   22   16  0  0 100  0  0
    ...
    [root@linux ~]#

You can benefit from `vmstat`'s ability to display memory in kilobytes,
megabytes or even kibibytes and mebibytes using -S (followed by k K m or
M).

    [root@linux ~]# vmstat -SM 5 10
    procs ----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
     r  b  swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
     0  0     5     14     11    334    0    0   259   255   79  107  2  1 97  0  0
     0  0     5     14     11    334    0    0     0     2   21   18  0  0 100  0  0
     0  0     5     15     11    334    0    0     6     0   35   31  0  0 100  0  0
     2  0     5      6     11    336    0    0 17100  7814 1378 2945 48 21 31  0  0
     2  0     5      6     11    336    0    0 13193    14 1662 3343 78 22  0  0  0
     2  0     5     13     11    330    0    0 11656  9781 1419 2642 82 18  0  0  0
     2  0     5      9     11    334    0    0 10705  2716 1504 2657 81 19  0  0  0
     1  0     5     14     11    336    0    0  6467  3788  765 1384 43  9 48  0  0
     0  0     5     14     11    336    0    0     0    13   28   24  0  0 100  0  0
     0  0     5     14     11    336    0    0     0     0   20   15  0  0 100  0  0
    [root@linux ~]#

`vmstat` is also discussed in other chapters.

