# Files

## Listing files


Files are always stored in a **directory** and there is always a
**current directory**. To see the *list* of files in the current
directory type **ls**.

    paul@debian10:~$ ls
    backup  cars  data  music
    paul@debian10:~$

Maybe you have some directories from the previous chapter. If not, then
create some with **mkdir**.

When executing a simple **ls** command, you cannot see the difference
between a file and a directory. To see the difference, you can use **ls
-l** (that is a lowercase letter l from **l**ong list).

    paul@debian10:~$ ls -l
    total 16
    drwxr-xr-x 2 paul paul 4096 Jul 24 23:07 backup
    drwxr-xr-x 3 paul paul 4096 Jul 25 01:24 cars
    drwxr-xr-x 3 paul paul 4096 Jul 25 01:00 data
    drwxr-xr-x 2 paul paul 4096 Jul 25 01:16 music
    paul@debian10:~$

Notice the first character of each line is a letter **d**. This is the
**d** from **directory**. (We will explain the rest later in this book).

## Creating files


Most applications on your Linux computer will be able to create files.
We will start with the very simple **touch** command to create empty
files. The example below creates three empty files in the **cars**
directory and then lists the contents of the **cars** directory.

    paul@debian10:~$ cd cars
    paul@debian10:~/cars$ touch bmw
    paul@debian10:~/cars$ touch fiat kia
    paul@debian10:~/cars$ ls -l
    total 4
    -rw-r--r-- 1 paul paul    0 Jul 25 03:52 bmw
    -rw-r--r-- 1 paul paul    0 Jul 25 03:52 fiat
    -rw-r--r-- 1 paul paul    0 Jul 25 03:52 kia
    drwxr-xr-x 2 paul paul 4096 Jul 25 01:24 mercedes
    paul@debian10:~/cars$

Notice that the three files have size 0, and that their lines start with
a **"-"** (called a hyphen or a dash). The **"-"** tells you that they
are **regular files**.

There is a time travel trick to **touch**; when using **touch -t** you
can create files with a custom time stamp. See this example to create a
file with the 1970-Feb-27 at 11:30 time stamp. (Later in the backup
chapter is an example of how this can be useful.)

    paul@debian10:~$ touch -t 197002271130 oldfile
    paul@debian10:~$ ls -l oldfile
    -rw-r--r-- 1 paul paul 0 Feb 27  1970 oldfile
    paul@debian10:~$

## Removing files


Now let us remove two files in the **cars** directory. To remove files
we use the **rm** command.

    paul@debian10:~/cars$ ls -l
    total 4
    -rw-r--r-- 1 paul paul    0 Jul 25 03:52 bmw
    -rw-r--r-- 1 paul paul    0 Jul 25 03:52 fiat
    -rw-r--r-- 1 paul paul    0 Jul 25 03:52 kia
    drwxr-xr-x 2 paul paul 4096 Jul 25 01:24 mercedes
    paul@debian10:~/cars$ rm bmw kia
    paul@debian10:~/cars$ ls -l
    total 4
    -rw-r--r-- 1 paul paul    0 Jul 25 03:52 fiat
    drwxr-xr-x 2 paul paul 4096 Jul 25 01:24 mercedes
    paul@debian10:~/cars$

Notice that you cannot remove a directory with **rm**.

    paul@debian10:~/cars$ ls -l
    total 4
    -rw-r--r-- 1 paul paul    0 Jul 25 03:52 fiat
    drwxr-xr-x 2 paul paul 4096 Jul 25 01:24 mercedes
    paul@debian10:~/cars$ rm mercedes/
    rm: cannot remove mercedes/: Is a directory
    paul@debian10:~/cars$

Did you use tab-completion when typing mercedes?

## Removing multiple files


The **rm** command can remove many files at once. We will see later in
the book how to use globbing with commands. In this example we create
three files and then we remove two of them. Notice that **rm** with the
option **-i** will ask for confirmation before erasing a file.

    paul@debian10:~$ mkdir files
    paul@debian10:~$ cd files
    paul@debian10:~/files$ touch one two three
    paul@debian10:~/files$ ls
    one  three  two
    paul@debian10:~/files$ rm -i one two three
    rm: remove regular empty file one? y
    rm: remove regular empty file two? n
    rm: remove regular empty file three? y
    paul@debian10:~/files$ ls
    two
    paul@debian10:~/files$

## Recursive force removal of a directory


Are you ready for the most dangerous command on Linux? Because we can
give two options to the **rm** command to **f**orce it to
**r**ecursively remove all files and directories in a directory.

See this example for the power of **rm -rf**.

    paul@debian10:~/cars$ ls
    fiat  mercedes
    paul@debian10:~/cars$ cd ..
    paul@debian10:~$ ls
    backup  cars  data  music
    paul@debian10:~$ rm -rf cars
    paul@debian10:~$ ls
    backup  data  music
    paul@debian10:~$

As you can see, no warning is given. The **rm -rf** command will remove
a directory and everything in it. There is no warning given, no
confirmation asked, there is also no recovery from this (except for
forensic tools).

## Downloading files with wget


Download the following five files from the internet with **wget**. Make
sure that your home directory is your current directory!

Use the **arrow-up key** instead of re-writing the same URL five times.

    paul@debian10:~$ cd
    paul@debian10:~$ wget http://linux-training.be/all.txt.gz
    --2019-07-27 13:16:59--  http://linux-training.be/all.txt.gz
    Resolving linux-training.be (linux-training.be)... 88.151.243.8
    Connecting to linux-training.be (linux-training.be)|88.151.243.8|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 332067 (324K) [application/x-gzip]
    Saving to: ‘all.txt.gz’

    all.txt.gz             100%[==========================>] 324.28K  --.-KB/s    in 0.08s

    2019-07-27 13:16:59 (4.06 MB/s) - ‘all.txt.gz’ saved [332067/332067]

    paul@debian10:~$ wget http://linux-training.be/linuxfun.pdf
    --2019-07-27 13:17:08--  http://linux-training.be/linuxfun.pdf
    Resolving linux-training.be (linux-training.be)... 88.151.243.8
    Connecting to linux-training.be (linux-training.be)|88.151.243.8|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 7022363 (6.7M) [application/pdf]
    Saving to: ‘linuxfun.pdf’

    linuxfun.pdf           100%[==========================>]   6.70M  6.54MB/s    in 1.0s

    2019-07-27 13:17:09 (6.54 MB/s) - ‘linuxfun.pdf’ saved [7022363/7022363]

    paul@debian10:~$ wget http://linux-training.be/dates.txt
    <cut output>
    paul@debian10:~$ wget http://linux-training.be/wolf.png
    <cut output>
    paul@debian10:~$ wget http://linux-training.be/studentfiles.html
    <cut output>
    paul@debian10:~$

Once downloaded you should be able to find them in your home directory.

    paul@debian10:~$ ls
    all.txt.gz  backup  data  dates.txt  linuxfun.pdf  music  studentfiles.html  wolf.png
    paul@debian10:~$

## Identifying files


There is a command named **file** that can help in identifying files.
For example in the screenshot below we use the **file** command to
obtain information about **all.txt.gz**.

    paul@debian10:~$ file all.txt.gz
    all.txt.gz: gzip compressed data, was "allfiles.txt", last modified: Thu Jul 25 02:59:57 2019, from Unix, original size 2903154
    paul@debian10:~$

As you can see the **file** command gives a lot of information; the file
is **gzip compressed**, it was **allfiles.txt** and its original size
was **2903154** (bytes). Let’s do the same for the **wolf.png** file.

    paul@debian10:~$ file wolf.png
    wolf.png: PNG image data, 1280 x 960, 8-bit/color RGB, non-interlaced
    paul@debian10:~$

As expected, the **file** command gives us PNG image information. Try
for yourself on the other files, and on a directory. The output should
be similar to this screenshot.

    paul@debian10:~$ file dates.txt
    dates.txt: ASCII text
    paul@debian10:~$ file linuxfun.pdf
    linuxfun.pdf: PDF document, version 1.4
    paul@debian10:~$ file studentfiles.html
    studentfiles.html: HTML document, ASCII text
    paul@debian10:~$ file music/
    music/: directory
    paul@debian10:~$

Instead of typing **file studentfiles.html** you can type **file s** tab
key.

## Copying files


### cp

Copying files is the simplest form of a backup. In this example we use
the **cp** command to copy two files to the **backup** directory.

    paul@debian10:~$ ls backup/
    paul@debian10:~$ cp dates.txt backup/
    paul@debian10:~$ cp linuxfun.pdf backup/
    paul@debian10:~$ ls backup/
    dates.txt  linuxfun.pdf
    paul@debian10:~$

Notice that we use two arguments to the **cp** command. The first one is
the file to copy, and the second one is the target directory.

You can copy multiple files in one command. To do this you have to list
all the files and provide the target directory as the very last
argument. In the example below we copy three files to the backup
directory.

    paul@debian10:~$ cp all.txt.gz studentfiles.html wolf.png backup/
    paul@debian10:~$

### cp rename

You can also use the **cp** command to give the copied file a different
name. In this screenshot we copy **linuxfun.pdf** and rename the copy to
**linux.pdf**.

    paul@debian10:~$ cp linuxfun.pdf linux.pdf
    paul@debian10:~$ ls
    all.txt.gz  data       linuxfun.pdf  music              wolf.png
    backup      dates.txt  linux.pdf     studentfiles.html
    paul@debian10:~$

### cp -i

The **cp** command has a **-i** option to prevent accidentally
overwriting existing files. In the example below we try to copy a file
twice to the same destination directory. Thanks to the **-i** option
this fails the second time.

    paul@debian10:~$ ls data/
    pictures
    paul@debian10:~$ cp -i wolf.png data/pictures/
    paul@debian10:~$ cp -i wolf.png data/pictures/
    cp: overwrite data/pictures/wolf.png? n
    paul@debian10:~$

### cp -p

The **cp** command also has a **-p** option to preserve the **time
stamp** on files copied, as can be seen in this screenshot.

    paul@debian10:$ ls -l dates.txt
    -rw-r--r-- 1 paul paul 1118 Jul 27 13:12 dates.txt
    paul@debian10:$ cp dates.txt dates2.txt
    paul@debian10:$ cp -p dates.txt dates3.txt
    paul@debian10:$ ls -l dates2.txt dates3.txt
    -rw-r--r-- 1 paul paul 1118 Aug 14 01:55 dates2.txt
    -rw-r--r-- 1 paul paul 1118 Jul 27 13:12 dates3.txt
    paul@debian10:~$

## Renaming files with mv


The easy way to rename a file is to use the **mv** command. The example
below renames the **studentfiles.html** file to **index.htm**.

    paul@debian10:~$ mv studentfiles.html index.htm
    paul@debian10:~$

The **mv** command has a **-i** option to prevent accidental overwriting
of an existing file.

    paul@debian10:~$ mv -i backup/studentfiles.html index.htm
    mv: overwrite index.htm? n
    paul@debian10:~$

You can also use **mv** to move files from one directory to another. The
first line in this screenshots moves a file from **~/data/pictures** to
**~/music**, while the second line moves a file into the **current
directory** (represented as a dot). <span class="indexterm"></span>

    paul@debian10:~$ mv data/pictures/wolf.png music/
    paul@debian10:~$ mv backup/studentfiles.html .
    paul@debian10:~$

The **"."** notation for the *current directory* can be used in many
commands, for example with **cp** and **mv**.

## Renaming files with rename


The **mv** command is easy to use when you want to rename one or only a
couple of files. To rename many (millions if you like) files in one
command you will need the **rename** command (or the **find** command).
The syntax of the **rename** command uses **regular expressions** which
we will discuss later in this book.

Here is a very simple example that renames all **linux**\* files to
**Linux**\*.

    paul@debian10:~$ ls
    all.txt.gz  data       index.htm     linux.pdf  studentfiles.html
    backup      dates.txt  linuxfun.pdf  music      wolf.png
    paul@debian10:~$ rename 's/^linux/Linux/' *
    paul@debian10:~$ ls
    all.txt.gz  data       index.htm     Linux.pdf  studentfiles.html
    backup      dates.txt  Linuxfun.pdf  music      wolf.png
    paul@debian10:~$

The rename command is not installed by default on Debian Linux. Ask an
administrator to execute **apt-get install rename** if you want to test
this now.

## Hidden files


We mentioned before that there are **hidden files** in the home
directory. These **hidden files** start with a dot **"."** . In the
example below we create a hidden file named **.hidden** and we verify
with **ls** that it is indeed not visible in the list of files.

    paul@debian10:~$ ls
    all.txt.gz  data       index.htm     Linux.pdf  studentfiles.html
    backup      dates.txt  Linuxfun.pdf  music      wolf.png
    paul@debian10:~$ touch .hidden
    paul@debian10:~$ ls
    all.txt.gz  data       index.htm     Linux.pdf  studentfiles.html
    backup      dates.txt  Linuxfun.pdf  music      wolf.png
    paul@debian10:~$

To see the **hidden files** we need to give the **-a** option to **ls**
(where a is short for **all** files).

    paul@debian10:~$ ls -a
    .           backup         .bashrc    .hidden    Linuxfun.pdf  .profile
    ..          .bash_history  data       index.htm  Linux.pdf     studentfiles.html
    all.txt.gz  .bash_logout   dates.txt  .lesshst   music         wolf.png
    paul@debian10:~$

Can you find the six hidden files in the output above? Do not count the
first two special files named **"."** and **".."**. We will explain
those two in the Links chapter.

Note that options like **-l** for long listing and **-a** for all can be
combined. Try the following commands "**ls -a -l**" and "**ls -al**".

## Finding files


Just like with directories, you can use the **find** command to search
for files. The example below enters the home directory and then searches
for all instances of **dates.txt** .

    paul@debian10:~$ cd
    paul@debian10:~$ find -name dates.txt
    ./backup/dates.txt
    ./dates.txt
    paul@debian10:~$

You can force the **find** command to search for only directories or
only files using the **-type** option. If we only want directories in
our result, then we use **-type d** .

First we create a file named **pictures**, then we see the **find**
command displaying just the directory named **pictures** and not the
file.

    paul@debian10:~$ touch pictures
    paul@debian10:~$ find -type d -name pictures
    ./data/pictures
    paul@debian10:~$

Use **find -type f** to receive files but not directories.

    paul@debian10:~$ find -type f -name pictures
    ./pictures
    paul@debian10:~$

## File extensions

The **file** command is really recognising the file type. It does not
use any extension like **.pdf** or **.htm**. The following example shows
how extensions have no meaning on the Linux command line, except for
human readability.

    paul@debian10:~$ file wolf.png
    wolf.png: PNG image data, 1280 x 960, 8-bit/color RGB, non-interlaced
    paul@debian10:~$ cp wolf.png test.txt
    paul@debian10:~$ file test.txt
    test.txt: PNG image data, 1280 x 960, 8-bit/color RGB, non-interlaced
    paul@debian10:~$

## Cheat sheet

<table>
<caption>Files</caption>
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
<td style="text-align: left;"><p>ls</p></td>
<td style="text-align: left;"><p>List the files in the current
directory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ls -l</p></td>
<td style="text-align: left;"><p>Long list of files in the current
directory.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ls -a</p></td>
<td style="text-align: left;"><p>List also the hidden files in the
current directory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>touch foo</p></td>
<td style="text-align: left;"><p>Create an empty file named
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>touch .foo</p></td>
<td style="text-align: left;"><p>Create a hidden file named
<strong>.foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>touch -t 197002271130 bar</p></td>
<td style="text-align: left;"><p>Create a file named
<strong>bar</strong> with a specific time stamp.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>rm foo</p></td>
<td style="text-align: left;"><p>Remove the <strong>foo</strong>
file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rm -i foo</p></td>
<td style="text-align: left;"><p>Ask for permission to remove the
<strong>foo</strong> file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>rm -rf foo</p></td>
<td style="text-align: left;"><p>Remove <strong>foo</strong> recursively
and forced.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>wget <a
href="http://linux-training.be/foo">http://linux-training.be/foo</a></p></td>
<td style="text-align: left;"><p>Download <strong>foo</strong> from <a
href="http://linux-training.be">http://linux-training.be</a>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file bar</p></td>
<td style="text-align: left;"><p>Identify the type of file for
<strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cp foo bar</p></td>
<td style="text-align: left;"><p>Copy the <strong>foo</strong> file to
<strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>cp foo1 foo2 foo3 bar/</p></td>
<td style="text-align: left;"><p>Copy multiple files to the
<strong>bar</strong> directory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cp -i foo bar</p></td>
<td style="text-align: left;"><p>Copy <strong>foo</strong> to
<strong>bar</strong> but ask permission before overwriting a
file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>cp -p foo bar</p></td>
<td style="text-align: left;"><p>Copy and preserve the time
stamp.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>mv foo bar</p></td>
<td style="text-align: left;"><p>Rename the <strong>foo</strong> file to
<strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mv foo1 foo2 foo3 bar/</p></td>
<td style="text-align: left;"><p>Move multiple files to the
<strong>bar</strong> directory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rename 's/foo/bar/' *</p></td>
<td style="text-align: left;"><p>Rename all files in the current
directory replacing the string <strong>foo</strong> with the string
<strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>find -name foo</p></td>
<td style="text-align: left;"><p>Search for the file (or directory)
named <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>find -type f -name foo</p></td>
<td style="text-align: left;"><p>Search for the file (not directory)
named <strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>find -type d -name foo</p></td>
<td style="text-align: left;"><p>Search for the directory named
<strong>foo</strong>.</p></td>
</tr>
</tbody>
</table>

Files

## Practice

1.  List the contents of your home directory.

2.  Create an empty file named **empty.txt** .

3.  List all the files in your home directory, including the hidden
    files.

4.  Create and then remove the directory **test** .

5.  Remove the **empty.txt** file.

6.  Remove the **~/backup** directory and all files in it.

7.  Download the <http://linux-training.be/dates.txt> file from the
    internet into your home directory.

8.  Identify the type of file for **dates.txt** .

9.  Copy the **dates.txt** file to **data.txt** .

10. Rename the **data.txt** file to **DATA.TXT** .

11. Find all the files (not the directories) named **Linuxfun.pdf** in
    your home directory.

## Solution

1.  List the contents of your home directory.

        cd
        ls

    or

        ls &#126;

2.  Create an empty file named **empty.txt** .

        touch empty.txt

3.  List all the files in your home directory, including the hidden
    files.

        ls -a

4.  Create and then remove the directory **test** .

        mkdir test
        rmdir test

5.  Remove the **empty.txt** file.

        rm empty.txt

6.  Remove the **~/backup** directory and all files in it.

        rm -rf ~/backup

7.  Download the <http://linux-training.be/dates.txt> file from the
    internet into your home directory.

        cd
        wget http://linux-training.be/dates.txt

    If the file is already there, then the download will get a **.1**
    extension.

8.  Identify the type of file for **dates.txt**

        file dates.txt

9.  Copy the **dates.txt** file to **data.txt** .

        cp dates.txt data.txt

10. Rename the **data.txt** file to **DATA.TXT** .

        mv data.txt DATA.TXT

11. Find all the files (not the directories) named **Linuxfun.pdf** in
    your home directory.

        cd
        find -type f -name Linuxfun.pdf
