## solutions: DHCP server with ISC Kea

An implementation of this exercise can be found at <https://github.com/HoGentTIN/linux-training-labs/tree/main/kea>

1. Set up the Enterprise Linux VM (e.g. AlmaLinux 10). Enable routing on the machine and NAT address translation so it can provide Internet access to client machines on the network.

    > Perform the following commands as root.

    ```bash
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p
    firewall-cmd --zone=external --change-interface=enp0s3 --permanent
    firewall-cmd --zone=internal --change-interface=enp0s8 --permanent
    firewall-cmd --reload
    ```

    > Check the network settings:

    ```console
    vagrant@kea-el:~$ ip -br a
    lo      UNKNOWN  127.0.0.1/8 ::1/128 
    enp0s3  UP       10.0.2.15/24 fd17:625c:f037:2:a00:27ff:fe43:cbc1/64 fe80::a00:27ff:fe43:cbc1/64 
    enp0s8  UP       192.168.42.254/24 fe80::1af6:e3ad:a03b:7523/64
    vagrant@kea-el:~$ cat /proc/sys/net/ipv4/ip_forward
    1
    vagrant@kea-el:~$ sudo firewall-cmd --get-active-zones 
    external
      interfaces: enp0s3
    internal
      interfaces: enp0s8
    public (default) 
    vagrant@kea-el:~$ sudo firewall-cmd --zone=external --query-masquerade 
    yes
    ```

2. Install Kea and copy an appropriate example configuration file to `/etc/kea`. Back up the original configuration file first.

    > Perform the following commands as root:
    
    ```bash
    dnf install kea kea-doc
    cp /etc/kea/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf.rpmnew
    cp /usr/share/doc/kea/examples/kea4/single-subnet.json /etc/kea/kea-dhcp4.conf
    ```

3. Add a subnet declaration for the 192.168.42.0/24 network. Specify a range (100-252) and set this VM as the default gateway.

    > The complete configuration file follows in step 4.

4. Update the options for this subnet. Set 10.0.2.3 as the global DNS server, *linux-training.be* as the domain name, default lease time of 2 hours and maximum lease time of 4 hours.

    ```json
    { "Dhcp4":
    {
        "interfaces-config": {
            "interfaces": [ "enp0s8" ]
        },

        // We need to specify the database used to store leases. 
        // We'll use memfile because it doesn't require any prior set up.
        "lease-database": {
            "type": "memfile",
            "lfc-interval": 3600
        },

        // Addresses will be assigned with a lifetime of 4000 seconds.
        "valid-lifetime": 4000,

        // The following list defines subnets. We have only one subnet
        // here. We tell Kea that it is directly available over local interface.
        "subnet4": [
            {
                "pools": [ { "pool":  "192.168.42.100 - 192.168.42.252" } ],
                "id": 1,
                "subnet": "192.168.42.0/24",
                "interface": "enp0s8",
                "valid-lifetime": 7200,
                "max-valid-lifetime": 14400,
                "option-data": [
                    {
                        "name": "domain-name",
                        "data": "linux-training.be"
                    },
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

        // The following configures logging. It assumes that messages with at
        // least informational level (info, warn, error and fatal) should be
        // logged to stdout. Alternatively, you can specify stderr here, a filename
        // or 'syslog', which will store output messages via syslog.
        "loggers": [
            {
                "name": "kea-dhcp4",
                "output-options": [
                    {
                    "output": "stdout"
                    }
                ],
                "severity": "INFO"
            }
        ]
    }
    }
    ```

5. Check the configuration file syntax and start the service. Check that the service is listening on the appropriate NIC and port.

    ```console
    vagrant@kea-el:~$ sudo kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
    2025-08-13 14:41:39.301 INFO  [kea-dhcp4.hosts/6564.139635720923328] HOSTS_BACKENDS_REGISTERED the following host backend types are available: mysql postgresql 
    2025-08-13 14:41:39.301 WARN  [kea-dhcp4.dhcpsrv/6564.139635720923328] DHCPSRV_MT_DISABLED_QUEUE_CONTROL disabling dhcp queue control when multi-threading is enabled.
    2025-08-13 14:41:39.301 WARN  [kea-dhcp4.dhcp4/6564.139635720923328] DHCP4_RESERVATIONS_LOOKUP_FIRST_ENABLED Multi-threading is enabled and host reservations lookup is always performed first.
    2025-08-13 14:41:39.301 INFO  [kea-dhcp4.dhcpsrv/6564.139635720923328] DHCPSRV_CFGMGR_NEW_SUBNET4 a new subnet has been added to configuration: 192.168.42.0/24 with params: valid-lifetime=7200
    2025-08-13 14:41:39.302 INFO  [kea-dhcp4.dhcpsrv/6564.139635720923328] DHCPSRV_CFGMGR_SOCKET_TYPE_SELECT using socket type raw
    2025-08-13 14:41:39.302 INFO  [kea-dhcp4.dhcpsrv/6564.139635720923328] DHCPSRV_CFGMGR_ADD_IFACE listening on interface enp0s8
    2025-08-13 14:41:39.302 INFO  [kea-dhcp4.dhcpsrv/6564.139635720923328] DHCPSRV_CFGMGR_SOCKET_TYPE_DEFAULT "dhcp-socket-type" not specified , using default socket type raw
    vagrant@kea-el:~$ sudo systemctl enable --now kea-dhcp4
    Created symlink '/etc/systemd/system/multi-user.target.wants/kea-dhcp4.service' → '/usr/lib/systemd/system/kea-dhcp4.service'.
    vagrant@kea-el:~$ systemctl status kea-dhcp4
    ● kea-dhcp4.service - Kea DHCPv4 Server
         Loaded: loaded (/usr/lib/systemd/system/kea-dhcp4.service; enabled; preset: disabled)
         Active: active (running) since Wed 2025-08-13 14:23:30 UTC; 19min ago
     Invocation: 1bc367b61aa34cafb2550850dcc963b5
           Docs: man:kea-dhcp4(8)
       Main PID: 6455 (kea-dhcp4)
          Tasks: 7 (limit: 18764)
         Memory: 2.5M (peak: 5.9M)
            CPU: 126ms
         CGroup: /system.slice/kea-dhcp4.service
                 └─6455 /usr/sbin/kea-dhcp4 -c /etc/kea/kea-dhcp4.conf
    vagrant@kea-el:~$ sudo ss -ulnp | grep :67
    UNCONN 0      0      192.168.42.254:67        0.0.0.0:*    users:(("kea-dhcp4",pid=6455,fd=11))
    ```

6. Start tcpdump to listen for DHCP requests on the host-only interface.

    > See the example of using `tcpdump` in the previous sections.

7. Attach a client VM (e.g. a Kali Linux VM) to the host-only network and start it. Check if the client gets an IP address from the DHCP server, and that the gateway and DNS server are set correctly.

    > On the server, we follow the system logs and see that a client:

    ```console
    Aug 13 14:23:38 kea-el kea-dhcp4[6455]: 2025-08-13 14:23:38.851 INFO  [kea-dhcp4.dhcp4/6455.139934786459328] DHCP4_QUERY_LABEL received query: [hwtype=1 08:00:27:4d:16:e9], cid=[01:08:00:27:4d:16:e9], tid=0x3f082956
    Aug 13 14:23:38 kea-el kea-dhcp4[6455]: 2025-08-13 14:23:38.851 INFO  [kea-dhcp4.packets/6455.139934786459328] DHCP4_PACKET_RECEIVED [hwtype=1 08:00:27:4d:16:e9], cid=[01:08:00:27:4d:16:e9], tid=0x3f082956: DHCPDISCOVER (type 1) received from 0.0.0.0 to 255.255.255.255 on interface enp0s8
    Aug 13 14:23:38 kea-el kea-dhcp4[6455]: 2025-08-13 14:23:38.852 INFO  [kea-dhcp4.leases/6455.139934786459328] DHCP4_LEASE_OFFER [hwtype=1 08:00:27:4d:16:e9], cid=[01:08:00:27:4d:16:e9], tid=0x3f082956: lease 192.168.42.100 will be offered
    Aug 13 14:23:38 kea-el kea-dhcp4[6455]: 2025-08-13 14:23:38.852 INFO  [kea-dhcp4.packets/6455.139934786459328] DHCP4_PACKET_SEND [hwtype=1 08:00:27:4d:16:e9], cid=[01:08:00:27:4d:16:e9], tid=0x3f082956: trying to send packet DHCPOFFER (type 2) from 192.168.42.254:67 to 192.168.42.100:68 on interface enp0s8
    Aug 13 14:23:38 kea-el kea-dhcp4[6455]: 2025-08-13 14:23:38.855 INFO  [kea-dhcp4.dhcp4/6455.139934778066624] DHCP4_QUERY_LABEL received query: [hwtype=1 08:00:27:4d:16:e9], cid=[01:08:00:27:4d:16:e9], tid=0x3f082956
    Aug 13 14:23:38 kea-el kea-dhcp4[6455]: 2025-08-13 14:23:38.855 INFO  [kea-dhcp4.packets/6455.139934778066624] DHCP4_PACKET_RECEIVED [hwtype=1 08:00:27:4d:16:e9], cid=[01:08:00:27:4d:16:e9], tid=0x3f082956: DHCPREQUEST (type 3) received from 0.0.0.0 to 255.255.255.255 on interface enp0s8
    Aug 13 14:23:38 kea-el kea-dhcp4[6455]: 2025-08-13 14:23:38.856 INFO  [kea-dhcp4.leases/6455.139934778066624] DHCP4_LEASE_ALLOC [hwtype=1 08:00:27:4d:16:e9], cid=[01:08:00:27:4d:16:e9], tid=0x3f082956: lease 192.168.42.100 has been allocated for 7200 seconds
    Aug 13 14:23:38 kea-el kea-dhcp4[6455]: 2025-08-13 14:23:38.856 INFO  [kea-dhcp4.packets/6455.139934778066624] DHCP4_PACKET_SEND [hwtype=1 08:00:27:4d:16:e9], cid=[01:08:00:27:4d:16:e9], tid=0x3f082956: trying to send packet DHCPACK (type 5) from 192.168.42.254:67 to 192.168.42.100:68 on interface enp0s8
    ```

    > On the client, we check the IP config:

    ```console
    ┌──(kali@kali)-[~]
    └─$ ip a show dev eth1
    3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether 08:00:27:4d:16:e9 brd ff:ff:ff:ff:ff:ff
        inet 192.168.42.100/24 brd 192.168.42.255 scope global dynamic noprefixroute eth1
        valid_lft 6954sec preferred_lft 6954sec
        inet6 fe80::81b4:b70a:c98a:bd5c/64 scope link noprefixroute 
        valid_lft forever preferred_lft forever
    ┌──(kali@kali)-[~]
    └─$ ip r                 
    default via 192.168.42.254 dev eth1 proto dhcp src 192.168.42.100 metric 101 
    192.168.42.0/24 dev eth1 proto kernel scope link src 192.168.42.100 metric 101
    ┌──(kali@kali)-[~]
    └─$ cat /etc/resolv.conf                                   
    # Generated by NetworkManager
    search linux-training.be
    nameserver 10.0.2.3
    ```

8. From the client VM, ping the default gateway/dhcp server on both interfaces (192.168.42.254 and 10.0.2.15), the DNS server 10.0.2.3 and the dhcp server's external gateway 10.0.2.2. Use `dig` to test that name resolution works. Access a website from the client VM to verify that Internet access is working.

9. Add a client reservation the client VM. Find the MAC address and assign a fixed IP address to it. Give it a longer default and maximum lease time than the global settings (e.g. 4 and 10 hours, respectively). Restart the dhcp server and re-attach the client VM to the network. Check if the client gets the reserved IP address and can access the internet.

