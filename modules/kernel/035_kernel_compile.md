# compiling a kernel

## extraversion

Enter into `/usr/src/redhat/BUILD/kernel-2.6.9/linux-2.6.9/` and change
the `extraversion` in the Makefile.

    [root@linux linux-2.6.18.i686]# pwd
    /usr/src/redhat/BUILD/kernel-2.6.18/linux-2.6.18.i686
    [root@linux linux-2.6.18.i686]# vi Makefile 
    [root@linux linux-2.6.18.i686]# head -4 Makefile 
    VERSION = 2
    PATCHLEVEL = 6
    SUBLEVEL = 18
    EXTRAVERSION = -paul2008

## make mrproper

Now clean up the source from any previous installs with
`make mrproper`. If this is your first after downloading
the source code, then this is not needed.

    [root@linux linux-2.6.18.i686]# make mrproper
      CLEAN   scripts/basic
      CLEAN   scripts/kconfig
      CLEAN   include/config
      CLEAN   .config .config.old

## .config

Now copy a working `.config` from /boot to our kernel directory. This
file contains the configuration that was used for your current working
kernel. It determines whether modules are included in compilation or
not.

    [root@linux linux-2.6.18.i686]# cp /boot/config-2.6.18-92.1.18.el5 .config

## make menuconfig

Now run `make menuconfig` (or the graphical
`make xconfig`). This tool allows you to select whether to
compile stuff as a module (m), as part of the kernel (\*), or not at all
(smaller kernel size). If you remove too much, your kernel will not
work. The configuration will be stored in the hidden `.config` file.

    [root@linux linux-2.6.18.i686]# make menuconfig

## make clean

Issue a `make clean` to prepare the kernel for compile.
`make clean` will remove most generated files, but keeps your kernel
configuration. Running a `make mrproper` at this point would destroy the
.config file that you built with `make menuconfig`.

    [root@linux linux-2.6.18.i686]# make clean

## make bzImage

And then run `make bzImage`, sit back and relax while the
kernel compiles. You can use `time make bzImage` to know
how long it takes to compile, so next time you can go for a short walk.

    [root@linux linux-2.6.18.i686]# time make bzImage
      HOSTCC  scripts/basic/fixdep
      HOSTCC  scripts/basic/docproc
      HOSTCC  scripts/kconfig/conf.o
      HOSTCC  scripts/kconfig/kxgettext.o
    ... 

This command will end with telling you the location of the `bzImage`
file (and with time info if you also specified the time command.

    Kernel: arch/i386/boot/bzImage is ready  (#1)

    real    13m59.573s
    user    1m22.631s
    sys 11m51.034s
    [root@linux linux-2.6.18.i686]#

You can already copy this image to /boot with
`cp arch/i386/boot/bzImage /boot/vmlinuz-<kernel-version>`.

## make modules

Now run `make modules`. It can take 20 to 50 minutes to
compile all the modules.

    [root@linux linux-2.6.18.i686]# time make modules
      CHK     include/linux/version.h
      CHK     include/linux/utsrelease.h
      CC [M]  arch/i386/kernel/msr.o
      CC [M]  arch/i386/kernel/cpuid.o
      CC [M]  arch/i386/kernel/microcode.o

## make modules_install

To copy all the compiled modules to `/lib/modules` just
run `make modules_install` (takes about 20 seconds). Here\'s a
screenshot from before the command.

    [root@linux linux-2.6.18.i686]# ls -l /lib/modules/
    total 20
    drwxr-xr-x 6 root root 4096 Oct 15 13:09 2.6.18-92.1.13.el5
    drwxr-xr-x 6 root root 4096 Nov 11 08:51 2.6.18-92.1.17.el5
    drwxr-xr-x 6 root root 4096 Dec  6 07:11 2.6.18-92.1.18.el5
    [root@linux linux-2.6.18.i686]# make modules_install

And here is the same directory after. Notice that `make modules_install`
created a new directory for the new kernel.

    [root@linux linux-2.6.18.i686]# ls -l /lib/modules/
    total 24
    drwxr-xr-x 6 root root 4096 Oct 15 13:09 2.6.18-92.1.13.el5
    drwxr-xr-x 6 root root 4096 Nov 11 08:51 2.6.18-92.1.17.el5
    drwxr-xr-x 6 root root 4096 Dec  6 07:11 2.6.18-92.1.18.el5
    drwxr-xr-x 3 root root 4096 Dec  6 08:50 2.6.18-paul2008

## /boot

We still need to copy the kernel, the System.map and our configuration
file to /boot. Strictly speaking the .config file is not obligatory, but
it might help you in future compilations of the kernel.

    [root@linux ]# pwd
    /usr/src/redhat/BUILD/kernel-2.6.18/linux-2.6.18.i686
    [root@linux ]# cp System.map /boot/System.map-2.6.18-paul2008
    [root@linux ]# cp .config /boot/config-2.6.18-paul2008
    [root@linux ]# cp arch/i386/boot/bzImage /boot/vmlinuz-2.6.18-paul2008

## mkinitrd

The kernel often uses an initrd file at bootup. We can use
`mkinitrd` to generate this file. Make sure you use the
correct kernel name!

    [root@linux ]# pwd
    /usr/src/redhat/BUILD/kernel-2.6.18/linux-2.6.18.i686
    [root@linux ]# mkinitrd /boot/initrd-2.6.18-paul2008 2.6.18-paul2008

## bootloader

Compilation is now finished, don\'t forget to create an additional
stanza in grub or lilo.

