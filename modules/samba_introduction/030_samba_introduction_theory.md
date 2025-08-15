## verify installed version

### .rpm based distributions

To see the version of samba installed on Red Hat, Fedora or CentOS use
`rpm -q samba`.

    [root@linux ~]# rpm -q samba
    samba-3.0.28-1.el5_2.1

The screenshot above shows that RHEL5 has `Samba` version
3.0 installed. The last number in the Samba version counts the number of
updates or patches.

Below the same command on a more recent version of CentOS with Samba
version 3.5 installed.

    [root@centos6 ~]# rpm -q samba
    samba-3.5.10-116.el6_2.i686

### .deb based distributions

Use `dpkg -l` or `aptitide show` on Debian
or Ubuntu. Both Debian 7.0 (Wheezy) and Ubuntu 12.04 (Precise) use
version 3.6.3 of the Samba server.

    root@linux~# aptitude show samba | grep Version
    Version: 2:3.6.3-1

Ubuntu 12.04 is currently at Samba version 3.6.3.

    root@linux:~# dpkg -l samba | tail -1
    ii samba 2:3.6.3-2ubuntu2.1 SMB/CIFS file, print, and login server for Unix

## installing samba

### .rpm based distributions

Samba is installed by default on Red Hat Enterprise Linux. If Samba is
not yet installed, then you can use the graphical menu (Applications \--
System Settings \-- Add/Remove Applications) and select \"Windows File
Server\" in the Server section. The non-graphical way is to use
`rpm` or `yum`.

When you downloaded the .rpm file, you can install Samba like this.

    [student@linux ~]$ rpm -i samba-3.0.28-1.el5_2.1.rpm

When you have a subscription to RHN (Red Hat Network), then `yum` is an
easy tool to use. This `yum` command works by default on Fedora and
CentOS.

    [root@centos6 ~]# yum install samba

### .deb based distributions

Ubuntu and Debian users can use the `aptitude` program (or
use a graphical tool like Synaptic).

    root@linux~# aptitude install samba
    The following NEW packages will be installed:
      samba samba-common{a} samba-common-bin{a} tdb-tools{a} 
    0 packages upgraded, 4 newly installed, 0 to remove and 1 not upgraded.
    Need to get 15.1 MB of archives. After unpacking 42.9 MB will be used.
    Do you want to continue? [Y/n/?]
    ...

## documentation

### samba howto

Samba comes with excellent documentation in html and pdf format (and
also as a free download from samba.org and it is for sale as a printed
book).

The documentation is a separate package, so install it if you want it on
the server itself.

    [root@centos6 ~]# yum install samba-doc
    ...
    [root@centos6 ~]# ls -l /usr/share/doc/samba-doc-3.5.10/
    total 10916
    drwxr-xr-x. 6 root root    4096 May  6 15:50 htmldocs
    -rw-r--r--. 1 root root 4605496 Jun 14  2011 Samba3-ByExample.pdf
    -rw-r--r--. 1 root root  608260 Jun 14  2011 Samba3-Developers-Guide.pdf
    -rw-r--r--. 1 root root 5954602 Jun 14  2011 Samba3-HOWTO.pdf

This action is very similar on Ubuntu and Debian except that the pdf
files are in a separate package named `samba-doc-pdf`.

    root@linux:~# aptitude install samba-doc-pdf
    The following NEW packages will be installed:
      samba-doc-pdf
    ...

### samba by example

Besides the howto, there is also an excellent book called
`Samba By Example` (again available as printed edition in shops, and as
a free pdf and html).

## starting and stopping samba

You can start the daemons by invoking
`/etc/init.d/smb start` (some systems use
`/etc/init.d/samba`) on any linux.

    root@linux:~# /etc/init.d/samba stop
     * Stopping Samba daemons                                    [ OK ] 
    root@linux:~# /etc/init.d/samba start
     * Starting Samba daemons                                    [ OK ] 
    root@linux:~# /etc/init.d/samba restart
     * Stopping Samba daemons                                    [ OK ] 
     * Starting Samba daemons                                    [ OK ] 
    root@linux:~# /etc/init.d/samba status
     * SMBD is running                                           [ OK ]

Red Hat derived systems are happy with
`service smb start`.

    [root@linux ~]# /etc/init.d/smb start
    Starting SMB services:                                     [  OK  ]
    Starting NMB services:                                     [  OK  ]
    [root@linux ~]# service smb restart
    Shutting down SMB services:                                [  OK  ]
    Shutting down NMB services:                                [  OK  ]
    Starting SMB services:                                     [  OK  ]
    Starting NMB services:                                     [  OK  ]
    [root@linux ~]#

## samba daemons

Samba 3 consists of three daemons, they are named `nmbd`,
`smbd` and `winbindd`.

### nmbd

The `nmbd` daemon takes care of all the names and naming. It registers
and resolves names, and handles browsing. According to the Samba
documentation, it should be the first daemon to start.

    [root@linux ~]# ps -C nmbd
      PID TTY          TIME CMD
     5681 ?        00:00:00 nmbd

### smbd

The `smbd` daemon manages file transfers and authentication.

    [root@linux ~]# ps -C smbd
      PID TTY          TIME CMD
     5678 ?        00:00:00 smbd
     5683 ?        00:00:00 smbd

### winbindd

The `winbind daemon` (winbindd) is only started to handle
Microsoft Windows domain membership.

Note that `winbindd` is started by the
`/etc/init.d/winbind` script (two dd's for the daemon and
only one d for the script).

    [root@linux ~]# /etc/init.d/winbind start
    Starting Winbind services:                                 [  OK  ]
    [root@linux ~]# ps -C winbindd
      PID TTY          TIME CMD
     5752 ?        00:00:00 winbindd
     5754 ?        00:00:00 winbindd

On Debian and Ubuntu, the winbindd daemon is installed via a separate
package called `winbind`.

## the SMB protocol

### brief history

Development of this protocol was started by `IBM` in the
early eighties. By the end of the eighties, most develpment was done by
`Microsoft`. SMB is an application level protocol designed to run on top
of NetBIOS/NetBEUI, but can also be run on top of tcp/ip.

In 1996 Microsoft was asked to document the protocol. They submitted
CIFS (Common Internet File System) as an internet draft, but it never
got final rfc status.

In 2004 the European Union decided Microsoft should document the
protocol to enable other developers to write compatible software.
December 20th 2007 Microsoft came to an agreement. The Samba team now
has access to SMB/CIFS, Windows for Workgroups and Active Directory
documentation.

### broadcasting protocol

SMB uses the NetBIOS `service location protocol`, which is
a broadcasting protocol. This means that NetBIOS names have to be unique
on the network (even when you have different IP-addresses). Having
duplicate names on an SMB network can seriously harm communications.

### NetBIOS names

NetBIOS names are similar to `hostnames`,
but are always uppercase and only 15 characters in length. Microsoft
Windows computers and Samba servers will broadcast this name on the
network.

### network bandwidth

Having many broadcasting SMB/CIFS computers on your
network can cause bandwidth issues. A solution can be the use of a
`NetBIOS name server` (NBNS) like `WINS` (Windows Internet Naming
Service).

