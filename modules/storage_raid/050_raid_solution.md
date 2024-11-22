## solution: raid

1. Boot the VM and log in, verify that the disks are present.

      ```console
      [vagrant@raidlab ~]$ lsblk
      NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
      sda      8:0    0  64G  0 disk 
      ├─sda1   8:1    0   2G  0 part [SWAP]
      └─sda2   8:2    0  62G  0 part /
      sdb      8:16   0   8G  0 disk 
      sdc      8:32   0   8G  0 disk 
      sdd      8:48   0   8G  0 disk 
      sde      8:64   0   8G  0 disk 
      ```

2. Create *raid* partitions on each of the four disks that take up the whole disk. Verify the result.

      > In this example, we use `parted` non-interactively as an alternative to `fdisk`.

      ```console
      [vagrant@raidlab ~]$ sudo parted /dev/sdb --script mklabel gpt
      [vagrant@raidlab ~]$ sudo parted /dev/sdb --script --align optimal mkpart primary 0% 100%
      [vagrant@raidlab ~]$ sudo parted /dev/sdb set 1 raid on
      Information: You may need to update /etc/fstab.
      ```

      > Repeat the above for `/dev/sdc`, `/dev/sdd` and `/dev/sde`. Verify with `lsblk` or `fdisk`. Since the output of `fdisk` is rather verbose, we show only the result for `/dev/sdb`.

      ```console
      [vagrant@raidlab ~]$ lsblk
      NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
      sda      8:0    0  64G  0 disk 
      ├─sda1   8:1    0   2G  0 part [SWAP]
      └─sda2   8:2    0  62G  0 part /
      sdb      8:16   0   8G  0 disk 
      └─sdb1   8:17   0   8G  0 part 
      sdc      8:32   0   8G  0 disk 
      └─sdc1   8:33   0   8G  0 part 
      sdd      8:48   0   8G  0 disk 
      └─sdd1   8:49   0   8G  0 part 
      sde      8:64   0   8G  0 disk 
      └─sde1   8:65   0   8G  0 part 
      [vagrant@raidlab ~]$ sudo fdisk -l /dev/sdb
      Disk /dev/sdb: 8 GiB, 8589934592 bytes, 16777216 sectors
      Disk model: VBOX HARDDISK   
      Units: sectors of 1 * 512 = 512 bytes
      Sector size (logical/physical): 512 bytes / 512 bytes
      I/O size (minimum/optimal): 512 bytes / 512 bytes
      Disklabel type: gpt
      Disk identifier: DF585956-01F3-4764-AA3F-CE8118885912

      Device     Start      End  Sectors Size Type
      /dev/sdb1   2048 16775167 16773120   8G Linux RAID
      ```

3. Create a software *raid 5* array with three active disks and one spare (find in the man page how to do this). Verify that the *raid* array exists.

      ```console
      [vagrant@raidlab ~]$ sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --spare-devices=1 /dev/sde1
      mdadm: Defaulting to version 1.2 metadata
      mdadm: array /dev/md0 started.
      [vagrant@raidlab ~]$ cat /proc/mdstat 
      Personalities : [raid6] [raid5] [raid4] 
      md0 : active raid5 sdd1[4] sde1[3](S) sdc1[1] sdb1[0]
            16762880 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
            [=============>.......]  recovery = 69.2% (5802752/8381440) finish=0.2min speed=200094K/sec
            
      unused devices: <none>
      
      [... wait for the rebuild to finish ...]
      
      [vagrant@raidlab ~]$ cat /proc/mdstat 
      Personalities : [raid6] [raid5] [raid4] 
      md0 : active raid5 sdd1[4] sde1[3](S) sdc1[1] sdb1[0]
            16762880 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
            
      unused devices: <none>
      [vagrant@raidlab ~]$ sudo sudo mdadm --detail /dev/md0
      /dev/md0:
            Version : 1.2
      Creation Time : Fri Nov 22 20:37:49 2024
            Raid Level : raid5
            Array Size : 16762880 (15.99 GiB 17.17 GB)
      Used Dev Size : 8381440 (7.99 GiB 8.58 GB)
            Raid Devices : 3
      Total Devices : 4
            Persistence : Superblock is persistent

            Update Time : Fri Nov 22 20:38:31 2024
                  State : clean 
      Active Devices : 3
      Working Devices : 4
      Failed Devices : 0
      Spare Devices : 1

                  Layout : left-symmetric
            Chunk Size : 512K

      Consistency Policy : resync

                  Name : raidlab:0  (local to host raidlab)
                  UUID : 81ead50e:6af0741d:5e7adb95:e8c0ece9
                  Events : 18

      Number   Major   Minor   RaidDevice State
            0       8       17        0      active sync   /dev/sdb1
            1       8       33        1      active sync   /dev/sdc1
            4       8       49        2      active sync   /dev/sdd1

            3       8       65        -      spare   /dev/sde1
      ```

4. Format the *raid 5* array with a filesystem of your choice and mount it (e.g. under `/srv/` or `/mnt/`). Add to `/etc/fstab` to make the mount persistent and reboot to verify. How much space is available on the array?

      ```console
      [vagrant@raidlab ~]$ sudo mkfs -t xfs /dev/md0
      log stripe unit (524288 bytes) is too large (maximum is 256KiB)
      log stripe unit adjusted to 32KiB
      meta-data=/dev/md0               isize=512    agcount=16, agsize=262016 blks
            =                       sectsz=512   attr=2, projid32bit=1
            =                       crc=1        finobt=1, sparse=1, rmapbt=0
            =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
      data     =                       bsize=4096   blocks=4190720, imaxpct=25
            =                       sunit=128    swidth=256 blks
      naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
      log      =internal log           bsize=4096   blocks=16384, version=2
            =                       sectsz=512   sunit=8 blks, lazy-count=1
      realtime =none                   extsz=4096   blocks=0, rtextents=0
      [vagrant@raidlab ~]$ sudo mount /dev/md0 /srv
      [vagrant@raidlab ~]$ sudo blkid /dev/md0
      /dev/md0: UUID="48024b37-901a-40e3-9548-01a5c99823b5" TYPE="xfs"
      ```

      > The following line was added to `/etc/fstab`:

      ```fstab
      [vagrant@raidlab ~]$ grep srv /etc/fstab 
      UUID=48024b37-901a-40e3-9548-01a5c99823b5 /srv  xfs  defaults  0 0
      ```

      > We reboot with `vagrant reload` and check if the filesystem is mounted:

      ```console
      [vagrant@raidlab ~]$ mount -t xfs
      /dev/sda2 on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
      /dev/md0 on /srv type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,sunit=1024,swidth=2048,noquota)
      [vagrant@raidlab ~]$ findmnt --real
      TARGET SOURCE    FSTYPE OPTIONS
      /      /dev/sda2 xfs    rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota
      └─/srv /dev/md0  xfs    rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,sunit=1024,swidth=204
      ```

      > The array has a size of about 16GB:

      ```console
      [vagrant@raidlab ~]$ df -h
      Filesystem      Size  Used Avail Use% Mounted on
      devtmpfs        4.0M     0  4.0M   0% /dev
      tmpfs           385M     0  385M   0% /dev/shm
      tmpfs           154M  5.1M  149M   4% /run
      /dev/sda2        62G  1.6G   61G   3% /
      vagrant         748G  275G  473G  37% /vagrant
      tmpfs            77M     0   77M   0% /run/user/1000
      /dev/md0         16G  147M   16G   1% /srv
      ```

5. Create a big file on the new filesystem, for example by downloading an ISO image from the internet, or with `dd` (filled with zeroes or with random data). Calculate a checksum of the file.

      ```console
      [vagrant@raidlab ~]$ sudo dd if=/dev/urandom of=/srv/bigfile bs=1M count=128
      128+0 records in
      128+0 records out
      134217728 bytes (134 MB, 128 MiB) copied, 0.238885 s, 562 MB/s
      [vagrant@raidlab ~]$ ls -lh /srv/
      total 128M
      -rw-r--r--. 1 root root 128M Nov 22 20:47 bigfile
      [vagrant@raidlab ~]$ sha256sum /srv/bigfile 
      249b3ccfbfef304f985011a836a7ff18acd24be851c0a069b0d5c35f96935dca  /srv/bigfile
      ```

6. Halt the VM and remove one of the active disks by commenting out the corresponding lines in `vagrant-hosts.yml`. Boot the VM and verify that the `raid 5` array is still present and that the filesystem is mounted. Observe how the spare disk is used to rebuild the array. After the rebuild is complete, verify that the file you created is still there and has the same checksum.

      > In this example, we removed `/dev/sdb` from the array (by commenting out the lines for disk `sata02` in `vagrant-hosts.yml`).
      >
      > After booting and logging in:

      ```console
      [vagrant@raidlab ~]$ findmnt --real
      TARGET SOURCE    FSTYPE OPTIONS
      /      /dev/sda2 xfs    rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota
      └─/srv /dev/md0  xfs    rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,sunit=1024,swidth=204
      [vagrant@raidlab ~]$ cat /proc/mdstat 
      Personalities : [raid6] [raid5] [raid4] 
      md0 : active raid5 sdd1[3] sdb1[0] sdc1[4]
            16762880 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [U_U]
            [==============>......]  recovery = 72.2% (6053532/8381440) finish=0.1min speed=201784K/sec
            
      unused devices: <none>
      [vagrant@raidlab ~]$ sudo mdadm --detail /dev/md0
      /dev/md0:
            Version : 1.2
      Creation Time : Fri Nov 22 20:37:49 2024
            Raid Level : raid5
            Array Size : 16762880 (15.99 GiB 17.17 GB)
      Used Dev Size : 8381440 (7.99 GiB 8.58 GB)
            Raid Devices : 3
      Total Devices : 3
            Persistence : Superblock is persistent

            Update Time : Fri Nov 22 21:10:19 2024
                  State : clean 
      Active Devices : 3
      Working Devices : 3
      Failed Devices : 0
      Spare Devices : 0

                  Layout : left-symmetric
            Chunk Size : 512K

      Consistency Policy : resync

                  Name : raidlab:0  (local to host raidlab)
                  UUID : 81ead50e:6af0741d:5e7adb95:e8c0ece9
                  Events : 49

      Number   Major   Minor   RaidDevice State
            0       8       17        0      active sync   /dev/sdb1
            3       8       49        1      active sync   /dev/sdd1
            4       8       33        2      active sync   /dev/sdc1
      [vagrant@raidlab ~]$ lsblk
      NAME    MAJ:MIN RM SIZE RO TYPE  MOUNTPOINTS
      sda       8:0    0  64G  0 disk  
      ├─sda1    8:1    0   2G  0 part  [SWAP]
      └─sda2    8:2    0  62G  0 part  /
      sdb       8:16   0   8G  0 disk  
      └─sdb1    8:17   0   8G  0 part  
      └─md0   9:0    0  16G  0 raid5 /srv
      sdc       8:32   0   8G  0 disk  
      └─sdc1    8:33   0   8G  0 part  
      └─md0   9:0    0  16G  0 raid5 /srv
      sdd       8:48   0   8G  0 disk  
      └─sdd1    8:49   0   8G  0 part  
      └─md0   9:0    0  16G  0 raid5 /srv
      [vagrant@raidlab ~]$ ls -l /srv/
      total 131072
      -rw-r--r--. 1 root root 134217728 Nov 22 20:55 bigfile
      [vagrant@raidlab ~]$ cat /proc/mdstat 
      Personalities : [raid6] [raid5] [raid4] 
      md0 : active raid5 sdd1[3] sdb1[0] sdc1[4]
            16762880 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
            
      unused devices: <none>
      [vagrant@raidlab ~]$ sha256sum /srv/bigfile 
      249b3ccfbfef304f985011a836a7ff18acd24be851c0a069b0d5c35f96935dca  /srv/bigfile
      ```

      > The *raid 5* array is still present and the file is still there with the same checksum!
      >
      > Other observations:
      > - The `/dev/sd*` devices were reordered. `/dev/sdb` is still present, but it's actually `/dev/sdc` from before. The name `/dev/sde` no longer occurs.
      > - After logging in, `/proc/mdstat` shows that the array is rebuilding.
      > - There is no longer a spare disk in the array.

7. Halt the VM again and remove another disk. Will the array (and the data) survive? How many disks can you remove before the array is no longer operational?

      > After removing another disk (`sata04` in this case), the array is still operational, but in a degraded state:

      ```console
      [vagrant@raidlab ~]$ sha256sum /srv/bigfile 
      249b3ccfbfef304f985011a836a7ff18acd24be851c0a069b0d5c35f96935dca  /srv/bigfile
      [vagrant@raidlab ~]$ cat /proc/mdstat 
      Personalities : [raid6] [raid5] [raid4] 
      md0 : active raid5 sdb1[0] sdc1[4]
            16762880 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [U_U]
            
      unused devices: <none>
      [vagrant@raidlab ~]$ sudo mdadm --detail /dev/md0 
      /dev/md0:
            Version : 1.2
      Creation Time : Fri Nov 22 20:37:49 2024
            Raid Level : raid5
            Array Size : 16762880 (15.99 GiB 17.17 GB)
      Used Dev Size : 8381440 (7.99 GiB 8.58 GB)
            Raid Devices : 3
      Total Devices : 2
            Persistence : Superblock is persistent

            Update Time : Fri Nov 22 21:19:46 2024
                  State : clean, degraded 
      Active Devices : 2
      Working Devices : 2
      Failed Devices : 0
      Spare Devices : 0

                  Layout : left-symmetric
            Chunk Size : 512K

      Consistency Policy : resync

                  Name : raidlab:0  (local to host raidlab)
                  UUID : 81ead50e:6af0741d:5e7adb95:e8c0ece9
                  Events : 55

      Number   Major   Minor   RaidDevice State
            0       8       17        0      active sync   /dev/sdb1
            -       0        0        1      removed
            4       8       33        2      active sync   /dev/sdc1
      ```

      > The next disk that is removed will make the array no longer operational. In fact, if you open the GUI of the VM (click the *Show* button in the VirtualBox main window), you will notice that the boot process hangs for a long time on a task that tries to detect the missing disk(s) (`A start job is running for /dev/disk/by-uuid-...`), it will fail to mount the `/srv` filesystem (`dependency failed for /srv/`) and drop you into a rescue shell.
      >
      > At this time, the VM is basically broken and you can delete it with `vagrant destroy`.

The labs with *raid 1*, *raid 0* or *raid 10* are left as an exercise to the reader.

