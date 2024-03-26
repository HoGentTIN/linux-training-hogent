# Shell commands

## /bin/bash


The command prompt that you are typing in, is called a **shell**. If you
use **ssh** or **putty** to connect to a remote computer, then you are
using a **remote shell**. In both (local and remote) cases you are
probably using the **bash** shell since this is the default on Debian
10.

You can verify the shell by typing **echo $SHELL** in the command
prompt.

    paul@debian10:~$ echo $SHELL
    /bin/bash
    paul@debian10:~$

This **bash** shell is doing a lot of work to make your live easier, so
it is important to explain its workings.

## which


The **which** command tells you where the shell is searching for a
command when you type it. This allows you to type **cat** instead of
**/usr/bin/cat**.

    paul@debian10:~$ which cat head tail find
    /usr/bin/cat
    /usr/bin/head
    /usr/bin/tail
    /usr/bin/find
    paul@debian10:~$


The **which** command is looking in the **$PATH** for commands. This
**$PATH** is a list of directories, separated by a colon **":"** .

    paul@debian10:~$ echo $PATH
    /usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
    paul@debian10:~$

But the **which** command is incomplete since there is no answer for
commands like **cd** and **popd**.

    paul@debian10:~$ which cd popd
    paul@debian10:~$

## type


The **type** command is less known, but more complete than **which**. It
will also look in the **$PATH** directories, but before that it will
look at shell **built-in** commands.

    paul@debian10:~$ type cat head cd popd
    cat is /usr/bin/cat
    head is /usr/bin/head
    cd is a shell builtin
    popd is a shell builtin
    paul@debian10:~$

Notice that **cd** and **popd** are built-in to the bash shell.

Some commands exist as both a **built-in** command and as en external
command. For example the **echo** command shown in this screenshot.

    paul@debian10:~$ which echo
    /usr/bin/echo
    paul@debian10:~$ type echo
    echo is a shell builtin
    paul@debian10:~$

So the question is, which will be executed when you type **echo**? The
answer is that the **built-in** command gets priority to the external
command. So when you use **echo** it is the **built-in** echo of the
**bash shell** that is used. If you want to use the external **echo**
command then you have to type **/bin/echo** or **/usr/bin/echo**.

Commands that you have recently used are still in memory. The **type**
command will show these as **hashed** as can be seen in this screenshot.

    paul@debian10:~$ type which
    which is hashed (/usr/bin/which)
    paul@debian10:~$

## alias


The bash shell allows you to create **aliases** for commands. This
allows you for example to abbreviate commands.

    paul@debian10:~$ t cat head find
    -bash: t: command not found
    paul@debian10:~$ alias t=type
    paul@debian10:~$ t cat head find
    cat is /usr/bin/cat
    head is /usr/bin/head
    find is hashed (/usr/bin/find)
    paul@debian10:~$

But what happens when an **alias** is identical to a **built-in**
command? The answer is that the **alias** gets priority.

    paul@debian10:~$ alias cd=type
    paul@debian10:~$ cd cat head find
    cat is /usr/bin/cat
    head is /usr/bin/head
    find is hashed (/usr/bin/find)
    paul@debian10:~$

To summarise, the **alias** gets priority to the **built-in** which gets
priority to **external** commands.

One advantage that is often used, is that with **aliases** you can
define default options for commands. For example instead of always
typing **mv -i**, you can define an **alias** for this.

    paul@debian10:~$ alias mv='mv -i'
    paul@debian10:~$ mv studentfiles.html index.htm
    mv: overwrite 'index.htm'? n
    paul@debian10:~$

To see a list of all **aliases** just type **alias** at the command
prompt.

    paul@debian10:~$ alias
    alias cd='type'
    alias ls='ls --color=auto'
    alias mv='mv -i'
    alias t='type'
    paul@debian10:~$

## unalias


When you no longer need an **alias**, then you can remove it with
**unalias**. See the example below where we remove two aliases.

    paul@debian10:~$ unalias cd
    paul@debian10:~$ unalias t
    paul@debian10:~$ alias
    alias ls='ls --color=auto'
    alias mv='mv -i'
    paul@debian10:~$

## exit code


A command typed in the shell will (hopefully) end and then it returns an
**exit code**. You can query this **exit code** with the **echo $?**
command.

    paul@debian10:~$ cp Linuxfun.pdf Linux.pdf
    paul@debian10:~$ echo $?
    0
    paul@debian10:~$

An **exit code** of 0 means the command executed successfully.

## Double ampersand &&


You can use this **exit code** as a condition to execute another command
using the **&&** control operator. Read this as "If the first command
succeeds, then execute the second command.".

In the screenshot below we execute the **rm** command only if the **cp**
command returned an **exit code** of 0.

    paul@debian10:~$ cp Linuxfun.pdf Linux.pdf && rm Linuxfun.pdf
    paul@debian10:~$

## Double vertical bar ||


You can also use the **exit code** to execute another command if the
first command **fails**. Use the double pipe symbol **"||"** for this,
as shown in the example below.

    paul@debian10:~$ rm test || echo it failed
    rm: cannot remove 'test': No such file or directory
    it failed
    paul@debian10:~$

## Combining the two

You can use both the **&&** and the **||** to do one thing when the
command succeeds and another thing when the command fails. See this for
example.

    paul@debian10:~$ rm fun.pdf && echo it worked || echo it failed
    it worked
    paul@debian10:~$ rm fun.pdf && echo it worked || echo it failed
    rm: cannot remove 'fun.pdf': No such file or directory
    it failed
    paul@debian10:~$

## Operator ;


When you want to run two or more commands after each other, without
interpreting the **exit code**, then you can use the semicolon **";"**
operator. The result is identical to typing these commands one by one on
a separate line.

    paul@debian10:~$ rm index.htm ; echo hello ; alias
    hello
    alias ls='ls --color=auto'
    paul@debian10:~$

## man bash


The man page for **bash** can be reached by typing **man bash**. This
man page however is a long read. The next chapters are a summary of what
is the most needed Linux knowledge in medium to large organisations.

## Cheat sheet

<table>
<caption>Commands</caption>
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
<td style="text-align: left;"><p>/bin/bash</p></td>
<td style="text-align: left;"><p>this is the bash shell
executable</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo $SHELL</p></td>
<td style="text-align: left;"><p>displays your current shell</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>which</p></td>
<td style="text-align: left;"><p>searches the $PATH for a
command</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo $PATH</p></td>
<td style="text-align: left;"><p>displays the PATH variable (a colon
separated list of directories)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>type foo</p></td>
<td style="text-align: left;"><p>displays the type of the command
<strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>alias</p></td>
<td style="text-align: left;"><p>displays a list of all aliases</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>alias foo=bar</p></td>
<td style="text-align: left;"><p>defines the alias <strong>foo</strong>
as <strong>bar</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>alias cp='cp -i'</p></td>
<td style="text-align: left;"><p>defines a default option for
<strong>cp</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>unalias foo</p></td>
<td style="text-align: left;"><p>unsets the alias
<strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo $?</p></td>
<td style="text-align: left;"><p>displays the last error code</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>foo &amp;&amp; bar</p></td>
<td style="text-align: left;"><p>executes <strong>bar</strong> if
<strong>foo</strong> succeeds</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>foo || bar</p></td>
<td style="text-align: left;"><p>executes <strong>bar</strong> if
<strong>foo</strong> fails</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>foo ; bar</p></td>
<td style="text-align: left;"><p>executes <strong>foo</strong>, then
executes <strong>bar</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>man bash</p></td>
<td style="text-align: left;"><p>a long but interesting read</p></td>
</tr>
</tbody>
</table>

Commands

## Practice

1.  Display the external location of the **mv** and **cp** commands.

2.  Display the name of the current shell.

3.  Is the **pushd** command external or built-in?

4.  Create an alias for **cp** so the **-i** option is always used when
    typing **cp**.

5.  List all aliases in your current shell.

6.  Remove the **cp** alias.

7.  Copy Linuxfun.pdf to fun.pdf and then display the **exit code**.

8.  Run **echo it works** but only if **rm fun.pdf** succeeds.

9.  Run **echo it failed** but only if **rm fun.pdf** fails.

10. Open the manual of bash and search for the **xtrace** option, is it
    the same as **-x**?

## Solution

1.  Display the external location of the **mv** and **cp** commands.

        which mv cp

2.  Display the name of the current shell.

        echo $SHELL

3.  Is the **pushd** command external or built-in?

        type pushd

4.  Create an alias for **cp** so the **-i** option is always used when
    typing **cp**.

        alias cp='cp -i'

5.  List all aliases in your current shell.

        alias

6.  Remove the **cp** alias.

        unalias cp

7.  Copy Linuxfun.pdf to fun.pdf and then display the **exit code**.

        cp Linufun.pdf fun.pdf
        echo $?

8.  Run **echo it works** but only if **rm fun.pdf** succeeds.

        rm fun.pdf && echo it works

9.  Run **echo it failed** but only if **rm fun.pdf** fails.

        rm fun.pdf || echo it failed

10. Open the manual of bash and search for the **xtrace** option, is it
    the same as **-x**?

        man bash
        /xtrace
        n n n n
