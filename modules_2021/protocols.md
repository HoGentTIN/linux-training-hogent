# Introduction to protocols

You can skip this chapter if you don’t wish to learn more about
networking and TCP/IP.

## ARP


We start with the **ARP** or **A**ddress **R**esolution **P**rotocol
because this is often the first protocol on the network. The goal of
this protocol is to find the **MAC-address** of a computer with a
certain **IP-address**. For example when you type **ping 10.0.2.102**
then your computer has a destination **IP-address** but no destination
**MAC-address**. This destination **MAC-address** is required because it
is the first six bytes of the Ethernet frame.

In this scenario the **ARP** protocol will construct an **Ethernet
frame** with **ff:ff:ff:ff:ff:ff** as the destination MAC-address. This
frame will be received by all computers on the local subnet. This frame
has a simple question: **"Who has 10.0.2.102?"** and all computers will
disregard this question, except the computer with this IP-address. This
10.0.2.102 computer will reply with an Ethernet frame containing its
MAC-address.

<figure>
<img src="images/arp0.svg" alt="images/arp0.svg" />
</figure>

You can try to use a sniffer like **tcpdump** or **Wireshark** to see
this traffic, but this can be tricky to do because of the **ARP cache**.
If there is a communication between two computers, then they will each
have the IP-to-MAC-address translation of each other in the **ARP
cache**.

Using this little script we managed to capture an **ARP request** and an
**ARP reply**. We made sure there was no prior communication with the
10.0.2.102 server.

    root@debian10:# cat arp.sh
    !/bin/bash

    tcpdump -i -n enp0s8 -w dump2.pcap &
    sleep 5
    ping -c2 10.0.2.102
    fg
    root@debian10:

To run it, we **source** the script, otherwise the **fg** command does
not work. As soon as the **tcpdump -n -i enp0s8 -w dump2.pcap** appears
we pressed Ctrl-c.

    root@debian10:# source arp.sh
    tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
    PING 10.0.2.102 (10.0.2.102) 56(84) bytes of data.
    64 bytes from 10.0.2.102: icmp_seq=1 ttl=64 time=1.11 ms
    64 bytes from 10.0.2.102: icmp_seq=2 ttl=64 time=0.527 ms

    --- 10.0.2.102 ping statistics ---
    2 packets transmitted, 2 received, 0% packet loss, time 11ms
    rtt min/avg/max/mdev = 0.527/0.818/1.110/0.292 ms
    tcpdump -n -i enp0s8 -w dump2.pcap
    ^C6 packets captured
    6 packets received by filter
    0 packets dropped by kernel
    root@debian10:#

We now have a nice capture of the ARP protocol in action, right before
the **ping** or **ICMP** packets.


    root@debian10:# tcpdump -nt -r dump2.pcap
    reading from file dump2.pcap, link-type EN10MB (Ethernet)
    ARP, Request who-has 10.0.2.102 tell 10.0.2.101, length 28
    ARP, Reply 10.0.2.102 is-at 08:00:27:2f:13:ed, length 46
    IP 10.0.2.101 > 10.0.2.102: ICMP echo request, id 1097, seq 1, length 64
    IP 10.0.2.102 > 10.0.2.101: ICMP echo reply, id 1097, seq 1, length 64
    IP 10.0.2.101 > 10.0.2.102: ICMP echo request, id 1097, seq 2, length 64
    IP 10.0.2.102 > 10.0.2.101: ICMP echo reply, id 1097, seq 2, length 64
    root@debian10:#

The tcpdump **-e** option will show the MAC-addresses of this ARP
request and reply. Notice the broadcast MAC-address ff:ff:ff:ff:ff:ff.

    root@debian10:# tcpdump -entr dump2.pcap arp
    reading from file dump2.pcap, link-type EN10MB (Ethernet)
    08:00:27:ff:0c:3c > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 10.0.2.102 tell 10.0.2.101, length 28
    08:00:27:2f:13:ed > 08:00:27:ff:0c:3c, ethertype ARP (0x0806), length 60: Reply 10.0.2.102 is-at 08:00:27:2f:13:ed, length 46
    root@debian10:#

This dump can be downloaded with **wget
<http://linux-training.be/dump2.pcap>** .

The above story about **ARP** is true if the destination **IP-address**
is on the same network (the same subnet) as the source computer. If the
destination computer is on another network then the Ethernet frame will
be sent to the **default gateway** (= a router).

And also if you ping to yourself, then there is no **ARP** request sent
out.

## UDP DNS

Next we will take a look at DNS or **D**omain **N**ame **S**ystem. DNS
is an application layer protocol that works on top of the UDP protocol.
The goal of DNS is to translate a name to an IP-address. Since people
tend to remember names rather than IP-addresses, this is a very common
action.

Setting up a DNS server is a couple of chapters later in this book. For
now we are happy if we can capture a **DNS query** and a **DNS
response** using tcpdump. We will use this little script, this time we
**ping** to a name.

    root@debian10:# cat dns.sh
    !/bin/bash

    tcpdump -n -i enp0s8 -w dump3.pcap &
    sleep 5
    ping -c2 www.linux-training.be
    fg
    root@debian10:

Again we source the script and we receive a whopping 14 packets this
time. Maybe we caught something extra?

    root@debian10:# source dns.sh
    tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
    PING www.linux-training.be (88.151.243.8) 56(84) bytes of data.
    64 bytes from fosfor.openminds.be (88.151.243.8): icmp_seq=1 ttl=55 time=13.1 ms
    64 bytes from fosfor.openminds.be (88.151.243.8): icmp_seq=2 ttl=55 time=13.3 ms

    --- www.linux-training.be ping statistics ---
    2 packets transmitted, 2 received, 0% packet loss, time 3ms
    rtt min/avg/max/mdev = 13.116/13.201/13.286/0.085 ms
    tcpdump -n -i enp0s8 -w dump3.pcap
    ^C14 packets captured
    14 packets received by filter
    0 packets dropped by kernel
    root@debian10:#

Firstly, let us see if we caught any ARP packets this time. It seems we
do, we caught the ARP request for the default gateway (10.0.2.1 in this
case, yours will vary) and the ARP response.

    root@debian10:# tcpdump -tnr dump3.pcap arp
    reading from file dump3.pcap, link-type EN10MB (Ethernet)
    ARP, Request who-has 10.0.2.1 tell 10.0.2.101, length 28
    ARP, Reply 10.0.2.1 is-at 52:54:00:12:35:00, length 46
    root@debian10:#

Secondly we take a look at the UDP packets in this capture. We caught
eight UDP packets, of which the first two are not related to DNS, but to
**NTP** (the **N**etwork **T**ime **P**rotocol). Our server wanted to
know what time it is.

After the NTP packets are two DNS queries. One for the A record for
**www.linux-training.be** and one for the quad A (AAAA) record for
**www.linux-training.be**. Both queries go to the server with IP-address
8.8.8.8. The 8.8.8.8 server responds with an A record pointing to
88.151.243.8.

The last two lines in the screenshot are a query and a response for a
PTR record, which we will discuss in the DNS chapters.

    root@debian10:# tcpdump -tnr dump3.pcap udp
    reading from file dump3.pcap, link-type EN10MB (Ethernet)
    IP 10.0.2.101.38390 > 85.88.55.5.123: NTPv4, Client, length 48
    IP 85.88.55.5.123 > 10.0.2.101.38390: NTPv4, Server, length 48
    IP 10.0.2.101.48961 > 8.8.8.8.53: 7889+ A? www.linux-training.be. (39)
    IP 10.0.2.101.48961 > 8.8.8.8.53: 28383+ AAAA? www.linux-training.be. (39)
    IP 8.8.8.8.53 > 10.0.2.101.48961: 28383 0/1/0 (100)
    IP 8.8.8.8.53 > 10.0.2.101.48961: 7889 1/0/0 A 88.151.243.8 (55)
    IP 10.0.2.101.45778 > 8.8.8.8.53: 21726+ PTR? 8.243.151.88.in-addr.arpa. (43)
    IP 8.8.8.8.53 > 10.0.2.101.45778: 21726 1/0/0 PTR fosfor.openminds.be. (76)
    root@debian10:#

Thirdly the last four packets of this tcpdump are the ping echo requests
and replies. They go from our server at 10.0.2.101 to the
linux-training.be server at 88.151.243.8.

    root@debian10:# tcpdump -tnr dump3.pcap icmp
    reading from file dump3.pcap, link-type EN10MB (Ethernet)
    IP 10.0.2.101 > 88.151.243.8: ICMP echo request, id 768, seq 1, length 64
    IP 88.151.243.8 > 10.0.2.101: ICMP echo reply, id 768, seq 1, length 64
    IP 10.0.2.101 > 88.151.243.8: ICMP echo request, id 768, seq 2, length 64
    IP 88.151.243.8 > 10.0.2.101: ICMP echo reply, id 768, seq 2, length 64
    root@debian10:#

## WWW example

When you surf with Firefox or Chrome to a website, then a connection is
made between your browser (Firefox or Chrome) and the WWW server. This
connection happens in the **Application** Layer. But applications don’t
know about *connections* or *networks* so the *connection* is made by
TCP in the **Transport** layer. TCP however does not know about
delivering packets on a network so the **Network** layer is used to
deliver the datagram to the correct destination IP-address, probably
passing over several **routers**. At the link layer the **Ethernet**
protocol is responsible for LAN communication and for delivering the
**Ethernet frame** to the next computer (often a router). And at the
bottom of the layers there is hardware necessary that can transfer
electrical signals or radio waves from one point to the next. This
hardware does not know anything about HTTP, TCP or IP.

<figure>
<img src="images/tcpip_layers7.svg" alt="images/tcpip_layers7.svg" />
</figure>

On the receiving computer, the WWW server, the electrical signals are
received by the network card and are translated into bytes. Then the
destination MAC-address will be verified, if this is correct then the
Ethernet header will be removed and the datagram will be given to IP. IP
will verify the IP-address, strip its header and give the packet to TCP.
TCP will verify the port, 80 or 443 in this case, and will also strip
its header and give the rest to the WWW server application (for example
Apache).

Packets with other destination ports will be given to other
applications.

<figure>
<img src="images/tcpip_stack.svg" alt="images/tcpip_stack.svg" />
</figure>

## Encapsulation

HTTP is the protocol used between the browser (for example Firefox) and
the web server (often Apache). TCP adds a TCP header to this protocol,
and has the Application layer protocol as **payload** or **data**. IP
adds an IP header and has the TCP header and payload as its **payload**.
Ethernet adds an Ethernet header and has the IP header and payload as
**payload**, and so the frame goes to the hardware and ends up in
electrical signals or radio waves (with their own header), to be
received on the next computer.

<figure>
<img src="images/encapsulation.svg" alt="images/encapsulation.svg" />
</figure>

Note that the above picture is simplified, the headers are not really
appended.

## An Ethernet Frame

An **Ethernet frame** in the case of a browser’s first contact with a
web server, contains an Ethernet header, an IP header, a TCP header and
an HTTP GET request. The image below shows the location of these bytes
in an Ethernet frame.

<figure>
<img src="images/ethernet_frame.svg" alt="images/ethernet_frame.svg" />
</figure>

The **Ethernet** header is in red. The first six bytes of the frame is
the **destination MAC-address**, the next six bytes is the **source
MAC-address**.

The **IP** header is in green and contains at the end four bytes for the
**destination IP-address** and before that four bytes for the **source
IP-address**.

In blue is the **TCP** header which starts with two bytes for the
**source port** and two bytes for the **destination port**. After the
TCP header we find the HTTP protocol (in white), a typical Ethernet
frame can be up to 1500 bytes in length.

## Simplified packet

In this book we will use this simplified picture for an Ethernet frame.
Note that we always put the destination before the source, this improves
readability.

<figure>
<img src="images/ethernet_frame_simple.svg"
alt="images/ethernet_frame_simple.svg" />
</figure>

## Cheat sheet

<table>
<caption>Protocols</caption>
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
<td style="text-align: left;"><p>ARP</p></td>
<td style="text-align: left;"><p>Address Resolution Protocol, resolves
MAC-to-IP relations.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ff:ff:ff:ff:ff:ff</p></td>
<td style="text-align: left;"><p>The broadcast MAC address.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>DNS</p></td>
<td style="text-align: left;"><p>Domain Name System, resolves name-to-IP
relations (see the DNS chapters).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>frame</p></td>
<td style="text-align: left;"><p>A packet on the network.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>datagram</p></td>
<td style="text-align: left;"><p>A frame without the Ethernet
header.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>packet</p></td>
<td style="text-align: left;"><p>A term used to describe frames,
datagrams, and TCP/UDP packets.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>wi-fi</p></td>
<td style="text-align: left;"><p>A trademark for a wireless
Ethernet.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Ethernet</p></td>
<td style="text-align: left;"><p>A LAN protocol for connecting network
adapters locally.</p></td>
</tr>
</tbody>
</table>

Protocols

## Practice

1.  Imagine a network were there has been no traffic on yet, nothing.
    And you perform a **wget <http://linux-training.be>**. List all the
    packets you will see on your server’s network interface in the
    correct order. Suppose the DNS server is on the network and provides
    a complete answer from its cache, suppose the gateway is not a DNS
    server.

2.  Try to get as many of the packets as possible with tcpdump writing
    to a file. Open this file in Wireshark and verify with your answer
    from the previous question. Note that it may not be possible to
    clear the ARP/DNS cache on all network devices.

## Solution

1.  Imagine a network were there has been no traffic on yet, nothing.
    And you perform a **wget <http://linux-training.be>**. List all the
    packets you will see on your server’s network interface in the
    correct order. Suppose the DNS server is on the network and provides
    a complete answer from its cache, suppose the gateway is not a DNS
    server.

        ARP query for DNS MAC
        ARP reply with DNS MAC
        DNS query for A linux-training.be
        DNS query for AAAA linux-training.be
        DNS response for linux-training.be
        ARP query for gateway MAC
        ARP reply with gateway MAC
        TCP SYN with linux-training.be
        TCP SYN,ACK with linux-training.be
        TCP ACK with linux-training.be
        HTTP GET with linux-training.be
        several TCP packets with web page
        TCP FIN with linux-training.be
        TCP ACK with linux-training.be
        TCP FIN with linux-training.be
        TCP ACK with linux-training.be

2.  Try to get as many of the packets as possible with tcpdump writing
    to a file. Open this file in Wireshark and verify with your answer
    from the previous question. Note that it may not be possible to
    clear the ARP/DNS cache on all network devices.
