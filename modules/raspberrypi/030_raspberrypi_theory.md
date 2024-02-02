## buying the hardware

This picture shows four `Raspberry Pi's`. The two on the left are made
in UK, those on the right are made in China. I noticed no difference in
using them.

![](images/raspberrypi_fourpis.jpg)

The `Raspberry Pi` is advertised as a \'30 euro computer\'. This is not
a lie, but many people will end up spending around 50 euro for each
fully working and connected `Raspberry Pi`.

Besides the obvious `Raspberry Pi board` you will also need an
`sd card`, a `utp ethernet cable` and a `micro usb cable` connected to a
`power adapter` or powered usb port.

I recommend buying `class 10 sd cards` because they are faster than
cheap sd cards. Below a picture that shows four class 10 cards; one
micro sd (left) and three regular ones.

![](images/raspberrypi_sd_cards.jpg)

For this project I will demonstrate two `Linux distributions` so I chose
to label the cards.

![](images/raspberrypi_sd_cards_labeled.jpg)

I will use the usb cable and power adapter from my old HTC Hero
smartphone to power the `Raspberry Pi`.

## downloading the images

Download two images from `http://raspberrypi.org/downloads`. In this
module I continue with the `raspbian` and the `pidora` images.

![](images/raspberrypi_downloads.png)

This download may take a couple minutes to complete\...

![](images/raspberrypi_downloading.png)

After the download, you will have two zipfiles in `/tmp`.

    paul@debian10:~$ ls -lh /tmp/*.zip
    -rw-r--r-- 1 paul paul 788M Jul 26 20:53 /tmp/2014-06-20-wheezy-raspbian.zip
    -rw-r--r-- 1 paul paul 549M Jul 26 20:51 /tmp/Pidora-2014-R2-1.zip
    paul@debian10:~$

## writing the SD cards

Find out the devicename of your SD card.

    root@debian10:~# dmesg | tail -2 | cut -c9-
    30238] sd 1:0:0:0: [sdb] 15644672 512-byte logical blocks: (8.01 GB/7.45 GiB)
    33843]  sdb: sdb1
    root@debian10:~#

Be very careful not to overwrite the wrong device! In my case it says
`sdb`. This can be different for you!

I choose to `unzip` the downloaded file with the `-p` switch to send the
unzipped data to `stdout` so it can be captured bu `dd` and written to
the SD card device (without creating the intermediate unzipped file).

    root@debian10:~# unzip -p /tmp/2014-06-20-wheezy-raspbian.zip | dd of=/dev/sdb

This command will take a couple of minutes. Here is the output from
`top -b` with relation to the unzipping and writing to the device (taken
on a 2013 Macbook Pro Retina).

     PID USER    PR  NI   VIRT    RES   SHR S  %CPU %MEM    TIME+ COMMAND
     123 root    20   0      0      0     0 D   6.6  0.0  0:16.40 usb-storage
    8877 root    20   0   8992   1644   572 S   6.6  0.0  0:33.09 unzip
    8878 root    20   0   5816    648   556 D   0.0  0.0  0:17.85 dd

This is the output from `dd`.

    root@debian10:~# unzip -p /tmp/2014-06-20-wheezy-raspbian.zip | dd of=/dev/sdb
    5785600+0 records in
    5785600+0 records out
    2962227200 bytes (3.0 GB) copied, 615.552 s, 4.8 MB/s

Using `fdisk -l /dev/sdb` gives a quick check whether the image was
written to the SD card.

    root@debian10:~# fdisk -l /dev/sdb

    Disk /dev/sdb: 8010 MB, 8010072064 bytes
    247 heads, 62 sectors/track, 1021 cylinders, total 15644672 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x000b5098

       Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1            8192      122879       57344    c  W95 FAT32 (LBA)
    /dev/sdb2          122880     5785599     2831360   83  Linux

## adjusting network settings

We will configure the network before inserting the `sd card` in the
`Raspberry Pi`. To do this we will mount the Linux partition and edit
`/etc/network/interfaces`.

    root@debian10:~# mount /dev/sdb2 /mnt
    root@debian10:~# vi /mnt/etc/network/interfaces

Check the chapters in Debian network configuration if you don\'t know
what to do with this file. I added four lines (in bold below) to give
this `Pi` a unique address in my ghost network (when connected via
ethernet cable).

    root@debian10:~# cat /mnt/etc/network/interfaces
    auto lo

    iface lo inet loopback
    iface eth0 inet dhcp

    auto eth0:0
    iface eth0:0 inet static
    address 192.168.42.54
    netmask 255.255.255.0

    allow-hotplug wlan0
    iface wlan0 inet manual
    wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
    iface default inet dhcp

## connecting the hardware

Besides a `Raspberry Pi`, we also use a network utp cable, the sd card
labeled `raspbian` and a usb power source (I use the adapter and usb
cable from my old HTC Hero phone).

Connect the usb power last. The end result will look something like this
picture.

![](images/raspberrypi.png)

## connecting with ssh

First we try to ping the device. I use my ghost network address. The
`Pi` also received an address from the DHCP server, so if you have
access to the DHCP leases you can also use that address.

    paul@debian10:~$ ping 192.168.42.54
    PING 192.168.42.54 (192.168.42.54) 56(84) bytes of data.
    64 bytes from 192.168.42.54: icmp_seq=1 ttl=64 time=0.577 ms
    64 bytes from 192.168.42.54: icmp_seq=2 ttl=64 time=0.627 ms
    ^C
    --- 192.168.42.54 ping statistics ---
    2 packets transmitted, 2 received, 0% packet loss, time 999ms
    rtt min/avg/max/mdev = 0.577/0.602/0.627/0.025 ms

Success, the `Pi` replies to the ping request.

Now we login with the user `raspberry` and the password `pi`.

    paul@debian10:~$ ssh pi@192.168.42.54
    The authenticity of host '192.168.42.54 (192.168.42.54)' can't be established.
    ECDSA key fingerprint is a7:9b:bf:7f:00:12:b0:f0:93:f8:09:ad:32:1d:29:57.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '192.168.42.54' (ECDSA) to the list of known hosts.
    pi@192.168.42.54's password:
    Linux raspberrypi 3.12.22+ #691 PREEMPT Wed Jun 18 18:29:58 BST 2014 armv6l

    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Sun Jul 27 15:47:20 2014 from 192.168.1.35

    NOTICE: the software on this Raspberry Pi has not been fully configured. Plea\
    se run 'sudo raspi-config'

    pi@raspberrypi ~ $

![](images/raspberrypi.png)

## camera module

There is a cheap HD camera module for the raspberry pi. In this picture
the module is connected.

To disble the camera led:

    disable_camera_led=1 in /boot/config.txt

![](images/raspberrypi_camera_connect.jpg)

## 

![](images/raspberrypi.png)

## building a stack of pi\'s

Here are some pictures of a `Raspberry Pi` stack held together by Lego
Technic.

![](images/raspberrypi_legostack.jpg)

## sending mail from the pi

install exim4

enter a smarthost in update-exim4.conf.conf

dpkg-reconfigure exim4-config (smarthost)

    root@raspicam1:~# cat /etc/exim4/update-exim4.conf.conf
    # /etc/exim4/update-exim4.conf.conf
    #
    # Edit this file and /etc/mailname by hand and execute update-exim4.conf
    # yourself or use 'dpkg-reconfigure exim4-config'
    #
    # Please note that this is _not_ a dpkg-conffile and that automatic changes
    # to this file might happen. The code handling this will honor your local
    # changes, so this is usually fine, but will break local schemes that mess
    # around with multiple versions of the file.
    #
    # update-exim4.conf uses this file to determine variable values to generate
    # exim configuration macros for the configuration file.
    #
    # Most settings found in here do have corresponding questions in the
    # Debconf configuration, but not all of them.
    #
    # This is a Debian specific file

    dc_eximconfig_configtype='satellite'
    dc_other_hostnames='raspberrypi'
    dc_local_interfaces='127.0.0.1 ;'
    dc_readhost='netsec.be'
    dc_relay_domains=''
    dc_minimaldns='true'
    dc_relay_nets=''
    dc_smarthost='smtp.telenet.be'
    CFILEMODE='644'
    dc_use_split_config='false'
    dc_hide_mailname='true'
    dc_mailname_in_oh='true'
    dc_localdelivery='mail_spool'
    root@raspicam1:~#

    mail -s "test2" paul.cobbaut@gmail.com

## disable ipv6

    root@raspberrypi:~# tail -3 /etc/sysctl.conf

    # Disable IPv6
    net.ipv6.conf.all.disable_ipv6 = 1
    root@raspberrypi:~#

## 

## 

## 
