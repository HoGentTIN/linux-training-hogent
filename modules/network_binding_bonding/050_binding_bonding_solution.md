## solution: binding and bonding

1. Add an extra `ip address` to one of your network cards. Test that it
works (have your neighbour ssh to it)!

    Redhat/Fedora:
    add an /etc/sysconfig/network-scripts/ifcfg-ethX:X file
    as shown in the theory

    Debian/Ubuntu:
    expand the /etc/network/interfaces file
    as shown in the theory

2. Use `ifdown` to disable this extra `ip address`.

    ifdown eth0:0

3. Make sure your neighbour also succeeded in `binding` an extra ip
address before you continue.

    ping $extra_ip_neighbour
    or
    ssh $extra_ip_neighbour

4. Add an extra network card (or two) to your virtual machine and use
the theory to `bond` two network cards.

    Redhat/Fedora:
    add ifcfg-ethX and ifcfg-bondX files in /etc/sysconfig/network-scripts
    as shown in the theory
    and don't forget the modprobe.conf

    Debian/Ubuntu:
    expand the /etc/network/interfaces file
    as shown in the theory
    and don't forget to install the ifenslave package

