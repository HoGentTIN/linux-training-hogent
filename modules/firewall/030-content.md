## starting the firewall

The state of `firewalld` is managed with `systemctl`:

```console
[student@el ~]$ systemctl status firewalld
○ firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; preset: enabled)
     Active: inactive (dead)
       Docs: man:firewalld(1)
[student@el ~]$ sudo systemctl enable --now firewalld
Created symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service → /usr/lib/systemd/system/firewalld.service.
Created symlink /etc/systemd/system/multi-user.target.wants/firewalld.service → /usr/lib/systemd/system/firewalld.service.
[student@el ~]$ systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; preset: enabled)
     Active: active (running) since Wed 2024-10-16 16:16:16 UTC; 4s ago
       Docs: man:firewalld(1)
   Main PID: 6679 (firewalld)
      Tasks: 2 (limit: 11128)
     Memory: 28.9M
        CPU: 191ms
     CGroup: /system.slice/firewalld.service
             └─6679 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid

Oct 16 16:16:16 el systemd[1]: Starting firewalld - dynamic firewall daemon...
Oct 16 16:16:16 el systemd[1]: Started firewalld - dynamic firewall daemon.
```

To list current firewall rules, use `firewall-cmd`. All `firewall-cmd` commands require superuser privileges, so use `sudo`, even to list rules:

```console
[student@el ~]$ firewall-cmd --list-all
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
[student@el ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0 eth1
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

Let's analyse the output. We give a short overview and will elaborate on the details in the following sections:

- `public` is the name of the active *zone*. A *zone* is a list of rules that can be used in a specific context.
- `interfaces` lists the *network interfaces* that the rules apply to, in this case, `eth0` and `eth1`.
- `services` lists the *services* that are allowed through the firewall, in this case, `cockpit`, `dhcpv6-client`, and `ssh`.
- `ports` lists the *ports* that are allowed through the firewall (apart from the listed services). In this case, no ports are specified.
- `masquerade` can be turned on to allow *NAT* (Network Address Translation) for the listed interfaces.

Other options are not set in this example.

## zones

In the configuration of `firewalld`, a **zone** is a list of rules that applies to a specific situation. For example, if you run Linux on your laptop, you could define a zone for home, where you can share your music library over the local network, and a zone for public places where you don't allow any incoming network traffic.

For a server in a datacenter, you could define a zone for the public network where you allow traffic to the user facing services (e.g. https) and a zone for the internal management network where you allow traffic to the SSH port.

The pre-defined zones in `firewalld` can be listed with the `--get-zones` option:

```console
[student@el ~]$ firewall-cmd --get-zones
block dmz drop external home internal nm-shared public trusted work
```

The default zone is called `public`, and it is active by default. When you issue a command without specifying a zone, the `public` zone is implied.

```console

[student@el ~]$ firewall-cmd --get-active-zones
public
  interfaces: eth0 eth1
```

As you can see, zones are associated with network interfaces. In this case, the `public` zone is applied to all traffic on interfaces `eth0` and `eth1`.

## services

`firewalld` uses the concept of **services** to group rules for specific network services. For example, the `ssh` service allows traffic on port 22. The `http` service allows traffic on port 80, and the `https` service allows traffic on port 443.

A list with dozens of predefined services can be obtained with the `--get-services` option:

```console
[student@el ~]$ firewall-cmd --get-services
RH-Satellite-6 RH-Satellite-6-capsule afp amanda-client amanda-k5-client amqp amqps apcupsd audit ausweisapp2 bacula bacula-client bareos-director bareos-filedaemon bareos-storage bb bgp bitcoin bitcoin-rpc bitcoin-testnet bitcoin-testnet-rpc bittorrent-lsd ceph ceph-exporter ceph-mon cfengine checkmk-agent cockpit collectd condor-collector cratedb ctdb dds dds-multicast dds-unicast dhcp dhcpv6 dhcpv6-client distcc dns dns-over-tls docker-registry
[... some output omitted ...] 
xmpp-bosh xmpp-client xmpp-local xmpp-server zabbix-agent zabbix-server zerotier
```

Some services are allowed by default in the `public` zone. You can list the services that are allowed in the active zone with the `--list-services` option:

```console
[student@el ~]$ sudo firewall-cmd --list-services
cockpit dhcpv6-client ssh
```

- *Cockpit* is a webinterface for server management and monitoring that listens on port 9090.
- *DHCPv6-client* allows a DHCP for IPv6 client to receive an address and other settings from a DHCPv6 server.
- *SSH* or Secure SHell is a protocol for logging into a remote machine and executing commands.

If you want to know which ports are associated with a service, you can use the `--info-service` option:

```console
[student@el ~]$ sudo firewall-cmd --info-service=dhcpv6-client 
dhcpv6-client
  ports: 546/udp
  protocols: 
  source-ports: 
  modules: 
  destination: ipv6:fe80::/64
  includes: 
  helpers:
```

Let's add some rules for allowing traffic to a web server:

```console
[student@el ~]$ sudo firewall-cmd --add-service=http
success
[student@el ~]$ sudo firewall-cmd --add-service=https
success
[student@el ~]$ sudo firewall-cmd --list-services 
cockpit dhcpv6-client http https ssh
```

Remark that since we didn't specify a zone, the rules are added to the `public` zone.

From now on, a web server running on this machine will be accessible from the network.

Unfortunately, this setting is not persistent. If you reboot the machine, or reload the firewall settings, the rules will be lost. To make the rules persistent, use the `--permanent` option and reload the rules:

```console
[student@el ~]$ sudo firewall-cmd --add-service=http --permanent
success
[student@el ~]$ sudo firewall-cmd --add-service=https --permanent
success
[student@el ~]$ sudo firewall-cmd --reload 
success
[student@el ~]$ sudo firewall-cmd --list-services 
cockpit dhcpv6-client http https ssh
```

## ports

If there's no predefined service available for the type of traffic you want to allow, you can use the `--add-port` option to allow traffic on a specific port. For example, to allow TCP traffic on port 8080:

```console
[student@el ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
[student@el ~]$ sudo firewall-cmd --reload 
[student@el ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0 eth1
  sources: 
  services: cockpit dhcpv6-client http https ssh
  ports: 8080/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

**Remark** that you could also use the `--add-port` option to allow traffic on a ports 80 and 443. However, we already added the `http` and `https` services, which are associated with these ports. The `--add-port` option is only useful when you want to allow traffic on a port that is not associated with a predefined service.

## assigning interfaces to zones

As mentioned earlier, zones are associated with network interfaces. You can add or remove interfaces from a zone with `--add-interface` and `--remove-interface`:

```console
[student@el ~]$ sudo firewall-cmd --remove-interface=eth1 --zone=public
success
[student@el ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0
  sources: 
  services: cockpit dhcpv6-client http https ssh
  ports: 8080/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

In this example, we removed `eth1` from the `public` zone. The `eth1` interface is now unmanaged by `firewalld`.

## panic mode

If a system seems to be under attack, you can block all traffic with the `--panic-on` option:

```console
[student@el ~]$ sudo firewall-cmd --panic-on

```

Hmmm, we don't get our prompt back. We were logged in to this system over SSH, but now we can't reach it anymore! We have to log in on a physical console to disable panic mode:

```console
[student@el ~]$ sudo firewall-cmd --panic-off
```

After this, the SSH connection becomes available again. So be careful with this option or you may lose access to a remote machine!

