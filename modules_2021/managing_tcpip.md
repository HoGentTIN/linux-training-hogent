# Managing tcp/ip

## network adapters


Every server has one or more network adapters. You can see a list of
network adapters in **/sys/class/net**. The files in there are symbolic
links to **/sys/devices/**.

    paul@debian10:$ ls /sys/class/net/
    enp0s3  enp0s8  lo
    paul@debian10:$

## ip a


The first tool of this chapter is the **ip** tool. Most common use is
maybe **ip a** to get IP-address, subnet and MAC information from all
network adapters. This includes the loopback adapter named **lo**.

Our **debian10** server of this screenshot has IP-address 192.168.56.101
on interface enp0s3 and IP-address 10.0.2.101 on interface enp0s8 (Look
behind **inet**). After the **inet6** keyword are the IPv6 addresses for
this server.

    paul@debian10:$ ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 08:00:27:3f:27:a6 brd ff:ff:ff:ff:ff:ff
        inet 192.168.56.101/24 brd 192.168.56.255 scope global dynamic enp0s3
           valid_lft 1157sec preferred_lft 1157sec
        inet6 fe80::a00:27ff:fe3f:27a6/64 scope link
           valid_lft forever preferred_lft forever
    3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 08:00:27:ff:0c:3c brd ff:ff:ff:ff:ff:ff
        inet 10.0.2.101/24 brd 10.0.2.255 scope global enp0s8
           valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:feff:c3c/64 scope link
           valid_lft forever preferred_lft forever
    paul@debian10:$

You can show information about just one adapter by typing **ip a s dev**
followed by the adapter name. The **a** is short for **address**, and
the **s** is short for **show**.

    paul@debian10:$ ip a s dev enp0s3
    2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 08:00:27:3f:27:a6 brd ff:ff:ff:ff:ff:ff
        inet 192.168.56.101/24 brd 192.168.56.255 scope global dynamic enp0s3
           valid_lft 948sec preferred_lft 948sec
        inet6 fe80::a00:27ff:fe3f:27a6/64 scope link
           valid_lft forever preferred_lft forever
    paul@debian10:$

## net-tools


Wait, what about the **ifconfig** command, isn’t that the standard on
Debian Linux? The answer is **not anymore**. The **ifconfig** command is
part of the **net-tools** package, which is no longer installed by
default. But it still works, as this screenshot shows.

    paul@debian10:$ /sbin/ifconfig enp0s3
    enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 192.168.56.101  netmask 255.255.255.0  broadcast 192.168.56.255
            inet6 fe80::a00:27ff:fe3f:27a6  prefixlen 64  scopeid 0x20<link>
            ether 08:00:27:3f:27:a6  txqueuelen 1000  (Ethernet)
            RX packets 1091  bytes 93631 (91.4 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 645  bytes 108797 (106.2 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    paul@debian10:$

## ip n


Next is the **ip n** command to show the **ARP table** of the server.
Whenever your server has contact with another device on the network,
then it’s MAC-address will be kept in the **ARP cache** (for a while).
You can see this **ARP cache** with the **ip n** command (n is short for
**neighbour**).

    paul@debian10:$ ip n
    192.168.56.102 dev enp0s3 lladdr 08:00:27:f5:54:03 REACHABLE
    10.0.2.1 dev enp0s8 lladdr 52:54:00:12:35:00 STALE
    192.168.56.100 dev enp0s3 lladdr 08:00:27:b4:90:ab STALE
    192.168.56.1 dev enp0s3 lladdr 0a:00:27:00:00:00 REACHABLE
    paul@debian10:$

The **net-tools** equivalent of this command is the **arp** command,
which in my humble opinion gives a much more readable output than **ip
n**.

    paul@debian10:$ /sbin/arp
    Address                  HWtype  HWaddress           Flags Mask            Iface
    192.168.56.102           ether   08:00:27:f5:54:03   C                     enp0s3
    10.0.2.1                 ether   52:54:00:12:35:00   C                     enp0s8
    192.168.56.100           ether   08:00:27:b4:90:ab   C                     enp0s3
    192.168.56.1             ether   0a:00:27:00:00:00   C                     enp0s3
    paul@debian10:$

## ip r


Type **ip r** to see the **routing table** of your server. The
screenshot shows that 10.0.2.1 is the **default gateway** and the server
is connected to two subnets (192.168.56.0/24 and 10.0.2.0/24).

    paul@debian10:$ ip r
    default via 10.0.2.1 dev enp0s8 onlink
    10.0.2.0/24 dev enp0s8 proto kernel scope link src 10.0.2.101
    169.254.0.0/16 dev enp0s8 scope link metric 1000
    192.168.56.0/24 dev enp0s3 proto kernel scope link src 192.168.56.101
    paul@debian10:$

Again I personally find the output of the net-tools **route** command
much more readable. This is identical to typing **netstat -nr** (which
is also from net-tools).

    paul@debian10:$ /sbin/route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    default         10.0.2.1        0.0.0.0         UG    0      0        0 enp0s8
    10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 enp0s8
    link-local      0.0.0.0         255.255.0.0     U     1000   0        0 enp0s8
    192.168.56.0    0.0.0.0         255.255.255.0   U     0      0        0 enp0s3
    paul@debian10:$

## /etc/network/interfaces


Configuration of network interfaces is done in the
**/etc/network/interfaces** file. The first interface defined in this
file is often the **loopback** interface. You probably never have to
change this.

    # The loopback network interface
    auto lo
    iface lo inet loopback

Next is the primary interface, which is usually configured when
installing the Debian server. In this example DHCP is used (even though
the server gets a fixed IP-address from DHCP). The name of the network
adapter **enp0s3** can be different on your server.

    # The primary network interface
    allow-hotplug enp0s3
    iface enp0s3 inet dhcp

Our server has a fixed IP-address on the second network card. The fixed
IP is 10.0.2.101 and the subnet mask is 255.255.255.0 (or /24). This
interface also has a default gateway.

    allow-hotplug enp0s8
    iface enp0s8 inet static
    address 10.0.2.101
    netmask 255.255.255.0
    gateway 10.0.2.1

For DHCPv6 (to obtain an IPv6) address add the following line to the
interface configuration.

    iface enp0s8 inet6 auto

## ifup & ifdown


You can turn off an interface with the **ifdown** command. And you can
turn it back on with **ifup**. These commands will use the information
in **/etc/network/interfaces** . Nothing much seems to happen in this
screenshot because **enp0s8** has a fixed IP-address.

Do not do an **ifdown** of the interface over which you are connected.

    root@debian10:# ifdown enp0s8
    root@debian10:# ifup enp0s8
    root@debian10:~#

Using **ifdown** and **ifup** on the **enp0s3** interface provides a lot
of output because this interface is configured to use DHCP. The
**ifdown** command will release the IP-address from the DHCP server.

    root@debian10:# ifdown enp0s3
    Killed old client process
    Internet Systems Consortium DHCP Client 4.4.1
    Copyright 2004-2018 Internet Systems Consortium.
    All rights reserved.
    For info, please visit https://www.isc.org/software/dhcp/

    Listening on LPF/enp0s3/08:00:27:3f:27:a6
    Sending on   LPF/enp0s3/08:00:27:3f:27:a6
    Sending on   Socket/fallback
    DHCPRELEASE of 192.168.56.101 on enp0s3 to 192.168.56.100 port 67
    root@debian10:#

Using **ifup** will again contact the DHCP server to get an IP-address.
Depending on the configuration of the DHCP server this can be the same
IP-address or a new one. Setting up a DHCP server is a whole new chapter
later in this book.

    root@debian10:# ifup enp0s3
    Internet Systems Consortium DHCP Client 4.4.1
    Copyright 2004-2018 Internet Systems Consortium.
    All rights reserved.
    For info, please visit https://www.isc.org/software/dhcp/

    Listening on LPF/enp0s3/08:00:27:3f:27:a6
    Sending on   LPF/enp0s3/08:00:27:3f:27:a6
    Sending on   Socket/fallback
    DHCPDISCOVER on enp0s3 to 255.255.255.255 port 67 interval 8
    DHCPOFFER of 192.168.56.101 from 192.168.56.100
    DHCPREQUEST for 192.168.56.101 on enp0s3 to 255.255.255.255 port 67
    DHCPACK of 192.168.56.101 from 192.168.56.100
    bound to 192.168.56.101 -- renewal in 558 seconds.
    root@debian10:#

## /etc/resolv.conf


Usually when using DHCP then the **/etc/resolv.conf** file will be
automatically configured to contain the correct DNS server. If not, then
you can manually add a DNS server in this file. In the example below we
use **8.8.8.8** as a DNS server.

    root@debian10:# cat /etc/resolv.conf
    domain lan
    search lan
    nameserver 8.8.8.8
    root@debian10:#

## /etc/services


Debian Linux comes with an extensive list of ports for TCP and UDP in
the **/etc/services** file. Here you (and applications) can find
applications related to a certain port.

    root@debian10:# head -30 /etc/services | tail -6
    chargen         19/tcp          ttytst source
    chargen         19/udp          ttytst source
    ftp-data        20/tcp
    ftp             21/tcp
    fsp             21/udp          fspd
    ssh             22/tcp                          # SSH Remote Login Protocol
    root@debian10:#

## /etc/protocols


The **/etc/protocols** file contains protocols like TCP, UDP and ICMP
associated with a number to be used in the IP-datagram. You probably
never need this file, when talking about protocols people actually mean
protocols in **/etc/services**.

    root@debian10:# head -20 /etc/protocols | tail -5
    tcp     6       TCP             # transmission control protocol
    egp     8       EGP             # exterior gateway protocol
    igp     9       IGP             # any private interior gateway (Cisco)
    pup     12      PUP             # PARC universal packet protocol
    udp     17      UDP             # user datagram protocol
    root@debian10:#

## ping


One of the most basic tools for testing a **TCP/IP** connection is
**ping**. You can literally **ping** a local or remote server. This
screenshot first **pings** a local server on the same subnet, and then
does a **ping** to 8.8.8.8 which is a Google server on the Internet.

    paul@debian10:$ ping -c1 10.0.2.2
    PING 10.0.2.2 (10.0.2.2) 56(84) bytes of data.
    64 bytes from 10.0.2.2: icmp_seq=1 ttl=64 time=0.538 ms

    --- 10.0.2.2 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.538/0.538/0.538/0.000 ms
    paul@debian10:$ ping -c1 8.8.8.8
    PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
    64 bytes from 8.8.8.8: icmp_seq=1 ttl=54 time=25.3 ms

    --- 8.8.8.8 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 25.268/25.268/25.268/0.000 ms
    paul@debian10:~$

The **ping** to the local server happens in less than a millisecond,
where the **ping** tot the Google server takes 25 milliseconds. The
**-c1** option performs just one ping, otherwise use **Ctrl-c** to
interrupt the command.

## traceroute


The **traceroute** tool can be used to trace how many routers there are
between your server and another server. Each router is called a **hop**.
The 8.8.8.8 server is eight **hops** away from our **debian10** server
in this screenshot.

    root@debian10# traceroute 8.8.8.8
    traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
     1  172.31.1.1 (172.31.1.1)  0.115 ms  0.062 ms  0.057 ms
     2  10298.your-cloud.host (88.99.159.100)  0.167 ms  0.117 ms  0.094 ms
     3  * * *
     4  spine1.cloud1.nbg1.hetzner.com (85.10.237.193)  0.751 ms  1.116 ms spine2.cloud1.nbg1.hetzner.com (85.10.237.197)  0.837 ms
     5  213-239-208-221.clients.your-server.de (213.239.208.221)  0.356 ms  0.369 ms core11.nbg1.hetzner.com (85.10.250.209)  0.339 ms
     6  core4.fra.hetzner.com (213.239.245.33)  3.592 ms core0.fra.hetzner.com (213.239.252.21)  3.517 ms core4.fra.hetzner.com (213.239.245.245)  3.438 ms
     7  72.14.218.94 (72.14.218.94)  3.726 ms  3.698 ms  3.669 ms
     8  * 108.170.251.129 (108.170.251.129)  3.754 ms 108.170.251.193 (108.170.251.193)  3.358 ms
     9  64.233.175.171 (64.233.175.171)  3.674 ms dns.google (8.8.8.8)  3.529 ms 108.170.235.249 (108.170.235.249)  3.448 ms
    root@debian10#

## ss


The **ss** tool is the modern version of the legacy **netstat** tool. It
has much the same functionality and most of the same options. In this
screenshot we use both tools to look at open TCP ports on our server.
The **t** option is for TCP, replace with **u** for UDP. Port 22 is used
for SSH connections.

    root@debian10:# ss -napt | cut -b-84
    State     Recv-Q    Send-Q        Local Address:Port       Peer Address:Port
    LISTEN    0         128                 0.0.0.0:22              0.0.0.0:*        use
    LISTEN    0         20                127.0.0.1:25              0.0.0.0:*        use
    ESTAB     0         0            192.168.56.101:22         192.168.56.1:56934    use
    LISTEN    0         128                    [::]:22                 [::]:*        use
    LISTEN    0         20                    [::1]:25                 [::]:*        use
    root@debian10:# netstat -napt | cut -b-84
    Active Internet connections (servers and established)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      500/
    tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      738/
    tcp        0      0 192.168.56.101:22       192.168.56.1:56934      ESTABLISHED 1716
    tcp6       0      0 :::22                   :::*                    LISTEN      500/
    tcp6       0      0 ::1:25                  :::*                    LISTEN      738/
    root@debian10:~#

## dhclient


On servers with a fixed IP-address it can happen that the DHCP client
named **dhclient** is running to obtain this fixed IP-address. Do not
kill this client, as your server will lose its IP-address after a while.

    root@debian10:# ps fax | grep dhclient
     1896 pts/0    S+     0:00                      \_ grep dhclient
      945?        Ss     0:00 /sbin/dhclient -4 -v -i -pf /run/dhclient.enp0s3.pid -lf /var/lib/dhcp/dhclient.enp0s3.leases -I -df /var/lib/dhcp/dhclient6.enp0s3.leases enp0s3
    root@debian10:#

## Cheat sheet

<table>
<caption>Managing TCP/IP</caption>
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
<td style="text-align: left;"><p>/sys/class/net</p></td>
<td style="text-align: left;"><p>Contains names of network adapters on
this Debian computer.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ip a</p></td>
<td style="text-align: left;"><p>Display TCP/IP configuration for
network adapters.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ifconfig</p></td>
<td style="text-align: left;"><p>Legacy tool to display TCP/IP
configuration.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ip n</p></td>
<td style="text-align: left;"><p>Display ARP cache.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>arp</p></td>
<td style="text-align: left;"><p>Legacy tool to display ARP
cache.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ip r</p></td>
<td style="text-align: left;"><p>Display routing information.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>route</p></td>
<td style="text-align: left;"><p>Legacy tool to display routing
information.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/etc/network/interfaces</p></td>
<td style="text-align: left;"><p>Contains the TCP/IP configuration of
network adapters.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ifup foo</p></td>
<td style="text-align: left;"><p>Bring the interface
<strong>foo</strong> up (with its configuration).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ifdown foo</p></td>
<td style="text-align: left;"><p>Bring the interface
<strong>foo</strong> down.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/resolv.conf</p></td>
<td style="text-align: left;"><p>Contains DNS server
configuration.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/etc/services</p></td>
<td style="text-align: left;"><p>Lists port to application
configuration.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/protocols</p></td>
<td style="text-align: left;"><p>Lists layer 4 protocol
configuration.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ping</p></td>
<td style="text-align: left;"><p>A tool to test an IP
connection.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>traceroute</p></td>
<td style="text-align: left;"><p>A tool to display routes between
computers.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ss</p></td>
<td style="text-align: left;"><p>A tool to display open ports and their
applications.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>netstat</p></td>
<td style="text-align: left;"><p>A legacy tool to display open ports and
their applications.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>dhclient</p></td>
<td style="text-align: left;"><p>A daemon that maintains an IP
configuration received from a DHCP server.</p></td>
</tr>
</tbody>
</table>

Managing TCP/IP

## Practice

1.  List the names of the network adapters on your server.

2.  List the IP and MAC address of each of your network adapters.

3.  List the cache of MAC-IP addresses of your server.

4.  List the routing table of your server.

5.  Display the configuration of the network adapters.

6.  Which DNS server is being used on your server?

7.  Display the list of TCP and UDP protocols.

8.  Test your connection to 8.8.8.8.

9.  Display the hops between you and 8.8.8.8.

10. List the open TCP ports on your server.

## Solution

1.  List the names of the network adapters on your server.

        ls /sys/class/net/

2.  List the IP and MAC address of each of your network adapters.

        ip a
        /sbin/ifconfig

3.  List the cache of MAC-IP addresses of your server.

        ip n
        /sbin/arp

4.  List the routing table of your server.

        ip r
        /sbin/route

5.  Display the configuration of the network adapters.

        more /etc/network/interfaces

6.  Which DNS server is being used on your server?

        cat /etc/resolv.conf

7.  Display the list of TCP and UDP protocols.

        more /etc/services

8.  Test your connection to 8.8.8.8.

        ping 8.8.8.8

9.  Display the hops between you and 8.8.8.8.

        traceroute 8.8.8.8

10. List the open TCP ports on your server.

        ss -napt
