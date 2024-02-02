## repeating the last command

To repeat the last command in bash, type `!!`. This is
pronounced as `bang bang`.

    paul@debian10:~/test42$ echo this will be repeated > file42.txt
    paul@debian10:~/test42$ !!
    echo this will be repeated > file42.txt
    paul@debian10:~/test42$ 

## repeating other commands

You can repeat other commands using one `bang` followed by one or more
characters. The shell will repeat the last command that started with
those characters.

    paul@debian10:~/test42$ touch file42
    paul@debian10:~/test42$ cat file42
    paul@debian10:~/test42$ !to
    touch file42
    paul@debian10:~/test42$

## history

To see older commands, use `history` to display the shell
command history (or use `history n` to see the last n commands).

    paul@debian10:~/test$ history 10
    38  mkdir test
    39  cd test
    40  touch file1
    41  echo hello > file2
    42  echo It is very cold today > winter.txt
    43  ls
    44  ls -l
    45  cp winter.txt summer.txt
    46  ls -l
    47  history 10

## !n

When typing `!` followed by the number preceding the
command you want repeated, then the shell will echo the command and
execute it.

    paul@debian10:~/test$ !43
    ls
    file1  file2  summer.txt  winter.txt

## Ctrl-r

Another option is to use `ctrl-r` to search in the
history. In the screenshot below i only typed `ctrl-r` followed by four
characters `apti` and it finds the last command containing these four
consecutive characters.

    paul@debian10:~$ 
    (reverse-i-search)`apti': sudo aptitude install screen

## \$HISTSIZE

The \$HISTSIZE variable determines the number of commands
that will be remembered in your current environment. Most distributions
default this variable to 500 or 1000.

    paul@debian10:~$ echo $HISTSIZE
    500

You can change it to any value you like.

    paul@debian10:~$ HISTSIZE=15000
    paul@debian10:~$ echo $HISTSIZE
    15000

## \$HISTFILE

The \$HISTFILE variable points to the file that contains
your history. The `bash` shell defaults this value to
`~/.bash_history`.

    paul@debian10:~$ echo $HISTFILE
    /home/paul/.bash_history

A session history is saved to this file when you `exit`
the session!

*Closing a gnome-terminal with the mouse, or typing
`reboot` as root will NOT save your terminal\'s history.*

## \$HISTFILESIZE

The number of commands kept in your history file can be set using
\$HISTFILESIZE.

    paul@debian10:~$ echo $HISTFILESIZE
    15000

## prevent recording a command

You can prevent a command from being recorded in `history` using a space
prefix.

    paul@debian8:~/github$ echo abc
    abc
    paul@debian8:~/github$  echo def
    def
    paul@debian8:~/github$ echo ghi
    ghi
    paul@debian8:~/github$ history 3
     9501  echo abc
     9502  echo ghi
     9503  history 3

## (optional)regular expressions

It is possible to use `regular expressions` when using the
`bang` to repeat commands. The screenshot below switches 1 into 2.

    paul@debian10:~/test$ cat file1
    paul@debian10:~/test$ !c:s/1/2
    cat file2
    hello
    paul@debian10:~/test$

## (optional) Korn shell history

Repeating a command in the `Korn shell` is very similar.
The Korn shell  also has the `history` command, but uses
the letter `r` to recall lines from history.

This screenshot shows the history command. Note the different meaning of
the parameter.

    $ history 17
    17  clear
    18  echo hoi
    19  history 12
    20  echo world
    21  history 17

Repeating with `r` can be combined with the line numbers given by the
history command, or with the first few letters of the command.

    $ r e
    echo world
    world
    $ cd /etc
    $ r
    cd /etc
    $
