# File permissions

## File ownership

Every file on Debian Linux has two owners, named a user owner and a
group owner. The screenshot below shows the **dates.txt** file being
owned by the user **paul** and by the group **paul**.

    paul@debian10:~$ ls -l dates.txt
    -rw-r--r-- 1 paul paul 1118 Jul 27 13:12 dates.txt
    paul@debian10:~$

This screenshot shows the owners of the **/etc/shadow** file, with
**root** as the user owner and the group **shadow** as the group owner.

    paul@debian10:~$ ls -l /etc/shadow
    -rw-r----- 1 root shadow 1377 Aug 13 12:59 /etc/shadow
    paul@debian10:~$

## chgrp


The **root** user can use the **chgrp** command to change the **group
owner** of a file to another group. The group must exist in
**/etc/group**.

    root@debian10:~# chgrp tennis /home/paul/dates.txt
    root@debian10:~# ls -l /home/paul/dates.txt
    -rw-r--r-- 1 paul tennis 1118 Jul 27 13:12 /home/paul/dates.txt
    root@debian10:~#

## chown


The **root** user can use **chown** to change the user owner and to
change the group owner in one command. The screenshot below changes both
owners of a file.

    root@debian10:~# chown laura:football /home/paul/dates.txt
    root@debian10:~# ls -l /home/paul/dates.txt
    -rw-r--r-- 1 laura football 1118 Jul 27 13:12 /home/paul/dates.txt
    root@debian10:~#

The **paul** user cannot take ownership of the file, even if it is in
his home directory, as the following screenshot shows.

    paul@debian10:~$ ls -l dates.txt
    -rw-r--r-- 1 laura football 1118 Jul 27 13:12 dates.txt
    paul@debian10:~$ chown paul:paul dates.txt
    chown: changing ownership of dates.txt: Operation not permitted
    paul@debian10:~$

## Regular files

Regular files (those that start with a **-** in **ls -l**) have
permissions in the form of **rwxrwxrwx**. Three triplets of **r**ead,
**w**rite, and e**x**ecute permissions.

The first triplet are the permissions for the **user owner**. The second
triplet are the permissions for the **group owner** (for all the members
of that group). The third triplet are the permissions for **other**
users.

<table style="width:70%;">
<caption>file permissions table</caption>
<colgroup>
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 46%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: center;"><p>letter</p></td>
<td style="text-align: center;"><p>short</p></td>
<td style="text-align: left;"><p>permission</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>r</p></td>
<td style="text-align: center;"><p>read</p></td>
<td style="text-align: left;"><p>Can read the file with
<strong>cat</strong>, <strong>more</strong>, …</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>w</p></td>
<td style="text-align: center;"><p>write</p></td>
<td style="text-align: left;"><p>Can write to the file with
<strong>vi</strong>, <strong>&gt;</strong>, …</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>x</p></td>
<td style="text-align: center;"><p>execute</p></td>
<td style="text-align: left;"><p>Can execute (run) the file.</p></td>
</tr>
</tbody>
</table>

file permissions table

In the screenshot below the **laura** user has read and write
permissions, the members of the **football** group have read
permissions, and the others also have read.

    paul@debian10:~$ ls -l dates.txt
    -rw-r--r-- 1 laura football 1118 Jul 27 13:12 dates.txt
    paul@debian10:~$

In the screenshot below the **paul** user has read, write and execute
permissions, the **paul** group has read and execute permissions, and
the others have no permissions (others cannot read, write or execute the
**forloop4.sh** file).

    paul@debian10:~$ ls -l forloop4.sh
    -rwxr-x--- 1 paul paul 79 Aug  9 13:54 forloop4.sh
    paul@debian10:~$

In case you are the user owner, and you are a member of the group owner,
then the user owner permissions prevail.

## Directories

Permissions on directories (those starting with **d** in **ls -l**) have
a different meaning than permissions on regular files. Generally **r**
and **x** are given to be able to enter the directory with **cd** and
list the files with **ls**. The **w** permission on directories is given
when you need to be able to create files in the directory.

<table style="width:70%;">
<caption>directory permissions table</caption>
<colgroup>
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 46%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: center;"><p>letter</p></td>
<td style="text-align: center;"><p>short</p></td>
<td style="text-align: left;"><p>permission</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>r</p></td>
<td style="text-align: center;"><p>read</p></td>
<td style="text-align: left;"><p>Together with <strong>x</strong> allows
for reading with <strong>ls</strong>, …</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>w</p></td>
<td style="text-align: center;"><p>write</p></td>
<td style="text-align: left;"><p>Can create files in the
directory.</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>x</p></td>
<td style="text-align: center;"><p>execute</p></td>
<td style="text-align: left;"><p>Can enter the directory with
<strong>cd</strong>.</p></td>
</tr>
</tbody>
</table>

directory permissions table

## chmod


Permissions on a regular file or directory can be changed with the
**chmod** command (which is short for **ch**ange **mod**e). The
**chmod** command can add, remove or set permissions for the **u**ser
owner, **g**roup owner and **o**thers.

<table style="width:70%;">
<caption>chmod permissions</caption>
<colgroup>
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 46%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: center;"><p>character</p></td>
<td style="text-align: center;"><p>short</p></td>
<td style="text-align: left;"><p>permission</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>u</p></td>
<td style="text-align: center;"><p>user</p></td>
<td style="text-align: left;"><p>user owner</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>g</p></td>
<td style="text-align: center;"><p>group</p></td>
<td style="text-align: left;"><p>group owner</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>o</p></td>
<td style="text-align: center;"><p>other</p></td>
<td style="text-align: left;"><p>others</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>+</p></td>
<td style="text-align: center;"><p>add</p></td>
<td style="text-align: left;"><p>add permission(s) to file or
directory</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>-</p></td>
<td style="text-align: center;"><p>remove</p></td>
<td style="text-align: left;"><p>remove permission(s) from file or
directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>=</p></td>
<td style="text-align: center;"><p>set</p></td>
<td style="text-align: left;"><p>set permissions on file or
directory</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>r</p></td>
<td style="text-align: center;"><p>read</p></td>
<td style="text-align: left;"><p>read permission</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>w</p></td>
<td style="text-align: center;"><p>write</p></td>
<td style="text-align: left;"><p>write permission</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>x</p></td>
<td style="text-align: center;"><p>execute</p></td>
<td style="text-align: left;"><p>execute permission</p></td>
</tr>
</tbody>
</table>

chmod permissions

For example to set permissions to rwxr-xr-- the following command can be
used.

    root@debian10:/home/paul# ls -l dates.txt
    -rw-r--r-- 1 laura football 1118 Jul 27 13:12 dates.txt
    root@debian10:/home/paul#
    root@debian10:/home/paul# chmod u=rwx,g=rx,o=r dates.txt
    root@debian10:/home/paul# ls -l dates.txt
    -rwxr-xr-- 1 laura football 1118 Jul 27 13:12 dates.txt
    root@debian10:/home/paul#

To simply add permission for the **others**, you can issue this command.

    root@debian10:/home/paul# chmod o+rwx dates.txt
    root@debian10:/home/paul# ls -l dates.txt
    -rwxr-xrwx 1 laura football 1118 Jul 27 13:12 dates.txt
    root@debian10:/home/paul#

You can combine the owners in the **chmod** command, if they need the
same permission change. And you can clear permissions by omitting them,
as shown in this screenshot.

    root@debian10:/home/paul# chmod ug=rw,o= dates.txt
    root@debian10:/home/paul# ls -l dates.txt
    -rw-rw---- 1 laura football 1118 Jul 27 13:12 dates.txt
    root@debian10:/home/paul#

And instead of writing **ugo** for all three permissions sets, you can
simply write **a** for all.

    root@debian10:/home/paul# chmod a+rwx dates.txt
    root@debian10:/home/paul# ls -l dates.txt
    -rwxrwxrwx 1 laura football 1118 Jul 27 13:12 dates.txt
    root@debian10:/home/paul#

## old school chmod


While the previous section with **chmod ugo+-=rwx** seems
straightforward, most people on Linux use **octal numbers** to set
permissions. This is quicker to type and easy to get used to.

<table style="width:40%;">
<caption>chmod octal permissions</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: center;"><p>octal number</p></td>
<td style="text-align: center;"><p>rwx equivalent</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>0</p></td>
<td style="text-align: center;"><p>---</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>1</p></td>
<td style="text-align: center;"><p>--x</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>2</p></td>
<td style="text-align: center;"><p>-w-</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>3</p></td>
<td style="text-align: center;"><p>-wx</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>4</p></td>
<td style="text-align: center;"><p>r--</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>5</p></td>
<td style="text-align: center;"><p>r-x</p></td>
</tr>
<tr class="even">
<td style="text-align: center;"><p>6</p></td>
<td style="text-align: center;"><p>rw-</p></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><p>7</p></td>
<td style="text-align: center;"><p>rwx</p></td>
</tr>
</tbody>
</table>

chmod octal permissions

For regular files the most common use cases are 6, 4 and 0. We use these
three in the following screenshot. The **6** means **rw** for user
owner, the **4** means **r** for group owner and the **0** removes all
permissions for others.

    paul@debian10:~$ chmod 640 error.txt
    paul@debian10:~$ ls -l error.txt
    -rw-r----- 1 paul paul 31537 Aug  4 14:59 error.txt
    paul@debian10:~$

And for directories the most common use cases are 7, 5 and 0. See the
following example which grants **rwx** for the user owner, **r-x** for
the group owner and nothing for the others.

    paul@debian10:~$ chmod 750 renamedir/
    paul@debian10:~$ ls -ld renamedir/
    drwxr-x--- 2 paul paul 4096 Aug  4 21:39 renamedir/
    paul@debian10:~$

The **chmod** command can be used to **recursively** change permissions
on all files in all subdirectories using the **-R** option, as seen in
this example.

    paul@debian10:~/recu$ find . -type f -exec ls -l {} \;
    -rw-r--r-- 1 paul paul 0 Aug 14 00:34 ./subdir/file33
    -rw-r--r-- 1 paul paul 0 Aug 14 00:34 ./file42
    paul@debian10:~/recu$ chmod -R 770 * 
    paul@debian10:~/recu$ find . -type f -exec ls -l {} \;
    -rwxrwx--- 1 paul paul 0 Aug 14 00:34 ./subdir/file33
    -rwxrwx--- 1 paul paul 0 Aug 14 00:34 ./file42
    paul@debian10:~/recu$

## stat


The **stat** command will display permissions in octal and in human
readable form, together with the uid and gid.

    paul@debian10~$ stat recu/file42 | grep Access | head -1
    Access: (0770/-rwxrwx---)  Uid: ( 1000/    paul)   Gid: ( 1000/    paul)
    paul@debian10~$

## umask


Where do the default permissions come from? For example in the following
screenshot we create a new file and a new directory, and they get
default permissions.

    paul@debian10:~/umask$ touch file42
    paul@debian10:~/umask$ mkdir newdir
    paul@debian10:~/umask$ ls -l
    total 4
    -rw-r--r-- 1 paul paul    0 Aug 14 00:39 file42
    drwxr-xr-x 2 paul paul 4096 Aug 14 00:39 newdir
    paul@debian10:~/umask$

They come from the **umask** value, which can be displayed with the
**umask** command.

    paul@debian10:~/umask$ umask
    0022
    paul@debian10:~/umask$

The first zero in the **umask** is to signify that this is an **octal**
number, so the octal number we receive is **022**. These are the
permissions that you **do not** get when creating files and directories.

Let’s verify this for the directory we just created. The maximum
permission is 777, minus the **umask** 022 equals 755, which is exactly
what we got when creating the **newdir** above.

It is the same for regular files, except that the maximum permission for
files is 666, because files are **never** executable by default.

The **umask** value is set in **/etc/login.defs**, but can be changed in
any of the profile scripts or even on the fly by typing **umask**
followed by the desired value.

    paul@debian10:$ umask
    0022
    paul@debian10:$ umask 002
    paul@debian10:$ umask
    0002
    paul@debian10:$

## mkdir -m


There is an option **-m** to **mkdir** which allows for you to specify
the permissions on that directory at creation time. See this for
example.

    paul@debian10:~/umask$ mkdir -m 700 mydir
    paul@debian10:~/umask$ ls -ld mydir/
    drwx------ 2 paul paul 4096 Aug 14 00:50 mydir/
    paul@debian10:~/umask$

## root and permissions

Permissions do not apply to the **root** user. The **root** user can
always read from and write to regular files and directories.

## Cheat sheet

<table>
<caption>Permissions</caption>
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
<td style="text-align: left;"><p>ls -l foo</p></td>
<td style="text-align: left;"><p>Display user owner and group owner of a
file named <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>chgrp bar foo</p></td>
<td style="text-align: left;"><p>Change the group owner of a file named
<strong>foo</strong> to <strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chown bar:bar foo</p></td>
<td style="text-align: left;"><p>Change both owners of the file named
<strong>foo</strong> to <strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>chmod</p></td>
<td style="text-align: left;"><p>Tool to change the permissions (the
<strong>mod</strong>e) of a file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chmod u=r foo</p></td>
<td style="text-align: left;"><p>Sets the <strong>user owner</strong>
permission to <strong>read</strong> (for the file
<strong>foo</strong>)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>chmod g+rw foo</p></td>
<td style="text-align: left;"><p>Adds <strong>read</strong> and
<strong>write</strong> permissions for the <strong>group</strong>
owner.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chmod o-x foo</p></td>
<td style="text-align: left;"><p>Removes the <strong>execute</strong>
permission for <strong>others</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>chmod 777 foo</p></td>
<td style="text-align: left;"><p>Sets 777 octal permissions on the file
named <strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chmod -R</p></td>
<td style="text-align: left;"><p>Recursively sets permissions for all
files in all subdirectories.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>stat foo</p></td>
<td style="text-align: left;"><p>Display owners and permissions (and
more) information about the file <strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>umask</p></td>
<td style="text-align: left;"><p>Display the default permission mask
(for your current environment!).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>umask 002</p></td>
<td style="text-align: left;"><p>Set the default permission mask (for
your current environment!).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mkdir -m 700 foo</p></td>
<td style="text-align: left;"><p>Create the directory
<strong>foo</strong> with octal 700 permissions.</p></td>
</tr>
</tbody>
</table>

Permissions

## Practice

1.  Display the user owner and group owner of the **/var/log/auth.log**
    file .

2.  Change the group owner of the **wolf.png** file to the group
    **tennis**.

3.  Change the user owner of the **wolf.png** file to the user **root**.

4.  Change the permissions on the **Linux.pdf** file to **r--r-----** .

5.  Change the permissions on the **Linux.pdf** file to **r--r-----**
    using octal notation.

6.  Create a directory **~/newdir** with 700 permissions.

7.  Display the **umask**.

8.  Does the **~/.profile** script change the **umask**?

## Solution

1.  Display the user owner and group owner of the **/var/log/auth.log**
    file .

        ls -l /var/log/auth.log

2.  Change the group owner of the **wolf.png** file to the group
    **tennis**.

        su -
        chgrp tennis wolf.png

3.  Change the user owner of the **wolf.png** file to the user **root**.

        su -
        chown root wolf.png

4.  Change the permissions on the **Linux.pdf** file to **r--r-----** .

        chmod ug=r,o= Linux.pdf

5.  Change the permissions on the **Linux.pdf** file to **r--r-----**
    using octal notation.

        chmod 440 Linux.pdf

6.  Create a directory **~/newdir** with 700 permissions.

        mkdir -m 700 ~/newdir

7.  Display the **umask**.

        umask

8.  Does the **~/.profile** script change the **umask**?

        grep umask ~/.profile
