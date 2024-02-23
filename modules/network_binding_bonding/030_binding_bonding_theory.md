## binding on Redhat/Fedora

### binding extra ip addresses

To bind more than one `ip address` to the same interface,
use `ifcfg-eth0:0`, where the last zero can be anything
else. Only two directives are required in the files.

    [root@linux ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0:0
    DEVICE="eth0:0"
    IPADDR="192.168.1.133"
    [root@linux ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0:1
    DEVICE="eth0:0"
    IPADDR="192.168.1.142"

### enabling extra ip-addresses

To activate a virtual network interface, use `ifup`, to
deactivate it, use `ifdown`.

    [root@linux ~]# ifup eth0:0
    [root@linux ~]# ifconfig | grep 'inet '
              inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0
              inet addr:192.168.1.133  Bcast:192.168.1.255  Mask:255.255.255.0
              inet addr:127.0.0.1  Mask:255.0.0.0
    [root@linux ~]# ifup eth0:1
    [root@linux ~]# ifconfig | grep 'inet '
              inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0
              inet addr:192.168.1.133  Bcast:192.168.1.255  Mask:255.255.255.0
              inet addr:192.168.1.142  Bcast:192.168.1.255  Mask:255.255.255.0
              inet addr:127.0.0.1  Mask:255.0.0.0

### verifying extra ip-addresses

Use `ping` from another computer to check the activation, or use
`ifconfig` like in this screenshot.

    [root@linux ~]# ifconfig 
    eth0   Link encap:Ethernet  HWaddr 08:00:27:DD:0D:5C  
           inet addr:192.168.1.99  Bcast:192.168.1.255  Mask:255.255.255.0
           inet6 addr: fe80::a00:27ff:fedd:d5c/64 Scope:Link
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:1259 errors:0 dropped:0 overruns:0 frame:0
           TX packets:545 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000 
           RX bytes:115260 (112.5 KiB)  TX bytes:84293 (82.3 KiB)

    eth0:0 Link encap:Ethernet  HWaddr 08:00:27:DD:0D:5C  
           inet addr:192.168.1.133  Bcast:192.168.1.255  Mask:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

    eth0:1 Link encap:Ethernet  HWaddr 08:00:27:DD:0D:5C  
           inet addr:192.168.1.142  Bcast:192.168.1.255  Mask:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

## binding on Debian/Ubuntu

### binding extra ip addresses

The configuration of multiple ip addresses on the same network card is
done in `/etc/network/interfaces` by adding `eth0:x`
devices. Adding the `netmask` is mandatory.

    debian10:~# cat /etc/network/interfaces
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    # The loopback network interface
    auto lo
    iface lo inet loopback

    # The primary network interface
    iface eth0 inet static
    address 192.168.1.34
    network 192.168.1.0
    netmask 255.255.255.0
    gateway 192.168.1.1
    auto eth0

    auto eth0:0
    iface eth0:0 inet static
    address 192.168.1.233
    netmask 255.255.255.0

    auto eth0:1
    iface eth0:1 inet static
    address 192.168.1.242
    netmask 255.255.255.0

### enabling extra ip-addresses

Use `ifup` to enable the extra addresses.

    debian10:~# ifup eth0:0
    debian10:~# ifup eth0:1

### verifying extra ip-addresses

Use `ping` from another computer to check the activation, or use
`ifconfig` like in this screenshot.

    debian10:~# ifconfig | grep 'inet '
          inet addr:192.168.1.34  Bcast:192.168.1.255  Mask:255.255.255.0
          inet addr:192.168.1.233  Bcast:192.168.1.255  Mask:255.255.255.0
          inet addr:192.168.1.242  Bcast:192.168.1.255  Mask:255.255.255.0
          inet addr:127.0.0.1  Mask:255.0.0.0

## bonding on Redhat/Fedora

We start with `ifconfig -a` to get a list of all the
network cards on our system.

    [root@linux network-scripts]# ifconfig -a | grep Ethernet
    eth0      Link encap:Ethernet  HWaddr 08:00:27:DD:0D:5C  
    eth1      Link encap:Ethernet  HWaddr 08:00:27:DA:C1:49  
    eth2      Link encap:Ethernet  HWaddr 08:00:27:40:03:3B

In this demo we decide to bond `eth1` and `eth2`.

We will name our bond `bond0` and add this entry to `modprobe` so the
kernel can load the `bonding module` when we bring the interface up.

    [root@linux network-scripts]# cat /etc/modprobe.d/bonding.conf 
    alias bond0 bonding

Then we create
`/etc/sysconfig/network-scripts/ifcfg-bond0` to configure
our `bond0` interface.

    [root@linux network-scripts]# pwd
    /etc/sysconfig/network-scripts
    [root@linux network-scripts]# cat ifcfg-bond0 
    DEVICE=bond0
    IPADDR=192.168.1.199
    NETMASK=255.255.255.0
    ONBOOT=yes
    BOOTPROTO=none
    USERCTL=no

Next we create two files, one for each network card that we will use as
slave in `bond0`.

    [root@linux network-scripts]# cat ifcfg-eth1
    DEVICE=eth1
    BOOTPROTO=none
    ONBOOT=yes
    MASTER=bond0
    SLAVE=yes
    USERCTL=no
    [root@linux network-scripts]# cat ifcfg-eth2
    DEVICE=eth2
    BOOTPROTO=none
    ONBOOT=yes
    MASTER=bond0
    SLAVE=yes
    USERCTL=no

Finally we bring the interface up with `ifup bond0`.

    [root@linux network-scripts]# ifup bond0
    [root@linux network-scripts]# ifconfig bond0
    bond0     Link encap:Ethernet  HWaddr 08:00:27:DA:C1:49  
              inet addr:192.168.1.199  Bcast:192.168.1.255  Mask:255.255.255.0
              inet6 addr: fe80::a00:27ff:feda:c149/64 Scope:Link
              UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1
              RX packets:251 errors:0 dropped:0 overruns:0 frame:0
              TX packets:21 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:39852 (38.9 KiB)  TX bytes:1070 (1.0 KiB)

The `bond` should also be visible in `/proc/net/bonding`.

    [root@linux network-scripts]# cat /proc/net/bonding/bond0 
    Ethernet Channel Bonding Driver: v3.5.0 (November 4, 2008)

    Bonding Mode: load balancing (round-robin)
    MII Status: up
    MII Polling Interval (ms): 0
    Up Delay (ms): 0
    Down Delay (ms): 0

    Slave Interface: eth1
    MII Status: up
    Link Failure Count: 0
    Permanent HW addr: 08:00:27:da:c1:49

    Slave Interface: eth2
    MII Status: up
    Link Failure Count: 0
    Permanent HW addr: 08:00:27:40:03:3b

## bonding on Debian/Ubuntu

We start with `ifconfig -a` to get a list of all the
network cards on our system.

    debian10:~# ifconfig -a | grep Ethernet
    eth0      Link encap:Ethernet  HWaddr 08:00:27:bb:18:a4
    eth1      Link encap:Ethernet  HWaddr 08:00:27:63:9a:95
    eth2      Link encap:Ethernet  HWaddr 08:00:27:27:a4:92

In this demo we decide to bond `eth1` and `eth2`.

We also need to install the `ifenslave` package.

    debian10:~# aptitude search ifenslave
    p ifenslave     - Attach and detach slave interfaces to a bonding device
    p ifenslave-2.6 - Attach and detach slave interfaces to a bonding device
    debian10:~# aptitude install ifenslave
    Reading package lists... Done
    ...

Next we update the `/etc/network/interfaces` file with
information about the `bond0` interface.

    debian10:~# tail -7 /etc/network/interfaces
    iface bond0 inet static
     address 192.168.1.42
     netmask 255.255.255.0
     gateway 192.168.1.1
     slaves eth1 eth2
     bond-mode active-backup
     bond_primary eth1

On older version of Debian/Ubuntu you needed to `modprobe bonding`, but
this is no longer required. Use `ifup` to bring the interface up, then
test that it works.

    debian10:~# ifup bond0
    debian10:~# ifconfig bond0
    bond0     Link encap:Ethernet  HWaddr 08:00:27:63:9a:95  
              inet addr:192.168.1.42  Bcast:192.168.1.255  Mask:255.255.255.0
              inet6 addr: fe80::a00:27ff:fe63:9a95/64 Scope:Link
              UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1
              RX packets:212 errors:0 dropped:0 overruns:0 frame:0
              TX packets:39 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:31978 (31.2 KiB)  TX bytes:6709 (6.5 KiB)

The `bond` should also be visible in `/proc/net/bonding`.

    debian10:~# cat /proc/net/bonding/bond0 
    Ethernet Channel Bonding Driver: v3.2.5 (March 21, 2008)

    Bonding Mode: fault-tolerance (active-backup)
    Primary Slave: eth1
    Currently Active Slave: eth1
    MII Status: up
    MII Polling Interval (ms): 0
    Up Delay (ms): 0
    Down Delay (ms): 0

    Slave Interface: eth1
    MII Status: up
    Link Failure Count: 0
    Permanent HW addr: 08:00:27:63:9a:95

    Slave Interface: eth2
    MII Status: up
    Link Failure Count: 0
    Permanent HW addr: 08:00:27:27:a4:92

