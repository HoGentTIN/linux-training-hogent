## pwd

The `you are here` sign can be displayed with the `pwd`
command (Print Working Directory). Go ahead, try it: Open a command line
interface (also called a terminal, console or xterm) and type `pwd`. The
tool displays your `current directory`.

    student@linux:~$ pwd
    /home/paul

## cd

You can change your current directory with the `cd`
command (Change Directory).

    student@linux$ cd /etc
    student@linux$ pwd
    /etc
    student@linux$ cd /bin
    student@linux$ pwd
    /bin
    student@linux$ cd /home/paul/
    student@linux$ pwd
    /home/paul

### cd \~

The `cd` is also a shortcut to get back into your home directory. Just
typing `cd` without a target directory, will put you in your home
directory. Typing `cd ~` has the same effect.

    student@linux$ cd /etc
    student@linux$ pwd
    /etc
    student@linux$ cd
    student@linux$ pwd
    /home/paul
    student@linux$ cd ~
    student@linux$ pwd
    /home/paul

### cd ..

To go to the `parent directory` (the one just above your
current directory in the directory tree), type `cd ..` .

    student@linux$ pwd
    /usr/share/games
    student@linux$ cd ..
    student@linux$ pwd
    /usr/share

*To stay in the current directory, type `cd .` ;-)* We
will see useful use of the `.` character representing the current
directory later.

### cd -

Another useful shortcut with `cd` is to just type `cd -`
to go to the previous directory.

    student@linux$ pwd
    /home/paul
    student@linux$ cd /etc
    student@linux$ pwd
    /etc
    student@linux$ cd -
    /home/paul
    student@linux$ cd -
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

    student@linux$ pwd
    /home/paul
    student@linux$ cd home
    bash: cd: home: No such file or directory
    student@linux$ cd /home
    student@linux$ pwd
    /home

When inside `/home`, you have to type `cd paul` instead of `cd /paul` to
enter the subdirectory `paul` of the current directory `/home`.

    student@linux$ pwd
    /home
    student@linux$ cd /paul
    bash: cd: /paul: No such file or directory
    student@linux$ cd paul
    student@linux$ pwd
    /home/paul

In case your current directory is the `root directory /`, then both
`cd /home` and `cd home` will get you in the `/home` directory.

    student@linux$ pwd
    /
    student@linux$ cd home
    student@linux$ pwd
    /home
    student@linux$ cd /
    student@linux$ cd /home 
    student@linux$ pwd
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

    student@linux:~$ ls
    allfiles.txt  dmesg.txt  services   stuff  summer.txt
    student@linux:~$

### ls -a

A frequently used option with ls is `-a` to show all files. Showing all
files means including the `hidden files`. When a file name
on a Linux file system starts with a dot, it is considered a
`hidden file` and it doesn\'t show up in regular file listings.

    student@linux:~$ ls
    allfiles.txt  dmesg.txt  services  stuff  summer.txt
    student@linux:~$ ls -a
    .   allfiles.txt   .bash_profile  dmesg.txt   .lesshst  stuff
    ..  .bash_history  .bashrc        services    .ssh      summer.txt 
    student@linux:~$

### ls -l

Many times you will be using options with `ls` to display the contents
of the directory in different formats or to display different parts of
the directory. Typing just `ls` gives you a list of files in the
directory. Typing `ls -l` (that is a letter L, not the
number 1) gives you a long listing.

    student@linux:~$ ls -l
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

    student@linux:~$ ls -l -h
    total 17M
    -rw-r--r-- 1 paul paul  17M Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul  95K Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul  20K Sep 17 00:04 services
    drwxr-xr-x 2 paul paul 4.0K Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul    0 Sep 17 00:04 summer.txt
    student@linux:~$ ls -lh
    total 17M
    -rw-r--r-- 1 paul paul  17M Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul  95K Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul  20K Sep 17 00:04 services
    drwxr-xr-x 2 paul paul 4.0K Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul    0 Sep 17 00:04 summer.txt
    student@linux:~$ ls -hl
    total 17M
    -rw-r--r-- 1 paul paul  17M Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul  95K Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul  20K Sep 17 00:04 services
    drwxr-xr-x 2 paul paul 4.0K Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul    0 Sep 17 00:04 summer.txt
    student@linux:~$ ls -h -l
    total 17M
    -rw-r--r-- 1 paul paul  17M Sep 17 00:03 allfiles.txt
    -rw-r--r-- 1 paul paul  95K Sep 17 00:03 dmesg.txt
    -rw-r--r-- 1 paul paul  20K Sep 17 00:04 services
    drwxr-xr-x 2 paul paul 4.0K Sep 17 00:04 stuff
    -rw-r--r-- 1 paul paul    0 Sep 17 00:04 summer.txt
    student@linux:~$

## mkdir

Walking around the Unix file tree is fun, but it is even more fun to
create your own directories with `mkdir`. You have to give
at least one parameter to `mkdir`, the name of the new directory to be
created. Think before you type a leading `/` .

    student@linux:~$ mkdir mydir
    student@linux:~$ cd mydir
    student@linux:~/mydir$ ls -al
    total 8
    drwxr-xr-x  2 paul paul 4096 Sep 17 00:07 .
    drwxr-xr-x 48 paul paul 4096 Sep 17 00:07 ..
    student@linux:~/mydir$ mkdir stuff
    student@linux:~/mydir$ mkdir otherstuff
    student@linux:~/mydir$ ls -l
    total 8
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:08 otherstuff
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:08 stuff
    student@linux:~/mydir$

### mkdir -p

The following command will fail, because the `parent directory` of
`threedirsdeep` does not exist.

    student@linux:~$ mkdir mydir2/mysubdir2/threedirsdeep
    mkdir: cannot create directory ‘mydir2/mysubdir2/threedirsdeep’: No such fi\
    le or directory

When given the option `-p`, then `mkdir` will create
`parent directories` as needed.

    student@linux:~$ mkdir -p mydir2/mysubdir2/threedirsdeep
    student@linux:~$ cd mydir2
    student@linux:~/mydir2$ ls -l
    total 4
    drwxr-xr-x 3 paul paul 4096 Sep 17 00:11 mysubdir2
    student@linux:~/mydir2$ cd mysubdir2
    student@linux:~/mydir2/mysubdir2$ ls -l
    total 4
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:11 threedirsdeep
    student@linux:~/mydir2/mysubdir2$ cd threedirsdeep/
    student@linux:~/mydir2/mysubdir2/threedirsdeep$ pwd
    /home/paul/mydir2/mysubdir2/threedirsdeep

## rmdir

When a directory is empty, you can use `rmdir` to remove
the directory.

    student@linux:~/mydir$ ls -l
    total 8
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:08 otherstuff
    drwxr-xr-x 2 paul paul 4096 Sep 17 00:08 stuff
    student@linux:~/mydir$ rmdir otherstuff
    student@linux:~/mydir$ cd ..
    student@linux:~$ rmdir mydir
    rmdir: failed to remove ‘mydir’: Directory not empty
    student@linux:~$ rmdir mydir/stuff
    student@linux:~$ rmdir mydir
    student@linux:~$

### rmdir -p

And similar to the `mkdir -p` option, you can also use
`rmdir` to recursively remove directories.

    student@linux:~$ mkdir -p test42/subdir
    student@linux:~$ rmdir -p test42/subdir
    student@linux:~$

