## solution: dhcp

An implementation of the solution for the `dhcp` exercise can be found at <https://github.com/HoGentTIN/linux-training-labs/tree/main/dhcp      >.

1. Set up the Debian VM (or, alternatively, Ubuntu or Mint). Enable routing and NAT on the machine so that the client machines can access the Internet.

    > Checking the settings after configuring:

    ```console
    vagrant@debian:~$ ip -br a
    lo               UNKNOWN        127.0.0.1/8 ::1/128 
    eth0             UP             10.0.2.15/24 fe80::a00:27ff:fee6:f5c9/64 
    eth1             UP             192.168.42.254/24 fe80::a00:27ff:fe86:e582/64 
    vagrant@debian:~$ ip r
    default via 10.0.2.2 dev eth0 
    10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
    192.168.42.0/24 dev eth1 proto kernel scope link src 192.168.42.254 
    vagrant@debian:~$ cat /etc/resolv.conf 
    domain home
    search home
    nameserver 10.0.2.3
    vagrant@debian:~$ cat /proc/sys/net/ipv4/ip_forward
    1
    vagrant@debian:~$ sudo nft list tables
    table ip nat
    vagrant@debian:~$ sudo nft list table nat
    table ip nat {
        chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            masquerade
        }
    }
    ```

2. Install DHCP and browse the explanation in the default configuration file `/etc/dhcp/dhcpd.conf` or the example file `/usr/share/doc/isc-dhcp-server/dhcpd.conf.example`. Turn off IPv6 support, only listen for IPv4 dhcp requests on the host-only interface.

    ```console
    vagrant@debian:~$ sudo apt install -y isc-dhcp-server
    [...output omitted...]
    vagrant@debian:~$ sudo nano /etc/default/isc-dhcp-server
    # change INTERFACESv4="" to INTERFACESv4="eth1"
    ```

3. Update the global options. Set 10.0.2.3 as the global DNS server, *linux-training.be* as the domain name, default lease time of 2 hours and maximum lease time of 4 hours.

    ```console
    vagrant@debian:~$ sudo nano /etc/dhcp/dhcpd.conf
    vagrant@debian:~$ cat /etc/dhcp/dhcpd.conf
    # dhcpd.conf -- practice setup
    
    # Global options
    option domain-name "linux-training.be";  # Set domain name
    option domain-name-servers 10.0.2.3;     # Set global DNS server
    default-lease-time 7200;                 # 2 hours
    max-lease-time 14400;                    # 4 hours
    authoritative;
    ddns-update-style none;                  # Turn off DDNS updates
    ```

4. Add a subnet declaration for the 192.168.42.0/24 network. Specify a range and set this VM as the default gateway.

    ```console
    vagrant@debian:~$ sudo nano /etc/dhcp/dhcpd.conf
    vagrant@debian:~$ tail -5 /etc/dhcp/dhcpd.conf
    # Subnet declaration:
    subnet 192.168.42.0 netmask 255.255.255.0 {
        range 192.168.42.100 192.168.42.252;
        option routers 192.168.42.254;
    }
    ```

5. Check the configuration file syntax and start the service.

    ```console
    vagrant@debian:~$ /sbin/dhcpd -t
    Internet Systems Consortium DHCP Server 4.4.3-P1
    Copyright 2004-2022 Internet Systems Consortium.
    All rights reserved.
    For info, please visit https://www.isc.org/software/dhcp/
    Config file: /etc/dhcp/dhcpd.conf
    Database file: /var/lib/dhcp/dhcpd.leases
    PID file: /var/run/dhcpd.pid
    vagrant@debian:~$ echo $?
    0
    vagrant@debian:~$ sudo systemctl status isc-dhcp-server
    ● isc-dhcp-server.service - LSB: DHCP server
        Loaded: loaded (/etc/init.d/isc-dhcp-server; generated)
        Active: active (running) since Tue 2024-10-08 09:29:25 UTC; 4s ago
        Docs: man:systemd-sysv-generator(8)
        Process: 4939 ExecStart=/etc/init.d/isc-dhcp-server start (code=exited, status=0/SUCCESS)
        Tasks: 1 (limit: 2304)
        Memory: 4.1M
            CPU: 46ms
        CGroup: /system.slice/isc-dhcp-server.service
                └─4951 /usr/sbin/dhcpd -4 -q -cf /etc/dhcp/dhcpd.conf eth1

    Oct 08 09:29:23 debian systemd[1]: Starting isc-dhcp-server.service - LSB: DHCP server...
    Oct 08 09:29:23 debian isc-dhcp-server[4939]: Launching IPv4 server only.
    Oct 08 09:29:23 debian dhcpd[4951]: Wrote 0 deleted host decls to leases file.
    Oct 08 09:29:23 debian dhcpd[4951]: Wrote 0 new dynamic host decls to leases file.
    Oct 08 09:29:23 debian dhcpd[4951]: Wrote 0 leases to leases file.
    Oct 08 09:29:23 debian dhcpd[4951]: Server starting service.
    Oct 08 09:29:25 debian isc-dhcp-server[4939]: Starting ISC DHCPv4 server: dhcpd.
    Oct 08 09:29:25 debian systemd[1]: Started isc-dhcp-server.service - LSB: DHCP server.
    ```

6. Start tcpdump to listen for DHCP requests on the host-only interface.

    ```console
    vagrant@debian:~$ sudo tcpdump -w dhcp-server.pcap -i eth1 -n port 67 or port 68

7. Attach a client VM (e.g. a Kali Linux VM) to the host-only network and start it. Check if the client gets an IP address from the DHCP server, and that the gateway and DNS server are set correctly.

    > On the client VM, a Kali Linux VM in this case:

    ```console
    ┌──(kali㉿kali)-[~]
    └─$ ip -br a
    lo               UNKNOWN        127.0.0.1/8 ::1/128 
    eth0             UP             192.168.42.100/24 fe80::7649:f279:c824:b4fa/64 

    ┌──(kali㉿kali)-[~]
    └─$ ip r    
    default via 192.168.42.254 dev eth1 proto dhcp src 192.168.42.100 metric 100 
    192.168.42.0/24 dev eth1 proto kernel scope link src 192.168.42.100 metric 100 

    ┌──(kali㉿kali)-[~]
    └─$ cat /etc/resolv.conf 
    # Generated by NetworkManager
    search linux-training.be
    nameserver 10.0.2.3
    ```

    > The logs on the dhcp server show:

    ```console
    vagrant@debian:~$ sudo journalctl -flu isc-dhcp-server.service
    Oct 08 09:49:03 debian systemd[1]: Starting isc-dhcp-server.service - LSB: DHCP server...
    Oct 08 09:49:03 debian isc-dhcp-server[5062]: Launching IPv4 server only.
    Oct 08 09:49:03 debian dhcpd[5074]: Wrote 0 deleted host decls to leases file.
    Oct 08 09:49:03 debian dhcpd[5074]: Wrote 0 new dynamic host decls to leases file.
    Oct 08 09:49:03 debian dhcpd[5074]: Wrote 0 leases to leases file.
    Oct 08 09:49:03 debian dhcpd[5074]: Server starting service.
    Oct 08 09:49:05 debian isc-dhcp-server[5062]: Starting ISC DHCPv4 server: dhcpd.
    Oct 08 09:49:05 debian systemd[1]: Started isc-dhcp-server.service - LSB: DHCP server.
    Oct 08 09:51:56 debian dhcpd[5074]: DHCPDISCOVER from 08:00:27:3c:55:79 via eth1
    Oct 08 09:51:57 debian dhcpd[5074]: DHCPOFFER on 192.168.42.100 to 08:00:27:3c:55:79 (kali) via eth1
    Oct 08 09:51:57 debian dhcpd[5074]: DHCPREQUEST for 192.168.42.100 (192.168.42.254) from 08:00:27:3c:55:79 (kali) via eth1
    Oct 08 09:51:57 debian dhcpd[5074]: DHCPACK on 192.168.42.100 to 08:00:27:3c:55:79 (kali) via eth1
    ```

    > Traffic sniffed with tcpdump:

    ```console
    vagrant@debian:~$ sudo tcpdump -w dhcp-server.pcap -vni eth1 port 67 or port 68
    tcpdump: listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
    ^C6 packets captured
    6 packets received by filter
    0 packets dropped by kernel
    vagrant@debian:~$ tcpdump -r dhcp-server.pcap -en#
    reading from file dhcp-server.pcap, link-type EN10MB (Ethernet), snapshot length 262144
        1  09:51:56.148641 08:00:27:3c:55:79 > ff:ff:ff:ff:ff:ff, ethertype IPv4 (0x0800), length 324: 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 08:00:27:3c:55:79, length 282
        2  09:51:57.162348 08:00:27:7a:49:be > 08:00:27:3c:55:79, ethertype IPv4 (0x0800), length 342: 192.168.42.254.67 > 192.168.42.100.68: BOOTP/DHCP, Reply, length 300
        3  09:51:57.163998 08:00:27:3c:55:79 > ff:ff:ff:ff:ff:ff, ethertype IPv4 (0x0800), length 336: 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 08:00:27:3c:55:79, length 294
        4  09:51:57.174166 08:00:27:7a:49:be > 08:00:27:3c:55:79, ethertype IPv4 (0x0800), length 342: 192.168.42.254.67 > 192.168.42.100.68: BOOTP/DHCP, Reply, length 300
    ```

8. From the client VM, ping the default gateway/dhcp server on both interfaces (192.168.42.254 and 10.0.2.15), the DNS server 10.0.2.3 and the dhcp server's external gateway 10.0.2.2. Use `dig` to test that name resolution works. Access a website from the client VM to verify that Internet access is working.

    ```console
    ┌──(kali㉿kali)-[~]
    └─$ ping -c1 192.168.42.254
    PING 192.168.42.254 (192.168.42.254) 56(84) bytes of data.
    64 bytes from 192.168.42.254: icmp_seq=1 ttl=64 time=0.995 ms

    --- 192.168.42.254 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.995/0.995/0.995/0.000 ms

    ┌──(kali㉿kali)-[~]
    └─$ ping -c1 10.0.2.15     
    PING 10.0.2.15 (10.0.2.15) 56(84) bytes of data.
    64 bytes from 10.0.2.15: icmp_seq=1 ttl=64 time=0.780 ms

    --- 10.0.2.15 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.780/0.780/0.780/0.000 ms

    ┌──(kali㉿kali)-[~]
    └─$ ping -c1 10.0.2.2 
    PING 10.0.2.2 (10.0.2.2) 56(84) bytes of data.
    64 bytes from 10.0.2.2: icmp_seq=1 ttl=62 time=1.13 ms

    --- 10.0.2.2 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 1.129/1.129/1.129/0.000 ms

    ┌──(kali㉿kali)-[~]
    └─$ ping -c1 10.0.2.3
    PING 10.0.2.3 (10.0.2.3) 56(84) bytes of data.
    64 bytes from 10.0.2.3: icmp_seq=1 ttl=62 time=1.25 ms

    --- 10.0.2.3 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms 
    rtt min/avg/max/mdev = 1.251/1.251/1.251/0.000 ms

    ┌──(kali㉿kali)-[~]
    └─$ dig linux-training.be +short
    188.40.26.208

    ┌──(kali㉿kali)-[~]
    └─$ curl https://icanhazdadjoke.com
    I had a pair of racing snails. I removed their shells to make them more aerodynamic, but they became sluggish.                                             
    ```

9. Add a client reservation the client VM. Find the MAC address and assign a fixed IP address to it. Give it a longer default and maximum lease time than the global settings (e.g. 4 and 10 hours, respectively). Restart the dhcp server and re-attach the client VM to the network. Check if the client gets the reserved IP address and can access the internet.

    > On the dhcp server:

    ```console
    vagrant@debian:~$ sudo nano /etc/dhcp/dhcpd.conf 
    vagrant@debian:~$ tail -5 !$
    tail -5 /etc/dhcp/dhcpd.conf
    host kali {
        hardware ethernet 08:00:27:d2:26:79;
        fixed-address 192.168.42.42;
    }
    vagrant@debian:~$ sudo systemctl restart isc-dhcp-server.service
    ```

    > Following the dhcp server logs:

    ```text
    Oct 08 10:04:58 debian dhcpd[5195]: Server starting service.
    Oct 08 10:05:00 debian isc-dhcp-server[5182]: Starting ISC DHCPv4 server: dhcpd.
    Oct 08 10:05:00 debian systemd[1]: Started isc-dhcp-server.service - LSB: DHCP server.
    Oct 08 10:05:51 debian dhcpd[5195]: DHCPREQUEST for 192.168.42.42 from 08:00:27:d2:26:79 via eth1
    Oct 08 10:05:51 debian dhcpd[5195]: DHCPACK on 192.168.42.42 to 08:00:27:d2:26:79 via eth1
    ```

    > On the client VM:

    ```console
    ┌──(kali㉿kali)-[~]
    └─$ ip a show dev eth0
    1: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether 08:00:27:d2:26:79 brd ff:ff:ff:ff:ff:ff
        inet 192.168.42.42/24 brd 192.168.42.255 scope global dynamic noprefixroute eth0
        valid_lft 7114sec preferred_lft 7114sec
        inet6 fe80::8b2d:a671:507e:7848/64 scope link noprefixroute 
        valid_lft forever preferred_lft forever
    ```

