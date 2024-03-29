## install multipath

RHEL and CentOS need the `device-mapper-multipath`
package.

    yum install device-mapper-multipath

This will create a sample multipath.conf in
`/usr/share/doc/device-mapper-multipath-0.4.9/multipath.conf`.

There is no `/etc/multipath.conf` until you initialize it with
`mpathconf`.

    [root@server2 ~]# mpathconf --enable --with_multipathd y
    Starting multipathd daemon:                                [  OK  ]
    [root@server2 ~]# wc -l /etc/multipath.conf 
    99 /etc/multipath.conf

## configure multipath

You can now choose to either edit `/etc/multipath.conf` or use
`mpathconf` to change this file for you.

    [root@server2 ~]# grep user_friendly_names /etc/multipath.conf
        user_friendly_names yes
    #   user_friendly_names yes
    [root@server2 ~]# mpathconf --enable --user_friendly_names n
    [root@server2 ~]# grep user_friendly_names /etc/multipath.conf
        user_friendly_names no
    #   user_friendly_names yes
    [root@server2 ~]# mpathconf --enable --user_friendly_names y
    [root@server2 ~]# grep user_friendly_names /etc/multipath.conf
        user_friendly_names yes
    #   user_friendly_names yes

## network

This example uses three networks, make sure the iSCSI Target is
connected to all three networks.

    [root@server1 tgt]# ifconfig | grep -B1 192.168
    eth1      Link encap:Ethernet  HWaddr 08:00:27:4E:AB:8E  
              inet addr:192.168.1.98  Bcast:192.168.1.255  Mask:255.255.255.0
    --
    eth2      Link encap:Ethernet  HWaddr 08:00:27:3F:A9:D1  
              inet addr:192.168.2.98  Bcast:192.168.2.255  Mask:255.255.255.0
    --
    eth3      Link encap:Ethernet  HWaddr 08:00:27:94:52:26  
              inet addr:192.168.3.98  Bcast:192.168.3.255  Mask:255.255.255.0

The same must be true for the multipath Initiator:

    [root@server2 ~]# ifconfig | grep -B1 192.168
    eth1      Link encap:Ethernet  HWaddr 08:00:27:A1:43:41  
              inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0
    --
    eth2      Link encap:Ethernet  HWaddr 08:00:27:12:A8:70  
              inet addr:192.168.2.99  Bcast:192.168.2.255  Mask:255.255.255.0
    --
    eth3      Link encap:Ethernet  HWaddr 08:00:27:6E:99:9B  
              inet addr:192.168.3.99  Bcast:192.168.3.255  Mask:255.255.255.0

Test the triple discovery in three networks (screenshot newer than
above).

    [root@linux ~]# iscsiadm -m discovery -t st -p 192.168.1.150
    192.168.1.150:3260,1 iqn.2015-04.be.linux:target1
    [root@linux ~]# iscsiadm -m discovery -t st -p 192.168.2.150
    192.168.2.150:3260,1 iqn.2015-04.be.linux:target1
    [root@linux ~]# iscsiadm -m discovery -t st -p 192.168.3.150
    192.168.3.150:3260,1 iqn.2015-04.be.linux:target1

## start multipathd and iscsi

Time to start (or restart) both the multipathd and iscsi services:

    [root@server2 ~]# service multipathd restart
    Stopping multipathd daemon:                                [  OK  ]
    Starting multipathd daemon:                                [  OK  ]
    [root@server2 ~]# service iscsi restart
    Stopping iscsi:                                            [  OK  ]
    Starting iscsi:                                            [  OK  ]

This shows `fdisk` output when leaving the default friendly_names option
to yes. The bottom three are the multipath devices to use.

    [root@server2 ~]# fdisk -l | grep Disk
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
    Disk /dev/sdl: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdn: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdk: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdm: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdp: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/sdo: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/mapper/mpathh: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/mapper/mpathi: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    Disk /dev/mapper/mpathj: 1073 MB, 1073741824 bytes
    Disk identifier: 0x00000000
    [root@server2 ~]#

## multipath list

You can list the multipath connections and devices with `multipath -ll`.

    [root@server2 ~]# multipath -ll
    mpathj (1IET     00010001) dm-4 Reddy,VBOX HARDDISK
    size=1.0G features='0' hwhandler='0' wp=rw
    |-+- policy='round-robin 0' prio=1 status=active
    | `- 13:0:0:1 sdh 8:112 active ready running
    |-+- policy='round-robin 0' prio=1 status=enabled
    | `- 12:0:0:1 sdi 8:128 active ready running
    `-+- policy='round-robin 0' prio=1 status=enabled
      `- 14:0:0:1 sdm 8:192 active ready running
    mpathi (1IET     00010003) dm-3 Reddy,VBOX HARDDISK
    size=1.0G features='0' hwhandler='0' wp=rw
    |-+- policy='round-robin 0' prio=1 status=active
    | `- 13:0:0:3 sdk 8:160 active ready running
    |-+- policy='round-robin 0' prio=1 status=enabled
    | `- 12:0:0:3 sdn 8:208 active ready running
    `-+- policy='round-robin 0' prio=1 status=enabled
      `- 14:0:0:3 sdp 8:240 active ready running
    mpathh (1IET     00010002) dm-2 Reddy,VBOX HARDDISK
    size=1.0G features='0' hwhandler='0' wp=rw
    |-+- policy='round-robin 0' prio=1 status=active
    | `- 12:0:0:2 sdl 8:176 active ready running
    |-+- policy='round-robin 0' prio=1 status=enabled
    | `- 13:0:0:2 sdj 8:144 active ready running
    `-+- policy='round-robin 0' prio=1 status=enabled
      `- 14:0:0:2 sdo 8:224 active ready running
    [root@server2 ~]#

The IET (iSCSI Enterprise Target) ID should match the ones you see on
the Target server.

    [root@server1 ~]# tgt-admin -s | grep -e LUN -e IET -e dev
        LUN information:
            LUN: 0
                SCSI ID: IET     00010000
            LUN: 1
                SCSI ID: IET     00010001
                Backing store path: /dev/sdb
            LUN: 2
                SCSI ID: IET     00010002
                Backing store path: /dev/sdc
            LUN: 3
                SCSI ID: IET     00010003
                Backing store path: /dev/sdd

## using the device

The rest is standard mkfs, mkdir, mount:

    [root@server2 ~]# mkfs.ext4 /dev/mapper/mpathi
    mke2fs 1.41.12 (17-May-2010)
    Filesystem label=
    OS type: Linux
    Block size=4096 (log=2)
    Fragment size=4096 (log=2)
    Stride=0 blocks, Stripe width=0 blocks
    65536 inodes, 262144 blocks
    13107 blocks (5.00%) reserved for the super user
    First data block=0
    Maximum filesystem blocks=268435456
    8 block groups
    32768 blocks per group, 32768 fragments per group
    8192 inodes per group
    Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376

    Writing inode tables: done                            
    Creating journal (8192 blocks): done
    Writing superblocks and filesystem accounting information: done

    This filesystem will be automatically checked every 38 mounts or
    180 days, whichever comes first.  Use tune2fs -c or -i to override.
    [root@server2 ~]# mkdir /srv/multipath
    [root@server2 ~]# mount /dev/mapper/mpathi /srv/multipath/
    [root@server2 ~]# df -h /srv/multipath/
    Filesystem          Size  Used Avail Use% Mounted on
    /dev/mapper/mpathi 1008M   34M  924M   4% /srv/multipath

