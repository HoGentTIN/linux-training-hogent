## about file systems

A file system is a way of organizing files on your partition. Besides
file-based storage, file systems usually include
*directories* and *access control*, and contain meta
information about files like access times, modification times and file
ownership.

The properties (length, character set, \...) of filenames are determined
by the file system you choose. Directories are usually implemented as
files, you will have to learn how this is implemented! Access control in
file systems is tracked by user ownership (and group owner- and
membership) in combination with one or more access control lists.

### man fs

The manual page about `filesystems(5)` is accessed by typing `man fs`.

### /proc/filesystems

The Linux kernel will inform you about currently loaded file system drivers in `/proc/filesystems`.

```console
student@linux ~$ cat /proc/filesystems  | grep -v nodev
    ext2
    iso9660
    ext3
```

### /etc/filesystems

The `/etc/filesystems` file contains a list of autodetected filesystems(in case the `mount` command is used without the `-t` option).

Help for this file is provided in the `mount(8)` man page.

## common file systems

### ext2, ext3 and ext4

Once the most common Linux file systems is the `ext2` (the second extended) file system. A disadvantage is that file system checks on ext2 can take a long time.

`ext2` and `ext3` have been replaced by `ext4` on most Linux machines. They are essentially the same, except for the *journaling* which is only present in ext3.

Journaling means that changes are first written to a journal on the disk. The journal is flushed regularly, writing the changes in the file system. Journaling keeps the file system in a consistent state, so you don't need a file system check after an unclean shutdown or power failure.

### creating ext2/3/4

You can create these file systems with the `/sbin/mkfs` or `/sbin/mke2fs` commands. Use `mke2fs -t ext3` (or `ext4`) to create an `ext3` (or `ext4`) file system.

You can convert an `ext2` to `ext3` with `tune2fs -j`. You can mount an `ext3` file system as `ext2`, but then you lose the journaling. Do not forget to run `mkinitrd` if you are booting from this device.

### ext4

The newest incarnation of the ext file system is named `ext4` and is available in the Linux kernel since 2008. `ext4` supports larger files (up to 16 terabyte) and larger file systems than `ext3` (and many more features).

Development started by making `ext3` fully capable for 64-bit. When it turned out the changes were significant, the developers decided to name it `ext4`.

### xfs

Enterprise Linux starting with major version 7 have `XFS` as the default file system. This is a highly scalable high-performance file system.

`xfs` was created for *Irix* (a discontinued UNIX based operating system developed by Silicon Graphics) and for a couple of years it was also used in *FreeBSD*. It is supported by the Linux kernel, but rarely used in distributions outside of the Enterprise Linux realm.

### vfat

The `vfat` file system exists in a couple of forms: `fat12` for floppy disks, `fat16` on `ms-dos`, and `fat32` for larger disks. The Linux `vfat` implementation supports all of these, but vfat lacks a lot of features like security and links. `fat` disks can be read by every operating system, and were used a lot for digital cameras, `usb` sticks and to exchange data between different OS'ses on a home user's computer.

### ntfs

The `ntfs` file system is the default file system for Windows computers since Windows NT . Linux also has support for reading and formatting NTFS file systems. Install the `ntfs-3g` package (and `ntfsprogs` on EL) to enable support.

### iso 9660

`iso9660` is the standard format for cd-roms. Chances are you will encounter this file system also when you download bootable installation media for Linux distributions in the form of images of cd-roms (often with the `.iso` extension). These can also be copied to a usb stick (e.g. with the `dd` command) and booted from there.

The `iso9660` standard limits filenames to the 8.3 format typical for ms-dos, i.e. the filename has at most 8 ASCII-characters and the filename extension at most 3. The Unix world didn't like this, and thus added the *rock ridge* extensions, which allows for filenames up to 255 characters and Unix-style file-modes, ownership and symbolic links. Another extensions to `iso9660` is `joliet`, which adds 64 unicode characters to the filename. The *el torito* standard extends `iso9660` to be able to boot from cd-rom's.

### udf

Most optical media today (including cd's and dvd's) use `udf`, the Universal Disk Format.

### swap

All things considered, swap is not a file system. But to use a partition as a *swap partition* it must be formatted and mounted as swap space.

### gfs

Linux clusters often use a dedicated cluster filesystem like GFS, GFS2,
ClusterFS, ...

### and more...

On older Linux systems, you may encounter the `reiserfs` file system. It was the default for SuSE Linux in the early 2000's until they moved to `ext3`. ReiserFS is no longer maintained and will disappear from the Linux kernel (scheduled in 2025).

Maybe you will see Sun's `zfs` that has some impressive features that position it as a "next generation" file system when compared with `ext4` and the likes, e.g. snapshots and cloning, integrated RAID and volume management, data integrity (also called copy-on-write, which has as consequence that a file system check is never needed), transparent encryption, deduplication. It's not supported out-of-the-box on Linux due to incompatible licenses, but there are ways to use it. On BSD-based systems (e.g. FreeBSD, FreeNAS), `zfs` is much more common.

More recently, the `btrfs` (pronounced *butter fs* or *better fs*) made `zfs`-like features more accessible to Linux. It is being developed under the GPL license by several companies, including Oracle, Red Hat, and SUSE. It is the default file system for SUSE Linux Enterprise Server since version 12 (released in 2015) and Fedora Desktop since version 33 (released in 2020). Features include automatic repair, automatic defragmentation, transparent compression, deduplication, resizing, volume management, subvolumes, etc.

The following example comes from a Fedora system (with an NVMe SSD as hard drive) where the root directory `/` and `/home` are `btrfs` subvolumes on the same partition (`/dev/nvme1n1p4`):

```console
[student@fedora ~] mount | grep nvme
/dev/nvme1n1p4 on / type btrfs (rw,relatime,seclabel,compress=zstd:1,ssd,discard=async,space_cache=v2,subvolid=257,subvol=/root)
/dev/nvme1n1p4 on /home type btrfs (rw,relatime,seclabel,compress=zstd:1,ssd,discard=async,space_cache=v2,subvolid=256,subvol=/home)
/dev/nvme1n1p3 on /boot type ext4 (rw,relatime,seclabel)
/dev/nvme1n1p1 on /boot/efi type vfat (rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=ascii,shortname=winnt,errors=remount-ro)
```

Remark that the options show a.o. that transparent file compression is enabled and that `btrfs` is aware that the hard disk is an SSD.

What's cool about this setup is that you don't have to think about choosing how much space you allocate to `/` and `/home` when you install the system. Both subvolumes share the same space on the partition, and they will take the space they need.

```console
[student@fedora ~] df -h | grep nvme
/dev/nvme1n1p4  748G  264G  479G  36% /
/dev/nvme1n1p4  748G  264G  479G  36% /home
/dev/nvme1n1p3  974M  476M  432M  53% /boot
/dev/nvme1n1p1  511M   56M  456M  11% /boot/efi
```

### /proc/filesystems

The `/proc/filesystems` file displays a list of supported file systems. When you mount a file system without explicitly defining one, then mount will first try to probe `/etc/filesystems` and then probe `/proc/filesystems` for all the filesystems without the `nodev` label. If `/etc/filesystems` ends with a line containing only an asterisk (`*`) then both files are probed.

```console
student@linux:~$ cat /proc/filesystems 
nodev   sysfs
nodev   rootfs
nodev   bdev
nodev   proc
nodev   sockfs
nodev   binfmt_misc
nodev   usbfs
nodev   usbdevfs
nodev   futexfs
nodev   tmpfs
nodev   pipefs
nodev   eventpollfs
nodev   devpts
        ext2
nodev   ramfs
nodev   hugetlbfs
        iso9660
nodev   relayfs
nodev   mqueue
nodev   selinuxfs
        ext3
nodev   rpc_pipefs
nodev   vmware-hgfs
nodev   autofs
```

## putting a file system on a partition

We now have a fresh partition. The system binaries to make file systems can be found with ls.

```console
student@linux ~$ ls -lS /sbin/mk*
-rwxr-xr-x  3 root root 34832 Apr 24  2006 /sbin/mke2fs
-rwxr-xr-x  3 root root 34832 Apr 24  2006 /sbin/mkfs.ext2
-rwxr-xr-x  3 root root 34832 Apr 24  2006 /sbin/mkfs.ext3
-rwxr-xr-x  3 root root 28484 Oct 13  2004 /sbin/mkdosfs
-rwxr-xr-x  3 root root 28484 Oct 13  2004 /sbin/mkfs.msdos
-rwxr-xr-x  3 root root 28484 Oct 13  2004 /sbin/mkfs.vfat
-rwxr-xr-x  1 root root 20313 Apr 10  2006 /sbin/mkinitrd
-rwxr-x---  1 root root 15444 Oct  5  2004 /sbin/mkzonedb
-rwxr-xr-x  1 root root 15300 May 24  2006 /sbin/mkfs.cramfs
-rwxr-xr-x  1 root root 13036 May 24  2006 /sbin/mkswap
-rwxr-xr-x  1 root root  6912 May 24  2006 /sbin/mkfs
-rwxr-xr-x  1 root root  5905 Aug  3  2004 /sbin/mkbootdisk
```

It is time for you to read the manual pages of `mkfs` and `mke2fs`. In the example below, you see the creation of an `ext2` file system on `/dev/sdb1`. In real life, you might want to use options like `-m0` and `-j`.

```console
student@linux:~$ sudo mke2fs /dev/sdb1
mke2fs 1.35 (28-Feb-2004)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
28112 inodes, 112420 blocks
5621 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=67371008
14 block groups
8192 blocks per group, 8192 fragments per group
2008 inodes per group
Superblock backups stored on blocks: 
8193, 24577, 40961, 57345, 73729

Writing inode tables: done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 37 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
```

## tuning a file system

You can use `tune2fs` to list and set file system settings. The first screenshot lists the reserved space for root (which is set at five percent).

```console
student@linux ~$ sudo tune2fs -l /dev/sda1 | grep -i "block count"
Block count:              104388
Reserved block count:     5219
```

This example changes this value to ten percent. You can use tune2fs while the file system is active, even if it is the root file system (as in this example).

```console
student@linux ~$ sudo tune2fs -m10 /dev/sda1 
tune2fs 1.35 (28-Feb-2004)
Setting reserved blocks percentage to 10 (10430 blocks)
student@linux ~$ sudo tune2fs -l /dev/sda1 | grep -i "block count"
Block count:              104388
Reserved block count:     10430
```

## checking a file system

The `fsck` command is a front end tool used to check a file system for errors.

```console
student@linux ~$ ls /sbin/*fsck*
/sbin/dosfsck  /sbin/fsck         /sbin/fsck.ext2  /sbin/fsck.msdos
/sbin/e2fsck   /sbin/fsck.cramfs  /sbin/fsck.ext3  /sbin/fsck.vfat
```

The last column in `/etc/fstab` is used to determine whether a file system should be checked at boot-up.

```console
[student@linux ~]$ grep ext /etc/fstab 
/dev/VolGroup00/LogVol00   /             ext3    defaults        1 1
LABEL=/boot                /boot         ext3    defaults        1 2
```

A value of `0` means don't check, a higher number determines the order. The root filesystem should have `1` and other filesystems should have `2`.

Manually checking a mounted file system results in a warning from `fsck`.

```console
student@linux ~$ sudo fsck /boot
fsck 1.35 (28-Feb-2004)
e2fsck 1.35 (28-Feb-2004)
/dev/sda1 is mounted.  

WARNING!!!  Running e2fsck on a mounted filesystem may cause
SEVERE filesystem damage.

Do you really want to continue (y/n)? no

check aborted.
```

But after unmounting fsck and `e2fsck` can be used to check an ext2 file system.

```console
student@linux ~$ sudo fsck  /boot
fsck 1.35 (28-Feb-2004)
e2fsck 1.35 (28-Feb-2004)
/boot: clean, 44/26104 files, 17598/104388 blocks
student@linux ~$ sudo fsck -p /boot
fsck 1.35 (28-Feb-2004)
/boot: clean, 44/26104 files, 17598/104388 blocks
student@linux ~$ sudo e2fsck -p /dev/sda1
/boot: clean, 44/26104 files, 17598/104388 blocks
```

