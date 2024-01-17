# groupadd

Groups can be created with the `groupadd` command. The
example below shows the creation of five (empty) groups.

    root@laika:~# groupadd tennis
    root@laika:~# groupadd football
    root@laika:~# groupadd snooker
    root@laika:~# groupadd formula1
    root@laika:~# groupadd salsa

# group file

Users can be a member of several groups. Group membership is defined by
the `/etc/group` file.

    root@laika:~# tail -5 /etc/group
    tennis:x:1006:
    football:x:1007:
    snooker:x:1008:
    formula1:x:1009:
    salsa:x:1010:
    root@laika:~#

The first field is the group\'s name. The second field is the group\'s
(encrypted) password (can be empty). The third field is the group
identification or `GID`. The fourth field is the list of
members, these groups have no members.

# groups

A user can type the `groups` command to see a list of
groups where the user belongs to.

    [harry@RHEL8b ~]$ groups
    harry sports
    [harry@RHEL8b ~]$

# usermod

Group membership can be modified with the useradd or
`usermod` command.

    root@laika:~# usermod -a -G tennis inge
    root@laika:~# usermod -a -G tennis katrien
    root@laika:~# usermod -a -G salsa katrien
    root@laika:~# usermod -a -G snooker sandra
    root@laika:~# usermod -a -G formula1 annelies
    root@laika:~# tail -5 /etc/group
    tennis:x:1006:inge,katrien
    football:x:1007:
    snooker:x:1008:sandra
    formula1:x:1009:annelies
    salsa:x:1010:katrien
    root@laika:~#

Be careful when using `usermod` to add users to groups. By default, the
`usermod` command will `remove` the user from every group of which he is
a member if the group is not listed in the command! Using the `-a`
(append) switch prevents this behaviour.

# groupmod

You can change the group name with the `groupmod` command.

    root@laika:~# groupmod -n darts snooker 
    root@laika:~# tail -5 /etc/group
    tennis:x:1006:inge,katrien
    football:x:1007:
    formula1:x:1009:annelies
    salsa:x:1010:katrien
    darts:x:1008:sandra

# groupdel

You can permanently remove a group with the `groupdel`
command.

    root@laika:~# groupdel tennis
    root@laika:~#

# gpasswd

You can delegate control of group membership to another user with the
`gpasswd` command. In the example below we delegate
permissions to add and remove group members to serena for the sports
group. Then we `su` to serena and add harry to the sports
group.

    [root@RHEL8b ~]# gpasswd -A serena sports
    [root@RHEL8b ~]# su - serena
    [serena@RHEL8b ~]$ id harry
    uid=516(harry) gid=520(harry) groups=520(harry)
    [serena@RHEL8b ~]$ gpasswd -a harry sports
    Adding user harry to group sports
    [serena@RHEL8b ~]$ id harry
    uid=516(harry) gid=520(harry) groups=520(harry),522(sports)
    [serena@RHEL8b ~]$ tail -1 /etc/group
    sports:x:522:serena,venus,harry
    [serena@RHEL8b ~]$ 

Group administrators do not have to be a member of the group. They can
remove themselves from a group, but this does not influence their
ability to add or remove members.

    [serena@RHEL8b ~]$ gpasswd -d serena sports
    Removing user serena from group sports
    [serena@RHEL8b ~]$ exit

Information about group administrators is kept in the
`/etc/gshadow` file.

    [root@RHEL8b ~]# tail -1 /etc/gshadow
    sports:!:serena:venus,harry
    [root@RHEL8b ~]#

To remove all group administrators from a group, use the `gpasswd`
command to set an empty administrators list.

    [root@RHEL8b ~]# gpasswd -A "" sports

# newgrp

You can start a `child shell` with a new temporary `primary group` using
the `newgrp` command.

    root@rhel65:~# mkdir prigroup
    root@rhel65:~# cd prigroup/
    root@rhel65:~/prigroup# touch standard.txt
    root@rhel65:~/prigroup# ls -l
    total 0
    -rw-r--r--. 1 root root 0 Apr 13 17:49 standard.txt
    root@rhel65:~/prigroup# echo $SHLVL
    1
    root@rhel65:~/prigroup# newgrp tennis
    root@rhel65:~/prigroup# echo $SHLVL
    2
    root@rhel65:~/prigroup# touch newgrp.txt
    root@rhel65:~/prigroup# ls -l
    total 0
    -rw-r--r--. 1 root tennis 0 Apr 13 17:49 newgrp.txt
    -rw-r--r--. 1 root root   0 Apr 13 17:49 standard.txt
    root@rhel65:~/prigroup# exit
    exit
    root@rhel65:~/prigroup#

# vigr

Similar to vipw, the `vigr` command can be used to
manually edit the `/etc/group` file, since it will do proper locking of
the file. Only experienced senior administrators should use
`vi` or `vigr` to manage groups.
