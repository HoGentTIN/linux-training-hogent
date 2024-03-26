# Introduction to networks

## TCP/IP

In the 1980s and 1990s there were a lot of protocols in use to construct
networks. IBM had SNA, Apple had Appletalk, Novell had Netware and so
on. Nowadays all these protocols are replaced by **TCP/IP**. The
**Transmission Control Protocol/Internet Protocol** is used everywhere,
from the smallest home networks to the worldwide Internet.

<figure>
<img src="images/tcpip_layers0.svg" alt="images/tcpip_layers0.svg" />
</figure>

Explaining networking is today in 2019 the same as explaining
**TCP/IP**.

### RFC

TCP/IP is a protocol stack with more than a thousand protocols. You may
know some of them like HTTP, or DHCP, or DNS just to name a few. These
protocols are all defined in **RFCs**. For example RFC 2616 is about
HTTP and RFC 2131 describes DHCP.

The official website that hosts all RFCs is
<https://www.rfc-editor.org/> . You can find any RFC here using this
example URL:

    https://www.rfc-editor.org/rfc/rfc2131.txt .

### the Internet

The history of the Internet begins in 1969, which is also the birth year
of Unix and is also the year in which the RFCs were started. While all
this history is very interesting, it is out of the scope of this book.

Today the Internet is one giant worldwide TCP/IP network.

### an intranet

Many organisations have an **intranet** that is only accessible to
certain groups of people. This too is a TCP/IP network, it is just
restricted in use. An intranet relies on the same stack of protocols
that the Internet does.

### 4G, 5G, Wi-fi, hotspot

So what about 4G and Wi-fi and a hotspot? Well 4G and 5G is TCP/IP via
you smartphone, Wi-fi is TCP/IP without network cables and a hotspot is
just a restricted Wi-fi network. It is all TCP/IP today.

## TCP/IP Layers

The TCP/IP protocol works in layers. There are four distinct layers in
this protocol: at the top is the **Application** layer, just underneath
is the **Transport** layer, below that is the **Internet** layer and at
the bottom is the **Link** layer.

<figure>
<img src="images/tcpip_layers.svg" alt="images/tcpip_layers.svg" />
</figure>

### IP-address

An IP-address is part of the **Internet** layer. Every computer on the
network, be it the Internet or an intranet, has an IP-address.

<figure>
<img src="images/tcpip_layers1.svg" alt="images/tcpip_layers1.svg" />
</figure>

Today there are two forms of IP-addresses in use. There are the old
**IPv4** (version 4) addresses and the new **IPv6** addresses.

**IPv4** addresses are 32-bit in length and are usually written in four
decimal numbers separated by a dot, for example 10.0.2.1 or
192.168.56.101 or 88.151.243.8 . There are a little more than four
billion IPv4 addresses.

**IPv6** addresses are 128-bit in length and are usually written in
hexadecimal form, for example: fe80::1a65:90ff:fedb:cb89 or
2a00:1450:400e:80b::200e . There are about 340 billion billion billion
billion IPv6 addresses.

In **IPv4** the ranges 10.0.0.0/8 and 192.168.0.0/16 are reserved for
private use, these adresses cannot exist on the Internet. The
169.254.0.0/16 is reserved for **zeroconf** (see the DHCP chapter) and
also cannot exist on the Internet.

### MAC-address

The hardware that is being used for network connectivity has a
**MAC-address**. Each **MAC-address** is unique in its local
environment. The **MAC-address** is part of the **Link** layer.

<figure>
<img src="images/tcpip_layers2.svg" alt="images/tcpip_layers2.svg" />
</figure>

A **MAC-address** is 48-bits (or six bytes) in length and is usually
written in hexadecimal form, for example : 08:00:27:3f:27:a6 or
18:65:90:dc:cb:49.

### TCP or UDP

The two **Transport** protocols that we will discuss the most are
**TCP** and **UDP**. In short **TCP** is a reliable protocol with a lot
of overhead, and **UDP** is a much simpler, faster, but unreliable
protocol.

<figure>
<img src="images/tcpip_layers3.svg" alt="images/tcpip_layers3.svg" />
</figure>

#### TCP

The **TCP** protocol will set up a connection between two computers with
a triple handshake. First part is a **SYN** packet sent from **computer
A** to **computer B**, this packet basically asks "Will you connect with
me?". The reply to this packet is called a **SYN,ACK** and is the second
part of the triple handshake and goes from **computer B** to **computer
A** basically saying "Yes, I would connect with you. Will you connect
with me?" The third part is a simple **ACK** from **computer A** to
confirm a TCP connection is set.

<figure>
<img src="images/tcp.svg" alt="images/tcp.svg" />
</figure>

TCP will then number all packets from computer A to computer B and will
confirm whether all packets were received, re-sending them if necessary.
When the TCP transfer is done a **FIN** packet will be sent, which will
receive a final **ACK**.

Protocols like SMTP (for e-mail) and HTTP (for websites) rely on a TCP
connection.

#### UDP

The **UDP** protocol will not set up a connection, it will just send the
data and hope that it arrives. This is much simpler and faster than TCP
on reliable network connections. For example DNS queries on your local
subnet are done with UDP.

### port

Every networked application will use a **port** to send and/or receive
data. Many **ports** are **well known** like 22 for SSH, 53 for DNS and
80 for HTTP.

<figure>
<img src="images/tcpip_layers4.svg" alt="images/tcpip_layers4.svg" />
</figure>

A TCP connection is initiated from a client application and will use a
**source** port and a **destination** port. The destination port is to
connect to the server application, and the source port is there because
traffic has to be able to return to the client application.

## TCP/IP devices

### hub

A **hub** is a device that receives and transmit electrical signals. It
may be aware of zeroes and ones and retransmit those. A **hub** is
invisible for other devices on the network (it could be pictured below
the **Link** layer) and is rare in 2019.

### switch

A **switch** is an intelligent device that can make decisions based on
the **MAC-address** in the network **frames**. A **switch** is a device
in the **Link** layer.

<figure>
<img src="images/tcpip_layers5.svg" alt="images/tcpip_layers5.svg" />
</figure>

### router

A **router** is an intelligent device that can make decisions based on
the **IP-address**, so it belongs in the **Internet** layer. Some
switches can also do this, so the line between routers and switches is
blurring.

<figure>
<img src="images/tcpip_layers6.svg" alt="images/tcpip_layers6.svg" />
</figure>

A router is often depicted like this in a network diagram.

<figure>
<img src="images/router.svg" alt="images/router.svg" />
</figure>

## unicast - broadcast

A **broadcast** message is a message to everyone (in a certain group). A
**unicast** message is part of a one-to-one communication, a **unicast**
message is sent to one member of a group.

More information on unicast, broadcast and others, and nice pictures,
can be found here:

    https://en.wikipedia.org/wiki/Routing#Delivery_schemes

## LAN - WAN

A **LAN** is a **Local Area Network**, in a **LAN** the computers are
close to each other. There can be few computers in a **LAN** and there
can be many, for example a large building with hundreds of computers can
be a **LAN**. A **LAN** often uses **Ethernet**.

A **WAN** or **Wide Area Network** is a network where the computers are
far apart. For example a computer in Beijing and a computer in Paris can
be connected via a **WAN**. There are several **WAN** protocols like
ATM, Frame Relay, X.25 and so on.

A lot more information can be found here:

    https://en.wikipedia.org/wiki/Computer_network

## Cheat sheet

<table>
<caption>Introduction to networks</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>term</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>TCP/IP</p></td>
<td style="text-align: left;"><p>A common name for the Internet protocol
stack.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>RFC</p></td>
<td style="text-align: left;"><p>Request For Comment, usually a TCP/IP
standard.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>the Internet</p></td>
<td style="text-align: left;"><p>A worldwide TCP/IP network.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>an intranet</p></td>
<td style="text-align: left;"><p>A local (organisation-wide) TCP/IP
network.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>IP address</p></td>
<td style="text-align: left;"><p>A unique address for a computer on a
TCP/IP network.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>MAC address</p></td>
<td style="text-align: left;"><p>A unique address for a computer on a
local network.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>TCP</p></td>
<td style="text-align: left;"><p>A reliable connection
protocol.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>UDP</p></td>
<td style="text-align: left;"><p>An unreliable connectionless fast
protocol.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>port</p></td>
<td style="text-align: left;"><p>A unique identifier for an
application.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>hub</p></td>
<td style="text-align: left;"><p>A layer 1 device.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>switch</p></td>
<td style="text-align: left;"><p>A layer 2 device (though the
distinction with a router is blurring).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>router</p></td>
<td style="text-align: left;"><p>A layer 3 device (it makes decisions
based on IP address).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>unicast</p></td>
<td style="text-align: left;"><p>A one-to-one message.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>broadcast</p></td>
<td style="text-align: left;"><p>A message to everyone (of a certain
group).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>LAN</p></td>
<td style="text-align: left;"><p>A Local Area Network (computers close
to each other, often Ethernet).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>WAN</p></td>
<td style="text-align: left;"><p>A Wide Area Network (computers far
apart).</p></td>
</tr>
</tbody>
</table>

Introduction to networks

## Practice

1.  Name the website were you can find all the RFC’s.

2.  Name the largest TCP/IP network.

3.  Name the four TCP/IP layers from top to bottom.

4.  In which layer do we find IP-addresses?

5.  In which layer do we find a switch?

6.  Which device makes decision based on IP-address?

7.  How are applications defined in TCP/IP?

8.  A message to all members of a group is a …?

9.  What are two key differences between a LAN and a WAN?

## Solution

1.  Name the website were you can find all the RFC’s.

        www.rfc-editor.org

2.  Name the largest TCP/IP network.

        The Internet

3.  Name the four TCP/IP layers from top to bottom.

        Application
        Transport
        Internet
        Link

4.  In which layer do we find IP-addresses?

        Internet

5.  In which layer do we find a switch?

        Link

6.  Which device makes decision based on IP-address?

        a router

7.  How are applications defined in TCP/IP?

        by a port number

8.  A message to all members of a group is a …?

        broadcast

9.  What are two key differences between a LAN and a WAN?

        distance between computers
        protocol being used
