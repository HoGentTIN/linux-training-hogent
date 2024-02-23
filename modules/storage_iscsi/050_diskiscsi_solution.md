## solution: iSCSI devices

1\. Set up a target (using an LVM and a SCSI device) and an initiator
that connects to both.

This solution was done on `Debian/ubuntu/Mint`. For RHEL/CentOS check
the theory.

Decide (with a partner) on a computer to be the Target and another
computer to be the Initiator.

`On the Target computer:`

First install iscsitarget using the standard tools for installing
software in your distribution. Then use your knowledge from the previous
chapter to setup a logical volume (/dev/vg/lvol0) and use the RAID
chapter to setup /dev/md0. Then perform the following step:

    vi /etc/default/iscsitarget (set enable to true)

Add your devices to /etc/iet/ietf.conf

    root@debby6:/etc/iet# cat ietd.conf
    Target iqn.2010-02.be.linux-training:storage.lun1
     IncomingUser isuser hunter2
     OutgoingUser
     Lun 0 Path=/dev/vg/lvol0,Type=fileio
     Alias LUN1
    Target iqn.2010-02.be.linux-training:storage.lun2
     IncomingUser isuser hunter2
     OutgoingUser
     Lun 0 Path=/dev/md0,Type=fileio
     Alias LUN2

Add both devices to /etc/iet/initiators.allow

    root@debby6:/etc/iet# cat initiators.allow
    iqn.2010-02.be.linux-training:storage.lun1
    iqn.2010-02.be.linux-training:storage.lun2

Now start the iscsitarget daemon and move over to the Initiator.

`On the Initiator computer:`

Install open-iscsi and start the daemon.

Then use `iscsiadm -m discovery -t st -p 'target-ip'` to see the iscsi
devices on the Target.

Edit the files `/etc/iscsi/nodes/` as shown in the book. Then restart
the iSCSI daemon and rund `fdisk -l` to see the iSCSI devices.

2\. Set up an iSCSI Target and Initiator on two CentOS7/RHEL7 computers
with the following information:

  -------------------------------------------------------------
  variable                     value
  ---------------------------- --------------------------------
  Target Server IP             192.168.1.143 (Adjust for your
                               subnet!)

  shared devices on target     /dev/sdb /dev/sdc /dev/sdd

  shared device name sdb       target.disk1

  shared device name sdc       target.disk2

  shared device name sdd       target.disk3

  target iqn                   iqn.2015-04.be.linux:target

  initiator iqn                iqn.2015-04.be.linux:initiator

  username                     paul

  password                     hunter2
  -------------------------------------------------------------

  : iSCSI Target and Initiator practice

On the iSCSI Target server:

    [root@linux ~]# targetcli
    targetcli shell version 2.1.fb37
    Copyright 2011-2013 by Datera, Inc and others.
    For help on commands, type 'help'.

    /> cd /backstores/block
    /backstores/block> ls
    o- block .................................................. [Storage Objects: 0]
    /backstores/block> create target.disk1 /dev/sdb
    Created block storage object target.disk1 using /dev/sdb.
    /backstores/block> create target.disk2 /dev/sdc
    Created block storage object target.disk2 using /dev/sdc.
    /backstores/block> create target.disk3 /dev/sdd
    Created block storage object target.disk3 using /dev/sdd.
    /backstores/block> ls
    o- block .................................................. [Storage Objects: 3]
      o- target.disk1 ................... [/dev/sdb (8.0GiB) write-thru deactivated]
      o- target.disk2 ................... [/dev/sdc (8.0GiB) write-thru deactivated]
      o- target.disk3 ................... [/dev/sdd (8.0GiB) write-thru deactivated]
    /backstores/block> cd /iscsi
    /iscsi> create iqn.2015-04.be.linux:target
    Created target iqn.2015-04.be.linux:target.
    Created TPG 1.
    Global pref auto_add_default_portal=true
    Created default portal listening on all IPs (0.0.0.0), port 3260.
    /iscsi> cd /iscsi/iqn.2015-04.be.linux:target/tpg1/acls
    /iscsi/iqn.20...get/tpg1/acls> create iqn.2015-04.be.linux:initiator
    Created Node ACL for iqn.2015-04.be.linux:initiator
    /iscsi/iqn.20...get/tpg1/acls> cd iqn.2015-04.be.linux:initiator
    /iscsi/iqn.20...nux:initiator> pwd
    /iscsi/iqn.2015-04.be.linux:target/tpg1/acls/iqn.2015-04.be.linux:initiator
    /iscsi/iqn.20...nux:initiator> set auth userid=paul
    Parameter userid is now 'paul'.
    /iscsi/iqn.20...nux:initiator> set auth password=hunter2
    Parameter password is now 'hunter2'.
    /iscsi/iqn.20...nux:initiator> cd /iscsi/iqn.2015-04.be.linux:target/tpg1/
    /iscsi/iqn.20...x:target/tpg1> ls
    o- tpg1 ................................................. [no-gen-acls, no-auth]
      o- acls ............................................................ [ACLs: 1]
      | o- iqn.2015-04.be.linux:initiator ......................... [Mapped LUNs: 0]
      o- luns ............................................................ [LUNs: 0]
      o- portals ...................................................... [Portals: 1]
        o- 0.0.0.0:3260 ....................................................... [OK]
    /iscsi/iqn.20...x:target/tpg1> cd luns
    /iscsi/iqn.20...get/tpg1/luns> create /backstores/block/target.disk1
    Created LUN 0.
    Created LUN 0->0 mapping in node ACL iqn.2015-04.be.linux:initiator
    /iscsi/iqn.20...get/tpg1/luns> create /backstores/block/target.disk2
    Created LUN 1.
    Created LUN 1->1 mapping in node ACL iqn.2015-04.be.linux:initiator
    /iscsi/iqn.20...get/tpg1/luns> create /backstores/block/target.disk3
    Created LUN 2.
    Created LUN 2->2 mapping in node ACL iqn.2015-04.be.linux:initiator
    s/scsi/iqn.20...get/tpg1/luns> cd /iscsi/iqn.2015-04.be.linux:target/tpg1/portals
    /iscsi/iqn.20.../tpg1/portals> create 192.168.1.143
    Using default IP port 3260
    Could not create NetworkPortal in configFS.
    /iscsi/iqn.20.../tpg1/portals> cd /
    /> ls
    o- / ..................................................................... [...]
      o- backstores .......................................................... [...]
      | o- block .............................................. [Storage Objects: 3]
      | | o- target.disk1 ................. [/dev/sdb (8.0GiB) write-thru activated]
      | | o- target.disk2 ................. [/dev/sdc (8.0GiB) write-thru activated]
      | | o- target.disk3 ................. [/dev/sdd (8.0GiB) write-thru activated]
      | o- fileio ............................................. [Storage Objects: 0]
      | o- pscsi .............................................. [Storage Objects: 0]
      | o- ramdisk ............................................ [Storage Objects: 0]
      o- iscsi ........................................................ [Targets: 1]
      | o- iqn.2015-04.be.linux:target ................................... [TPGs: 1]
      |   o- tpg1 ........................................... [no-gen-acls, no-auth]
      |     o- acls ...................................................... [ACLs: 1]
      |     | o- iqn.2015-04.be.linux:initiator ................... [Mapped LUNs: 3]
      |     |   o- mapped_lun0 ...................... [lun0 block/target.disk1 (rw)]
      |     |   o- mapped_lun1 ...................... [lun1 block/target.disk2 (rw)]
      |     |   o- mapped_lun2 ...................... [lun2 block/target.disk3 (rw)]
      |     o- luns ...................................................... [LUNs: 3]
      |     | o- lun0 .............................. [block/target.disk1 (/dev/sdb)]
      |     | o- lun1 .............................. [block/target.disk2 (/dev/sdc)]
      |     | o- lun2 .............................. [block/target.disk3 (/dev/sdd)]
      |     o- portals ................................................ [Portals: 1]
      |       o- 0.0.0.0:3260 ................................................. [OK]
      o- loopback ..................................................... [Targets: 0]
    /> exit
    Global pref auto_save_on_exit=true
    Last 10 configs saved in /etc/target/backup.
    Configuration saved to /etc/target/saveconfig.json
    [root@linux ~]# systemctl enable target
    ln -s '/usr/lib/systemd/system/target.service' '/etc/systemd/system/multi-user.target.wants/target.service'
    [root@linux ~]# systemctl start target
    [root@linux ~]# setenforce 0

On the Initiator:

    [root@linux ~]# cat /etc/iscsi/initiatorname.iscsi
    InitiatorName=iqn.2015-04.be.linux:initiator
    [root@linux ~]# vi /etc/iscsi/iscsid.conf
    [root@linux ~]# grep ^node.session.au /etc/iscsi/iscsid.conf
    node.session.auth.authmethod = CHAP
    node.session.auth.username = paul
    node.session.auth.password = hunter2
    [root@linux ~]# fdisk -l 2>/dev/null | grep sd
    Disk /dev/sda: 22.0 GB, 22038806528 bytes, 43044544 sectors
    /dev/sda1   *        2048     1026047      512000   83  Linux
    /dev/sda2         1026048    43042815    21008384   8e  Linux LVM
    Disk /dev/sdb: 8589 MB, 8589934592 bytes, 16777216 sectors
    /dev/sdb1            2048      821247      409600   83  Linux
    /dev/sdb2          821248     1640447      409600   83  Linux
    /dev/sdb3         1640448     2459647      409600   83  Linux
    Disk /dev/sdc: 8589 MB, 8589934592 bytes, 16777216 sectors
    Disk /dev/sdd: 8589 MB, 8589934592 bytes, 16777216 sectors
    Disk /dev/sde: 2147 MB, 2147483648 bytes, 4194304 sectors
    Disk /dev/sdf: 2147 MB, 2147483648 bytes, 4194304 sectors
    [root@linux ~]# systemctl enable iscsid
    ln -s '/usr/lib/systemd/system/iscsid.service' '/etc/systemd/system/multi-user.target.wants/iscsid.service'
    [root@linux ~]# iscsiadm -m node -T iqn.2015-04.be.linux:target -p 192.168.1.143 -l
    Logging in to [iface: default, target: iqn.2015-04.be.linux:target, portal: 192.168.1.143,3260] (multiple)
    Login to [iface: default, target: iqn.2015-04.be.linux:target, portal: 192.168.1.143,3260] successful.

    [root@linux ~]# fdisk -l 2>/dev/null | grep sd
    Disk /dev/sda: 22.0 GB, 22038806528 bytes, 43044544 sectors
    /dev/sda1   *        2048     1026047      512000   83  Linux
    /dev/sda2         1026048    43042815    21008384   8e  Linux LVM
    Disk /dev/sdb: 8589 MB, 8589934592 bytes, 16777216 sectors
    /dev/sdb1            2048      821247      409600   83  Linux
    /dev/sdb2          821248     1640447      409600   83  Linux
    /dev/sdb3         1640448     2459647      409600   83  Linux
    Disk /dev/sdc: 8589 MB, 8589934592 bytes, 16777216 sectors
    Disk /dev/sdd: 8589 MB, 8589934592 bytes, 16777216 sectors
    Disk /dev/sde: 2147 MB, 2147483648 bytes, 4194304 sectors
    Disk /dev/sdf: 2147 MB, 2147483648 bytes, 4194304 sectors
    Disk /dev/sdg: 8589 MB, 8589934592 bytes, 16777216 sectors
    Disk /dev/sdh: 8589 MB, 8589934592 bytes, 16777216 sectors
    Disk /dev/sdi: 8589 MB, 8589934592 bytes, 16777216 sectors
    [root@linux ~]# 

