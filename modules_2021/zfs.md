# ZFS

## Installing ZFS


Debian 10 Linux does not provide kernel modules for ZFS by default.
**<span class="red">The reason is there may be a licensing conflict
between GPL (the kernel license) and CDDL (the ZFS license).</span>**
This chapter is entirely optional!

If you still want to proceed, then ZFS is available in **contrib** (see
the Installing Software chapter). To install software from **contrib**
you need to change two lines in **/etc/apt/sources.list**. Take a backup
of this file, then add the word **contrib** to the following two lines.

    root@server2:/etc/apt# cp /etc/apt/sources.list /etc/apt/sources.original
    root@server2:/etc/apt# vi /etc/apt/sources.list
    root@server2:/etc/apt# grep contrib /etc/apt/sources.list
    deb http://deb.debian.org/debian/ buster main contrib
    deb-src http://deb.debian.org/debian/ buster main contrib
    root@server2:/etc/apt#

Then you can do **apt-get update** followed by **apt-get upgrade**. This
will refresh the list of all Debian packages available in **main** and
in **contrib**, followed by an installation of all available upgrades
(if there are any).

Then issue these two commands to install the **ZFS** kernel modules.
These commands may take a while to complete since a lot of stuff is
compiled from source.

    apt-get install spl-dkms
    apt-get install zfs-dkms

ZFS can take a lot of RAM memory, at least 4GB is recommended.

## Creating a basic ZFS pool


ZFS is a filesystem and a volume manager and a mount command. In the
screenshot below we use **zpool create** to create a striped volume, a
ZFS filesystem, a mount point and the ZFS volume is mounted on that
mount point all in one command.

    root@server2:# modprobe zfs
    root@server2:# zpool create mypool /dev/sdb /dev/sdc
    root@server2:# df -h | grep mypool
    mypool          278G     0  278G   0% /mypool
    root@server2:#

## Verifying a ZFS pool

Two useful commands for verifying a ZFS pool are **zpool list** for a
nice summary, and **zpool status** for device and data integrity
information.

    root@server2:# zpool list
    NAME     SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
    mypool   286G  1.19G   285G         -     0%     0%  1.00x  ONLINE  -
    root@server2:# zpool status mypool
      pool: mypool
     state: ONLINE
      scan: none requested
    config:

            NAME        STATE     READ WRITE CKSUM
            mypool      ONLINE       0     0     0
              sdb       ONLINE       0     0     0
              sdc       ONLINE       0     0     0

    errors: No known data errors
    root@server2:~#

The status of all pools can be quickly verified with **zpool status
-x**.

    root@server2:# zpool status -x
    all pools are healthy
    root@server2:#

## Destroying a ZFS pool

The **zpool destroy** command will unmount the ZFS filesystem, remove
the mount point, and destroy the ZFS pool. All data on the ZFS pool will
be lost.

    root@server2:# zpool destroy mypool
    root@server2:#

## Creating a ZFS RAID5 pool

The next **zpool create** command will create a RAID5 (called a RAIDZ by
ZFS) over three disks (/dev/sdb /dev/sdc /dev/sdd), will named the pool
**pro42pool**, and it will also create a custom mount point and mount
the filesystem on it.

    root@server2:# zpool create -m /srv/project42 pro42pool raidz sdb sdc sdd
    root@server2:# df -h | grep project42
    pro42pool       277G     0  277G   0% /srv/project42
    root@server2:~#

## Setting ZFS disk quota


In this example we create a ZFS filesystem (and mount point) and set a
30GB quota on it. Note that we use the **zfs** command instead of
**zpool**.

    root@server2:# zfs create pro42pool/div01
    root@server2:# zfs set quota=30G pro42pool/div01
    root@server2:# zfs list
    NAME              USED  AVAIL  REFER  MOUNTPOINT
    pro42pool         151K   276G  30.6K  /srv/project42
    pro42pool/div01  30.6K  30.0G  30.6K  /srv/project42/div01
    root@server2:#

## ZFS properties

There are many properties that you can set on a ZFS filesystem. You can
see them all with the **zfs get all** command as shown in this example.

    root@server2:# zfs get all pro42pool/div01 | head
    NAME             PROPERTY              VALUE                  SOURCE
    pro42pool/div01  type                  filesystem             -
    pro42pool/div01  creation              Sat Aug 31 17:45 2019  -
    pro42pool/div01  used                  30.6K                  -
    pro42pool/div01  available             30.0G                  -
    pro42pool/div01  referenced            30.6K                  -
    pro42pool/div01  compressratio         1.00x                  -
    pro42pool/div01  mounted               yes                    -
    pro42pool/div01  quota                 30G                    local
    pro42pool/div01  reservation           none                   default
    root@server2:#

### query individual properties

Using the **zfs get** command you can query for individual properties on
a zfs filesystem. In the example here we query for the **quota** we set
before.

    root@server2:# zfs get quota pro42pool/div01
    NAME             PROPERTY  VALUE  SOURCE
    pro42pool/div01  quota     30G    local
    root@server2:#

### Setting reserved disk space

One useful property is to set a minimum reserved space for a zfs
filesystem. Notice how the pool available space shrink 100GB when
reserving this space.

    root@server2:# zfs create pro42pool/div02
    root@server2:# zfs set reservation=100G pro42pool/div02
    root@server2:# zfs list
    NAME              USED  AVAIL  REFER  MOUNTPOINT
    pro42pool         100G   176G  32.0K  /srv/project42
    pro42pool/div01  30.6K  30.0G  30.6K  /srv/project42/div01
    pro42pool/div02  30.6K   276G  30.6K  /srv/project42/div02
    root@server2:#

### Activating compression

You can activate compression to save disk space. Don’t forget that
compressing twice is a waste of CPU power. The screenshot shows the
**zfs set compression=on** command.

    root@server2:# zfs get compression pro42pool/div01
    NAME             PROPERTY     VALUE     SOURCE
    pro42pool/div01  compression  off       local
    root@server2:# zfs set compression=on pro42pool/div01
    root@server2:# zfs get compression pro42pool/div01
    NAME             PROPERTY     VALUE     SOURCE
    pro42pool/div01  compression  on        local
    root@server2:#

## Monitoring ZFS


There is **zpool iostat** command to monitor a zpool every x seconds. In
the screenshot we ask for statistics every two seconds.

    root@server2:~# zpool iostat 2
                  capacity     operations     bandwidth
    pool        alloc   free   read  write   read  write
    ----------  -----  -----  -----  -----  -----  -----
    pro42pool    210M   428G      0      1     52  19.6K
    pro42pool    634M   427G      0  18.9K      0   170M
    pro42pool    869M   427G      0  7.11K      0  85.7M

Use **zpool iostat -v** for detailed statistics about each hard disk in
the pool.

    root@server2:# zpool iostat -v 5
                  capacity     operations     bandwidth
    pool        alloc   free   read  write   read  write
    ----------  -----  -----  -----  -----  -----  -----
    pro42pool    887M   427G      0      4     51  47.7K
      raidz1     887M   427G      0      4     51  47.7K
        sdb         -      -      0      1     25  15.9K
        sdc         -      -      0      1     25  15.9K
        sdd         -      -      0      1      1  15.9K
    ----------  -----  -----  -----  -----  -----  -----
    ^C
    root@server2:#

## Creating ZFS snapshots

It is easy to create copy-on-write snapshots with the **zfs snapshot**
command.

    root@server2:# zfs snapshot pro42pool/div02@2019aug31
    root@server2:# zfs list -t all
    NAME                        USED  AVAIL  REFER  MOUNTPOINT
    pro42pool                   101G   176G  32.0K  /srv/project42
    pro42pool/div01             591M  29.4G   591M  /srv/project42/div01
    pro42pool/div02            30.6K   276G  30.6K  /srv/project42/div02
    pro42pool/div02@2019aug31     0B      -  30.6K  -
    root@server2:~#

## ZFS send and receive

You can send a ZFS filesystem over the network with **zfs send** and
**ssh**, and receive it on another server with **zfs receive**. This
will be discussed later in the Backup chapter.

    root@server2:# zfs send pro42pool/div02@2019aug31 | ssh ba@server3 'zfs receive backuppool/div02@2019aug31'
    ba@server3's password:
    root@server2:#

## ZFS network sharing

We will discuss ZFS **NFS sharing** in the NFS chapter and **SMB
sharing** in one of the Samba chapters.

## Cheat sheet

<table>
<caption>ZFS</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zpool create foo /dev/sdb
/dev/sdc</p></td>
<td style="text-align: left;"><p>Create a new zpool named
<strong>foo</strong> using two block devices.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>zpool list</p></td>
<td style="text-align: left;"><p>List information about zpools.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zpool status foo</p></td>
<td style="text-align: left;"><p>Display information about the zpool
named <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>zpool status -x</p></td>
<td style="text-align: left;"><p>Succinct information about all
zpools.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zpool destroy foo</p></td>
<td style="text-align: left;"><p>Delete the zpool named
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>zpool create foo raidz sdb sdc
sdd</p></td>
<td style="text-align: left;"><p>Create a raidz (RAID 5) zpool named
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zfs create foo/bar</p></td>
<td style="text-align: left;"><p>Create a zfs file system named
<strong>bar</strong> in the zpool named <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>zfs set quota=100G foo/bar</p></td>
<td style="text-align: left;"><p>Set a 100 gigabyte quota for
<strong>foo/bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zfs set reservation=42G
foo/bar</p></td>
<td style="text-align: left;"><p>Reserve 42 gigabyte for
<strong>foo/bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>zfs set compression=on foo/bar</p></td>
<td style="text-align: left;"><p>compress the zfs file system
<strong>foo/bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zfs get all foo/bar</p></td>
<td style="text-align: left;"><p>List all properties for the zfs file
system <strong>foo/bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>zpool iostat 2</p></td>
<td style="text-align: left;"><p>Display statistics every two
seconds.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zfs snapshot foo/bar@date</p></td>
<td style="text-align: left;"><p>Create a snapshot of
<strong>foo/bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>zfs send foo/bar@date | ssh</p></td>
<td style="text-align: left;"><p>Send the snapshot to another
server.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zfs receive backupfoo/bar@date</p></td>
<td style="text-align: left;"><p>Receive a snapshot from a
server.</p></td>
</tr>
</tbody>
</table>

ZFS

## Practice

1.  Follow the instructions in the theory to install ZFS.

2.  Create a zpool RAID1 mirror named **mymirpool**.

3.  Create a **division01** zfs filesystem in this pool with a 10GB
    quota.

4.  Verify your work with **zfs list** .

5.  Read the **zfs** man page about **deduplication** and set this
    property to on for **division01**.

6.  Create a snapshot from the **division01** ZFS filesystem.

7.  Create a disk I/O heavy job in the background and monitor the
    **zpool** every three seconds.

8.  Destroy your pool and all its subdirectories.

## Solution

1.  Follow the instructions in the theory to install ZFS.

        cp /etc/apt/sources.list /etc/apt/sources.original
        vi /etc/apt/sources.list
        apt-get install spl-dkms
        apt-get install zfs-dkms

2.  Create a zpool RAID1 mirror named **mymirpool**.

        zpool create mymirpool mirror sde sdf

3.  Create a **division01** zfs filesystem in this pool with a 10GB
    quota.

        zfs create -o quota=10G mymirpool/division01

4.  Verify your work with **zfs list** .

        zfs list

5.  Read the **zfs** man page about **deduplication** and set this
    property to on for **division01**.

        man zfs
        zfs set dedup=on mymirpool/division01

6.  Create a snapshot from the **division01** ZFS filesystem.

        zfs snapshot mymirpool/division01@2019aug31

7.  Create a disk I/O heavy job in the background and monitor the
    **zpool** every three seconds.

        cp -r /usr /mymirpool/division01 &
        zpool iostat 3

8.  Destroy your pool and all its subdirectories.

        zpool destroy mymirpool
