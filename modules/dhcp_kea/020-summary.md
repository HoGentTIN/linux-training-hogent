ISC DHCP has been de facto the default implementation of DHCP for Linux. Most Linux distributions ship with ISC DHCP as the default DHCP server. However, since the end of 2022, ISC has announced the end of maintenance for the ISC DHCP server.

ISC has developed a new DHCP server, Kea, which should replace ISC DHCP in most cases.

Starting with Enterprise Linux 10, ISC DHCP is no longer available in the repositories. [Red Hat recommends moving to Kea instead](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/9.4_release_notes/deprecated-functionality#deprecated-functionality-infrastructure-services), or to another DHCP server, like `dhcpdcd`.

Learning goals:

- Installing Kea
- Configuring Kea to provide network configuration to clients in a simple local network

