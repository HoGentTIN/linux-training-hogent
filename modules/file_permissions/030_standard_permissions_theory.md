## file ownership

### user owner and group owner

The *users* and *groups* of a system can be locally managed in `/etc/passwd` and `/etc/group`, or they can be in a NIS, LDAP, or Samba domain. These users and groups can *own* files. Actually, every file has a *user owner* and a *group owner*, as can be seen in the following example.

```console
student@linux:~/owners$ ls -lh
total 636K
-rw-r--r--. 1 student snooker  1.1K Apr  8 18:47 data.odt
-rw-r--r--. 1 student student  626K Apr  8 18:46 file1
-rw-r--r--. 1 student tennis    185 Apr  8 18:46 file2
-rw-rw-r--. 1 root root           0 Apr  8 18:47 stuff.txt
```

User `student` owns three files: `file1` has `student` as *user owner* and has the group `student` as *group owner*, `data.odt` is *group owned* by the group `snooker`, `file2` by the group `tennis`.

The last file is called `stuff.txt` and is owned by the `root` user and the `root` group.

### chgrp

You can change the group owner of a file using the `chgrp` command. You must have root privileges to do this.

```console
root@linux:/home/student/owners# ls -l file2
-rw-r--r--. 1 root tennis 185 Apr  8 18:46 file2
root@linux:/home/student/owners# chgrp snooker file2
root@linux:/home/student/owners# ls -l file2
-rw-r--r--. 1 root snooker 185 Apr  8 18:46 file2
root@linux:/home/student/owners#
```

### chown

The user owner of a file can be changed with `chown` command. You must have root privileges to do this. In the following example, the user owner of `file2` is changed from `root` to `student`.

```console
root@linux:/home/student# ls -l FileForStudent 
-rw-r--r-- 1 root student 0 2008-08-06 14:11 FileForStudent
root@linux:/home/student# chown student FileForStudent 
root@linux:/home/student# ls -l FileForStudent 
-rw-r--r-- 1 student student 0 2008-08-06 14:11 FileForStudent
```

You can also use `chown user:group` to change both the user owner and the group owner.

```console
root@linux:/home/student# ls -l FileForStudent 
-rw-r--r-- 1 student student 0 2008-08-06 14:11 FileForStudent
root@linux:/home/student# chown root:project42 FileForStudent 
root@linux:/home/student# ls -l FileForStudent 
-rw-r--r-- 1 root project42 0 2008-08-06 14:11 FileForStudent
```

## list of special files

When you use `ls -l`, for each file you can see ten characters before the user and group owner. The first character tells us the type of file. Regular files get a `-`, directories get a `d`, symbolic links are shown with an `l`, pipes get a `p`, character devices a `c`, block devices a `b`, and sockets an `s`.

| first character | file type        |
| :-------------: | :--------------- |
|       `-`       | normal file      |
|       `d`       | directory        |
|       `l`       | symbolic link    |
|       `p`       | named pipe       |
|       `b`       | block device     |
|       `c`       | character device |
|       `s`       | socket           |

Below an example of a character device (the console) and a block device (the hard disk).

```console
student@linux:~$ ls -l /dev/console /dev/sda
crw--w---- 1 root tty  5, 1 Mar  8 08:32 /dev/console
brw-rw---- 1 root disk 8, 0 Mar  8 08:32 /dev/sda
```

And here you can see a directory, a regular file and a symbolic link.

```console
student@linux:~$ ls -ld /etc /etc/hosts /etc/os-release
drwxr-xr-x 81 root root 4096 Mar  8 08:32 /etc
-rw-r--r--  1 root root  186 Feb 26 14:58 /etc/hosts
lrwxrwxrwx  1 root root   21 Dec  9 21:08 /etc/os-release -> ../usr/lib/os-release
```

## permissions

### rwx

The nine characters following the file type denote the permissions in three triplets. A permission can be `r` for **r**ead access, `w` for **w**rite access, and `x` for e**x**ecute. You need the `r` permission to list (ls) the contents of a directory. You need the `x` permission to enter (cd) a directory. You need the `w` permission to create files in or remove files from a directory.

| permission  | on a file                  | on a directory                     |
| :---------: | :------------------------- | :--------------------------------- |
|  **r**ead   | read file contents (`cat`) | read directory contents (`ls`)     |
|  **w**rite  | change file contents       | create/delete files (`touch`,`rm`) |
| e**x**ecute | execute the file           | enter the directory (`cd`)         |

### three sets of rwx

We already know that the output of `ls -l` starts with ten characters for each file. This example shows a regular file (because the first character is a - ).

```console
student@linux:~/test$ ls -l proc42.sh
-rwxr-xr--  1 student proj  984 Feb  6 12:01 proc42.sh
```

Below is a table describing the function of all ten characters.

| position | characters | function                          |
| :------: | :--------: | :-------------------------------- |
|    1     |    `-`     | file type                         |
|   2-4    |   `rwx`    | permissions for the *user owner*  |
|   5-7    |   `r-x`    | permissions for the *group owner* |
|   8-10   |   `r--`    | permissions for *others*          |

When you are the *user owner* of a file, then the *user owner permissions* apply to you. The rest of the permissions have no influence on your access to the file.

When you belong to the *group* that is the *group owner* of a file, then the *group owner permissions* apply to you. The rest of the permissions have no influence on your access to the file.

When you are not the *user owner* of a file and you do not belong to the *group owner*, then the *others permissions* apply to you. The rest of the permissions have no influence on your access to the file.

### permission examples

Some example combinations on files and directories are seen in this example. The name of the file explains the permissions.

```console
student@linux:~/perms$ ls -lh
total 12K
drwxr-xr-x 2 student student 4.0K 2007-02-07 22:26 AllEnter_UserCreateDelete
-rwxrwxrwx 1 student student    0 2007-02-07 22:21 EveryoneFullControl.txt
-r--r----- 1 student student    0 2007-02-07 22:21 OnlyOwnersRead.txt
-rwxrwx--- 1 student student    0 2007-02-07 22:21 OwnersAll_RestNothing.txt
dr-xr-x--- 2 student student 4.0K 2007-02-07 22:25 UserAndGroupEnter
dr-x------ 2 student student 4.0K 2007-02-07 22:25 OnlyUserEnter
```

To summarise, the first `rwx` triplet represents the permissions for the *user owner*. The second triplet corresponds to the *group owner*; it specifies permissions for all members of that group. The third triplet defines permissions for all *other* users that are not the *user owner* and are not a member of the *group owner*. The `root` user ignores all restrictions and can do anything with any file.

### setting permissions with symbolic notation

Permissions can be changed with `chmod MODE FILE...`. You need to be the owner of the file to do this. The first example gives (`+`) the *user owner* (`u`) execute (`x`) permissions.

```console
student@linux:~/perms$ ls -l permissions.txt 
-rw-r--r-- 1 student student 0 2007-02-07 22:34 permissions.txt
student@linux:~/perms$ chmod u+x permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rwxr--r-- 1 student student 0 2007-02-07 22:34 permissions.txt
```

This example removes (`-`) the group owner's (`g`) read (`r`) permission.

```console
student@linux:~/perms$ chmod g-r permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rwx---r-- 1 student student 0 2007-02-07 22:34 permissions.txt
```

This example removes (`-`) the other's (`o`) read (`r`) permission.

```console
student@linux:~/perms$ chmod o-r permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rwx------ 1 student student 0 2007-02-07 22:34 permissions.txt
```

This example gives (`+`) all (`a`) of them the write (`w`) permission.

```console
student@linux:~/perms$ chmod a+w permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rwx-w--w- 1 student student 0 2007-02-07 22:34 permissions.txt
```

You don't even have to type the `a`.

```console
student@linux:~/perms$ chmod +x permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rwx-wx-wx 1 student student 0 2007-02-07 22:34 permissions.txt
```

You can also set explicit permissions with `=`.

```console
student@linux:~/perms$ chmod u=rw permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rw--wx-wx 1 student student 0 2007-02-07 22:34 permissions.txt
```

Feel free to make any kind of combination, separating them with a comma. Remark that spaces are **not** allowed!

```console
student@linux:~/perms$ chmod u=rw,g=rw,o=r permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rw-rw-r-- 1 student student 0 2007-02-07 22:34 permissions.txt
```

Even fishy combinations are accepted by `chmod`.

```console
student@linux:~/perms$ chmod u=rwx,ug+rw,o=r permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rwxrw-r-- 1 student student 0 2007-02-07 22:34 permissions.txt
```

**Summarized**, in order to change permissions with `chmod` using symbolic notation:

- first specify who the permissions are for: `u` for the user owner, `g` for the group owner, `o` for others, and `a` for all. `a` is the default and can be omitted.
- then specify the operation: `+` to add permissions, `-` to remove permissions, and `=` to set permissions.
- finally specify the permission(s): `r` for read, `w` for write, and `x` for execute.
- multiple operations can be combined with a comma (no spaces!)

### setting permissions with octal notation

Most Unix administrators will use the "old school" octal system to talk about and set permissions. Consider the triplet to be a binary number with 0 indicating the permission is not set and 1 indicating the permission is set. You then have $2^3=8$ possible combinations, hence the name *octal*. You can then convert the binary number to an octal number, equating `r` to 4, `w` to 2, and `x` to 1.

| permission | binary | octal |
| :--------: | :----: | :---: |
|   `---`    |  000   |   0   |
|   `--x`    |  001   |   1   |
|   `-w-`    |  010   |   2   |
|   `-wx`    |  011   |   3   |
|   `r--`    |  100   |   4   |
|   `r-x`    |  101   |   5   |
|   `rw-`    |  110   |   6   |
|   `rwx`    |  111   |   7   |

Since we have three triplets, we can use three octal digits to represent the permissions. This makes 777 equal to `rwxrwxrwx` and by the same logic, 654 mean `rw-r-xr--`. The `chmod` command will accept these numbers.

```console
student@linux:~/perms$ chmod 777 permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rwxrwxrwx 1 student student 0 2007-02-07 22:34 permissions.txt
student@linux:~/perms$ chmod 664 permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rw-rw-r-- 1 student student 0 2007-02-07 22:34 permissions.txt
student@linux:~/perms$ chmod 750 permissions.txt 
student@linux:~/perms$ ls -l permissions.txt 
-rwxr-x--- 1 student student 0 2007-02-07 22:34 permissions.txt
```

Remark that in practice, some combinations will never occur:

- The permissions of a user will never be smaller than the permissions of the group owner or others. Consequently, the digits will always be in descending order.
- Setting the write or execute permission without read access is useless. Consequently, you will never use 1, 2, or 3 in an octal permission code
- A directory will always have the read and execute permission set or unset together. It is useless to allow a user to read the directory contents, but not let them `cd` into that directory. Allowing `cd` without read access is also useless. The permission code for a directory will therefore always be odd.

Here's a little tip: you can print the permissions of a file in either octal or symbolic notation with the `stat` command (check the man page of `stat` to see how this works).

```console
[student@linux ~]$ stat -c '%A %a' /etc/passwd
-rw-r--r-- 644
[student@linux ~]$ stat -c '%A %a' /etc/shadow
---------- 0
[student@linux ~]$ stat -c '%A %a' /bin/ls
-rwxr-xr-x 755
```

### umask

When creating a file or directory, a set of default permissions are applied. These default permissions are determined by the `umask` value. The `umask` specifies permissions that you do not want set on by default. You can display the `umask` with the `umask` command.

```console
[student@linux ~]$ umask
0002
[student@linux ~]$ touch test
[student@linux ~]$ ls -l test
-rw-rw-r--  1 student student    0 Jul 24 06:03 test
[student@linux ~]$
```

As you can also see, the file is also not executable by default. This is a general security feature among Unixes; newly created files are never executable by default. You have to explicitly do a `chmod +x` to make a file executable. This also means that the 1 bit in the `umask` has no meaning. A `umask` value of 0022 has the same effect as 0033.

In practice, you will only use umask values:

- 0: don't take away any permissions
- 2: take away write permissions
- 7: take away all permissions

You can set the `umask` value to a new value with the `umask` command. The `umask` value is a four-digit octal number. The first digit is for special permissions (and is always zero), the second for the user permissions (is in practice always 0, since there is no use in taking away the user's permissions), the third for the group owner (sometimes 0, but usually 2 or 7), and the last for others (usually 2 or 7, 0 is very uncommon and can be considered to be a security risk).

The `umask` value is subtracted from 777 to get the default permissions and in the case of a file, the execute bit is removed.

```console
[student@linux ~]$ umask 0002
[student@linux ~]$ touch file0002
[student@linux ~]$ mkdir dir0002
[student@linux ~]$ ls -ld *0002
drwxrwxr-x. 2 student student 6 Mar  8 10:48 dir0002
-rw-rw-r--. 1 student student 0 Mar  8 10:47 file0002
[student@linux ~]$ umask 0027
[student@linux ~]$ touch file0027
[student@linux ~]$ mkdir dir0027
[student@linux ~]$ ls -ld *0027
drwxr-x---. 2 student student 6 Mar  8 10:48 dir0027
-rw-r-----. 1 student student 0 Mar  8 10:48 file0027
[student@linux ~]$ umask 0077
[student@linux ~]$ touch file0077
[student@linux ~]$ mkdir dir0077
[student@linux ~]$ ls -ld *0077
drwx------. 2 student student 6 Mar  8 10:51 dir0077
-rw-------. 1 student student 0 Mar  8 10:51 file0077
```

### mkdir -m

When creating directories with `mkdir` you can use the `-m` option to set the `mode`. This example explains.

```console
student@linux~$ mkdir -m 700 MyDir
student@linux~$ mkdir -m 777 Public
student@linux~$ ls -dl MyDir/ Public/
drwx------ 2 student student 4096 2011-10-16 19:16 MyDir/
drwxrwxrwx 2 student student 4096 2011-10-16 19:16 Public/
```

### cp -p

To preserve permissions and time stamps from source files, use `cp -p`.

```console
student@linux:~/perms$ cp file* cp
student@linux:~/perms$ cp -p file* cpp
student@linux:~/perms$ ll *
-rwx------ 1 student student    0 2008-08-25 13:26 file33
-rwxr-x--- 1 student student    0 2008-08-25 13:26 file42

cp:
total 0
-rwx------ 1 student student 0 2008-08-25 13:34 file33
-rwxr-x--- 1 student student 0 2008-08-25 13:34 file42

cpp:
total 0
-rwx------ 1 student student 0 2008-08-25 13:26 file33
-rwxr-x--- 1 student student 0 2008-08-25 13:26 file42
```

