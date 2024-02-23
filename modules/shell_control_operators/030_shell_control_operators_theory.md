## ; semicolon

You can put two or more commands on the same line separated by a
semicolon `;` . The shell will scan the line until it
reaches the semicolon. All the arguments before this semicolon will be
considered a separate command from all the arguments after the
semicolon. Both series will be executed sequentially with the shell
waiting for each command to finish before starting the next one.

    [student@linux ~]$ echo Hello
    Hello
    [student@linux ~]$ echo World
    World
    [student@linux ~]$ echo Hello ; echo World
    Hello
    World
    [student@linux ~]$

## & ampersand

When a line ends with an ampersand `&`, the shell will not
wait for the command to finish. You will get your shell prompt back, and
the command is executed in background. You will get a message when this
command has finished executing in background.

    [student@linux ~]$ sleep 20 &
    [1] 7925
    [student@linux ~]$ 
    ...wait 20 seconds...
    [student@linux ~]$ 
    [1]+  Done                     sleep 20

The technical explanation of what happens in this case is explained in
the chapter about `processes`.

## \$? dollar question mark

The exit code of the previous command is stored in the shell variable
`$?`. Actually `$?` is a shell parameter and not a
variable, since you cannot assign a value to `$?`.

    student@linux:~/test$ touch file1
    student@linux:~/test$ echo $?
    0
    student@linux:~/test$ rm file1
    student@linux:~/test$ echo $?
    0
    student@linux:~/test$ rm file1
    rm: cannot remove `file1': No such file or directory
    student@linux:~/test$ echo $?
    1
    student@linux:~/test$

## && double ampersand

The shell will interpret `&&` as a `logical AND`. When
using `&&` the second command is executed only if the first one succeeds
(returns a zero exit status).

    student@linux:~$ echo first && echo second
    first
    second
    student@linux:~$ zecho first && echo second
    -bash: zecho: command not found

Another example of the same `logical AND` principle. This
example starts with a working `cd` followed by `ls`, then a non-working
`cd` which is `not` followed by `ls`.

    [student@linux ~]$ cd gen && ls
    file1  file3  File55  fileab  FileAB   fileabc
    file2  File4  FileA   Fileab  fileab2
    [student@linux gen]$ cd gen && ls
    -bash: cd: gen: No such file or directory

## \|\| double vertical bar

The `||` represents a `logical OR`. The second command is
executed only when the first command fails (returns a non-zero exit
status).

    student@linux:~$ echo first || echo second ; echo third
    first
    third
    student@linux:~$ zecho first || echo second ; echo third
    -bash: zecho: command not found
    second
    third
    student@linux:~$

Another example of the same `logical OR` principle.

    [student@linux ~]$ cd gen || ls
    [student@linux gen]$ cd gen || ls
    -bash: cd: gen: No such file or directory
    file1  file3  File55  fileab  FileAB   fileabc
    file2  File4  FileA   Fileab  fileab2

## combining && and \|\|

You can use this logical AND and logical OR to write an `if-then-else`
structure on the command line. This example uses `echo` to display
whether the `rm` command was successful.

    student@linux:~/test$ rm file1 && echo It worked! || echo It failed!
    It worked!
    student@linux:~/test$ rm file1 && echo It worked! || echo It failed!
    rm: cannot remove `file1': No such file or directory
    It failed!
    student@linux:~/test$

## \# pound sign

Everything written after a `pound sign` (#) is ignored by
the shell. This is useful to write a `shell comment`, but
has no influence on the command execution or shell expansion.

    student@linux:~$ mkdir test    # we create a directory
    student@linux:~$ cd test       #### we enter the directory
    student@linux:~/test$ ls       # is it empty ?
    student@linux:~/test$

## \\ escaping special characters

The backslash `\` character enables the use of control
characters, but without the shell interpreting it, this is called
`escaping` characters.

    [student@linux ~]$ echo hello \; world
    hello ; world
    [student@linux ~]$ echo hello\ \ \ world
    hello   world
    [student@linux ~]$ echo escaping \\\ \#\ \&\ \"\ \'
    escaping \ # & " '
    [student@linux ~]$ echo escaping \\\?\*\"\'
    escaping \?*"'

### end of line backslash

Lines ending in a backslash are continued on the next line. The shell
does not interpret the newline character and will wait on shell
expansion and execution of the command line until a newline without
backslash is encountered.

    [student@linux ~]$ echo This command line \
    > is split in three \
    > parts
    This command line is split in three parts
    [student@linux ~]$

