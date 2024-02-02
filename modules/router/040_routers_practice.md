## practice: packet forwarding

0\. You have the option to select (or create) an internal network when
adding a network card in `VirtualBox` or
`VMWare`. Use this option to create two internal networks.
I named them `leftnet` and `rightnet`, but you can choose any other
name.

![](images/LAN_networks.png)

1\. Set up two Linux machines, one on `leftnet`, the other on
`rightnet`. Make sure they both get an ip-address in the correct subnet.
These two machines will be \'left\' and \'right\' from the \'router\'.

![](images/leftnet_rightnet_router2.png)

2\. Set up a third Linux computer with three network cards, one on
`leftnet`, the other on `rightnet`. This computer will be the
\'router\'. Complete the table below with the relevant names,
ip-addresses and `mac-addresses`.

  -------------------------------------------------------------------------
        leftnet computer the router                        rightnet
                                                           computer
  ----- ---------------- ---------------- ---------------- ----------------
  MAC                                                      

  IP                                                       
  -------------------------------------------------------------------------

  : Packet Forwarding Exercise

3\. How can you verify whether the `router` will allow packet forwarding
by default or not ? Test that you can `ping` from the
`router` to the two other machines, and from those two machines to the
`router`. Use `arp -a` to make sure you are connected with the correct
`mac addresses`.

4\. `Ping` from the leftnet computer to the rightnet
computer. Enable and/or disable packet forwarding on the `router` and
verify what happens to the ping between the two networks. If you do not
succeed in pinging between the two networks (on different subnets), then
use a sniffer like `wireshark` or `tcpdump` to discover the problem.

5\. Use `wireshark` or `tcpdump` -xx to
answer the following questions. Does the source MAC change when a packet
passes through the filter ? And the destination MAC ? What about source
and destination IP-addresses ?

6\. Remember the third network card on the router ? Connect this card to
a LAN with internet connection. On many LAN\'s the command
`dhclient eth0` just works (replace `eth0` with the
correct interface).

    root@router~# dhclient eth0

You now have a setup similar to this picture. What needs to be done to
give internet access to `leftnet` and `rightnet`.

![](images/leftnet_rightnet_router3.png)
