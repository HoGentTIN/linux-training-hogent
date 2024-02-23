# compiling one module

## hello.c

A little C program that will be our module.

    [root@linux kernel_module]# cat hello.c 
    #include <linux/module.h>
    #include <section>
                
    int init_module(void)
    {
        printk(KERN_INFO "Start Hello World...\n");
        return 0;
    }
                
    void cleanup_module(void)
    {
        printk(KERN_INFO "End Hello World... \n");
    }

## Makefile

The make file for this module.

    [root@linux kernel_module]# cat Makefile 
    obj-m += hello.o
    all:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
    clean:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

These are the only two files needed.

    [root@linux kernel_module]# ll
    total 16
    -rw-rw-r--  1 paul paul 250 Feb 15 19:14 hello.c
    -rw-rw-r--  1 paul paul 153 Feb 15 19:15 Makefile

## make

The running of the `make` command.

    [root@linux kernel_module]# make
    make -C /lib/modules/2.6.9-paul-2/build M=~/kernel_module modules
    make[1]: Entering dir... `/usr/src/redhat/BUILD/kernel-2.6.9/linux-2.6.9'
    CC [M]  /home/paul/kernel_module/hello.o
    Building modules, stage 2.
    MODPOST
    CC      /home/paul/kernel_module/hello.mod.o
    LD [M]  /home/paul/kernel_module/hello.ko
    make[1]: Leaving dir... `/usr/src/redhat/BUILD/kernel-2.6.9/linux-2.6.9'
    [root@linux kernel_module]#

Now we have more files.

    [root@linux kernel_module]# ll
    total 172
    -rw-rw-r--  1 paul paul   250 Feb 15 19:14 hello.c
    -rw-r--r--  1 root root 64475 Feb 15 19:15 hello.ko
    -rw-r--r--  1 root root   632 Feb 15 19:15 hello.mod.c
    -rw-r--r--  1 root root 37036 Feb 15 19:15 hello.mod.o
    -rw-r--r--  1 root root 28396 Feb 15 19:15 hello.o
    -rw-rw-r--  1 paul paul   153 Feb 15 19:15 Makefile
    [root@linux kernel_module]#

## hello.ko

Use `modinfo` to verify that it is really a module.

    [root@linux kernel_module]# modinfo hello.ko 
    filename:       hello.ko
    vermagic:       2.6.9-paul-2 SMP 686 REGPARM 4KSTACKS gcc-3.4
    depends:        
    [root@linux kernel_module]#

Good, so now we can load our hello module.

    [root@linux kernel_module]# lsmod | grep hello
    [root@linux kernel_module]# insmod ./hello.ko
    [root@linux kernel_module]# lsmod | grep hello
    hello                   5504  0 
    [root@linux kernel_module]# tail -1 /var/log/messages 
    Feb 15 19:16:07 RHEL8a kernel: Start Hello World...
    [root@linux kernel_module]# rmmod hello
    [root@linux kernel_module]#

Finally `/var/log/messages` has a little surprise.

    [root@linux kernel_module]# tail -2 /var/log/messages 
    Feb 15 19:16:07 RHEL8a kernel: Start Hello World...
    Feb 15 19:16:35 RHEL8a kernel: End Hello World... 
    [root@linux kernel_module]#

