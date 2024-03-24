## to gui or not to gui

Recent Linux desktop distributions often provide a GUI to configure the network. Some people complain that these applications mess networking configurations up when used simultaneously with command line configurations. Since the goal of this course is `server` administration, we will assume our Linux servers are always administered through the command line and/or configuration files.

## components of the network configuration

In order to allow a Linux system to communicate with other hosts on a TCP/IP network, it needs the following three settings:

1. An IP address and subnet mask
2. A default gateway
3. One or more DNS servers that can resolve domain names to IP addresses

Usually, those are provided by a DHCP server, but they can also be configured manually.

In the following sections, we will discuss how to check these settings and how to configure them.

### checking the network configuration

You can check the network configuration of a Linux system with the `ip` command. The `ip` command is part of the `iproute2` package, which is installed by default on most Linux distributions. The `ip` command is a powerful tool to configure and manage network interfaces, routing, and tunnels. Be sure to read the man-page of `ip(8)` and `ip-address(8)` for detailed information.

If you find a guide or HOWTO online that discusses the `ifconfig` command, it is outdated. The `ifconfig` command is deprecated and should not be used anymore. The `ip` command is the modern replacement for `ifconfig`.

This is the network configuration of a VirtualBox VM with an NAT interface and a host-only interface.:

```console
student@linux:~$ ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:e6:f5:c9 brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 79579sec preferred_lft 79579sec
    inet6 fe80::a00:27ff:fee6:f5c9/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:0a:46:36 brd ff:ff:ff:ff:ff:ff
    altname enp0s8
    inet 192.168.56.21/24 brd 192.168.56.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe0a:4636/64 scope link
       valid_lft forever preferred_lft forever
```

The `ip address` command (or `ip a` in short) shows the network configuration of the system. The output shows three network interfaces: `lo`, `eth0`, and `eth1`.

- `lo` is the loopback interface, which is used for communication within the system and always has IPv4 address *127.0.0.1/8* and IPv6 address *::1*.
- `eth0` is an Ethernet interface with the IPv4 address *10.0.2.15/24* and IPv6 address *fe80::a00:27ff:fee6:f5c9/64*.
- `eth1` is also an Ethernet interface with the IPv4 address *192.168.56.21/24* and IPv6 address *fe80::a00:27ff:fe0a:4636/64*.

The `UP` flag indicates that the interface is up and running. The `LOWER_UP` flag indicates that the link layer is up and running. If an interface is down, you would see the following:

```console
student@linux:~$ ip a show dev eth1
3: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether 08:00:27:0a:46:36 brd ff:ff:ff:ff:ff:ff
    altname enp0s8
    inet 192.168.56.21/24 brd 192.168.56.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe0a:4636/64 scope link
       valid_lft forever preferred_lft forever
```

The `NO-CARRIER` flag indicates that there is no carrier signal on the interface. This means that there is no network cable connected to the interface, or the cable is broken.

The `ip` command has many subcommands and options. We will discuss some of them in the next sections, but be sure to check the manpage of the `ip(8)` command for more information. Useful options include:

- `-br` or `-brief` show output in a brief format
- `-4` or `-family inet` show only IPv4 addresses
- `-6` or `-family inet6` show only IPv6 addresses
- `-c` or `-color` colorize the output (highlights the interface names and addresses)
- Adding `show dev <interface>` to the command only shows the configuration of the specified interface

### network interface names

Traditionally, network interfaces on Linux systems were named `eth0`, `eth1`, `eth2`, etc. Unfortunately, when you install and configure a new baremetal server system with multiple network interfaces, it is not predictable which interface will get which name. If network interfaces are added or removed, the names of the remaining interfaces might change. This can be confusing.

On modern Linux systems, network interface names are provided by the `systemd` [predictable network interface names](https://systemd.io/PREDICTABLE_INTERFACE_NAMES/) feature. This feature assigns names to network interfaces based on their physical location on the system. The names are based on the firmware or BIOS topology information. This means that the names of the network interfaces are predictable and stable.

It is still possible to disable this feature and revert to the traditional naming scheme, but this is beyond the scope of this course and we do not recommend this.

More information about the network device naming scheme can be found in the manpage `man systemd.net-naming-scheme`.

- a name starting with `en` denotes an Ethernet device
- a name starting with `wl` denotes a wireless LAN device
- the rest of the name is based on the physical location of the device, e.g.
    - `enp0s3` stands for "Ethernet device, PCI bus 0, slot 3"
    - `wlp3s0` stands for "Wireless LAN device, PCI bus 3, slot 0"

Remark that in the example above, the `altname` shows the predictable name of the network interfaces. The actual name of network interface `eth0` is `enp0s3` and `eth1` is in fact `enp0s8`.

### routing table and default gateway

The routing table of a Linux system can be shown with the `ip route` or `ip r` command. The routing table shows the available routes and the default gateway.

```console
student@linux:~$ ip route
default via 10.0.2.2 dev eth0
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
192.168.56.0/24 dev eth1 proto kernel scope link src 192.168.56.21
```

This is a typical routing table for a server system. The first line shows the default route, i.e. the IP address of the router that connects the LAN to the Internet. In the example above, the default gateway is *10.0.2.2* and the interface to reach the default gateway is *eth0*.

The other two lines correspond with the two network interfaces of the system. Packets that are sent to destinations within the subnet of the network interfaces can be delivered directly.

### DNS configuration

The final part of the network configuration of a Linux system is the DNS configuration, i.e. a list of DNS servers that can be used to resolve domain names to IP addresses. The way DNS servers are configured depends on your Linux distribution and/or its version.

Traditionally, DNS servers were kept in the file `/etc/resolv.conf`:

```console
student@linux:~$ cat /etc/resolv.conf
domain home
search home
nameserver 10.0.2.3
```

In this example, the DNS server has IP address 10.0.2.3 (which is typical for a VirtualBox NAT interface). The `domain` and `search` lines are used to append the domain name to hostnames that are not fully qualified.

However, on recent versions of several Linux distribututions, the `/etc/resolv.conf` file is often managed by the `systemd-resolved` service. This service is part of the `systemd` suite and provides network name resolution to local applications. The `systemd-resolved` service is configured through the file `/etc/systemd/resolved.conf` and the `/etc/resolv.conf` file is a symlink to `/run/systemd/resolve/stub-resolv.conf`.

The following example is a typical `/etc/resolv.conf` file on a system with `systemd-resolved`:

```console
student@linux:~$ cat /etc/resolv.conf
# This is /run/systemd/resolve/stub-resolv.conf managed by man:systemd-resolved(8).
# Do not edit.
nameserver 127.0.0.53
options edns0 trust-ad
search home
student@linux:~$ ls -l /etc/resolv.conf 
lrwxrwxrwx 1 root root 39 Jan 21 19:42 /etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
```

The DNS server is set to 127.0.0.53, which seems to be a combination of the loopback address 127.0.0.1 and the port number 53 of the DNS service. Any IP address in the 127.0.0.0/8 range is considered to be a loopback address and will behave just like 127.0.0.1. `systemd-resolved` listens on a server socket with port 53 connected to the loopback interface.

In the example below, we use the Show Sockets (`ss`) command to verify that `systemd-resolved` is listening on UDP port 53 and next, we send a DNS query to the IP address specified in `/etc/resolv.conf` (see below for more info on the `dig` command that is used here):

```console
student@linux:~$ sudo ss -ulnp  | grep 'resolve' 
UNCONN 0      0      127.0.0.53%lo:53         0.0.0.0:*    users:(("systemd-resolve",pid=582,fd=13))
student@linux:~$ dig +short @127.0.0.53 www.linux-training.be
188.40.26.208
```

This means that your Linux system is providing its own DNS service. However, it can't make up the IP addresses of hosts on the Internet by itself, it needs to forward the request to a real DNS server. You can check which DNS servers are used by `systemd-resolved` with the `resolvectl` command:

```console
student@linux:~$ resolvectl dns
$ resolvectl dns
Global:
Link 2 (enp0s3): 195.130.131.1 195.130.130.1
Link 3 (enp0s8):
```

In this example, the first network interface uses the DNS servers 195.130.131.1 and 195.130.130.1 (which are operated by the Belgian ISP Telenet). The second network interface is not connected to the Internet and does not have any DNS servers.

## verifying network connectivity

### ping

In order to check whether a Linux system can communicate with other hosts on the network, you can use the `ping` command. The `ping` command sends ICMP echo request packets to a host and waits for ICMP echo reply packets. If the host is reachable, it will respond to the echo request packets.

On a Linux system, the `ping` command will continue to send echo request packets until you stop it with `Ctrl-C`. You can also limit the number of echo request packets with the `-c` option.

```console
student@linux:~$ ping -c 3 10.0.2.3
PING 10.0.2.3 (10.0.2.3) 56(84) bytes of data.
64 bytes from 10.0.2.3: icmp_seq=1 ttl=64 time=1.18 ms
64 bytes from 10.0.2.3: icmp_seq=2 ttl=64 time=1.18 ms
64 bytes from 10.0.2.3: icmp_seq=3 ttl=64 time=0.835 ms

--- 10.0.2.3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2006ms
rtt min/avg/max/mdev = 0.835/1.063/1.181/0.161 ms
```

You can specify either an IP address or a hostname:

```console
student@linux:~$ ping -c 3 www.linux-training.be
PING www.linux-training.be (188.40.26.208) 56(84) bytes of data.
64 bytes from www115.your-server.de (188.40.26.208): icmp_seq=1 ttl=50 time=28.8 ms
64 bytes from www115.your-server.de (188.40.26.208): icmp_seq=2 ttl=50 time=29.2 ms
64 bytes from www115.your-server.de (188.40.26.208): icmp_seq=3 ttl=50 time=28.1 ms

--- www.linux-training.be ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev = 28.063/28.699/29.187/0.470 ms
```

If IPv6 is enabled on your system, you can also use the `-6` option or the `ping6` command to send echo request packets to an IPv6 address.

```console
student@linux:~$ ping6 -c 3 www.linux-training.be
PING www.linux-training.be(www115.your-server.de (2a01:4f8:d0a:1044::2)) 56 data bytes
64 bytes from www115.your-server.de (2a01:4f8:d0a:1044::2): icmp_seq=1 ttl=51 time=23.9 ms
64 bytes from www115.your-server.de (2a01:4f8:d0a:1044::2): icmp_seq=2 ttl=51 time=23.9 ms
64 bytes from www115.your-server.de (2a01:4f8:d0a:1044::2): icmp_seq=3 ttl=51 time=21.6 ms

--- www.linux-training.be ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 21.595/23.138/23.911/1.091 ms
```

### traceroute

The `ping` command can tell you whether routing to a host is possible. The `traceroute` command is goes a step further and also shows you which route the packets take to reach their destination. It does this by sending packets with an increasing time-to-live (TTL) value. The IP standard states that a router must decrease the TTL value of a packet by 1. If the TTL value reaches 0, the packet is discarded and the router sends an *ICMP time exceeded* message back to the sender. The `traceroute` command uses this mechanism to find out which routers are on the path to the destination.

Originally, `traceroute` sent an UDP packet to some unlikely port on the target system. If the target system was reached, it would send an ICMP port unreachable message back. Unfortunately, nowadays many routers are configured to silently drop packets to unlikely ports, so this method is not reliable anymore.

In the following example, we use the `traceroute` command to find out which routers are on the path to the web server of the Linux Training website. Unfortunately, we don't get any useful information:

```console
student@linux:~$ traceroute www.linux-training.be
traceroute to www.linux-training.be (188.40.26.208), 30 hops max, 60 byte packets
 1  10.0.2.2 (10.0.2.2)  0.443 ms  1.023 ms  0.866 ms
 2  * * *
 3  * * *
... (many lines omitted) ...
29  * * *
30  * * *
```

Fortunately, the `traceroute` command provides some options to select a different method, e.g. the `-I` option to use *ICMP echo request* packets (as used by `ping`) and the `-T` option to use TCP SYN packets to port 80 (http, as if you want to request a web page from the target host). You will need to try different methods to find out which one works best in your situation. Remark that you need root privileges to use the `-I` and `-T` options.

```console
student@linux:~$ traceroute -I www.linux-training.be
You do not have enough privileges to use this traceroute method.
socket: Operation not permitted
student@linux:~$ sudo traceroute -I www.linux-training.be
traceroute to www.linux-training.be (188.40.26.208), 30 hops max, 60 byte packets
 1  10.0.2.2 (10.0.2.2)  1.251 ms  1.001 ms *
 2  192.168.0.1 (192.168.0.1)  6.929 ms * *
 3  94-224-72-1.access.telenet.be (94.224.72.1)  17.122 ms * *
 4  dD5E0CB8A.access.telenet.be (213.224.203.138)  22.673 ms * *
 5  * * *
 6  4.68.70.53 (4.68.70.53)  49.133 ms  16.993 ms  16.451 ms
 7  * * *
 8  62.67.26.138 (62.67.26.138)  25.287 ms  26.677 ms  26.513 ms
 9  core11.nbg1.hetzner.com (213.239.245.73)  26.374 ms  30.749 ms  30.598 ms
10  ex9k2.dc1.nbg1.hetzner.com (213.239.203.214)  30.455 ms  35.780 ms  35.636 ms
11  www115.your-server.de (188.40.26.208)  36.502 ms  37.340 ms  34.059 ms
```

When `traceroute` receives a packet from a router, it will try to do a reverse DNS lookup to find out its host name. These are useful (as you can sometimes deduce info about the router's location), but may take some time to resolve. In that case, you can use the `-n` option and immediately show only the IP addresses.

### tracepath

The `tracepath` command is a simplified version of `traceroute`. It uses the same strategy as `traceroute` to find routers along the path to the destination. It does not require root privileges, but it also does not provide the alternative methods that `traceroute` does. That means that `tracepath` is less likely to work than `traceroute`, but it is worth a try if you don't have root privileges.

```console
$ tracepath www.linux-training.be
 1?: [LOCALHOST]                      pmtu 1500
 1:  _gateway                                              3.430ms
 1:  _gateway                                              5.459ms
 2:  no reply
...(many lines omitted)...
29:  no reply
30:  no reply
     Too many hops: pmtu 1500
```

### name resolution

You can test whether name resolution is available for your system with e.g. the `dig` command:

```console
student@linux:~$ dig +short @10.0.2.3 www.linux-training.be
188.40.26.208
```

The argument `@10.0.2.3` tells `dig` to send the request to that specific DNS server. If you omit it, the system will use the DNS server configured in `/etc/resolv.conf`.

Windows users will probably be more familiar with the `nslookup` command, but it is much more limited than `dig`.

```console
vagrant@debian:~$ nslookup www.linux-training.be 10.0.2.3
Server:         10.0.2.3
Address:        10.0.2.3#53

Non-authoritative answer:
Name:   www.linux-training.be
Address: 188.40.26.208
Name:   www.linux-training.be
Address: 2a01:4f8:d0a:1044::2
```

If the command `dig` and `nslookup` are not available, and you can't install them (because of network issues, for example!), you can fall back to the `getent ahosts` command to check whether DNS resolution works:

```console
student@linux:~$ getent ahosts www.linux-training.be
188.40.26.208   STREAM www.linux-training.be
188.40.26.208   DGRAM
188.40.26.208   RAW
2a01:4f8:d0a:1044::2 STREAM
2a01:4f8:d0a:1044::2 DGRAM
2a01:4f8:d0a:1044::2 RAW
```

### arp (ip neighbor)

On a local network, IP addresses must be translated to MAC addresses in order to send packets to other hosts. This translation is done with the layer two broadcast protocol ARP (Address Resolution Protocol).

Your system will keep a cache of the MAC addresses of the hosts it has recently communicated with. You can view this cache with the `ip neighbor` (or `neighbour`, or `n`) command:

```console
[student@linux ~]$ ip neighbour
10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
192.168.56.12 dev eth1 lladdr 08:00:27:0a:46:36 STALE
10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 DELAY
```

The `ip neighbour` command shows the IP address, the network interface, the MAC address, and the state of the entry. The state can be one of the following:

- `REACHABLE`: the MAC address is known and the system has recently communicated with the host
- `STALE`: the MAC address is known, but the system has not recently communicated with the host
- `DELAY`: the MAC address is not known and the system is trying to find it. If you see this state, it means that the system is trying to send an ARP request to find the MAC address of the host. If the host exists, the state will change to `REACHABLE` after a while.

The `ip n` command also allows you to edit the ARP cache, e.g. to add a static entry or to remove an entry.

To get a specific entry:

```console
[student@linux ~]$ ip n get 10.0.2.3 dev eth0
10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 STALE
```

To delete a specific entry (requires root privileges), use `ip n del`:

```console
[student@el ~]$ ip n del 10.0.2.3 dev eth0
RTNETLINK answers: Operation not permitted
[student@el ~]$ sudo ip n del 10.0.2.3 dev eth0
[student@el ~]$ ip n
192.168.56.12 dev eth1 lladdr 08:00:27:0a:46:36 STALE
10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
```

To delete all entries for a specific interface (requires root privileges), use `ip n flush`:

```console
[student@el ~]$ ip n
10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
192.168.56.12 dev eth1 lladdr 08:00:27:0a:46:36 STALE
10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 STALE
[student@el ~]$ ip n flush dev eth1
Failed to send flush request: Operation not permitted
[student@el ~]$ sudo !!
sudo ip n flush dev eth1
[student@el ~]$ ip n
10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 STALE
```

See the man-page of `ip-neighbour(8)` for more information.

### what is my public IP address?

Quite often, you find yourself behind a NAT router, and you have an IP address within a privat range (e.g. 192.168.0.0/24, 172.16.0.0/16 or 10.0.0.0/8). If you want to know what your public IP address is, you can use the `curl` command to get this information from a website that provides this service. The following example uses the `ifconfig.me` website (you can also use `icanhazip.com`):

```console
student@linux:~$ curl ifconfig.me
94.224.76.64
student@linux:~$ dig +short -x 94.224.76.64
94-224-76-64.access.telenet.be.
```

You can try the same with the `ipinfo.io` website, which gives some more information in JSON format:

```console
student@linux:~$ curl ipinfo.io
{
  "ip": "94.224.76.64",
  "hostname": "94-224-76-64.access.telenet.be",
  "city": "Dilbeek",
  "region": "Flanders",
  "country": "BE",
  "loc": "50.8480,4.2597",
  "org": "AS6848 Telenet BV",
  "postal": "1700",
  "timezone": "Europe/Brussels",
  "readme": "https://ipinfo.io/missingauth"
}
```

## configuring network settings

The configuration files that keep the network settings differ between Linux distributions. In this section, we will discuss the configuration of Debian and Enterprise Linux (Red Hat-like) systems.

### temporary changes with the ip command

On both Debian and Enterprise Linux, and many other Linux distribution, you can use the `ip` command to configure network interfaces. However, the changes you make with the `ip` command are not persistent. If you reboot the system, the changes will be lost. To make the changes persistent, you need to edit the configuration files, as we will discuss in the next sections.

To change the IP address of an interface, you can use the `ip address add` or `replace` command. For example, to change the IP address of `eth1` to 192.168.56.99:

```console
[vagrant@el ~]$ ip a replace 192.168.56.99 dev eth1
[vagrant@el ~]$ ip -4 -br a show dev eth1
eth1       UP             192.168.56.9/24 192.168.56.99/32
```

There's also a `del` option to remove an IP address from an interface:

```console
[vagrant@el ~]$ ip a del 192.168.56.99 dev eth1
[vagrant@el ~]$ ip -4 -br a show dev eth1
eth1       UP             192.168.56.9/24
```

### /etc/network/interfaces (Debian)

On Debian-based systems (including Ubuntu, Linux Mint, Raspberry Pi OS, etc.), the network settings are kept in the `/etc/network/interfaces` file. This file is used by the `ifup` and `ifdown` commands to configure and deconfigure network interfaces. The `ifup` and `ifdown` commands are part of the `ifupdown` package, which is installed by default on Debian-based systems. For more information about this configuration file, see its manpage with `man 5 interfaces`.

An example of a network configuration file for a system with two network interfaces, one with a dynamic IP address and one with a static IP address, is shown below:

```console
student@debian:~$ cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet dhcp
pre-up sleep 2

auto eth1
iface eth1 inet static
      address 192.168.56.21
      netmask 255.255.255.0
```

In this example, we find configuration for three network interfaces: `lo`, `eth0` and `eth1`.

- The `lo` interface is the loopback interface, which is always configured with the `loopback` keyword.
    - The `auto` keyword means that the interface will be brought up automatically at boot time.
- The `eth0` interface is configured to use DHCP to get an IP address.
    - The `allow-hotplug` keyword means that the interface will be brought up automatically when various condition changes are detected.
    - The `pre-up` keyword means that the command that follows will be executed before the interface is brought up. In this case, the `sleep 2` command is used to wait for 2 seconds before the interface is brought up. This is useful when the interface is connected to a switch that needs some time to come up.
- The `eth1` interface is configured with a static IP address (192.168.56.21) and network mask (255.255.255.0 or /24).

After you have made changes to the `/etc/network/interfaces` file, you can apply the changes with the `ifup` and `ifdown` commands.

For example, let's change the IP address on `eth1` to 192.168.56.12

```console
student@debian:~$ sudo nano /etc/network/interfaces
... (make the necessary changes to the file) ...
student@debian:~$ sudo ifdown eth1
RTNETLINK answers: Cannot assign requested address
student@debian:~$ sudo ifup eth1
student@debian:~$ ip -br a show dev eth1
eth1      UP      192.168.56.12/24 fe80::a00:27ff:fe0a:4636/64
```

### /etc/sysconfig/network-scripts (Enterprise Linux)

On Enterprise Linux (Red Hat, Fedora, AlmaLinux, CentOS, etc.), the network settings are traditionally kept in the `/etc/sysconfig/network-scripts` directory. Each network interface has its own configuration file in this directory. The configuration files are named `ifcfg-<interface>`, where `<interface>` is the name of the network interface.

Remark that Red Hat has been moving away from this system since RHEL 7 and is migrating to the *NetworkManager* service. However, for now, the old configuration files are still present and can be used. See the next section for more information on editing network settings with *NetworkManager*.

An example of a network configuration file for a EL9 system with two network interfaces, one with a dynamic IP address and one with a static IP address, is shown below:

```console
[student@el ~]$ ls /etc/sysconfig/network-scripts/
ifcfg-eth0  ifcfg-eth1  readme-ifcfg-rh.txt
[student@el ~]$ cat /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
DEVICE=eth0
ONBOOT=yes
[student@el ~]$ cat /etc/sysconfig/network-scripts/ifcfg-eth1
NM_CONTROLLED=yes
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.56.11
NETMASK=255.255.255.0
DEVICE=eth1
PEERDNS=no
```

The important settings in these files are:

- `NAME` and `DEVICE`: the name of the network interface
- `ONBOOT=yes`: the interface will be brought up automatically at boot time
- `BOOTPROTO`: the method to get an IP address:
    - `dhcp`: the interface will get an IP address from a DHCP server
    - `none`: the interface will use a static IP address
- `IPADDR` and `NETMASK`: the static IP address and network mask

After you have made changes to the configuration files in `/etc/sysconfig/network-scripts`, you can apply the changes with the `nmcli` (NetworkManager Command-Line Interface) command.

For example, let's change the IP address on `eth1` to 192.168.56.9

```console
[student@el ~]$ ip -br a show dev eth1
eth1             UP             192.168.56.11/24 fe80::a00:27ff:fec8:fbc4/64
[student@el ~]$ sudo vi /etc/sysconfig/network-scripts/ifcfg-eth1
... (make the necessary changes to the file) ...
[student@el ~]$ sudo nmcli connection reload
[student@el ~]$ nmcli connection show
NAME         UUID                                  TYPE      DEVICE
eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0
System eth1  9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04  ethernet  eth1
lo           7aec5c7a-0122-4c27-a48b-0755c9cf0769  loopback  lo
[student@el ~]$ sudo nmcli connection up 'System eth1'
[student@el ~]$ ip -br a show dev eth1
eth1      UP       192.168.56.9/24 fe80::a00:27ff:fec8:fbc4/64
```

### NetworkManager (EL>=7, Fedora, Mint, ...)

On recent versions of RHEL (since RHEL 7) and Fedora, and even Debian and derivatives, *NetworkManager* is used to manage network connections. The *NetworkManager* service is a dynamic network control and configuration system that attempts to keep network devices and connections up and active when they are available. It manages Ethernet, WiFi, mobile broadband (WWAN), and PPPoE devices, and provides VPN integration with a variety of different VPN services.

An argument can be made that this is quite useful for laptops, who often move between networks and need to switch between wired and wireless connections. However, for servers, it is often considered overkill and unnecessary. Nevertheless, *NetworkManager* is installed and actiated on many systems, so it is necessary to know how to use it.

In this section, we'll discuss `nmcli`, the command-line interface to *NetworkManager*. There are alternative ways to configure *NetworkManager* (e.g. with the `nmtui` command or the graphical user interface), but we will focus on `nmcli` here. Reason is that `nmcli`-based configuration can be automated in scripts, while actions in an interactive user interface cannot.

With *NetworkManager*, you can provide a connection profile for each network interface. A connection profile is a set of properties that describe how the network interface should be configured. The connection profiles are stored in the `/etc/NetworkManager/system-connections` directory.

To show the connection profiles, use the `nmcli connection show` command. If you want to see specific details of a connection profile, use the `nmcli connection show <name>` command. 

```console
[student@el ~]$ nmcli connection show
NAME         UUID                                  TYPE      DEVICE
eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0
lo           7aec5c7a-0122-4c27-a48b-0755c9cf0769  loopback  lo
System eth1  9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04  ethernet  eth1
[student@el ~]$ nmcli connection show eth0
connection.id:                          eth0
connection.uuid:                        5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03
connection.stable-id:                   --
connection.type:                        802-3-ethernet
connection.interface-name:              eth0
connection.autoconnect:                 yes
... (more details of the connection profile for eth0) ...
[student@el ~]$ nmcli device show eth1
... (more details of the network device eth1) ...
```

There's a lot of output, so you may want to use the `--fields` or `-f` option to limit the output to the fields you are interested in.

```console
[student@el ~]$ nmcli -f IP4 device show eth0
IP4.ADDRESS[1]:        10.0.2.15/24
IP4.GATEWAY:           10.0.2.2
IP4.ROUTE[1]:          dst = 0.0.0.0/0, nh = 10.0.2.2, mt = 102
IP4.ROUTE[2]:          dst = 10.0.2.0/24, nh = 0.0.0.0, mt = 102
IP4.DNS[1]:            10.0.2.3
IP4.DOMAIN[1]:         home
[student@el ~]$ nmcli -f IP6 dev sh eth1
IP6.ADDRESS[1]:        fe80::a00:27ff:fec8:fbc4/64
IP6.GATEWAY:           --
IP6.ROUTE[1]:          dst = fe80::/64, nh = ::, mt = 256
```

In this example, the names of the connection profiles are `eth0`, `lo` and `System eth1`. The name of the last one is not consistent with the other two, but that can be changed!

```console
[student@el ~]$ sudo nmcli con modify 'System eth1' connection.id eth1
[student@el ~]$ nmcli con sh
NAME    UUID                                  TYPE      DEVICE
eth0    5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0
eth1    9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04  ethernet  eth1
lo      7aec5c7a-0122-4c27-a48b-0755c9cf0769  loopback  lo
```

To configure IPv4 settings for a connection profile, use the `nmcli connection modify` command. The following example shows how to configure the `eth1` connection profile with a static IP address:

```console
[student@el ~]$ sudo nmcli connection modify eth1 \
  ipv4.method manual ipv4.addresses 192.168.56.9/24
```

You can also configure the default gateway and DNS servers (if appropriate for that connection):

```console
[student@el ~]$ sudo nmcli connection modify eth1 \
  ipv4.method manual \
  ipv4.addresses 192.168.56.9/24 ipv4.gateway 192.168.56.254 \
  ipv4.dns 192.168.56.254 ipv4.dns-search example.com
```

To use DHCP instead, enter:

```console
[student@el ~]$ sudo nmcli connection modify eth1 ipv4.method auto
```

To configure IPv6 settings and use stateless address autoconfiguration (SLAAC), use the following command:

```console
[student@el ~]$ sudo nmcli connection modify eth1 ipv6.method auto
```

This is the default, so it may not be necessary to set it explicitly.

To set a static IPv6 address, network mask, default gateway, DNS servers and DNS search domain, use the following command (modifying the IPv6 addresses to ones that are appropriate for your network):

```console
[student@el ~]$ sudo nmcli connection modify eth1 \
  ipv6.method manual \
  ipv6.addresses 2001:db8:1::9/64 ipv6.gateway 2001:db8:1::1 \
  ipv6.dns 2001:db8:1::1 ipv6.dns-search example.com
```

Finally, to activate the profile, enter:

```console
[student@el ~]$ sudo nmcli connection up eth1
```

Verify the changes with `ip a`, `ip r` and `resolvectl dns` commands (or the `/etc/resolv.conf` file).

### Netplan (Ubuntu)

Recent versions of Ubuntu use *Netplan* to configure network interfaces. *Netplan* is a utility that converts a declarative description of the desired network configuration in YAML format to the required format for the underlying network management system, either `systemd-networkd` (the default for Ubuntu) or `NetworkManager`.

The configuration files are stored in the `/etc/netplan` directory. This directory may contain one or more YAML files starting with a double digit number, e.g. `01-netcfg.yaml` (or similar).

```console
student@ubuntu:~$ cat /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
```

In this example, we have a single interface that is configured to get an IP address from a DHCP server. If you want to use a static IP address, you can use the following configuration:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 10.0.2.15/24
      routes:
        - to: default
          via: 10.0.2.2
      nameservers:
        search: 
          - home
        addresses:
          - 10.0.2.3
```

In this example we reconstructed the settings a VirtualBox VM would get if it attaches to a NAT adapter.

After you have made changes to the configuration file in `/etc/netplan`, you can apply the changes with the `sudo netplan apply` command.

### changing the hostname

The hostname of a Linux system is a name given to it by the system administrator. In many cases, this is just a name for internal use in the logs and prompts. If you want other hosts on the network to be able to reach your system by its hostname, you will need register it in the DNS server for the domain.

On modern Linux distributions, managing the host name is done by `systemd-hostnamed`, part of the `systemd` suite. The `hostnamectl` command is used to query and change the system hostname and related settings. Read the man-page of `hostnamectl(1)` for detailed information.

Without any arguments, `hostnamectl` will show the current settings, e.g.:

```console
[student@el ~]$ hostnamectl
 Static hostname: el
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 8616fe49eae5443aac94b55664267068
         Boot ID: 47762feaf5614f33a6bd7576374e186e
  Virtualization: oracle
Operating System: AlmaLinux 9.3 (Shamrock Pampas Cat)
     CPE OS Name: cpe:/o:almalinux:almalinux:9::baseos
          Kernel: Linux 5.14.0-362.13.1.el9_3.x86_64
    Architecture: x86-64
 Hardware Vendor: innotek GmbH
  Hardware Model: VirtualBox
Firmware Version: VirtualBox
```

This example is from Ubuntu 22.04 in Windows Subsystem For Linux:

```console
$ hostnamectl
 Static hostname: NB23-G89HHX3
       Icon name: computer-container
         Chassis: container
      Machine ID: 0444ccbadb2245f4a0caac3a81a7d7cf
         Boot ID: fa53f951d31f41a3ab3935429b9b59a2
  Virtualization: wsl
Operating System: Ubuntu 22.04.3 LTS
          Kernel: Linux 5.15.146.1-microsoft-standard-WSL2
    Architecture: x86-64
```

To change the hostname, use the `hostnamectl set-hostname` command:

```console
[student@el ~]$ sudo hostnamectl set-hostname alma9
[student@el ~]$
```

Remark that the prompt hasn't changed yet! You will need to log out and log back in to see the new hostname in the prompt.

`systemd-hostnamed` distinguishes three different hostnames: the high-level "pretty" hostname which might include all kinds of special characters (e.g. "Lennart's Laptop"), the "static" hostname which is the user-configured hostname (e.g. "lennarts-laptop"), and the transient hostname which is a fallback value received from network configuration (e.g. "node12345678"). If a static hostname is set to a valid value, then the transient hostname is not used.

### changing the MAC address

The MAC address of a network interface is a unique identifier assigned to a network interface for communications at the data link layer of a network segment. It is usually assigned by the manufacturer of the network interface. However, it is possible to change the MAC address of a network interface with the `ip` command.

To change the MAC address of a network interface, use the `ip link set` command. You will need to have root privileges to do this.

```console
[student@el ~]$ ip link show dev eth1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:c8:fb:c4 brd ff:ff:ff:ff:ff:ff
    altname enp0s8
[student@el ~]$ sudo ip link set eth1 address 08:00:de:ad:be:ef type ether
[student@el ~]$ ip link show dev eth1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:de:ad:be:ef brd ff:ff:ff:ff:ff:ff permaddr 08:00:27:c8:fb:c4
    altname enp0s8
```

Remark that the original MAC address is still visible with the `permaddr` keyword.

See the man-page of `ip-link(8)` for more information.

