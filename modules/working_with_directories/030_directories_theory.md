## pwd

The `you are here` sign can be displayed with the `pwd`
command (Print Working Directory). Go ahead, try it: Open a command line
interface (also called a terminal, console or xterm) and type `pwd`. The
tool displays your `current directory`.

    paul@debian8:~$ pwd
    /home/paul

## cd

You can change your current directory with the `cd`
command (Change Directory).

    paul@debian8$ cd /etc
    paul@debian8$ pwd
    /etc
    paul@debian8$ cd /bin
    paul@debian8$ pwd
    /bin
    paul@debian8$ cd /home/paul/
    paul@debian8$ pwd
    /home/paul

### cd \~

The `cd` is also a shortcut to get back into your home directory. Just
typing `cd` without a target directory, will put you in your home
directory. Typing `cd ~` has the same effect.

    paul@debian8$ cd /etc
    paul@debian8$ pwd
    /etc
    paul@debian8$ cd
    paul@debian8$ pwd
    /home/paul
    paul@debian8$ cd ~
    paul@debian8$ pwd
    /home/paul

### cd ..

To go to the `parent directory` (the one just above your
current directory in the directory tree), type `cd ..` .

    paul@debian8$ pwd
    /usr/share/games
    paul@debian8$ cd ..
    paul@debian8$ pwd
    /usr/share

*To stay in the current directory, type `cd .` ;-)* We
will see useful use of the `.` character representing the current
directory later.

### cd -

Another useful shortcut with `cd` is to just type `cd -`
to go to the previous directory.

    paul@debian8$ pwd
    /home/paul
    paul@debian8$ cd /etc
    paul@debian8$ pwd
    /etc
    paul@debian8$ cd -
    /home/paul
    paul@debian8$ cd -
    /etc

## absolute and relative paths

You should be aware of `absolute and relative paths` in
the file tree. When you type a path starting with a `slash (/)`, then
the `root` of the file tree is assumed. If you don\'t
start your path with a slash, then the current directory is the assumed
starting point.

The screenshot below first shows the current directory `/home/paul`.
From within this directory, you have to type `cd /home` instead of
`cd home` to go to the `/home` directory.

    paul@debian8$ pwd
    /home/paul
    paul@debian8$ cd home
    bash: cd: home: No such file or directory
    paul@debian8$ cd /home
    paul@debian8$ pwd
    /home

When inside `/home`, you have to type `cd paul` instead of `cd /paul` to
enter the subdirectory `paul` of the current directory `/home`.

    paul@debian8$ pwd
    /home
    paul@debian8$ cd /paul
    bash: cd: /paul: No such file or directory
    paul@debian8$ cd paul
    paul@debian8$ pwd
    /home/paul

In case your current directory is the `root directory /`, then both
`cd /home` and `cd home` will get you in the `/home` directory.

    paul@debian8$ pwd
    /
    paul@debian8$ cd home
    paul@debian8$ pwd
    /home
    paul@debian8$ cd /
    paul@debian8$ cd /home 
    paul@debian8$ pwd
    /home

This was the last screenshot with `pwd` statements. From
now on, the current directory will often be displayed in the prompt.
Later in this book we will explain how the shell variable
`$PS1` can be configured to show this.

## path completion

The `tab key` can help you in typing a path without
errors. Typing `cd /et` followed by the `tab key` will expand the
command line to `cd /etc/`. When typing `cd /Et` followed by the
`tab key`, nothing will happen because you typed the wrong
`path` (upper case E).

You will need fewer key strokes when using the `tab key`, and you will
be sure your typed `path` is correct!

## ls

You can list the contents of a directory with `ls`.

    paul@debian8:~$ ls
    allfiles.txt  dmesg.txt  services   stuff  summer.txt
    paul@debian8:~$

### ls -a

A frequently used option with ls is `-a` to show all files. Showing all
files means including the `hidden files`. When a file name
on a Linux file system starts with a dot, it is considered a
`hidden file` and it doesn\'t show up in regular file listings.

    paul@debian8:~$ ls
    allfiles.txt  dmesg.txt  services  stuff  summer.txt
    paul@debian8:~$ ls -a
    .   allfiles.txt   .bash_profile  dmesg.txt   .lesshst  stuff
    ..  .bash_history  .bashrc        services    .ssh      summer.txt 
    paul@debian8:~$

### ls -l

Many times you will be using options with `ls` to display the contents
of the directory in different formats or to display different parts of
the directory. Typing just `ls` gives you a list of files in the
directory. Typing `ls -l` (that is a letter L, not the
number 1) gives you a long listing.

    paul@debian8:~$ ls -l
    total 17296
    -rw-r--r-- 1 paul paul 17584442 Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul    96650 Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul    19558 Sep 17 00:04 services
    drwxr-xr-x 2 paul paul     4096 Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul        0 Sep 17 00:04 summer.txt

### ls -lh

Another frequently used ls option is `-h`. It shows the numbers (file
sizes) in a more human readable format. Also shown below is some
variation in the way you can give the options to `ls`. We will explain
the details of the output later in this book.

*Note that we use the letter L as an option in this screenshot, not the
number 1.*

    paul@debian8:~$ ls -l -h
    total 17M
    -rw-r--r-- 1 paul paul  17M Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul  95K Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul  20K Sep 17 00:04 services
    drwxr-xr-x 2 paul paul 4.0K Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul    0 Sep 17 00:04 summer.txt
    paul@debian8:~$ ls -lh
    total 17M
    -rw-r--r-- 1 paul paul  17M Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul  95K Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul  20K Sep 17 00:04 services
    drwxr-xr-x 2 paul paul 4.0K Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul    0 Sep 17 00:04 summer.txt
    paul@debian8:~$ ls -hl
    total 17M
    -rw-r--r-- 1 paul paul  17M Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul  95K Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul  20K Sep 17 00:04 services
    drwxr-xr-x 2 paul paul 4.0K Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul    0 Sep 17 00:04 summer.txt
    paul@debian8:~$ ls -h -l
    total 17M
    -rw-r--r-- 1 paul paul  17M Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul  95K Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul  20K Sep 17 00:04 services
    drwxr-xr-x 2 paul paul 4.0K Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul    0 Sep 17 00:04 summer.txt
    paul@debian8:~$

## mkdir

Walking around the Unix file tree is fun, but it is even more fun to
create your own directories with `mkdir`. You have to give
at least one parameter to `mkdir`, the name of the new directory to be
created. Think before you type a leading `/` .

    paul@debian8:~$ mkdir mydir
    paul@debian8:~$ cd mydir
    paul@debian8:~/mydir$ ls -al
    total 8
    drwxr-xr-x  2 paul paul 4096 Sep 17 00:07 .
    drwxr-xr-x 48 paul paul 4096 Sep 17 00:07 ..
    paul@debian8:~/mydir$ mkdir stuff
    paul@debian8:~/mydir$ mkdir otherstuff
    paul@debian8:~/mydir$ ls -l
    total 8
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:08 otherstuff
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:08 stuff
    paul@debian8:~/mydir$

### mkdir -p

The following command will fail, because the `parent directory` of
`threedirsdeep` does not exist.

    paul@debian8:~$ mkdir mydir2/mysubdir2/threedirsdeep
    mkdir: cannot create directory ‘mydir2/mysubdir2/threedirsdeep’: No such fi\
    le or directory

When given the option `-p`, then `mkdir` will create
`parent directories` as needed.

    paul@debian8:~$ mkdir -p mydir2/mysubdir2/threedirsdeep
    paul@debian8:~$ cd mydir2
    paul@debian8:~/mydir2$ ls -l
    total 4
    drwxr-xr-x 3 paul paul 4096 Sep 17 00:11 mysubdir2
    paul@debian8:~/mydir2$ cd mysubdir2
    paul@debian8:~/mydir2/mysubdir2$ ls -l
    total 4
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:11 threedirsdeep
    paul@debian8:~/mydir2/mysubdir2$ cd threedirsdeep/
    paul@debian8:~/mydir2/mysubdir2/threedirsdeep$ pwd
    /home/paul/mydir2/mysubdir2/threedirsdeep

## rmdir

When a directory is empty, you can use `rmdir` to remove
the directory.

    paul@debian8:~/mydir$ ls -l
    total 8
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:08 otherstuff
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:08 stuff
    paul@debian8:~/mydir$ rmdir otherstuff
    paul@debian8:~/mydir$ cd ..
    paul@debian8:~$ rmdir mydir
    rmdir: failed to remove ‘mydir’: Directory not empty
    paul@debian8:~$ rmdir mydir/stuff
    paul@debian8:~$ rmdir mydir
    paul@debian8:~$

### rmdir -p

And similar to the `mkdir -p` option, you can also use
`rmdir` to recursively remove directories.

    paul@debian8:~$ mkdir -p test42/subdir
    paul@debian8:~$ rmdir -p test42/subdir
    paul@debian8:~$

