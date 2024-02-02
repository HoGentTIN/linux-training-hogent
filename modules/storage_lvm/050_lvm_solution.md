## solution : lvm

1\. Create a volume group that contains a complete disk and a partition
on another disk.

step 1: select disks:

    root@rhel65:~# fdisk -l | grep Disk
    Disk /dev/sda: 8589 MB, 8589934592 bytes
    Disk identifier: 0x00055ca0
    Disk /dev/sdb: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdc: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    ...

I choose /dev/sdb and /dev/sdc for now.

step 2: partition /dev/sdc

    root@rhel65:~# fdisk /dev/sdc
    Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disk\
    label
    Building a new DOS disklabel with disk identifier 0x94c0e5d5.
    Changes will remain in memory only, until you decide to write them.
    After that, of course, the previous content won't be recoverable.

    Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

    WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
             switch off the mode (command 'c') and change display units to
             sectors (command 'u').

    Command (m for help): n
    Command action
       e   extended
       p   primary partition (1-4)
    p
    Partition number (1-4): 1
    First cylinder (1-130, default 1): 
    Using default value 1
    Last cylinder, +cylinders or +size{K,M,G} (1-130, default 130): 
    Using default value 130

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.
    Syncing disks.

step 3: pvcreate and vgcreate

    root@rhel65:~# pvcreate /dev/sdb /dev/sdc1
      Physical volume "/dev/sdb" successfully created
      Physical volume "/dev/sdc1" successfully created
    root@rhel65:~# vgcreate VG42 /dev/sdb /dev/sdc1
      Volume group "VG42" successfully created

2\. Create two logical volumes (a small one and a bigger one) in this
volumegroup. Format them wih ext3, mount them and copy some files to
them.

    root@rhel65:~# lvcreate --size 200m --name LVsmall VG42
      Logical volume "LVsmall" created
    root@rhel65:~# lvcreate --size 600m --name LVbig VG42
      Logical volume "LVbig" created
    root@rhel65:~# ls -l /dev/mapper/VG42-LVsmall
    lrwxrwxrwx. 1 root root 7 Apr 20 20:41 /dev/mapper/VG42-LVsmall -> ../dm-2
    root@rhel65:~# ls -l /dev/VG42/LVsmall
    lrwxrwxrwx. 1 root root 7 Apr 20 20:41 /dev/VG42/LVsmall -> ../dm-2
    root@rhel65:~# ls -l /dev/dm-2
    brw-rw----. 1 root disk 253, 2 Apr 20 20:41 /dev/dm-2

    root@rhel65:~# mkfs.ext3 /dev/mapper/VG42-LVsmall
    mke2fs 1.41.12 (17-May-2010)
    Filesystem label=
    OS type: Linux
    Block size=1024 (log=0)
    Fragment size=1024 (log=0)
    Stride=0 blocks, Stripe width=0 blocks
    51200 inodes, 204800 blocks
    10240 blocks (5.00%) reserved for the super user
    First data block=1
    Maximum filesystem blocks=67371008
    25 block groups
    8192 blocks per group, 8192 fragments per group
    2048 inodes per group
    Superblock backups stored on blocks: 
        8193, 24577, 40961, 57345, 73729

    Writing inode tables: done
    Creating journal (4096 blocks): done
    Writing superblocks and filesystem accounting information: done

    This filesystem will be automatically checked every 39 mounts or
    180 days, whichever comes first.  Use tune2fs -c or -i to override.

    root@rhel65:~# mkfs.ext3 /dev/VG42/LVbig 
    mke2fs 1.41.12 (17-May-2010)
    Filesystem label=
    OS type: Linux
    Block size=4096 (log=2)
    Fragment size=4096 (log=2)
    Stride=0 blocks, Stripe width=0 blocks
    38400 inodes, 153600 blocks
    7680 blocks (5.00%) reserved for the super user
    First data block=0
    Maximum filesystem blocks=159383552
    5 block groups
    32768 blocks per group, 32768 fragments per group
    7680 inodes per group
    Superblock backups stored on blocks: 
        32768, 98304

    Writing inode tables: done                            
    Creating journal (4096 blocks): done
    Writing superblocks and filesystem accounting information: done

    This filesystem will be automatically checked every 25 mounts or
    180 days, whichever comes first.  Use tune2fs -c or -i to override.

The mounting and copying of files.

    root@rhel65:~# mkdir /srv/LVsmall
    root@rhel65:~# mkdir /srv/LVbig
    root@rhel65:~# mount /dev/mapper/VG42-LVsmall /srv/LVsmall
    root@rhel65:~# mount /dev/VG42/LVbig /srv/LVbig
    root@rhel65:~# cp -r /etc /srv/LVsmall/
    root@rhel65:~# cp -r /var/log /srv/LVbig/

3\. Verify usage with fdisk, mount, pvs, vgs, lvs, pvdisplay, vgdisplay,
lvdisplay and df. Does fdisk give you any information about lvm?

Run all those commands (only two are shown below), then answer \'no\'.

    root@rhel65:~# df -h 
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/mapper/VolGroup-lv_root
                          6.7G  1.4G  5.0G  21% /
    tmpfs                 246M     0  246M   0% /dev/shm
    /dev/sda1             485M   77M  383M  17% /boot
    /dev/mapper/VG42-LVsmall
                          194M   30M  154M  17% /srv/LVsmall
    /dev/mapper/VG42-LVbig
                          591M   20M  541M   4% /srv/LVbig
    root@rhel65:~# mount | grep VG42
    /dev/mapper/VG42-LVsmall on /srv/LVsmall type ext3 (rw)
    /dev/mapper/VG42-LVbig on /srv/LVbig type ext3 (rw)

4\. Enlarge the small logical volume by 50 percent, and verify your
work!

    root@rhel65:~# lvextend VG42/LVsmall -l+50%LV
      Extending logical volume LVsmall to 300.00 MiB
      Logical volume LVsmall successfully resized
    root@rhel65:~# resize2fs /dev/mapper/VG42-LVsmall
    resize2fs 1.41.12 (17-May-2010)
    Filesystem at /dev/mapper/VG42-LVsmall is mounted on /srv/LVsmall; on-line res\
    izing required
    old desc_blocks = 1, new_desc_blocks = 2
    Performing an on-line resize of /dev/mapper/VG42-LVsmall to 307200 (1k) blocks.
    The filesystem on /dev/mapper/VG42-LVsmall is now 307200 blocks long.

    root@rhel65:~# df -h | grep small
    /dev/mapper/VG42-LVsmall
                          291M   31M  246M  12% /srv/LVsmall
    root@rhel65:~#

5\. Take a look at other commands that start with vg\* , pv\* or lv\*.

6\. Create a mirror and a striped Logical Volume.

7\. Convert a linear logical volume to a mirror.

8\. Convert a mirror logical volume to a linear.

9\. Create a snapshot of a Logical Volume, take a backup of the
snapshot. Then delete some files on the Logical Volume, then restore
your backup.

10\. Move your volume group to another disk (keep the Logical Volumes
mounted).

11\. If time permits, split a Volume Group with vgsplit, then merge it
again with vgmerge.
