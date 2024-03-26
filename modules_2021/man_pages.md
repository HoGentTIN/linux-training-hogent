# Manual pages

## man


Most Linux commands come with an excellent manual in the form of a **man
page**. This **man page** can usually be accessed by typing **man**
followed by the command. The example below enters the **man page** of
the **tail** command.

    paul@debian10:~$ man tail
    TAIL(1)                              User Commands                              TAIL(1)

    NAME
           tail - output the last part of files

    SYNOPSIS
           tail [OPTION]... [FILE]...

    DESCRIPTION
    output truncated

When inside the man page, you have several options that are the same as
when using the **more** command.

<table style="width:70%;">
<caption>man page keys</caption>
<colgroup>
<col style="width: 35%" />
<col style="width: 35%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>key</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>enter</p></td>
<td style="text-align: left;"><p>continue one line</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>space bar</p></td>
<td style="text-align: left;"><p>next page</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>q</p></td>
<td style="text-align: left;"><p>quit</p></td>
</tr>
</tbody>
</table>

man page keys

On Debian 10 you can also use the arrow keys to browse up and down in
the **man page**.

## Searching the man page

You can use the slash key **"/"** to search for strings in the **man
page**. The **/** will appear at the bottom of the screen. The search is
case insensitive by default. You can jump to the next occurrence using
the **n** key and to the previous occurrence using the **p** key. And
remember type **q** to quit the **man page**.

<table style="width:70%;">
<caption>man page keys</caption>
<colgroup>
<col style="width: 35%" />
<col style="width: 35%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>key</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/string</p></td>
<td style="text-align: left;"><p>search for string</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>n</p></td>
<td style="text-align: left;"><p>jump to next occurrence of
string</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>jump to previous occurrence of
string</p></td>
</tr>
</tbody>
</table>

man page keys

## man man

There is a **man page** for the **man** command itself. In this (rather
long) **man page** you can read about different sections (see the
screenshot below).

           The table below shows the section numbers of the manual followed by the types of
           pages they contain.

           1   Executable programs or shell commands
           2   System calls (functions provided by the kernel)
           3   Library calls (functions within program libraries)
           4   Special files (usually found in /dev)
           5   File formats and conventions eg /etc/passwd
           6   Games
           7   Miscellaneous  (including  macro  packages  and  conventions),  e.g. man(7),
               groff(7)
           8   System administration commands (usually only for root)
           9   Kernel routines [Non standard]

The vast majority of **man page** readings for a system administrator
will involve either **section 1** on commands or **section 5** on files,
and the correct section will automatically be chosen.

But there are cases where there is a command and a file with the same
name. This is the case for example with the **passwd** command and the
**passwd** file. To select the correct **man page** you can type the
section as an argument.

The following command opens the **man page** for the **passwd**
*command*.

    paul@debian10:~$ man 1 passwd
    PASSWD(1)                            User Commands                            PASSWD(1)

    NAME
           passwd - change user password

    SYNOPSIS
           passwd [options] [LOGIN]

    DESCRIPTION
    output truncated

And here we show how to open the **man page** for the **passwd** *file*.

    paul@debian10:~$ man 5 passwd
    PASSWD(5)                     File Formats and Conversions                    PASSWD(5)

    NAME
           passwd - the password file

    DESCRIPTION
    output truncated

## apropos


It can happen that you are looking for a **man page** or even a
**command** but you forgot the exact name. Then the **apropos** command
can help you. In the example below we use **apropos** to discover
commands related to **USB** devices.

    paul@debian10:~$ apropos usb
    lsusb (8)            - list USB devices
    usb-devices (1)      - print USB device details
    usbhid-dump (8)      - dump USB HID device report descriptors and streams
    paul@debian10:~$

The **apropos** command will do a case insensitive search in the name
and the short description of all **man pages**.

Typing **apropos** is identical to typing **man -k**.

## man -wK


If you want to search the content of all man pages, then you can use
**man -wK**. Because this can take a long time, it is advised to limit
the search to one section. The screenshot below demonstrates searching
section 1 for the string **SIGHUP**.

    paul@debian10:~$ man -wK -s 1 SIGHUP
    /usr/share/man/man1/bash.1.gz
    /usr/share/man/man1/systemd-run.1.gz
    /usr/share/man/man1/systemd.1.gz
    /usr/share/man/man1/nano.1.gz
    /usr/share/man/man1/nano.1.gz
    /usr/share/man/man1/nano.1.gz
    /usr/share/man/man1/tar.1.gz
    /usr/share/man/man1/dbus-daemon.1.gz
    paul@debian10:~$

## whatis


You can use the **whatis** command to see the short description of
**files** or **commands**. The example shows the short description of
the **head** command and of the **services** file.

    paul@debian10:~$ whatis head
    head (1)             - output the first part of files
    paul@debian10:~$ whatis services
    services (5)         - Internet network services list
    paul@debian10:~$

## whereis


You can find the location of **commands** and **files** and their
respective **man pages** in the file system with the **whereis**
command. The example does this for the **tail** command and for the
**lsusb** command.

Notice that the **man page** is stored as a gzipped **.gz** file.

    paul@debian10:~$ whereis tail
    tail: /usr/bin/tail /usr/share/man/man1/tail.1.gz
    paul@debian10:~$ whereis lsusb
    lsusb: /usr/bin/lsusb /usr/share/man/man8/lsusb.8.gz
    paul@debian10:~$

## mandb


It should not happen, but in case you have freshly installed programs
that you cannot find with the **man** commands, then it may help to run
the **mandb** command. This command will regenerate all man page index
caches.

    paul@debian10:~$ mandb
    0 man subdirectories contained newer manual pages.
    0 manual pages were added.
    0 stray cats were added.
    0 old database entries were purged.
    paul@debian10:~$

Unfortunately there is no **man page** for **woman**.

    paul@debian10:~$ man woman
    No manual entry for woman
    paul@debian10:~$

## Cheat sheet

<table>
<caption>man pages</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>man foo</p></td>
<td style="text-align: left;"><p>Display the manual page of
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>man man</p></td>
<td style="text-align: left;"><p>Display the manual of the
manual.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>man 1 foo</p></td>
<td style="text-align: left;"><p>Display the section 1 manual page of
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>man 5 foo</p></td>
<td style="text-align: left;"><p>Display the section 5 manual page of
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>apropos foo</p></td>
<td style="text-align: left;"><p>List manual pages containing the string
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>man -k foo</p></td>
<td style="text-align: left;"><p>List manual pages containing the string
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>whatis foo</p></td>
<td style="text-align: left;"><p>Shows the short description of
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>whereis foo</p></td>
<td style="text-align: left;"><p>Shows the location of
<strong>foo</strong> and its manual.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mandb</p></td>
<td style="text-align: left;"><p>Regenerate the man index
caches.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"><p><strong>When inside a man
page</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>enter key</p></td>
<td style="text-align: left;"><p>Go to the next line</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>space bar</p></td>
<td style="text-align: left;"><p>Go to the next page</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>q</p></td>
<td style="text-align: left;"><p>quit the manual</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/foo</p></td>
<td style="text-align: left;"><p>Search for the string foo</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>n</p></td>
<td style="text-align: left;"><p>jump to next occurrence of
string</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>jump to previous occurrence of
string</p></td>
</tr>
</tbody>
</table>

man pages

## Practice

1.  Open the man page for **cp** and search for the option to
    recursively copy directories.

2.  Open the man page for the **passwd** file.

3.  Open the man page of **bash** and search for **noclobber**

4.  List all the man pages that have something to do with **passwords**.

5.  List the location of the **cat** command and its manual page.

6.  Display the short description of the **grep** command.

## Solution

1.  Open the man page for **cp** and search for the option to
    recursively copy directories.

        man cp

    The option you were looking for is **-r**.

2.  Open the man page for the **passwd** file.

        man 5 passwd

3.  Open the man page of **bash** and search for **noclobber**

        man bash

    followed by

        /noclobber
        n n n

    We will use the **noclobber** option later in this book.

4.  List all the man pages that have something to do with **passwords**.

        apropos password

5.  List the location of the **cat** command and its manual page.

        whereis cat

6.  Display the short description of the **grep** command.

        whatis grep
