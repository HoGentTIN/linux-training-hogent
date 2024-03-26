# Introduction to routing

## A standard router


In the networking chapter we saw that a **router** is a device that
makes decisions based on **IP-addresses**. Obviously it can do a lot
more than that.

### Debian 10 as a router

In this chapter we will use our Debian 10 named **server3** as a router.
On one side of the router we will construct a network named **leftnet**
with IP-range 10.0.33.0/24, on the other side we will construct
**rightnet** with IP-range 10.0.42.0/24.

<figure>
<img src="images/router0.svg" alt="images/router0.svg" />
</figure>

Notice that the router has an **IP-address** ending in **.1** on both
networks, which is common practice for routers.

If you are simulating this on VirtualBox then you may need to use an
IP-address ending in **.2** instead of **.1** since VirtualBox appears
to use **.1** for its internal router.

On each network we will put one client. On **leftnet** we put a Debian
10 server named **leftpc** with IP-address 10.0.33.33 and on
**rightnet** we put a Debian 10 server named **rightpc** with IP-address
10.0.42.42 .

<figure>
<img src="images/router1.svg" alt="images/router1.svg" />
</figure>

### a default gateway


If we log on to **leftpc** and issue a **ping** command to the
IP-address of **rightpc** then we get a **Network is unreachable**
error. The computer knows that 10.0.42.42 is on another network, but it
has no gateway to that network.

    paul@leftpc:$ ping 10.0.42.42
    connect: Network is unreachable
    paul@leftpc:$

So step 1 is to enter the IP-address of the router as a default gateway.
This happens in **/etc/network/interfaces** by adding a **gateway
10.0.33.1** line.

    root@leftpc:# vi /etc/network/interfaces
    root@leftpc:# tail -5 /etc/network/interfaces
    allow-hotplug enp0s8
    iface enp0s8 inet static
    address 10.0.33.33
    netmask 255.255.255.0
    gateway 10.0.33.1
    root@leftpc:~#

The router has two IP-addresses, make sure you enter the IP-address of
the router on **leftnet**.

### Being a router

If we now try the **ping** to the IP-address of **rightpc** then we get
no output until we press **Ctrl-c**. Then it says all packets were lost.

    paul@leftpc:$ ping 10.0.42.42
    PING 10.0.42.42 (10.0.42.42) 56(84) bytes of data.
    ^C
    --- 10.0.42.42 ping statistics ---
    5 packets transmitted, 0 received, 100% packet loss, time 177ms

    paul@leftpc:$


The **leftpc** is now sending the packets to its gateway at 10.0.33.1,
but this machine is a default Debian 10 Linux, so it is not a router. We
make it a router by setting **/proc/sys/net/ipv4/ip\_forward** to 1.

    root@server3:# cat /proc/sys/net/ipv4/ip_forward
    0
    root@server3:# echo 1 > /proc/sys/net/ipv4/ip_forward
    root@server3:~#

We can now change the icon of our **server 3** to the router icon.

<figure>
<img src="images/router2.svg" alt="images/router2.svg" />
</figure>

After entering the **gateway** on **rightpc** there is a response to the
ping which passes over our router. We now have a basic router that will
forward all traffic between the two networks.

    paul@leftpc:$ ping 10.0.42.42
    PING 10.0.42.42 (10.0.42.42) 56(84) bytes of data.
    64 bytes from 10.0.42.42: icmp_seq=1 ttl=63 time=0.762 ms
    64 bytes from 10.0.42.42: icmp_seq=2 ttl=63 time=1.46 ms
    ^C
    --- 10.0.42.42 ping statistics ---
    2 packets transmitted, 2 received, 0% packet loss, time 2ms
    rtt min/avg/max/mdev = 0.762/1.111/1.460/0.349 ms
    paul@leftpc:$

### Being a permanent router


After a reboot this router function of **server3** is gone. To make it a
permanent router you have to uncomment a line in **/etc/sysctl.conf**.

    root@server3:# cat /proc/sys/net/ipv4/ip_forward
    0
    root@server3:# vi /etc/sysctl.conf
    root@server3:# grep ip_forward /etc/sysctl.conf
    net.ipv4.ip_forward=1
    root@server3:#

### Looking at the Ethernet frames

In this section we take a look at what the router is doing with the
**Ethernet frame** that it receives from **leftpc** after a **ping
10.0.42.42** command.

The router is not touching the **IP-addresses** in the frame, which
means that during the journey from leftpc to rightpc the **source
IP-address** is always 10.0.33.33 and the **destination IP-address** is
always 10.0.42.42.

But the router is changing the **MAC-addresses** in the frame, because
they are unique to each Ethernet network. In the picture below we added
part of the Ethernet and IP header, note the changing MAC addresses
between leftnet and rightnet. (Remember we alwyas put the destination
before the source in our simplified frame.)

<figure>
<img src="images/router3.svg" alt="images/router3.svg" />
</figure>

## NAT

NAT is short for **Network Address Translation** and the **network
address** in this case is an IP-address. So a NAT router **will** change
IP-addresses in a packet.

NAT is often used to translate private IP-addresses from a private
network into one public IP-address, as shown in this image. See the
change in source IP-address, in addition to the change in MAC-addresses.

<figure>
<img src="images/router_nat.svg" alt="images/router_nat.svg" />
</figure>

Note that the destination port in this scenario stays the same, while
the source port can (probably will) differ. This enables the router to
create a NAT table so that a reply from the Internet can be sent to the
correct computer.

We will set up a NAT router with Debian 10 and **nftables** in the next
chapter.

### SNAT

SNAT is short for **Source Network Address Translation**. This means
that the source IP-address of a packet should be modified.

In the picture below we show a SNAT router that modifies to source
address of the 10.0.33.33 computer to its own 10.42.0.1 address. In this
drawing we go from a private address IP-range to another private address
IP-range, but this is also common from a private IP-range to a public
IP-range. (Very similar to the NAT situation from the previous section.)

<figure>
<img src="images/router_snat.svg" alt="images/router_snat.svg" />
</figure>

### DNAT

DNAT is short for **Destination Network Address Translation** which
means that the destination IP-address of a packet should be modified.
This is common for servers with public IP-addresses when not the actual
server but rather a router or firewall holds the public IP-address.

<figure>
<img src="images/router_dnat.svg" alt="images/router_dnat.svg" />
</figure>

In the image above the **rightpc** is the actual web server with a
private IP-address, and the router holds the public IP-address by which
this web server is known on the Internet.

## port forwarding

Port forwarding can be similar to DNAT, but depends on the destination
port. A router can decide to forward all destination port 80 traffic to
a local HTTP server and all destination port 25 traffic to another local
SMTP server. But it can also decide to forward destination port 9000 to
destination port 22 on a local server. All this while also changing the
destination IP-address.

<figure>
<img src="images/router_portfw.svg" alt="images/router_portfw.svg" />
</figure>

## PAT and Static NAT?

Many vendors use another definition of SNAT or will use PAT instead of
port forwarding. In the next chapter we will use the Linux kernel
firewall with the **nftables** tool and follow the terminology of the
Linux kernel and **netfilter** documentation.

So always read and understand the documentation that comes with your
device.

## Cheat sheet

<table>
<caption>Routing</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>file or term</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/proc/sys/net/ipv4/ip_forward</p></td>
<td style="text-align: left;"><p>Contains 1 if computer is a
router.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/etc/sysctl.conf</p></td>
<td style="text-align: left;"><p>Contains a permanent setting for being
a router.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/network/interfaces</p></td>
<td style="text-align: left;"><p>Contains <strong>default
gateway</strong> (=router) address.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>NAT</p></td>
<td style="text-align: left;"><p>Network (=IP) Address
Translation.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>SNAT</p></td>
<td style="text-align: left;"><p>Source NAT.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>DNAT</p></td>
<td style="text-align: left;"><p>Destination NAT.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>PAT</p></td>
<td style="text-align: left;"><p>Port Address Translation.</p></td>
</tr>
</tbody>
</table>

Routing

## Practice

## Solution

.

\+

.

\+

.

\+

.

\+

.

\+

.

\+

.

\+

.

\+
