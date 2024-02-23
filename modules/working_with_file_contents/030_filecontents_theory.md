## head

You can use `head` to display the first ten lines of a
file.

    student@linux~$ head /etc/passwd
    root:x:0:0:root:/root:/bin/bash
    daemon:x:1:1:daemon:/usr/sbin:/bin/sh
    bin:x:2:2:bin:/bin:/bin/sh
    sys:x:3:3:sys:/dev:/bin/sh
    sync:x:4:65534:sync:/bin:/bin/sync
    games:x:5:60:games:/usr/games:/bin/sh
    man:x:6:12:man:/var/cache/man:/bin/sh
    lp:x:7:7:lp:/var/spool/lpd:/bin/sh
    mail:x:8:8:mail:/var/mail:/bin/sh
    news:x:9:9:news:/var/spool/news:/bin/sh
    root@linux~#

The `head` command can also display the first `n` lines of a file.

    student@linux~$ head -4 /etc/passwd
    root:x:0:0:root:/root:/bin/bash
    daemon:x:1:1:daemon:/usr/sbin:/bin/sh
    bin:x:2:2:bin:/bin:/bin/sh
    sys:x:3:3:sys:/dev:/bin/sh
    student@linux~$

And `head` can also display the first `n bytes`.

    student@linux~$ head -c14 /etc/passwd
    root:x:0:0:roostudent@linux~$

## tail

Similar to `head`, the `tail` command will display the
last ten lines of a file.

    student@linux~$ tail /etc/services
    vboxd           20012/udp
    binkp           24554/tcp                       # binkp fidonet protocol
    asp             27374/tcp                       # Address Search Protocol
    asp             27374/udp
    csync2          30865/tcp                       # cluster synchronization tool
    dircproxy       57000/tcp                       # Detachable IRC Proxy
    tfido           60177/tcp                       # fidonet EMSI over telnet
    fido            60179/tcp                       # fidonet EMSI over TCP

    # Local services
    student@linux~$

You can give `tail` the number of lines you want to see.

    student@linux~$ tail -3 /etc/services
    fido            60179/tcp                       # fidonet EMSI over TCP

    # Local services
    student@linux~$

The `tail` command has other useful options, some of which we will use
during this course.

## cat

The `cat` command is one of the most universal tools, yet
all it does is copy `standard input` to
`standard output`. In combination with the shell this can
be very powerful and diverse. Some examples will give a glimpse into the
possibilities. The first example is simple, you can use cat to display a
file on the screen. If the file is longer than the screen, it will
scroll to the end.

    student@linux:~$ cat /etc/resolv.conf
    domain linux-training.be
    search linux-training.be
    nameserver 192.168.1.42

### concatenate

`cat` is short for `concatenate`. One of the basic uses of `cat` is to
concatenate files into a bigger (or complete) file.

    student@linux:~$ echo one >part1
    student@linux:~$ echo two >part2
    student@linux:~$ echo three >part3
    student@linux:~$ cat part1
    one
    student@linux:~$ cat part2
    two
    student@linux:~$ cat part3
    three
    student@linux:~$ cat part1 part2 part3
    one
    two
    three
    student@linux:~$ cat part1 part2 part3 >all
    student@linux:~$ cat all
    one
    two
    three
    student@linux:~$

### create files

You can use `cat` to create flat text files. Type the `cat > winter.txt`
command as shown in the screenshot below. Then type one or more lines,
finishing each line with the enter key. After the last line, type and
hold the Control (Ctrl) key and press d.

    student@linux:~$ cat > winter.txt
    It is very cold today!
    student@linux:~$ cat winter.txt
    It is very cold today!
    student@linux:~$

The `Ctrl d` key combination will send an
`EOF` (End of File) to the running process ending the
`cat` command.

### custom end marker

You can choose an end marker for `cat` with `<<` as is shown in this
screenshot. This construction is called a `here directive`
and will end the `cat` command.

    student@linux:~$ cat > hot.txt <<stop
    > It is hot today!
    > Yes it is summer.
    > stop
    student@linux:~$ cat hot.txt
    It is hot today!
    Yes it is summer.
    student@linux:~$

### copy files

In the third example you will see that cat can be used to copy files. We
will explain in detail what happens here in the bash shell chapter.

    student@linux:~$ cat winter.txt
    It is very cold today!
    student@linux:~$ cat winter.txt > cold.txt
    student@linux:~$ cat cold.txt 
    It is very cold today!
    student@linux:~$

## tac

Just one example will show you the purpose of `tac` (cat
backwards).

    student@linux:~$ cat count
    one
    two
    three
    four
    student@linux:~$ tac count 
    four
    three
    two
    one

## more and less

The `more` command is useful for displaying files that
take up more than one screen. More will allow you to see the contents of
the file page by page. Use the space bar to see the next page, or `q` to
quit. Some people prefer the `less` command to `more`.

## strings

With the `strings` command you can display readable ascii
strings found in (binary) files. This example locates the `ls` binary
then displays readable strings in the binary file (output is truncated).

    student@linux:~$ which ls
    /bin/ls
    student@linux:~$ strings /bin/ls
    /lib/ld-linux.so.2
    librt.so.1
    __gmon_start__
    _Jv_RegisterClasses
    clock_gettime
    libacl.so.1
    ...
        

