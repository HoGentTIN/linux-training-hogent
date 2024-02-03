## raid levels

### raid 0

`raid 0` uses two or more disks, and is often called
`striping` (or stripe set, or striped volume). Data is
divided in `chunks`, those chunks are evenly spread across every disk in
the array. The main advantage of `raid 0` is that you can create
`larger drives`. `raid 0` is the only `raid` without redundancy.

### jbod

`jbod` uses two or more disks, and is often called
`concatenating` (spanning, spanned set, or spanned volume). Data is
written to the first disk, until it is full. Then data is written to the
second disk\... The main advantage of `jbod` (Just a Bunch of Disks) is
that you can create `larger drives`. JBOD offers no redundancy.

### raid 1

`raid 1` uses exactly two disks, and is often called
`mirroring` (or mirror set, or mirrored volume). All data
written to the array is written on each disk. The main advantage of raid
1 is `redundancy`. The main disadvantage is that you lose
at least half of your available disk space (in other words, you at least
double the cost).

### raid 2, 3 and 4 ?

`raid 2` uses bit level striping, `raid 3` byte level, and `raid 4` is
the same as `raid 5`, but with a dedicated parity disk. This is actually
slower than `raid 5`, because every write would have to write parity to
this one (bottleneck) disk. It is unlikely that you will ever see these
`raid` levels in production.

### raid 5

`raid 5` uses `three` or more disks, each divided into chunks. Every
time chunks are written to the array, one of the disks will receive a
`parity` chunk. Unlike `raid 4`, the parity chunk will
alternate between all disks. The main advantage of this is that `raid 5`
will allow for full data recovery in case of `one` hard disk failure.

### raid 6

`raid 6` is very similar to `raid 5`, but uses two parity chunks.
`raid 6` protects against two hard disk failures. Oracle Solaris `zfs`
calls this `raidz2` (and also had `raidz3` with triple parity).

### raid 0+1

`raid 0+1` is a mirror(1) of stripes(0). This means you first create two
`raid 0 stripe` sets, and then you set them up as a mirror set. For
example, when you have six 100GB disks, then the stripe sets are each
300GB. Combined in a mirror, this makes 300GB total. `raid 0+1` will
survive one disk failure. It will only survive the second disk failure
if this disk is in the same stripe set as the previous failed disk.

### raid 1+0

`raid 1+0` is a stripe(0) of mirrors(1). For example, when you have six
100GB disks, then you first create three mirrors of 100GB each. You then
stripe them together into a 300GB drive. In this example, as long as not
all disks in the same mirror fail, it can survive up to three hard disk
failures.

### raid 50

`raid 5+0` is a stripe(0) of `raid 5` arrays. Suppose you have nine
disks of 100GB, then you can create three `raid 5` arrays of 200GB each.
You can then combine them into one large stripe set.

### many others

There are many other nested `raid` combinations, like `raid` 30, 51, 60,
100, 150, \...

## building a software raid5 array

### do we have three disks?

First, you have to attach some disks to your computer. In this scenario,
three brand new disks of eight gigabyte each are added. Check with
`fdisk -l` that they are connected.

    [root@rhel6c ~]# fdisk -l 2> /dev/null | grep MB
    Disk /dev/sdb: 8589 MB, 8589934592 bytes
    Disk /dev/sdc: 8589 MB, 8589934592 bytes
    Disk /dev/sdd: 8589 MB, 8589934592 bytes

### fd partition type

The next step is to create a partition of type `fd` on
every disk. The `fd` type is to set the partition as
`Linux RAID autodetect`. See this (truncated) screenshot:

    [root@rhel6c ~]# fdisk /dev/sdd
    ...
    Command (m for help): n
    Command action
       e   extended
       p   primary partition (1-4)
    p
    Partition number (1-4): 1
    First cylinder (1-1044, default 1): 
    Using default value 1
    Last cylinder, +cylinders or +size{K,M,G} (1-1044, default 1044): 
    Using default value 1044

    Command (m for help): t
    Selected partition 1
    Hex code (type L to list codes): fd
    Changed system type of partition 1 to fd (Linux raid autodetect)

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.
    Syncing disks.

### verify all three partitions

Now all three disks are ready for `raid 5`, so we have to tell the
system what to do with these disks.

    [root@rhel6c ~]# fdisk -l 2> /dev/null | grep raid
    /dev/sdb1       1        1044     8385898+  fd  Linux raid autodetect
    /dev/sdc1       1        1044     8385898+  fd  Linux raid autodetect
    /dev/sdd1       1        1044     8385898+  fd  Linux raid autodetect

### create the raid5

The next step used to be *create the `raid table` in
`/etc/raidtab`*. Nowadays, you can just issue the command
`mdadm` with the correct parameters.

The command below is split on two lines to fit this print, but you
should type it on one line, without the backslash (\\).

    [root@rhel6c ~]# mdadm --create /dev/md0 --chunk=64 --level=5 --raid-\
    devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.

Below a partial screenshot how fdisk -l sees the `raid 5`.

    [root@rhel6c ~]# fdisk -l /dev/md0

    Disk /dev/md0: 17.2 GB, 17172135936 bytes
    2 heads, 4 sectors/track, 4192416 cylinders
    Units = cylinders of 8 * 512 = 4096 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 65536 bytes / 131072 bytes
    Disk identifier: 0x00000000

    Disk /dev/md0 doesn't contain a valid partition table

We could use this software `raid 5` array in the next topic: `lvm`.

### /proc/mdstat

The status of the raid devices can be seen in
`/proc/mdstat`. This example shows a `raid 5` in the
process of rebuilding.

    [root@rhel6c ~]# cat /proc/mdstat 
    Personalities : [raid6] [raid5] [raid4] 
    md0 : active raid5 sdd1[3] sdc1[1] sdb1[0]
          16769664 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/2] [UU_]
          [============>........]  recovery = 62.8% (5266176/8384832) finish=0\
    .3min speed=139200K/sec

This example shows an active software `raid 5`.

    [root@rhel6c ~]# cat /proc/mdstat 
    Personalities : [raid6] [raid5] [raid4] 
    md0 : active raid5 sdd1[3] sdc1[1] sdb1[0]
        16769664 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

### mdadm \--detail

Use `mdadm --detail` to get information on a raid device.

    [root@rhel6c ~]# mdadm --detail /dev/md0
    /dev/md0:
            Version : 1.2
      Creation Time : Sun Jul 17 13:48:41 2011
         Raid Level : raid5
         Array Size : 16769664 (15.99 GiB 17.17 GB)
      Used Dev Size : 8384832 (8.00 GiB 8.59 GB)
       Raid Devices : 3
      Total Devices : 3
        Persistence : Superblock is persistent

        Update Time : Sun Jul 17 13:49:43 2011
              State : clean
     Active Devices : 3
    Working Devices : 3
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 64K

               Name : rhel6c:0  (local to host rhel6c)
               UUID : c10fd9c3:08f9a25f:be913027:999c8e1f
             Events : 18

        Number   Major   Minor   RaidDevice State
           0       8       17        0      active sync   /dev/sdb1
           1       8       33        1      active sync   /dev/sdc1
           3       8       49        2      active sync   /dev/sdd1

### removing a software raid

The software raid is visible in `/proc/mdstat` when active. To remove
the raid completely so you can use the disks for other purposes, you
stop (de-activate) it with `mdadm`.

    [root@rhel6c ~]# mdadm --stop /dev/md0
    mdadm: stopped /dev/md0

The disks can now be repartitioned.

### further reading

Take a look at the man page of `mdadm` for more information. Below an
example command to add a new partition while removing a faulty one.

    mdadm /dev/md0 --add /dev/sdd1 --fail /dev/sdb1 --remove /dev/sdb1

