## stdin, stdout, and stderr

The bash shell has three basic streams; it takes input from `stdin`
(stream `0`), it sends output to `stdout` (stream `1`)
 and it sends error messages to `stderr` (stream `2`)
.

The drawing below has a graphical interpretation of these three streams.

![](assets/bash_stdin_stdout_stderr.png){width="14cm"}

The keyboard often serves as `stdin`, whereas `stdout` and `stderr` both
go to the display. This can be confusing to new Linux users because
there is no obvious way to recognize `stdout` from `stderr`. Experienced
users know that separating output from errors can be very useful.

![](assets/bash_ioredirection_keyboard_display.png)

The next sections will explain how to redirect these streams.

## output redirection

### \> stdout

`stdout` can be redirected to a file with a `greater than` sign. While scanning
the line, the shell will see the `>` sign and will clear
the file.

![](assets/bash_output_redirection.png)

The `>` notation is in fact the abbreviation of `1>` (`stdout` being
referred to as stream `1`).

    [student@linux ~]$ echo It is cold today!
    It is cold today!
    [student@linux ~]$ echo It is cold today! > winter.txt
    [student@linux ~]$ cat winter.txt 
    It is cold today!
    [student@linux ~]$

Note that the bash shell effectively `removes` the redirection from the
command line before argument 0 is executed. This means that in the case
of this command:

    echo hello > greetings.txt

the shell only counts two arguments (echo = argument 0, hello = argument
1). The redirection is removed before the argument counting takes place.

### output file is erased

While scanning the line, the shell will see the \> sign and
`will clear the file`! Since this happens before resolving `argument 0`,
this means that even when the command fails, the file will have been
cleared!

    [student@linux ~]$ cat winter.txt 
    It is cold today!
    [student@linux ~]$ zcho It is cold today! > winter.txt
    -bash: zcho: command not found
    [student@linux ~]$ cat winter.txt 
    [student@linux ~]$

### noclobber

Erasing a file while using \> can be prevented by setting the
`noclobber` option.

    [student@linux ~]$ cat winter.txt 
    It is cold today!
    [student@linux ~]$ set -o noclobber
    [student@linux ~]$ echo It is cold today! > winter.txt
    -bash: winter.txt: cannot overwrite existing file
    [student@linux ~]$ set +o noclobber
    [student@linux ~]$

### overruling noclobber

The `noclobber` can be overruled with `>|`.

    [student@linux ~]$ set -o noclobber
    [student@linux ~]$ echo It is cold today! > winter.txt
    -bash: winter.txt: cannot overwrite existing file
    [student@linux ~]$ echo It is very cold today! >| winter.txt
    [student@linux ~]$ cat winter.txt 
    It is very cold today!
    [student@linux ~]$

### \>\> append

Use `>>` to `append` output to a file.

    [student@linux ~]$ echo It is cold today! > winter.txt
    [student@linux ~]$ cat winter.txt 
    It is cold today!
    [student@linux ~]$ echo Where is the summer ? >> winter.txt
    [student@linux ~]$ cat winter.txt 
    It is cold today!
    Where is the summer ?
    [student@linux ~]$

## error redirection

### 2\> stderr

Redirecting `stderr` is done with `2>`. This can be very
useful to prevent error messages from cluttering your screen.

![](assets/bash_error_redirection.png)

The screenshot below shows redirection of `stdout` to a file, and
`stderr` to `/dev/null`. Writing `1>` is the
same as \>.

    [student@linux ~]$ find / > allfiles.txt 2> /dev/null
    [student@linux ~]$

### 2\>&1

To redirect both `stdout` and `stderr` to the same file, use
`2>&1`.

    [student@linux ~]$ find / > allfiles_and_errors.txt 2>&1
    [student@linux ~]$

Note that the order of redirections is significant. For example, the
command

    ls > dirlist 2>&1

directs both standard output (file descriptor 1) and standard error
(file descriptor 2) to the file dirlist, while the command

    ls 2>&1 > dirlist

directs only the standard output to file dirlist, because the standard
error made a copy of the standard output before the standard output was
redirected to dirlist.

## output redirection and pipes

By default you cannot grep inside `stderr` when using pipes on the
command line, because only `stdout` is passed.

    student@linux:~$ rm file42 file33 file1201 | grep file42
    rm: cannot remove ‘file42’: No such file or directory
    rm: cannot remove ‘file33’: No such file or directory
    rm: cannot remove ‘file1201’: No such file or directory

With `2>&1` you can force `stderr` to go to `stdout`. This enables the
next command in the pipe to act on both streams.

    student@linux:~$ rm file42 file33 file1201 2>&1 | grep file42
    rm: cannot remove ‘file42’: No such file or directory

You cannot use both `1>&2` and `2>&1` to switch `stdout` and `stderr`.

    student@linux:~$ rm file42 file33 file1201 2>&1 1>&2 | grep file42
    rm: cannot remove ‘file42’: No such file or directory
    student@linux:~$ echo file42 2>&1 1>&2 | sed 's/file42/FILE42/' 
    FILE42

You need a third stream to switch stdout and stderr after a pipe symbol.

    student@linux:~$ echo file42 3>&1 1>&2 2>&3 | sed 's/file42/FILE42/' 
    file42
    student@linux:~$ rm file42 3>&1 1>&2 2>&3 | sed 's/file42/FILE42/' 
    rm: cannot remove ‘FILE42’: No such file or directory

## joining stdout and stderr

The `&>` construction will put both `stdout` and `stderr` in one stream
(to a file).

    student@linux:~$ rm file42 &> out_and_err
    student@linux:~$ cat out_and_err 
    rm: cannot remove ‘file42’: No such file or directory
    student@linux:~$ echo file42 &> out_and_err
    student@linux:~$ cat out_and_err 
    file42
    student@linux:~$ 

## input redirection

### < stdin

Redirecting `stdin` is done with < (short for 0<).

    [student@linux ~]$ cat < text.txt
    one
    two
    [student@linux ~]$ tr 'onetw' 'ONEZZ' < text.txt
    ONE
    ZZO
    [student@linux ~]$

### << here document

The `here document` (sometimes called here-is-document) is
a way to append input until a certain sequence (usually EOF) is
encountered. The `EOF` marker can be typed literally or
can be called with Ctrl-D.

    [student@linux ~]$ cat <<EOF > text.txt
    > one
    > two
    > EOF
    [student@linux ~]$ cat text.txt 
    one
    two
    [student@linux ~]$ cat <<brol > text.txt
    > brel
    > brol
    [student@linux ~]$ cat text.txt 
    brel
    [student@linux ~]$
            

### <<< here string

The `here string` can be used to directly pass strings to
a command. The result is the same as using `echo string | command` (but
you have one less process running).

    student@linux~$ base64 <<< linux-training.be
    bGludXgtdHJhaW5pbmcuYmUK
    student@linux~$ base64 -d <<< bGludXgtdHJhaW5pbmcuYmUK
    linux-training.be

See rfc 3548 for more information about `base64`.

## confusing redirection

The shell will scan the whole line before applying redirection. The
following command line is very readable and is correct.

    cat winter.txt > snow.txt 2> errors.txt

But this one is also correct, but less readable.

    2> errors.txt cat winter.txt > snow.txt

Even this will be understood perfectly by the shell.

    < winter.txt > snow.txt 2> errors.txt cat

## quick file clear

So what is the quickest way to clear a file ?

    >foo

And what is the quickest way to clear a file when the `noclobber` option
is set ?

    >|bar

