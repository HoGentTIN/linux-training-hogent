## about ipv6

The `ipv6` protocol is designed to replace `ipv4`. Where `ip version 4`
supports a maximum of four billion unique addresses, `ip version 6`
expands this to
`four billion times four billion times four billion times four billion`
unique addresses. This is more than 100.000.000.000.000.000.000 ipv6
addresses per square cm on our planet. That should be enough, even if
every cell phone, every coffee machine and every pair of socks gets an
address.

Technically speaking ipv6 uses 128-bit addresses (instead of the 32-bit
from ipv4). 128-bit addresses are `huge` numbers. In decimal it would
amount up to 39 digits, in hexadecimal it looks like this:

    fe80:0000:0000:0000:0a00:27ff:fe8e:8aa8

Luckily ipv6 allows us to omit leading zeroes. Our address from above
then becomes:

    fe80:0:0:0:a00:27ff:fe8e:8aa8

When a 16-bit block is zero, it can be written as `::`. Consecutive
16-bit blocks that are zero can also be written as `::`. So our address
can from above can be shortened to:

    fe80::a00:27ff:fe8e:8aa8

This `::` can only occur once! The following is not a valid ipv6
address:

    fe80::20:2e4f::39ac

The ipv6 `localhost` address is
`0000:0000:0000:0000:0000:0000:0000:0001`, which can be abbreviated to
`::1`.

    paul@debian10:~/github/lt/images$ /sbin/ifconfig lo | grep inet6
              inet6 addr: ::1/128 Scope:Host

## network id and host id

One of the few similarities between ipv4 and ipv6 is that addresses have
a host part and a network part determined by a subnet mask. Using the
`cidr` notation this looks like this:

    fe80::a00:27ff:fe8e:8aa8/64

The above address has 64 bits for the host id, theoretically allowing
for 4 billion times four billion hosts.

The localhost address looks like this with cidr:

    ::1/128

## host part generation

The host part of an automatically generated (stateless) ipv6 address
contains part of the hosts mac address:

    paul@debian10:~$ /sbin/ifconfig | head -3
    eth3      Link encap:Ethernet  HWaddr 08:00:27:ab:67:30  
              inet addr:192.168.1.29  Bcast:192.168.1.255  Mask:255.255.255.0
              inet6 addr: fe80::a00:27ff:feab:6730/64 Scope:Link

Some people are concerned about privacy here\...

## ipv4 mapped ipv6 address

Some applications use ipv4 addresses embedded in an ipv6 address. (Yes
there will be an era of migration with both ipv4 and ipv6 in use.) The
ipv6 address then looks like this:

    ::ffff:192.168.1.42/96

Indeed a mix of decimal and hexadecimal characters\...

## link local addresses

`ipv6` addresses starting with `fe8.` can only be used on the local
segment (replace the dot with an hexadecimal digit). This is the reason
you see `Scope:Link` behind the address in this screenshot. This address
serves only the `local link`.

    paul@deb106:~$ /sbin/ifconfig | grep inet6
       inet6 addr: fe80::a00:27ff:fe8e:8aa8/64 Scope:Link
       inet6 addr: ::1/128 Scope:Host

These `link local` addresses all begin with `fe8.`.

Every ipv6 enabled nic will get an address in this range.

## unique local addresses

The now obsolete system of `site local addresses` similar to ipv4
private ranges is replaced with a system of globally unique local ipv6
addresses. This to prevent duplicates when joining of networks within
`site local` ranges.

All `unique local` addresses strat with `fd..`.

## globally unique unicast addresses

Since `ipv6` was designed to have multiple ip addresses per interface,
the `global ipv6 address` can be used next to the `link local address`.

These `globally unique` addresses all begin with `2...` or `3...` as the
first 16-bits.

## 6to4

`6to4` is defined in rfc\'s 2893 and 3056 as one possible way to
transition between ipv4 and ipv6 by creating an ipv6 tunnel.

It encodes an ipv4 address in an ipv6 address that starts with `2002`.
For example 192.168.1.42/24 will be encoded as:

    2002:c0a8:12a:18::1

You can use the command below to convert any ipv4 address to this range.

    paul@ubu1010:~$ printf "2002:%02x%02x:%02x%02x:%04x::1\n" `echo 192.168.1.42/24 \
    |tr "./" "  "`
    2002:c0a8:012a:0018::1

## ISP

Should you be so lucky to get an ipv6 address from an `isp`, then it
will start with `2001:`.

## non routable addresses

Comparable to `example.com` for DNS, the following ipv6 address ranges
are reserved for examples, and not routable on the internet.

    3fff:ffff::/32
    2001:0db8::/32

## ping6

Use `ping6` to test connectivity between ipv6 hosts. You need to specify
the interface (there is no routing table for \'random\' generated ipv6
link local addresses).

    [root@fedora14 ~]# ping6 -I eth0 fe80::a00:27ff:fecd:7ffc
    PING fe80::a00:27ff:fecd:7ffc(fe80::a00:27ff:fecd:7ffc) from fe80::a00:27ff:fe3c:4346 eth0: 56 data bytes
    64 bytes from fe80::a00:27ff:fecd:7ffc: icmp_seq=1 ttl=64 time=0.586 ms
    64 bytes from fe80::a00:27ff:fecd:7ffc: icmp_seq=2 ttl=64 time=3.95 ms
    64 bytes from fe80::a00:27ff:fecd:7ffc: icmp_seq=3 ttl=64 time=1.53 ms

Below a multicast ping6 that recieves replies from three ip6 hosts on
the same network.

    [root@fedora14 ~]# ping6 -I eth0 ff02::1
    PING ff02::1(ff02::1) from fe80::a00:27ff:fe3c:4346 eth0: 56 data bytes
    64 bytes from fe80::a00:27ff:fe3c:4346: icmp_seq=1 ttl=64 time=0.598 ms
    64 bytes from fe80::a00:27ff:fecd:7ffc: icmp_seq=1 ttl=64 time=1.87 ms (DUP!)
    64 bytes from fe80::8e7b:9dff:fed6:dff2: icmp_seq=1 ttl=64 time=535 ms (DUP!)
    64 bytes from fe80::a00:27ff:fe3c:4346: icmp_seq=2 ttl=64 time=0.106 ms
    64 bytes from fe80::8e7b:9dff:fed6:dff2: icmp_seq=2 ttl=64 time=1.79 ms (DUP!)
    64 bytes from fe80::a00:27ff:fecd:7ffc: icmp_seq=2 ttl=64 time=2.48 ms (DUP!)

## Belgium and ipv6

A lot of information on ipv6 in Belgium can be found at
www.ipv6council.be.

Sites like ipv6.belgium.be, www.bipt.be and www.bricozone.be are enabled
for ipv6. Some Universities also: fundp.ac.be (Namur) and ulg.ac.be
(Liege).

## other websites

Other useful websites for testing ipv6 are:

    test-ipv6.com
    ipv6-test.com

Going to the ipv6-test.com website will test whether you have a valid
accessible ipv6 address.

![](../images/ipv6_test_ok.jpg)

Going to the test-ipv6.com website will also test whether you have a
valid accessible ipv6 address.

![](../images/ipv6_test2_ok.jpg)

## 6to4 gateways

To access ipv4 only websites when on ipv6 you can use sixxs.net (more
specifically http://www.sixxs.net/tools/gateway/) as a gatway.

For example use http://www.slashdot.org.sixxs.org/ instead of
http://slashdot.org

## ping6 and dns

Below a screenshot of a `ping6` from behind a 6to4 connection.

![](../images/ipv6_ping6_dns.jpg)

## ipv6 and tcp/http

Below a screenshot of a tcp handshake and http connection over ipv6.

![](../images/tcp_over_ipv6.jpg)

## ipv6 PTR record

As seen in the DNS chapter, ipv6 PTR records are in the ip6.net domain,
and have 32 generations of child domains.

![](../images/ipv6_PTR_record.jpg)

## 6to4 setup on Linux

Below a transcript of a 6to4 setup on Linux.

Thanks to http://www.anyweb.co.nz/tutorial/v6Linux6to4 and
http://mirrors.bieringer.de/Linux+IPv6-HOWTO/ and tldp.org!

    root@mac:~# ifconfig 
    eth0      Link encap:Ethernet  HWaddr 00:26:bb:5d:2e:52  
              inet addr:81.165.101.125  Bcast:255.255.255.255  Mask:255.255.248.0
              inet6 addr: fe80::226:bbff:fe5d:2e52/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:5926044 errors:0 dropped:0 overruns:0 frame:0
              TX packets:2985892 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:4274849823 (4.2 GB)  TX bytes:237002019 (237.0 MB)
              Interrupt:43 Base address:0x8000 

    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:598 errors:0 dropped:0 overruns:0 frame:0
              TX packets:598 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:61737 (61.7 KB)  TX bytes:61737 (61.7 KB)

    root@mac:~# sysctl -w net.ipv6.conf.default.forwarding=1
    net.ipv6.conf.default.forwarding = 1
    root@mac:~# ip tunnel add tun6to4 mode sit remote any local 81.165.101.125
    root@mac:~# ip link set dev tun6to4 mtu 1472 up
    root@mac:~# ip link show dev tun6to4
    10: tun6to4: <NOARP,UP,LOWER_UP> mtu 1472 qdisc noqueue state UNKNOWN 
        link/sit 81.165.101.125 brd 0.0.0.0
    root@mac:~# ip -6 addr add dev tun6to4 2002:51a5:657d:0::1/64
    root@mac:~# ip -6 addr add dev eth0 2002:51a5:657d:1::1/64
    root@mac:~# ip -6 addr add dev eth0 fdcb:43c1:9c18:1::1/64
    root@mac:~# ifconfig
    eth0      Link encap:Ethernet  HWaddr 00:26:bb:5d:2e:52  
              inet addr:81.165.101.125  Bcast:255.255.255.255  Mask:255.255.248.0
              inet6 addr: fe80::226:bbff:fe5d:2e52/64 Scope:Link
              inet6 addr: fdcb:43c1:9c18:1::1/64 Scope:Global
              inet6 addr: 2002:51a5:657d:1::1/64 Scope:Global
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:5927436 errors:0 dropped:0 overruns:0 frame:0
              TX packets:2986025 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:4274948430 (4.2 GB)  TX bytes:237014619 (237.0 MB)
              Interrupt:43 Base address:0x8000 

    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:598 errors:0 dropped:0 overruns:0 frame:0
              TX packets:598 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0
              RX bytes:61737 (61.7 KB)  TX bytes:61737 (61.7 KB)

    tun6to4   Link encap:IPv6-in-IPv4  
              inet6 addr: ::81.165.101.125/128 Scope:Compat
              inet6 addr: 2002:51a5:657d::1/64 Scope:Global
              UP RUNNING NOARP  MTU:1472  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    root@mac:~# ip -6 route add 2002::/16 dev tun6to4
    root@mac:~# ip -6 route add ::/0 via ::192.88.99.1 dev tun6to4 metric 1
    root@mac:~# ip -6 route show
    ::/96 via :: dev tun6to4  metric 256  mtu 1472 advmss 1412 hoplimit 0
    2002:51a5:657d::/64 dev tun6to4  proto kernel  metric 256  mtu 1472 advmss 1412 hoplimit 0
    2002:51a5:657d:1::/64 dev eth0  proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
    2002::/16 dev tun6to4  metric 1024  mtu 1472 advmss 1412 hoplimit 0
    fdcb:43c1:9c18:1::/64 dev eth0  proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
    fe80::/64 dev eth0  proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
    fe80::/64 dev tun6to4  proto kernel  metric 256  mtu 1472 advmss 1412 hoplimit 0
    default via ::192.88.99.1 dev tun6to4  metric 1  mtu 1472 advmss 1412 hoplimit 0
    root@mac:~# ping6 ipv6-test.com
    PING ipv6-test.com(ipv6-test.com) 56 data bytes
    64 bytes from ipv6-test.com: icmp_seq=1 ttl=57 time=42.4 ms
    64 bytes from ipv6-test.com: icmp_seq=2 ttl=57 time=43.0 ms
    64 bytes from ipv6-test.com: icmp_seq=3 ttl=57 time=43.5 ms
    64 bytes from ipv6-test.com: icmp_seq=4 ttl=57 time=43.9 ms
    64 bytes from ipv6-test.com: icmp_seq=5 ttl=57 time=45.6 ms
    ^C
    --- ipv6-test.com ping statistics ---
    5 packets transmitted, 5 received, 0% packet loss, time 4006ms
    rtt min/avg/max/mdev = 42.485/43.717/45.632/1.091 ms
