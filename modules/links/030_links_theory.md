## inodes

### inode contents

An `inode` is a data structure that contains metadata about a file. When
the file system stores a new file on the hard disk, it stores not only
the contents (data) of the file, but also extra properties like the name
of the file, the creation date, its permissions, the owner of the file,
and more. All this information (except the name of the file and the
contents of the file) is stored in the `inode` of the file.

The `ls -l` command will display some of the inode
contents, as seen in this screenshot.

    root@linux ~# ls -ld /home/project42/
    drwxr-xr-x 4 root pro42 4.0K Mar 27 14:29 /home/project42/

### inode table

The `inode table` contains all of the `inodes` and is
created when you create the file system (with `mkfs`). You
can use the `df -i` command to see how many `inodes` are
used and free on mounted file systems.

    root@linux ~# df -i
    Filesystem            Inodes   IUsed   IFree IUse% Mounted on
    /dev/mapper/VolGroup00-LogVol00
                         4947968  115326 4832642    3% /
    /dev/hda1              26104      45   26059    1% /boot
    tmpfs                  64417       1   64416    1% /dev/shm
    /dev/sda1             262144    2207  259937    1% /home/project42
    /dev/sdb1              74400    5519   68881    8% /home/project33
    /dev/sdb5                  0       0       0    -  /home/sales
    /dev/sdb6             100744      11  100733    1% /home/research

In the `df -i` screenshot above you can see the `inode` usage for
several mounted `file systems`. You don't see numbers for `/dev/sdb5`
because it is a `fat` file system.

### inode number

Each `inode` has a unique number (the inode number). You can see the
`inode` numbers with the `ls -li` command.

    student@linux:~/test$ touch file1
    student@linux:~/test$ touch file2
    student@linux:~/test$ touch file3
    student@linux:~/test$ ls -li
    total 12
    817266 -rw-rw-r--  1 paul paul 0 Feb  5 15:38 file1
    817267 -rw-rw-r--  1 paul paul 0 Feb  5 15:38 file2
    817268 -rw-rw-r--  1 paul paul 0 Feb  5 15:38 file3
    student@linux:~/test$

These three files were created one after the other and got three
different `inodes` (the first column). All the information you see with
this `ls` command resides in the `inode`, except for the filename (which
is contained in the directory).

### inode and file contents

Let's put some data in one of the files.

    student@linux:~/test$ ls -li
    total 16
    817266 -rw-rw-r--  1 paul paul  0 Feb  5 15:38 file1
    817270 -rw-rw-r--  1 paul paul 92 Feb  5 15:42 file2
    817268 -rw-rw-r--  1 paul paul  0 Feb  5 15:38 file3
    student@linux:~/test$ cat file2
    It is winter now and it is very cold.
    We do not like the cold, we prefer hot summer nights.
    student@linux:~/test$

The data that is displayed by the `cat` command is not in the `inode`,
but somewhere else on the disk. The `inode` contains a pointer to that
data.

## about directories

### a directory is a table

A `directory` is a special kind of file that contains a
table which maps filenames to inodes. Listing our current directory with
`ls -ali` will display the contents of the directory file.

    student@linux:~/test$ ls -ali
    total 32
    817262 drwxrwxr-x   2 paul paul 4096 Feb  5 15:42 .
    800768 drwx------  16 paul paul 4096 Feb  5 15:42 ..
    817266 -rw-rw-r--   1 paul paul    0 Feb  5 15:38 file1
    817270 -rw-rw-r--   1 paul paul   92 Feb  5 15:42 file2
    817268 -rw-rw-r--   1 paul paul    0 Feb  5 15:38 file3
    student@linux:~/test$

### . and ..

You can see five names, and the mapping to their five inodes. The dot
`.` is a mapping to itself, and the dotdot
`..` is a mapping to the parent directory. The three other
names are mappings to different inodes.

## hard links

### creating hard links

When we create a `hard link` to a file with
`ln`, an extra entry is added in the directory. A new file
name is mapped to an existing inode.

    student@linux:~/test$ ln file2 hardlink_to_file2
    student@linux:~/test$ ls -li
    total 24
    817266 -rw-rw-r--  1 paul paul  0 Feb  5 15:38 file1
    817270 -rw-rw-r--  2 paul paul 92 Feb  5 15:42 file2
    817268 -rw-rw-r--  1 paul paul  0 Feb  5 15:38 file3
    817270 -rw-rw-r--  2 paul paul 92 Feb  5 15:42 hardlink_to_file2
    student@linux:~/test$

Both files have the same inode, so they will always have the same
permissions and the same owner. Both files will have the same content.
Actually, both files are equal now, meaning you can safely remove the
original file, the hardlinked file will remain. The inode contains a
counter, counting the number of hard links to itself. When the counter
drops to zero, then the inode is emptied.

### finding hard links

You can use the `find` command to look for files with a
certain inode. The screenshot below shows how to search for all
filenames that point to `inode` 817270. Remember that an
`inode` number is unique to its partition.

    student@linux:~/test$ find / -inum 817270 2> /dev/null
    /home/paul/test/file2
    /home/paul/test/hardlink_to_file2

## symbolic links

Symbolic links (sometimes called `soft links`) do not link
to inodes, but create a name to name mapping. Symbolic links are created
with `ln -s`. As you can see below, the
`symbolic link` gets an inode of its own.

    student@linux:~/test$ ln -s file2 symlink_to_file2
    student@linux:~/test$ ls -li
    total 32
    817273 -rw-rw-r--  1 paul paul  13 Feb  5 17:06 file1
    817270 -rw-rw-r--  2 paul paul 106 Feb  5 17:04 file2
    817268 -rw-rw-r--  1 paul paul   0 Feb  5 15:38 file3
    817270 -rw-rw-r--  2 paul paul 106 Feb  5 17:04 hardlink_to_file2
    817267 lrwxrwxrwx  1 paul paul   5 Feb  5 16:55 symlink_to_file2 -> file2
    student@linux:~/test$

Permissions on a symbolic link have no meaning, since the permissions of
the target apply. Hard links are limited to their own partition (because
they point to an inode), symbolic links can link anywhere (other file
systems, even networked).

## removing links

Links can be removed with `rm`.

    student@linux:~$ touch data.txt
    student@linux:~$ ln -s data.txt sl_data.txt
    student@linux:~$ ln data.txt hl_data.txt
    student@linux:~$ rm sl_data.txt 
    student@linux:~$ rm hl_data.txt

