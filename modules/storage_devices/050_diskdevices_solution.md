## solution: hard disk devices

The following results were obtained on a VirtualBox VM with AlmaLinux 9 with 3 extra SATA disks and 1 extra IDE disk (see assignment above).

1. Use `lsblk` and `fdisk` to make a list of detected hard disk devices and their properties.

    ```console
    [student@el ~]$ lsblk 
    NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
    sda      8:0    0  64G  0 disk 
    ├─sda1   8:1    0   2G  0 part [SWAP]
    └─sda2   8:2    0  62G  0 part /
    sdb      8:16   0  20G  0 disk 
    sdc      8:32   0  20G  0 disk 
    sdd      8:48   0  20G  0 disk 
    [student@el ~]$ sudo fdisk -l | grep -i disk
    Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
    Disk model: VBOX HARDDISK   
    Disklabel type: dos
    Disk identifier: 0x0732c2c4
    Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
    Disk model: VBOX HARDDISK   
    Disk /dev/sdc: 20 GiB, 21474836480 bytes, 41943040 sectors
    Disk model: VBOX HARDDISK   
    Disk /dev/sdd: 20 GiB, 21474836480 bytes, 41943040 sectors
    Disk model: VBOX HARDDISK 
    ```

2. Use `dmesg` to look in the boot messages for information about the hard disks.

    ```console
    [student@el ~]$ sudo dmesg | grep '\bsd[a-z]\b'
    [    5.696395] sd 0:0:0:0: [sda] 134217728 512-byte logical blocks: (68.7 GB/64.0 GiB)
    [    5.696400] sd 0:0:0:0: [sda] Write Protect is off
    [    5.696401] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
    [    5.696405] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.696412] sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
    [    5.696575] sd 2:0:0:0: [sdb] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
    [    5.696578] sd 2:0:0:0: [sdb] Write Protect is off
    [    5.696579] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
    [    5.696584] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.696590] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
    [    5.696750] sd 4:0:0:0: [sdc] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
    [    5.696753] sd 4:0:0:0: [sdc] Write Protect is off
    [    5.696753] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
    [    5.696758] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.696764] sd 4:0:0:0: [sdc] Preferred minimum I/O size 512 bytes
    [    5.696870] sd 2:0:0:0: [sdb] Attached SCSI disk
    [    5.696876]  sda: sda1 sda2
    [    5.696897] sd 4:0:0:0: [sdc] Attached SCSI disk
    [    5.696917] sd 0:0:0:0: [sda] Attached SCSI disk
    [    5.696943] sd 5:0:0:0: [sdd] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
    [    5.696946] sd 5:0:0:0: [sdd] Write Protect is off
    [    5.696947] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
    [    5.696951] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.696957] sd 5:0:0:0: [sdd] Preferred minimum I/O size 512 bytes
    [    5.697130] sd 5:0:0:0: [sdd] Attached SCSI disk
    [    8.827620] block sda: the capability attribute has been deprecated.
    ```

3. Verify that you can see the disk devices in `/dev`.

    ```console
    [student@el ~]$ ls -l /dev/sd*
    brw-rw----. 1 root disk 8,  0 Nov 10 15:48 /dev/sda
    brw-rw----. 1 root disk 8,  1 Nov 10 15:48 /dev/sda1
    brw-rw----. 1 root disk 8,  2 Nov 10 15:48 /dev/sda2
    brw-rw----. 1 root disk 8, 16 Nov 10 15:48 /dev/sdb
    brw-rw----. 1 root disk 8, 32 Nov 10 15:48 /dev/sdc
    brw-rw----. 1 root disk 8, 48 Nov 10 15:48 /dev/sdd
    ```

4. Turn off the virtual machine, add an **IDE disk** of size 128MB and boot.

    > The IDE disk is now added to the VM and made available under `/dev/sda` (which comes as a bit of a surprise, as `/dev/hda` was expected). Peruse the output of `lshw` (without filtering out any information) to verify that indeed, the new disk is recognized as an IDE device and the others as SATA devices.

5. Repeat exercises 1 - 3 and check that the new IDE disk is detected.

    ```console
    [student@el ~]$ lsblk 
    NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
    sda      8:0    0  128M  0 disk 
    sdb      8:16   0   64G  0 disk 
    ├─sdb1   8:17   0    2G  0 part [SWAP]
    └─sdb2   8:18   0   62G  0 part /
    sdc      8:32   0   20G  0 disk 
    sdd      8:48   0   20G  0 disk 
    sde      8:64   0   20G  0 disk 
    [student@el ~]$ sudo fdisk -l | grep -i disk
    Disk /dev/sda: 128 MiB, 134217728 bytes, 262144 sectors
    Disk model: VBOX HARDDISK   
    Disk /dev/sdb: 64 GiB, 68719476736 bytes, 134217728 sectors
    Disk model: VBOX HARDDISK   
    Disklabel type: dos
    Disk identifier: 0x0732c2c4
    Disk /dev/sdc: 20 GiB, 21474836480 bytes, 41943040 sectors
    Disk model: VBOX HARDDISK   
    Disk /dev/sdd: 20 GiB, 21474836480 bytes, 41943040 sectors
    Disk model: VBOX HARDDISK   
    Disk /dev/sde: 20 GiB, 21474836480 bytes, 41943040 sectors
    Disk model: VBOX HARDDISK  
    [student@el ~]$ sudo dmesg | grep '\bsd[a-z]\b'
    [sudo] password for student: 
    [    5.691024] sd 0:0:0:0: [sda] 262144 512-byte logical blocks: (134 MB/128 MiB)
    [    5.691029] sd 0:0:0:0: [sda] Write Protect is off
    [    5.691030] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
    [    5.691034] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.691041] sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
    [    5.691409] sd 0:0:0:0: [sda] Attached SCSI disk
    [    5.691499] sd 2:0:0:0: [sdb] 134217728 512-byte logical blocks: (68.7 GB/64.0 GiB)
    [    5.691502] sd 2:0:0:0: [sdb] Write Protect is off
    [    5.691503] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
    [    5.691508] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.691515] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
    [    5.691879] sd 3:0:0:0: [sdc] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
    [    5.691882] sd 3:0:0:0: [sdc] Write Protect is off
    [    5.691883] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
    [    5.691888] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.691905] sd 3:0:0:0: [sdc] Preferred minimum I/O size 512 bytes
    [    5.692152]  sdb: sdb1 sdb2
    [    5.692187] sd 2:0:0:0: [sdb] Attached SCSI disk
    [    5.692380] sd 3:0:0:0: [sdc] Attached SCSI disk
    [    5.692738] sd 4:0:0:0: [sdd] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
    [    5.692741] sd 4:0:0:0: [sdd] Write Protect is off
    [    5.692742] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
    [    5.692746] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.692751] sd 4:0:0:0: [sdd] Preferred minimum I/O size 512 bytes
    [    5.692935] sd 4:0:0:0: [sdd] Attached SCSI disk
    [    5.693439] sd 5:0:0:0: [sde] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
    [    5.693442] sd 5:0:0:0: [sde] Write Protect is off
    [    5.693443] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
    [    5.693447] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    5.693455] sd 5:0:0:0: [sde] Preferred minimum I/O size 512 bytes
    [    5.693736] sd 5:0:0:0: [sde] Attached SCSI disk
    [    8.034556] block sdb: the capability attribute has been deprecated.
    [student@el ~]$ ls -l /dev/[sh]d*
    brw-rw----. 1 root disk 8,  0 Nov 10 16:00 /dev/sda
    brw-rw----. 1 root disk 8, 16 Nov 10 15:53 /dev/sdb
    brw-rw----. 1 root disk 8, 17 Nov 10 15:53 /dev/sdb1
    brw-rw----. 1 root disk 8, 18 Nov 10 15:53 /dev/sdb2
    brw-rw----. 1 root disk 8, 32 Nov 10 15:53 /dev/sdc
    brw-rw----. 1 root disk 8, 48 Nov 10 15:53 /dev/sdd
    brw-rw----. 1 root disk 8, 64 Nov 10 15:53 /dev/sde
    ```

6. Install `lsscsi`, `lshw`, `hdparm`, and `sdparm`. Use them to find information about the disks.

    ```console
    [student@el ~]$ lsscsi
    [0:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sda 
    [2:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdb 
    [3:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdc 
    [4:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdd 
    [5:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sde 
    [student@el ~]$ sudo lshw -class disk
    *-disk                    
        description: ATA Disk
        product: VBOX HARDDISK
        vendor: VirtualBox
        physical id: 0.0.0
        bus info: scsi@0:0.0.0
        logical name: /dev/sda
        version: 1.0
        serial: VB434d45f2-a6322d0b
        size: 128MiB (134MB)
        configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512
    [... some output omitted for brevity ...]
    *-disk:3
        description: ATA Disk
        product: VBOX HARDDISK
        vendor: VirtualBox
        physical id: 3
        bus info: scsi@5:0.0.0
        logical name: /dev/sde
        version: 1.0
        serial: VBc4020207-5d756530
        size: 20GiB (21GB)
        configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512
    [student@el ~]$ sudo hdparm /dev/sda
    /dev/sda:
    multcount     = 128 (on)
    IO_support    =  1 (32-bit)
    readonly      =  0 (off)
    readahead     = 256 (on)
    geometry      = 16/255/63, sectors = 262144, start = 0
    [student@el ~]$ sudo hdparm /dev/sdb
    /dev/sdb:
    multcount     = 128 (on)
    IO_support    =  1 (32-bit)
    readonly      =  0 (off)
    readahead     = 256 (on)
    geometry      = 8354/255/63, sectors = 134217728, start = 0
    [student@el ~]$ sudo hdparm /dev/sdc
    /dev/sdc:
    multcount     = 128 (on)
    IO_support    =  1 (32-bit)
    readonly      =  0 (off)
    readahead     = 256 (on)
    geometry      = 2610/255/63, sectors = 41943040, start = 0
    [student@el ~]$ sudo sdparm /dev/sdb
    /dev/sdb: ATA       VBOX HARDDISK     1.0 
    Read write error recovery mode page:
    AWRE          1  [cha: n, def:  1]
    ARRE          0  [cha: n, def:  0]
    PER           0  [cha: n, def:  0]
    Caching (SBC) mode page:
    IC            0  [cha: n, def:  0]
    WCE           1  [cha: y, def:  1]
    RCD           0  [cha: n, def:  0]
    Control mode page:
    TST           0  [cha: n, def:  0]
    SWP           0  [cha: n, def:  0]
    [student@el ~]$ sudo sdparm /dev/sdc
        /dev/sdc: ATA       VBOX HARDDISK     1.0 
    Read write error recovery mode page:
    AWRE          1  [cha: n, def:  1]
    ARRE          0  [cha: n, def:  0]
    PER           0  [cha: n, def:  0]
    Caching (SBC) mode page:
    IC            0  [cha: n, def:  0]
    WCE           1  [cha: y, def:  1]
    RCD           0  [cha: n, def:  0]
    Control mode page:
    TST           0  [cha: n, def:  0]
    SWP           0  [cha: n, def:  0]
    ```

    > Be sure to try `hdparm` with the `-i` and `-I` options as well.

7. Use `badblocks` to completely erase the small IDE disk.

    > On this disk, the process was actually quite fast. We timed the process and it took less than 2 seconds:

    ```console
    [student@el ~]$ time sudo badblocks -ws /dev/sda
    Testing with pattern 0xaa: done                                                 
    Reading and comparing: done                                                 
    Testing with pattern 0x55: done                                                 
    Reading and comparing: done                                                 
    Testing with pattern 0xff: done                                                 
    Reading and comparing: done                                                 
    Testing with pattern 0x00: done                                                 
    Reading and comparing: done                                                 

    real    0m1.902s
    user    0m0.056s
    sys     0m0.106s
    ```

