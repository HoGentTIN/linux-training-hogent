## Samba 4 alpha 6

A quick view on Samba 4 alpha 6 (January 2009). You can also follow this
guide http://wiki.samba.org/index.php/Samba4/HOWTO

Remove old Samba from Red Hat

    yum remove samba

set a fix ip address (Red Hat has an easy GUI)

download and untar

    samba.org, click 'download info', choose mirror, dl samba4 latest alpha

once untarred, enter the directory and read the howto4.txt

    cd samba-4.0.0alpha6/

    more howto4.txt

first we have to configure, compile and install samba4

    cd source4/

    ./configure

    make

    make install

Then we can use the provision script to setup our realm. I used
booi.schot as domain name (instead of example.com).

    ./setup/provision --realm=BOOI.SCHOT --domain=BOOI --adminpass=stargate \
    --server-role='domain controller'
        

i added a simple share for testing

    vi /usr/local/samba/etc/smb.conf

then i started samba

    cd /usr/local/samba/sbin/

    ./samba

I tested with smbclient, it works

    smbclient //localhost/test -Uadministrator%stargate

I checked that bind (and bind-chroot) were installed (yes), so copied
the srv records

    cp booi.schot.zone /var/named/chroot/etc/

then appended to named.conf

    cat named.conf >> /var/named/chroot/etc/named.conf

I followed these steps in the howto4.txt

    vi /etc/init.d/named  [added two export lines right after start()]
    chmod a+r /usr/local/samba/private/dns.keytab 
    cp krb5.conf /etc/
    vi /var/named/chroot/etc/named.conf
        --> remove a lot, but keep allow-update { any; };
        

restart bind (named!), then tested dns with dig, this works (stripped
screenshot!)

    [root@linux private]# dig _ldap._tcp.dc._msdcs.booi.schot SRV @localhost

    ; (1 server found)
    ;; global options:  printcmd
    ;; Got answer:
    ;; -HEADER- opcode: QUERY, status: NXDOMAIN, id: 58186
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;_ldap._tcp.dc._msdcs.booi.schot. IN    SRV

    ;; AUTHORITY SECTION:
    .           10800   IN  SOA A.ROOT-SERVERS.NET....

    ;; Query time: 54 msec
    ;; SERVER: 127.0.0.1#53(127.0.0.1)
    ;; WHEN: Tue Jan 27 20:57:05 2009
    ;; MSG SIZE  rcvd: 124

    [root@linux private]# 
        

made sure /etc/resolv.conf points to himself

    [root@linux private]# cat /etc/resolv.conf
    search booi.schot
    nameserver 127.0.0.1
        

start windows 2003 server, enter the samba4 as DNS!

ping the domain, if it doesn\'t work, then add your redhats hostname and
your realm to windows/system32/drivers/etc/hosts

join the windows computer to the domain

reboot the windows

log on with administrator stargate

start run dsa.msc to manage samba4

create an OU, a user and a GPO, test that it works

