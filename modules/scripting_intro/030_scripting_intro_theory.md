## prerequisites

You should have read and understood `part III shell expansion` and
`part IV pipes and commands` before starting this chapter.

## hello world

Just like in every programming course, we start with a simple
`hello_world` script. The following script will output `Hello World`.

    echo Hello World

After creating this simple script in `vi` or with `echo`, you\'ll have
to `chmod +x hello_world` to make it executable. And
unless you add the scripts directory to your path, you\'ll have to type
the path to the script for the shell to be able to find it.

    [paul@RHEL8a ~]$ echo echo Hello World > hello_world
    [paul@RHEL8a ~]$ chmod +x hello_world 
    [paul@RHEL8a ~]$ ./hello_world 
    Hello World
    [paul@RHEL8a ~]$

## she-bang

Let\'s expand our example a little further by putting `#!/bin/bash` on
the first line of the script. The `#!` is called a
`she-bang` (sometimes called `sha-bang`), where the
`she-bang` is the first two characters of the script.

    #!/bin/bash
    echo Hello World

You can never be sure which shell a user is running. A script that works
flawlessly in `bash` might not work in `ksh`,
`csh`, or `dash`. To instruct a shell to run your script
in a certain shell, you can start your script with a
`she-bang` followed by the shell it is supposed to run in.
This script will run in a bash shell.

    #!/bin/bash
    echo -n hello
    echo A bash subshell `echo -n hello`
            

This script will run in a Korn shell (unless `/bin/ksh` is a hard link
to `/bin/bash`). The `/etc/shells` file contains a list of
shells available on your system. Check it to see which ones are optional
for you

    #!/bin/ksh
    echo -n hello
    echo a Korn subshell `echo -n hello`
            

in order to shorten search for needed path for your shell environment
you could use `env`. env is used to either print environment variables.
It is also used to run a utility or command in a custom environment. In
practice, `env` has another common use. It is often used by shell
scripts to launch the correct interpreter.

    #!/usr/bin/env bash
    echo -n hello
    echo A bash subshell $(echo -n hello)
            

as of 2020, Bourne Again SHell, or bash for short, still remains the
most needed language to shorten the gap the difference between
UNIX/Linux based systems and various applications they use. Moreover,
due its usefulness it was incorporated in windows10 operational
system(WSL). thus its knowledge is more needed, then you might have
known.

## comments

When writing Bash scripts, it is always a good practice to make your
code clean and easily understandable. Organizing your code in blocks,
indenting, giving variables and functions descriptive names are several
ways to do this. Another way to improve the readability of your code is
by using comments. A comment is a human-readable explanation or
annotation that is written in the shell script.

Let\'s expand our example a little further by adding comment lines.

    #!/usr/bin/env bash  # this is sha-bang using env command
    #
    # Hello World Script
    #
    echo Hello World
    echo A bash subshell `echo -n hello` 
    # this is old way of calling for subshell with backtick ``
    echo A bash subshell $(echo -n hello) 
    # this is more modern way of calling for subshell with dollar and brackets $()
    #NOTICE: backtick might not work in future versions of bash shell

## variables

Here is a simple example of a variable inside a script.

    #!/usr/bin/env bash
    #
    # simple variable in script
    #
    var1=4
    echo var1 = $var1

Scripts can contain variables, but since scripts are run in their own
shell, the variables do not survive the end of the script.

    [paul@RHEL8a ~]$ echo $var1

    [paul@RHEL8a ~]$ ./vars
    var1 = 4
    [paul@RHEL8a ~]$ echo $var1

    [paul@RHEL8a ~]$

## sourcing a script

Luckily, you can force a script to run in the same shell; this is called
`sourcing` a script.

    [paul@RHEL8a ~]$ source ./vars
    var1 = 4
    [paul@RHEL8a ~]$ echo $var1
    4
    [paul@RHEL8a ~]$ 
            

The above is identical to the below.

    [paul@RHEL8a ~]$ . ./vars
    var1 = 4
    [paul@RHEL8a ~]$ echo $var1
    4
    [paul@RHEL8a ~]$ 
            

## troubleshooting a script

Another way to run a script in a separate shell is by typing `bash` with
the name of the script as a parameter.

    paul@debian10~/test$ bash runme
    42

Expanding this to `bash -x` allows you to see the commands
that the shell is executing (after shell expansion).

    paul@debian10~/test$ bash -x runme
    + var4=42
    + echo 42
    42
    paul@debian10~/test$ cat runme
    # the runme script
    var4=42
    echo $var4
    paul@debian10~/test$

Notice the absence of the commented (#) line, and the replacement of the
variable before execution of `echo`.

## prevent setuid root spoofing

Some user may try to perform `setuid` based script
`root spoofing`. This is a rare but possible attack. To improve script
security and to avoid interpreter spoofing, you need to add `--` after
the `#!/bin/bash`, which disables further option processing so the shell
will not accept any options.

    #!/usr/bin/env bash -
    or
    #!/usr/bin/env bash --

Any arguments after the `--` are treated as filenames and
arguments. An argument of - is equivalent to \--.
