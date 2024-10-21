## groupadd

Groups can be created with the `groupadd` command. The
example below shows the creation of five (empty) groups.

    root@linux:~# groupadd tennis
    root@linux:~# groupadd football
    root@linux:~# groupadd snooker
    root@linux:~# groupadd formula1
    root@linux:~# groupadd salsa

## group file

Users can be a member of several groups. Group membership is defined by
the `/etc/group` file.

    root@linux:~# tail -5 /etc/group
    tennis:x:1006:
    football:x:1007:
    snooker:x:1008:
    formula1:x:1009:
    salsa:x:1010:
    root@linux:~#

The first field is the group's name. The second field is the group's
(encrypted) password (can be empty). The third field is the group
identification or `GID`. The fourth field is the list of
members, these groups have no members.

## groups

A user can type the `groups` command to see a list of
groups where the user belongs to.

    [harry@linux ~]$ groups
    harry sports
    [harry@linux ~]$

## usermod

Group membership can be modified with the useradd or
`usermod` command.

    root@linux:~# usermod -a -G tennis inge
    root@linux:~# usermod -a -G tennis katrien
    root@linux:~# usermod -a -G salsa katrien
    root@linux:~# usermod -a -G snooker sandra
    root@linux:~# usermod -a -G formula1 annelies
    root@linux:~# tail -5 /etc/group
    tennis:x:1006:inge,katrien
    football:x:1007:
    snooker:x:1008:sandra
    formula1:x:1009:annelies
    salsa:x:1010:katrien
    root@linux:~#

Be careful when using `usermod` to add users to groups. By default, the
`usermod` command will `remove` the user from every group of which he is
a member if the group is not listed in the command! Using the `-a`
(append) switch prevents this behaviour.

## groupmod

You can change the group name with the `groupmod` command.

    root@linux:~# groupmod -n darts snooker 
    root@linux:~# tail -5 /etc/group
    tennis:x:1006:inge,katrien
    football:x:1007:
    formula1:x:1009:annelies
    salsa:x:1010:katrien
    darts:x:1008:sandra

## groupdel

You can permanently remove a group with the `groupdel`
command.

    root@linux:~# groupdel tennis
    root@linux:~#

## gpasswd

You can delegate control of group membership to another user with the
`gpasswd` command. In the example below we delegate
permissions to add and remove group members to serena for the sports
group. Then we `su` to serena and add harry to the sports
group.

    [root@linux ~]# gpasswd -A serena sports
    [root@linux ~]# su - serena
    [serena@linux ~]$ id harry
    uid=516(harry) gid=520(harry) groups=520(harry)
    [serena@linux ~]$ gpasswd -a harry sports
    Adding user harry to group sports
    [serena@linux ~]$ id harry
    uid=516(harry) gid=520(harry) groups=520(harry),522(sports)
    [serena@linux ~]$ tail -1 /etc/group
    sports:x:522:serena,venus,harry
    [serena@linux ~]$ 

Group administrators do not have to be a member of the group. They can
remove themselves from a group, but this does not influence their
ability to add or remove members.

    [serena@linux ~]$ gpasswd -d serena sports
    Removing user serena from group sports
    [serena@linux ~]$ exit

Information about group administrators is kept in the
`/etc/gshadow` file.

    [root@linux ~]# tail -1 /etc/gshadow
    sports:!:serena:venus,harry
    [root@linux ~]#

To remove all group administrators from a group, use the `gpasswd`
command to set an empty administrators list.

    [root@linux ~]# gpasswd -A "" sports

## newgrp

You can start a `child shell` with a new temporary `primary group` using
the `newgrp` command.

    root@linux:~# mkdir prigroup
    root@linux:~# cd prigroup/
    root@linux:~/prigroup# touch standard.txt
    root@linux:~/prigroup# ls -l
    total 0
    -rw-r--r--. 1 root root 0 Apr 13 17:49 standard.txt
    root@linux:~/prigroup# echo $SHLVL
    1
    root@linux:~/prigroup# newgrp tennis
    root@linux:~/prigroup# echo $SHLVL
    2
    root@linux:~/prigroup# touch newgrp.txt
    root@linux:~/prigroup# ls -l
    total 0
    -rw-r--r--. 1 root tennis 0 Apr 13 17:49 newgrp.txt
    -rw-r--r--. 1 root root   0 Apr 13 17:49 standard.txt
    root@linux:~/prigroup# exit
    exit
    root@linux:~/prigroup#

## vigr

Similar to vipw, the `vigr` command can be used to
manually edit the `/etc/group` file, since it will do proper locking of
the file. Only experienced senior administrators should use
`vi` or `vigr` to manage groups.

