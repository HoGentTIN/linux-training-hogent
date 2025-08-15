## to gui or not to gui

Recent Linux distributions often include a graphical application to
configure the network. Some people complain that these applications mess
networking configurations up when used simultaneously with command line
configurations. Notably `Network Manager` (often replaced by `wicd`) and
`yast` are known to not care about configuration changes via the command
line.

Since the goal of this course is `server` administration, we will assume
our Linux servers are always administered through the command line.

This chapter only focuses on using the command line for network
interface configuration!

Unfortunately there is no single combination of Linux commands and
`/etc` files that works on all Linux distributions. We discuss
networking on two (large but distinct) Linux distribution families.

We start with `Debian` (this should also work on Ubuntu and Mint), then
continue with `RHEL` (which is identical to CentOS and Fedora).

## Debian nic configuration

### /etc/network/interfaces

The `/etc/network/interfaces` file is a core network
interface card configuration file on `debian`.

#### dhcp client

The screenshot below shows that our computer is configured for
`dhcp` on `eth0` (the first network
interface card or nic).

    student@linux:~$ cat /etc/network/interfaces
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    # The loopback network interface
    auto lo
    iface lo inet loopback

    auto eth0
    iface eth0 inet dhcp

Configuring network cards for `dhcp` is good practice for clients, but
servers usually require a `fixed ip address`.

#### fixed ip

The screenshot below shows `/etc/network/interfaces` configured with a
`fixed ip address`.

    root@linux~# cat /etc/network/interfaces
    auto lo
    iface lo inet loopback

    auto  eth0
    iface eth0 inet static
    address   10.42.189.198
    broadcast 10.42.189.207
    netmask   255.255.255.240
    gateway   10.42.189.193

The screenshot above also shows that you can provide more configuration
than just the ip address. See `interfaces(5)` for help on setting a
`gateway`, `netmask` or any of the other options.

### /sbin/ifdown

It is adviced (but not mandatory) to down an interface before changing
its configuration. This can be done with the `ifdown`
command.

The command will not give any output when downing an interface with a
fixed ip address. However `ifconfig` will no longer show the interface.

    root@ubu1104srv:~# ifdown eth0
    root@ubu1104srv:~# ifconfig
    lo   Link encap:Local Loopback  
         inet addr:127.0.0.1  Mask:255.0.0.0
         inet6 addr: ::1/128 Scope:Host
         UP LOOPBACK RUNNING  MTU:16436  Metric:1
         RX packets:106 errors:0 dropped:0 overruns:0 frame:0
         TX packets:106 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:0 
         RX bytes:11162 (11.1 KB)  TX bytes:11162 (11.1 KB)

An interface that is down cannot be used to connect to the network.

### /sbin/ifup

Below a screenshot of `ifup` bringing the `eth0` ethernet
interface up using dhcp. (Note that this is a Ubuntu 10.10 screenshot,
Ubuntu 11.04 omits `ifup` output by default.)

    root@linux:/etc/network# ifup eth0
    Internet Systems Consortium DHCP Client V3.1.3
    Copyright 2004-2009 Internet Systems Consortium.
    All rights reserved.
    For info, please visit https://www.isc.org/software/dhcp/

    Listening on LPF/eth0/08:00:27:cd:7f:fc
    Sending on   LPF/eth0/08:00:27:cd:7f:fc
    Sending on   Socket/fallback
    DHCPREQUEST of 192.168.1.34 on eth0 to 255.255.255.255 port 67
    DHCPNAK from 192.168.33.100
    DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 3
    DHCPOFFER of 192.168.33.77 from 192.168.33.100
    DHCPREQUEST of 192.168.33.77 on eth0 to 255.255.255.255 port 67
    DHCPACK of 192.168.33.77 from 192.168.33.100
    bound to 192.168.33.77 -- renewal in 95 seconds.
    ssh stop/waiting
    ssh start/running, process 1301
    root@linux:/etc/network#

The details of `dhcp` are covered in a separate chapter in the
`Linux Servers` course.

## RHEL nic configuration

### /etc/sysconfig/network

The `/etc/sysconfig/network` file is a global (across all
network cards) configuration file. It allows us to define whether we
want networking (NETWORKING=yes\|no), what the hostname should be
(HOSTNAME=) and which gateway to use (GATEWAY=).

    [root@linux ~]# cat /etc/sysconfig/network
    NETWORKING=yes
    HOSTNAME=rhel610
    GATEWAY=192.168.1.1

There are a dozen more options settable in this file, details can be
found in `/usr/share/doc/initscripts-*/sysconfig.txt`.

Note that this file contains no settings at all in a default RHEL7
install (with networking enabled).

    [root@linux ~]# cat /etc/sysconfig/network
    # Created by anaconda

### /etc/sysconfig/network-scripts/ifcfg-

Each network card can be configured individually using the
`/etc/sysconfig/network-scripts/ifcfg-*` files. When you
have only one network card, then this will probably be
`/etc/sysconfig/network-scripts/ifcfg-eth0`.

#### dhcp client

Below a screenshot of `/etc/sysconfig/network-scripts/ifcfg-eth0`
configured for dhcp (BOOTPROTO=\"dhcp\"). Note also the NM_CONTROLLED
paramater to disable control of this nic by `Network Manager`. This
parameter is not explained (not even mentioned) in
`/usr/share/doc/initscripts-*/sysconfig.txt`, but many others are.

    [root@linux ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
    DEVICE="eth0"
    HWADDR="08:00:27:DD:0D:5C"
    NM_CONTROLLED="no"
    BOOTPROTO="dhcp"
    ONBOOT="yes"

The BOOTPROTO variable can be set to either `dhcp` or
`bootp`, anything else will be considered `static` meaning
there should be no protocol used at boot time to set the interface
values.

RHEL7 adds `ipv6` variables to this file.

    [root@linux network-scripts]# cat ifcfg-enp0s3
    TYPE="Ethernet"
    BOOTPROTO="dhcp"
    DEFROUTE="yes"
    PEERDNS="yes"
    PEERROUTES="yes"
    IPV4_FAILURE_FATAL="no"
    IPV6INIT="yes"
    IPV6_AUTOCONF="yes"
    IPV6_DEFROUTE="yes"
    IPV6_PEERDNS="yes"
    IPV6_PEERROUTES="yes"
    IPV6_FAILURE_FATAL="no"
    NAME="enp0s3"
    UUID="9fa6a83a-2f8e-4ecc-962c-5f614605f4ee"
    DEVICE="enp0s3"
    ONBOOT="yes"
    [root@linux network-scripts]#

#### fixed ip

Below a screenshot of a `fixed ip` configuration in
`/etc/sysconfig/network-scripts/ifcfg-eth0`.

    [root@linux ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
    DEVICE="eth0"
    HWADDR="08:00:27:DD:0D:5C"
    NM_CONTROLLED="no"
    BOOTPROTO="none"
    IPADDR="192.168.1.99"
    NETMASK="255.255.255.0"
    GATEWAY="192.168.1.1"
    ONBOOT="yes"

The HWADDR can be used to make sure that each network card gets the
correct name when multiple network cards are present in the computer. It
can not be used to assign a `mac address` to a network card. For this,
you need to specify the MACADDR variable. Do not use HWADDR and MACADDR
in the same `ifcfg-ethx` file.

The BROADCAST= and NETWORK= parameters from previous RHEL/Fedora
versions are obsoleted.

### nmcli

On RHEL7 you should run `nmcli connection reload` if you changed
configuration files in `/etc/sysconfig/` to enable your changes.

The `nmcli` tool has many options to configure networking on the command
line in RHEL7/CentOS8

    man nmcli

### nmtui

Another recommendation for RHEL7/CentOS8 is to use `nmtui`. This tool
will use a 'windowed' interface in command line to manage network
interfaces.

    nmtui

### /sbin/ifup and /sbin/ifdown

The `ifup` and `ifdown` commands will set an
interface up or down, using the configuration discussed above. This is
identical to their behaviour in Debian and Ubuntu.

    [root@linux ~]# ifdown eth0 && ifup eth0
    [root@linux ~]# ifconfig eth0
    eth0 Link encap:Ethernet  HWaddr 08:00:27:DD:0D:5C  
         inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0
         inet6 addr: fe80::a00:27ff:fedd:d5c/64 Scope:Link
         UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
         RX packets:2452 errors:0 dropped:0 overruns:0 frame:0
         TX packets:1881 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:1000 
         RX bytes:257036 (251.0 KiB)  TX bytes:184767 (180.4 KiB)

## ifconfig

The use of `/sbin/ifconfig` without any arguments will
present you with a list of all active network interface cards, including
wireless and the loopback interface. In the screenshot below `eth0` has
no ip address.

    root@ubuntu1604:~# ifconfig 
    eth0 Link encap:Ethernet  HWaddr 00:26:bb:5d:2e:52  
         UP BROADCAST MULTICAST  MTU:1500  Metric:1
         RX packets:0 errors:0 dropped:0 overruns:0 frame:0
         TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:1000 
         RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
         Interrupt:43 Base address:0xe000 

    eth1 Link encap:Ethernet  HWaddr 00:26:bb:12:7a:5e  
         inet addr:192.168.1.30  Bcast:192.168.1.255  Mask:255.255.255.0
         inet6 addr: fe80::226:bbff:fe12:7a5e/64 Scope:Link
         UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
         RX packets:11141791 errors:202 dropped:0 overruns:0 frame:11580126
         TX packets:6473056 errors:3860 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:1000 
         RX bytes:3476531617 (3.4 GB)  TX bytes:2114919475 (2.1 GB)
         Interrupt:23 

    lo   Link encap:Local Loopback  
         inet addr:127.0.0.1  Mask:255.0.0.0
         inet6 addr: ::1/128 Scope:Host
         UP LOOPBACK RUNNING  MTU:16436  Metric:1
         RX packets:2879 errors:0 dropped:0 overruns:0 frame:0
         TX packets:2879 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:0 
         RX bytes:486510 (486.5 KB)  TX bytes:486510 (486.5 KB)

You can also use `ifconfig` to obtain information about just one network
card.

    [root@linux ~]# ifconfig eth0
    eth0 Link encap:Ethernet  HWaddr 08:00:27:DD:0D:5C  
         inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0
         inet6 addr: fe80::a00:27ff:fedd:d5c/64 Scope:Link
         UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
         RX packets:2969 errors:0 dropped:0 overruns:0 frame:0
         TX packets:1918 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:1000 
         RX bytes:335942 (328.0 KiB)  TX bytes:190157 (185.7 KiB)

When `/sbin` is not in the `$PATH` of a normal user you
will have to type the full path, as seen here on Debian.

    student@linux:~$ /sbin/ifconfig eth3
    eth3 Link encap:Ethernet  HWaddr 08:00:27:ab:67:30  
         inet addr:192.168.1.29  Bcast:192.168.1.255  Mask:255.255.255.0
         inet6 addr: fe80::a00:27ff:feab:6730/64 Scope:Link
         UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
         RX packets:27155 errors:0 dropped:0 overruns:0 frame:0
         TX packets:30527 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:1000 
         RX bytes:13095386 (12.4 MiB)  TX bytes:25767221 (24.5 MiB)

### up and down

You can also use `ifconfig` to bring an interface up or
down. The difference with `ifup` is that
`ifconfig eth0 up` will re-activate the nic keeping its existing
(current) configuration, whereas `ifup` will read the correct file that
contains a (possibly new) configuration and use this config file to
bring the interface up.

    [root@linux ~]# ifconfig eth0 down
    [root@linux ~]# ifconfig eth0 up
    [root@linux ~]# ifconfig eth0
    eth0 Link encap:Ethernet  HWaddr 08:00:27:DD:0D:5C
         inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0
         inet6 addr: fe80::a00:27ff:fedd:d5c/64 Scope:Link
         UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
         RX packets:2995 errors:0 dropped:0 overruns:0 frame:0
         TX packets:1927 errors:0 dropped:0 overruns:0 carrier:0
         collisions:0 txqueuelen:1000 
         RX bytes:339030 (331.0 KiB)  TX bytes:191583 (187.0 KiB)

### setting ip address

You can `temporary` set an ip address with `ifconfig`. This ip address
is only valid until the next `ifup/ifdown` cycle or until
the next `reboot`.

    [root@linux ~]# ifconfig eth0 | grep 192
         inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0
    [root@linux ~]# ifconfig eth0 192.168.33.42 netmask 255.255.0.0
    [root@linux ~]# ifconfig eth0 | grep 192
         inet addr:192.168.33.42  Bcast:192.168.255.255  Mask:255.255.0.0
    [root@linux ~]# ifdown eth0 && ifup eth0
    [root@linux ~]# ifconfig eth0 | grep 192
         inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0

### setting mac address

You can also use `ifconfig` to set another `mac address`
than the one hard coded in the network card. This screenshot shows you
how.

    [root@linux ~]# ifconfig eth0 | grep HWaddr
    eth0 Link encap:Ethernet  HWaddr 08:00:27:DD:0D:5C  
    [root@linux ~]# ifconfig eth0 hw ether 00:42:42:42:42:42
    [root@linux ~]# ifconfig eth0 | grep HWaddr
    eth0 Link encap:Ethernet  HWaddr 00:42:42:42:42:42

## ip

The `ifconfig` tool is deprecated on some systems. Use the `ip` tool
instead.

To see ip addresses on RHEL7 for example, use this command:

    [root@linux ~]# ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 08:00:27:89:22:33 brd ff:ff:ff:ff:ff:ff
        inet 192.168.1.135/24 brd 192.168.1.255 scope global dynamic enp0s3
           valid_lft 6173sec preferred_lft 6173sec
        inet6 fe80::a00:27ff:fe89:2233/64 scope link
           valid_lft forever preferred_lft forever
    [root@linux ~]#

## dhclient

Home and client Linux desktops often have `/sbin/dhclient`
running. This is a daemon that enables a network interface to lease an
ip configuration from a `dhcp server`. When your adapter
is configured for `dhcp` or `bootp`, then `/sbin/ifup` will start the
`dhclient` daemon.

When a lease is renewed, `dhclient` will override your `ifconfig` set ip
address!

## hostname

Every host receives a `hostname`, often placed in a
`DNS name space` forming the `fqdn` or Fully Qualified
Domain Name.

This screenshot shows the `hostname` command and the configuration of
the hostname on Red Hat/Fedora.

    [root@linux ~]# grep HOSTNAME /etc/sysconfig/network
    HOSTNAME=rhel610
    [root@linux ~]# hostname
    rhel6

Starting with RHEL7/CentOS8 this file is empty. The hostname is
configured in the standard `/etc/hostname` file.

    [root@linux ~]# cat /etc/hostname
    rhel76.linux-training.be
    [root@linux ~]#

Ubuntu/Debian uses the `/etc/hostname` file to configure
the `hostname`.

    student@linux:~$ cat /etc/hostname
    server42
    student@linux:~$ hostname
    server42

On all Linux distributions you can change the `hostname`
using the `hostname $newname` command. This is not a permanent change.

    [root@linux ~]# hostname server42
    [root@linux ~]# hostname
    server42

On any Linux you can use `sysctl` to display and set the
hostname.

    [root@linux ~]# sysctl kernel.hostname
    kernel.hostname = server42
    [root@linux ~]# sysctl kernel.hostname=rhel6
    kernel.hostname = rhel6
    [root@linux ~]# sysctl kernel.hostname
    kernel.hostname = rhel610
    [root@linux ~]# hostname
    rhel610

## arp

The `ip to mac` resolution is handled by the `layer two broadcast`
protocol `arp`. The `arp table` can be displayed with the
`arp tool`. The screenshot below shows the list of computers that this
computer recently communicated with.

    root@linux:~# arp -a
    ? (192.168.1.191) at 00:0C:29:3B:15:80 [ether] on eth1
    agapi (192.168.1.73) at 00:03:BA:09:7F:D2 [ether] on eth1
    anya (192.168.1.1) at 00:12:01:E2:87:FB [ether] on eth1
    faith (192.168.1.41) at 00:0E:7F:41:0D:EB [ether] on eth1
    kiss (192.168.1.49) at 00:D0:E0:91:79:95 [ether] on eth1
    laika (192.168.1.40) at 00:90:F5:4E:AE:17 [ether] on eth1
    pasha (192.168.1.71) at 00:03:BA:02:C3:82 [ether] on eth1
    shaka (192.168.1.72) at 00:03:BA:09:7C:F9 [ether] on eth1
    root@linux:~#

*Anya is a Cisco Firewall, faith is a laser printer, kiss is a Kiss
DP600, laika is a laptop and Agapi, Shaka and Pasha are SPARC servers.
The question mark is a Red Hat Enterprise Linux server running on a
virtual machine.*

You can use `arp -d` to remove an entry from the
`arp table`.

    [root@linux ~]# arp
    Address             HWtype  HWaddress           Flags Mask       Iface
    ubu1010             ether   00:26:bb:12:7a:5e   C                eth0
    anya                ether   00:02:cf:aa:68:f0   C                eth0
    [root@linux ~]# arp -d anya
    [root@linux ~]# arp
    Address             HWtype  HWaddress           Flags Mask       Iface
    ubuntu1604             ether   00:26:bb:12:7a:5e   C                eth0
    anya                        (incomplete)                         eth0
    [root@linux ~]# ping anya
    PING anya (192.168.1.1) 56(84) bytes of data.
    64 bytes from anya (192.168.1.1): icmp_seq=1 ttl=254 time=10.2 ms
    ...
    [root@linux ~]# arp
    Address             HWtype  HWaddress           Flags Mask       Iface
    ubuntu1604          ether   00:26:bb:12:7a:5e   C                eth0
    anya                ether   00:02:cf:aa:68:f0   C                eth0

## route

You can see the computer's local routing table with the
`/sbin/route` command (and also with
`netstat -r` ).

    root@linux ~]# netstat -r
    Kernel IP routing table
    Destination     Gateway   Genmask         Flags   MSS Window  irtt Iface
    192.168.1.0     *         255.255.255.0   U         0 0          0 eth0
    [root@linux ~]# route
    Kernel IP routing table
    Destination     Gateway   Genmask         Flags Metric Ref    Use Iface
    192.168.1.0     *         255.255.255.0   U     0      0        0 eth0
    [root@linux ~]#

It appears this computer does not have a `gateway`
configured, so we use `route add default gw` to add a
`default gateway` on the fly.

    [root@linux ~]# route add default gw 192.168.1.1
    [root@linux ~]# route
    Kernel IP routing table
    Destination     Gateway      Genmask        Flags Metric Ref  Use Iface
    192.168.1.0     *            255.255.255.0  U     0      0      0 eth0
    default         192.168.1.1  0.0.0.0        UG    0      0      0 eth0
    [root@linux ~]#

Unless you configure the gateway in one of the `/etc/` file from the
start of this chapter, your computer will forget this `gateway` after a
reboot.

## ping

If you can `ping` to another host, then `tcp/ip` is
configured.

    [root@linux ~]# ping 192.168.1.5
    PING 192.168.1.5 (192.168.1.5) 56(84) bytes of data.
    64 bytes from 192.168.1.5: icmp_seq=0 ttl=64 time=1004 ms
    64 bytes from 192.168.1.5: icmp_seq=1 ttl=64 time=1.19 ms
    64 bytes from 192.168.1.5: icmp_seq=2 ttl=64 time=0.494 ms
    64 bytes from 192.168.1.5: icmp_seq=3 ttl=64 time=0.419 ms

    --- 192.168.1.5 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3009ms
    rtt min/avg/max/mdev = 0.419/251.574/1004.186/434.520 ms, pipe 2
    [root@linux ~]#

## optional: ethtool

To display or change network card settings, use `ethtool`.
The results depend on the capabilities of your network card. The example
shows a network that auto-negotiates it's bandwidth.

    root@linux:~# ethtool eth0
    Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Advertised auto-negotiation: Yes
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00000033 (51)
        Link detected: yes

This example shows how to use ethtool to switch the bandwidth from
1000Mbit to 100Mbit and back. Note that some time passes before the nic
is back to 1000Mbit.

    root@linux:~# ethtool eth0 | grep Speed
        Speed: 1000Mb/s
    root@linux:~# ethtool -s eth0 speed 100
    root@linux:~# ethtool eth0 | grep Speed
        Speed: 100Mb/s
    root@linux:~# ethtool -s eth0 speed 1000
    root@linux:~# ethtool eth0 | grep Speed
        Speed: 1000Mb/s

