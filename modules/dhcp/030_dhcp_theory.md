## four broadcasts

`dhcp` works with layer 2 broadcasts. A dhcp client that starts, will
send a `dhcp discover` on the network. All `dhcp servers` (that have a
lease available) will respond with a `dhcp offer`. The client will
choose one of those offers and will send a `dhcp request` containing the
chosen offer. The `dhcp server` usually responds with a
`dhcp ack`(knowledge).

In wireshark it looks like this.

![](../images/wireshark_dhcp_four_broadcasts.png)

When this procedure is finished, then the client is allowed to use that
ip-configuration until the end of its lease time.

## picturing dhcp

Here we have a small network with two `dhcp servers` named DHCP-SRV1 and
DHCP-SRV2 and two clients (SunWS1 and Mac42). All computers are
connected by a hub or switch (pictured in the middle). All four
computers have a cable to the hub (cables not pictured).

![](../images/dhcp.png)

1\. The client SunWS1 sends a `dhcp discover` on the network. All
computers receive this broadcast.

2\. Both `dhcp servers` answer with a `dhcp offer`. DHCP-SRV1 is a
`dedicated dhcp server` and is faster in sending a `dhcp offer` than
DHCP-SRV2 (who happens to also be a file server).

3\. The client chooses the offer from DHCP-SRV1 and sends a
`dhcp request` on the network.

4\. DHCP-SRV1 answers with a `dhcp ack` (short for acknowledge).

All four broadcasts (or five when you count both offers) can be layer 2
ethernet broadcast to mac address `ff:ff:ff:ff:ff:ff` and a layer 3 ip
broadcast to 255.255.255.255.

The same story can be read in `rfc 2131`.

## installing a dhcp server

dhcp server for Debian/Mint

    debian10:~# aptitude install dhcp3-server
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following NEW packages will be installed:
      dhcp3-server 

You get a configuration file with many examples.

    debian10:~# ls -l /etc/dhcp3/dhcpd.conf 
    -rw-r--r-- 1 root root 3551 2011-04-10 21:23 /etc/dhcp3/dhcpd.conf

## dhcp server for RHEL/CentOS

Installing is easy with `yum`.

    [root@rhel71 ~]# yum install dhcp
    Loaded plugins: product-id, subscription-manager
    Resolving Dependencies
    --> Running transaction check
    ---> Package dhcp.x86_64 12:4.2.5-36.el7 will be installed
    --> Finished Dependency Resolution

    Dependencies Resolved

    ================================================================================
     Package    Arch         Version                 Repository                Size
    ================================================================================
    Installing:
     dhcp       x86_64       12:4.2.5-36.el7         rhel-7-server-rpms       510 k

    Transaction Summary
    ================================================================================
    Install  1 Package

    Total download size: 510 k
    Installed size: 1.4 M
    Is this ok [y/d/N]: y
    Downloading packages:
    dhcp-4.2.5-36.el7.x86_64.rpm                               | 510 kB   00:01
    Running transaction check
    Running transaction test
    Transaction test succeeded
    Running transaction
      Installing : 12:dhcp-4.2.5-36.el7.x86_64                                  1/1
      Verifying  : 12:dhcp-4.2.5-36.el7.x86_64                                  1/1

    Installed:
      dhcp.x86_64 12:4.2.5-36.el7

    Complete!
    [root@rhel71 ~]#

After installing we get a `/etc/dhcp/dhcpd.conf` that points us to an
example file named `dhcpd.conf.sample`.

    [root@rhel71 ~]# cat /etc/dhcp/dhcpd.conf
    #
    # DHCP Server Configuration file.
    #   see /usr/share/doc/dhcp*/dhcpd.conf.example
    #   see dhcpd.conf(5) man page
    #
    [root@rhel71 ~]#

So we copy the sample and adjust it for our real situation. We name the
copy `/etc/dhcp/dhcpd.conf`.

    [root@rhel71 ~]# cp /usr/share/doc/dhcp-4.2.5/dhcpd.conf.example /etc/dhcp/dhcp\
    d.conf
    [root@rhel71 ~]# vi /etc/dhcp/dhcpd.conf
    [root@rhel71 ~]# cat /etc/dhcp/dhcpd.conf
    option domain-name "linux-training.be";
    option domain-name-servers 10.42.42.42;
    default-lease-time 600;
    max-lease-time 7200;
    log-facility local7;

    subnet 10.42.0.0 netmask 255.255.0.0 {
      range 10.42.200.11 10.42.200.120;
      option routers 10.42.200.1;
    }
    [root@rhel71 ~]#

The \'routers\' option is valid for the subnet alone, whereas the
\'domain-name\' option is global (for all subnets).

Time to start the server. Remember to use `systemctl start dhcpd` on
RHEL7/CentOS8 and `service dhcpd start` on previous versions of
RHEL/CentOS.

    [root@rhel71 ~]# systemctl start dhcpd
    [root@rhel71 ~]#

## client reservations

You can reserve an ip configuration for a client using the mac address.

    host pc42 {
    hardware ethernet 11:22:33:44:55:66;
    fixed-address 192.168.42.42;
    }

You can add individual options to this reservation.

    host pc42 {
    hardware ethernet 11:22:33:44:55:66;
    fixed-address 192.168.42.42;
    option domain-name "linux-training.be";
    option routers 192.168.42.1;
    }

## example config files

Below you see several sections of `/etc/dhcp/dhcpd.conf` on a `Debian 6`
server.

    # NetSec Antwerp Network
    subnet 192.168.1.0 netmask 255.255.255.0 {
     range 192.168.1.20 192.168.1.199;
     option domain-name-servers ns1.netsec.local;
     option domain-name "netsec.local";
     option routers 192.168.1.1;
     option broadcast-address 192.168.1.255;
     default-lease-time 7200;
     max-lease-time 7200;
    }

Above the general configuration for the network, with a pool of 180
addresses.

Below two client reservations:

    #
    # laptops
    #

    host mac {
      hardware ethernet 00:26:bb:xx:xx:xx;
      fixed-address mac.netsec.local;
    }

    host vmac {
      hardware ethernet 8c:7b:9d:xx:xx:xx;
      fixed-address vmac.netsec.local;
    }

## older example config files

For dhcpd.conf on Fedora with dynamic updates for a DNS domain.

    [root@fedora14 ~]# cat /etc/dhcp/dhcpd.conf 
    authoritative;
    include "/etc/rndc.key";

    log-facility local6;

    server-identifier       fedora14;
    ddns-domainname     "office.linux-training.be";
    ddns-update-style   interim;
    ddns-updates        on;
    update-static-leases    on;

    option domain-name  "office.linux-training.be";
    option domain-name-servers  192.168.42.100;
    option ip-forwarding    off;

    default-lease-time  1800;
    max-lease-time      3600;

    zone office.linux-training.be {
        primary 192.168.42.100;
    }

    subnet 192.168.4.0 netmask 255.255.255.0 {
        range 192.168.4.24 192.168.4.40;
    }

Allowing any updates in the zone database (part of the named.conf
configuration)

    zone "office.linux-training.be" {
        type master;
        file "/var/named/db.office.linux-training.be";
        allow-transfer { any; };
        allow-update { any; };
    };

Allowing secure key updates in the zone database (part of the named.conf
configuration)

    zone "office.linux-training.be" {
        type master;
        file "/var/named/db.office.linux-training.be";
        allow-transfer { any; };
        allow-update { key mykey; };
    };

Sample key file contents:

    [root@fedora14 ~]# cat /etc/rndc.key 
    key "rndc-key" {
        algorithm hmac-md5;
        secret "4Ykd58uIeUr3Ve6ad1qTfQ==";
    };

Generate your own keys with `dnssec-keygen`.

How to include a key in a config file:

    include "/etc/bind/rndc.key";

Also make sure that `bind` can write to your db.zone file (using
chmod/chown). For Ubuntu this can be in /etc/bind, for Fedora in
/var/named.

## advanced dhcp

### 80/20 rule

DHCP servers should not be a single point of failure. Let us discuss
redundant dhcp server setups.

### relay agent

To avoid having to place a dhcp server on every segment, we can use
`dhcp relay agents`.

### rogue dhcp servers

Rogue dhcp servers are a problem without a solution. For example
accidental connection of a (believed to be simple) hub/switch to a
network with an internal dhcp server.

### dhcp and ddns

DHCP can dynamically update DNS when it configures a client computer.
DDNS can be used with or without secure keys.

When set up properly records can be added automaticall to the zone file:

    root@fedora14~# tail -2 /var/named/db.office.linux-training.be
    ubu1010srv         A     192.168.42.151
                       TXT   "00dfbb15e144a273c3cf2d6ae933885782"

