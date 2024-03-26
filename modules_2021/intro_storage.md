# Introduction to storage

## Introduction

There are four major components to managing local storage, each
component has its own chapter. Each component is mandatory prerequisite
knowledge for the other storage chapters.

-   Detecting hardware (this chapter)

-   Creating partitions (next chapter)

-   Creating filesystems

-   Mounting filesystems

The following chapters will continue this storage story.

-   Troubleshooting storage

-   UUIDs

-   RAID

-   LVM

-   iSCSI

-   multipath devices

For the screenshots we installed Debian 10 on a server named
**server2**. This server has three extra 144GiB hard disks.

## hard disk

A hard disk can either be a spinning disk, with tracks, heads and
cylinders, or a Solid State Drive. A spinning hard disk has several
platters with data in concentric circles called tracks. All tracks on
top of each other are called cylinders. The magnetic reading and writing
is done by heads that almost touch each side of the platters (except
maybe the outside of the stack).

An SSD or Solid State Drive is new technology that contains no moving
parts. Currently in 2019 SSDs are more expensive per megabyte than
spinning disks.

## block device


A block device is a storage device with random access. Each block has an
address and can be read and/or written to. Block devices can be
recognised by the letter **b** as the first character in the output of
**ls -l**.

    root@server2:# ls -l /dev | grep ^b
    brw-rw---- 1 root disk      8,   0 Aug 22 19:12 sda
    brw-rw---- 1 root disk      8,   1 Aug 22 19:12 sda1
    brw-rw---- 1 root disk      8,   2 Aug 22 19:12 sda2
    brw-rw---- 1 root disk      8,   5 Aug 22 19:12 sda5
    brw-rw---- 1 root disk      8,  16 Aug 22 19:12 sdb
    brw-rw---- 1 root disk      8,  32 Aug 22 19:12 sdc
    brw-rw---- 1 root disk      8,  48 Aug 22 19:12 sdd
    root@server2:#

A hard disk is a block device, and so is a **RAID**, **LVM**, **iSCSI**
or **multipath** device. What we learn here about simple hard disk
devices will be applicable later for all block devices.

In this book we picture these four hard disk (or any block devices) as
follows.

<figure>
<img src="images/block_device.svg" alt="images/block_device.svg" />
</figure>

## lsblk


All block devices on a Debian Linux computer can be displayed using the
**lsblk** command. Compare the output with the screenshot from **/dev/**
from above.

    root@server2:# lsblk -i
    NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda      8:0    0   16G  0 disk
    |-sda1   8:1    0   15G  0 part /
    |-sda2   8:2    0    1K  0 part
    `-sda5   8:5    0 1022M  0 part [SWAP]
    sdb      8:16   0  144G  0 disk
    sdc      8:32   0  144G  0 disk
    sdd      8:48   0  144G  0 disk
    root@server2:#

Now that we know the sizes of these hard disks, we can update our
drawing. You may want to browse Wikipedia on **kibi**byte versus
**kilo**byte here <https://en.wikipedia.org/wiki/Kibibyte> .

<figure>
<img src="images/block_device1.svg" alt="images/block_device1.svg" />
</figure>

## /dev/sd\*


In Debian 10 almost all block devices use the **sd** driver for SCSI
disk devices and thus get a **/dev/sd** device name. This includes extra
hard disks, extra USB sticks, well every new block device.

You can look in **/proc/devices** to verify the driver for a major
number. The **major number** of a device is visible in the **ls -l**
output and corresponds to the driver in use for this device.

    root@server2:/proc# grep sd /proc/devices | head -5
      8 sd
     65 sd
     66 sd
     67 sd
     68 sd
    root@server2:/proc#

In our Debian 10 server the first hard disk is known as **/dev/sda**,
the second to fourth are known as **/dev/sdb**, **/dev/sdc**, and
**/dev/sdd**.

    root@server2:# ls /dev/sd* 
    /dev/sda  /dev/sda1  /dev/sda2  /dev/sda5  /dev/sdb  /dev/sdc  /dev/sdd
    root@server2:#

## fdisk -l

The tool most people use to manage disks is called **fdisk**. Typing
**fdisk -l** will list the attached block devices. The names of the
block devices should be familiar by now.

    root@server2:# fdisk -l | grep sd
    Disk /dev/sda: 16 GiB, 17179869184 bytes, 33554432 sectors
    /dev/sda1  *        2048 31457279 31455232   15G 83 Linux
    /dev/sda2       31459326 33552383  2093058 1022M  5 Extended
    /dev/sda5       31459328 33552383  2093056 1022M 82 Linux swap / Solaris
    Disk /dev/sdb: 144 GiB, 154618822656 bytes, 301989888 sectors
    Disk /dev/sdc: 144 GiB, 154618822656 bytes, 301989888 sectors
    Disk /dev/sdd: 144 GiB, 154618822656 bytes, 301989888 sectors
    root@server2:#

## dmesg

The **dmesg** command will display messages from the kernel (including
when it was booting) and can provide some information on attached
storage devices. In the screenshot we query **dmesg** for messages
regarding **sdd**.

    root@server2:# dmesg | grep sdd
    [    3.052894] sd 5:0:0:0: [sdd] 301989888 512-byte logical blocks: (155 GB/144 GiB)
    [    3.052896] sd 5:0:0:0: [sdd] Write Protect is off
    [    3.052897] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
    [    3.052901] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [    3.053928] sd 5:0:0:0: [sdd] Attached SCSI disk
    root@server2:#

## lshw

The **lshw** tool can be installed with **apt-get install lshw**. It
will give information on all hardware and how it is connected to your
computer. Look for **disk** and find the SCSI connections.

    root@server2:# lshw | grep -A1 -i SCSI
                 logical name: scsi0
                 logical name: scsi1
                 logical name: scsi2
                 logical name: scsi3
                 version: 02
    --
                    bus info: scsi@0:0.0.0
                    logical name: /dev/sda
    --
                       bus info: scsi@0:0.0.0,1
                       logical name: /dev/sda1
    --
                       bus info: scsi@0:0.0.0,2
                       logical name: /dev/sda2
    --
                    bus info: scsi@1:0.0.0
                    logical name: /dev/sdb
    --
                    bus info: scsi@2:0.0.0
                    logical name: /dev/sdc
    --
                    bus info: scsi@3:0.0.0
                    logical name: /dev/sdd
    root@server2:#

## lsscsi

The **lsscsi** tool can be installed with **apt-get install lsscsi**.
This tool can display SCSI devices in several output formats.

    root@server2:# lsscsi --brief
    [0:0:0:0]    /dev/sda
    [1:0:0:0]    /dev/sdb
    [2:0:0:0]    /dev/sdc
    [3:0:0:0]    /dev/sdd
    root@server2:#

## Cheat sheet

<table>
<caption>Introduction to storage</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>lsblk</p></td>
<td style="text-align: left;"><p>List block devices.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>fdisk -l</p></td>
<td style="text-align: left;"><p>List block devices with more
information.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>dmesg</p></td>
<td style="text-align: left;"><p>Display kernel messages (including
detection of block devices)..</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>lshw</p></td>
<td style="text-align: left;"><p>List hardware (including block
devices).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>lsscsi</p></td>
<td style="text-align: left;"><p>List SCSI devices.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/proc/devices</p></td>
<td style="text-align: left;"><p>Location that shows the link between
major numbers and drivers.</p></td>
</tr>
</tbody>
</table>

Introduction to storage

## Practice

1.  Prepare a (virtual) server with at least three extra disks.

2.  List all block devices in **/dev**.

3.  List all block devices on the computer (not using ls).

4.  Verify that the block devices use the **sd** driver.

5.  Use **fdisk** to list all disks.

6.  Use **lsscsi** to list all SCSI devices.

7.  Use **lshw** and look at the complete device tree.

## Solution

1.  Prepare a (virtual) server with at least three extra disks.

        If you don't have a real server then you can use Vmware or Virtualbox,
        and add three extra virtual disks.
        Or use a Raspberry Pi with three old USB sticks.

2.  List all block devices in **/dev**.

        ls -l /dev | grep ^b

3.  List all block devices on the computer (not using ls).

        lsblk

4.  Verify that the block devices use the **sd** driver.

        Check the major number (probably 8) in cat /proc/devices.

5.  Use **fdisk** to list all disks.

        fdisk -l

6.  Use **lsscsi** to list all SCSI devices.

        apt-get install lsscsi
        lsscsi

7.  Use **lshw** and look at the complete device tree.

        apt-get install lshw
        lshw
