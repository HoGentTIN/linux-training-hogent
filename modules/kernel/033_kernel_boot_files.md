# kernel boot files

## vmlinuz

The `vmlinuz` file in /boot is the compressed kernel.

    student@linux:~$ ls -lh /boot | grep vmlinuz
    -rw-r--r-- 1 root root 1.2M 2006-03-06 16:22 vmlinuz-2.6.15-1-486
    -rw-r--r-- 1 root root 1.1M 2006-03-06 16:30 vmlinuz-2.6.15-1-686
    -rw-r--r-- 1 root root 1.3M 2008-02-11 00:00 vmlinuz-2.6.18-6-686
    student@linux:~$

## initrd

The kernel uses `initrd` (an initial RAM disk) at boot
time. The initrd is mounted before the kernel loads, and can contain
additional drivers and modules. It is a `compressed cpio archive`, so
you can look at the contents in this way.

    root@linux:/boot# mkdir /mnt/initrd
    root@linux:/boot# cp initrd-2.6.9-42.0.3.EL.img TMPinitrd.gz
    root@linux:/boot# gunzip TMPinitrd.gz 
    root@linux:/boot# file TMPinitrd 
    TMPinitrd: ASCII cpio archive (SVR4 with no CRC)
    root@linux:/boot# cd /mnt/initrd/
    root@linux:/mnt/initrd# cpio -i | /boot/TMPinitrd 
    4985 blocks
    root@linux:/mnt/initrd# ls -l
    total 76
    drwxr-xr-x  2 root root 4096 Feb  5 08:36 bin
    drwxr-xr-x  2 root root 4096 Feb  5 08:36 dev
    drwxr-xr-x  4 root root 4096 Feb  5 08:36 etc
    -rwxr-xr-x  1 root root 1607 Feb  5 08:36 init
    drwxr-xr-x  2 root root 4096 Feb  5 08:36 lib
    drwxr-xr-x  2 root root 4096 Feb  5 08:36 loopfs
    drwxr-xr-x  2 root root 4096 Feb  5 08:36 proc
    lrwxrwxrwx  1 root root    3 Feb  5 08:36 sbin -> bin
    drwxr-xr-x  2 root root 4096 Feb  5 08:36 sys
    drwxr-xr-x  2 root root 4096 Feb  5 08:36 sysroot
    root@linux:/mnt/initrd#

## System.map

The `System.map` contains the symbol table and changes
with every kernel compile. The symbol table is also present in
`/proc/kallsyms` (pre 2.6 kernels name this file
/proc/ksyms).

    root@linux:/boot# head System.map-`uname -r`
    00000400 A __kernel_vsyscall
    0000041a A SYSENTER_RETURN_OFFSET
    00000420 A __kernel_sigreturn
    00000440 A __kernel_rt_sigreturn
    c0100000 A _text
    c0100000 T startup_32
    c01000c6 t checkCPUtype
    c0100147 t is486
    c010014e t is386
    c010019f t L6
    root@linux:/boot# head /proc/kallsyms 
    c0100228 t _stext
    c0100228 t calibrate_delay_direct
    c0100228 t stext
    c0100337 t calibrate_delay
    c01004db t rest_init
    c0100580 t do_pre_smp_initcalls
    c0100585 t run_init_process
    c01005ac t init
    c0100789 t early_param_test
    c01007ad t early_setup_test
    root@linux:/boot#

## .config

The last file copied to the /boot directory is the kernel configuration
used for compilation. This file is not necessary in the /boot directory,
but it is common practice to put a copy there. It allows you to
recompile a kernel, starting from the same configuration as an existing
working one.

