# More scripting

## eval


The **eval** builtin command will concatenate a string with spaces and
execute this as a command in the current **bash** shell. So it is
similar to **bash -c** but runs in the current environment.

    paul@debian10:~$ var1='echo'
    paul@debian10:~$ var2='hello'
    paul@debian10:~$ var3='world'
    paul@debian10:~$ eval $var1 $var2 $var3
    hello world
    paul@debian10:~$

This **eval** notation also allows to use the value of a variable as a
variable. The following screenshot shows what we mean by this.

    paul@debian10:~$ answer=42
    paul@debian10:~$ word=answer
    paul@debian10:~$ eval echo \$$word
    42
    paul@debian10:~$

This allows also to set complete commands in a variable, you cannot
execute the variable, but you can **eval** it, as we show in this
screenshot.

    paul@debian10:~$ lastweek='date --date="1 week ago"
    paul@debian10:~$ $lastweek
    date: extra operand ‘ago"’
    Try 'date --help for more information.
    paul@debian10:~$ eval $lastweek
    Thu 08 Aug 2019 01:04:21 PM CEST
    paul@debian10:~$

## expr


The **expr** command prints the value of an (often mathematical)
expression to standard output, as shown in the examples below.

    paul@debian10:~$ expr 33 + 42
    75
    paul@debian10:~$ expr 42 \* 8472
    355824
    paul@debian10:~$ expr 355824 / 8472
    42
    paul@debian10:~$

You can combine the **expr** command with embedded shells, as shown in
this example. Note that **date +%s** gives the number of seconds since
the epoch Jan 1st, 1970. Dividing this by 86400, the number of seconds
in a day, gives us the number of days passed since the Linux epoch.

    paul@debian10:~$ expr $(date +%s) / 86400
    18123
    paul@debian10:~$

## let


The **let** command will evaluate an arithmetic expression and will
return 0 (true) unless the last argument evaluates to 0, then it will
return 1 (false). See these examples.

    paul@debian10:~$ let x='33 + 42' && echo $x
    75
    paul@debian10:~$ let x='10 + 100/10' && echo $x
    20
    paul@debian10:~$ let x='10-2+100/10' && echo $x
    18
    paul@debian10:~$ let x='10*2+100/10' && echo $x
    30
    paul@debian10:~$

It is August 2019 as of this writing and the following math problem is
trending: 8/2(2+2) is it 1 or 16. Can you find out?

    paul@debian10:~$ let y='2+2' && let x="8 / 2 * $y" && echo $x
    16
    paul@debian10:~$

Note also that the **let "expression"** is the exact same as **\\(
expression ))**. The latter is often used in a **while** statement as in
the screenshot below. The expression will remain **true** until $#
becomes 0.

    #!/bin/bash

    while (( $# ))
    do
      [ -f $1 ] && echo $1 exists || echo $1 not found
      shift
    done

This script is an answer to the previous practice question 4.

The **let** command can work with different numeral systems (bases).
Here is an example of first and second in **hexadecimal** and then third
and fourth in **octal**.

    paul@debian10:~$ let x="0xFF" && echo $x
    255
    paul@debian10:~$ let x="16#FF" && echo $x
    255
    paul@debian10:~$ let x="8#77" && echo $x
    63
    paul@debian10:~$ let x="8#100" && echo $x
    64
    paul@debian10:~$

Beware, **let** and **declare** for variables are different from each
other.

    paul@debian10:~$ dec=15 ; oct=017 ; hex=0x0F
    paul@debian10:~$ echo $dec $oct $hex
    15 017 0x0F
    paul@debian10:~$ let dec=15 ; let oct=017 ; let hex=0x0F
    paul@debian10:~$ echo $dec $oct $hex
    15 15 15
    paul@debian10:~$

## functions

Functions are a collection of commands that can be called by the name of
the function as one command. Here is a simple example of a function that
combines two **echo** commands into one new **greetings** command.

    paul@debian10:~$ cat functions.sh
    #!/bin/bash

    function greetings {
    echo Hello world.
    echo Hello to $USER.
    }

    echo We will now call a function.
    greetings
    echo The end.
    paul@debian10:~$ ./functions.sh
    We will now call a function.
    Hello world.
    Hello to paul.
    The end.
    paul@debian10:~$

A function can also receive parameters, for example this function which
adds two numbers receives both numbers as a parameter. Sourcing this
function would make the **plus** command valid on the command line.

    paul@debian10:~$ cat functions2.sh
    #!/bin/bash

    function plus {
    let result="$1 + $2"
    echo $1 + $2 = $result
    }

    plus 33 42
    plus 42 33
    plus 8472 33
    paul@debian10:~$ ./functions2.sh
    33 + 42 = 75
    42 + 33 = 75
    8472 + 33 = 8505
    paul@debian10:~$

This function can also be written as a one-liner on the command line.
Note the extra semicolon after the last command (echo) inside the
function.

    paul@debian10:$ function plus { let r="$1 + $2" ; echo $r ; } ; plus 33 42
    75
    paul@debian10:$

## exit code in $PS1

Some Linux administrators put a lot of information in the command prompt
**$PS1**, sometimes spanning multiple lines. One way to do this is using
the **$PROMPT\_COMMAND** variable of bash. If you assign a function to
this variable, then that function will be executed each time the prompt
is displayed. This allows you to put the output of any script in your
command prompt.

As an example, we put the last error code in red in the command prompt.
It displays a space when there is no error code. We also simplified the
prompt colour usage. Source this script, or put the function and the
**export** in your **~/.bashrc**.

    paul@debian10~$ cat prompt.sh
    #!/bin/bash

    prompt_command () {
     [ $? -eq 0 ] && ERR=" " || ERR='==$?== '
     RED="\[\033[01;31m\]"
     GREEN="\[\033[01;32m\]"
     BLUE="\[\033[01;34m\]"
     WHITE="\[\033[01;37m\]"
     DEFAULT="\[\033[0;39m\]"
     export PS1="$GREEN\u$WHITE@$BLUE\h$WHITE\w\$$RED$ERR$DEFAULT"
    }

    export PROMPT_COMMAND=prompt_command
    paul@debian10~$

Typing a command that produces an error will have an output like this.
The **==1==** is displayed in red.

    paul@debian10~$ rm g
    rm: cannot remove g: No such file or directory
    paul@debian10~$==1==
    paul@debian10~$==1==

This method allows you to put cpu load, current time, number of httpd
processes, current weather, or anything in your command prompt.

## Cheat sheet

<table>
<caption>More scripting</caption>
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
<td style="text-align: left;"><p>eval</p></td>
<td style="text-align: left;"><p>Concatenate to a string with spaces and
execute as a command.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>expr</p></td>
<td style="text-align: left;"><p>Print the value of an
expression.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>let</p></td>
<td style="text-align: left;"><p>Evaluate an arithmetic
expression.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>let i--</p></td>
<td style="text-align: left;"><p>Decrease the value of i with
1.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>let i++</p></td>
<td style="text-align: left;"><p>Increase the value of i with
1.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>let x="0x42"</p></td>
<td style="text-align: left;"><p>Let x be the
<strong>hexadecimal</strong> value 42.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>let x="16#42"</p></td>
<td style="text-align: left;"><p>Let x be the
<strong>hexadecimal</strong> value 42.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>let x="8#42"</p></td>
<td style="text-align: left;"><p>Let x be the <strong>octal</strong>
value 42.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>\(( expression ))</p></td>
<td style="text-align: left;"><p>This is identical to <strong>let
expression</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>function foo { bar ; }</p></td>
<td style="text-align: left;"><p>Declare a function named
<strong>foo</strong> which executes <strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>foo</p></td>
<td style="text-align: left;"><p>Call the function named
<strong>foo</strong>.</p></td>
</tr>
</tbody>
</table>

More scripting

## Practice

1.  Read and understand this chapter, then put the red-coloured error
    code in your prompt.
