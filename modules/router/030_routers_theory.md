## router or firewall

A `router` is a device that connects two networks. A
`firewall` is a device that besides acting as a `router`,
also contains (and implements) rules to determine whether packets are
allowed to travel from one network to another. A firewall can be
configured to block access based on networks, hosts, protocols and
ports. Firewalls can also change the contents of packets while
forwarding them.

![](../images/router_or_firewall.png)

## packet forwarding

`Packet forwarding` means allowing packets to go from one network to
another. When a multihomed host is connected to two different networks,
and it allows packets to travel from one network to another through its
two network interfaces, it is said to have enabled
`packet forwarding`.

## packet filtering

`Packet filtering` is very similar to packet forwarding,
but every packet is individually tested against rules that decide on
allowing or dropping the packet. The rules are stored by iptables.

## stateful

A `stateful` firewall is an advancement over stateless
firewalls that inspect every individual packet. A stateful firewall will
keep a table of active connections, and is knowledgeable enough to
recognise when new connections are part of an active session. Linux
iptables is a stateful firewall.

## nat (network address translation)

A `nat` device is a router that is also changing the
source and/or target ip-address in packets. It is typically used to
connect multiple computers in a private address range (rfc 1918) with
the (public) internet. A `nat` can hide private addresses from the
internet.

It is important to understand that people and vendors do not always use
the right term when referring to a certain type of `nat`. Be sure you
talk about the same thing. We can distuinguish several types of `nat`.

## pat (port address translation)

`nat` often includes `pat`. A `pat` device is a router
that is also changing the source and/or target tcp/udp port in packets.
`pat` is Cisco terminology and is used by `snat`, `dnat`, `masquerading`
and `port forwarding` in Linux. RFC 3022 calls it `NAPT`
and defines the `nat/pat` combo as \"traditional nat\". A device sold to
you as a nat-device will probably do `nat` and `pat`.

## snat (source nat)

A `snat` device is changing the source ip-address when a
packet passes our `nat`. `snat` configuration with iptables includes a
fixed target source address.

## masquerading

`Masquerading` is a form of `snat` that will hide the
(private) source ip-addresses of your private network using a public
ip-address. Masquerading is common on dynamic internet interfaces
(broadband modem/routers). Masquerade configuration with iptables uses a
dynamic target source address.

## dnat (destination nat)

A `dnat` device is changing the destination ip-address
when a packet passes our `nat`.

## port forwarding

When static `dnat` is set up in a way that allows outside connections to
enter our private network, then we call it
`port forwarding`.

## /proc/sys/net/ipv4/ip_forward

Whether a host is forwarding packets is defined in
`/proc/sys/net/ipv4/ip_forward`. The following screenshot
shows how to enable packet forwarding on Linux.

    root@router~# echo 1 > /proc/sys/net/ipv4/ip_forward
        

The next command shows how to disable packet forwarding.

    root@router~# echo 0 > /proc/sys/net/ipv4/ip_forward
        

Use cat to check if packet forwarding is enabled.

    root@router~# cat /proc/sys/net/ipv4/ip_forward
        

## /etc/sysctl.conf

By default, most Linux computers are not configured for automatic packet
forwarding. To enable packet forwarding whenever the system starts,
change the `net.ipv4.ip_forward` variable in
`/etc/sysctl.conf` to the value 1.

    root@router~# grep ip_forward /etc/sysctl.conf 
    net.ipv4.ip_forward = 0

## sysctl

For more information, take a look at the man page of
`sysctl`.

    root@debian6~# man sysctl
    root@debian6~# sysctl -a 2>/dev/null | grep ip_forward
    net.ipv4.ip_forward = 0

