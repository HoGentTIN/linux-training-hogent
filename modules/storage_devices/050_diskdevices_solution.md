## solution: hard disk devices

1\. Use `dmesg` to make a list of hard disk devices detected at boot-up.

    Some possible answers...

    dmesg | grep -i disk

    Looking for ATA disks: dmesg | grep hd[abcd]

    Looking for ATA disks: dmesg | grep -i "ata disk"

    Looking for SCSI disks: dmesg | grep sd[a-f]

    Looking for SCSI disks: dmesg | grep -i "scsi disk"

2\. Use `fdisk` to find the total size of all hard disk devices on your
system.

    fdisk -l

3\. Stop a virtual machine, add three virtual 1 gigabyte `scsi` hard
disk devices and one virtual 400 megabyte `ide` hard disk device. If
possible, also add another virtual 400 megabyte `ide` disk.

    This exercise happens in the settings of vmware or VirtualBox.

4\. Use `dmesg` to verify that all the new disks are properly detected
at boot-up.

    See 1.

5\. Verify that you can see the disk devices in `/dev`.

    SCSI+SATA: ls -l /dev/sd*

    ATA: ls -l /dev/hd*

6\. Use `fdisk` (with `grep` and `/dev/null`) to display the total size
of the new disks.

    root@linux ~# fdisk -l 2>/dev/null | grep [MGT]B
    Disk /dev/hda: 21.4 GB, 21474836480 bytes
    Disk /dev/hdb: 1073 MB, 1073741824 bytes
    Disk /dev/sda: 2147 MB, 2147483648 bytes
    Disk /dev/sdb: 2147 MB, 2147483648 bytes
    Disk /dev/sdc: 2147 MB, 2147483648 bytes

7\. Use `badblocks` to completely erase one of the smaller hard disks.

    #Verify the device (/dev/sdc??) you want to erase before typing this.
    #
    root@linux ~# badblocks -ws /dev/sdc
    Testing with pattern 0xaa: done                                
    Reading and comparing: done                                
    Testing with pattern 0x55: done                                
    Reading and comparing: done                                
    Testing with pattern 0xff: done                                
    Reading and comparing: done                                
    Testing with pattern 0x00: done                                
    Reading and comparing: done

8\. Look at `/proc/scsi/scsi`.

    root@linux ~# cat /proc/scsi/scsi 
    Attached devices:
    Host: scsi0 Channel: 00 Id: 02 Lun: 00
      Vendor: VBOX     Model: HARDDISK         Rev: 1.0 
      Type:   Direct-Access                    ANSI SCSI revision: 05
    Host: scsi0 Channel: 00 Id: 03 Lun: 00
      Vendor: VBOX     Model: HARDDISK         Rev: 1.0 
      Type:   Direct-Access                    ANSI SCSI revision: 05
    Host: scsi0 Channel: 00 Id: 06 Lun: 00
      Vendor: VBOX     Model: HARDDISK         Rev: 1.0 
      Type:   Direct-Access                    ANSI SCSI revision: 05

9\. If possible, install `lsscsi`, `lshw` and use them to list the
disks.

    Debian,Ubuntu: aptitude install lsscsi lshw

    Fedora: yum install lsscsi lshw

    root@linux ~# lsscsi 
    [0:0:2:0]    disk    VBOX     HARDDISK         1.0   /dev/sda
    [0:0:3:0]    disk    VBOX     HARDDISK         1.0   /dev/sdb
    [0:0:6:0]    disk    VBOX     HARDDISK         1.0   /dev/sdc

