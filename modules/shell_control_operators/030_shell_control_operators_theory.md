## ; semicolon

You can put two or more commands on the same line separated by a
semicolon `;` . The shell will scan the line until it
reaches the semicolon. All the arguments before this semicolon will be
considered a separate command from all the arguments after the
semicolon. Both series will be executed sequentially with the shell
waiting for each command to finish before starting the next one.

    [paul@RHELv8u3 ~]$ echo Hello
    Hello
    [paul@RHELv8u3 ~]$ echo World
    World
    [paul@RHELv8u3 ~]$ echo Hello ; echo World
    Hello
    World
    [paul@RHELv8u3 ~]$

## & ampersand

When a line ends with an ampersand `&`, the shell will not
wait for the command to finish. You will get your shell prompt back, and
the command is executed in background. You will get a message when this
command has finished executing in background.

    [paul@RHELv8u3 ~]$ sleep 20 &
    [1] 7925
    [paul@RHELv8u3 ~]$ 
    ...wait 20 seconds...
    [paul@RHELv8u3 ~]$ 
    [1]+  Done                     sleep 20

The technical explanation of what happens in this case is explained in
the chapter about `processes`.

## \$? dollar question mark

The exit code of the previous command is stored in the shell variable
`$?`. Actually `$?` is a shell parameter and not a
variable, since you cannot assign a value to `$?`.

    paul@debian10:~/test$ touch file1
    paul@debian10:~/test$ echo $?
    0
    paul@debian10:~/test$ rm file1
    paul@debian10:~/test$ echo $?
    0
    paul@debian10:~/test$ rm file1
    rm: cannot remove `file1': No such file or directory
    paul@debian10:~/test$ echo $?
    1
    paul@debian10:~/test$

## && double ampersand

The shell will interpret `&&` as a `logical AND`. When
using `&&` the second command is executed only if the first one succeeds
(returns a zero exit status).

    paul@barry:~$ echo first && echo second
    first
    second
    paul@barry:~$ zecho first && echo second
    -bash: zecho: command not found

Another example of the same `logical AND` principle. This
example starts with a working `cd` followed by `ls`, then a non-working
`cd` which is `not` followed by `ls`.

    [paul@RHELv8u3 ~]$ cd gen && ls
    file1  file3  File55  fileab  FileAB   fileabc
    file2  File4  FileA   Fileab  fileab2
    [paul@RHELv8u3 gen]$ cd gen && ls
    -bash: cd: gen: No such file or directory

## \|\| double vertical bar

The `||` represents a `logical OR`. The second command is
executed only when the first command fails (returns a non-zero exit
status).

    paul@barry:~$ echo first || echo second ; echo third
    first
    third
    paul@barry:~$ zecho first || echo second ; echo third
    -bash: zecho: command not found
    second
    third
    paul@barry:~$

Another example of the same `logical OR` principle.

    [paul@RHELv8u3 ~]$ cd gen || ls
    [paul@RHELv8u3 gen]$ cd gen || ls
    -bash: cd: gen: No such file or directory
    file1  file3  File55  fileab  FileAB   fileabc
    file2  File4  FileA   Fileab  fileab2

## combining && and \|\|

You can use this logical AND and logical OR to write an `if-then-else`
structure on the command line. This example uses `echo` to display
whether the `rm` command was successful.

    paul@laika:~/test$ rm file1 && echo It worked! || echo It failed!
    It worked!
    paul@laika:~/test$ rm file1 && echo It worked! || echo It failed!
    rm: cannot remove `file1': No such file or directory
    It failed!
    paul@laika:~/test$

## \# pound sign

Everything written after a `pound sign` (#) is ignored by
the shell. This is useful to write a `shell comment`, but
has no influence on the command execution or shell expansion.

    paul@debian4:~$ mkdir test    # we create a directory
    paul@debian4:~$ cd test       #### we enter the directory
    paul@debian4:~/test$ ls       # is it empty ?
    paul@debian4:~/test$

## \\ escaping special characters

The backslash `\` character enables the use of control
characters, but without the shell interpreting it, this is called
`escaping` characters.

    [paul@RHELv8u3 ~]$ echo hello \; world
    hello ; world
    [paul@RHELv8u3 ~]$ echo hello\ \ \ world
    hello   world
    [paul@RHELv8u3 ~]$ echo escaping \\\ \#\ \&\ \"\ \'
    escaping \ # & " '
    [paul@RHELv8u3 ~]$ echo escaping \\\?\*\"\'
    escaping \?*"'

### end of line backslash

Lines ending in a backslash are continued on the next line. The shell
does not interpret the newline character and will wait on shell
expansion and execution of the command line until a newline without
backslash is encountered.

    [paul@RHEL8b ~]$ echo This command line \
    > is split in three \
    > parts
    This command line is split in three parts
    [paul@RHEL8b ~]$

