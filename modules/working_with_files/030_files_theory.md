## all files are case sensitive

Files on Linux (or any Unix) are `case sensitive`. This
means that `FILE1` is different from `file1`, and `/etc/hosts` is
different from `/etc/Hosts` (the latter one does not exist on a typical
Linux computer).

This screenshot shows the difference between two files, one with upper
case `W`, the other with lower case `w`.

    student@linux:~/Linux$ ls
    winter.txt  Winter.txt
    student@linux:~/Linux$ cat winter.txt
    It is cold.
    student@linux:~/Linux$ cat Winter.txt
    It is very cold!

## everything is a file

A `directory` is a special kind of `file`, but it is still a (case
sensitive!) `file`. Each terminal window (for example `/dev/pts/4`), any
hard disk or partition (for example `/dev/sdb1`) and any process are all
represented somewhere in the `file system` as a `file`. It will become
clear throughout this course that everything on Linux is a `file`.

## file

The `file` utility determines the file type. Linux does
not use extensions to determine the file type. The command line does not
care whether a file ends in .txt or .pdf. As a system administrator, you
should use the `file` command to determine the file type. Here are some
examples on a typical Linux system.

    student@linux:~$ file pic33.png
    pic33.png: PNG image data, 3840 x 1200, 8-bit/color RGBA, non-interlaced
    student@linux:~$ file /etc/passwd
    /etc/passwd: ASCII text
    student@linux:~$ file HelloWorld.c
    HelloWorld.c: ASCII C program text

The file command uses a magic file that contains patterns to recognise
file types. The magic file is located in
`/usr/share/file/magic`. Type `man 5 magic` for more
information.

It is interesting to point out `file -s` for special files like those in
`/dev` and `/proc`.

    root@linux~# file /dev/sda
    /dev/sda: block special
    root@linux~# file -s /dev/sda
    /dev/sda: x86 boot sector; partition 1: ID=0x83, active, starthead...
    root@linux~# file /proc/cpuinfo 
    /proc/cpuinfo: empty
    root@linux~# file -s /proc/cpuinfo
    /proc/cpuinfo: ASCII C++ program text

## touch

### create an empty file

One easy way to create an empty file is with `touch`. (We
will see many other ways for creating files later in this book.)

This screenshot starts with an empty directory, creates two files with
`touch` and the lists those files.

    student@linux:~$ ls -l
    total 0
    student@linux:~$ touch file42
    student@linux:~$ touch file33
    student@linux:~$ ls -l
    total 0
    -rw-r--r-- 1 paul paul 0 Oct 15 08:57 file33
    -rw-r--r-- 1 paul paul 0 Oct 15 08:56 file42
    student@linux:~$

### touch -t

The `touch` command can set some properties while creating empty files.
Can you determine what is set by looking at the next screenshot? If not,
check the manual for `touch`.

    student@linux:~$ touch -t 200505050000 SinkoDeMayo
    student@linux:~$ touch -t 130207111630 BigBattle.txt
    student@linux:~$ ls -l
    total 0
    -rw-r--r-- 1 paul paul 0 Jul 11  1302 BigBattle.txt
    -rw-r--r-- 1 paul paul 0 Oct 15 08:57 file33
    -rw-r--r-- 1 paul paul 0 Oct 15 08:56 file42
    -rw-r--r-- 1 paul paul 0 May  5  2005 SinkoDeMayo
    student@linux:~$

## rm

### remove forever

When you no longer need a file, use `rm` to remove it.
Unlike some graphical user interfaces, the command line in general does
not have a `waste bin` or `trash can` to recover files. When you use
`rm` to remove a file, the file is gone. Therefore, be careful when
removing files!

    student@linux:~$ ls
    BigBattle.txt  file33  file42  SinkoDeMayo
    student@linux:~$ rm BigBattle.txt
    student@linux:~$ ls
    file33  file42  SinkoDeMayo
    student@linux:~$

### rm -i

To prevent yourself from accidentally removing a file, you can type
`rm -i`.

    student@linux:~$ ls
    file33  file42  SinkoDeMayo
    student@linux:~$ rm -i file33
    rm: remove regular empty file `file33'? yes
    student@linux:~$ rm -i SinkoDeMayo
    rm: remove regular empty file `SinkoDeMayo'? n
    student@linux:~$ ls
    file42  SinkoDeMayo
    student@linux:~$

### rm -rf

By default, `rm -r` will not remove non-empty directories. However `rm`
accepts several options that will allow you to remove any directory. The
`rm -rf` statement is famous because it will erase
anything (providing that you have the permissions to do so). When you
are logged on as root, be very careful with `rm -rf` (the `f` means
`force` and the `r` means `recursive`) since being root implies that
permissions don't apply to you. You can literally erase your entire
file system by accident.

    student@linux:~$ mkdir test
    student@linux:~$ rm test
    rm: cannot remove `test': Is a directory
    student@linux:~$ rm -rf test
    student@linux:~$ ls test
    ls: cannot access test: No such file or directory
    student@linux:~$

## cp

### copy one file

To copy a file, use `cp` with a source and a target
argument.

    student@linux:~$ ls
    file42  SinkoDeMayo
    student@linux:~$ cp file42 file42.copy
    student@linux:~$ ls
    file42  file42.copy  SinkoDeMayo

### copy to another directory

If the target is a directory, then the source files are copied to that
target directory.

    student@linux:~$ mkdir dir42
    student@linux:~$ cp SinkoDeMayo dir42
    student@linux:~$ ls dir42/
    SinkoDeMayo

### cp -r

To copy complete directories, use `cp -r` (the `-r` option
forces `recursive` copying of all files in all subdirectories).

    student@linux:~$ ls
    dir42  file42  file42.copy  SinkoDeMayo
    student@linux:~$ cp -r dir42/ dir33
    student@linux:~$ ls
    dir33  dir42  file42  file42.copy  SinkoDeMayo
    student@linux:~$ ls dir33/
    SinkoDeMayo

### copy multiple files to directory

You can also use cp to copy multiple files into a directory. In this
case, the last argument (a.k.a. the target) must be a directory.

    student@linux:~$ cp file42 file42.copy SinkoDeMayo dir42/
    student@linux:~$ ls dir42/
    file42  file42.copy  SinkoDeMayo

### cp -i

To prevent `cp` from overwriting existing files, use the `-i` (for
interactive) option.

    student@linux:~$ cp SinkoDeMayo file42
    student@linux:~$ cp SinkoDeMayo file42
    student@linux:~$ cp -i SinkoDeMayo file42
    cp: overwrite `file42'? n
    student@linux:~$

## mv

### rename files with mv

Use `mv` to rename a file or to move the file to another
directory.

    student@linux:~$ ls
    dir33  dir42  file42  file42.copy  SinkoDeMayo
    student@linux:~$ mv file42 file33
    student@linux:~$ ls
    dir33  dir42  file33  file42.copy  SinkoDeMayo
    student@linux:~$

When you need to rename only one file then `mv` is the preferred command
to use.

### rename directories with mv

The same `mv` command can be used to rename directories.

    student@linux:~$ ls -l
    total 8
    drwxr-xr-x 2 paul paul 4096 Oct 15 09:36 dir33
    drwxr-xr-x 2 paul paul 4096 Oct 15 09:36 dir42
    -rw-r--r-- 1 paul paul    0 Oct 15 09:38 file33
    -rw-r--r-- 1 paul paul    0 Oct 15 09:16 file42.copy
    -rw-r--r-- 1 paul paul    0 May  5  2005 SinkoDeMayo
    student@linux:~$ mv dir33 backup
    student@linux:~$ ls -l
    total 8
    drwxr-xr-x 2 paul paul 4096 Oct 15 09:36 backup
    drwxr-xr-x 2 paul paul 4096 Oct 15 09:36 dir42
    -rw-r--r-- 1 paul paul    0 Oct 15 09:38 file33
    -rw-r--r-- 1 paul paul    0 Oct 15 09:16 file42.copy
    -rw-r--r-- 1 paul paul    0 May  5  2005 SinkoDeMayo
    student@linux:~$

### mv -i

The `mv` also has a `-i` switch similar to `cp` and `rm`.

this screenshot shows that `mv -i` will ask permission to overwrite an
existing file.

    student@linux:~$ mv -i file33 SinkoDeMayo
    mv: overwrite `SinkoDeMayo'? no
    student@linux:~$

## rename

### about rename

The `rename` command is one of the rare occasions where the Linux
Fundamentals book has to make a distinction between Linux distributions.
Almost every command in the `Fundamentals` part of this book works on
almost every Linux computer. But `rename` is different.

Try to use `mv` whenever you need to rename only a couple of files.

### rename on Debian/Ubuntu

The `rename` command on Debian uses regular expressions
(regular expression or shor regex are explained in a later chapter) to
rename many files at once.

Below a `rename` example that switches all occurrences of txt to png for
all file names ending in .txt.

    student@linux:~/test42$ ls
    abc.txt  file33.txt  file42.txt
    student@linux:~/test42$ rename 's/.txt/.png/' *.txt
    student@linux:~/test42$ ls
    abc.png  file33.png  file42.png

This second example switches all (first) occurrences of `file` into
`document` for all file names ending in .png.

    student@linux:~/test42$ ls
    abc.png  file33.png  file42.png
    student@linux:~/test42$ rename 's/file/document/' *.png
    student@linux:~/test42$ ls
    abc.png  document33.png  document42.png
    student@linux:~/test42$

### rename on CentOS/RHEL/Fedora

On Red Hat Enterprise Linux, the syntax of `rename` is a bit different.
The first example below renames all \*.conf files replacing any
occurrence of .conf with .backup.

    [student@linux ~]$ touch one.conf two.conf three.conf
    [student@linux ~]$ rename .conf .backup *.conf
    [student@linux ~]$ ls
    one.backup  three.backup  two.backup
    [student@linux ~]$

The second example renames all (\*) files replacing one with ONE.

    [student@linux ~]$ ls
    one.backup  three.backup  two.backup
    [student@linux ~]$ rename one ONE *
    [student@linux ~]$ ls
    ONE.backup  three.backup  two.backup
    [student@linux ~]$

