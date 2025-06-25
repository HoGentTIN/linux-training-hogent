## installing isc kea on enterprise linux

On EL 10 (released in 2025), ISC Kea is available in the default repositories as package `kea`. In EL 9, it isn't available yet, but you can install it from the EPEL (Extra Packages for Enterprise Linux) repository. To activate the repository, run:

```bash
sudo dnf install epel-release
```

Then, you can install Kea with:

```bash
sudo dnf install kea
```

The configuration files are located in `/etc/kea/`:

```console
[vagrant@el ~]$ tree /etc/kea/
/etc/kea/
├── kea-ctrl-agent.conf
├── keactrl.conf
├── kea-dhcp4.conf
├── kea-dhcp6.conf
└── kea-dhcp-ddns.conf

0 directories, 5 files
```

The contents of the configuration files are in JSON format (with comments). Examples of configuration files for several different use cases can be found in `/usr/share/doc/kea/examples/`.

## configuring kea for a simple local network

The default configuration file contains a lot of comments and examples that are not needed for a simple local network. We suggest that you put it aside and start with the contents of `/usr/share/doc/kea/examples/kea4/single-subnet.json`.

```console
[vagrant@kea-el ~]$ sudo cp /etc/kea/kea-dhcp4.conf /usr/share/doc/kea/kea-dhcp4.conf.rpmnew
[vagrant@kea-el ~]$ sudo cp /usr/share/doc/kea/examples/kea4/single-subnet.json /etc/kea/kea-dhcp4.conf 
```

Then, edit `/etc/kea/kea-dhcp4.conf` to adjust the configuration to your network. In the example setup below, the local network has the following properties:

- The network IP is *192.168.42.0/24*
- The Kea server has IP *192.168.42.254* on network interface `eth1`
- The default gateway is *192.168.42.254* (i.e. the host running Kea is also acting as the default gateway)
- The DNS server is *10.0.2.3*
- Clients will receive an IP address in the range 192.168.42.101-252

The configuration file should look like this:

```json
// Kea DHCPv4 configuration for a single subnet
{ "Dhcp4":

{
// Kea is told to only listen on eth1
  "interfaces-config": {
    "interfaces": [ "eth1" ]
  },

// Leases will be kept in memory.
  "lease-database": {
      "type": "memfile",
      "lfc-interval": 3600
  },

// Addresses will be assigned with a default lease time of 8 hours,
// minimal lease time of 4 hours and maximum 10 hours.
  "valid-lifetime":     28800,
  "min-valid-lifetime": 14400,
  "max-valid-lifetime": 36000,

// Subnet declaration for the LAN
  "subnet4": [
    {
       "pools": [ { "pool":  "192.168.42.101 - 192.168.42.252" } ],
       "subnet": "192.168.42.0/24",
       "interface": "eth1",
       "option-data": [
         {
           "name": "domain-name-servers",
           "data": "10.0.2.3"
         },
         {
           "name": "routers",
           "data": "192.168.42.254"
         }
       ]
    }
  ],


// Logging configuration. Messages with at least informational level (info,
// warn, error and fatal) are logged to syslog.
    "loggers": [
        {
            "name": "kea-dhcp4",
            "output_options": [
                {
                    "output": "syslog"
                }
            ],
            "severity": "INFO"
        }
    ]
}

}
```

After editing the configuration file, be sure to first check the syntax with `kea-dhcp4 -t`. In the example below, we get a warning about extraneous commas (which is easily fixed), but the configuration is otherwise correct:

```bash
[vagrant@kea-el ~]$ kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
2024-11-24 14:26:17.056 WARN  [kea-dhcp4.dhcp4/5824.140563970693248] DHCP4_CONFIG_SYNTAX_WARNING configuration syntax warning: /etc/kea/kea-dhcp4.conf:38.30: Extraneous comma. A piece of configuration may have been omitted.
2024-11-24 14:26:17.056 WARN  [kea-dhcp4.dhcp4/5824.140563970693248] DHCP4_CONFIG_SYNTAX_WARNING configuration syntax warning: /etc/kea/kea-dhcp4.conf:42.36: Extraneous comma. A piece of configuration may have been omitted.
2024-11-24 14:26:17.057 INFO  [kea-dhcp4.hosts/5824.140563970693248] HOSTS_BACKENDS_REGISTERED the following host backend types are available: mysql postgresql 
2024-11-24 14:26:17.059 INFO  [kea-dhcp4.dhcpsrv/5824.140563970693248] DHCPSRV_CFGMGR_ADD_IFACE listening on interface eth1
2024-11-24 14:26:17.060 INFO  [kea-dhcp4.dhcpsrv/5824.140563970693248] DHCPSRV_CFGMGR_SOCKET_TYPE_DEFAULT "dhcp-socket-type" not specified , using default socket type raw
2024-11-24 14:26:17.061 INFO  [kea-dhcp4.dhcpsrv/5824.140563970693248] DHCPSRV_CFGMGR_NEW_SUBNET4 a new subnet has been added to configuration: 192.168.42.0/24 with params: valid-lifetime=28800
```

If the syntax check is successful, you can start the Kea DHCP server with `systemctl start` or `systemctl enable --now`.

```console
[vagrant@kea-el ~]$ sudo systemctl enable --now kea-dhcp4
Created symlink /etc/systemd/system/multi-user.target.wants/kea-dhcp4.service → /usr/lib/systemd/system/kea-dhcp4.service.
```

Check with `systemctl status` and `sudo ss -ulnp` if the service is running and listening on the correct port (67) and interface (`eth1`).

```console
[vagrant@kea-el ~]$ systemctl status kea-dhcp4.service 
● kea-dhcp4.service - Kea DHCPv4 Server
     Loaded: loaded (/usr/lib/systemd/system/kea-dhcp4.service; enabled; preset: disabled)
     Active: active (running) since Sun 2024-11-24 14:35:58 UTC; 51min ago
       Docs: man:kea-dhcp4(8)
   Main PID: 6065 (kea-dhcp4)
      Tasks: 5 (limit: 11128)
     Memory: 2.1M
        CPU: 257ms
     CGroup: /system.slice/kea-dhcp4.service
             └─6065 /usr/sbin/kea-dhcp4 -c /etc/kea/kea-dhcp4.conf
[vagrant@kea-el ~]$ sudo ss -uln | grep ':67'
UNCONN 0      0      192.168.42.254:67        0.0.0.0:* 
```

Finally, you can test the DHCP server by connecting a client to the network and checking if it receives an IP address. Follow the logs with `journalctl -flu kea-dhcp4 -f` to observe the interaction between a client and the Kea service. Optionally, you can also use `tcpdump` to see the DHCP packets.

```console
[vagrant@kea-el ~]$ sudo tcpdump -w kea-dhcp.pcap -v -n -i eth1 port 67 or port 68
dropped privs to tcpdump
tcpdump: listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
4 packets captured
4 packets received by filter
0 packets dropped by kernel
```

Cancel the `tcpdump` command with `Ctrl-C` after you've seen the four packets. Afterwards, open the file with `wireshark` or use `tcpdump` to print the contents:

```console
[vagrant@kea-el ~]$ tcpdump -r /vagrant/kea-dhcp.pcap -ne#
reading from file /vagrant/kea-dhcp.pcap, link-type EN10MB (Ethernet), snapshot length 262144
    1  15:31:59.764913 08:00:27:78:d1:ec > Broadcast, ethertype IPv4 (0x0800), length 329: 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP, Request from 08:00:27:78:d1:ec, length 287
    2  15:31:59.765589 08:00:27:aa:8c:22 > 08:00:27:78:d1:ec, ethertype IPv4 (0x0800), length 336: 192.168.42.254.bootps > 192.168.42.101.bootpc: BOOTP/DHCP, Reply, length 294
    3  15:31:59.766029 08:00:27:78:d1:ec > Broadcast, ethertype IPv4 (0x0800), length 341: 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP, Request from 08:00:27:78:d1:ec, length 299
    4  15:31:59.766198 08:00:27:aa:8c:22 > 08:00:27:78:d1:ec, ethertype IPv4 (0x0800), length 336: 192.168.42.254.bootps > 192.168.42.101.bootpc: BOOTP/DHCP, Reply, length 294
```

The first packet is the *dhcp discover* from the client, the second packet is the *dhcp offer* from the server, the third packet is the *dhcp request* from the client, and the fourth packet is the *dhcp ack* from the server. You can see more details when you open the file in `wireshark`.

In this example, the host with mac address `08:00:27:78:d1:ec` received the reserved ip address 192.168.42.101.

