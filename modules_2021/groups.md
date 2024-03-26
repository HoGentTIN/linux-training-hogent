# Group management

## groups


By default any user created on Debian Linux 10 will belong to one group.
This group has the same name as the user and is considered the primary
group of that user.

    tania@debian10:~$ groups
    tania
    tania@debian10:~$

An exception to this rule is the very first user, which is created at
installation time. This user belongs to a number of groups, as shown in
this screenshot.

    paul@debian10:~$ groups
    paul cdrom floppy audio dip video plugdev netdev bluetooth
    paul@debian10:~$

## groupadd


To create a group, as root, issue the **groupadd** command followed by
the name of the group. The example below creates two new empty groups.

    root@debian10:~# groupadd tennis
    root@debian10:~# groupadd football
    root@debian10:~#

## /etc/group

Groups are stored by the Linux system in the **/etc/group** file. Every
line in this file has four fields separated by a colon. The first field
is the group name, then there is room for a group password (I have never
seen this in use), then follows the group id and last is the list of
members of this group.

    paul@debian10:~$ tail -2 /etc/group
    tennis:x:1009:
    football:x:1010:
    paul@debian10:~$

## groupmod


You can change the **gid** or the name of the group with the
**groupmod** command. Both actions are shown in the screenshot below.

    root@debian10:~# groupmod -g 2000 tennis
    root@debian10:~# groupmod -n soccer football
    root@debian10:~# tail -2 /etc/group
    tennis:x:2000:
    soccer:x:1010:
    root@debian10:~#

## groepdel


Groups can be deleted with the **groupdel** command.

    root@debian10:~# groupdel soccer
    root@debian10:~# tail -2 /etc/group
    tania:x:1008:
    tennis:x:2000:
    root@debian10:~#

## usermod


The **usermod** command can be used to add a member to a list of groups.
Be careful when using **usermod -G** as you will have to list all groups
of which you want the user to be a member. The user will be removed from
groups not listed. The screenshot below shows how user **tania** is
removed from the group **tennis**.

    root@debian10:~# groupadd football
    root@debian10:~# tail -2 /etc/group
    tennis:x:2000:
    football:x:2001:
    root@debian10:~# usermod -G tennis tania
    root@debian10:~# usermod -G football tania
    root@debian10:~# tail -2 /etc/group
    tennis:x:2000:
    football:x:2001:tania
    root@debian10:~#

You can prevent this by using **usermod** with the **-a -G** options.

    root@debian10:~# usermod -a -G tennis tania
    root@debian10:~# tail -2 /etc/group
    tennis:x:2000:tania
    football:x:2001:tania
    root@debian10:~#

## newgrp


This topic touches file ownership, which will be discussed later in this
book. When you are creating files (for example with **touch** or with
**&gt;** redirection ), then you are the **owner** of the file, and your
primary group is the **group owner** of the file. But if you issue the
**newgrp tennis** command, then a new shell is started with **tennis**
as your primary group. See the screenshot below, in particular the
ownership of the files.

    root@debian10:~# touch file33
    root@debian10:~# ls -l file33
    -rw-r--r-- 1 root root 0 Aug 13 14:21 file33
    root@debian10:~# newgrp tennis
    root@debian10:~# echo $SHLVL
    2
    root@debian10:~# touch file42
    root@debian10:~# ls -l file42
    -rw-r--r-- 1 root tennis 0 Aug 13 14:21 file42
    root@debian10:~#

By default only the **root** user can do this.

## gpasswd


The last command of this little chapter is **gpasswd**. It allows for
delegation of groups to a user, so that user can add and remove members
to and from a group. The user has to use **gpasswd** for this, not
**usermod**.

In the screenshot below **tania** is the delegated account for the group
**tennis**. She can then add users to that group with **gpasswd -a**.

    root@debian10:~# gpasswd -A tania tennis
    root@debian10:~# su - tania
    tania@debian10:~$ grep tennis /etc/group
    tennis:x:2000:tania
    tania@debian10:~$ gpasswd -a valentina tennis
    Adding user valentina to group tennis
    tania@debian10:~$ grep tennis /etc/group
    tennis:x:2000:tania,valentina
    tania@debian10:~$

## backups


Note that the files **/etc/passwd**, **/etc/shadow**, **/etc/group** and
**/etc/gshadow** are backed up every day to **/var/backup**. Only
**root** can access these backups.

    paul@debian10:$ ls -l /var/backups/*.bak
    -rw------- 1 root root    960 Sep  5 22:30 /var/backups/group.bak
    -rw------- 1 root shadow  803 Sep  5 22:30 /var/backups/gshadow.bak
    -rw------- 1 root root   1837 Sep  5 22:30 /var/backups/passwd.bak
    -rw------- 1 root shadow 1515 Sep  5 22:30 /var/backups/shadow.bak
    paul@debian10:$

## Cheat sheet

<table>
<caption>Groups</caption>
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
<td style="text-align: left;"><p>groups</p></td>
<td style="text-align: left;"><p>List your group memberships.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>groupadd foo</p></td>
<td style="text-align: left;"><p>Adds an empty group named
<strong>foo</strong> to this computer.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>groupmod</p></td>
<td style="text-align: left;"><p>Tool to modify properties of
groups.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>groupdel foo</p></td>
<td style="text-align: left;"><p>Delete the group named
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>usermod -G foo bar</p></td>
<td style="text-align: left;"><p>Add the user <strong>bar</strong> to
the group <strong>foo</strong> (and remove <strong>bar</strong> from all
other groups).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>usermod -a -G foo bar</p></td>
<td style="text-align: left;"><p>Add the user <strong>bar</strong> to
the group <strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>newgrp</p></td>
<td style="text-align: left;"><p>Change the primary group in your
current environment.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>gpasswd -A foo bar</p></td>
<td style="text-align: left;"><p>Make user <strong>foo</strong> an
administrator of group <strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/etc/group</p></td>
<td style="text-align: left;"><p>Contains the list of all groups and
their members on this computer.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/var/backups</p></td>
<td style="text-align: left;"><p>Contains backups of /etc/passwd,
/etc/group and more.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/etc/cron.daily/passwd</p></td>
<td style="text-align: left;"><p>The file that performs the backup (see
the Scheduling chapter).</p></td>
</tr>
</tbody>
</table>

Groups

## Practice

1.  Verify your group membership on this computer.

2.  Add two groups named **music** and **arts**

3.  Verify that both groups were created and contain no members.

4.  Modify the **gid** of arts to 3000.

5.  Modify the name of the group **music** to **artists**.

6.  Delete the group artists.

7.  Add the user **tania** to the group **arts**, without removing her
    from other groups.

## Solution

1.  Verify your group membership on this computer.

        groups

2.  Add two groups named **music** and **arts**

        su -
        groupadd music
        groupadd arts

3.  Verify that both groups were created and contain no members.

        tail -2 /etc/group

4.  Modify the **gid** of arts to 3000.

        groupmod -g 3000 arts

5.  Modify the name of the group **music** to **artists**.

        groupmod -n music artists

6.  Delete the group artists.

        groupdel artists

7.  Add the user **tania** to the group **arts**, without removing her
    from other groups.

        usermod -a -G arts tania
