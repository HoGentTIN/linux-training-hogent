## practice: DHCP server with ISC Kea

In this exercise, we are going to set up an **Enterprise Linux 10** VM as a router and dhcp server. Use e.g. Vagrant to quickly set up a VirtualBox VM with a NAT interface (usually `eth0` or `enp0s3`) and a Host-Only Interface (`eth1` or `enp0s8`). The Host-Only Interface will be used to connect the client VMs. The NAT interface will provide Internet access to the VMs.

1. Set up the Enterprise Linux VM (e.g. AlmaLinux 10). Give it a static IP address 192.168.42.254/24 on the second Host-Only Interface `eth1` (or `enp0s8`, depending on the VM configuration). Vagrant will also automatically connect the VM to a NAT interface `eth0` (or `enp0s3`), providing Internet access. The VM's IP address on this interface are provided by VirtualBox, but they are predictable: the IP address will be 10.0.2.15, the default gateway 10.0.2.2 and DNS server 10.0.2.3. This DNS server will also be used by the client VMs.

    Enable routing on the machine and NAT address translation so it can provide Internet access to client machines on the network. Follow the instructions in the [router with nat](../firewall/#router-with-nat) section of the [chapter on firewalls](../firewall/).

2. Install Kea and copy an appropriate example configuration file to `/etc/kea`. Back up the original configuration file first.

3. Add a subnet declaration for the 192.168.42.0/24 network. Specify a range (100-252) and set this VM as the default gateway.

4. Update the options for this subnet. Set 10.0.2.3 as the global DNS server, *linux-training.be* as the domain name, default lease time of 2 hours and maximum lease time of 4 hours.

5. Check the configuration file syntax and start the service. Check that the service is listening on the appropriate NIC and port.

6. Start tcpdump to listen for DHCP requests on the host-only interface.

7. Attach a client VM (e.g. a Kali Linux VM) to the host-only network and start it. Check if the client gets an IP address from the DHCP server, and that the gateway and DNS server are set correctly.

8. From the client VM, ping the default gateway/dhcp server on both interfaces (192.168.42.254 and 10.0.2.15), the DNS server 10.0.2.3 and the dhcp server's external gateway 10.0.2.2. Use `dig` to test that name resolution works. Access a website from the client VM to verify that Internet access is working.

9. Add a client reservation the client VM. Find the MAC address and assign a fixed IP address to it. Give it a longer default and maximum lease time than the global settings (e.g. 4 and 10 hours, respectively). Restart the dhcp server and re-attach the client VM to the network. Check if the client gets the reserved IP address and can access the internet.

Repeat the exercise for a VM with a **Debian-based** distribution (e.g. Debian 12/13 or Ubuntu 24.04) with ip address 192.168.42.253/24. What happens if both VMs are active at the same time?

