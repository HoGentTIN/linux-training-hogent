# network address translation

## about NAT

A NAT device is a router that is also changing the source and/or target
ip-address in packets. It is typically used to connect multiple
computers in a private address range with the (public) internet. A NAT
can hide private addresses from the internet.

NAT was developed to mitigate the use of real ip addresses, to allow
private address ranges to reach the internet and back, and to not
disclose details about internal networks to the outside.

The nat table in iptables adds two new chains. PREROUTING allows
altering of packets before they reach the INPUT chain. POSTROUTING
allows altering packets after they exit the OUTPUT chain.

![](images/iptables_filter_nat2.png)

Use `iptables -t nat -nvL` to look at the NAT table. The screenshot
below shows an empty NAT table.

    [root@RHEL5 ~]# iptables -t nat -nL
    Chain PREROUTING (policy ACCEPT)
    target     prot opt source               destination         

    Chain POSTROUTING (policy ACCEPT)
    target     prot opt source               destination         

    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         
    [root@RHEL5 ~]#

## SNAT (Source NAT)

The goal of source nat is to change the source address inside a packet
before it leaves the system (e.g. to the internet). The destination will
return the packet to the NAT-device. This means our NAT-device will need
to keep a table in memory of all the packets it changed, so it can
deliver the packet to the original source (e.g. in the private network).

Because SNAT is about packets leaving the system, it uses the
POSTROUTING chain.

Here is an example SNAT rule. The rule says that packets coming from
10.1.1.0/24 network and exiting via eth1 will get the source ip-address
set to 11.12.13.14. (Note that this is a one line command!)

    iptables -t nat -A POSTROUTING -o eth1 -s 10.1.1.0/24 -j SNAT \
    --to-source 11.12.13.14

Of course there must exist a proper iptables filter setup to allow the
packet to traverse from one network to the other.

## SNAT example setup

This example script uses a typical nat setup. The internal (eth0)
network has access via SNAT to external (eth1) webservers (port 80).

    #!/bin/bash
    #
    # iptables script for simple classic nat websurfing
    # eth0 is internal network, eth1 is internet
    #
    echo 0 > /proc/sys/net/ipv4/ip_forward
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD DROP
    iptables -A FORWARD -i eth0 -o eth1 -s 10.1.1.0/24 -p tcp \
    --dport 80 -j ACCEPT
    iptables -A FORWARD -i eth1 -o eth0 -d 10.1.1.0/24 -p tcp \
    --sport 80 -j ACCEPT
    iptables -t nat -A POSTROUTING -o eth1 -s 10.1.1.0/24 -j SNAT \
    --to-source 11.12.13.14
    echo 1 > /proc/sys/net/ipv4/ip_forward

## IP masquerading

IP masquerading is very similar to SNAT, but is meant for dynamic
interfaces. Typical example are broadband \'router/modems\' connected to
the internet and receiving a different ip-address from the isp, each
time they are cold-booted.

The only change needed to convert the SNAT script to a masquerading is
one line.

    iptables -t nat -A POSTROUTING -o eth1 -s 10.1.1.0/24 -j MASQUERADE

## DNAT (Destination NAT)

DNAT is typically used to allow packets from the internet to be
redirected to an internal server (in your DMZ) and in a private address
range that is inaccessible directly form the internet.

This example script allows internet users to reach your internal
(192.168.1.99) server via ssh (port 22).

    #!/bin/bash
    #
    # iptables script for DNAT
    # eth0 is internal network, eth1 is internet
    #
    echo 0 > /proc/sys/net/ipv4/ip_forward
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD DROP
    iptables -A FORWARD -i eth0 -o eth1 -s 10.1.1.0/24 -j ACCEPT
    iptables -A FORWARD -i eth1 -o eth0 -p tcp --dport 22 -j ACCEPT
    iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 22 \
    -j DNAT --to-destination 10.1.1.99
    echo 1 > /proc/sys/net/ipv4/ip_forward
