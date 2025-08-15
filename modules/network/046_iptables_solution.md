# solution : iptables

1. Verify whether the firewall is running.

    root@linux ~# service iptables status | head
    Table: filter
    Chain INPUT (policy ACCEPT)
    num  target     prot opt source               destination         
    1    RH-Firewall-1-INPUT  all  --  0.0.0.0/0            0.0.0.0/0           

    Chain FORWARD (policy ACCEPT)
    num  target     prot opt source               destination         
    1    RH-Firewall-1-INPUT  all  --  0.0.0.0/0            0.0.0.0/0           

    Chain OUTPUT (policy ACCEPT)

2. Stop the running firewall.

    root@linux ~# service iptables stop
    Flushing firewall rules:                                   [  OK  ]
    Setting chains to policy ACCEPT: filter                    [  OK  ]
    Unloading iptables modules:                                [  OK  ]
    root@linux ~# service iptables status
    Firewall is stopped.

