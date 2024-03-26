# xen

## About Xen

## installation

Installation of **Xen** via **apt-get install xen-system** will add an
entry in **grub2** to enable booting with or without the **xen
hypervisor**.

    root@MBDebian~# apt-get install xen-system xen-tools

===

## Creating an Xen image

    root@MBDebian~# xen-create-image --hostname xen1.xen.local --ip 192.168.1.101 --vcpus 1 --pygrub --dist buster --size=8gb --fs=ext4 --image=sparse --memory=512Mb --swap=512Mb
    WARNING:  No gateway address specified!
    WARNING:  No netmask address specified!

    General Information

Hostname : xen1.xen.local Distribution : buster Mirror :
<http://deb.debian.org/debian> Partitions : swap 512Mb (swap) / 8gb
(ext4) Image type : sparse Memory size : 512Mb Bootloader : pygrub

# Networking Information

IP Address 1 : 192.168.1.101 \[MAC: 00:16:3E:CB:F0:1A\]

# WARNING

Loopback module not loaded and you’re using loopback images Run the
following to load the module:

modprobe loop max\_loop=255

Creating partition image: /home/xen/domains/xen1.xen.local/swap.img Done

Creating swap on /home/xen/domains/xen1.xen.local/swap.img Done

Creating partition image: /home/xen/domains/xen1.xen.local/disk.img Done

Creating ext4 filesystem on /home/xen/domains/xen1.xen.local/disk.img
Done Installation method: debootstrap Done

Running hooks Done

No role scripts were specified. Skipping

Creating Xen configuration file Done

No role scripts were specified. Skipping Setting up root password
Generating a password for the new guest. All done

Logfile produced at: /var/log/xen-tools/xen1.xen.local.log

# Installation Summary

Hostname : xen1.xen.local Distribution : buster MAC Address :
00:16:3E:CB:F0:1A IP Address(es) : 192.168.1.101 SSH Fingerprint :
SHA256:xvcu/0smpDj3+BExbxZZ0/8DaJEaVbCaqQwp60Fflx8 (DSA) SSH Fingerprint
: SHA256:bJfySQD0tXxxfIAtCXC3Jv9fEKxTgl1bR4oUAFTeZ58 (ECDSA) SSH
Fingerprint : SHA256:GiaGEpGViaEs8WVC1vBnDLh2HMe1hD0NwbndCXYz8yM
(ED25519) SSH Fingerprint :
SHA256:5xoZoVcbzL4O0ynTaRJJTyrIM6xmZNTwTTr0P3YxYXQ (RSA) Root Password :
VuSMEy3QmYcZwN7JBcxJ8Jk

<root@MBDebian>~#

    This created the */home/xen* directory that we configured in */etc/xen-tools/xen-tools.conf*.

    [subs="quotes"]

root@MBDebian<sub>\#\ **ls\ /home/xen/domains/**\ xen1.xen.local\ root@MBDebian</sub>\#

    And this image can be quickly verified with *xen-list-images*.

    [subs="quotes"]

root@MBDebian<sub>\#\ **xen-list-images**\ Name:\ xen1.xen.local\ Memory:\ 512\ MB\ IP:\ 192.168.1.101\ Config:\ /etc/xen/xen1.xen.local.cfg\ root@MBDebian</sub>\#

    [subs="quotes"]

    [subs="quotes"]

    [subs="quotes"]

    [subs="quotes"]

    [subs="quotes"]

    [subs="quotes"]

    [subs="quotes"]

    <<<

    === Practice

    <<<

    === Solution
    .
    +
    [subs="quotes"]

    .
    +
    [subs="quotes"]

    .
    +
    [subs="quotes"]

    .
    +
    [subs="quotes"]

    .
    +
    [subs="quotes"]

    .
    +
    [subs="quotes"]

    .
    +
    [subs="quotes"]

    .
    +
    [subs="quotes"]
