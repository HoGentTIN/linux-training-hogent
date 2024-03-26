# Useful tools

## find


The **find** command is very versatile, as you will *find* out in this
section. In its simplest form the **find** command will list all files
in the current directory.

    paul@debian10:~$ find | more
    .
    ./renamedir
    ./renamedir/alltxt
    ./renamedir/error
    ./renamedir/dates
    ./renamedir/artist
    ./renamedir/artist2
    ./white
    ./error.txt
    ./.bashrc
    ./cities
    ./textfile
    ./tennis
    ./Linux.pdf
    ./music.txt
    ./services.gz
    ./.bash_logout
    ./count.txt
    ./pictures
    ./wolf.png
    --More--

### find location

Usually administrators like to specify where **find** needs to look for
files. This is the first argument to find in the examples below.

    find .    --> searches in current directory and all subdirectories
    find /etc --> searches in /etc (and all subdirectories)
    find /tmp --> searches in /tmp (and all subdirectories)
    find /    --> searches in the complete file system

### find -name

The next argument for **find** that we will discuss is **-name**. Using
this we can let find search for files with a specific name, as this
screenshot shows.

    paul@debian10:~$ find . -name dates.txt
    ./backup/dates.txt
    ./dates.txt
    paul@debian10:~$

Wild cards can be used to find files by name, but not like this
screenshot. Do you know why this wild card fails?

    paul@debian10:~$ find . -name music*
    find: paths must precede expression: ‘music2.txt’
    find: possible unquoted pattern after predicate ‘-name’?
    paul@debian10:~$

It fails because the **bash shell** is expanding the music\* to list all
the files that start with music. We need to quote the wild card so the
shell does not touch it. In other words, we need to make sure that the
**find** command receives the wild card. The next screenshot is much
better.

    paul@debian10:~$ find . -name 'music*' 
    ./music.txt
    ./music2.txt
    ./music
    paul@debian10:~$

### find -type

We saw before that we can specify the file type for **files** or
**directories** as the screenshot below shows.

    paul@debian10:~$ find . -name 'music*' -type d
    ./music
    paul@debian10:~$ find . -name 'music*' -type f
    ./music.txt
    ./music2.txt
    paul@debian10:~$

### find -newer

You can use **find** to search for files that are newer than a certain
file with the **-newer** argument.

    paul@debian10:~$ find . -name '*.txt' -newer music.txt
    ./all.txt
    ./music2.txt
    paul@debian10:~$

### find -exec

We can use find to execute a command on the files that it finds. We can
for example search for all **.txt** files in our home directory and copy
them in a temporary **/tmp/textfiles** directory.

    paul@debian10:~$ mkdir /tmp/textfiles
    paul@debian10:~$ find . -name '*.txt' -exec cp {} /tmp/textfiles/ \;
    paul@debian10:~$ ls /tmp/textfiles/
    5test.txt  combi.txt  dates.txt  error.txt  music2.txt  output.txt  test.txt
    all.txt    count.txt  empty.txt  hello.txt  music.txt   temp.txt
    paul@debian10:~$

The **-exec** ends at the **\\** . The **{ }** means **the file we just
found**. So for every file that **find** finds that matches the name, it
will execute a **cp** of that file to **/tmp/textfiles**. In this case
the **cp** command was executed thirteen times.

### 2&gt; /dev/null


When you execute a **find /** , then you will get a lot of **Permission
denied** errors. You can mitigate this problem by redirecting **stderr**
to a file, or even to **/dev/null**.

    paul@debian10:~$ find / > all.txt 2> /dev/null
    paul@debian10:~$

Nothing will appear on the screen when executing the above command, and
all errors are immediately discarded. The *pseudo* device **/dev/null**
is sometimes called **the black hole**, because it absorbs everything
and nothing can be retrieved from it.

## locate


The **locate** command is not installed by default on Debian 10, so ask
an administrator to perform **apt-get install locate && updatedb** if
you want to try this out. The **locate** command works much faster than
**find** because it uses an index (created by the **updatedb** command).

In the screenshot below we ask **locate** for all files that contain
**resolv.conf** in their name.

    paul@debian10:~$ locate resolv.conf
    /etc/resolv.conf
    /usr/lib/systemd/resolv.conf
    /usr/share/man/man5/resolv.conf.5.gz
    paul@debian10:~$

The **locate** command doesn’t know about recently created files,
because the index is only updated once a day.

    paul@debian10:~$ touch haha
    paul@debian10:~$ locate haha
    paul@debian10:~$

## watch


The **watch** command will by default execute a command every two
seconds. This allows you to **watch** for changes in the command’s
output. In the screenshot below we execute the **ls -l \*.txt** command
every two seconds.

    paul@debian10:~$ watch ls -l *.txt
    paul@debian10:~$
    Every 2.0s: ls -l all.txt combi.txt count.txt dates.txt e...  debian10: Mon Aug  5 05:28:38 2019

    -rw-r--r-- 1 paul paul 2900463 Aug  5 04:57 all.txt
    -rw-r--r-- 1 paul paul     198 Aug  3 21:09 combi.txt
    -rw-r--r-- 1 paul paul      19 Jul 27 23:42 count.txt
    -rw-r--r-- 1 paul paul    1118 Jul 27 13:12 dates.txt
    -rw-r--r-- 1 paul paul       0 Aug  3 21:45 empty.txt
    -rw-r--r-- 1 paul paul   31537 Aug  4 14:59 error.txt
    -rw-r--r-- 1 paul paul      24 Jul 28 13:56 hello.txt
    -rw-r--r-- 1 paul paul      30 Aug  4 16:02 music2.txt
    -rw-r--r-- 1 paul paul      35 Aug  4 15:29 music.txt
    -rw-r--r-- 1 paul paul       6 Aug  3 20:57 output.txt
    -rw-r--r-- 1 paul paul      19 Aug  4 13:15 temp.txt
    -rw-r--r-- 1 paul paul 2062776 Jul 28 14:48 test.txt

You can change the refresh by add **-n seconds** to the **watch**
command. Quit the **watch** command with the **Ctrl-c** keyboard
interrupt.

## time


The **time** utility tells you how long it took to execute a command.
This means you don’t have to wait for a command to finish to know how
long it took. This can be useful to schedule intensive jobs like
backups.

In the screenshot below we measure the time it takes to **gzip** a text
file. It took 0.062 real seconds (most of which was in user space).

    paul@debian10:~$ find / > all.txt 2>/dev/null
    paul@debian10:~$ time gzip all.txt

    real    0m0.062s
    user    0m0.058s
    sys     0m0.004s
    paul@debian10:~$

We mentioned before that **bzip2** takes longer than **gzip**. With the
**time** command you can compare them. We will revisit this when
discussing backups!

    paul@debian10:~$ time bzip2 all.txt

    real    0m0.293s
    user    0m0.269s
    sys     0m0.022s
    paul@debian10:~$

## date


Let’s revisit the **date** command that we saw in one of the first
chapters. We start with **date +%s** which shows us the count of seconds
since the beginning of time.

    paul@debian10:~$ date +%s
    1564977087
    paul@debian10:~$ date +%s
    1564977110
    paul@debian10:~$

In the Linux world, time began on January 1st 1970. The first second of
that day, is second number 0 for Linux. This is why we have a Year 2038
problem, because then this signed 32-bit integer number will exceed
2147483647, which it cannot (at least not in 32 bits). You can read more
about this here <https://en.wikipedia.org/wiki/Year_2038_problem> .

The **date** string can be customised to the format of your choice. The
format is described in the man page and comes after a **+** sign.

    paul@debian10:~$ date
    Mon 05 Aug 2019 06:56:07 AM CEST
    paul@debian10:~$ date +'%A %d-%m-%Y'
    Monday 05-08-2019
    paul@debian10:~$

## od


The **od** command, short for **o**ctal **d**isplay, is able to print
the content of files in different formats. Consider the file **test**
which contains the ASCII characters 0 to 9 followed by a newline.

    paul@debian10:~$ echo 0123456789 > test
    paul@debian10:~$ cat test
    0123456789
    paul@debian10:~$ od -c test
    0000000   0   1   2   3   4   5   6   7   8   9  \n
    0000013
    paul@debian10:~$ od -b test
    0000000 060 061 062 063 064 065 066 067 070 071 012
    0000013
    paul@debian10:~$ od -x test
    0000000 3130 3332 3534 3736 3938 000a
    0000013
    paul@debian10:~$

The **od -c** command will show the ASCII characters inside the file,
including the **newline** at the end. With **od -b** we see the
**octal** numbers corresponding to those characters and for the
**newline** (012). And with **od -x** we see the same data in
**hexadecimal** format (in little endian).

Unicode characters require two bytes per character, as can be seen in
this screenshot.

    paul@debian10:~$ cat test
    μωΩπρφετη
    paul@debian10:~$ od -b test
    0000000 316 274 317 211 316 251 317 200 317 201 317 206 316 265 317 204
    0000020 316 267 012
    0000026
    paul@debian10:~$

## dd


The **dd** command will copy bytes from one file to another. Since
everything on Linux is a file (see the chapter), this means that this
command can copy anything to anything.

For example in this screenshot we use **/dev/zero** (an endless source
of zeroes) to create a file of 1024 bytes, with each byte set to zero.

    paul@debian10:~$ dd if=/dev/zero of=test bs=1024 count=1
    1+0 records in
    1+0 records out
    1024 bytes (1.0 kB, 1.0 KiB) copied, 0.000525708 s, 1.9 MB/s
    paul@debian10:~$

The **if** means **i**nput **f**ile, **of** is **o**utput **f**ile and
**bs** is **b**lock **s**ize. We can verify with **od** that all bytes
are set to zero.

    paul@debian10:~$ od -b test
    0000000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000
    *
    0002000
    paul@debian10:~$

With **root** privileges you can erase a complete disk using **dd**. Not
even forensic tools can recover the data when executing the following
command.

    dd if=/dev/zero of=/dev/sdb

We will discuss hard disks in the storage chapters.

In the example below we use **dd** to create an ISO file from a Compact
Disc. When not giving it a **bs** and **count** then **dd** will copy
until it gets an **EOF** byte.

    paul@debian10:~$ dd if=/dev/cdrom of=cd.iso
    684032+0 records in
    684032+0 records out
    350224384 bytes (350 MB, 334 MiB) copied, 2.04172 s, 172 MB/s
    paul@debian10:~$

The **dd** tool can be used to copy a file, just like **cp** it requires
a source and a destination (input file and output file).

    paul@debian10:~$ dd if=services.gz of=copy.gz
    14+1 records in
    14+1 records out
    7307 bytes (7.3 kB, 7.1 KiB) copied, 0.000486533 s, 15.0 MB/s
    paul@debian10:~$

## bc


The **bc** command, which is short for **b**asic **c**alculator, is not
installed by default. Ask an administrator to execute **apt-get install
bc** if you want to try this.

In short you can give calculations to **bc** and it will output the
answer.

    paul@debian10:~$ echo 4+3 | bc
    7
    paul@debian10:~$

If you want answers that are more precise than integer numbers, then use
the **scale=** statement.

    paul@debian10:~$ echo "42.2 / 33.3" | bc
    1
    paul@debian10:~$ echo "scale=2; 42.2 / 33.3" | bc
    1.26
    paul@debian10:~$

The **bc** command can work with *extremely* large numbers, much larger
than common calculators can. See for example this question for 10 to the
power of 128. (10 to the power 4096 also works).

    paul@debian10:~$ echo 10^128 | bc
    10000000000000000000000000000000000000000000000000000000000000000000\
    0000000000000000000000000000000000000000000000000000000000000
    paul@debian10:~$

You can use C-style syntax when working with variables and **bc**, as
shown in this example.

    paul@debian10:~$ echo "var=10;++var;--var" | bc
    11
    10
    paul@debian10:~$

## sleep


The **sleep** command is probably the simplest command of all. You give
it an argument in seconds and it will do nothing for that amount of
seconds.

    paul@debian10:~$ sleep 3
    paul@debian10:~$

## script


The **script** tool allows you to record sessions in your terminal
window. In the screenshot below we start the **script** tool by typing
**script** and end it with the **exit** command.

    paul@debian10:~$ script
    Script started, file is typescript
    paul@debian10:~$ ls -l dates.txt
    -rw-r--r-- 1 paul paul 1118 Jul 27 13:12 dates.txt
    paul@debian10:~$ cp Linux.pdf Fun.pdf
    paul@debian10:~$ exit
    exit
    Script done, file is typescript
    paul@debian10:~$

Use **cat** to see the recorded session.

    paul@debian10:~$ cat typescript
    Script started on 2019-08-08 15:35:25+02:00 [TERM="screen-256color" TTY="/dev/pts/0" COLUMNS="96" LINES="29"]
    paul@debian10:~$ ls -l dates.txt
    -rw-r--r-- 1 paul paul 1118 Jul 27 13:12 dates.txt
    paul@debian10:~$ cp Linux.pdf Fun.pdf
    paul@debian10:~$ exit
    exit

    Script done on 2019-08-08 15:35:44+02:00 [COMMAND_EXIT_CODE="0"]
    paul@debian10:~$

## tmux


To finish this chapter I have to mention **tmux**. Personally I use it
all the time, but it can be a lot to learn for people that are new to
Linux. **tmux** is a **terminal multiplexer**, which means it allows for
many terminals inside one terminal. The **root** user can install it
with **apt-get install tmux**.

By default you can send commands to **tmux** using Ctrl-b. For example
**Ctrl-b-"** and **Ctrl-b-%** will split the screen in two horizontal or
two vertical panes. Exit a pane with the **exit** command (or Ctrl-d).
Move from one pane to the next using **Ctrl-b-o**.

## Cheat sheet

<table>
<caption>Useful tools</caption>
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
<td style="text-align: left;"><p>find</p></td>
<td style="text-align: left;"><p>List all files in the current directory
(and all subdirectories).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>find /etc</p></td>
<td style="text-align: left;"><p>List all files in
<strong>/etc</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>find . -name foo</p></td>
<td style="text-align: left;"><p>List all files named
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>find . -name 'foo*'</p></td>
<td style="text-align: left;"><p>List all files of which the name starts
with <strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>find . -type d</p></td>
<td style="text-align: left;"><p>List only directories.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>find . -type f</p></td>
<td style="text-align: left;"><p>List only regular files.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>find . -exec foo {} \;</p></td>
<td style="text-align: left;"><p>Execute the <strong>foo</strong>
command on all files found.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>find / 2&gt;/dev/null</p></td>
<td style="text-align: left;"><p>List all files on the system, while
discarding errors.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>locate</p></td>
<td style="text-align: left;"><p>Use an index to search for
files.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>updatedb</p></td>
<td style="text-align: left;"><p>Update the index with all current
filenames.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>locate foo</p></td>
<td style="text-align: left;"><p>List all files (in the index) that
contain <strong>foo</strong> in their name.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>watch foo</p></td>
<td style="text-align: left;"><p>Repeat the <strong>foo</strong> command
every two seconds.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>time foo</p></td>
<td style="text-align: left;"><p>Give a summary of how long it took to
run the <strong>foo</strong> command.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>date</p></td>
<td style="text-align: left;"><p>Display the current time and
date.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>date +%s</p></td>
<td style="text-align: left;"><p>Display the number of seconds since the
epoch (Jan 1st 1970, 00:00:00 UTC).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>od -c foo</p></td>
<td style="text-align: left;"><p>Display the file <strong>foo</strong>
as ASCII characters.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>od -b foo</p></td>
<td style="text-align: left;"><p>Display the file <strong>foo</strong>
as octal numbers.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>od -x foo</p></td>
<td style="text-align: left;"><p>Display the file <strong>foo</strong>
as hexadecimal little endian numbers.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>dd if=foo of=bar</p></td>
<td style="text-align: left;"><p>Copy <strong>foo</strong> to
<strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>dd if=/dev/zero of=/dev/sdb</p></td>
<td style="text-align: left;"><p>Wipe the <strong>/dev/sdb</strong>
device (hard disk or usb stick or …)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo 42+33 | bc</p></td>
<td style="text-align: left;"><p>Calculate the sum of these
numbers.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo "scale=4; 42/33" | bc</p></td>
<td style="text-align: left;"><p>Calculate the division with four
decimal places.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo 10^10 | bc</p></td>
<td style="text-align: left;"><p>Calculate 10 to the power 10.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sleep</p></td>
<td style="text-align: left;"><p>Do nothing for x seconds.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>script foo</p></td>
<td style="text-align: left;"><p>Start recording the terminal session in
the file named <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exit</p></td>
<td style="text-align: left;"><p>End the recording of the terminal
session.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-d</p></td>
<td style="text-align: left;"><p>Send an ASCII EOF character (end
recording of terminal session).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>tmux</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

Useful tools

## Practice

1.  Search in **/etc** for all **files** named **resolv.conf**,
    discarding all errors.

2.  Search **/var** for all files newer than yesterday 11h (11 a.m.)

3.  Search **/etc** for all files named **\*.conf** and copy all those
    files to ~/backup , and discard all errors.

4.  Repeat the **file \*** command every five seconds.

5.  How long does it take to execute **find / &gt;/dev/null 2&gt;&1**?

6.  Create a transcript of your session in the file **mysession**.

7.  Create a 30 bytes file with random numbers.

8.  Create a 1MiB (one mebibyte) file with pseudo random numbers.

9.  Sleep for 42 seconds.

10. Interrupt the sleep command.

11. End your **mysession** transcript.

12. Play with **tmux**.

## Solution

1.  Search in **/etc** for all **files** named **resolv.conf**,
    discarding all errors.

        find /etc -type f -name resolv.conf 2> /dev/null

2.  Search **/var** for all files newer than yesterday 11h (11 a.m.)

        touch -t 201908071100 yesterday
        find /var -newer yesterday 2>/dev/null

3.  Search **/etc** for all files named **\*.conf** and copy all those
    files to ~/backup , and discard all errors.

        find /etc -name '*.conf' -exec cp {} ~/backup \;

4.  Repeat the **file \*** command every five seconds.

        watch -n5 file \*

5.  How long does it take to execute **find / &gt;/dev/null 2&gt;&1**?

        time find / >/dev/null 2>&1

6.  Create a transcript of your session in the file **mysession**.

        script mysession

7.  Create a 30 bytes file with random numbers.

        dd if=/dev/random of=randomfile count=30 bs=1

    If this stalls then open another terminal to this computer and make
    some stuff happen.

8.  Create a 1MiB (one mebibyte) file with pseudo random numbers.

        dd if=/dev/urandom of=urandomfile count=1024 bs=1024

9.  Sleep for 42 seconds.

        sleep 42

10. Interrupt the sleep command.

        Ctrl-c

11. End your **mysession** transcript.

        exit (or Ctrl-d)
        more mysession

12. Play with **tmux**.

        tmux
        Ctrl-b %
        Ctrl-b "
        Ctrl-b o
