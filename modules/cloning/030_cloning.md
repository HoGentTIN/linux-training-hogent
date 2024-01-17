# About cloning

You can have distinct goals for cloning a server. For instance a clone
can be a cold iron backup system used for manual disaster recovery of a
service. Or a clone can be created to serve in a test environment. Or
you might want to make an almost identical server. Let\'s take a look at
some offline and online ways to create a clone of a Linux server.

# About offline cloning

The term offline cloning is used when you power off the running Linux
server to create the clone. This method is easy since we don\'t have to
consider open files and we don\'t have to skip virtual file systems like
`/dev` or `/sys` . The offline cloning method can be broken down into
these steps:

    1. Boot source and target server with a bootable CD
    2. Partition, format and mount volumes on the target server
    3. Copy files/partitions from source to target over the network
        

The first step is trivial. The second step is explained in the Disk
Management chapter. For the third step, you can use a combination of
`ssh` or `netcat` with `cp`, `dd`, `dump` and `restore`, `tar`, `cpio`,
`rsync` or even `cat`.

# Offline cloning example

We have a working Red Hat Enterprise Linux 5 server, and we want a
perfect copy of it on newer hardware. First thing to do is discover the
disk layout.

    [root@RHEL5 ~]# df -h 
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/sda2              15G  4.5G  9.3G  33% /
    /dev/sda1              99M   31M   64M  33% /boot

The `/boot` partition is small but big enough. If we create an identical
partition, then `dd` should be a good cloning option. Suppose the `/`
partition needs to be enlarged on the target system. The best option
then is to use a combination of `dump` and `restore`. Remember that dd
copies blocks, whereas dump/restore copies files.

The first step to do is to boot the target server with a live CD and
partition the target disk. To do this we use the Red Hat Enterprise
Linux 5 install CD. At the CD boot prompt we type \"linux rescue\". The
cd boots into a root console where we can use fdisk to discover and
prepare the attached disks.

When the partitions are created and have their filesystem, then we can
use dd to copy the /boot partition.

    ssh root@192.168.1.40 "dd if=/dev/sda1" | dd of=/dev/sda1

Then we use a dump and restore combo to copy the / partition.

    mkdir /mnt/x
    mount /dev/sda2 /mnt/x
    cd /mnt/x
    ssh root@192.168.1.40 "dump -0 -f - /" | restore -r -f -
