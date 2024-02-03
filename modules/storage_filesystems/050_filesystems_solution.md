## solution: file systems

1\. List the filesystems that are known by your system.

    man fs

    cat /proc/filesystems

    cat /etc/filesystems (not on all Linux distributions)

2\. Create an `ext2` filesystem on the 200MB partition.

    mke2fs /dev/sdc1 (replace sdc1 with the correct partition)

3\. Create an `ext3` filesystem on one of the 300MB logical drives.

    mke2fs -j /dev/sdb5 (replace sdb5 with the correct partition)

4\. Create an `ext4` on the 400MB partition.

    mkfs.ext4 /dev/sdb1 (replace sdb1 with the correct partition)

5\. Set the reserved space for root on the ext3 filesystem to 0 percent.

    tune2fs -m 0 /dev/sdb5

6\. Verify your work with `fdisk` and `df`.

    mkfs (mke2fs) makes no difference in the output of these commands

    The big change is in the next topic: mounting

7\. Perform a file system check on all the new file systems.

    fsck /dev/sdb1
    fsck /dev/sdc1
    fsck /dev/sdb5

