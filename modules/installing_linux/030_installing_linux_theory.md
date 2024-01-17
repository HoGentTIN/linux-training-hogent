# about

The past couple of years the installation of Linux has become a lot
easier than before, at least for end users installing a distro like
Ubuntu, Fedora, Debian or Mandrake on their home computer. Servers
usually come pre-installed, and if not pre-installed, then setup of a
Linux server today is very easy.

# legacy content

Everything below this paragraph was written betweem 2003 and 2009 or so.
I will rewrite this when I find the time.

## about

Linux can be installed in many different ways. End users most commonly
use cdrom\'s or dvd\'s for installation, most of the time with a working
internet connection te receive updates. Administrators might prefer
network installations using protocols like `tftp`,
`bootp`, `rarp` and/or `nfs`
or response file solutions like `Red Hat Kickstart` or
`Solaris Jumpstart`.

## installation by cdrom

Installation of Linux from cdrom is easy! Most distributions ask very
few questions during install (keyboard type, language, username) and
detect all the hardware themselves. There is usually no need to retrieve
third-party drivers from the internet. The GUI installation gives
options like Desktop (for end users), Workstation (for developers),
Server or minimal (usually without graphical interface).

## installation with rarp and tftp

Installing over the network involves powering on the machine, have it
find a rarpd server to get an ip-address, then let it find an tftps
server to get an installation image copied to the machine. This image
can then boot. The procedure below demonstrates how to setup three Sun
SPARC servers with Ubuntu Linux, using a Debian Linux machine to host
the tftp, bootp and nfs daemons.

First we need to configure the mac to ip resolution in the
`/etc/ethers` configuration file. Each server will receive
a unique ip-address during installation.

    root@laika:~# cat /etc/ethers 
    00:03:ba:02:c3:82       192.168.1.71
    00:03:ba:09:7c:f9       192.168.1.72
    00:03:ba:09:7f:d2       192.168.1.73

We need to install the rarpd and tftpd daemons on the (Debian) machine
that will be hosting the install image.

    root@laika:~# aptitude install rarpd
    root@laika:~# aptitude install tftpd

The tftp services must be activated in inetd or xinetd.

    root@laika:~# cat /etc/inetd.conf | tail -1
    tftp dgram udp wait nobody /usr/sbin/tcpd /usr/sbin/in.tftpd /srv/tftp
        

And finally the Linux install image must be present in the tftp served
directory. The filename of the image must be the hex ip-address, this is
accomplished with symbolic links.

    root@laika:~# ll /srv/tftp/
    total 7.5M
    lrwxrwxrwx 1 root root   13 2007-03-02 21:49 C0A80147 -> ubuntu610.img
    lrwxrwxrwx 1 root root   13 2007-03-03 14:13 C0A80148 -> ubuntu610.img
    lrwxrwxrwx 1 root root   13 2007-03-02 21:49 C0A80149 -> ubuntu610.img
    -rw-r--r-- 1 paul paul 7.5M 2007-03-02 21:42 ubuntu610.img

Time to enter `boot net` now in the openboot prompt. Twenty minutes
later the three servers where humming with Linux.

## about Red Hat kickstart

Automating Linux installations with response files can be done with
`Red Hat kickstart`. One way to set it up is by using the
graphical tool `/usr/sbin/system-config-kickstart`. If you
prefer to set it up manually, read on.

You can modify the sample kickstart file
`RH-DOCS/sample.ks` (can be found on the documentation
dvd). Put this file so `anaconda` can read it.

*Anaconda is the Red Hat installer written in `python`. The name is
chose because anacondas are lizard-eating pythons. Lizard is the name of
the Caldera Linux installation program.*

Another option is to start with the
`/root/anaconda-ks.cfg` file. This is a sample kickstart
file that contains all the settings from your current installation.

Do not change the order of the sections inside your kickstart file! The
Red Hat System Administration Guide contains about 25 pages describing
all the options, most of them are easy ti understand if you already
performed a couple of installations.

## using kickstart

To use kickstart, name your kickstart file `ks.cfg` and
put it in the root directory of your installation cdrom (or on a usb
stick or a floppy). For network based installations, name the file
`$ip-address-kickstart` and place the following in
`dhcpd.conf`.

    filename "/export/kickstart"
    next-server remote.installation.server

Leaving out the `next-server` line will result in the client looking for
the file on the dhcp server itself.

Booting from cdrom with kickstart requires the following command at the
`boot:` prompt.

    linux ks=cdrom:/ks.cfg
        

When the kickstart file is on the network, use nfs or http like in these
examples.

    linux ks=nfs:servername:/path/to/ks.cfg

    linux ks=http://servername/path/to/ks.cfg
