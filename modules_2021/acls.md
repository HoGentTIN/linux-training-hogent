# Access control lists

Debian 10 Linux has no **ACLs** enabled after a default installation.
You will have to perform some commands as **root** to enable **ACLs**.
These commands are explained in the Storage chapters and in the Managing
software chapter. You may want to study the Storage chapters and come
back here when you can mount filesystems. Or you may continue here with
this chapter, after blindly executing these three commands as **root** .

    apt-get update
    apt-get install acl
    mount -o remount,acl /

## About

With **ACLs** enabled on a filesystem, you can assign permissions to
many different users and groups on individual files or directories. We
will first take a look at recognising **ACLs** and then explain how to
set them.

## ls

Consider the example in the screenshot below and the question: Why can
the user **tania** still read this file? Can you see the difference with
all screenshots from before this chapter?

    paul@debian10~$ chmod 770 newfile
    paul@debian10~$ ls -l newfile
    -rwxrwx---+ 1 paul paul 0 Aug 15 17:53 newfile
    paul@debian10~$

There is new character in the screenshot above, one that we have not
seen yet. After the permissions there is a **+**-sign. This means that
beside the standard Linux permissions, there is also an **ACL** active
on this file.

Note that the **stat** command has no info at all on the presence of an
**ACL**.

    paul@debian10~$ stat newfile
      File: newfile
      Size: 0               Blocks: 0          IO Block: 4096   regular empty file
    Device: 801h/2049d      Inode: 393399      Links: 1
    Access: (0770/-rwxrwx---)  Uid: ( 1000/    paul)   Gid: ( 1000/    paul)
    Access: 2019-08-15 18:34:52.854530983 +0200
    Modify: 2019-08-15 17:53:42.610530930 +0200
    Change: 2019-08-15 18:19:40.866530983 +0200
     Birth: -
    paul@debian10~$

## getfacl

The **getfacl** command will display the **ACL** that is present on this
file. The example shows an entry for the user **tania** and two entries
for the groups **tennis** and **football**.

    paul@debian10~$ getfacl newfile
    # file: newfile
    # owner: paul
    # group: paul
    user::rwx
    user:tania:r-x
    group::r--
    group:tennis:r-x
    group:football:rwx
    mask::rwx
    other::---

    paul@debian10~$

The above screenshot means that **tania** can **r-x** **newfile**, same
as the group members of the **tennis** group. And the **football** group
gets all permissions on this **newfile**.

## setfacl


The **setfacl** command allows us to set **ACLs** on files and
directories. Again we learn by example, so the first screenshot will set
7 permissions (=rwx) for a user named **valentina**.

    paul@debian10~$ echo hello > oldfile
    paul@debian10~$ ls -l oldfile
    -rw-r--r-- 1 paul paul 6 Aug 15 19:06 oldfile
    paul@debian10~$ setfacl -m u:valentina:7 oldfile
    paul@debian10~$ getfacl oldfile | grep valentina
    user:valentina:rwx
    paul@debian10~$

The **-m** option to **setfacl** is to **modify** an ACL, which means
existing ACL antries will remain. Now even after a **chmod 770** the
user **valentina** will have access to the file, as can be seen in this
screenshot.

    paul@debian10~$ chmod 770 oldfile
    paul@debian10~$ su - valentina
    Password:
    valentina@debian10:~$ cat /home/paul/oldfile
    hello
    valentina@debian10:~$

Note that **setfacl** can also be used to set the standard **rwx**
permissions for user, group and other. The screenshot below uses
**setfacl** but no ACL is present.

    root@debian10:~# mkdir /srv/project33
    root@debian10:~# chown root:pro33 /srv/project33/
    root@debian10:~# setfacl -m u::rwx,g::rwx,o:- /srv/project33/
    root@debian10:~# ls -ld /srv/project33/
    drwxrwx--- 2 root pro33 4096 Aug 17 18:24 /srv/project33/
    root@debian10:~#

The **setfacl** command above is identical to the one here below, which
uses octal permissions.

    root@debian10:~# setfacl -m u::7,g::7,o:0 /srv/project33/
    root@debian10:~# ls -ld /srv/project33/
    drwxrwx--- 2 root pro33 4096 Aug 17 18:24 /srv/project33/
    root@debian10:~#

## setfacl --set

We can set all permissions, the classic rwx ones, and all the ACL
entries in one command with **setfacl --set**. This command will erase
all existing ACL entries, so it has to be complete.

    root@debian10:~# setfacl --set u::7,g::7,u:tania:r,o::-,g:pro33:7 /srv/project33/
    root@debian10:~# getfacl /srv/project33/
    getfacl: Removing leading / from absolute path names
    # file: srv/project33/
    # owner: root
    # group: root
    user::rwx
    user:tania:r--
    group::rwx
    group:pro33:rwx
    mask::rwx
    other::---

    root@debian10:~#

The example above is equal to **chmod 770 /srv/project33** followed by
**setfacl -m u:tania:r,g:pro33:7 /srv/project33** .

## mask


You may have noticed the **mask** entry in the output of the previous
**getfacl** commands. This **mask** is set automatically when using
**setfacl**, but can be changed afterwards by a **chmod** or a
**setfacl** command.

Below a **chmod 750**, which sets the **mask** to **r-x**. The output of
**getfacl** will then list the ACL entries, followed by an **effective**
mask.

    root@debian10:~# chmod 750 /srv/project33/
    root@debian10:~# getfacl /srv/project33/
    getfacl: Removing leading / from absolute path names
    # file: srv/project33/
    # owner: root
    # group: root
    user::rwx
    user:tania:r--
    group::rwx                      #effective:r-x
    group:pro33:rwx                 #effective:r-x
    mask::r-x
    other::---

    root@debian10:~#

Using **setfacl** once is enough to recalculate the **mask** so all ACLs
apply. So be careful when mixing **chmod** and **setfacl** commands.

    root@debian10:~# setfacl -m u:tania:7 /srv/project33/
    root@debian10:~# getfacl /srv/project33/
    getfacl: Removing leading / from absolute path names
    # file: srv/project33/
    # owner: root
    # group: root
    user::rwx
    user:tania:rwx
    group::rwx
    group:pro33:rwx
    mask::rwx
    other::---

    root@debian10:~#

## default acls

You may want to set an ACL on a directory, and have all the files and
subdirectories automatically inherit the ACL. This can be done by
marking the ACL as **default**, using the **-d** option to **setfacl**.
Consider this example.

    root@debian10:~# rm -rf /srv/project33/
    root@debian10:~# mkdir /srv/project33/
    root@debian10:~# chown root:pro33 /srv/project33/
    root@debian10:~# setfacl -d --set u::7,g::7,o::-,g:pro33:7,u:tania:7 /srv/project33/
    root@debian10:~# mkdir /srv/project33/newdir
    root@debian10:~# getfacl /srv/project33/newdir
    getfacl: Removing leading / from absolute path names
    # file: srv/project33/newdir
    # owner: root
    # group: root
    user::rwx
    user:tania:rwx
    group::rwx
    group:pro33:rwx
    mask::rwx
    other::---
    default:user::rwx
    default:user:tania:rwx
    default:group::rwx
    default:group:pro33:rwx
    default:mask::rwx
    default:other::---

    root@debian10:~#

## getfacl | setfacl

The output of the **getfacl** command can serve as input for the
**setfacl** command, which allows for copying of the ACL from one file
or directory to another.

    root@debian10:~# getfacl /srv/project33/ | setfacl --set-file=- /srv/project42/
    getfacl: Removing leading / from absolute path names
    root@debian10:~# getfacl /srv/project42/
    getfacl: Removing leading / from absolute path names
    # file: srv/project42/
    # owner: root
    # group: project42
    # flags: -st
    user::rwx
    group::rwx
    other::---
    default:user::rwx
    default:user:tania:r--
    default:group::rwx
    default:group:pro33:rwx
    default:mask::rwx
    default:other::---

    root@debian10:~#

**setfacl --set-file** is similar to **-d --set** in that it has to be
complete because it erases an existing ACL and it sets a default ACL.

You can also put the output of **getfacl** in a file, and use that file
later with **setfacl** to set the same permissions and ACL. This works
recursively when using the **-R** option to **getfacl**.

    root@debian10:~# getfacl -R /srv > srv.acls
    getfacl: Removing leading / from absolute path names
    root@debian10:~# cd /
    root@debian10:/# setfacl --restore /root/srv.acls
    root@debian10:/#

## /etc/fstab

To be able to use **ACLs** the filesystem has to be mounted with the
**acl** mount option. Mount options are explained in the Storage
chapter.

## Cheat sheet

<table>
<caption>Access control lists</caption>
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
<td style="text-align: left;"><p>+</p></td>
<td style="text-align: left;"><p>The sign that <strong>ls</strong> shows
when there is an ACL.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>getfacl foo</p></td>
<td style="text-align: left;"><p>Read the ACL of the file named
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>setfacl -m u:bar:7 foo</p></td>
<td style="text-align: left;"><p>Set octal 7 permissions for user
<strong>bar</strong> on file <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>setfacl --set</p></td>
<td style="text-align: left;"><p>Set all permissions and ACL’s.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>setfacl -d</p></td>
<td style="text-align: left;"><p>Set a default (=inheritable)
ACL.</p></td>
</tr>
</tbody>
</table>

Access control lists

## Practice

1.  Create a directory for **project8472**. Also create a group named
    **pro8472** for this project and make the group owner of the
    directory.

2.  Create a group named **pro42** and give them read and execute access
    on the **project8472** directory, while retaining access for the
    **pro8472** group.

3.  Verify with **ls -l** that there is a plus-sign behind the
    permissions.

4.  Verify with **getfacl** that the ACL contains two different groups.

5.  Use **chmod 700** on the project8472 directory, is the ACL still
    active?

6.  Is the ACL restored after a **chmod 770** on the project8472
    directory?

7.  Store the ACL in a file.

8.  Remove the ACL from the project8472 directory.

9.  Restore the ACL using the backup file.

## Solution

1.  Create a directory for **project8472**. Also create a group named
    **pro8472** for this project and make the group owner of the
    directory.

        mkdir /srv/project8472
        groupadd pro8472
        chgrp pro8472 /srv/project8472

2.  Create a group named **pro42** and give them read and execute access
    on the **project8472** directory, while retaining access for the
    **pro8472** group.

        groupadd pro42
        setfacl -m g:pro42:rx /srv/project8472

3.  Verify with **ls -l** that there is a plus-sign behind the
    permissions.

        ls -l /srv/project8472

4.  Verify with **getfacl** that the ACL contains two different groups.

        getfacl /srv/project8472

5.  Use **chmod 700** on the project8472 directory, is the ACL still
    active?

        chmod 700 /srv/project8472
        You should see 'effective:---' when using getfacl on this directory.

6.  Is the ACL restored after a **chmod 770** on the project8472
    directory?

        chmod 770 /srv/project8472
        getfacl /srv/project8472

7.  Store the ACL in a file.

        getfacl /srv/project8472 > file.acl

8.  Remove the ACL from the project8472 directory.

        setfacl -b /srv/project8472

9.  Restore the ACL using the backup file.

        setfacl --set-file=file.acl /srv/project8472
