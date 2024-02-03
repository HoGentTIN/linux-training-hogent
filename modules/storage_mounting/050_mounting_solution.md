## solution: mounting file systems

1\. Mount the small 200MB partition on /home/project22.

    mkdir /home/project22
    mount /dev/sdc1 /home/project22

2\. Mount the big 400MB primary partition on /mnt, then copy some files
to it (everything in /etc). Then umount, and mount the file system as
read only on /srv/nfs/salesnumbers. Where are the files you copied ?

    mount /dev/sdb1 /mnt
    cp -r /etc /mnt
    ls -l /mnt

    umount /mnt
    ls -l /mnt

    mkdir -p /srv/nfs/salesnumbers
    mount /dev/sdb1 /srv/nfs/salesnumbers

    You see the files in /srv/nfs/salenumbers now...

    But physically they are on ext3 on partition /dev/sdb1

3\. Verify your work with `fdisk`, `df` and `mount`. Also look in
`/etc/mtab` and `/proc/mounts`.

    fdisk -l
    df -h
    mount

    All three the above commands should show your mounted partitions.

    grep project22 /etc/mtab
    grep project22 /proc/mounts

4\. Make both mounts permanent, test that it works.

    add the following lines to /etc/fstab

    /dev/sdc1 /home/project22 auto defaults 0 0
    /dev/sdb1 /srv/nfs/salesnumbers auto defaults 0 0

5\. What happens when you mount a file system on a directory that
contains some files ?

    The files are hidden until umount.

6\. What happens when you mount two file systems on the same mount point
?

    Only the last mounted fs is visible.

7\. (optional) Describe the difference between these commands: find,
locate, updatedb, makewhatis, whereis, apropos, which and type.

    man find
    man locate
    ...

8\. (optional) Perform a file system check on the partition mounted at
/srv/nfs/salesnumbers.

    # umount /srv/nfs/salesnumbers (optional but recommended)
    # fsck /dev/sdb1

