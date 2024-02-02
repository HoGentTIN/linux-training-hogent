## practice: hard disk devices

`About this lab:` To practice working with hard disks, you will need
some hard disks. When there are no physical hard disk available, you can
use virtual disks in `vmware` or `VirtualBox`. The teacher will help you
in attaching a couple of ATA and/or SCSI disks to a virtual machine. The
results of this lab can be used in the next three labs (partitions, file
systems, mounting).

It is adviced to attach three 1GB disks and three 2GB disks to the
virtual machine. This will allow for some freedom in the practices of
this chapter as well as the next chapters (raid, lvm, iSCSI).

1\. Use `dmesg` to make a list of hard disk devices detected at boot-up.

2\. Use `fdisk` to find the total size of all hard disk devices on your
system.

3\. Stop a virtual machine, add three virtual 1 gigabyte `scsi` hard
disk devices and one virtual 400 megabyte `ide` hard disk device. If
possible, also add another virtual 400 megabyte `ide` disk.

4\. Use `dmesg` to verify that all the new disks are properly detected
at boot-up.

5\. Verify that you can see the disk devices in `/dev`.

6\. Use `fdisk` (with `grep` and `/dev/null`) to display the total size
of the new disks.

7\. Use `badblocks` to completely erase one of the smaller hard disks.

8\. Look at `/proc/scsi/scsi`.

9\. If possible, install `lsscsi`, `lshw` and use them to list the
disks.
