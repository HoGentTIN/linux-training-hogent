# UUID’s

## Problem with /dev/sd\*


Up until now we have been using **/dev/sd**\* to refer to disks and
partitions. There is problem with this, namely that those names are not
persistent. What is **/dev/sdc** today may be **/dev/sdb** tomorrow (by
removing the old /dev/sdb for example).

Luckily there is a solution for this because every filesystem has a
unique identifier.

## What is a UUID?


A **UUID** is a Universally Unique Identifier. In other words it is a
very big unique number. There are many tools to create a **UUID**, on
Debian Linux we have **dbus-uuidgen**.

    root@server2:# dbus-uuidgen
    afac8abf786bfaa2fe2e17d25d668787
    root@server2:# dbus-uuidgen
    81f63c400031e7ea4f07b6075d668789
    root@server2:# dbus-uuidgen
    6a00dc58cba70ea97e6ccd185d66878f
    root@server2:#

## tune2fs


Every filesystem that is created in Debian Linux will get a UUID. You
can find the UUID using **tune2fs** as shown in this screenshot.

    root@server2:# tune2fs -l /dev/sdd1 | grep UUID
    Filesystem UUID:          9d27f1b0-65f5-44ed-a3c4-2efbffbf6d94
    root@server2:#

## blkid and lsblk


You can also use **blkid** or **lsblk** to find the UUID. Note that the
UUID for the partition is different from the UUID for the filesystem.

    root@server2:# blkid | grep sdd1
    /dev/sdd1: UUID="9d27f1b0-65f5-44ed-a3c4-2efbffbf6d94" TYPE="ext4" PARTUUID="19637ce0-f08d-6144-90af-d981c6b69c73"
    root@server2:# lsblk -f | grep sdd1
    |-sdd1 ext4         9d27f1b0-65f5-44ed-a3c4-2efbffbf6d94    9.2G     0% /srv/pro33
    root@server2:~#

## /etc/fstab


You may have noticed that there are already UUIDs in the **/etc/fstab**
file. This is to make sure that the correct filesystem is mounted at the
correct mount point.

    root@server2:# tail -7 /etc/fstab
    # / was on /dev/sda1 during installation
    UUID=9ea6c2b3-1ad2-4209-ba06-19af4027b6f8 /               ext4    errors=remount-ro 0       1
    # swap was on /dev/sda5 during installation
    UUID=89854b55-bfab-4c61-8bbb-aaa40c7154aa none            swap    sw              0       0
    /dev/sr0        /media/cdrom0   udf,iso9660 user,noauto     0       0
    /dev/sdb1 /srv/pro42 ext4 defaults 0 0
    /dev/sdd1 /srv/pro33 auto acl 0 0
    root@server2:#

The line that starts with **/dev/sdd1** can be improved by using the
filesystem’s UUID instead of **/dev/sdd1**. We found the UUID in the
screenshots above, so the last line in **/etc/fstab** becomes this.

    root@server2:# tail -7 /etc/fstab
    # / was on /dev/sda1 during installation
    UUID=9ea6c2b3-1ad2-4209-ba06-19af4027b6f8 /               ext4    errors=remount-ro 0       1
    # swap was on /dev/sda5 during installation
    UUID=89854b55-bfab-4c61-8bbb-aaa40c7154aa none            swap    sw              0       0
    /dev/sr0        /media/cdrom0   udf,iso9660 user,noauto     0       0
    /dev/sdb1 /srv/pro42 ext4 defaults 0 0
    UUID="9d27f1b0-65f5-44ed-a3c4-2efbffbf6d94" /srv/pro33 auto acl 0 0
    root@server2:#

You can get the UUID in vi by typing **Esc :r !blkid /dev/sdd1** .

Note that you can still use the device name with the **mount** command,
even though the device is not mentioned in **/etc/fstab**. The **mount**
tool will search for this device. It may be safer to use the mount
point.

    root@server2:/boot/grub# umount /dev/sdd1
    root@server2:/boot/grub# mount /dev/sdd1
    root@server2:/boot/grub# umount /dev/sdd1
    root@server2:/boot/grub# mount /srv/pro33/
    root@server2:/boot/grub#

## grub2

We will see later in this book that Debian Linux boots from a UUID. So
even if **/dev/sda** changes, the system will still boot properly.

## Cheat sheet

<table>
<caption>UUID’s</caption>
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
<td style="text-align: left;"><p>dbus-uuidgen</p></td>
<td style="text-align: left;"><p>Create a UUID.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tune2fs -l /dev/foo1</p></td>
<td style="text-align: left;"><p>List UUID (and other parameters) of the
partition <strong>/dev/foo1</strong> partition.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>blkid</p></td>
<td style="text-align: left;"><p>Lists partition UUID (and other
information).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>lsblk -f</p></td>
<td style="text-align: left;"><p>Lists file system UUID’s.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/fstab</p></td>
<td style="text-align: left;"><p>Can contain UUID’s as identifier to
mount a file system.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grub2</p></td>
<td style="text-align: left;"><p>Tool to boot Debian Linux which
identifies the root file system by UUID.</p></td>
</tr>
</tbody>
</table>

UUID’s

## Practice

1.  Use **tune2fs** and **blkid** to find the UUID of a filesystem.
    Verify that both UUIDs are identical.

2.  Add two of your filesystems with their UUID to **/etc/fstab** . Make
    sure to remove the old entry with **/dev/sd**.

3.  Test with the mount command that your entries in **/etc/fstab** work
    properly.

## Solution

1.  Use **tune2fs** and **blkid** to find the UUID of a filesystem.
    Verify that both UUIDs are identical.

        tune2fs -l /dev/sdc1
        blkid | grep sdc1

2.  Add two of your filesystems with their UUID to **/etc/fstab** . Make
    sure to remove the old entry with **/dev/sd**.

        vi /etc/fstab

3.  Test with the mount command that your entries in **/etc/fstab** work
    properly.

        umount /srv/pro33
        mount /srv/pro33
        umount /srv/pro42
        mount /srv/pro42
