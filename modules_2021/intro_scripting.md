# Introduction to scripting

## About scripting chapters

The next four chapters discuss **bash** scripting on Debian Linux. The
goal of these chapters is not to become a skilled programmer, but rather
to be able to read and understand scripts. As an administrator you will
frequently encounter (simple) scripts in Debian Linux.

## Hello world

A script is a text file that can be executed line by line by (in this
case) the **bash shell**. Below is an example of a **Hello world**
script in bash.

    paul@debian10:~$ vi first.sh
    paul@debian10:~$ cat first.sh
    echo Hello world
    paul@debian10:~$

A text file is not executable by default. We have to manually set the
**x** flag for **executable** on the file. We can do this with the
**chmod +x** command (which will be discussed in detail in the
Permissions chapter).

    paul@debian10:~$ chmod +x first.sh
    paul@debian10:~$

To execute the script we wrote, we have to either use an absolute path
**/home/paul/first.sh** or use a relative path starting from the current
directory as in **./first.sh**. Remember that the current directory is
by default not in $PATH so typing just **first.sh** will result in a
**command not found** error.

    paul@debian10:~$ /home/paul/first.sh
    Hello world
    paul@debian10:~$ ./first.sh
    Hello world
    paul@debian10:~$ first.sh
    -bash: first.sh: command not found
    paul@debian10:~$

## Sha-bang


It is advised to start any script (bash or Perl or any other scripting
language) with **\#!** as the first two characters, followed by the
interpreter. In our case the interpreter will always be **/bin/bash**.

The **\#!** is called a **sha-bang** or **she-bang**. The next
screenshot shows how this looks.

    paul@debian10:~$ vi first.sh
    paul@debian10:~$ cat first.sh
    #!/bin/bash
    echo Hello world
    paul@debian10:~$

When launching the script, the Linux kernel will start a new process and
will read the **sha-bang** to know which exec it should perform for that
new process. This new process will end when the script ends.

In this book we only use **bash** for scripting, so the kernel will
always be starting **/bin/bash** for our scripts.

## Comment

Except for the **sha-bang**, any line that starts with **\#** is ignored
by the **bash shell**. You can use the **\#** to write comment about the
instruction(s).

In the example below we added some comments to our script.

    paul@debian10:~$ vi first.sh
    paul@debian10:~$ cat first.sh
    #!/bin/bash

    # This command displays Hello world
    echo Hello world

    # rm -rf ~ is not executed

    # The script will end here
    paul@debian10:~$

## Variables in a script

You can, of course, use variables in a script. In our example we create
a variable named **var\_s** and we give it a value.

    paul@debian10:~$ vi vars.sh
    paul@debian10:~$ chmod +x vars.sh
    paul@debian10:~$ cat vars.sh
    #!/bin/bash

    var_s=200

    echo Our var_s is $var_s

    paul@debian10:~$ ./vars.sh
    Our var_s is 200
    paul@debian10:~$

But this variable was created in a **child shell** to the current shell,
so it does not exist in our current shell. (You can verify the **child
shell** status using **echo $SHLVL**.)

    paul@debian10:~$ echo $var_s

    paul@debian10:~$

This means that a script that is executed has no influence on the
environment of our current shell. In the script you can create, use and
delete variables, all without touching any of the variables in our
current shell.

## Sourcing a script


If you **want** your script to change the current environment, then you
can, using the **source** command. When **sourcing** a script then the
script is run in the current shell (instead of in a child shell).

    paul@debian10:~$ source vars.sh
    Our var_s is 200
    paul@debian10:~$ echo $var_s
    200
    paul@debian10:~$

A **sourced** script does not need to be executable!

Since **source** is a long word to type you can abbreviate it as a
simple dot. The screenshot below shows two identical commands.

    paul@debian10:~$ source vars.sh
    Our var_s is 200
    paul@debian10:~$ . vars.sh
    Our var_s is 200
    paul@debian10:~$

## Reading input


You can ask the user of the script to give **runtime input** by using
the **read** statement. The following screenshot asks for a number and
then displays that number.

    paul@debian10:~$ cat ask.sh
    #!/bin/bash

    echo -n "Give a number between 1 and 9: "
    read number
    echo You gave $number
    paul@debian10:~$ ./ask.sh
    Give a number between 1 and 9: 4
    You gave 4
    paul@debian10:~$

There is no input validation in the previous example!

## Troubleshooting a script

You can force a script to run in a **bash** shell by tying **bash** with
the name of the script as the first argument.

    paul@debian10:~$ bash vars.sh
    Our var_s is 200
    paul@debian10:~$

You can give options to **bash** this way, for example the **xtrace**
option to have bash list all the commands that it executes. This can be
a way to troubleshoot a script.

This screenshot shows how bash writes every line it will execute behind
a **+** sign.

    paul@debian10:~$ bash -x vars.sh
    + var_s=200
    + echo Our var_s is 200
    Our var_s is 200
    paul@debian10:~$

## Cheat sheet

<table>
<caption>Intro scripting</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chmod +x foo</p></td>
<td style="text-align: left;"><p>Make <strong>foo</strong>
executable.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>./foo</p></td>
<td style="text-align: left;"><p>Execute <strong>foo</strong> in the
current directory.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>#!</p></td>
<td style="text-align: left;"><p>Denotes a sha-bang (if these are the
first two characters of a script).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>#!/bin/bash</p></td>
<td style="text-align: left;"><p>Denotes a sha-bang for the
<strong>bash</strong> shell.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>#</p></td>
<td style="text-align: left;"><p>Starts a comment in a script (or on the
command line).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>foo=bar</p></td>
<td style="text-align: left;"><p>Declare a variable named
<strong>foo</strong> with a value of <strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>source foo</p></td>
<td style="text-align: left;"><p>Source the script named
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>. foo</p></td>
<td style="text-align: left;"><p>Source the script named
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>read bar</p></td>
<td style="text-align: left;"><p>Read runtime input in the variable
<strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>bash foo</p></td>
<td style="text-align: left;"><p>Run the script <strong>foo</strong> in
a child bash shell.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>bash -x foo</p></td>
<td style="text-align: left;"><p>Run the script <strong>foo</strong> in
a child bash shell with <strong>xtrace</strong> on.</p></td>
</tr>
</tbody>
</table>

Intro scripting

## Practice

1.  Write a script that displays "The answer is 42." and execute it the
    normal way.

2.  Write a script that sets and echoes a variable, execute it and
    verify that your variable did not survive the script.

3.  Write some comments in your second script.

4.  Source your last script and verify that the variable now survives
    the script.

5.  Have the **bash** shell show every command of your script that it
    executes.

6.  Write a script with **cd /etc** in it. Is there a difference between
    normal execution and sourcing this script?

## Solution

1.  Write a script that displays "The answer is 42." and execute it the
    normal way.

        paul@debian10:~$ vi first.sh
        paul@debian10:~$ cat first.sh
        #!/bin/bash
        echo "The answer is 42."
        paul@debian10:~$ chmod +x first.sh
        paul@debian10:~$ ./first.sh
        The answer is 42.
        paul@debian10:~$

2.  Write a script that sets and echoes a variable, execute it and
    verify that your variable did not survive the script.

        paul@debian10:~$ vi second.sh
        paul@debian10:~$ cat second.sh
        #!/bin/bash
        varA=42
        echo $varA
        paul@debian10:~$ chmod +x second.sh
        paul@debian10:~$ ./second.sh
        42
        paul@debian10:~$ echo $varA

        paul@debian10:~$

3.  Write some comments in your second script.

        paul@debian10:~$ cat second.sh
        #!/bin/bash

        # declare a variable
        varA=42

        # Use a variable
        echo $varA
        paul@debian10:~$

4.  Source your last script and verify that the variable now survives
    the script.

        paul@debian10:~$ . second.sh
        42
        paul@debian10:~$ echo $varA
        42
        paul@debian10:~$

5.  Have the **bash** shell show every command of your script that it
    executes.

        paul@debian10:~$ bash -x second.sh
        + varA=42
        + echo 42
        42
        paul@debian10:~$

6.  Write a script with **cd /etc** in it. Is there a difference between
    normal execution and sourcing this script?

        paul@debian10:~$ cat third.sh
        #!/bin/bash
        cd /etc
        pwd
        paul@debian10:~$ ./third.sh
        /etc
        paul@debian10:~$ source third.sh
        /etc
        paul@debian10:/etc$
