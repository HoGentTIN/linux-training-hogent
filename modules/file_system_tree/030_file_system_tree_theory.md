# filesystem hierarchy standard

Many Linux distributions partially follow the
`Filesystem Hierarchy Standard`. The `FHS` may help make
more Unix/Linux file system trees conform better in the future. The
`FHS` is available online at
`http://www.pathname.com/fhs/` where we read: \"The
filesystem hierarchy standard has been designed to be used by Unix
distribution developers, package developers, and system implementers.
However, it is primarily intended to be a reference and is not a
tutorial on how to manage a Unix filesystem or directory hierarchy.\"

# man hier

There are some differences in the filesystems between
`Linux distributions`. For help about your machine, enter
`man hier` to find information about the file system
hierarchy. This manual will explain the directory structure on your
computer.

# the root directory /

All Linux systems have a directory structure that starts at the
`root directory`. The root directory is represented by a
`forward slash`, like this: `/`. Everything that exists on
your Linux system can be found below this root directory. Let\'s take a
brief look at the contents of the root directory.

    [paul@RHELv8u3 ~]$ ls /
    bin   dev  home  media  mnt  proc  sbin     srv  tftpboot  usr
    boot  etc  lib   misc   opt  root  selinux  sys  tmp       var
        

# binary directories

`Binaries` are files that contain compiled source code (or machine
code). Binaries can be `executed` on the computer. Sometimes binaries
are called `executables`.

## /bin

The `/bin` directory contains `binaries` for
use by all users. According to the FHS the `/bin` directory should
contain `/bin/cat` and `/bin/date` (among
others).

In the screenshot below you see common Unix/Linux commands like cat, cp,
cpio, date, dd, echo, grep, and so on. Many of these will be covered in
this book.

    paul@laika:~$ ls /bin
    archdetect       egrep             mt               setupcon
    autopartition    false             mt-gnu           sh
    bash             fgconsole         mv               sh.distrib
    bunzip2          fgrep             nano             sleep
    bzcat            fuser             nc               stralign
    bzcmp            fusermount        nc.traditional   stty
    bzdiff           get_mountoptions  netcat           su
    bzegrep          grep              netstat          sync
    bzexe            gunzip            ntfs-3g          sysfs
    bzfgrep          gzexe             ntfs-3g.probe    tailf
    bzgrep           gzip              parted_devices   tar
    bzip2            hostname          parted_server    tempfile
    bzip2recover     hw-detect         partman          touch
    bzless           ip                partman-commit   true
    bzmore           kbd_mode          perform_recipe   ulockmgr
    cat              kill              pidof            umount
    ...

## other /bin directories

You can find a `/bin subdirectory` in many other directories. A user
named `serena` could put her own programs in `/home/serena/bin`.

Some applications, often when installed directly from source will put
themselves in `/opt`. A `samba server` installation can use
`/opt/samba/bin` to store its binaries.

## /sbin

`/sbin` contains binaries to configure the operating
system. Many of the `system binaries` require `root`
privilege to perform certain tasks.

Below a screenshot containing `system binaries` to change the ip
address, partition a disk and create an ext4 file system.

    paul@ubu1010:~$ ls -l /sbin/ifconfig /sbin/fdisk /sbin/mkfs.ext4
    -rwxr-xr-x 1 root root 97172 2011-02-02 09:56 /sbin/fdisk
    -rwxr-xr-x 1 root root 65708 2010-07-02 09:27 /sbin/ifconfig
    -rwxr-xr-x 5 root root 55140 2010-08-18 18:01 /sbin/mkfs.ext4

## /lib

Binaries found in `/bin` and `/sbin` often use `shared libraries`
located in `/lib`. Below is a screenshot of the partial
contents of `/lib`.

    paul@laika:~$ ls /lib/libc*
    /lib/libc-2.5.so     /lib/libcfont.so.0.0.0  /lib/libcom_err.so.2.1    
    /lib/libcap.so.1     /lib/libcidn-2.5.so     /lib/libconsole.so.0      
    /lib/libcap.so.1.10  /lib/libcidn.so.1       /lib/libconsole.so.0.0.0  
    /lib/libcfont.so.0   /lib/libcom_err.so.2    /lib/libcrypt-2.5.so

### /lib/modules

Typically, the `Linux kernel` loads kernel modules from
`/lib/modules/$kernel-version/`. This directory is
discussed in detail in the Linux kernel chapter.

### /lib32 and /lib64

We currently are in a transition between `32-bit` and `64-bit` systems.
Therefore, you may encounter directories named `/lib32`
and `/lib64` which clarify the register size used during
compilation time of the libraries. A 64-bit computer may have some
32-bit binaries and libraries for compatibility with legacy
applications. This screenshot uses the `file` utility to
demonstrate the difference.

    paul@laika:~$ file /lib32/libc-2.5.so 
    /lib32/libc-2.5.so: ELF 32-bit LSB shared object, Intel 80386, \
    version 1 (SYSV), for GNU/Linux 2.6.0, stripped
    paul@laika:~$ file /lib64/libcap.so.1.10 
    /lib64/libcap.so.1.10: ELF 64-bit LSB shared object, AMD x86-64, \
    version 1 (SYSV), stripped
                

The ELF `(Executable and Linkable Format)` is used in
almost every Unix-like operating system since `System V`.

## /opt

The purpose of `/opt` is to store `optional` software. In many cases
this is software from outside the distribution repository. You may find
an empty `/opt` directory on many systems.

A large package can install all its files in `/bin`, `/lib`, `/etc`
subdirectories within `/opt/$packagename/`. If for example the package
is called wp, then it installs in `/opt/wp`, putting binaries in
`/opt/wp/bin` and manpages in `/opt/wp/man`.

# configuration directories

## /boot

The `/boot` directory contains all files needed to boot
the computer. These files don\'t change very often. On Linux systems you
typically find the `/boot/grub` directory here.
`/boot/grub` contains `/boot/grub/grub.cfg` (older systems
may still have `/boot/grub/grub.conf`) which defines the
boot menu that is displayed before the kernel starts.

## /etc

All of the machine-specific `configuration files` should be located in
`/etc`. Historically `/etc` stood for `etcetera`, today
people often use the `Editable Text Configuration` backronym.

Many times the name of a configuration files is the same as the
application, daemon, or protocol with `.conf` added as the extension.

    paul@laika:~$ ls /etc/*.conf
    /etc/adduser.conf        /etc/ld.so.conf       /etc/scrollkeeper.conf
    /etc/brltty.conf         /etc/lftp.conf        /etc/sysctl.conf
    /etc/ccertificates.conf  /etc/libao.conf       /etc/syslog.conf
    /etc/cvs-cron.conf       /etc/logrotate.conf   /etc/ucf.conf
    /etc/ddclient.conf       /etc/ltrace.conf      /etc/uniconf.conf
    /etc/debconf.conf        /etc/mke2fs.conf      /etc/updatedb.conf
    /etc/deluser.conf        /etc/netscsid.conf    /etc/usplash.conf
    /etc/fdmount.conf        /etc/nsswitch.conf    /etc/uswsusp.conf
    /etc/hdparm.conf         /etc/pam.conf         /etc/vnc.conf
    /etc/host.conf           /etc/pnm2ppa.conf     /etc/wodim.conf
    /etc/inetd.conf          /etc/povray.conf      /etc/wvdial.conf
    /etc/kernel-img.conf     /etc/resolv.conf
    paul@laika:~$ 

There is much more to be found in `/etc`.

### /etc/init.d/

A lot of Unix/Linux distributions have an `/etc/init.d`
directory that contains scripts to start and stop `daemons`. This
directory could disappear as Linux migrates to systems that replace the
old `init` way of starting all `daemons`.

### /etc/X11/

The graphical display (aka `X Window System` or just
`X`) is driven by software from the X.org foundation. The
configuration file for your graphical display is
`/etc/X11/xorg.conf`.

### /etc/skel/

The `skeleton` directory `/etc/skel` is
copied to the home directory of a newly created user. It usually
contains hidden files like a `.bashrc` script.

### /etc/sysconfig/

This directory, which is not mentioned in the FHS, contains a lot of
`Red Hat Enterprise Linux` configuration files. We will discuss some of
them in greater detail. The screenshot below is the
`/etc/sysconfig` directory from RHELv8u4 with everything
installed.

    paul@RHELv8u4:~$ ls /etc/sysconfig/
    apmd         firstboot     irda              network      saslauthd
    apm-scripts  grub          irqbalance        networking   selinux
    authconfig   hidd          keyboard          ntpd         spamassassin
    autofs       httpd         kudzu             openib.conf  squid
    bluetooth    hwconf        lm_sensors        pand         syslog
    clock        i18n          mouse             pcmcia       sys-config-sec
    console      init          mouse.B           pgsql        sys-config-users
    crond        installinfo   named             prelink      sys-logviewer
    desktop      ipmi          netdump           rawdevices   tux
    diskdump     iptables      netdump_id_dsa    rhn          vncservers
    dund         iptables-cfg  netdump_id_dsa.p  samba        xinetd
    paul@RHELv8u4:~$

The file `/etc/sysconfig/firstboot` tells the Red Hat
Setup Agent not to run at boot time. If you want to run the Red Hat
Setup Agent at the next reboot, then simply remove this file, and run
`chkconfig --level 5 firstboot on`. The Red Hat Setup
Agent allows you to install the latest updates, create a user account,
join the Red Hat Network and more. It will then create the
/etc/sysconfig/firstboot file again.

    paul@RHELv8u4:~$ cat /etc/sysconfig/firstboot 
    RUN_FIRSTBOOT=NO

The `/etc/sysconfig/harddisks` file contains some
parameters to tune the hard disks. The file explains itself.

You can see hardware detected by `kudzu` in
`/etc/sysconfig/hwconf`. Kudzu is software from Red Hat
for automatic discovery and configuration of hardware.

The keyboard type and keymap table are set in the
`/etc/sysconfig/keyboard` file. For more console keyboard
information, check the manual pages of `keymaps(5)`,
`dumpkeys(1)`, `loadkeys(1)` and the
directory `/lib/kbd/keymaps/`.

    root@RHELv8u4:/etc/sysconfig# cat keyboard 
    KEYBOARDTYPE="pc"
    KEYTABLE="us"

We will discuss networking files in this directory in the networking
chapter.

# data directories

## /home

Users can store personal or project data under `/home`. It
is common (but not mandatory by the fhs) practice to name the users home
directory after the user name in the format `/home/$USERNAME`. For
example:

    paul@ubu606:~$ ls /home 
    geert  annik  sandra  paul  tom

Besides giving every user (or every project or group) a location to
store personal files, the home directory of a user also serves as a
location to store the user profile. A typical Unix user profile contains
many hidden files (files whose file name starts with a dot). The hidden
files of the Unix user profiles contain settings specific for that user.

    paul@ubu606:~$ ls -d /home/paul/.*
    /home/paul/.              /home/paul/.bash_profile  /home/paul/.ssh
    /home/paul/..             /home/paul/.bashrc        /home/paul/.viminfo
    /home/paul/.bash_history  /home/paul/.lesshst
            

## /root

On many systems `/root` is the default location for
personal data and profile of the `root user`. If it does not exist by
default, then some administrators create it.

## /srv

You may use `/srv` for data that is
`served by your system`. The FHS allows locating cvs, rsync, ftp and www
data in this location. The FHS also approves administrative naming in
/srv, like /srv/project55/ftp and /srv/sales/www.

On Sun Solaris (or Oracle Solaris) `/export` is used for
this purpose.

## /media

The `/media` directory serves as a mount point for
`removable media devices` such as CD-ROM\'s, digital cameras, and
various usb-attached devices. Since `/media` is rather new in the Unix
world, you could very well encounter systems running without this
directory. Solaris 9 does not have it, Solaris 10 does. Most Linux
distributions today mount all removable media in `/media`.

    paul@debian10:~$ ls /media/
    cdrom  cdrom0  usbdisk

## /mnt

The `/mnt` directory should be empty and should only be used for
temporary mount points (according to the FHS).

Unix and Linux administrators used to create many directories here, like
/mnt/something/. You likely will encounter many systems with more than
one directory created and/or mounted inside `/mnt` to be used for
various local and remote filesystems.

## /tmp

Applications and users should use `/tmp` to store
temporary data when needed. Data stored in `/tmp` may use either disk
space or RAM. Both of which are managed by the operating system. Never
use `/tmp` to store data that is important or which you wish to archive.

# in memory directories

## /dev

Device files in `/dev` appear to be ordinary files, but
are not actually located on the hard disk. The `/dev` directory is
populated with files as the kernel is recognising hardware.

### common physical devices

Common hardware such as hard disk devices are represented by device
files in `/dev`. Below a screenshot of SATA device files on a laptop and
then IDE attached drives on a desktop. (The detailed meaning of these
devices will be discussed later.)

    #
    # SATA or SCSI or USB
    #
    paul@laika:~$ ls /dev/sd*
    /dev/sda  /dev/sda1  /dev/sda2  /dev/sda3  /dev/sdb  /dev/sdb1  /dev/sdb2

    #
    # IDE or ATAPI
    #
    paul@barry:~$ ls /dev/hd*
    /dev/hda  /dev/hda1  /dev/hda2  /dev/hdb  /dev/hdb1  /dev/hdb2  /dev/hdc
                

Besides representing physical hardware, some device files are special.
These special devices can be very useful.

### /dev/tty and /dev/pts

For example, `/dev/tty1` represents a terminal or console
attached to the system. (Don\'t break your head on the exact terminology
of \'terminal\' or \'console\', what we mean here is a command line
interface.) When typing commands in a terminal that is part of a
graphical interface like Gnome or KDE, then your terminal will be
represented as `/dev/pts/1` (1 can be another number).

### /dev/null

On Linux you will find other special devices such as
`/dev/null` which can be considered a black hole; it has
unlimited storage, but nothing can be retrieved from it. Technically
speaking, anything written to /dev/null will be discarded. /dev/null can
be useful to discard unwanted output from commands. */dev/null is not a
good location to store your backups ;-)*.

## /proc conversation with the kernel

`/proc` is another special directory, appearing to be
ordinary files, but not taking up disk space. It is actually a view of
the kernel, or better, what the kernel manages, and is a means to
interact with it directly. `/proc` is a proc filesystem.

    paul@RHELv8u4:~$ mount -t proc
    none on /proc type proc (rw)
            

When listing the /proc directory you will see many numbers (on any Unix)
and some interesting files (on Linux)

    mul@laika:~$ ls /proc
    1      2339   4724  5418  6587  7201       cmdline      mounts
    10175  2523   4729  5421  6596  7204       cpuinfo      mtrr
    10211  2783   4741  5658  6599  7206       crypto       net
    10239  2975   4873  5661  6638  7214       devices      pagetypeinfo
    141    29775  4874  5665  6652  7216       diskstats    partitions
    15045  29792  4878  5927  6719  7218       dma          sched_debug
    1519   2997   4879  6     6736  7223       driver       scsi
    1548   3      4881  6032  6737  7224       execdomains  self
    1551   30228  4882  6033  6755  7227       fb           slabinfo
    1554   3069   5     6145  6762  7260       filesystems  stat
    1557   31422  5073  6298  6774  7267       fs           swaps
    1606   3149   5147  6414  6816  7275       ide          sys
    180    31507  5203  6418  6991  7282       interrupts   sysrq-trigger
    181    3189   5206  6419  6993  7298       iomem        sysvipc
    182    3193   5228  6420  6996  7319       ioports      timer_list
    18898  3246   5272  6421  7157  7330       irq          timer_stats
    19799  3248   5291  6422  7163  7345       kallsyms     tty
    19803  3253   5294  6423  7164  7513       kcore        uptime
    19804  3372   5356  6424  7171  7525       key-users    version
    1987   4      5370  6425  7175  7529       kmsg         version_signature
    1989   42     5379  6426  7188  9964       loadavg      vmcore
    2      45     5380  6430  7189  acpi       locks        vmnet
    20845  4542   5412  6450  7191  asound     meminfo      vmstat
    221    46     5414  6551  7192  buddyinfo  misc         zoneinfo
    2338   4704   5416  6568  7199  bus        modules
            

Let\'s investigate the file properties inside `/proc`. Looking at the
date and time will display the current date and time showing the files
are constantly updated (a view on the kernel).

    paul@RHELv8u4:~$ date
    Mon Jan 29 18:06:32 EST 2007
    paul@RHELv8u4:~$ ls -al /proc/cpuinfo 
    -r--r--r--  1 root root 0 Jan 29 18:06 /proc/cpuinfo
    paul@RHELv8u4:~$ 
    paul@RHELv8u4:~$  ...time passes...
    paul@RHELv8u4:~$ 
    paul@RHELv8u4:~$ date
    Mon Jan 29 18:10:00 EST 2007
    paul@RHELv8u4:~$ ls -al /proc/cpuinfo 
    -r--r--r--  1 root root 0 Jan 29 18:10 /proc/cpuinfo
            

Most files in /proc are 0 bytes, yet they contain data\--sometimes a lot
of data. You can see this by executing cat on files like
`/proc/cpuinfo`, which contains information about the CPU.

    paul@RHELv8u4:~$ file /proc/cpuinfo 
    /proc/cpuinfo: empty
    paul@RHELv8u4:~$ cat /proc/cpuinfo 
    processor       : 0
    vendor_id       : AuthenticAMD
    cpu family      : 15
    model           : 43
    model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4600+
    stepping        : 1
    cpu MHz         : 2398.628
    cache size      : 512 KB
    fdiv_bug        : no
    hlt_bug         : no
    f00f_bug        : no
    coma_bug        : no
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 1
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge...
    bogomips        : 4803.54
            

*Just for fun, here is /proc/cpuinfo on a Sun Sunblade 1000\...*

    paul@pasha:~$ cat /proc/cpuinfo
    cpu : TI UltraSparc III (Cheetah)
    fpu : UltraSparc III integrated FPU
    promlib : Version 3 Revision 2
    prom : 4.2.2
    type : sun4u
    ncpus probed : 2
    ncpus active : 2
    Cpu0Bogo : 498.68
    Cpu0ClkTck : 000000002cb41780
    Cpu1Bogo : 498.68
    Cpu1ClkTck : 000000002cb41780
    MMU Type : Cheetah
    State:
    CPU0: online
    CPU1: online 
            

Most of the files in /proc are read only, some require root privileges,
some files are writable, and many files in `/proc/sys` are
writable. Let\'s discuss some of the files in /proc.

### /proc/interrupts

On the x86 architecture, `/proc/interrupts` displays the
interrupts.

    paul@RHELv8u4:~$ cat /proc/interrupts 
               CPU0       
      0:   13876877    IO-APIC-edge  timer
      1:         15    IO-APIC-edge  i8042
      8:          1    IO-APIC-edge  rtc
      9:          0   IO-APIC-level  acpi
     12:         67    IO-APIC-edge  i8042
     14:        128    IO-APIC-edge  ide0
     15:     124320    IO-APIC-edge  ide1
    169:     111993   IO-APIC-level  ioc0
    177:       2428   IO-APIC-level  eth0
    NMI:          0 
    LOC:   13878037 
    ERR:          0
    MIS:          0

On a machine with two CPU\'s, the file looks like this.

    paul@laika:~$ cat /proc/interrupts 
              CPU0      CPU1       
      0:    860013        0  IO-APIC-edge     timer
      1:      4533        0  IO-APIC-edge     i8042
      7:         0        0  IO-APIC-edge     parport0
      8:   6588227        0  IO-APIC-edge     rtc
     10:      2314        0  IO-APIC-fasteoi  acpi
     12:       133        0  IO-APIC-edge     i8042
     14:         0        0  IO-APIC-edge     libata
     15:     72269        0  IO-APIC-edge     libata
     18:         1        0  IO-APIC-fasteoi  yenta
     19:    115036        0  IO-APIC-fasteoi  eth0
     20:    126871        0  IO-APIC-fasteoi  libata, ohci1394
     21:     30204        0  IO-APIC-fasteoi  ehci_hcd:usb1, uhci_hcd:usb2
     22:      1334        0  IO-APIC-fasteoi  saa7133[0], saa7133[0]
     24:    234739        0  IO-APIC-fasteoi  nvidia
    NMI:        72       42 
    LOC:    860000   859994 
    ERR:         0

### /proc/kcore

The physical memory is represented in `/proc/kcore`. Do
not try to cat this file, instead use a debugger. The size of
/proc/kcore is the same as your physical memory, plus four bytes.

    paul@laika:~$ ls -lh /proc/kcore 
    -r-------- 1 root root 2.0G 2007-01-30 08:57 /proc/kcore
    paul@laika:~$

## /sys Linux 2.6 hot plugging

The `/sys` directory was created for the Linux 2.6 kernel.
Since 2.6, Linux uses `sysfs` to support
`usb` and `IEEE 1394`
(`FireWire`) hot plug devices. See the manual pages of
udev(8) (the successor of `devfs`) and hotplug(8) for more
info (or visit http://linux-hotplug.sourceforge.net/ ).

Basically the `/sys` directory contains kernel information about
hardware.

# /usr Unix System Resources

Although `/usr` is pronounced like user, remember that it
stands for `Unix System Resources`. The `/usr` hierarchy should contain
`shareable, read only` data. Some people choose to mount `/usr` as read
only. This can be done from its own partition or from a read only NFS
share (NFS is discussed later).

## /usr/bin

The `/usr/bin` directory contains a lot of commands.

    paul@deb508:~$ ls /usr/bin | wc -l
    1395

(On Solaris the `/bin` directory is a symbolic link to `/usr/bin`.)

## /usr/include

The `/usr/include` directory contains general use include
files for C.

    paul@ubu1010:~$ ls /usr/include/
    aalib.h        expat_config.h      math.h           search.h
    af_vfs.h       expat_external.h    mcheck.h         semaphore.h
    aio.h          expat.h             memory.h         setjmp.h
    AL             fcntl.h             menu.h           sgtty.h
    aliases.h      features.h          mntent.h         shadow.h
    ...

## /usr/lib

The `/usr/lib` directory contains libraries that are not
directly executed by users or scripts.

    paul@deb508:~$ ls /usr/lib | head -7
    4Suite
    ao
    apt
    arj
    aspell
    avahi
    bonobo

## /usr/local

The `/usr/local` directory can be used by an administrator
to install software locally.

    paul@deb508:~$ ls /usr/local/
    bin  etc  games  include  lib  man  sbin  share  src
    paul@deb508:~$ du -sh /usr/local/
    128K    /usr/local/

## /usr/share

The `/usr/share` directory contains architecture
independent data. As you can see, this is a fairly large directory.

    paul@deb508:~$ ls /usr/share/ | wc -l
    263
    paul@deb508:~$ du -sh /usr/share/
    1.3G    /usr/share/

This directory typically contains `/usr/share/man` for
manual pages.

    paul@deb508:~$ ls /usr/share/man
    cs  fr        hu        it.UTF-8  man2  man6  pl.ISO8859-2  sv
    de  fr.ISO8859-1  id        ja    man3  man7  pl.UTF-8      tr
    es  fr.UTF-8      it        ko    man4  man8  pt_BR     zh_CN
    fi  gl        it.ISO8859-1  man1      man5  pl    ru        zh_TW

And it contains `/usr/share/games` for all static game
data (so no high-scores or play logs).

    paul@ubu1010:~$ ls /usr/share/games/
    openttd  wesnoth

## /usr/src

The `/usr/src` directory is the recommended location for
kernel source files.

    paul@deb508:~$ ls -l /usr/src/
    total 12
    drwxr-xr-x  4 root root 4096 2011-02-01 14:43 linux-headers-2.6.26-2-686
    drwxr-xr-x 18 root root 4096 2011-02-01 14:43 linux-headers-2.6.26-2-common
    drwxr-xr-x  3 root root 4096 2009-10-28 16:01 linux-kbuild-2.6.26

# /var variable data

Files that are unpredictable in size, such as log, cache and spool
files, should be located in `/var`.

## /var/log

The `/var/log` directory serves as a central point to
contain all log files.

    [paul@RHEL8b ~]$ ls /var/log
    acpid           cron.2    maillog.2   quagga           secure.4
    amanda          cron.3    maillog.3   radius           spooler
    anaconda.log    cron.4    maillog.4   rpmpkgs          spooler.1
    anaconda.syslog cups      mailman     rpmpkgs.1        spooler.2
    anaconda.xlog   dmesg     messages    rpmpkgs.2        spooler.3
    audit           exim      messages.1  rpmpkgs.3        spooler.4
    boot.log        gdm       messages.2  rpmpkgs.4        squid
    boot.log.1      httpd     messages.3  sa               uucp
    boot.log.2      iiim      messages.4  samba            vbox
    boot.log.3      iptraf    mysqld.log  scrollkeeper.log vmware-tools-guestd
    boot.log.4      lastlog   news        secure           wtmp
    canna           mail      pgsql       secure.1         wtmp.1
    cron            maillog   ppp         secure.2         Xorg.0.log
    cron.1          maillog.1 prelink.log secure.3         Xorg.0.log.old

## /var/log/messages

A typical first file to check when troubleshooting on Red Hat (and
derivatives) is the `/var/log/messages` file. By default
this file will contain information on what just happened to the system.
The file is called `/var/log/syslog` on Debian and Ubuntu.

    [root@RHEL8b ~]# tail /var/log/messages
    Jul 30 05:13:56 anacron: anacron startup succeeded
    Jul 30 05:13:56 atd: atd startup succeeded
    Jul 30 05:13:57 messagebus: messagebus startup succeeded
    Jul 30 05:13:57 cups-config-daemon: cups-config-daemon startup succeeded
    Jul 30 05:13:58 haldaemon: haldaemon startup succeeded
    Jul 30 05:14:00 fstab-sync[3560]: removed all generated mount points
    Jul 30 05:14:01 fstab-sync[3628]: added mount point /media/cdrom for...
    Jul 30 05:14:01 fstab-sync[3646]: added mount point /media/floppy for...
    Jul 30 05:16:46 sshd(pam_unix)[3662]: session opened for user paul by... 
    Jul 30 06:06:37 su(pam_unix)[3904]: session opened for user root by paul

## /var/cache

The `/var/cache` directory can contain `cache data` for
several applications.

    paul@ubu1010:~$ ls /var/cache/
    apt      dictionaries-common    gdm       man        software-center
    binfmts  flashplugin-installer  hald      pm-utils
    cups     fontconfig             jockey    pppconfig
    debconf  fonts                  ldconfig  samba

## /var/spool

The `/var/spool` directory typically contains spool
directories for `mail` and `cron`, but also serves as a parent directory
for other spool files (for example print spool files).

## /var/lib

The `/var/lib` directory contains application state
information.

Red Hat Enterprise Linux for example keeps files pertaining to
`rpm` in `/var/lib/rpm/`.

## /var/\...

`/var` also contains Process ID files in `/var/run` (soon
to be replaced with `/run`) and temporary files that
survive a reboot in `/var/tmp` and information about file
locks in `/var/lock`. There will be more examples of
`/var` usage further in this book.
