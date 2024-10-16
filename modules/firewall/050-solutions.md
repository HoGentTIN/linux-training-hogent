## solutions: managing firewalls

This lab was executed on an Vagrant VM with an AlmaLinux 9 base box created by the [Bento project](https://github.com/chef/bento). Its IP addresses are:

```console
[vagrant@el ~]$ ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eth0             UP             10.0.2.15/24 fe80::8e2:7ade:5a6f:670f/64 
eth1             UP             192.168.56.11/24 fe80::a00:27ff:fe52:a07/64 
```

In `/var/www/html` there is a simple `index.html` file that contains the text "It works!".

1. Install Apache and support for HTTPS.

    ```console
    [vagrant@el ~]$ sudo dnf install -y httpd mod_ssl
    [vagrant@el ~]$ sudo systemctl enable --now httpd
    Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
    [vagrant@el ~]$ sudo ss -tlnp | grep httpd
    LISTEN 0    511    *:80    *:*    users:(("httpd",pid=7026,fd=4),...)
    LISTEN 0    511    *:443   *:*    users:(("httpd",pid=7026,fd=6),...)
    ```

2. Ensure that the `firewalld` service is running and enabled on your system, and that it has the default configuration.

    ```console
    [vagrant@el ~]$ systemctl status firewalld
    ○ firewalld.service - firewalld - dynamic firewall daemon
        Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; preset: enabled)
        Active: inactive (dead)
        Docs: man:firewalld(1)
    [vagrant@el ~]$ sudo systemctl enable --now firewalld
    Created symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service → /usr/lib/systemd/system/firewalld.service.
    Created symlink /etc/systemd/system/multi-user.target.wants/firewalld.service → /usr/lib/systemd/system/firewalld.service.
    [vagrant@el ~]$ sudo firewall-cmd --list-all
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

3. Check the current rules of the `internal` zone and ensure that only traffic to SSH, Cockpit and DHCPv6-client services is allowed. Assign the `eth0` interface to the `internal` zone. Use the `--permanent` option to make the changes persistent, but don't reload the rules just yet!

    ```console
    [vagrant@el ~]$ sudo firewall-cmd --list-all --zone=internal
    internal
      target: default
      icmp-block-inversion: no
      interfaces: 
      sources: 
      services: cockpit dhcpv6-client mdns samba-client ssh
      ports: 
      protocols: 
      forward: yes
      masquerade: no
      forward-ports: 
      source-ports: 
      icmp-blocks: 
      rich rules: 
    ```

    > Remark that we only have to remove the services that we don't want to allow in the `internal` zone, viz. `mdns` and `samba-client`.

    ```console
    [vagrant@el ~]$ sudo firewall-cmd --permanent --zone=internal --remove-service=mdns
    success
    [vagrant@el ~]$ sudo firewall-cmd --permanent --zone=internal --remove-service=samba-client
    success
    ```

    > Now we can assign the `eth0` interface to the `internal` zone.

    ```console
    [vagrant@el ~]$ sudo firewall-cmd --permanent --zone=internal --add-interface=eth0
    The interface is under control of NetworkManager, setting zone to 'internal'.
    success
    ```

4. Allow *only* HTTP and HTTPS traffic on the `public` zone. Assign the `eth1` interface to the `public` zone. Use the `--permanent` option again.

    ```console
    [vagrant@el ~]$ sudo firewall-cmd --permanent --zone=public --add-service=http
    success
    [vagrant@el ~]$ sudo firewall-cmd --permanent --zone=public --add-service=https
    success
    [vagrant@el ~]$ sudo firewall-cmd --permanent --zone=public --remove-service=ssh
    success
    [vagrant@el ~]$ sudo firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client
    success
    [vagrant@el ~]$ sudo firewall-cmd --permanent --zone=public --remove-service=cockpit
    success
    ```

5. Reload the firewall rules. Check whether you still have SSH Access (`vagrant ssh`) and that you can access the web server from the host machine by entering the IP address of the VM on the host-only network in a web browser.

    ```console
    [vagrant@el ~]$ sudo firewall-cmd --get-active-zones 
    internal
      interfaces: eth0
    public
      interfaces: eth1
    [vagrant@el ~]$ sudo firewall-cmd --list-all --zone=public
    public (active)
      target: default
      icmp-block-inversion: no
      interfaces: eth1
      sources: 
      services: http https
      ports: 
      protocols: 
      forward: yes
      masquerade: no
      forward-ports: 
      source-ports: 
      icmp-blocks: 
      rich rules: 
    [vagrant@el ~]$ sudo firewall-cmd --list-all --zone=internal
    internal (active)
      target: default
      icmp-block-inversion: no
      interfaces: eth0
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

    > At this point, the SSH connection still works, so the rules on the `eth0` interface (that is used for the SSH connection) are working.

    > We try to access the web server from the host machine with `curl` on both http and https. Remark that you can do this in a webbrowser as well!

    ```console
    > curl -i http://192.168.56.11/
    HTTP/1.1 200 OK
    Date: Wed, 16 Oct 2024 18:07:49 GMT
    Server: Apache/2.4.57 (AlmaLinux) OpenSSL/3.0.7
    Last-Modified: Wed, 16 Oct 2024 18:07:46 GMT
    ETag: "56-6249bf26e31d2"
    Accept-Ranges: bytes
    Content-Length: 86
    Content-Type: text/html; charset=UTF-8

    <html>
    <head><title>It works!</title></head>
    <body><h1>It works!</h1></body>
    </html>
    > curl --insecure -i https://192.168.56.11/
    HTTP/1.1 200 OK
    Date: Wed, 16 Oct 2024 18:09:22 GMT
    Server: Apache/2.4.57 (AlmaLinux) OpenSSL/3.0.7
    Last-Modified: Wed, 16 Oct 2024 18:07:46 GMT
    ETag: "56-6249bf26e31d2"
    Accept-Ranges: bytes
    Content-Length: 86
    Content-Type: text/html; charset=UTF-8

    <html>
    <head><title>It works!</title></head>
    <body><h1>It works!</h1></body>
    </html>
    ```

