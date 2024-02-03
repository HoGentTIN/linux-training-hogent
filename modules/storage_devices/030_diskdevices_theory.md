## terminology

### platter, head, track, cylinder, sector

Data is commonly stored on magnetic or optical
`disk platters`. The platters are rotated (at high
speeds). Data is read by `heads`, which are very close to
the surface of the platter, without touching it! The heads are mounted
on an arm (sometimes called a comb or a fork).

Data is written in concentric circles called `tracks`.
Track zero is (usually) on the outside. The time it takes to position
the head over a certain track is called the `seek time`.
Often the platters are stacked on top of each other, hence the set of
tracks accessible at a certain position of the comb forms a
`cylinder`. Tracks are divided into 512 byte
`sectors`, with more unused space (`gap`) between the
sectors on the outside of the platter.

When you break down the advertised `access time` of a hard
drive, you will notice that most of that time is taken by movement of
the heads (about 65%) and `rotational latency` (about
30%).

### ide or scsi

Actually, the title should be `ata` or
`scsi`, since ide is an ata compatible device. Most
desktops use `ata devices`, most servers use `scsi`.

### ata

An `ata controller` allows two devices per bus, one
`master` and one `slave`. Unless your
controller and devices support `cable select`, you have to
set this manually with jumpers.

With the introduction of `sata` (serial ata), the original
ata was renamed to `parallel ata`. Optical drives often
use `atapi`, which is an ATA interface using the SCSI
communication protocol.

### scsi

A `scsi controller` allows more than two devices. When using
`SCSI (small computer system interface)`, each device gets a unique
`scsi id`. The `scsi controller` also needs a `scsi id`,
do not use this id for a scsi-attached device.

Older 8-bit SCSI is now called `narrow`, whereas 16-bit is `wide`. When
the bus speeds was doubled to 10Mhz, this was known as `fast SCSI`.
Doubling to 20Mhz made it `ultra SCSI`. Take a look at
http://en.wikipedia.org/wiki/SCSI for more SCSI standards.

### block device

Random access hard disk devices have an abstraction layer called
`block device` to enable formatting in fixed-size (usually
512 bytes) blocks. Blocks can be accessed independent of access to other
blocks.

    [root@centos65 ~]# lsblk
    NAME                        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                           8:0    0   40G  0 disk 
    --sda1                        8:1    0  500M  0 part /boot
    --sda2                        8:2    0 39.5G  0 part 
      --VolGroup-lv_root (dm-0) 253:0    0 38.6G  0 lvm  /
      --VolGroup-lv_swap (dm-1) 253:1    0  928M  0 lvm  [SWAP]
    sdb                           8:16   0   72G  0 disk 
    sdc                           8:32   0  144G  0 disk

A block device has the letter b to denote the file type in the output of
`ls -l`.

    [root@centos65 ~]# ls -l /dev/sd*
    brw-rw----. 1 root disk 8,  0 Apr 19 10:12 /dev/sda
    brw-rw----. 1 root disk 8,  1 Apr 19 10:12 /dev/sda1
    brw-rw----. 1 root disk 8,  2 Apr 19 10:12 /dev/sda2
    brw-rw----. 1 root disk 8, 16 Apr 19 10:12 /dev/sdb
    brw-rw----. 1 root disk 8, 32 Apr 19 10:12 /dev/sdc

Virtual devices like `raid` or `lvm` are also listed as `block devices`
as seen in this RHEL7 virtual machine.

    [root@centos7 ~]# lsblk
    NAME                    MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
    sda                       8:0    0     8G  0 disk
    ├─sda1                    8:1    0   400M  0 part
    │ └─md0                   9:0    0 399.7M  0 raid1
    ├─sda2                    8:2    0   400M  0 part
    │ └─md0                   9:0    0 399.7M  0 raid1
    └─sda3                    8:3    0   400M  0 part
    sdb                       8:16   0     8G  0 disk
    sdc                       8:32   0     8G  0 disk
    sdd                       8:48   0     2G  0 disk
    sde                       8:64   0     2G  0 disk
    sdf                       8:80   0  20.5G  0 disk
    ├─sdf1                    8:81   0   500M  0 part  /boot
    └─sdf2                    8:82   0    20G  0 part
      ├─centos_centos7-swap 253:0    0     2G  0 lvm   [SWAP]
      └─centos_centos7-root 253:1    0    18G  0 lvm   /
    sr0                      11:0    1  1024M  0 rom
    [root@centos7 ~]#

Note that a `character device` is a constant stream of
characters, being denoted by a c in `ls -l`. Note also that the
`ISO 9660` standard for cdrom uses a `2048 byte` block size.

Old hard disks (and floppy disks) use
`cylinder-head-sector` addressing to access a sector on
the disk. Most current disks use
`LBA (Logical Block Addressing)`.

### solid state drive

A `solid state drive` or `ssd` is a block
device without moving parts. It is comparable to `flash memory`. An
`ssd` is more expensive than a hard disk, but it typically has a much
faster access time.

In this book we will use the following pictograms for `spindle disks`
(in brown) and `solid state disks` (in blue).

![](../images/storage_disk_devices_template.png)

## device naming

### ata (ide) device naming

All `ata` drives on your system will start with `/dev/hd`
followed by a unit letter. The master hdd on the first `ata controller`
is /dev/hda, the slave is /dev/hdb. For the second controller, the names
of the devices are /dev/hdc and /dev/hdd.

   controller   connection   device name
  ------------ ------------ -------------
      ide0        master      /dev/hda
     slave       /dev/hdb   
      ide1        master      /dev/hdc
     slave       /dev/hdd   

  : ide device naming

It is possible to have only `/dev/hda` and `/dev/hdd`. The first one is
a single ata hard disk, the second one is the cdrom (by default
configured as slave).

### scsi device naming

`scsi` drives follow a similar scheme, but all start with
`/dev/sd`. When you run out of letters (after /dev/sdz),
you can continue with /dev/sdaa and /dev/sdab and so on. (We will see
later on that `lvm` volumes are commonly seen as /dev/md0, /dev/md1
etc.)

Below a `sample` of how scsi devices on a Linux can be named. Adding a
scsi disk or raid controller with a lower scsi address will change the
naming scheme (shifting the higher scsi addresses one letter further in
the alphabet).

  ---------------------------------------------------------
          device             scsi id        device name
  ----------------------- -------------- ------------------
          disk 0                0             /dev/sda

          disk 1                1             /dev/sdb

     raid controller 0          5             /dev/sdc

     raid controller 1          6             /dev/sdd
  ---------------------------------------------------------

  : scsi device naming

A modern Linux system will use `/dev/sd*` for scsi and sata devices, and
also for sd-cards, usb-sticks, (legacy) ATA/IDE devices and solid state
drives.

## discovering disk devices

### fdisk

You can start by using `/sbin/fdisk` to find out what kind
of disks are seen by the kernel. Below the result on old Debian desktop,
with two `ata-ide disks` present.

    root@barry:~# fdisk -l | grep Disk
    Disk /dev/hda: 60.0 GB, 60022480896 bytes
    Disk /dev/hdb: 81.9 GB, 81964302336 bytes

And here an example of `sata and scsi disks` on a server with CentOS.
Remember that `sata` disks are also presented to you with the `scsi`
/dev/sd\* notation.

    [root@centos65 ~]# fdisk -l | grep 'Disk /dev/sd'
    Disk /dev/sda: 42.9 GB, 42949672960 bytes
    Disk /dev/sdb: 77.3 GB, 77309411328 bytes
    Disk /dev/sdc: 154.6 GB, 154618822656 bytes
    Disk /dev/sdd: 154.6 GB, 154618822656 bytes

Here is an overview of disks on a RHEL4u3 server with two real 72GB
`scsi disks`. This server is attached to a `NAS` with four `NAS disks`
of half a terabyte. On the NAS disks, four LVM (/dev/mdx) software RAID
devices are configured.

    [root@tsvtl1 ~]# fdisk -l | grep Disk
    Disk /dev/sda: 73.4 GB, 73407488000 bytes
    Disk /dev/sdb: 73.4 GB, 73407488000 bytes
    Disk /dev/sdc: 499.0 GB, 499036192768 bytes
    Disk /dev/sdd: 499.0 GB, 499036192768 bytes
    Disk /dev/sde: 499.0 GB, 499036192768 bytes
    Disk /dev/sdf: 499.0 GB, 499036192768 bytes
    Disk /dev/md0: 271 MB, 271319040 bytes
    Disk /dev/md2: 21.4 GB, 21476081664 bytes
    Disk /dev/md3: 21.4 GB, 21467889664 bytes
    Disk /dev/md1: 21.4 GB, 21476081664 bytes

You can also use `fdisk` to obtain information about one specific hard
disk device.

    [root@centos65 ~]# fdisk -l /dev/sdc

    Disk /dev/sdc: 154.6 GB, 154618822656 bytes
    255 heads, 63 sectors/track, 18798 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x00000000

Later we will use fdisk to do dangerous stuff like creating and deleting
partitions.

### dmesg

Kernel boot messages can be seen after boot with `dmesg`.
Since hard disk devices are detected by the kernel during boot, you can
also use dmesg to find information about disk devices.

    [root@centos65 ~]# dmesg | grep 'sd[a-z]' | head
    sd 0:0:0:0: [sda] 83886080 512-byte logical blocks: (42.9 GB/40.0 GiB)
    sd 0:0:0:0: [sda] Write Protect is off
    sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
    sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support \
    DPO or FUA
    sda: sda1 sda2
    sd 0:0:0:0: [sda] Attached SCSI disk
    sd 3:0:0:0: [sdb] 150994944 512-byte logical blocks: (77.3 GB/72.0 GiB)
    sd 3:0:0:0: [sdb] Write Protect is off
    sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
    sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support \
    DPO or FUA

Here is another example of `dmesg` on a computer with a
200GB ata disk.

    paul@barry:~$ dmesg | grep -i "ata disk"
    [    2.624149] hda: ST360021A, ATA DISK drive
    [    2.904150] hdb: Maxtor 6Y080L0, ATA DISK drive
    [    3.472148] hdd: WDC WD2000BB-98DWA0, ATA DISK drive

Third and last example of `dmesg` running on RHEL5.3.

    root@rhel53 ~# dmesg | grep -i "scsi disk"
    sd 0:0:2:0: Attached scsi disk sda
    sd 0:0:3:0: Attached scsi disk sdb
    sd 0:0:6:0: Attached scsi disk sdc

### /sbin/lshw

The `lshw` tool will `list hardware`. With the right options `lshw` can
show a lot of information about disks (and partitions).

Below a truncated screenshot on Debian 6:

    root@debian6~# lshw -class volume | grep -A1 -B2 scsi
           description: Linux raid autodetect partition
           physical id: 1
           bus info: scsi@1:0.0.0,1
           logical name: /dev/sdb1
    --
           description: Linux raid autodetect partition
           physical id: 1
           bus info: scsi@2:0.0.0,1
           logical name: /dev/sdc1
    --
           description: Linux raid autodetect partition
           physical id: 1
           bus info: scsi@3:0.0.0,1
           logical name: /dev/sdd1
    --
           description: Linux raid autodetect partition
           physical id: 1
           bus info: scsi@4:0.0.0,1
           logical name: /dev/sde1
    --
           vendor: Linux
           physical id: 1
           bus info: scsi@0:0.0.0,1
           logical name: /dev/sda1
    --
           vendor: Linux
           physical id: 2
           bus info: scsi@0:0.0.0,2
           logical name: /dev/sda2
    --
           description: Extended partition
           physical id: 3
           bus info: scsi@0:0.0.0,3
           logical name: /dev/sda3

Redhat and CentOS do not have this tool (unless you add a repository).

### /sbin/lsscsi

The `lsscsi` command provides a nice readable output of
all scsi (and scsi emulated devices). This first screenshot shows
`lsscsi` on a SPARC system.

    root@shaka:~# lsscsi 
    [0:0:0:0]    disk    Adaptec  RAID5            V1.0  /dev/sda
    [1:0:0:0]    disk    SEAGATE  ST336605FSUN36G  0438  /dev/sdb
    root@shaka:~#

Below a screenshot of `lsscsi` on a QNAP NAS (which has four 750GB disks
and boots from a usb stick).

    lroot@debian6~# lsscsi 
    [0:0:0:0]    disk    SanDisk  Cruzer Edge      1.19  /dev/sda
    [1:0:0:0]    disk    ATA      ST3750330AS      SD04  /dev/sdb
    [2:0:0:0]    disk    ATA      ST3750330AS      SD04  /dev/sdc
    [3:0:0:0]    disk    ATA      ST3750330AS      SD04  /dev/sdd
    [4:0:0:0]    disk    ATA      ST3750330AS      SD04  /dev/sde

This screenshot shows the classic output of `lsscsi`.

    root@debian6~# lsscsi -c
    Attached devices: 
    Host: scsi0 Channel: 00 Target: 00 Lun: 00
      Vendor: SanDisk  Model: Cruzer Edge      Rev: 1.19
      Type:   Direct-Access                    ANSI SCSI revision: 02
    Host: scsi1 Channel: 00 Target: 00 Lun: 00
      Vendor: ATA      Model: ST3750330AS      Rev: SD04
      Type:   Direct-Access                    ANSI SCSI revision: 05
    Host: scsi2 Channel: 00 Target: 00 Lun: 00
      Vendor: ATA      Model: ST3750330AS      Rev: SD04
      Type:   Direct-Access                    ANSI SCSI revision: 05
    Host: scsi3 Channel: 00 Target: 00 Lun: 00
      Vendor: ATA      Model: ST3750330AS      Rev: SD04
      Type:   Direct-Access                    ANSI SCSI revision: 05
    Host: scsi4 Channel: 00 Target: 00 Lun: 00
      Vendor: ATA      Model: ST3750330AS      Rev: SD04
      Type:   Direct-Access                    ANSI SCSI revision: 05

### /proc/scsi/scsi

Another way to locate `scsi` (or sd) devices is via
`/proc/scsi/scsi`.

This screenshot is from a `sparc` computer with adaptec RAID5.

    root@shaka:~# cat /proc/scsi/scsi 
    Attached devices:
    Host: scsi0 Channel: 00 Id: 00 Lun: 00
      Vendor: Adaptec  Model: RAID5            Rev: V1.0
      Type:   Direct-Access                    ANSI SCSI revision: 02
    Host: scsi1 Channel: 00 Id: 00 Lun: 00
      Vendor: SEAGATE  Model: ST336605FSUN36G  Rev: 0438
      Type:   Direct-Access                    ANSI SCSI revision: 03
    root@shaka:~#

Here we run `cat /proc/scsi/scsi` on the QNAP from above (with Debian
Linux).

    root@debian6~# cat /proc/scsi/scsi 
    Attached devices:
    Host: scsi0 Channel: 00 Id: 00 Lun: 00
      Vendor: SanDisk  Model: Cruzer Edge      Rev: 1.19
      Type:   Direct-Access                    ANSI  SCSI revision: 02
    Host: scsi1 Channel: 00 Id: 00 Lun: 00
      Vendor: ATA      Model: ST3750330AS      Rev: SD04
      Type:   Direct-Access                    ANSI  SCSI revision: 05
    Host: scsi2 Channel: 00 Id: 00 Lun: 00
      Vendor: ATA      Model: ST3750330AS      Rev: SD04
      Type:   Direct-Access                    ANSI  SCSI revision: 05
    Host: scsi3 Channel: 00 Id: 00 Lun: 00
      Vendor: ATA      Model: ST3750330AS      Rev: SD04
      Type:   Direct-Access                    ANSI  SCSI revision: 05
    Host: scsi4 Channel: 00 Id: 00 Lun: 00
      Vendor: ATA      Model: ST3750330AS      Rev: SD04
      Type:   Direct-Access                    ANSI  SCSI revision: 05

Note that some recent versions of Debian have this disabled in the
kernel. You can enable it (after a kernel compile) using this entry:

    # CONFIG_SCSI_PROC_FS is not set

Redhat and CentOS have this by default (if there are scsi devices
present).

    [root@centos65 ~]# cat /proc/scsi/scsi 
    Attached devices:
    Host: scsi0 Channel: 00 Id: 00 Lun: 00
      Vendor: ATA      Model: VBOX HARDDISK    Rev: 1.0 
      Type:   Direct-Access                    ANSI  SCSI revision: 05
    Host: scsi3 Channel: 00 Id: 00 Lun: 00
      Vendor: ATA      Model: VBOX HARDDISK    Rev: 1.0 
      Type:   Direct-Access                    ANSI  SCSI revision: 05
    Host: scsi4 Channel: 00 Id: 00 Lun: 00
      Vendor: ATA      Model: VBOX HARDDISK    Rev: 1.0 
      Type:   Direct-Access                    ANSI  SCSI revision: 05

## erasing a hard disk

Before selling your old hard disk on the internet, it may be a good idea
to erase it. By simply repartitioning, or by using the Microsoft Windows
format utility, or even after an `mkfs` command, some people will still
be able to read most of the data on the disk.

    root@debian6~# aptitude search foremost autopsy sleuthkit | tr -s ' '
    p autopsy - graphical interface to SleuthKit 
    p foremost - Forensics application to recover data 
    p sleuthkit - collection of tools for forensics analysis

Although technically the `/sbin/badblocks` tool is meant
to look for bad blocks, you can use it to completely erase all data from
a disk. Since this is really writing to every sector of the disk, it can
take a long time!

    root@RHELv8u2:~# badblocks -ws /dev/sdb
    Testing with pattern 0xaa: done
    Reading and comparing: done
    Testing with pattern 0x55: done
    Reading and comparing: done
    Testing with pattern 0xff: done
    Reading and comparing: done
    Testing with pattern 0x00: done
    Reading and comparing: done

The previous screenshot overwrites every sector of the disk
`four times`. Erasing `once` with a tool like `dd` is enough to destroy
all data.

Warning, this screenshot shows how to permanently destroy all data on a
block device.

    [root@rhel65 ~]# dd if=/dev/zero of=/dev/sdb

## advanced hard disk settings

Tweaking of hard disk settings (dma, gap, \...) are not covered in this
course. Several tools exists, `hdparm` and `sdparm` are two of them.

`hdparm` can be used to display or set information and
parameters about an ATA (or SATA) hard disk device. The -i and -I
options will give you even more information about the physical
properties of the device.

    root@laika:~# hdparm /dev/sdb

    /dev/sdb:
     IO_support   =  0 (default 16-bit)
     readonly     =  0 (off)
     readahead    = 256 (on)
     geometry     = 12161/255/63, sectors = 195371568, start = 0

Below `hdparm` info about a 200GB IDE disk.

    root@barry:~# hdparm /dev/hdd

    /dev/hdd:
     multcount     =  0 (off)
     IO_support    =  0 (default) 
     unmaskirq     =  0 (off)
     using_dma     =  1 (on)
     keepsettings  =  0 (off)
     readonly      =  0 (off)
     readahead     = 256 (on)
     geometry      = 24321/255/63, sectors = 390721968, start = 0

Here a screenshot of `sdparm` on Ubuntu 10.10.

    root@ubu1010:~# aptitude install sdparm
    ...
    root@ubu1010:~# sdparm /dev/sda | head -1
        /dev/sda: ATA       FUJITSU MJA2160B  0081
    root@ubu1010:~# man sdparm

Use `hdparm` and `sdparm` with care.
