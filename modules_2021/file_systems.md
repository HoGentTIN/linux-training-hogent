# Introduction to file systems

## man fs


You need to put a **filesystem** on a partition before you can put files
and directories on it. Without a filesystem a partition is useless.

There are many **filesystems** supported in Linux, see **man fs** for a
list. The most common filesystem on Linux today is **ext4**, It is also
the default on Debian 10. Our **server2** has the **ext4** filesystem on
/dev/sda1.

    root@server2:# parted /dev/sda print
    Model: ATA (scsi)
    Disk /dev/sda: 17.2GB
    Sector size (logical/physical): 512B/512B
    Partition Table: msdos
    Disk Flags:

    Number  Start   End     Size    Type      File system     Flags
     1      1049kB  16.1GB  16.1GB  primary   ext4            boot
     2      16.1GB  17.2GB  1072MB  extended
     5      16.1GB  17.2GB  1072MB  logical   linux-swap(v1)

    root@server2:#

## /proc/filesystems


The Linux kernel supports many filesystems, but only some are compiled
in the kernel. The rest will be loaded as a module when needed. You can
see a list of currently supported filesystems in **/proc/filesystems** .

    root@server2:# grep -v nodev /proc/filesystems
            ext3
            ext2
            ext4
    root@server2:#

## ext4

Since **ext4** is the default and the most common, it is appropriate to
talk about some of its features. The **fourth extended file system** can
grow to 1 Exbibyte with file size up to 16 tebibyte with the standard
4KiB block size. It has journaling, a fast file system check, it can
have 6 billion entries in a directory, and timestamps are in
nanoseconds. See the man page for more details or visit Wikipedia here
<https://en.wikipedia.org/wiki/Ext4> .

But **ext4** is still a basic filesystem, ideal and default for the root
partition on most Linux distributions. It does not have features like a
**volume manager**, **integrity checking** and it doesn’t scale well
beyond 100 TiB.

    root@server2:# man ext4
    root@server2:#

## File Allocation Table


The **FAT** filesystem has a history since 1977, with prominence in the
DOS and Windows 95 era. It is supported by all operating systems and its
derivatives like **FAT32** and **exFAT** are still in use today.
**exFAT** notably on SDXC cards larger than 32GiB and on newer USB
sticks. There is no security on these filesystems, and files do not have
owners.

Below a screenshot on what happens when you insert an old 32GB SD card.
The **vfat** driver is loaded and **fdisk** will see a new *disk* with a
**fat32** filesystem.

    paul@MBDebian$ grep -v nodev /proc/filesystems
            ext3
            ext2
            ext4
            vfat
    paul@MBDebian$ su -
    Password:
    root@MBDebian# fdisk -l /dev/sdb
    Disk /dev/sdb: 29.9 GiB, 32094814208 bytes, 62685184 sectors
    Disk model: SD Card Reader
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x00000000

    Device     Boot Start      End  Sectors  Size Id Type
    /dev/sdb1        8192 62685183 62676992 29.9G  c W95 FAT32 (LBA)
    root@MBDebian#

The same happens when inserting a 128GB USB stick. The **vfat** driver
will handle the FAT32 filesystem on the stick.

    root@MBDebian# fdisk -l /dev/sdc | grep sdc
    Disk /dev/sdc: 114.6 GiB, 123010547712 bytes, 240254976 sectors
    /dev/sdc1          32 240254975 240254944 114.6G  c W95 FAT32 (LBA)
    root@MBDebian#

Much more information on FAT and its derivatives here
<https://en.wikipedia.org/wiki/File_Allocation_Table> and also here
<https://en.wikipedia.org/wiki/ExFAT> .

## ISO9660 and UDF


Mounting a CD-ROM will add the **ISO9660** filesystem to
**/proc/filesystems**. A CD-ROM does not show up in **fdisk** but will
get a line in **df -h**.

    root@server2:# df -hT | grep iso
    /dev/sr0       iso9660   334M  334M     0 100% /mnt
    root@server2:# grep -v nodev /proc/filesystems
            ext3
            ext2
            ext4
            iso9660
    root@server2:~#

Mounting a DVD will add the **UDF** filesystem to **/proc/filesystems**.
Similar to a CD-ROM it will show up in **df** when mounted, but not in
**fdisk**. <span class="indexterm"></span>

    oot@server2:# grep udf /proc/filesystems
            udf
    root@server2:# df -hT | grep udf
    /dev/sr0       udf       3.7G  3.7G     0 100% /mnt
    root@server2:~#

## ZFS


The **zettabyte file system** or ZFS was developed by Sun and part of
OpenSolaris in 2005. ZFS is a complete filesystem with volume manager,
redundancy, encryption, networking and much more. The problem is that
ZFS is licensed under the CDDL, which may be incompatible with the GPL
License from the Linux kernel.

We will discuss all aspects of ZFS in a separate chapter.

## mkfs.ext4


It is time now to put a filesystem on our partitions from the previous
chapter. We will start with a partition on **/dev/sdb** which uses the
MBR partition table type. Recreate these partitions if necessary.

    root@server2:# fdisk -l /dev/sdb | tail -5
    Device     Boot     Start       End   Sectors Size Id Type
    /dev/sdb1            2048  41945087  41943040  20G 83 Linux
    /dev/sdb2        41945088 125831167  83886080  40G 83 Linux
    /dev/sdb3       125831168 301989887 176158720  84G  5 Extended
    /dev/sdb5       125833216 301989887 176156672  84G 83 Linux
    root@server2:#

The **mkfs.ext4** command will create an **ext4** filesystem on the
**/dev/sdb1** partition when executing **mkfs.ext4 /dev/sdb1** . You can
see in the screenshot that more than five million 4K blocks and more
than one million **inodes** were created.

    root@server2:# mkfs.ext4 /dev/sdb1
    mke2fs 1.44.5 (15-Dec-2018)
    Creating filesystem with 5242880 4k blocks and 1310720 inodes
    Filesystem UUID: cfcbcfa8-9df4-4ecd-b24e-a6adcc42b4d3
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
            4096000

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (32768 blocks): done
    Writing superblocks and filesystem accounting information: done

    root@server2:#

You can add a lot of options when using **mkfs.ext4**. For example for
the filesystem on **/dev/sdb2** we will create far fewer **inodes**
(because we plan to only put large files on it). The **-i** option
specifies the number of bytes per inode.

    root@server2:# mkfs.ext4 -i 1024K /dev/sdb2
    mke2fs 1.44.5 (15-Dec-2018)
    Creating filesystem with 10485760 4k blocks and 40960 inodes
    Filesystem UUID: 83ae9263-bf4c-4385-9050-e556d2459382
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
            4096000, 7962624

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (65536 blocks): done
    Writing superblocks and filesystem accounting information: done

    root@server2:#

Look in the **man mkfs.ext4** for many more options. Note also that
**mkfs.ext2**, **mkfs.ext3**, and **mkfs.ext4** are all links to the
same program.

    paul@debian10:$ ls -l /sbin/mkfs.ext* 
    lrwxrwxrwx 1 root root 6 Sep 25 19:37 /sbin/mkfs.ext2 -> mke2fs
    lrwxrwxrwx 1 root root 6 Sep 25 19:37 /sbin/mkfs.ext3 -> mke2fs
    lrwxrwxrwx 1 root root 6 Sep 25 19:37 /sbin/mkfs.ext4 -> mke2fs
    paul@debian10:$

## tune2fs


With **tune2fs** you can list properties and options of existing file
systems. For example if we want to know how many blocks are reserved for
the root user, then we execute **tune2fs -l** on the device and grep for
our property.

    root@server2:# tune2fs -l /dev/sdb2 | grep 'Reserved block '
    Reserved block count:     524288
    root@server2:#

We can change this with **tune2fs** to zero, as is shown in this
screenshot.

    root@server2:# tune2fs -m 0 /dev/sdb2
    tune2fs 1.44.5 (15-Dec-2018)
    Setting reserved blocks percentage to 0% (0 blocks)
    root@server2:# tune2fs -l /dev/sdb2 | grep 'Reserved block '
    Reserved block count:     0
    root@server2:~#

## resize2fs

In later chapters we will see how a block device can grow in size while
the filesystem is in use. When this happens then we also need to resize
the **ext4** filesystem to match the size of the block device. This is
done with **resize2fs**.

    root@server2:# resize2fs /dev/md2
    resize2fs 1.44.5 (15-Dec-2018)
    Filesystem at /dev/md2 is mounted on /srv/pro42; on-line resizing required
    old_desc_blocks = 1, new_desc_blocks = 1
    The filesystem on /dev/md2 is now 523264 (4k) blocks long.

    root@server2:#

## fsck


The computer will from time to time do an automated **fsck** or **file
system check**, so this is not a common task. But you can initiate a
**file system check** manually using the **fsck /device** command shown
in this screenshot.

    root@server2:# fsck /dev/sdb2
    fsck from util-linux 2.33.1
    e2fsck 1.44.5 (15-Dec-2018)
    /dev/sdb2: clean, 11/40960 files, 81102/10485760 blocks
    root@server2:#

## Cheat sheet

<table>
<caption>File systems</caption>
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
<td style="text-align: left;"><p>man fs</p></td>
<td style="text-align: left;"><p>Information about file
systems.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>parted /dev/foo print</p></td>
<td style="text-align: left;"><p>Partition and file system information
for <strong>/dev/foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>fdisk -l /dev/foo</p></td>
<td style="text-align: left;"><p>Partition information for
<strong>/dev/foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cat /proc/filesystems</p></td>
<td style="text-align: left;"><p>All kernel loaded file
systems.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mkfs.ext2</p></td>
<td style="text-align: left;"><p>Create (make) an ext2 file
system.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>mkfs.ext3</p></td>
<td style="text-align: left;"><p>Create (make) an ext3 file
system.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mkfs.ext4</p></td>
<td style="text-align: left;"><p>Create (make) an ext4 file
system.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tune2fs</p></td>
<td style="text-align: left;"><p>Adjust parameters of an ext2/3/4 file
system.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>resize2fs</p></td>
<td style="text-align: left;"><p>Resize an ext2/3/4 file
system.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>fsck</p></td>
<td style="text-align: left;"><p>Run a file system check.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ext4</p></td>
<td style="text-align: left;"><p>Default and most common file system on
Debian Linux.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>iso9660</p></td>
<td style="text-align: left;"><p>CD-ROM file system.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>udf</p></td>
<td style="text-align: left;"><p>DVD file system.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zfs</p></td>
<td style="text-align: left;"><p>Zettabyte File System (has its own
chapter).</p></td>
</tr>
</tbody>
</table>

File systems

## Practice

1.  Open **man fs** and have a brief look at the filesystems mentioned.

2.  Put an **ext4** filesystem on /dev/sdb1 (replace sdb with your first
    extra disk).

3.  Verify your work with **fdisk** and with **lsblk** .

4.  Also create an **ext4** on /dev/sdb2, with 0% reserved blocks for
    the root user.

5.  Verify the reserved blocks with **tune2fs**.

6.  Do a filesystem check on /dev/sdb2 .

7.  Do the same exercises on a GPT label on /dev/sdd.

## Solution

1.  Open **man fs** and have a brief look at the filesystems mentioned.

        man fs

2.  Put an **ext4** filesystem on /dev/sdb1 (replace sdb with your first
    extra disk).

        mkfs.ext4 /dev/sdb1

3.  Verify your work with **fdisk** and with **lsblk** .

        fdisk -l /dev/sdb
        lsblk -f /dev/sdb

4.  Also create an **ext4** on /dev/sdb2, with 0% reserved blocks for
    the root user.

        mkfs.ext4 -m 0 /dev/sdb2

5.  Verify the reserved blocks with **tune2fs**.

        tune2fs -l /dev/sdb2

6.  Do a filesystem check on /dev/sdb2 .

        fsck /dev/sdb2

7.  Do the same exercises on a GPT label on /dev/sdd.

        fdisk /dev/sdd
        mkfs.ext4 /dev/sdd1
        mkfs.ext4 -m 0 /dev/sdd2
        lsblk -f /dev/sdd
        fdisk -l /dev/sdd
        tune2fs -l /dev/sdd2
