# solution: packet filtering

A possible solution, where leftnet is the internal and rightnet is the
external network.

    #!/bin/bash

    # first cleanup everything
    iptables -t filter -F
    iptables -t filter -X
    iptables -t nat -F
    iptables -t nat -X

    # default drop
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT DROP

    # allow loopback device
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

    # question 1: allow ssh over eth0
    iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -o eth0 -p tcp --sport 22 -j ACCEPT

    # question 2: Allow icmp(ping) anywhere
    iptables -A INPUT -p icmp --icmp-type any -j ACCEPT
    iptables -A FORWARD -p icmp --icmp-type any -j ACCEPT
    iptables -A OUTPUT -p icmp --icmp-type any -j ACCEPT

    # question 3: allow http from internal(leftnet) to external(rightnet)
    iptables -A FORWARD -i eth1 -o eth2 -p tcp --dport 80 -j ACCEPT
    iptables -A FORWARD -i eth2 -o eth1 -p tcp --sport 80 -j ACCEPT

    # question 4: allow ssh from internal(leftnet) to external(rightnet)
    iptables -A FORWARD -i eth1 -o eth2 -p tcp --dport 22 -j ACCEPT
    iptables -A FORWARD -i eth2 -o eth1 -p tcp --sport 22 -j ACCEPT

    # allow http from external(rightnet) to internal(leftnet)
    # iptables -A FORWARD -i eth2 -o eth1 -p tcp --dport 80 -j ACCEPT
    # iptables -A FORWARD -i eth1 -o eth2 -p tcp --sport 80 -j ACCEPT

    # allow rpcinfo over eth0 from outside to system
    # iptables -A INPUT -i eth2 -p tcp --dport 111 -j ACCEPT
    # iptables -A OUTPUT -o eth2 -p tcp --sport 111 -j ACCEPT
