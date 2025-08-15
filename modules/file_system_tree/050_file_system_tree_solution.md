## solution: file system tree

1. Does the file `/bin/cat` exist ? What about `/bin/dd` and
`/bin/echo`. What is the type of these files ?

    ls /bin/cat ; file /bin/cat

    ls /bin/dd ; file /bin/dd

    ls /bin/echo ; file /bin/echo

2. What is the size of the Linux kernel file(s) (vmlinu\*) in `/boot` ?

    ls -lh /boot/vm*

3. Create a directory ~/test. Then issue the following commands:

    cd ~/test

    dd if=/dev/zero of=zeroes.txt count=1 bs=100

    od zeroes.txt

`dd` will copy one times (count=1) a block of size 100 bytes (bs=100)
from the file `/dev/zero` to ~/test/zeroes.txt. Can you describe the
functionality of `/dev/zero` ?

`/dev/zero` is a Linux special device. It can be
considered a source of zeroes. You cannot send something to `/dev/zero`,
but you can read zeroes from it.

4. Now issue the following command:

    dd if=/dev/random of=random.txt count=1 bs=100 ; od random.txt

`dd` will copy one times (count=1) a block of size 100 bytes (bs=100)
from the file `/dev/random` to ~/test/random.txt. Can you describe the
functionality of `/dev/random` ?

`/dev/random` acts as a
`random number generator` on your Linux machine.

5. Issue the following two commands, and look at the first character of
each output line.

    ls -l /dev/sd* /dev/hd*

    ls -l /dev/tty* /dev/input/mou*

The first ls will show block(b) devices, the second ls shows
character(c) devices. Can you tell the difference between block and
character devices ?

Block devices are always written to (or read from) in blocks. For hard
disks, blocks of 512 bytes are common. Character devices act as a stream
of characters (or bytes). Mouse and keyboard are typical character
devices.

6. Use cat to display `/etc/hosts` and `/etc/resolv.conf`. What is your
idea about the purpose of these files ?

    /etc/hosts/etc/hosts contains hostnames with their ip address

    /etc/resolv.conf/etc/resolv.conf should contain the ip address of a DNS name server.

7. Are there any files in `/etc/skel/` ? Check also for hidden files.

    Issue "ls -al /etc/skel/". Yes, there should be hidden files there.

8. Display `/proc/cpuinfo`. On what architecture is your Linux running
?

    The file should contain at least one line with Intel or other cpu.

9. Display `/proc/interrupts`. What is the size of this file ? Where is
this file stored ?

The size is zero, yet the file contains data. It is not stored anywhere
because /proc is a virtual file system that allows you to talk with the
kernel. (If you answered \"stored in RAM-memory, that is also
correct...).

10. Can you enter the `/root` directory ? Are there (hidden) files ?

    Try "cd /root". The /root directory is not accessible for normal users on most modern Linux systems.

11. Are ifconfig, fdisk, parted, shutdown and grub-install present in
`/sbin` ? Why are these binaries in `/sbin` and not in /bin ?

    Because those files are only meant for system administrators.

12. Is `/var/log` a file or a directory ? What about `/var/spool` ?

    Both are directories.

13. Open two command prompts (Ctrl-Shift-T in gnome-terminal) or
terminals (Ctrl-Alt-F1, Ctrl-Alt-F2, ...) and issue the `who am i` in
both. Then try to echo a word from one terminal to the other.

    tty-terminal: echo Hello > /dev/tty1

    pts-terminal: echo Hello > /dev/pts/1

14. Read the man page of `random` and explain the difference between
`/dev/random` and `/dev/urandom`.

    man 4 random

