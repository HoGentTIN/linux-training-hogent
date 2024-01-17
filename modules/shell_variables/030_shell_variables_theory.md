# \$ dollar sign

Another important character interpreted by the shell is the dollar sign
`$`. The shell will look for an
`environment variable` named like the string following the
`dollar sign` and replace it with the value of the variable (or with
nothing if the variable does not exist).

These are some examples using \$HOSTNAME, \$USER, \$UID, \$SHELL, and
\$HOME.

    [paul@RHELv8u3 ~]$ echo This is the $SHELL shell
    This is the /bin/bash shell
    [paul@RHELv8u3 ~]$ echo This is $SHELL on computer $HOSTNAME
    This is /bin/bash on computer RHELv8u3.localdomain
    [paul@RHELv8u3 ~]$ echo The userid of $USER is $UID
    The userid of paul is 500
    [paul@RHELv8u3 ~]$ echo My homedir is $HOME
    My homedir is /home/paul

# case sensitive

This example shows that shell variables are case sensitive!

    [paul@RHELv8u3 ~]$ echo Hello $USER
    Hello paul
    [paul@RHELv8u3 ~]$ echo Hello $user
    Hello

# creating variables

This example creates the variable `$MyVar` and sets its value. It then
uses `echo` to verify the value.

    [paul@RHELv8u3 gen]$ MyVar=555
    [paul@RHELv8u3 gen]$ echo $MyVar
    555
    [paul@RHELv8u3 gen]$

# quotes

Notice that double quotes still allow the parsing of variables, whereas
single quotes prevent this.

    [paul@RHELv8u3 ~]$ MyVar=555
    [paul@RHELv8u3 ~]$ echo $MyVar
    555
    [paul@RHELv8u3 ~]$ echo "$MyVar"
    555
    [paul@RHELv8u3 ~]$ echo '$MyVar'
    $MyVar

The bash shell will replace variables with their value in double quoted
lines, but not in single quoted lines.

    paul@laika:~$ city=Burtonville
    paul@laika:~$ echo "We are in $city today."
    We are in Burtonville today.
    paul@laika:~$ echo 'We are in $city today.'
    We are in $city today. 

# set

You can use the `set` command to display a list of
environment variables. On Ubuntu and Debian systems, the `set` command
will also list shell functions after the shell variables. Use
`set | more` to see the variables then.

# unset

Use the `unset` command to remove a variable from your
shell environment.

    [paul@RHEL4b ~]$ MyVar=8472
    [paul@RHEL4b ~]$ echo $MyVar
    8472
    [paul@RHEL4b ~]$ unset MyVar
    [paul@RHEL4b ~]$ echo $MyVar

    [paul@RHEL4b ~]$

# \$PS1

The `$PS1` variable determines your shell prompt. You can use backslash
escaped special characters like `\u` for the username or `\w` for the
working directory. The `bash` manual has a complete reference.

In this example we change the value of `$PS1` a couple of times.

    paul@deb503:~$ PS1=prompt
    prompt
    promptPS1='prompt '
    prompt 
    prompt PS1='> '
    > 
    > PS1='\u@\h$ '
    paul@deb503$ 
    paul@deb503$ PS1='\u@\h:\W$'
    paul@deb503:~$

To avoid unrecoverable mistakes, you can set normal user prompts to
green and the root prompt to red. Add the following to your `.bashrc`
for a green user prompt:

    # color prompt by paul
    RED='\[\033[01;31m\]'
    WHITE='\[\033[01;00m\]'
    GREEN='\[\033[01;32m\]'
    BLUE='\[\033[01;34m\]'
    export PS1="${debian_chroot:+($debian_chroot)}$GREEN\u$WHITE@$BLUE\h$WHITE\w\$ "

# \$PATH

The `$PATH` variable is determines where the shell is
looking for commands to execute (unless the command is builtin or
aliased). This variable contains a list of directories, separated by
colons.

    [[paul@RHEL4b ~]$ echo $PATH
    /usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:

The shell will not look in the current directory for commands to
execute! (Looking for executables in the current directory provided an
easy way to hack PC-DOS computers). If you want the shell to look in the
current directory, then add a . at the end of your \$PATH.

    [paul@RHEL4b ~]$ PATH=$PATH:.
    [paul@RHEL4b ~]$ echo $PATH
    /usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:.
    [paul@RHEL4b ~]$

Your path might be different when using su instead of
`su -` because the latter will take on the environment of
the target user. The root user typically has `/sbin` directories added
to the \$PATH variable.

    [paul@RHEL3 ~]$ su
    Password: 
    [root@RHEL3 paul]# echo $PATH
    /usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin
    [root@RHEL3 paul]# exit
    [paul@RHEL3 ~]$ su -
    Password: 
    [root@RHEL3 ~]# echo $PATH
    /usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:
    [root@RHEL3 ~]#

# env

The `env` command without options will display a list of
`exported variables`. The difference with `set` with options is that
`set` lists all variables, including those not exported to child shells.

But `env` can also be used to start a clean shell (a shell without any
inherited environment). The `env -i` command clears the
environment for the subshell.

Notice in this screenshot that `bash` will set the `$SHELL` variable on
startup.

    [paul@RHEL4b ~]$ bash -c 'echo $SHELL $HOME $USER'
    /bin/bash /home/paul paul
    [paul@RHEL4b ~]$ env -i bash -c 'echo $SHELL $HOME $USER'
    /bin/bash
    [paul@RHEL4b ~]$

You can use the `env` command to set the `$LANG`, or any other, variable
for just one instance of `bash` with one command. The example below uses
this to show the influence of the `$LANG` variable on file globbing (see
the chapter on file globbing).

    [paul@RHEL4b test]$ env LANG=C bash -c 'ls File[a-z]'
    Filea  Fileb
    [paul@RHEL4b test]$ env LANG=en_US.UTF-8 bash -c 'ls File[a-z]'
    Filea  FileA  Fileb  FileB
    [paul@RHEL4b test]$

# export

You can export shell variables to other shells with the
`export` command. This will export the variable to child
shells.

    [paul@RHEL4b ~]$ var3=three
    [paul@RHEL4b ~]$ var4=four
    [paul@RHEL4b ~]$ export var4
    [paul@RHEL4b ~]$ echo $var3 $var4
    three four
    [paul@RHEL4b ~]$ bash
    [paul@RHEL4b ~]$ echo $var3 $var4
    four

But it will not export to the parent shell (previous screenshot
continued).

    [paul@RHEL4b ~]$ export var5=five
    [paul@RHEL4b ~]$ echo $var3 $var4 $var5
    four five
    [paul@RHEL4b ~]$ exit
    exit
    [paul@RHEL4b ~]$ echo $var3 $var4 $var5
    three four
    [paul@RHEL4b ~]$

# delineate variables

Until now, we have seen that bash interprets a variable starting from a
dollar sign, continuing until the first occurrence of a non-alphanumeric
character that is not an underscore. In some situations, this can be a
problem. This issue can be resolved with curly braces like in this
example.

    [paul@RHEL4b ~]$ prefix=Super
    [paul@RHEL4b ~]$ echo Hello $prefixman and $prefixgirl
    Hello  and
    [paul@RHEL4b ~]$ echo Hello ${prefix}man and ${prefix}girl
    Hello Superman and Supergirl
    [paul@RHEL4b ~]$

# unbound variables

The example below tries to display the value of the `$MyVar` variable,
but it fails because the variable does not exist. By default the shell
will display nothing when a variable is unbound (does not exist).

    [paul@RHELv8u3 gen]$ echo $MyVar
                    
    [paul@RHELv8u3 gen]$

There is, however, the `nounset` shell option that you can
use to generate an error when a variable does not exist.

    paul@laika:~$ set -u
    paul@laika:~$ echo $Myvar
    bash: Myvar: unbound variable
    paul@laika:~$ set +u
    paul@laika:~$ echo $Myvar

    paul@laika:~$

In the bash shell `set -u` is identical to `set -o nounset` and likewise
`set +u` is identical to `set +o nounset`.
