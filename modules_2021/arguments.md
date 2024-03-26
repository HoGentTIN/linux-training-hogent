# Shell arguments

## White space removal


The shell will remove all whitespace and tabs from your command line.
See for example the following three identical command lines.

    paul@debian10:~$ echo hello world
    hello world
    paul@debian10:~$ echo    hello    world
    hello world
    paul@debian10:~$      echo       hello       world
    hello world
    paul@debian10:~$

The shell is effectively cutting your command line into distinct
**arguments**. For the lines above the first **argument** is always
**echo**. We call this **argument zero**. The second argument is always
**hello** without any spaces, we call this **argument one**. And
**world** is **argument two**.

The **echo** command will display all the arguments that it receives,
with a space added between the arguments. This is true even in this
example.

    paul@debian10:~$ echo hello world
    hello world
    paul@debian10:~$

In the example above the shell removes the space between **echo** and
**hello** and the space between **hello** and **world**. The **echo**
command then adds a space between **argument one** (hello) and
**argument two** (world).

## Single quotes


When using single quotes on the command line, you tell the shell that
the stuff between single quotes is **one single argument**. The
following screenshot shows a command line that contains only **two
arguments** ; namely **argument zero** is **echo** and **argument one**
is **hello**     **world** with the six spaces included.

    paul@debian10:~$ echo 'hello      world'
    hello      world
    paul@debian10:~$

Since the **echo** command only receives one argument, it displays that
one argument as is.

then the shell will assume you have not finished your command line yet.
You must enter the second quote, or type **Ctrl-c** for an interrupt.

    paul@debian10:~$ echo 'hello
    > world'

## Double quotes


In this chapter using **double quotes** is essentially identical to
using **single quotes** ; namely you are telling the shell that the
stuff between the **double quotes** is one single argument. Later in the
book we will discuss differences between using single quotes and double
quotes.

    paul@debian10:~$ echo "Hello      world"
    Hello      world
    paul@debian10:~$

## Pound sign \#


The pound sign **"#"** is a control operator where the shell stops
interpreting. This means that anything after this **pound sign** is
ignored (same as with a hashtag ;-).

    paul@debian10:~$ echo hello # this is not shown
    hello
    paul@debian10:~$ echo hello # rm -rf /home is not executed
    hello
    paul@debian10:~$

## Escaping with \\


You can **escape** all the control operators and quotes with the
**backslash** **"\\**. This prevents the shell from interpreting the
special character.

    paul@debian10:~$ echo a hashtag looks like this \# yes
    a hashtag looks like this # yes
    paul@debian10:~$ echo here\'s a quote
    here's a quote
    paul@debian10:~$

## End of line \\

If you end your command line with a **\\** followed directly by an
**enter** key, then the **enter** key is ignored. This means you can
continue writing your command line, on several lines.

The next screenshot contains a command line over four lines.

    paul@debian10:~$ echo Hello \
    > world \
    > and also Mars,\
    > and Venus
    Hello world and also Mars,and Venus
    paul@debian10:~$

## set -x


You can verify what the shell is doing with your command line by typing
**set -x** to activate the shell **xtrace** option. (Yes the shell has
options, more on that later in this book).

In the example below we use this option to see that **echo** first gets
two arguments and in the second command gets only one argument. (Look
behind the + sign).

    paul@debian10:~$ set -x
    paul@debian10:~$ echo hello world
    + echo hello world
    hello world
    paul@debian10:~$ echo 'hello world'
    + echo 'hello world'
    hello world
    paul@debian10:~$

You can disable the **-x** option by typing **set +x** or **set +o
xtrace**.

## Cheat sheet

<table>
<caption>Arguments</caption>
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
<td style="text-align: left;"><p>echo hello world</p></td>
<td style="text-align: left;"><p>this is three arguments, with argument
zero being <strong>echo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo 'hello world'</p></td>
<td style="text-align: left;"><p>this is two arguments, the second is
<strong>hello world</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo "hello world"</p></td>
<td style="text-align: left;"><p>this is two arguments, the second is
<strong>hello world</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>foo #bar</p></td>
<td style="text-align: left;"><p><strong>bar</strong> is a comment (not
interpreted by the shell)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo \#</p></td>
<td style="text-align: left;"><p>this will display a # because it is
escaped (so not interpreted)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>set -x</p></td>
<td style="text-align: left;"><p>activate the shell’s xtrace
option</p></td>
</tr>
</tbody>
</table>

Arguments

## Practice

1.  Create one file named **foo bar** (do not create two files foo and
    bar).

2.  Use tab-completion to remove this file.

3.  Echo a single and a double quote to the screen.

4.  Find three different ways to display a pound sign \# on the screen.

5.  Write a command line on three lines.

6.  Activate the **xtrace** option in bash.

7.  Execute **echo $SHELL** while the **xtrace** is active and try to
    explain what happens.

8.  Disable the **xtrace** option.

## Solution

1.  Create one file named **foo bar** (do not create two files foo and
    bar).

        touch 'foo bar'

2.  Use tab-completion to remove this file.

        rm fo tab-key

3.  Echo a single and a double quote to the screen.

        echo \' \"

4.  Find three different ways to display a pound sign \# on the screen.

        echo \#
        echo "#"
        echo '#'

5.  Write a command line on three lines.

        echo hello \
        world \
        and Mars

6.  Activate the **xtrace** option in bash.

        set -x

    or

        set -o xtrace

7.  Execute **echo $SHELL** while the **xtrace** is active and try to
    explain what happens. We will see the solution in the next chapter.

8.  Disable the **xtrace** option.

        set +o xtrace

    or

        set +x
