# Shell variables

## Variables in the shell


Variables in the shell always start with a dollar sign **"$"**.
Applications can use variables to define certain settings (for example:
a path to a directory).

In this chapter we discuss variables in the shell, later in this book we
will see how applications define and use variables.

## declare


You can define a variable by **declaring** it. In the screenshot below
we declare two variables; the first explicitly, the second implicitly.

    paul@debian10:~$ declare var1=33
    paul@debian10:~$ var2=42
    paul@debian10:~$

You can now use echo to use these variables.

    paul@debian10:~$ echo The answer is $var2
    The answer is 42
    paul@debian10:~$ echo Why $var1 seconds
    Why 33 seconds
    paul@debian10:~$

You can also put a string (like a path) in a variable.

    paul@debian10:~$ var3=/var/tmp
    paul@debian10:~$ cd $var3
    paul@debian10:/var/tmp$

Notice that when declaring a variable you do not use the dollar sign
**$**.

## Variables and quotes

Variables between **double quotes** are still parsed by the shell and
thus are replaced by their value.

    paul@debian10:~$ echo "The answer is $var2"
    The answer is 42
    paul@debian10:~$

Variables between **single quotes** are not parsed, this is a big
difference between **single** and **double** quotes.

    paul@debian10:~$ echo 'Why $var1 seconds?'
    Why $var1 seconds?
    paul@debian10:~$

Single quotes are often called **full quotes**.

## Parsed by the shell?

Yes, the **bash shell** is replacing variables with their value.
Consider this example with **xtrace** active.

    paul@debian10:~$ set -x
    paul@debian10:~$ echo "The answer is $var2"
    + echo 'The answer is 42'
    The answer is 42
    paul@debian10:~$

The **echo** command in the example above does not see **$var2**, it
receives **42** instead. The **echo** command doesn’t even know how to
handle variables, it simply *echoes* what it receives from the bash
shell.

## Escaping the $

Another way to prevent the parsing of variables by the shell is to
escape the dollar sign as shown in this screenshot.

    paul@debian10:~$ echo Why \$var1 seconds?
    Why $var1 seconds?
    paul@debian10:~$

## set


You can see the list of all variables in the shell by typing the **set**
command. There are many variables so we truncate the screenshot to the
top nine.

    paul@debian10:~$ set | head -9
    BASH=/bin/bash
    BASHOPTS=checkwinsize:cmdhist:complete_fullquote:expand_aliases:extglob:extquote:force_fignore:globasciiranges:histappend:interactive_comments:login_shell:progcomp:promptvars:sourcepath
    BASH_ALIASES=()
    BASH_ARGC=([0]="0")
    BASH_ARGV=()
    BASH_CMDS=()
    BASH_COMPLETION_VERSINFO=([0]="2" [1]="8")
    BASH_LINENO=()
    BASH_SOURCE=()
    paul@debian10:~$

The **set** command will also list all **functions**, more on
**functions** in the Scripting chapters.

You can use **grep** in combination with **set** to find the variables
that we just created.

    paul@debian10:~$ set | grep var1
    var1=33
    paul@debian10:~$ set | grep var2
    var2=42
    paul@debian10:~$

We will explain the **|** symbol in the redirection chapter.

## unset


You can **unset** a variable with the **unset** command. The variable
then no longer exists. The example below shows what happens when you use
an non-existing variable.

    paul@debian10:~$ echo The answer is $var2
    The answer is 42
    paul@debian10:~$ unset var2
    paul@debian10:~$ echo The answer is $var2
    The answer is
    paul@debian10:~$

As you can see the non-existing variable is replaced with *nothing*.

Do not use the $ when unsetting a variable.

## Unbound variables


You may want an error message when you use a non-existing (=unbound)
variable. You can achieve this by setting the **nounset** shell option
either with **set -u** or with **set -o nounset**.

    paul@debian10:~$ echo The answer is $var2
    The answer is
    paul@debian10:~$ set -o nounset
    paul@debian10:~$ echo The answer is $var2
    -bash: var2: unbound variable
    paul@debian10:~$

## Delineate variables

Consider the following example where we create a **$pre** variable with
a value of **Super**.

    paul@debian10:~$ pre=Super
    paul@debian10:~$ echo $preman is stronger than $pregirl
    is stronger than
    paul@debian10:~$

The **$pre** is not recognised in the example above, this can be solved
in several ways.

    paul@debian10:~$ echo ${pre}man is stronger than $pre'girl'
    Superman is stronger than Supergirl
    paul@debian10:~$ echo "$pre"man is stronger than $pre"girl"
    Superman is stronger than Supergirl
    paul@debian10:~$

## $SHELL


The **$SHELL** variable is initialised by the **bash** shell when the
shell is started. It is set to **/bin/bash**. If, one day, the **bash**
shell is replaced with another shell, then this variable will probably
be changed.

    paul@debian10:~$ echo $SHELL
    /bin/bash
    paul@debian10:~$

## $PS1


The **$PS1** variable determines the look of the prompt. In the example
below we set the prompt to the text **prompt&gt;** . Everything else is
unaffected, the shell works exactly as before.

    paul@debian10:~$ PS1='prompt>'
    prompt>
    prompt>file studentfiles.html
    studentfiles.html: HTML document, ASCII text
    prompt>

We can set it back to something useful using the following shortcuts.

<table style="width:70%;">
<caption>PS1 backslash-escaped shortcuts</caption>
<colgroup>
<col style="width: 35%" />
<col style="width: 35%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>shortcut</p></td>
<td style="text-align: left;"><p>decoding</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>\u</p></td>
<td style="text-align: left;"><p>name of current user</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>\h</p></td>
<td style="text-align: left;"><p>hostname</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>\w</p></td>
<td style="text-align: left;"><p>current directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>\$</p></td>
<td style="text-align: left;"><p>$ for users and # for root</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>\t</p></td>
<td style="text-align: left;"><p>current time</p></td>
</tr>
</tbody>
</table>

PS1 backslash-escaped shortcuts

So let us set the prompt to include these shortcuts. To do this we
simply set the **$PS1** variable.

    prompt>
    prompt>PS1='\u \h \w \t '
    paul debian10 ~ 07:32:38
    paul debian10 ~ 07:32:39

Almost good, so let us include the **@** and the **:** and the **$**,
and do not forget to add a space at the end.

    paul debian10 ~ 07:32:39 PS1=\'\u@\h:\w@\t\$ '
    paul@debian10:~@07:34:21$
    paul@debian10:~@07:34:27$

Later in this book we will see how to add a *function* to the prompt.

## $PATH


We have discussed the **$PATH** variable before, together with the
**which** command. This variable contains a list of directories,
separated by a colon **:** .

    paul@debian10:~$ echo $PATH
    /usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
    paul@debian10:~$

These directories are checked in order when executing a command (the
**which** command also checks them in order). So if a command with the
same name exists in two of these directories, then only the first will
be executed.

You can add or remove directories from the **$PATH** by setting the
variable. In the example below we add the **/home/paul/bin** directory
at the end of the **$PATH**.

    paul@debian10:~$ PATH=$PATH:/home/paul/bin
    paul@debian10:~$

You may have noticed that the **current directory** is not in the
**$PATH**. This is for security reasons. You can however add it, in
front of all the other directories, if you desire to live dangerously.

    paul@debian10:~$ PATH=.:$PATH
    paul@debian10:~$ echo $PATH
    .:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/paul/bin
    paul@debian10:~$

Remember the **current directory** is represented by a simple dot.

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
<td style="text-align: left;"><p>declare foo=42</p></td>
<td style="text-align: left;"><p>Declares and initialises a variable
named <strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo $foo</p></td>
<td style="text-align: left;"><p>Displays the value of the variable
<strong>foo</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo "$foo"</p></td>
<td style="text-align: left;"><p>Displays the value of the variable
<strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo '$foo'</p></td>
<td style="text-align: left;"><p>Displays $foo</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>set | grep foo</p></td>
<td style="text-align: left;"><p>Searches in all variable names for the
string <strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>unset foo</p></td>
<td style="text-align: left;"><p>Unsets (destroys) the variable named
<strong>foo</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>set -o nounset</p></td>
<td style="text-align: left;"><p>Sets the shell option to error when
using non-existing variables.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo $foo"bar"</p></td>
<td style="text-align: left;"><p>Displays the contents of
<strong>foo</strong> followed by the string
<strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo "$foo"bar</p></td>
<td style="text-align: left;"><p>Displays the contents of
<strong>foo</strong> followed by the string
<strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo $foo’bar'</p></td>
<td style="text-align: left;"><p>Displays the contents of
<strong>foo</strong> followed by the string
<strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Displays the contents of
<strong>foo</strong> followed by the string
<strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$PATH</p></td>
<td style="text-align: left;"><p>This variable contains directories
where commands can be found.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>$SHELL</p></td>
<td style="text-align: left;"><p>This variable contains the name of the
current shell.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$PS1</p></td>
<td style="text-align: left;"><p>This variable contains the prompt in
the bash shell.</p></td>
</tr>
</tbody>
</table>

Variables

## Practice

1.  Declare a variable named **$varone** with a value of **100** .

2.  Declare a variable named **$mypath** with a value of
    **/home/yourname** .

3.  Display both your variables on one line.

4.  Display both your variables on one line with six spaces between
    them.

5.  Display **$varone=100** by escaping the first dollar sign.

6.  Use the **set** command to display your variables.

7.  Delete the **$mypath** variable.

8.  Make sure you get an error when using **$mypath** .

9.  Remove the games directories from the **$PATH** .

10. Log out and log back on, are your variables still there?

## Solution

1.  Declare a variable named **$varone** with a value of **100** .

        varone=100

2.  Declare a variable named **$mypath** with a value of
    **/home/yourname** .

        mypath=/home/paul

3.  Display both your variables on one line.

        echo $mypath and $varone

4.  Display both your variables on one line with six spaces between
    them.

        echo "$mypath      $varone"

    or

        echo $mypath'      '$varone

5.  Display **$varone=100** by escaping the first dollar sign.

        echo \$varone=$varone

6.  Use the **set** command to display your variables.

        set | grep varone
        set | grep mypath

7.  Delete the **$mypath** variable.

        unset mypath

8.  Make sure you get an error when using **$mypath** .

        set -u
        echo $mypath

9.  Remove the games directories from the **$PATH** .

        PATH=/usr/local/bin:/usr/bin:/bin

10. Log out and log back on, are your variables still there?

        no
