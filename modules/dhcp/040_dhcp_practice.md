## Practice: dhcp

1\. Make sure you have a unique fixed ip address for your DNS and DHCP
server (easier on the same machine).

2\. Install DHCP and browse the explanation in the default configuration
file /etc/dhcp/dhcpd.conf or /etc/dhcp3/dhcpd.conf.

3\. Decide on a valid scope and activate it.

4\. Test with a client that your DHCP server works.

5\. Use wireshark to capture the four broadcasts when a client receives
an ip (for the first time).

6\. Use wireshark to capture a DHCPNAK and a DHCPrelease.

7\. Reserve a configuration for a particular client (using mac address).

8\. Configure your DHCP/DNS server(s) with a proper hostname and
domainname (/etc/hosts, /etc/hostname, /etc/sysconfig/network on
Fedora/RHEL, /etc/resolv.conf \...). You may need to disable
NetworkManager on \*buntu-desktops.

9\. Make sure your DNS server still works, and is master over (at least)
one domain.

There are several ways to do steps 10-11-12. Google is your friend in
exploring DDNS with keys, with key-files or without keys.

10\. Configure your DNS server to allow dynamic updates from your DHCP
server.

11\. Configure your DHCP server to send dynamic updates to your DNS
server.

12\. Test the working of Dynamic DNS.

