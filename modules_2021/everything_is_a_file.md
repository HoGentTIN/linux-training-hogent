# Everything is a file

## commands are files

When we look at a command with **ls -l**, then we see that the first
character is a **-** . This **-** signifies that the file is a regular
file. Many commands are regular files, even the bash shell is a regular
file.

    paul@debian10:~$ ls -l $(which cp)
    -rwxr-xr-x 1 root root 146880 Feb 28 16:30 /usr/bin/cp
    paul@debian10:~$ ls -l $(which bash)
    -rwxr-xr-x 1 root root 1168776 Apr 18 06:12 /usr/bin/bash
    paul@debian10:~$

## directories are files

Directories are a special kind of file, but they are files nonetheless
(you can open a directory in **vi**, though I wouldn’t recommend
changing anything). Directories start with a **d** in an **ls -l**
listing.

    paul@debian10:~$ ls -ld backup/
    drwxr-xr-x 2 paul paul 4096 Aug 13 16:52 backup/
    paul@debian10:~$ ls -ld .
    drwxr-xr-x 10 paul paul 4096 Aug 13 16:52 .
    paul@debian10:~$

## terminals are files


You can issue the **who am i** command to see the terminal on which you
are logged on. A terminal window is a character device (its input and/or
output are a stream of characters). Character devices start with a **c**
in the output of **ls -l**.

    paul@debian10:~$ who am i
    paul     pts/0        2019-08-13 12:49 (192.168.56.1)
    paul@debian10:~$ ls -l /dev/pts/0
    crw------- 1 paul tty 136, 0 Aug 13 16:57 /dev/pts/0
    paul@debian10:~$ ls -l /dev/tty1
    crw------- 1 root tty 4, 1 Aug 13 12:33 /dev/tty1
    paul@debian10:~$

## block devices are files


In Debian 10 Linux any block device will get a corresponding file in
**/dev**. So the hard disk, even an SSD, a USB stick, and the CD-ROM
will be visible as a block device. The screenshot shows that the first
hard disk, the first partition and the CD-ROM in this computer are
**b**lock devices.

    paul@debian10:~$ ls -l /dev/sda /dev/sda1 /dev/sr0
    brw-rw---- 1 root disk   8, 0 Aug 13 10:41 /dev/sda
    brw-rw---- 1 root disk   8, 1 Aug 13 10:41 /dev/sda1
    brw-rw---- 1 root cdrom 11, 0 Aug 13 10:41 /dev/sr0
    paul@debian10:~$

A **block device** has an address for each block. An addressed block can
be retrieved or written to, this is the opposite of the continuous
stream of a **character device**.

Behind each character or block device is a kernel device driver.

## symbolic links are files

Symbolic links will be explained later in this book, but we can already
say that a symlink is also a file. There are many **symbolic links** on
a Linux computer.

    paul@debian10:/lib$ find /usr/lib -exec ls -l {} \; 2>/dev/null | grep ^l | head -3
    lrwxrwxrwx  1 root root    21 Aug 12 19:01 cpp -> /etc/alternatives/cpp
    lrwxrwxrwx  1 root root    20 Jan 14  2018 libdiscover.so.2 -> libdiscover.so.2.0.1
    lrwxrwxrwx  1 root root    19 Apr  8 12:13 sftp-server -> openssh/sftp-server
    paul@debian10:/lib$

## pipes are files


A **pipe** can be used as way to communicate between processes. We will
introduce **named pipes** in the processes chapter. They can be
recognised by the letter **p** in **ls -l**. There aren’t many **named
pipes** on a default Debian 10.

    paul@debian10:/lib$ find / -exec ls -l {} \; 2>/dev/null | grep ^p
    prw-------  1 root root    0 Aug 13 10:41 initctl
    prw------- 1 root root 0 Aug 13 10:41 /run/initctl
    prw------- 1 root root   0 Aug 13 12:32 12.ref
    prw------- 1 root root   0 Aug 13 12:49 16.ref
    prw------- 1 root root 0 Aug 13 12:49 /run/systemd/sessions/16.ref
    prw------- 1 root root 0 Aug 13 12:32 /run/systemd/sessions/12.ref
    paul@debian10:/lib$

The above is a very slow **find** command, because it does an **ls -l**
on every file.

## IPC sockets are files


Linux domain sockets can be used by processes for inter-process
communication. For example the **systemd-journald** will listen to
**/run/systemd/journal/dev-log**, which is a socket.

    paul@debian10:/lib$ ls -l /dev/log
    lrwxrwxrwx 1 root root 28 Aug 13 10:41 /dev/log -> /run/systemd/journal/dev-log
    paul@debian10:/lib$ ls -l /run/systemd/journal/dev-log
    srw-rw-rw- 1 root root 0 Aug 13 10:41 /run/systemd/journal/dev-log
    paul@debian10:/lib$

## Summary

Below is a table of all the Linux special files that can be recognised
by the first character of an **ls -l** command. Note that we did not
discuss a **door** because it does not exist in Debian 10.

<table style="width:60%;">
<caption>List special files</caption>
<colgroup>
<col style="width: 24%" />
<col style="width: 36%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>first character</p></td>
<td style="text-align: left;"><p>special file type</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>regular file</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>d</p></td>
<td style="text-align: left;"><p>directory</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>l</p></td>
<td style="text-align: left;"><p>symbolic link</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>named pipe</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>b</p></td>
<td style="text-align: left;"><p>block device</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>c</p></td>
<td style="text-align: left;"><p>character device</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>s</p></td>
<td style="text-align: left;"><p>IPC socket</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>D</p></td>
<td style="text-align: left;"><p>door (Created by Solaris or Linux
kernel 2.4.18.)</p></td>
</tr>
</tbody>
</table>

List special files

This list is very similar to the **-type** option of the **find**
command. Note however the difference for regular files.

<table style="width:60%;">
<caption>Find special files</caption>
<colgroup>
<col style="width: 24%" />
<col style="width: 36%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>find -type option</p></td>
<td style="text-align: left;"><p>special file type</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>f</p></td>
<td style="text-align: left;"><p>regular file</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>d</p></td>
<td style="text-align: left;"><p>directory</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>l</p></td>
<td style="text-align: left;"><p>symbolic link</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>named pipe</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>b</p></td>
<td style="text-align: left;"><p>block device</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>c</p></td>
<td style="text-align: left;"><p>character device</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>s</p></td>
<td style="text-align: left;"><p>IPC socket</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>D</p></td>
<td style="text-align: left;"><p>door</p></td>
</tr>
</tbody>
</table>

Find special files

## Cheat sheet

<table>
<caption>Everything is a file</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>first character in ls -l</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>This file is a regular file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>d</p></td>
<td style="text-align: left;"><p>This is a directory.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>c</p></td>
<td style="text-align: left;"><p>This is a character device.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>b</p></td>
<td style="text-align: left;"><p>This is a block device.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>l</p></td>
<td style="text-align: left;"><p>This is a symbolic link.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>This is a named pipe.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>s</p></td>
<td style="text-align: left;"><p>This is a socket.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>D</p></td>
<td style="text-align: left;"><p>This is a door (cannot be created on
Debian 10, but some commands like <strong>find</strong> have options for
it).</p></td>
</tr>
</tbody>
</table>

Everything is a file

## Practice

1.  Log on twice with the same user on the same computer and identify
    the terminal in each.

2.  Use **echo** to send a message from one terminal to the other, as if
    it was a file.

3.  List all character devices in **/dev**.

4.  Compare the output of **lsblk** with **ls -l /dev | grep ^b** .

5.  Is **/run/initctl** a pipe?

## Solution

1.  Log on twice with the same user on the same computer and identify
    the terminal in each.

        who am i

2.  Use **echo** to send a message from one terminal to the other, as if
    it was a file.

        echo hello > /dev/pts/1

3.  List all character devices in **/dev**.

        ls -l /dev | grep ^c

4.  Compare the output of **lsblk** with **ls -l /dev | grep ^b** .

        lsblk
        ls -l /dev | grep ^b

5.  Is **/run/initctl** a pipe?

        ls -l /run/initctl
