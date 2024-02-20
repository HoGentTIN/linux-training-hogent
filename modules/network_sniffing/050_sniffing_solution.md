## solution: network sniffing

1\. Install wireshark on your computer (not inside a virtual machine).

    Debian/Ubuntu: aptitude install wireshark

    Red Hat/Mandriva/Fedora: yum install wireshark

2\. Start a ping between your computer and another computer.

    ping $ip_address

3\. Start sniffing the network.

    (sudo) wireshark

    select an interface (probably eth0)

4\. Display only the ping echo\'s in the top pane using a filter.

    type 'icmp' (without quotes) in the filter box, and then click 'apply'

5\. Now ping to a name (like www.linux-training.be) and try to sniff the
DNS query and response. Which DNS server was used ? Was it a tcp or udp
query and response ?

    First start the sniffer.

    Enter 'dns' in the filter box and click apply.

    root@ubuntu910:~# ping www.linux-training.be
    PING www.linux-training.be (88.151.243.8) 56(84) bytes of data.
    64 bytes from fosfor.openminds.be (88.151.243.8): icmp_seq=1 ttl=58 time=14.9 ms
    64 bytes from fosfor.openminds.be (88.151.243.8): icmp_seq=2 ttl=58 time=16.0 ms
    ^C
    --- www.linux-training.be ping statistics ---
    2 packets transmitted, 2 received, 0% packet loss, time 1002ms
    rtt min/avg/max/mdev = 14.984/15.539/16.095/0.569 ms

The wireshark screen should look something like this.

![](assets/wireshark_dns_sniff.png)

The details in wireshark will say the DNS query was inside a udp packet.

6\. Find an amateur/hobby/club website that features a login prompt.
Attempt to login with user \'paul\' and password \'hunter2\' while your
sniffer is running. Now find this information in the sniffer.

