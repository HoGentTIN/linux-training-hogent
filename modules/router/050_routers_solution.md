# solution: packet forwarding

![](images/LAN_networks.png)

1\. Set up two Linux machines, one on `leftnet`, the other on
`rightnet`. Make sure they both get an ip-address in the correct subnet.
These two machines will be \'left\' and \'right\' from the \'router\'.

![](images/leftnet_rightnet_router2.png)

The ip configuration on your computers should be similar to the
following two screenshots. Both machines must be in a different subnet
(here 192.168.60.0/24 and 192.168.70.0/24). I created a little script on
both machines to configure the interfaces.

    root@left~# cat leftnet.sh
    pkill dhclient
    ifconfig eth0 192.168.60.8 netmask 255.255.255.0

    root@right~# cat rightnet.sh
    pkill dhclient
    ifconfig eth0 192.168.70.9 netmask 255.255.255.0

2\. Set up a third Linux computer with three network cards, one on
`leftnet`, the other on `rightnet`. This computer will be the
\'router\'. Complete the table below with the relevant names,
ip-addresses and mac-addresses.

    root@router~# cat router.sh
    ifconfig eth1 192.168.60.1 netmask 255.255.255.0
    ifconfig eth2 192.168.70.1 netmask 255.255.255.0
    #echo 1 > /proc/sys/net/ipv4/ip_forward

Your setup may use different ip and mac addresses than the ones in the
table below.

  -------------------------------------------------------------------------------
   leftnet computer       the router                           rightnet computer
  ------------------- ------------------- ------------------- -------------------
   08:00:27:f6:ab:b9   08:00:27:43:1f:5a   08:00:27:be:4a:6b   08:00:27:14:8b:17

     192.168.60.8        192.168.60.1        192.168.70.1        192.168.70.9
  -------------------------------------------------------------------------------

  : Packet Forwarding Solution

3\. How can you verify whether the `router` will allow packet forwarding
by default or not ? Test that you can ping from the `router` to the two
other machines, and from those two machines to the `router`. Use
`arp -a` to make sure you are connected with the correct
`mac addresses`.

This can be done with \"`grep ip_forward /etc/sysctl.conf`\" (1 is
enabled, 0 is disabled) or with `sysctl -a | grep ip_for`.

    root@router~# grep ip_for /etc/sysctl.conf 
    net.ipv4.ip_forward = 0

4\. Ping from the leftnet computer to the rightnet computer. Enable
and/or disable packet forwarding on the `router` and verify what happens
to the ping between the two networks. If you do not succeed in pinging
between the two networks (on different subnets), then use a sniffer like
wireshark or tcpdump to discover the problem.

Did you forget to add a `default gateway` to the LAN machines ? Use
`route add default gw 'ip-address'`.

    root@left~# route add default gw 192.168.60.1

    root@right~# route add default gw 192.168.70.1

You should be able to ping when packet forwarding is enabled (and both
default gateways are properly configured). The ping will not work when
packet forwarding is disabled or when gateways are not configured
correctly.

5\. Use wireshark or tcpdump -xx to answer the following questions. Does
the source MAC change when a packet passes through the filter ? And the
destination MAC ? What about source and destination IP-addresses ?

Both MAC addresses are changed when passing the router. Use
`tcpdump -xx` like this:

    root@router~# tcpdump -xx -i eth1

    root@router~# tcpdump -xx -i eth2

6\. Remember the third network card on the router ? Connect this card to
a LAN with internet connection. On many LAN\'s the command
`dhclient eth0` just works (replace `eth0` with the correct interface.

    root@router~# dhclient eth0

You now have a setup similar to this picture. What needs to be done to
give internet access to `leftnet` and `rightnet`.

![](images/leftnet_rightnet_router3.png)

The clients on `leftnet` and `rightnet` need a working `dns server`. We
use one of Google\'s dns servers here.

    echo nameserver 8.8.8.8 > /etc/resolv.conf
