## shell embedding

Shells can be `embedded` on the command line, or in other
words, the command line scan can spawn new processes containing a fork
of the current shell. You can use variables to prove that new shells are
created. In the screenshot below, the variable \$var1 only exists in the
(temporary) sub shell.

    [student@linux gen]$ echo $var1

    [student@linux gen]$ echo $(var1=5;echo $var1)
    5
    [student@linux gen]$ echo $var1

    [student@linux gen]$

You can embed a shell in an `embedded shell`, this is
called `nested embedding` of shells.

This screenshot shows an embedded shell inside an embedded shell.

    student@linux:~$ A=shell
    student@linux:~$ echo $C$B$A $(B=sub;echo $C$B$A; echo $(C=sub;echo $C$B$A))
    shell subshell subsubshell

### backticks

Single embedding can be useful to avoid changing your current directory.
The screenshot below uses `backticks` instead of dollar-bracket to
embed.

    [student@linux ~]$ echo `cd /etc; ls -d * | grep pass`
    passwd passwd- passwd.OLD
    [student@linux ~]$

You can only use the `$()` notation to nest embedded
shells, `backticks` cannot do this.

### backticks or single quotes

Placing the embedding between `backticks` uses one
character less than the dollar and parenthesis combo. Be careful
however, backticks are often confused with single quotes. The technical
difference between `'` and `` ` `` is
significant!

    [student@linux gen]$ echo `var1=5;echo $var1`
    5
    [student@linux gen]$ echo 'var1=5;echo $var1'
    var1=5;echo $var1
    [student@linux gen]$

## shell options

Both `set` and `unset` are builtin shell
commands. They can be used to set options of the bash shell itself. The
next example will clarify this. By default, the shell will treat unset
variables as a variable having no value. By setting the -u option, the
shell will treat any reference to unset variables as an error. See the
man page of bash for more information.

    [student@linux ~]$ echo $var123

    [student@linux ~]$ set -u
    [student@linux ~]$ echo $var123
    -bash: var123: unbound variable
    [student@linux ~]$ set +u
    [student@linux ~]$ echo $var123

    [student@linux ~]$

To list all the set options for your shell, use `echo $-`.
The `noclobber` (or `-C`) option will be explained later in this book
(in the I/O redirection chapter).

    [student@linux ~]$ echo $-
    himBH
    [student@linux ~]$ set -C ; set -u
    [student@linux ~]$ echo $-
    himuBCH
    [student@linux ~]$ set +C ; set +u
    [student@linux ~]$ echo $-
    himBH
    [student@linux ~]$

When typing `set` without options, you get a list of all variables
without function when the shell is on `posix` mode. You can set bash in
posix mode typing `set -o posix`.

