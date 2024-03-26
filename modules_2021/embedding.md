# Shell embedding and child shells

## Shell embedding


Shell **embedding** is a useful trick to save time and effort, remember
Linux people are lazy and lazy people are efficient. Consider the
following two statements, where we copy the output from the **which**
command and use it as input for the **ls -l** command.

    paul@debian10:~$ which cat
    /usr/bin/cat
    paul@debian10:~$ ls -l /usr/bin/cat
    -rwxr-xr-x 1 root root 43744 Feb 28 16:30 /usr/bin/cat
    paul@debian10:~$

We can shorten this by embedding a **bash** shell in the command with
the **$( )** notation.

    paul@debian10:~$ ls -l $(which cat)
    -rwxr-xr-x 1 root root 43744 Feb 28 16:30 /usr/bin/cat
    paul@debian10:~$

When the **bash** shell is evaluating your command, it encounters the
**$(** and there it starts a new **bash** shell. That new **embedded**
shell then executes the **which cat** command and gives the result back
to our **bash** shell.

Nothing remains of the embedded shell once it executed its command(s). A
variable defined inside the embedded shell does not exist outside of
that shell.

    paul@debian10:~$ echo $(var5=500 ; echo \$var5=$var5 )
    $var5=500
    paul@debian10:~$ echo $var5
    -bash: var5: unbound variable
    paul@debian10:~$

You can *nest* embedded shells, sometimes this is useful!

## Backticks


Some people use **backticks** instead of the **$( )** notation for
embedded shells. This can be confusing to new users who mistake them for
**single quotes**. The result is quite different when using single
quotes.

    paul@debian10:~$ ls -l `which cat`
    -rwxr-xr-x 1 root root 43744 Feb 28 16:30 /usr/bin/cat
    paul@debian10:~$ ls -l 'which cat'
    ls: cannot access which cat: No such file or directory
    paul@debian10:~$

You cannot nest embedded shells with backticks.

## Child shells

Besides embedding shells, you can also create **child** shells. A
**child shell** is created when you type **bash** at the command line.
And you can exit this **child shell** by typing **exit** at the command
line.

    paul@debian10:~$ bash
    paul@debian10:~$ echo inside the child shell now
    inside the child shell now
    paul@debian10:~$ exit
    exit
    paul@debian10:~$

In this **child shell** you can do a lot of things without influencing
your **parent shell**. For example you can create variables, change
them, and destroy them, without changing any of the variables of the
**parent shell**.

    paul@debian10:~$ varans=42
    paul@debian10:~$ bash
    paul@debian10:~$ varans=8472
    paul@debian10:~$ echo $varans
    8472
    paul@debian10:~$ exit
    exit
    paul@debian10:~$ echo $varans
    42
    paul@debian10:~$

## Verifying that shell is child shell


You can verify that you are in a child shell by displaying the
**$SHLVL** variable.

    paul@debian10:~$ echo $SHLVL
    1
    paul@debian10:~$ bash
    paul@debian10:~$ echo $SHLVL
    2
    paul@debian10:~$ exit
    exit
    paul@debian10:~$ echo $SHLVL
    1
    paul@debian10:~$

## Exporting variables


A **child shell** will inherit all **exported** variables. See the
example below where we use the **export** command to export the
**$varans** variable.

    paul@debian10:~$ varmin=33
    paul@debian10:~$ varans=42
    paul@debian10:~$ export varans
    paul@debian10:~$ bash
    paul@debian10:~$ echo $varmin does not exist
    does not exist
    paul@debian10:~$ echo $varans is the answer
    42 is the answer
    paul@debian10:~$

You can type **export varans=42** to export and initialise a variable.

## env - printenv - export


There is, of course, a list of all exported variables. You can display
this list by typing **env**, or **printenv**, or **export** without any
arguments.

    paul@debian10:~$ env | tail -3
    MAIL=/var/mail/paul
    SSH_TTY=/dev/pts/0
    _=/usr/bin/env
    paul@debian10:~$ printenv | tail -3
    MAIL=/var/mail/paul
    SSH_TTY=/dev/pts/0
    _=/usr/bin/printenv
    paul@debian10:~$ export | tail -3
    declare -x XDG_SESSION_ID="54"
    declare -x XDG_SESSION_TYPE="tty"
    declare -x varans="42"
    paul@debian10:~$

Note that **export** gives you a **declare -x** command to **declare**
and **export** variables in one command.

## env

You can also use the **env** command to execute a new shell (or any
other command) in a new environment. In the screenshot below we start a
new child **bash** shell, but the **-i** option prevents inheritance of
even **exported** variables.

    paul@debian10:~$ export varans=42
    paul@debian10:~$ varmin=33
    paul@debian10:~$ env -i varspe=8472  bash
    paul@debian10:/home/paul$ echo $varspe $varans $varmin
    8472
    paul@debian10:/home/paul$ exit
    exit
    paul@debian10:~$

## Cheat sheet

<table>
<caption>Variables</caption>
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
<td style="text-align: left;"><p>foo $(bar)</p></td>
<td style="text-align: left;"><p>first execute <strong>bar</strong>,
then do <strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>foo `bar`</p></td>
<td style="text-align: left;"><p>first execute <strong>bar</strong>,
then do <strong>foo</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>bash</p></td>
<td style="text-align: left;"><p>starts a new bash shell (with its own
environment)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exit</p></td>
<td style="text-align: left;"><p>exits the current bash shell</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-d</p></td>
<td style="text-align: left;"><p>exits the current bash shell (by
sending a EOF character)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo $SHLVL</p></td>
<td style="text-align: left;"><p>displays how many shells deep you
are</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>export foo</p></td>
<td style="text-align: left;"><p>exports the variable foo to child
shells</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>env</p></td>
<td style="text-align: left;"><p>prints all <strong>exported</strong>
variables</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>printenv</p></td>
<td style="text-align: left;"><p>prints all <strong>exported</strong>
variables</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>export</p></td>
<td style="text-align: left;"><p>prints all <strong>exported</strong>
variables</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>env foo</p></td>
<td style="text-align: left;"><p>execute the <strong>foo</strong>
command in a default environment</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>env -i foo</p></td>
<td style="text-align: left;"><p>execute the <strong>foo</strong>
command in an empty environment</p></td>
</tr>
</tbody>
</table>

Variables

## Practice

1.  Verify that you are not in a **child shell** . Exit if necessary.

2.  Create and echo a variable in an **embedded** shell.

3.  Export the **varmin=33** variable.

4.  Start a **child** shell. Then start another **child** shell.

5.  Verify that **$SHLVL** is indeed 3.

6.  List all the exported variables.

7.  Verify that your **$varmin** exists and is **33** .

8.  Start a new bash shell in a clean environment.

## Solution

1.  Verify that you are not in a **child shell** . Exit if necessary.

        echo $SHLVL
        exit

2.  Create and echo a variable in an **embedded** shell.

        echo $( varans=42; echo The value is $varans )

    or

        echo ` varans=42; echo The value is $varans `

3.  Export the **varmin=33** variable.

        export varmin=33

    or

        declare -x varmin=33

4.  Start a **child** shell. Then start another **child** shell.

        bash
        bash

5.  Verify that **$SHLVL** is indeed 3.

        echo $SHLVL

6.  List all the exported variables.

        env
        printenv
        export

7.  Verify that your **$varmin** exists and is **33** .

        echo $varmin

8.  Start a new bash shell in a clean environment.

        env -i bash
