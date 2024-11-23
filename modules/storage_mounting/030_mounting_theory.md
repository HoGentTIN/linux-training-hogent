## mounting local file systems

### mkdir

This example shows how to create a new *mount point* with `mkdir`.

```console
student@linux:~$ sudo mkdir /mnt/project42
```

### mount

When the *mount point* is created, and a *file system* is present on the
partition, then `mount` can *mount* the *file system* on the
*mount point directory*.

```console
student@linux:~$ sudo mount -t ext2 /dev/sdb1 /mnt/project42/
```

Once mounted, the new file system is accessible to users.

### /etc/filesystems

Actually the explicit `-t ext2` option to set the file system is not always necessary. The `mount` command is able to automatically detect a lot of file systems.

When mounting a file system without specifying explicitly the file system, then `mount` will first probe `/etc/filesystems`. Mount will skip lines with the `nodev` directive.

```console
student@linux:~$ cat /etc/filesystems 
ext3
ext2
nodev proc
nodev devpts
iso9660
vfat
hfs
```

### /proc/filesystems

When `/etc/filesystems` does not exist, or ends with a single `*` on the last line, then `mount` will read `/proc/filesystems`.

```console
student@linux:~$ cat /proc/filesystems | grep -v ^nodev
        ext3
        ext2
        ext4
        btrfs
        fuseblk
        squashfs
        vfat
```

### umount

You can *unmount* a mounted file system using the `umount` command.

```console
student@linux:~$ sudo umount /mnt/project42
```

## displaying mounted file systems

To display all mounted file systems, issue the `mount` command. Or look at the files `/proc/mounts` and `/etc/mtab`.

### mount

The simplest and most common way to view all mounts is by issuing the `mount` command without any arguments.

```console
student@linux:~$ mount | grep /dev/sdb
/dev/sdb1 on /mnt/project42 type ext2 (rw)
```

The output of `mount` used to be simple enough, but these days, with all the pseudo filesystems under `/sys`, `/run` and the like, you have to pipe it through `grep` to find useful information through all the noise.

However, as it turns out, using `mount` to *list* mounted filesystems is *deprecated*. From the man page `mount(8)`:

```text
   Listing the mounts
       The listing mode is maintained for backward compatibility only.

       For more robust and customizable output use findmnt(8), especially in your scripts.
```

### findmnt

The `findmnt` command is way more useful to show mounted filesystems. Even the default output looks better structured than `mount` and there are a lot of options and arguments to customize the output. Try the default output yourself, as it's quite verbose.

A few examples of useful options:

- `--real`: Only show "real" filesystems (i.e. not pseudo filesystems):

    ```console
    [vagrant@el ~]$ findmnt --real
    TARGET       SOURCE    FSTYPE  OPTIONS
    /            /dev/sda2 xfs     rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota
    ├─/mnt/part3 /dev/sdc5 xfs     rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota
    ├─/mnt/part4 /dev/sdc6 fuseblk rw,relatime,user_id=0,group_id=0,allow_other,blksize=4096
    ├─/mnt/part2 /dev/sdc2 ext4    rw,relatime,seclabel
    └─/mnt/part1 /dev/sdc1 ext3    rw,relatime,seclabel
    ```

    Note the tree structure and aligned columns!

- `--fstab`, `-s`: Show only filesystems listed in `/etc/fstab`:

    ```console
    [vagrant@el ~]$ findmnt --fstab
    TARGET     SOURCE                                      FSTYPE OPTIONS
    /          UUID=303db791-9236-4ac4-a176-e2a033576d89   xfs    defaults
    none       UUID=a4814ebe-c0b2-4819-8129-30f32b3e8772   swap   defaults
    /mnt/part1 UUID="f89d27bf-94d3-40a4-9fca-2af9cbe94856" ext3   defaults
    /mnt/part2 UUID="cb44e6c4-a49e-43e1-b9a8-ed5d272b8efb" ext4   defaults
    /mnt/part3 UUID="6b306b44-23fe-4cef-8c3e-423188e5c088" xfs    defaults
    /mnt/part4 UUID="2856B0906FE06278"                     ntfs   defaults
    /vagrant   vagrant                                     vboxsf uid=1000,gid=1000,_netdev
    ```

- `--json`, `-J`: Output in JSON format

- `--pairs`, `-P`: Output in key-value pairs

    ```console
    [vagrant@el ~]$ findmnt --pairs
    TARGET="/proc" SOURCE="proc" FSTYPE="proc" OPTIONS="rw,nosuid,nodev,noexec,relatime"
    TARGET="/sys" SOURCE="sysfs" FSTYPE="sysfs" OPTIONS="rw,nosuid,nodev,noexec,relatime,seclabel"
    [...]
    ```

- `--df`, `-D`: imitate the output of `df(1)`

    ```console
    [vagrant@el ~]$ findmnt  --df
    SOURCE    FSTYPE     SIZE  USED  AVAIL USE% TARGET
    devtmpfs  devtmpfs     4M     0     4M   0% /dev
    tmpfs     tmpfs    384.5M     0 384.5M   0% /dev/shm
    tmpfs     tmpfs    153.8M  4.4M 149.4M   3% /run
    /dev/sda2 xfs       61.9G  1.8G    60G   3% /
    /dev/sdc5 xfs        4.9G 67.5M   4.9G   1% /mnt/part3
    /dev/sdc6 fuseblk      5G 26.2M     5G   1% /mnt/part4
    /dev/sdc2 ext4       5.8G   24K   5.5G   0% /mnt/part2
    /dev/sdc1 ext3       3.9G   96K   3.7G   0% /mnt/part1
    tmpfs     tmpfs     76.9M     0  76.9M   0% /run/user/1000
    ```

### Mount info in /proc

The kernel provides the info through the `/proc` pseudo file system (i.e., `/proc` does not exist as a file on any hard disk but provides a file-like interface to information about the kernel).

Several files contain relevant information:

- `/proc/self/mounts`: a list of all mounted file systems, the content is like the output of `mount`. For backwards compatibility, `/etc/mtab` and `/proc/mounts` are symlinks to this file.
- `/proc/self/mountinfo`: a more detailed list of mounted file systems
- `/proc/self/mountstats`: statistics about mounted file systems

```console
student@linux:~$ cat /proc/mounts | grep /dev/sdb
    /dev/sdb1 /mnt/project42 ext2 rw 0 0
```

However, `findmnt` is a better way to get and present this information.

### df

A more user friendly way to look at mounted file systems is `df`. The `df` (*diskfree*) command has the added benefit of showing you the free space on each mounted disk. Like a lot of Linux commands, `df` supports the `-h` switch to make the output more *human readable*.

```console
student@linux:~$ df
Filesystem         1K-blocks      Used Available Use% Mounted on
/dev/mapper/VolGroup00-LogVol00
                    11707972   6366996   4746240  58% /
/dev/sda1             101086      9300     86567  10% /boot
none                  127988         0    127988   0% /dev/shm
/dev/sdb1             108865      1550    101694   2% /mnt/project42
student@linux:~$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00
                       12G  6.1G  4.6G  58% /
/dev/sda1              99M  9.1M   85M  10% /boot
none                  125M     0  125M   0% /dev/shm
/dev/sdb1             107M  1.6M  100M   2% /mnt/project42
```

### df -h

In the `df -h` example below you can see the size, free space, used gigabytes and percentage and mount point of a partition.

```console
student@linux:~$ df -h | egrep -e "(sdb2|File)"
Filesystem            Size Used Avail Use% Mounted on
/dev/sdb2              92G  83G  8.6G  91% /media/sdb2
```

### du

The `du` command can summarize *disk usage* for files and directories. By using `du` on a mount point you effectively get the disk space used on a file system.

While `du` can go display each subdirectory recursively, the `-s` option will give you a total summary for the parent directory. This option is often used together with `-h`. This means `du -sh` on a mount point gives the total amount used by the file system in that partition.

```console
student@linux:~$ du -sh /boot /srv/wolf
6.2M    /boot
1.1T    /srv/wolf
```

## from start to finish

Below is a screenshot that show a summary roadmap starting with detection of the hardware (/dev/sdb) up until mounting on `/mnt`.

```console
student@linux:~$ sudo dmesg | grep '\[sdb\]'
sd 3:0:0:0: [sdb] 150994944 512-byte logical blocks: (77.3 GB/72.0 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] Attached SCSI disk

student@linux:~$ sudo parted /dev/sdb

(parted) mklabel msdos
(parted) mkpart primary ext4 1 77000
(parted) print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 77.3GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End     Size    Type     File system  Flags
    1      1049kB  77.0GB  77.0GB  primary

(parted) quit
student@linux:~$ sudomkfs.ext4 /dev/sdb1
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
4702208 inodes, 18798592 blocks
939929 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
574 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
( output truncated )
...
student@linux:~$ sudomount /dev/sdb1 /mnt
student@linux:~$ sudomount | grep mnt
/dev/sdb1 on /mnt type ext4 (rw)
student@linux:~$ sudodf -h | grep mnt
/dev/sdb1              71G  180M   67G   1% /mnt
student@linux:~$ sudodu -sh /mnt
20K     /mnt
student@linux:~$ sudoumount /mnt
```

## permanent mounts

Until now, we performed all mounts manually. This works nice, until the next reboot. Luckily there is a way to tell your computer to automatically mount certain file systems during boot.

### /etc/fstab

The file system table located in `/etc/fstab` contains a list of file systems, with an option to automtically mount each of them at boot time.

Below is a sample `/etc/fstab` file.

```console
student@linux:~$ cat /etc/fstab 
/dev/VolGroup00/LogVol00 /                ext3    defaults        1 1
LABEL=/boot             /boot             ext3    defaults        1 2
none                    /dev/pts          devpts  gid=5,mode=620  0 0
none                    /dev/shm          tmpfs   defaults        0 0
none                    /proc             proc    defaults        0 0
none                    /sys              sysfs   defaults        0 0
/dev/VolGroup00/LogVol01 swap             swap    defaults        0 0
```

By adding the following line, we can automate the mounting of a file system.

```console
/dev/sdb1                /mnt/project42      ext2    defaults    0 0
```

### mount /mountpoint

Adding an entry to `/etc/fstab` has the added advantage that you can simplify the `mount` command. The command in the screenshot below forces `mount` to look for the partition info in `/etc/fstab`.

```console
student@linux:~$ sudo mount /mnt/project42
```

## securing mounts

File systems can be secured with several *mount options*. Here are some examples.

### ro

The `ro` option will mount a file system as read only, preventing anyone from writing.

```console
student@linux:~$ sudo mount -t ext2 -o ro /dev/hdb1 /mnt/project42
student@linux:~$ sudo touch /mnt/project42/testwrite
touch: cannot touch `/mnt/project42/testwrite': Read-only file system
```

### noexec

The `noexec` option will prevent the execution of binaries and scripts on the mounted file system.

```console
student@linux:~$ sudo mount -t ext2 -o noexec /dev/hdb1 /mnt/project42
student@linux:~$ sudo cp /bin/cat /mnt/project42
student@linux:~$ sudo /mnt/project42/cat /etc/hosts
-bash: /mnt/project42/cat: Permission denied
student@linux:~$ sudo echo echo hello > /mnt/project42/helloscript
student@linux:~$ sudo chmod +x /mnt/project42/helloscript 
student@linux:~$ sudo /mnt/project42/helloscript 
-bash: /mnt/project42/helloscript: Permission denied
```

### nosuid

The `nosuid` option will ignore `setuid` bit set binaries on the mounted file system.

Note that you can still set the `setuid` bit on files.

```console
student@linux:~$ sudo mount -o nosuid /dev/hdb1 /mnt/project42
student@linux:~$ sudo cp /bin/sleep /mnt/project42/
student@linux:~$ sudo chmod 4555 /mnt/project42/sleep 
student@linux:~$ sudo ls -l /mnt/project42/sleep 
-r-sr-xr-x 1 root root 19564 Jun 24 17:57 /mnt/project42/sleep
```

But users cannot exploit the `setuid` feature.

```console
student@linux:~$ su - paul
[paul@linux ~]$ /mnt/project42/sleep 500 &
[1] 2876
[paul@linux ~]$ ps -f 2876
UID        PID  PPID  C STIME TTY      STAT   TIME CMD
paul      2876  2853  0 17:58 pts/0    S      0:00 /mnt/project42/sleep 500
```

### noacl

To prevent cluttering permissions with *acl's*, use the `noacl` option.

```console
student@linux:~$ sudo mount -o noacl /dev/hdb1 /mnt/project42
```

More *mount options* can be found in the manual page of `mount(8)`.

## mounting remote file systems

### smb/cifs

The Samba team (<https://samba.org/>) has a Unix/Linux service that is compatible with the SMB/CIFS protocol. This protocol is mainly used by networked Microsoft Windows computers for sharing files or printers (a.k.a. *Network Neighbourhood*).

Connecting to a Samba server (or to a Microsoft computer) is also done with the `mount` command.

This example shows how to connect to the `10.0.0.42` server, to a share named `data2`.

```console
student@linux:~$ sudo mount -t cifs -o user=paul //10.0.0.42/data2 /mnt/data2
Password: 
student@linux:~$ sudo mount | grep cifs
//10.0.0.42/data2 on /mnt/data2 type cifs (rw)
```

The above requires the package `cifs-utils` (on both Debian and Enterprise Linux based distributions).

### nfs

Unix servers often use *nfs* (aka the network file system) to share directories over the network. Setting up an nfs server is not discussed here. Connecting as a client to an nfs server is done with `mount`, and is very similar to connecting to local storage.

This command shows how to connect to the *nfs* server named `server42`, which is sharing the directory `/srv/data`. The *mount point* at the end of the command (`/mnt/data`) must already exist.

```console
student@linux:~$ mount -t nfs server42:/srv/data /mnt/data
```

If this `server42` has ip-address `10.0.0.42` then you can also write:

```console
student@linux:~$ sudo mount -t nfs 10.0.0.42:/srv/data /mnt/data
student@linux:~$ mount | grep data
10.0.0.42:/srv/data on /mnt/data type nfs (rw,vers=4,addr=10.0.0.42,clienta\
ddr=10.0.0.33)
```

### nfs specific mount options

- `bg`: If mount fails, retry in background.
- `fg`: (default) If mount fails, retry in foreground.
- `soft`: Stop trying to mount after X attempts.
- `hard`: (default) Continue trying to mount.

The `soft+bg` options combined guarantee the fastest client boot if there are NFS problems.

```console
retrans=X Try X times to connect (over udp).
tcp Force tcp (default and supported)
udp Force udp (unsupported)
```

