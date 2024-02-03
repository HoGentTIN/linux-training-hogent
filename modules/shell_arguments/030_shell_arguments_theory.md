## arguments

One of the primary features of a shell is to perform a
`command line scan`. When you enter a command at the
shell\'s command prompt and press the enter key, then the shell will
start scanning that line, cutting it up in `arguments`. While scanning
the line, the shell may make many changes to the `arguments` you typed.

This process is called `shell expansion`. When the shell
has finished scanning and modifying that line, then it will be executed.

## white space removal

Parts that are separated by one or more consecutive
`white spaces` (or tabs) are considered separate
`arguments`, any white space is removed. The first
`argument` is the command to be executed, the other
`arguments` are given to the command. The shell effectively cuts your
command into one or more arguments.

This explains why the following four different command lines are the
same after `shell expansion`.

    [paul@RHELv8u3 ~]$ echo Hello World
    Hello World
    [paul@RHELv8u3 ~]$ echo Hello   World
    Hello World
    [paul@RHELv8u3 ~]$ echo   Hello   World
    Hello World
    [paul@RHELv8u3 ~]$    echo      Hello      World
    Hello World

The `echo` command will display each argument it receives
from the shell. The `echo` command will also add a new white space
between the arguments it received.

## single quotes

You can prevent the removal of white spaces by quoting the spaces. The
contents of the quoted string are considered as one argument. In the
screenshot below the `echo` receives only one `argument`.

    [paul@RHEL8b ~]$ echo 'A line with      single    quotes'
    A line with      single    quotes
    [paul@RHEL8b ~]$

## double quotes

You can also prevent the removal of white spaces by double quoting
 the spaces. Same as above, `echo` only receives one
`argument`.

    [paul@RHEL8b ~]$ echo "A line with      double    quotes"
    A line with      double    quotes
    [paul@RHEL8b ~]$

Later in this book, when discussing `variables` we will see important
differences between single and double quotes.

## echo and quotes

Quoted lines can include special escaped characters recognised by the
`echo` command (when using `echo -e`). The screenshot
below shows how to use `\n` for a newline and `\t` for a tab (usually
eight white spaces).

    [paul@RHEL8b ~]$ echo -e "A line with \na newline"
    A line with 
    a newline
    [paul@RHEL8b ~]$ echo -e 'A line with \na newline'
    A line with 
    a newline
    [paul@RHEL8b ~]$ echo -e "A line with \ta tab"
    A line with     a tab
    [paul@RHEL8b ~]$ echo -e 'A line with \ta tab'
    A line with     a tab
    [paul@RHEL8b ~]$

The echo command can generate more than white spaces, tabs and newlines.
Look in the man page for a list of options.

## commands

### external or builtin commands ?

Not all commands are external to the shell, some are `builtin`.
`External commands` are programs that have their own binary and reside
somewhere in the file system. Many external commands are located in
`/bin` or `/sbin`. `Builtin commands` are an
integral part of the shell program itself.

### type

To find out whether a command given to the shell will be executed as an
`external command` or as a `builtin command`, use the
`type` command.

    paul@laika:~$ type cd
    cd is a shell builtin
    paul@laika:~$ type cat
    cat is /bin/cat

As you can see, the `cd` command is `builtin` and the `cat` command is
`external`.

You can also use this command to show you whether the command is
`aliased` or not.

    paul@laika:~$ type ls
    ls is aliased to `ls --color=auto'

### running external commands

Some commands have both builtin and external versions. When one of these
commands is executed, the builtin version takes priority. To run the
external version, you must enter the full path to the command.

    paul@laika:~$ type -a echo
    echo is a shell builtin
    echo is /bin/echo
    paul@laika:~$ /bin/echo Running the external echo command... 
    Running the external echo command...

### which

The `which` command will search for binaries in the
`$PATH` environment variable (variables will be explained
later). In the screenshot below, it is determined that `cd` is
`builtin`, and `ls, cp, rm, mv, mkdir, pwd,` and `which` are external
commands.

    [root@RHEL8b ~]# which cp ls cd mkdir pwd 
    /bin/cp
    /bin/ls
    /usr/bin/which: no cd in (/usr/kerberos/sbin:/usr/kerberos/bin:...
    /bin/mkdir
    /bin/pwd

## aliases

### create an alias

The shell allows you to create `aliases`. Aliases are
often used to create an easier to remember name for an existing command
or to easily supply parameters.

    [paul@RHELv8u3 ~]$ cat count.txt 
    one
    two
    three
    [paul@RHELv8u3 ~]$ alias dog=tac
    [paul@RHELv8u3 ~]$ dog count.txt 
    three
    two
    one

### abbreviate commands

An `alias` can also be useful to abbreviate an existing
command.

    paul@laika:~$ alias ll='ls -lh --color=auto'
    paul@laika:~$ alias c='clear'
    paul@laika:~$

### default options

Aliases can be used to supply commands with default options. The example
below shows how to set the `-i` option default when typing
`rm`.

    [paul@RHELv8u3 ~]$ rm -i winter.txt 
    rm: remove regular file `winter.txt'? no
    [paul@RHELv8u3 ~]$ rm winter.txt 
    [paul@RHELv8u3 ~]$ ls winter.txt
    ls: winter.txt: No such file or directory
    [paul@RHELv8u3 ~]$ touch winter.txt
    [paul@RHELv8u3 ~]$ alias rm='rm -i'
    [paul@RHELv8u3 ~]$ rm winter.txt 
    rm: remove regular empty file `winter.txt'? no
    [paul@RHELv8u3 ~]$

Some distributions enable default aliases to protect users from
accidentally erasing files (\'rm -i\', \'mv -i\', \'cp -i\')

### viewing aliases

You can provide one or more aliases as arguments to the `alias` command
to get their definitions. Providing no arguments gives a complete list
of current aliases.

    paul@laika:~$ alias c ll
    alias c='clear'
    alias ll='ls -lh --color=auto'

### unalias

You can undo an alias with the `unalias` command.

    [paul@RHEL8b ~]$ which rm
    /bin/rm
    [paul@RHEL8b ~]$ alias rm='rm -i'
    [paul@RHEL8b ~]$ which rm
    alias rm='rm -i'
            /bin/rm
    [paul@RHEL8b ~]$ unalias rm
    [paul@RHEL8b ~]$ which rm
    /bin/rm
    [paul@RHEL8b ~]$

## displaying shell expansion

You can display shell expansion with `set -x`, and stop
displaying it with `set +x`. You might want to use this
further on in this course, or when in doubt about exactly what the shell
is doing with your command.

    [paul@RHELv8u3 ~]$ set -x
    ++ echo -ne '\033]0;paul@RHELv8u3:~\007'
    [paul@RHELv8u3 ~]$ echo $USER
    + echo paul
    paul
    ++ echo -ne '\033]0;paul@RHELv8u3:~\007'
    [paul@RHELv8u3 ~]$ echo \$USER
    + echo '$USER'
    $USER
    ++ echo -ne '\033]0;paul@RHELv8u3:~\007'
    [paul@RHELv8u3 ~]$ set +x
    + set +x
    [paul@RHELv8u3 ~]$ echo $USER
    paul

