## practice: firewalld

For this lab, you can use a VM created with Vagrant with two network adapters:

- Adapter 1 (interface name `eth0` or `enp0s3`) is connected to the NAT network
- Adapter 2 (interface name `eth1` or `enp0s8`) is connected to a Host-only network

We assume that Adapter 1 is an internal management network that is not accessible from the outside. Adapter 2 is a public network for user facing services.

1. Install Apache and support for HTTPS.

2. Ensure that the `firewalld` service is running and enabled on your system, and that it has the default configuration.

3. Enable the `internal` zone and allow traffic to SSH, Cockpit and DHCPv6-client services. Assign the `eth0` interface to the `internal` zone. Use the `--permanent` option to make the changes persistent, but don't reload the rules just yet!

4. Enable the `public` zone and allow HTTP and HTTPS traffic. Assign the `eth1` interface to the `public` zone. Use the `--permanent` option again.

5. Reload the firewall rules. Check whether you still have SSH Access (`vagrant ssh`) and that you can access the web server from the host machine by entering the IP address of the VM on the host-only network in a web browser.

