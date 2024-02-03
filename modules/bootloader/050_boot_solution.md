## solution: bootloader

0\. Find out whether your system is using lilo, grub or grub2. Only do
the practices that are appropriate for your system.

1\. Make a copy of the kernel, initrd and System.map files in /boot. Put
the copies also in /boot but replace 2.x or 3.x with 4.0 (just imagine
that Linux 4.0 is out.).

    [root@centos65 boot]# uname -r
    2.6.32-431.11.2.el6.x86_64
    [root@centos65 boot]# cp System.map-2.6.32-431.11.2.el6.x86_64 System.map-4.0
    [root@centos65 boot]# cp vmlinuz-2.6.32-431.11.2.el6.x86_64 vmlinuz-4.0
    [root@centos65 boot]# cp initramfs-2.6.32-431.11.2.el6.x86_64.img initramfs-4.0\
    .img

Do not forget that the initrd (or initramfs) file ends in `.img` .

2\. Add a stanza in grub for the 4.0 files. Make sure the title is
different.

    [root@centos65 grub]# cut -c1-70 menu.lst | tail -12
    title CentOS (4.0)
            root (hd0,0)
            kernel /vmlinuz-4.0 ro root=/dev/mapper/VolGroup-lv_root rd_NO_LUKS L
            initrd /initramfs-4.0.img
    title CentOS (2.6.32-431.11.2.el6.x86_64)
            root (hd0,0)
            kernel /vmlinuz-2.6.32-431.11.2.el6.x86_64 ro root=/dev/mapper/VolGro
            initrd /initramfs-2.6.32-431.11.2.el6.x86_64.img
    title CentOS (2.6.32-431.el6.x86_64)
            root (hd0,0)
            kernel /vmlinuz-2.6.32-431.el6.x86_64 ro root=/dev/mapper/VolGroup-lv
            initrd /initramfs-2.6.32-431.el6.x86_64.img
    [root@centos65 grub]#

3\. Set the boot menu timeout to 30 seconds.

    [root@centos65 grub]# vi menu.lst
    [root@centos65 grub]# grep timeout /boot/grub/grub.conf
    timeout=30

4\. Reboot and test the new stanza.

    [root@centos65 grub]# reboot

![](../images/grub1_centos.png)

Select your stanza and if it boots then you did it correct.

