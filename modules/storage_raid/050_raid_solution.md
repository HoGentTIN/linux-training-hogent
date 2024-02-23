## solution: raid

1\. Add three virtual disks of 1GB each to a virtual machine.

2\. Create a software `raid 5` on the three disks. (It is not necessary
to put a filesystem on it)

3\. Verify with `fdisk` and in `/proc` that the `raid 5` exists.

4\. Stop and remove the `raid 5`.

5\. Create a `raid 1` to mirror two disks.

    [root@linux ~]# mdadm --create /dev/md0 --level=1 --raid-devices=2 \
    /dev/sdb1 /dev/sdc1 
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    [root@linux ~]# cat /proc/mdstat 
    Personalities : [raid6] [raid5] [raid4] [raid1] 
    md0 : active raid1 sdc1[1] sdb1[0]
          8384862 blocks super 1.2 [2/2] [UU]
          [====>................]  resync = 20.8% (1745152/8384862) \
    finish=0.5min speed=218144K/sec

