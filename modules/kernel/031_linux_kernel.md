# about the Linux kernel

## kernel versions

In 1991 Linus Torvalds wrote (the first version of) the Linux kernel. He
put it online, and other people started contributing code. Over 4000
individuals contributed source code to the latest kernel release
(version 2.6.27 in November 2008).

Major Linux kernel versions used to come in even and odd numbers.
Versions `2.0`, `2.2`, `2.4` and `2.6` are considered stable kernel
versions. Whereas `2.1`, `2.3` and `2.5` were unstable (read
development) versions. Since the release of 2.6.0 in January 2004, all
development has been done in the 2.6 tree. There is currently no v2.7.x
and according to Linus the even/stable vs odd/development scheme is
abandoned forever.

## uname -r

To see your current Linux kernel version, issue the
`uname -r` command as shown below.

This first example shows Linux major version `2.6` and minor version
`24`. The rest `-22-generic` is specific to the distribution (Ubuntu in
this case).

    paul@laika:~$ uname -r
    2.6.24-22-generic

The same command on Red Hat Enterprise Linux shows an older kernel
(2.6.18) with `-92.1.17.el5` being specific to the distribution.

    [paul@RHEL52 ~]$ uname -r
    2.6.18-92.1.17.el5

## /proc/cmdline

The parameters that were passed to the kernel at boot time are in
`/proc/cmdline`.

    paul@RHELv8u4:~$ cat /proc/cmdline 
    ro root=/dev/VolGroup00/LogVol00 rhgb quiet

## single user mode

When booting the kernel with the `single` parameter, it starts in
`single user mode`. Linux can start in a bash shell with
the `root` user logged on (without password).

Some distributions prevent the use of this feature (at kernel compile
time).

## init=/bin/bash

Normally the kernel invokes `init` as the first daemon process. Adding
`init=/bin/bash` to the kernel parameters will instead
invoke bash (again with root logged on without providing a password).

## /var/log/messages

The kernel reports during boot to `syslog` which writes a
lot of kernel actions in `/var/log/messages`. Looking at
this file reveals when the kernel was started, including all the devices
that were detected at boot time.

    [root@RHEL53 ~]# grep -A16 "syslogd 1.4.1:" /var/log/messages|cut -b24-
    syslogd 1.4.1: restart.
    kernel: klogd 1.4.1, log source = /proc/kmsg started.
    kernel: Linux version 2.6.18-128.el5 (mockbuild@hs20-bc1-5.build.red...
    kernel: BIOS-provided physical RAM map:
    kernel:  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
    kernel:  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
    kernel:  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
    kernel:  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
    kernel:  BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
    kernel:  BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
    kernel:  BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
    kernel:  BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
    kernel:  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
    kernel:  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
    kernel:  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
    kernel: 0MB HIGHMEM available.
    kernel: 512MB LOWMEM available.

This example shows how to use `/var/log/messages` to see kernel
information about `/dev/sda`.

    [root@RHEL53 ~]# grep sda /var/log/messages | cut -b24-
    kernel: SCSI device sda: 41943040 512-byte hdwr sectors (21475 MB)
    kernel: sda: Write Protect is off
    kernel: sda: cache data unavailable
    kernel: sda: assuming drive cache: write through
    kernel: SCSI device sda: 41943040 512-byte hdwr sectors (21475 MB)
    kernel: sda: Write Protect is off
    kernel: sda: cache data unavailable
    kernel: sda: assuming drive cache: write through
    kernel:  sda: sda1 sda2
    kernel: sd 0:0:0:0: Attached scsi disk sda
    kernel: EXT3 FS on sda1, internal journal

## dmesg

The `dmesg` command prints out all the kernel bootup messages (from the
last boot).

    [root@RHEL53 ~]# dmesg | head
    Linux version 2.6.18-128.el5 (mockbuild@hs20-bc1-5.build.redhat.com)
    BIOS-provided physical RAM map:
     BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
     BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
     BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
     BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
     BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
     BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
     BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
     BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)

Thus to find information about /dev/sda, using `dmesg`
will yield only kernel messages from the last boot.

    [root@RHEL53 ~]# dmesg | grep sda
    SCSI device sda: 41943040 512-byte hdwr sectors (21475 MB)
    sda: Write Protect is off
    sda: Mode Sense: 5d 00 00 00
    sda: cache data unavailable
    sda: assuming drive cache: write through
    SCSI device sda: 41943040 512-byte hdwr sectors (21475 MB)
    sda: Write Protect is off
    sda: Mode Sense: 5d 00 00 00
    sda: cache data unavailable
    sda: assuming drive cache: write through
     sda: sda1 sda2
    sd 0:0:0:0: Attached scsi disk sda
    EXT3 FS on sda1, internal journal
