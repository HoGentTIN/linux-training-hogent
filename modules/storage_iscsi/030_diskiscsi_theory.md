## iSCSI terminology

`iSCSI` is a protocol that enables SCSI over IP. This
means that you can have local SCSI devices (like /dev/sdb) without
having the storage hardware in the local computer.

The computer holding the physical storage hardware is called the
`iSCSI Target`. Each individual addressable iSCSI device on the target
server will get a `LUN number`.

The iSCSI client computer that is connecting to the Target server is
called an `Initiator`. An initiator will send SCSI
commands over IP instead of directly to the hardware. The Initiator will
connect to the Target.

## iSCSI Target in RHEL/CentOS

This section will describe iSCSI Target setup on RHEL6, RHEL7 and
CentOS.

Start with installing the `iSCSI Target` package.

    yum install scsi-target-utils

We configure three local disks in `/etc/tgt/targets.conf` to become
three LUN's.

    <target iqn.2008-09.com.example:server.target2>
        direct-store /dev/sdb
        direct-store /dev/sdc
        direct-store /dev/sdd
        incominguser paul hunter2
    </target>

Restart the service.

    [root@linux ~]# service tgtd start
    Starting SCSI target daemon:                               [  OK  ]

The standard local port for iSCSI Target is 3260, in case of doubt you
can verify this with `netstat`.

    [root@server1 tgt]# netstat -ntpl | grep tgt
    tcp    0   0 0.0.0.0:3260       0.0.0.0:*          LISTEN      1670/tgtd
    tcp    0   0 :::3260            :::*               LISTEN      1670/tgtd

The `tgt-admin -s` command should now give you a nice overview of the
three LUN's (and also LUN 0 for the controller).

    [root@server1 tgt]# tgt-admin -s
    Target 1: iqn.2014-04.be.linux-training:server1.target1
        System information:
            Driver: iscsi
            State: ready
        I_T nexus information:
        LUN information:
            LUN: 0
                Type: controller
                SCSI ID: IET     00010000
                SCSI SN: beaf10
                Size: 0 MB, Block size: 1
                Online: Yes
                Removable media: No
                Prevent removal: No
                Readonly: No
                Backing store type: null
                Backing store path: None
                Backing store flags: 
            LUN: 1
                Type: disk
                SCSI ID: IET     00010001
                SCSI SN: VB9f23197b-af6cfb60 
                Size: 1074 MB, Block size: 512
                Online: Yes
                Removable media: No
                Prevent removal: No
                Readonly: No
                Backing store type: rdwr
                Backing store path: /dev/sdb
                Backing store flags: 
            LUN: 2
                Type: disk
                SCSI ID: IET     00010002
                SCSI SN: VB8f554351-a1410828 
                Size: 1074 MB, Block size: 512
                Online: Yes
                Removable media: No
                Prevent removal: No
                Readonly: No
                Backing store type: rdwr
                Backing store path: /dev/sdc
                Backing store flags: 
            LUN: 3
                Type: disk
                SCSI ID: IET     00010003
                SCSI SN: VB1035d2f0-7ae90b49 
                Size: 1074 MB, Block size: 512
                Online: Yes
                Removable media: No
                Prevent removal: No
                Readonly: No
                Backing store type: rdwr
                Backing store path: /dev/sdd
                Backing store flags: 
        Account information:
        ACL information:
            ALL

## iSCSI Initiator in RHEL/CentOS

This section will describe iSCSI Initiator setup on RHEL6, RHEL7 and
CentOS.

Start with installing the `iSCSI Initiator` package.

    [root@server2 ~]# yum install iscsi-initiator-utils

Then ask the `iSCSI target server` to send you the target names.

    [root@server2 ~]# iscsiadm -m discovery -t sendtargets -p 192.168.1.95:3260
    Starting iscsid:                                           [  OK  ]
    192.168.1.95:3260,1 iqn.2014-04.be.linux-training:centos65.target1

We received `iqn.2014-04.be.linux-training:centos65.target1`.

We use this iqn to configure the username and the password (paul and
hunter2) that we set on the target server.

    [root@server2 iscsi]# iscsiadm -m node --targetname iqn.2014-04.be.linux-tra\
    ining:centos65.target1 --portal "192.168.1.95:3260" --op=update --name node.\
    session.auth.username --value=paul
    [root@server2 iscsi]# iscsiadm -m node --targetname iqn.2014-04.be.linux-tra\
    ining:centos65.target1 --portal "192.168.1.95:3260" --op=update --name node.\
    session.auth.password --value=hunter2
    [root@server2 iscsi]# iscsiadm -m node --targetname iqn.2014-04.be.linux-tra\
    ining:centos65.target1 --portal "192.168.1.95:3260" --op=update --name node.\
    session.auth.authmethod --value=CHAP

RHEL and CentOS will store these in `/var/lib/iscsi/nodes/`.

    [root@server2 iscsi]# grep auth /var/lib/iscsi/nodes/iqn.2014-04.be.linux-tr\
    aining\:centos65.target1/192.168.1.95\,3260\,1/default 
    node.session.auth.authmethod = CHAP
    node.session.auth.username = paul
    node.session.auth.password = hunter2
    node.conn[0].timeo.auth_timeout = 45
    [root@server2 iscsi]# 

A restart of the `iscsi` service will add three new devices to our
system.

    [root@server2 iscsi]# fdisk -l | grep Disk
    Disk /dev/sda: 42.9 GB, 42949672960 bytes
    Disk identifier: 0x0004f229
    Disk /dev/sdb: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdc: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdd: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sde: 2147 MB, 2147483648 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdf: 2147 MB, 2147483648 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdg: 2147 MB, 2147483648 bytes
    Disk identifier: 0x00000000
    Disk /dev/mapper/VolGroup-lv_root: 41.4 GB, 41448112128 bytes
    Disk identifier: 0x00000000
    Disk /dev/mapper/VolGroup-lv_swap: 973 MB, 973078528 bytes
    Disk identifier: 0x00000000
    [root@server2 iscsi]# service iscsi restart
    Stopping iscsi:                                            [  OK  ]
    Starting iscsi:                                            [  OK  ]
    [root@server2 iscsi]# fdisk -l | grep Disk
    Disk /dev/sda: 42.9 GB, 42949672960 bytes
    Disk identifier: 0x0004f229
    Disk /dev/sdb: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdc: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdd: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sde: 2147 MB, 2147483648 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdf: 2147 MB, 2147483648 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdg: 2147 MB, 2147483648 bytes
    Disk identifier: 0x00000000
    Disk /dev/mapper/VolGroup-lv_root: 41.4 GB, 41448112128 bytes
    Disk identifier: 0x00000000
    Disk /dev/mapper/VolGroup-lv_swap: 973 MB, 973078528 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdh: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdi: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdj: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000

You can verify iscsi status with:

    service iscsi status

## iSCSI target on Debian

Installing the software for the target server requires `iscsitarget` on
Ubuntu and Debian, and an extra `iscsitarget-dkms` for the kernel
modules only on Debian.

    root@debby6:~# aptitude install iscsitarget
    The following NEW packages will be installed:
      iscsitarget 
    0 packages upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 69.4 kB of archives. After unpacking 262 kB will be used.
    Get:1 http://ftp.belnet.be/debian/ squeeze/main iscsitarget i386 1.4.20.2-1\
     [69.4 kB]
    Fetched 69.4 kB in 0s (415 kB/s)
    Selecting previously deselected package iscsitarget.
    (Reading database ... 36441 files and directories currently installed.)
    Unpacking iscsitarget (from .../iscsitarget_1.4.20.2-1_i386.deb) ...
    Processing triggers for man-db ...
    Setting up iscsitarget (1.4.20.2-1) ...
    iscsitarget not enabled in "/etc/default/iscsitarget", not starting...(warning).

On Debian 6 you will also need `aptitude install iscsitarget-dkms` for
the kernel modules, on Debian 5 this is
`` aptitude install iscsitarget-modules-`uname -a` ``. Ubuntu includes
the kernel modules in the main package.

The iSCSI target server is disabled by default, so we enable it.

    root@debby6:~# cat /etc/default/iscsitarget 
    ISCSITARGET_ENABLE=false
    root@debby6:~# vi /etc/default/iscsitarget 
    root@debby6:~# cat /etc/default/iscsitarget 
    ISCSITARGET_ENABLE=true

## iSCSI target setup with dd files

You can use LVM volumes (/dev/md0/lvol0), physical partitions (/dev/sda)
,raid devices (/dev/md0) or just plain files for storage. In this demo,
we use files created with `dd`.

This screenshot shows how to create three small files (100MB, 200MB and
300MB).

    root@debby6:~# mkdir /iscsi
    root@debby6:~# dd if=/dev/zero of=/iscsi/lun1.img bs=1M count=100
    100+0 records in
    100+0 records out
    104857600 bytes (105 MB) copied, 0.315825 s, 332 MB/s
    root@debby6:~# dd if=/dev/zero of=/iscsi/lun2.img bs=1M count=200
    200+0 records in
    200+0 records out
    209715200 bytes (210 MB) copied, 1.08342 s, 194 MB/s
    root@debby6:~# dd if=/dev/zero of=/iscsi/lun3.img bs=1M count=300
    300+0 records in
    300+0 records out
    314572800 bytes (315 MB) copied, 1.36209 s, 231 MB/s

We need to declare these three files as iSCSI targets in
`/etc/iet/ietd.conf` (used to be /etc/ietd.conf).

    root@debby6:/etc/iet# cp ietd.conf ietd.conf.original
    root@debby6:/etc/iet# > ietd.conf
    root@debby6:/etc/iet# vi ietd.conf
    root@debby6:/etc/iet# cat ietd.conf
    Target iqn.2010-02.be.linux-training:storage.lun1
        IncomingUser isuser hunter2
        OutgoingUser
        Lun 0 Path=/iscsi/lun1.img,Type=fileio
        Alias LUN1

    Target iqn.2010-02.be.linux-training:storage.lun2
        IncomingUser isuser hunter2
        OutgoingUser
        Lun 0 Path=/iscsi/lun2.img,Type=fileio
        Alias LUN2

    Target iqn.2010-02.be.linux-training:storage.lun3
        IncomingUser isuser hunter2
        OutgoingUser
        Lun 0 Path=/iscsi/lun3.img,Type=fileio
        Alias LUN3 

We also need to add our devices to the `/etc/initiators.allow` file.

    root@debby6:/etc/iet# cp initiators.allow initiators.allow.original
    root@debby6:/etc/iet# >initiators.allow
    root@debby6:/etc/iet# vi initiators.allow
    root@debby6:/etc/iet# cat initiators.allow
    iqn.2010-02.be.linux-training:storage.lun1
    iqn.2010-02.be.linux-training:storage.lun2
    iqn.2010-02.be.linux-training:storage.lun3

Time to start the server now:

    root@debby6:/etc/iet# /etc/init.d/iscsitarget start
    Starting iSCSI enterprise target service:.
    .
    root@debby6:/etc/iet#

Verify activation of the storage devices in `/proc/net/iet`:

    root@debby6:/etc/iet# cat /proc/net/iet/volume 
    tid:3 name:iqn.2010-02.be.linux-training:storage.lun3
        lun:0 state:0 iotype:fileio iomode:wt blocks:614400 blocksize:\
    512 path:/iscsi/lun3.img
    tid:2 name:iqn.2010-02.be.linux-training:storage.lun2
        lun:0 state:0 iotype:fileio iomode:wt blocks:409600 blocksize:\
    512 path:/iscsi/lun2.img
    tid:1 name:iqn.2010-02.be.linux-training:storage.lun1
        lun:0 state:0 iotype:fileio iomode:wt blocks:204800 blocksize:\
    512 path:/iscsi/lun1.img
    root@debby6:/etc/iet# cat /proc/net/iet/session 
    tid:3 name:iqn.2010-02.be.linux-training:storage.lun3
    tid:2 name:iqn.2010-02.be.linux-training:storage.lun2
    tid:1 name:iqn.2010-02.be.linux-training:storage.lun1

## ISCSI initiator on ubuntu

First we install the iSCSi client software (on another computer than the
target).

    root@ubu1104:~# aptitude install open-iscsi
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    Reading extended state information
    Initializing package states... Done
    The following NEW packages will be installed:
      open-iscsi open-iscsi-utils{a}

Then we set the iSCSI client to start automatically.

    root@ubu1104:/etc/iscsi# cp iscsid.conf iscsid.conf.original
    root@ubu1104:/etc/iscsi# vi iscsid.conf
    root@ubu1104:/etc/iscsi# grep ^node.startup iscsid.conf
    node.startup = automatic

Or you could start it manually.

    root@ubu1104:/etc/iscsi/nodes# /etc/init.d/open-iscsi start
     * Starting iSCSI initiator service iscsid                        [ OK ] 
     * Setting up iSCSI targets                                       [ OK ] 
    root@ubu1104:/etc/iscsi/nodes#

Now we can connect to the Target server and use `iscsiadm` to discover
the devices it offers:

    root@ubu1104:/etc/iscsi# iscsiadm  -m discovery -t st -p 192.168.1.31
    192.168.1.31:3260,1 iqn.2010-02.be.linux-training:storage.lun2
    192.168.1.31:3260,1 iqn.2010-02.be.linux-training:storage.lun1
    192.168.1.31:3260,1 iqn.2010-02.be.linux-training:storage.lun3 

We can use the same `iscsiadm` to edit the files in
`/etc/iscsi/nodes/`.

    root@ubu1104:/etc/iscsi# iscsiadm -m node --targetname "iqn.2010-02.be.linu\
    x-training:storage.lun1" --portal "192.168.1.31:3260" --op=update --name no\
    de.session.auth.authmethod --value=CHAP
    root@ubu1104:/etc/iscsi# iscsiadm -m node --targetname "iqn.2010-02.be.linu\
    x-training:storage.lun1" --portal "192.168.1.31:3260" --op=update --name no\
    de.session.auth.username --value=isuser
    root@ubu1104:/etc/iscsi# iscsiadm -m node --targetname "iqn.2010-02.be.linu\
    x-training:storage.lun1" --portal "192.168.1.31:3260" --op=update --name no\
    de.session.auth.password --value=hunter2

Repeat the above for the other two devices.

Restart the initiator service to log in to the target.

    root@ubu1104:/etc/iscsi/nodes# /etc/init.d/open-iscsi restart
     * Disconnecting iSCSI targets                                      [ OK ]
     * Stopping iSCSI initiator service                                 [ OK ]
     * Starting iSCSI initiator service iscsid                          [ OK ]
     * Setting up iSCSI targets  

Use `fdisk -l` to enjoy three new iSCSI devices.

    root@ubu1104:/etc/iscsi/nodes# fdisk -l 2> /dev/null | grep Disk
    Disk /dev/sda: 17.2 GB, 17179869184 bytes
    Disk identifier: 0x0001983f
    Disk /dev/sdb: 209 MB, 209715200 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdd: 314 MB, 314572800 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdc: 104 MB, 104857600 bytes
    Disk identifier: 0x00000000 

The Target (the server) now shows active sessions.

    root@debby6:/etc/iet# cat /proc/net/iet/session 
    tid:3 name:iqn.2010-02.be.linux-training:storage.lun3
        sid:5348024611832320 initiator:iqn.1993-08.org.debian:01:8983ed2d770
            cid:0 ip:192.168.1.35 state:active hd:none dd:none
    tid:2 name:iqn.2010-02.be.linux-training:storage.lun2
        sid:4785074624856576 initiator:iqn.1993-08.org.debian:01:8983ed2d770
            cid:0 ip:192.168.1.35 state:active hd:none dd:none
    tid:1 name:iqn.2010-02.be.linux-training:storage.lun1
        sid:5066549618344448 initiator:iqn.1993-08.org.debian:01:8983ed2d770
            cid:0 ip:192.168.1.35 state:active hd:none dd:none
    root@debby6:/etc/iet# 

## using iSCSI devices

There is no difference between using SCSI or iSCSI devices once they are
connected : partition, make filesystem, mount.

    root@ubu1104:/etc/iscsi/nodes# history | tail -13
       94  fdisk /dev/sdc
       95  fdisk /dev/sdd
       96  fdisk /dev/sdb
       97  mke2fs /dev/sdb1
       98  mke2fs -j /dev/sdc1
       99  mkfs.ext4 /dev/sdd1
      100  mkdir /mnt/is1
      101  mkdir /mnt/is2
      102  mkdir /mnt/is3
      103  mount /dev/sdb1 /mnt/is1
      104  mount /dev/sdc1 /mnt/is2
      105  mount /dev/sdd1 /mnt/is3
      106  history | tail -13
    root@ubu1104:/etc/iscsi/nodes# mount | grep is
    /dev/sdb1 on /mnt/is1 type ext2 (rw)
    /dev/sdc1 on /mnt/is2 type ext3 (rw)
    /dev/sdd1 on /mnt/is3 type ext4 (rw)

## iSCSI Target RHEL7/CentOS7

The prefered tool to setup an iSCSI Target on RHEL is `targetcli`.

    [root@linux ~]# yum install targetcli
    Loaded plugins: fastestmirror
    ...
    ...
    Installed:
      targetcli.noarch 0:2.1.fb37-3.el7

    Complete!
    [root@linux ~]#

The `targetcli` tool is interactive and represents the configuration fo
the `target` in a structure that resembles a directory tree with several
files. Although this is explorable inside `targetcli` with `ls`, `cd`
and `pwd`, this are not files on the file system.

This tool also has tab-completion, which is very handy for the `iqn`
names.

    [root@linux ~]# targetcli
    targetcli shell version 2.1.fb37
    Copyright 2011-2013 by Datera, Inc and others.
    For help on commands, type 'help'.

    /> cd backstores/
    /backstores> ls
    o- backstores ............................................................ [...]
      o- block ................................................ [Storage Objects: 0]
      o- fileio ............................................... [Storage Objects: 0]
      o- pscsi ................................................ [Storage Objects: 0]
      o- ramdisk .............................................. [Storage Objects: 0]
    /backstores> cd block
    /backstores/block> ls
    o- block .................................................. [Storage Objects: 0]
    /backstores/block> create server1.disk1 /dev/sdb
    Created block storage object server1.disk1 using /dev/sdb.
    /backstores/block> ls
    o- block .................................................. [Storage Objects: 1]
      o- server1.disk1 .................. [/dev/sdb (2.0GiB) write-thru deactivated]
    /backstores/block> cd /iscsi
    /iscsi> create iqn.2015-04.be.linux:iscsi1
    Created target iqn.2015-04.be.linux:iscsi1.
    Created TPG 1.
    Global pref auto_add_default_portal=true
    Created default portal listening on all IPs (0.0.0.0), port 3260.
    /iscsi> cd /iscsi/iqn.2015-04.be.linux:iscsi1/tpg1/acls
    /iscsi/iqn.20...si1/tpg1/acls> create iqn.2015-04.be.linux:server2
    Created Node ACL for iqn.2015-04.be.linux:server2
    /iscsi/iqn.20...si1/tpg1/acls> cd iqn.2015-04.be.linux:server2
    /iscsi/iqn.20...linux:server2> set auth userid=paul
    Parameter userid is now 'paul'.
    /iscsi/iqn.20...linux:server2> set auth password=hunter2
    Parameter password is now 'hunter2'.
    /iscsi/iqn.20...linux:server2> cd /iscsi/iqn.2015-04.be.linux:iscsi1/tpg1/luns
    /iscsi/iqn.20...si1/tpg1/luns> create /backstores/block/server1.disk1
    Created LUN 0.
    Created LUN 0->0 mapping in node ACL iqn.2015-04.be.linux:server2
    s/scsi/iqn.20...si1/tpg1/luns> cd /iscsi/iqn.2015-04.be.linux:iscsi1/tpg1/portals
    /iscsi/iqn.20.../tpg1/portals> create 192.168.1.128
    Using default IP port 3260
    Could not create NetworkPortal in configFS.
    /iscsi/iqn.20.../tpg1/portals> cd /
    /> ls
    o- / ..................................................................... [...]
      o- backstores .......................................................... [...]
      | o- block .............................................. [Storage Objects: 1]
      | | o- server1.disk1 ................ [/dev/sdb (2.0GiB) write-thru activated]
      | o- fileio ............................................. [Storage Objects: 0]
      | o- pscsi .............................................. [Storage Objects: 0]
      | o- ramdisk ............................................ [Storage Objects: 0]
      o- iscsi ........................................................ [Targets: 1]
      | o- iqn.2015-04.be.linux:iscsi1 ................................... [TPGs: 1]
      |   o- tpg1 ........................................... [no-gen-acls, no-auth]
      |     o- acls ...................................................... [ACLs: 1]
      |     | o- iqn.2015-04.be.linux:server2 ..................... [Mapped LUNs: 1]
      |     |   o- mapped_lun0 ..................... [lun0 block/server1.disk1 (rw)]
      |     o- luns ...................................................... [LUNs: 1]
      |     | o- lun0 ............................. [block/server1.disk1 (/dev/sdb)]
      |     o- portals ................................................ [Portals: 1]
      |       o- 0.0.0.0:3260 ................................................. [OK]
      o- loopback ..................................................... [Targets: 0]
    /> saveconfig
    Last 10 configs saved in /etc/target/backup.
    Configuration saved to /etc/target/saveconfig.json
    /> exit
    Global pref auto_save_on_exit=true
    Last 10 configs saved in /etc/target/backup.
    Configuration saved to /etc/target/saveconfig.json
    [root@linux ~]#

Use the `systemd` tools to manage the service:

    [root@linux ~]# systemctl enable target
    ln -s '/usr/lib/systemd/system/target.service' '/etc/systemd/system/multi-user.target.wants/target.service'
    [root@linux ~]# systemctl start target
    [root@linux ~]#

Depending on your organisations policy, you may need to configure
firewall and SELinux. The screenshot belows adds a firewall rule to
allow all traffic over port 3260, and disables SELinux.

    [root@linux ~]# firewall-cmd --permanent --add-port=3260/tcp
    [root@linux ~]# firewall-cmd --reload
    [root@linux ~]# setenforce 0

The total configuration is visible using `ls` from the root.

    [root@linux ~]# targetcli
    targetcli shell version 2.1.fb37
    Copyright 2011-2013 by Datera, Inc and others.
    For help on commands, type 'help'.

    /> ls
    o- / ..................................................................... [...]
      o- backstores .......................................................... [...]
      | o- block .............................................. [Storage Objects: 1]
      | | o- server1.disk1 ................ [/dev/sdb (2.0GiB) write-thru activated]
      | o- fileio ............................................. [Storage Objects: 0]
      | o- pscsi .............................................. [Storage Objects: 0]
      | o- ramdisk ............................................ [Storage Objects: 0]
      o- iscsi ........................................................ [Targets: 1]
      | o- iqn.2015-04.be.linux:iscsi1 ................................... [TPGs: 1]
      |   o- tpg1 ........................................... [no-gen-acls, no-auth]
      |     o- acls ...................................................... [ACLs: 1]
      |     | o- iqn.2015-04.be.linux:server2 ..................... [Mapped LUNs: 1]
      |     |   o- mapped_lun0 ..................... [lun0 block/server1.disk1 (rw)]
      |     o- luns ...................................................... [LUNs: 1]
      |     | o- lun0 ............................. [block/server1.disk1 (/dev/sdb)]
      |     o- portals ................................................ [Portals: 1]
      |       o- 0.0.0.0:3260 ................................................. [OK]
      o- loopback ..................................................... [Targets: 0]
    />
    /> exit
    Global pref auto_save_on_exit=true
    Last 10 configs saved in /etc/target/backup.
    Configuration saved to /etc/target/saveconfig.json
    [root@linux ~]#

The iSCSI Target is now ready.

## iSCSI Initiator RHEL7/CentOS7

This is identical to the RHEL6/CentOS6 procedure:

    [root@linux ~]# yum install iscsi-initiator-utils
    Loaded plugins: fastestmirror
    ...
    ...
    Installed:
      iscsi-initiator-utils.x86_64 0:6.2.0.873-29.el7

    Dependency Installed:
      iscsi-initiator-utils-iscsiuio.x86_64 0:6.2.0.873-29.el7

    Complete!

Map your initiator name to the `targetcli` acl.

    [root@linux ~]# cat /etc/iscsi/initiatorname.iscsi
    InitiatorName=iqn.2015-04.be.linux:server2
    [root@linux ~]#

Enter the CHAP authentication in `/etc/iscsi/iscsid.conf`.

    [root@linux ~]# vi /etc/iscsi/iscsid.conf
    ...
    [root@linux ~]# grep ^node.session.auth /etc/iscsi/iscsid.conf
    node.session.auth.authmethod = CHAP
    node.session.auth.username = paul
    node.session.auth.password = hunter2
    [root@linux ~]#

There are no extra devices yet...

    [root@linux ~]# fdisk -l | grep sd
    Disk /dev/sda: 22.0 GB, 22038806528 bytes, 43044544 sectors
    /dev/sda1   *        2048     1026047      512000   83  Linux
    /dev/sda2         1026048    43042815    21008384   8e  Linux LVM
    Disk /dev/sdb: 2147 MB, 2147483648 bytes, 4194304 sectors

Enable the service and discover the target.

    [root@linux ~]# systemctl enable iscsid
    ln -s '/usr/lib/systemd/system/iscsid.service' '/etc/systemd/system/multi-user.target.wants/iscsid.service'
    [root@linux ~]# iscsiadm -m discovery -t st -p 192.168.1.128
    192.168.1.128:3260,1 iqn.2015-04.be.linux:iscsi1

Log into the target and see /dev/sdc appear.

    [root@linux ~]# iscsiadm -m node -T iqn.2015-04.be.linux:iscsi1 -p 192.168.1.128 -l
    Logging in to [iface: default, target: iqn.2015-04.be.linux:iscsi1, portal: 192.168.1.128,3260] (multiple)
    Login to [iface: default, target: iqn.2015-04.be.linux:iscsi1, portal: 192.168.1.128,3260] successful.
    [root@linux ~]#
    [root@linux ~]# fdisk -l | grep sd
    Disk /dev/sda: 22.0 GB, 22038806528 bytes, 43044544 sectors
    /dev/sda1   *        2048     1026047      512000   83  Linux
    /dev/sda2         1026048    43042815    21008384   8e  Linux LVM
    Disk /dev/sdb: 2147 MB, 2147483648 bytes, 4194304 sectors
    Disk /dev/sdc: 2147 MB, 2147483648 bytes, 4194304 sectors
    [root@linux ~]# 

