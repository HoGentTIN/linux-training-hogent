# Linux kernel modules

## about kernel modules

The Linux kernel is a monolithic kernel with loadable modules. These
modules contain parts of the kernel used typically for device drivers,
file systems and network protocols. Most of the time the necessary
kernel modules are loaded automatically and dynamically without
administrator interaction.

## /lib/modules

The modules are stored in the
`/lib/modules/<kernel-version>` directory. There is a
separate directory for each kernel that was compiled for your system.

    student@linux:~$ ll /lib/modules/
    total 12K
    drwxr-xr-x 7 root root 4.0K 2008-11-10 14:32 2.6.24-16-generic
    drwxr-xr-x 8 root root 4.0K 2008-12-06 15:39 2.6.24-21-generic
    drwxr-xr-x 8 root root 4.0K 2008-12-05 12:58 2.6.24-22-generic

## \<module\>.ko

The file containing the modules usually ends in `.ko`. This screenshot
shows the location of the isdn module files.

    student@linux:~$ find /lib/modules -name isdn.ko
    /lib/modules/2.6.24-21-generic/kernel/drivers/isdn/i4l/isdn.ko
    /lib/modules/2.6.24-22-generic/kernel/drivers/isdn/i4l/isdn.ko
    /lib/modules/2.6.24-16-generic/kernel/drivers/isdn/i4l/isdn.ko

## lsmod

To see a list of currently loaded modules, use `lsmod`.
You see the name of each loaded module, the size, the use count, and the
names of other modules using this one.

    [root@linux ~]# lsmod | head -5
    Module                  Size  Used by
    autofs4                24517  2 
    hidp                   23105  2 
    rfcomm                 42457  0 
    l2cap                  29505  10 hidp,rfcomm

## /proc/modules

`/proc/modules` lists all modules loaded by the kernel.
The output would be too long to display here, so lets
`grep` for the `vm` module.

We see that vmmon and vmnet are both loaded. You can display the same
information with `lsmod`. Actually `lsmod` only reads and
reformats the output of `/proc/modules`.

    student@linux:~$ cat /proc/modules | grep vm
    vmnet 36896 13 - Live 0xffffffff88b21000 (P)
    vmmon 194540 0 - Live 0xffffffff88af0000 (P)
    student@linux:~$ lsmod | grep vm
    vmnet                  36896  13 
    vmmon                 194540  0 
    student@linux:~$

## module dependencies

Some modules depend on others. In the following example, you can see
that the nfsd module is used by exportfs, lockd and sunrpc.

    student@linux:~$ cat /proc/modules | grep nfsd
    nfsd 267432 17 - Live 0xffffffff88a40000
    exportfs 7808 1 nfsd, Live 0xffffffff88a3d000
    lockd 73520 3 nfs,nfsd, Live 0xffffffff88a2a000
    sunrpc 185032 12 nfs,nfsd,lockd, Live 0xffffffff889fb000
    student@linux:~$ lsmod | grep nfsd
    nfsd                  267432  17 
    exportfs                7808  1 nfsd
    lockd                  73520  3 nfs,nfsd
    sunrpc                185032  12 nfs,nfsd,lockd
    student@linux:~$

## insmod

Kernel modules can be manually loaded with the `insmod`
command. This is a very simple (and obsolete) way of loading modules.
The screenshot shows `insmod` loading the fat module (for fat file
system support).

    root@linux:/lib/modules/2.6.17-2-686# lsmod | grep fat
    root@linux:/lib/modules/2.6.17-2-686# insmod kernel/fs/fat/fat.ko 
    root@linux:/lib/modules/2.6.17-2-686# lsmod | grep fat
    fat                    46588  0

`insmod` is not detecting dependencies, so it fails to load the isdn
module (because the isdn module depends on the slhc module).

    [root@linux drivers]# pwd
    /lib/modules/2.6.18-92.1.18.el5/kernel/drivers
    [root@linux kernel]# insmod isdn/i4l/isdn.ko 
    insmod: error inserting 'isdn/i4l/isdn.ko': -1 Unknown symbol in module

## modinfo

As you can see in the screenshot of `modinfo` below, the
isdn module depends in the slhc module.

    [root@linux drivers]# modinfo isdn/i4l/isdn.ko | head -6
    filename:       isdn/i4l/isdn.ko
    license:        GPL
    author:         Fritz Elfert
    description:    ISDN4Linux: link layer
    srcversion:     99650346E708173496F6739
    depends:        slhc

## modprobe

The big advantage of `modprobe` over
`insmod` is that modprobe will load all necessary modules,
whereas insmod requires manual loading of dependencies. Another
advantage is that you don't need to point to the filename with full
path.

This screenshot shows how modprobe loads the isdn module, automatically
loading slhc in background.

    [root@linux kernel]# lsmod | grep isdn
    [root@linux kernel]# modprobe isdn
    [root@linux kernel]# lsmod | grep isdn
    isdn                  122433  0 
    slhc                   10561  1 isdn
    [root@linux kernel]#

## /lib/modules/\<kernel\>/modules.dep

Module dependencies are stored in `modules.dep`.

    [root@linux 2.6.18-92.1.18.el5]# pwd
    /lib/modules/2.6.18-92.1.18.el5
    [root@linux 2.6.18-92.1.18.el5]# head -3 modules.dep 
    /lib/modules/2.6.18-92.1.18.el5/kernel/drivers/net/tokenring/3c359.ko:
    /lib/modules/2.6.18-92.1.18.el5/kernel/drivers/net/pcmcia/3c574_cs.ko:
    /lib/modules/2.6.18-92.1.18.el5/kernel/drivers/net/pcmcia/3c589_cs.ko:

## depmod

The `modules.dep` file can be updated (recreated) with the
`depmod` command. In this screenshot no modules were
added, so `depmod` generates the same file.

    root@linux:/lib/modules/2.6.17-2-686# ls -l modules.dep 
    -rw-r--r-- 1 root root 310676 2008-03-01 16:32 modules.dep
    root@linux:/lib/modules/2.6.17-2-686# depmod
    root@linux:/lib/modules/2.6.17-2-686# ls -l modules.dep 
    -rw-r--r-- 1 root root 310676 2008-12-07 13:54 modules.dep

## rmmod

Similar to insmod, the `rmmod` command is rarely used
anymore.

    [root@linux ~]# modprobe isdn
    [root@linux ~]# rmmod slhc
    ERROR: Module slhc is in use by isdn
    [root@linux ~]# rmmod isdn
    [root@linux ~]# rmmod slhc
    [root@linux ~]# lsmod | grep isdn
    [root@linux ~]#

## modprobe -r

Contrary to rmmod, `modprobe` will automatically remove
unneeded modules.

    [root@linux ~]# modprobe isdn
    [root@linux ~]# lsmod | grep isdn
    isdn                  133537  0 
    slhc                    7233  1 isdn
    [root@linux ~]# modprobe -r isdn
    [root@linux ~]# lsmod | grep isdn
    [root@linux ~]# lsmod | grep slhc
    [root@linux ~]#

## /etc/modprobe.conf

The `/etc/modprobe.conf` file and the
`/etc/modprobe.d` directory can contain aliases (used by
humans) and options (for dependent modules) for modprobe.

    [root@linux ~]# cat /etc/modprobe.conf
    alias scsi_hostadapter mptbase
    alias scsi_hostadapter1 mptspi
    alias scsi_hostadapter2 ata_piix
    alias eth0 pcnet32
    alias eth2 pcnet32
    alias eth1 pcnet32

