# introduction to iptables

## iptables firewall

The Linux kernel has a built-in stateful firewall named `iptables`. To
stop the `iptables` firewall on Red Hat, use the service
command.

    root@linux:~# service iptables stop
    Flushing firewall rules:                                   [  OK  ]
    Setting chains to policy ACCEPT: filter                    [  OK  ]
    Unloading iptables modules:                                [  OK  ]
    root@linux:~# 
            

The easy way to configure iptables, is to use a graphical tool like
KDE's `kmyfirewall` or
`Security Level Configuration Tool`. You can find the latter in the
graphical menu, somewhere in System Tools - Security, or you can start
it by typing `system-config-securitylevel` in bash. These
tools allow for some basic firewall configuration. You can decide
whether to enable or disable the firewall, and what typical standard
ports are allowed when the firewall is active. You can even add some
custom ports. When you are done, the configuration is written to
`/etc/sysconfig/iptables` on Red Hat.

    root@linux:~# cat /etc/sysconfig/iptables
    # Firewall configuration written by system-config-securitylevel
    # Manual customization of this file is not recommended.
    *filter
    :INPUT ACCEPT [0:0]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    :RH-Firewall-1-INPUT - [0:0]
    -A INPUT -j RH-Firewall-1-INPUT
    -A FORWARD -j RH-Firewall-1-INPUT
    -A RH-Firewall-1-INPUT -i lo -j ACCEPT
    -A RH-Firewall-1-INPUT -p icmp --icmp-type any -j ACCEPT
    -A RH-Firewall-1-INPUT -p 50 -j ACCEPT
    -A RH-Firewall-1-INPUT -p 51 -j ACCEPT
    -A RH-Firewall-1-INPUT -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT
    -A RH-Firewall-1-INPUT -p udp -m udp --dport 631 -j ACCEPT
    -A RH-Firewall-1-INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    -A RH-F...NPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
    -A RH-F...NPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
    -A RH-F...NPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT
    -A RH-F...NPUT -m state --state NEW -m tcp -p tcp --dport 25 -j ACCEPT
    -A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited
    COMMIT
    root@linux:~#
            

To start the service, issue the `service iptables start`
command. You can configure iptables to start at boot time with
chkconfig.

    root@linux:~# service iptables start
    Applying iptables firewall rules:                          [  OK  ]
    root@linux:~# chkconfig iptables on
    root@linux:~# 
            

One of the nice features of iptables is that it displays extensive
`status` information when queried with the `service iptables status`
command.

    root@linux:~# service iptables status
    Table: filter
    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    RH-Firewall-1-INPUT  all  --  0.0.0.0/0            0.0.0.0/0           
                    
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination         
    RH-Firewall-1-INPUT  all  --  0.0.0.0/0            0.0.0.0/0           

    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         
                    
    Chain RH-Firewall-1-INPUT (2 references)
    target  prot opt source      destination  
    ACCEPT  all  --  0.0.0.0/0   0.0.0.0/0 
    ACCEPT  icmp --  0.0.0.0/0   0.0.0.0/0   icmp type 255 
    ACCEPT  esp  --  0.0.0.0/0   0.0.0.0/0 
    ACCEPT  ah   --  0.0.0.0/0   0.0.0.0/0    
    ACCEPT  udp  --  0.0.0.0/0   224.0.0.251 udp dpt:5353 
    ACCEPT  udp  --  0.0.0.0/0   0.0.0.0/0   udp dpt:631 
    ACCEPT  all  --  0.0.0.0/0   0.0.0.0/0   state RELATED,ESTABLISHED 
    ACCEPT  tcp  --  0.0.0.0/0   0.0.0.0/0   state NEW tcp dpt:22 
    ACCEPT  tcp  --  0.0.0.0/0   0.0.0.0/0   state NEW tcp dpt:80 
    ACCEPT  tcp  --  0.0.0.0/0   0.0.0.0/0   state NEW tcp dpt:21 
    ACCEPT  tcp  --  0.0.0.0/0   0.0.0.0/0   state NEW tcp dpt:25 
    REJECT  all  --  0.0.0.0/0   0.0.0.0/0   reject-with icmp-host-prohibited 

    root@linux:~# 
            

Mastering firewall configuration requires a decent knowledge of tcp/ip.
Good iptables tutorials can be found online here
http://iptables-tutorial.frozentux.net/iptables-tutorial.html and here
http://tldp.org/HOWTO/IP-Masquerade-HOWTO/.

