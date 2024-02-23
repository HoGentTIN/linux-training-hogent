## vol_id (legacy)

Older versions of Linux have a `vol_id` utility to display
the `uuid` of a file system.

    root@linux:~# vol_id --uuid /dev/sda1
    193c3c9b-2c40-9290-8b71-4264ee4d4c82

Red Hat Enterprise Linux 5 puts `vol_id` in `/lib/udev/vol_id`, which is
not in the \$PATH. The syntax is also a bit different from
Debian/Ubuntu/Mint.

    root@linux ~# /lib/udev/vol_id -u /dev/hda1
    48a6a316-9ca9-4214-b5c6-e7b33a77e860

This utility is not available in standard installations of RHEL6/7 or
Debian6/7/8.

## lsblk -f

You can quickly locate the `uuid` of file systems with `lsblk -f`. This
is a screenshot from a Macbook Pro Retina with Debian 8.

    root@linux:~# lsblk -f
    lsblk: sdb2: unknown device name
    NAME   FSTYPE  LABEL        UUID                                 MOUNTPOINT
    sda
    ├─sda1 vfat    EFI          67E3-17ED                            /boot/efi
    ├─sda2 hfsplus Macintosh HD de87321a-95e3-3b5b-9bc4-855c173d8337
    ├─sda3 hfsplus Recovery HD  3ddc4f86-4e26-308e-a52c-0216318ab73e
    ├─sda4 hfsplus Recovery HD  672f06bd-5e13-3f62-995b-c5e3dc5ee19e
    └─sda5 ext4                 5361cc68-746e-4800-8e6c-108d0054b6f0 /
    sdb
    └─sdb1
    root@linux:~#

The same command will also work on recent RHEL and CentOS servers.

    [root@linux ~]# lsblk -f /dev/sdf
    NAME          FSTYPE   LABEL UUID                                   MOUNTPOINT
    sdf
    ├─sdf1        xfs            0697ab0c-5c99-4c80-880f-10bb0f9aa948   /boot
    └─sdf2        LVM2_mem       ZWr0TY-W0qX-Uwva-qMT1-Nkhp-RsXU-HDUIil
      ├─c...-swap swap           14c9d978-f547-4e18-91e2-a2ab140fe82c   [SWAP]
      └─c...-root xfs            fd931dbd-cdea-41e8-9943-1d9668d39857   /
    [root@linux ~]#

## tune2fs

Use `tune2fs` to find the `uuid` of a file system.

    [root@linux ~]# tune2fs -l /dev/sda1 | grep UUID
    Filesystem UUID:          11cfc8bc-07c0-4c3f-9f64-78422ef1dd5c
    [root@linux ~]# /lib/udev/vol_id -u /dev/sda1
    11cfc8bc-07c0-4c3f-9f64-78422ef1dd5c

## uuid

There is more information in the manual of `uuid`, a tool that can
generate uuid\'s.

    [root@linux ~]# yum install uuid
    (output truncated)
    [root@linux ~]# man uuid

## uuid in /etc/fstab

You can use the `uuid` to make sure that a volume is universally
uniquely identified in `/etc/fstab`. The device name can change
depending on the disk devices that are present at boot time, but a
`uuid` never changes.

First we use `tune2fs` to find the `uuid`.

    [root@linux ~]# tune2fs -l /dev/sdc1 | grep UUID
    Filesystem UUID:          7626d73a-2bb6-4937-90ca-e451025d64e8

Then we check that it is properly added to `/etc/fstab`,
the `uuid` replaces the variable devicename /dev/sdc1.

    [root@linux ~]# grep UUID /etc/fstab 
    UUID=7626d73a-2bb6-4937-90ca-e451025d64e8 /home/pro42 ext3 defaults 0 0

Now we can mount the volume using the mount point defined in
`/etc/fstab`.

    [root@linux ~]# mount /home/pro42
    [root@linux ~]# df -h | grep 42
    /dev/sdc1             397M   11M  366M   3% /home/pro42

The real test now, is to remove `/dev/sdb` from the
system, reboot the machine and see what happens. After the reboot, the
disk previously known as `/dev/sdc` is now `/dev/sdb`.

    [root@linux ~]# tune2fs -l /dev/sdb1 | grep UUID
    Filesystem UUID:          7626d73a-2bb6-4937-90ca-e451025d64e8

And thanks to the `uuid` in `/etc/fstab`, the mountpoint is mounted on
the same disk as before.

    [root@linux ~]# df -h | grep sdb
    /dev/sdb1             397M   11M  366M   3% /home/pro42

## uuid as a boot device

Recent Linux distributions (Debian, Ubuntu, \...) use `grub` with a
`uuid` to identify the root file system.

This example shows how a `root=/dev/sda1` is replaced with a `uuid`.

    title           Ubuntu 9.10, kernel 2.6.31-19-generic
    uuid            f001ba5d-9077-422a-9634-8d23d57e782a
    kernel          /boot/vmlinuz-2.6.31-19-generic \
    root=UUID=f001ba5d-9077-422a-9634-8d23d57e782a ro quiet splash 
    initrd          /boot/initrd.img-2.6.31-19-generic

The screenshot above contains only four lines. The line starting with
`root=` is the continuation of the `kernel` line.

RHEL and CentOS boot from LVM after a default install.

