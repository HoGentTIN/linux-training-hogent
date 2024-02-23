## \$ dollar sign

Another important character interpreted by the shell is the dollar sign
`$`. The shell will look for an
`environment variable` named like the string following the
`dollar sign` and replace it with the value of the variable (or with
nothing if the variable does not exist).

These are some examples using \$HOSTNAME, \$USER, \$UID, \$SHELL, and
\$HOME.

    [student@linux ~]$ echo This is the $SHELL shell
    This is the /bin/bash shell
    [student@linux ~]$ echo This is $SHELL on computer $HOSTNAME
    This is /bin/bash on computer RHELv8u3.localdomain
    [student@linux ~]$ echo The userid of $USER is $UID
    The userid of paul is 500
    [student@linux ~]$ echo My homedir is $HOME
    My homedir is /home/paul

## case sensitive

This example shows that shell variables are case sensitive!

    [student@linux ~]$ echo Hello $USER
    Hello paul
    [student@linux ~]$ echo Hello $user
    Hello

## creating variables

This example creates the variable `$MyVar` and sets its value. It then
uses `echo` to verify the value.

    [student@linux gen]$ MyVar=555
    [student@linux gen]$ echo $MyVar
    555
    [student@linux gen]$

## quotes

Notice that double quotes still allow the parsing of variables, whereas
single quotes prevent this.

    [student@linux ~]$ MyVar=555
    [student@linux ~]$ echo $MyVar
    555
    [student@linux ~]$ echo "$MyVar"
    555
    [student@linux ~]$ echo '$MyVar'
    $MyVar

The bash shell will replace variables with their value in double quoted
lines, but not in single quoted lines.

    student@linux:~$ city=Burtonville
    student@linux:~$ echo "We are in $city today."
    We are in Burtonville today.
    student@linux:~$ echo 'We are in $city today.'
    We are in $city today. 

## set

You can use the `set` command to display a list of
environment variables. On Ubuntu and Debian systems, the `set` command
will also list shell functions after the shell variables. Use
`set | more` to see the variables then.

## unset

Use the `unset` command to remove a variable from your
shell environment.

    [student@linux ~]$ MyVar=8472
    [student@linux ~]$ echo $MyVar
    8472
    [student@linux ~]$ unset MyVar
    [student@linux ~]$ echo $MyVar

    [student@linux ~]$

## \$PS1

The `$PS1` variable determines your shell prompt. You can use backslash
escaped special characters like `\u` for the username or `\w` for the
working directory. The `bash` manual has a complete reference.

In this example we change the value of `$PS1` a couple of times.

    student@linux:~$ PS1=prompt
    prompt
    promptPS1='prompt '
    prompt 
    prompt PS1='> '
    > 
    > PS1='\u@\h$ '
    student@linux$ 
    student@linux$ PS1='\u@\h:\W$'
    student@linux:~$

To avoid unrecoverable mistakes, you can set normal user prompts to
green and the root prompt to red. Add the following to your `.bashrc`
for a green user prompt:

    # color prompt by paul
    RED='\[\033[01;31m\]'
    WHITE='\[\033[01;00m\]'
    GREEN='\[\033[01;32m\]'
    BLUE='\[\033[01;34m\]'
    export PS1="${debian_chroot:+($debian_chroot)}$GREEN\u$WHITE@$BLUE\h$WHITE\w\$ "

## \$PATH

The `$PATH` variable is determines where the shell is
looking for commands to execute (unless the command is builtin or
aliased). This variable contains a list of directories, separated by
colons.

    [[student@linux ~]$ echo $PATH
    /usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:

The shell will not look in the current directory for commands to
execute! (Looking for executables in the current directory provided an
easy way to hack PC-DOS computers). If you want the shell to look in the
current directory, then add a . at the end of your \$PATH.

    [student@linux ~]$ PATH=$PATH:.
    [student@linux ~]$ echo $PATH
    /usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:.
    [student@linux ~]$

Your path might be different when using su instead of
`su -` because the latter will take on the environment of
the target user. The root user typically has `/sbin` directories added
to the \$PATH variable.

    [student@linux ~]$ su
    Password: 
    [root@linux paul]# echo $PATH
    /usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin
    [root@linux paul]# exit
    [student@linux ~]$ su -
    Password: 
    [root@linux ~]# echo $PATH
    /usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:
    [root@linux ~]#

## env

The `env` command without options will display a list of
`exported variables`. The difference with `set` with options is that
`set` lists all variables, including those not exported to child shells.

But `env` can also be used to start a clean shell (a shell without any
inherited environment). The `env -i` command clears the
environment for the subshell.

Notice in this screenshot that `bash` will set the `$SHELL` variable on
startup.

    [student@linux ~]$ bash -c 'echo $SHELL $HOME $USER'
    /bin/bash /home/paul paul
    [student@linux ~]$ env -i bash -c 'echo $SHELL $HOME $USER'
    /bin/bash
    [student@linux ~]$

You can use the `env` command to set the `$LANG`, or any other, variable
for just one instance of `bash` with one command. The example below uses
this to show the influence of the `$LANG` variable on file globbing (see
the chapter on file globbing).

    [student@linux test]$ env LANG=C bash -c 'ls File[a-z]'
    Filea  Fileb
    [student@linux test]$ env LANG=en_US.UTF-8 bash -c 'ls File[a-z]'
    Filea  FileA  Fileb  FileB
    [student@linux test]$

## export

You can export shell variables to other shells with the
`export` command. This will export the variable to child
shells.

    [student@linux ~]$ var3=three
    [student@linux ~]$ var4=four
    [student@linux ~]$ export var4
    [student@linux ~]$ echo $var3 $var4
    three four
    [student@linux ~]$ bash
    [student@linux ~]$ echo $var3 $var4
    four

But it will not export to the parent shell (previous screenshot
continued).

    [student@linux ~]$ export var5=five
    [student@linux ~]$ echo $var3 $var4 $var5
    four five
    [student@linux ~]$ exit
    exit
    [student@linux ~]$ echo $var3 $var4 $var5
    three four
    [student@linux ~]$

## delineate variables

Until now, we have seen that bash interprets a variable starting from a
dollar sign, continuing until the first occurrence of a non-alphanumeric
character that is not an underscore. In some situations, this can be a
problem. This issue can be resolved with curly braces like in this
example.

    [student@linux ~]$ prefix=Super
    [student@linux ~]$ echo Hello $prefixman and $prefixgirl
    Hello  and
    [student@linux ~]$ echo Hello ${prefix}man and ${prefix}girl
    Hello Superman and Supergirl
    [student@linux ~]$

## unbound variables

The example below tries to display the value of the `$MyVar` variable,
but it fails because the variable does not exist. By default the shell
will display nothing when a variable is unbound (does not exist).

    [student@linux gen]$ echo $MyVar
                    
    [student@linux gen]$

There is, however, the `nounset` shell option that you can
use to generate an error when a variable does not exist.

    student@linux:~$ set -u
    student@linux:~$ echo $Myvar
    bash: Myvar: unbound variable
    student@linux:~$ set +u
    student@linux:~$ echo $Myvar

    student@linux:~$

In the bash shell `set -u` is identical to `set -o nounset` and likewise
`set +u` is identical to `set +o nounset`.

