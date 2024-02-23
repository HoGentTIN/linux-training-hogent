## solution: partitions

1\. Use `fdisk -l` to display existing partitions and sizes.

    as root: # fdisk -l

2\. Use `df -h` to display existing partitions and sizes.

    df -h

3\. Compare the output of `fdisk` and `df`.

    Some partitions will be listed in both outputs (maybe /dev/sda1 or /dev/hda1).

4\. Create a 200MB primary partition on a small disk.

    Choose one of the disks you added (this example uses /dev/sdc).
    root@linux ~# fdisk /dev/sdc
    ...
    Command (m for help): n
    Command action
       e   extended
       p   primary partition (1-4)
    p
    Partition number (1-4): 1
    First cylinder (1-261, default 1): 1
    Last cylinder or +size or +sizeM or +sizeK (1-261, default 261): +200m
    Command (m for help): w
    The partition table has been altered!
    Calling ioctl() to re-read partition table.
    Syncing disks.

5\. Create a 400MB primary partition and two 300MB logical drives on a
big disk.

    Choose one of the disks you added (this example uses /dev/sdb)

    fdisk /dev/sdb

    inside fdisk : n p 1 +400m enter --- n e 2 enter enter --- n l +300m (twice)

6\. Use `df -h` and `fdisk -l` to verify your work.

    fdisk -l ; df -h

7\. Compare the output again of `fdisk` and `df`. Do both commands
display the new partitions ?

    The newly created partitions are visible with fdisk.

    But they are not displayed by df.

8\. Create a backup with `dd` of the `mbr` that contains your 200MB
primary partition.

    dd if=/dev/sdc of=bootsector.sdc.dd count=1 bs=512

9\. Take a backup of the `partition table` containing your 400MB primary
and 300MB logical drives. Make sure the logical drives are in the
backup.

    sfdisk -d /dev/sdb > parttable.sdb.sfdisk

