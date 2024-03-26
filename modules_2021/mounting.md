# File system mounting

This chapter is the fourth and final component of **basic storage
introduction**. The first is recognising hardware, the second is
partitioning and the third is filesystems.

## mount


To be able to use a filesystem, we need to mount it to a **mount
point**. The **mount point** is a directory that we create for this
purpose. For example, if we want to share the filesystem on /dev/sdb1
for the **project 42** group, then we create **/srv/pro42**.

    root@server2:# mkdir /srv/pro42
    root@server2:#

The next step is to link this directory to the filesystem on /dev/sdb1,
in other words, we **mount** the filesystem on **/srv/pro42** .

    root@server2:# mount /dev/sdb1 /srv/pro42/
    root@server2:#

From now on, whenever your create a file or directory in
**/srv/pro42/**, then you create these on the filesystem on /dev/sdb1.

    root@server2:# echo Hello > /srv/pro42/welcome.txt
    root@server2:#

## df


You can see mounted filesystems with the **df** tool. The **-h** option
gives a human readable output for the sizes in multiples of kibibytes.
Using **-H** will use multiples of kilobytes.

    root@server2:# df -h | grep sdb
    /dev/sdb1        20G   45M   19G   1% /srv/pro42
    root@server2:#

The **-T** option will add the filesystem to the output of **df** .

    root@server2:# df -Th | grep sdb
    /dev/sdb1      ext4       20G   45M   19G   1% /srv/pro42
    root@server2:#

## du -sh


You can use **du -sh** to obtain the total size of a directory. In this
case the directory is a mount point, so you get the total size of all
files on the mounted filesystem.

    root@server2:# du -sh /srv/pro42/
    24K     /srv/pro42/
    root@server2:#

## /proc/mounts


Your **mount** is visible also in **/proc/mounts** and in **/etc/mtab**
(the latter is a link to the former now). The **/proc/mounts** file
holds information about what the **kernel** thinks is mounted.

    root@server2:# grep sdb /proc/mounts
    /dev/sdb1 /srv/pro42 ext4 rw,relatime 0 0
    root@server2:# grep sdb /etc/mtab
    /dev/sdb1 /srv/pro42 ext4 rw,relatime 0 0
    root@server2:# file /etc/mtab
    /etc/mtab: symbolic link to ../proc/self/mounts
    root@server2:#

## umount


A **mounted** filesystem can be unmounted with the **umount** command.
This can be done either by using the mount point or by using the device.

    root@server2:# umount /srv/pro42
    root@server2:# mount /dev/sdb1 /srv/pro42/
    root@server2:# umount /dev/sdb1
    root@server2:#

## /etc/fstab


The **file system table** can contain an entry for each filesystem that
can be mounted. The required fields are **device, mountpoint, filesystem
type, options, dump, and fsck**. The device is of course /dev/sdb1, the
mountpoint is /srv/pro42, the filesystem type is ext4 (but you can put
**auto** here), we use no options, so the **defaults** keyword is
mandatory, and we don’t want backups, nor filesystem checks at boot
time.

    root@server2:# echo "/dev/sdb1 /srv/pro42 ext4 defaults 0 0" >> /etc/fstab
    root@server2:#

This line will make sure the filesystem is mounted automatically at
boot. It also enables us to type **mount /srv/pro42** or **mount
/dev/sdb1** as the mount command will look in **/etc/fstab**.

    root@server2:# mount /srv/pro42/
    root@server2:#

## mount options

Several **mount options** can be used when mounting a filesystem. These
options can be typed with a mount command, or can be set in
**/etc/fstab**. A common option for troubleshooting a filesystem is
**ro** to mount it as **read only**.

    root@server2:# umount /srv/pro42
    root@server2:# mount -o ro /srv/pro42/
    root@server2:# touch /srv/pro42/nope
    touch: cannot touch '/srv/pro42/nope': Read-only file system
    root@server2:#

The **umount** and then **mount** combo can be avoided with the
**remount** option. Using **remount** will keep the filesystem mounted
while changing the options.

    root@server2:# mount -o remount,ro /srv/pro42/
    root@server2:#

An option that we discussed in the **ACLs** chapter is to mount a
filesystem with ACL support. In this screenshot we add a line to
**/etc/fstab** to automatically **mount** the /dev/sdd1 device with ACL
support. (The defaults keyword can then be omitted.)

    root@server2:# echo '/dev/sdd1 /srv/pro33 auto acl 0 0' >> /etc/fstab
    root@server2:#

## securing mounts

We already discussed the **ro** option to mount a filesystem **read
only**. Not even root can then write to the filesystem. There are some
other interesting security options.

The **noexec** option prevents execution of binaries or scripts from the
filesystem. In the screenshot below we mount with this option and verify
that not even root can start a script from this filesystem.

    root@server2:# mount -o noexec,remount /srv/pro33/
    root@server2:# echo echo hello > /srv/pro33/script.sh
    root@server2:# chmod +x /srv/pro33/script.sh
    root@server2:# /srv/pro33/script.sh
    -bash: /srv/pro33/script.sh: Permission denied
    root@server2:~#

In much the same way you can use the **nosuid** option and the **noacl**
option.

## Cheat sheet

<table>
<caption>Mounting</caption>
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
<td style="text-align: left;"><p>mount foo bar</p></td>
<td style="text-align: left;"><p>Mount the <strong>foo</strong> file
system on the <strong>bar</strong> directory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>mount -o ro foo bar</p></td>
<td style="text-align: left;"><p>Mount the <strong>foo</strong> file
system read only on the <strong>bar</strong> directory.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mount -o noexec foo bar</p></td>
<td style="text-align: left;"><p>Mount the <strong>foo</strong> file
system on the <strong>bar</strong> directory, but prevent execution on
that mount.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>df -h</p></td>
<td style="text-align: left;"><p>Display information about mounted file
systems.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>du -sh foo</p></td>
<td style="text-align: left;"><p>Display the total size of the
<strong>foo</strong> directory/mount point.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>mount</p></td>
<td style="text-align: left;"><p>Display information about all
mounts.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>umount foo</p></td>
<td style="text-align: left;"><p>Unmount the <strong>foo</strong> file
system/directory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cat /proc/mounts</p></td>
<td style="text-align: left;"><p>Display kernel information about all
mounts.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/fstab</p></td>
<td style="text-align: left;"><p>File that contains information about
file systems to mount at boot.</p></td>
</tr>
</tbody>
</table>

Mounting

## Practice

1.  Choose a free disk, create a GPT label on it and five partitions.

2.  Create an **ext4** filesystem on two of the partitions.

3.  Create two mount points, one for project42 shared, one for project33
    local.

4.  Mount the two **ext4** filesystems on the mount points.

5.  Add two lines for these mounts to **/etc/fstab**.

6.  Test the lines in **/etc/fstab** by mounting then with one parameter
    to the **mount** command.

7.  View your mounts with the **df** and the **mount** command.

## Solution

1.  Choose a free disk, create a GPT label on it and five partitions.

        fdisk /dev/sdd
        g
        n n n n n
        w

2.  Create an **ext4** filesystem on two of the partitions.

        mkfs.ext4 /dev/sdd1
        mkfs.ext4 /dev/sdd2

3.  Create two mount points, one for project42 shared, one for project33
    local.

        mkdir /srv/pro42
        mkdir /home/pro33

4.  Mount the two **ext4** filesystems on the mount points.

        mount /dev/sdd1 /srv/pro42
        mount /dev/sdd2 /home/pro33

5.  Add two lines for these mounts to **/etc/fstab**.

        echo '/dev/sdd1  /srv/pro42  auto defaults 0 0' >> /etc/fstab
        echo '/dev/sdd2  /home/pro33  auto defaults 0 0' >> /etc/fstab

6.  Test the lines in **/etc/fstab** by mounting then with one parameter
    to the **mount** command.

        umount /dev/sdd1
        mount /dev/sdd1
        umount /dev/sdd1
        mount /srv/pro42
        umount /dev/sdd2
        mount /dev/sdd2
        umount /dev/sdd2
        mount /home/pro33

7.  View your mounts with the **df** and the **mount** command.

        df -h
        mount
