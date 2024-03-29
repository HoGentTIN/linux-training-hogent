## solution: interface configuration

1\. Verify whether `dhclient` is running.

    student@linux:~$ ps fax | grep dhclient

2\. Display your current ip address(es).

    student@linux:~$ /sbin/ifconfig | grep 'inet '
          inet addr:192.168.1.31  Bcast:192.168.1.255  Mask:255.255.255.0
          inet addr:127.0.0.1  Mask:255.0.0.0

3\. Display the configuration file where this `ip address` is defined.

    Ubuntu/Debian: cat /etc/network/interfaces
    Redhat/Fedora: cat /etc/sysconfig/network-scripts/ifcfg-eth*

4\. Follow the `nic configuration` in the book to change your ip address
from `dhcp client` to `fixed`. Keep the same `ip address` to avoid
conflicts!

    Ubuntu/Debian:
    ifdown eth0
    vi /etc/network/interfaces
    ifup eth0

    Redhat/Fedora:
    ifdown eth0
    vi /etc/sysconfig/network-scripts/ifcfg-eth0
    ifup eth0

5\. Did you also configure the correct `gateway` in the previous
question ? If not, then do this now.

6\. Verify that you have a gateway.

    student@linux:~$ /sbin/route
    Kernel IP routing table
    Destination   Gateway       Genmask        Flags Metric Ref  Use Iface
    192.168.1.0   *             255.255.255.0  U     0      0      0 eth0
    default       192.168.1.1   0.0.0.0        UG    0      0      0 eth0

7\. Verify that you can connect to the gateway, that it is alive.

    student@linux:~$ ping -c3 192.168.1.1
    PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
    64 bytes from 192.168.1.1: icmp_seq=1 ttl=254 time=2.28 ms
    64 bytes from 192.168.1.1: icmp_seq=2 ttl=254 time=2.94 ms
    64 bytes from 192.168.1.1: icmp_seq=3 ttl=254 time=2.34 ms

    --- 192.168.1.1 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2008ms
    rtt min/avg/max/mdev = 2.283/2.524/2.941/0.296 ms

8\. Change the last two digits of your `mac address`.

    [root@linux ~]# ifconfig eth0 hw ether 08:00:27:ab:67:XX

9\. Which ports are used by http, pop3, ssh, telnet, nntp and ftp ?

    root@linux ~# grep ^'http ' /etc/services 
    http       80/tcp          www www-http    # WorldWideWeb HTTP
    http       80/udp          www www-http    # HyperText Transfer Protocol
    root@linux ~# grep ^'smtp ' /etc/services 
    smtp       25/tcp          mail
    smtp       25/udp          mail
    root@linux ~# grep ^'ssh ' /etc/services 
    ssh        22/tcp                     # The Secure Shell (SSH) Protocol
    ssh        22/udp                     # The Secure Shell (SSH) Protocol
    root@linux ~# grep ^'telnet ' /etc/services 
    telnet     23/tcp
    telnet     23/udp
    root@linux ~# grep ^'nntp ' /etc/services 
    nntp       119/tcp         readnews untp   # USENET News Transfer Protocol
    nntp       119/udp         readnews untp   # USENET News Transfer Protocol
    root@linux ~# grep ^'ftp ' /etc/services 
    ftp        21/tcp
    ftp        21/udp          fsp fspd

10\. Explain why e-mail and websites are sent over `tcp` and not `udp`.

    Because tcp is reliable and udp is not.

11\. Display the `hostname` of your computer.

    pau@ldebian9:~$ hostnamectl status  
         Static hostname: vaio.labs
             Icon name: computer-laptop
               Chassis: laptop
            Machine ID: 841ea4c609fa47489106a59274e87312
               Boot ID: 0208b3bbc10a4124ba6020e288f1b4e4
      Operating System: Fedora 28 (Twenty Eight)
           CPE OS Name: cpe:/o:fedoraproject:fedora:28
                Kernel: Linux 4.19.13-200.fc28.x86_64
          Architecture: x86-64

12\. Which ip-addresses did your computer recently have contact with ?

    root@linux ~# arp -a
    ? (192.168.1.1) at 00:02:cf:aa:68:f0 [ether] on eth2
    ? (192.168.1.30) at 00:26:bb:12:7a:5e [ether] on eth2
    ? (192.168.1.31) at 08:00:27:8e:8a:a8 [ether] on eth2

