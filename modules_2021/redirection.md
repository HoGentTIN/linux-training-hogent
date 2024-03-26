# Shell redirection

## stdin, stdout, stderr


The **bash** shell has three default streams to work with. Stream 0 is
named **stdin**, stream 1 is named **stdout** and stream 2 is named
**stderr**.

<figure>
<img src="images/bash_stdin_stdout_stderr.svg"
alt="images/bash_stdin_stdout_stderr.svg" />
</figure>

By default **stream 0** is connected to the **keyboard**, while **stream
1 and 2** are both directed to your terminal window.

<figure>
<img src="images/bash_default_streams.svg"
alt="images/bash_default_streams.svg" />
</figure>

## &gt; stdout


Using the **bigger than** sign **&gt;** we can redirect **stream 1** to
something else than the terminal window. In fact **&gt;** is identical
to **1&gt;** because we are redirecting **stream 1** .

<figure>
<img src="images/bash_redir_stdout.svg"
alt="images/bash_redir_stdout.svg" />
</figure>

In the image above and in the screenshot below we redirect **stream 1**
to a file named **output.txt** .

    paul@debian10:~$ ls *.gz > output.txt
    paul@debian10:~$ cat output.txt
    all.txt.gz
    services.gz
    words.gz
    paul@debian10:~$

Note that **stream 2** a.k.a. **stderr** still goes to the terminal
window, as shown in the following screenshot.

    paul@debian10:~$ ls *.no > output.txt
    ls: cannot access '*.no': No such file or directory
    paul@debian10:~$

## &gt;&gt; stdout append


Data can be appended to a file when redirecting **stdout** using the
**&gt;&gt;** or **1&gt;&gt;** notation, as is shown in the next
screenshot.

    paul@debian10:~$ ls *.gz > output.txt
    paul@debian10:~$ cat output.txt
    all.txt.gz
    services.gz
    words.gz
    paul@debian10:~$ ls *.pdf >> output.txt
    paul@debian10:~$ cat output.txt
    all.txt.gz
    services.gz
    words.gz
    Linux.pdf
    paul@debian10:~$

## noclobber


There is the danger, when using **stdout redirection**, of overwriting
an existing file. In the example below we lose the contents of the
**output.txt** file.

    paul@debian10:~$ cat output.txt
    all.txt.gz
    services.gz
    words.gz
    Linux.pdf
    paul@debian10:~$ echo hello > output.txt
    paul@debian10:~$ cat output.txt
    hello
    paul@debian10:~$

This danger can be mitigated by setting the **noclobber** option (**set
-C** or **set -o noclobber**). This shell option prevents accidental
overwriting of an existing file.

    paul@debian10:~$ cat output.txt
    hello
    paul@debian10:~$ set -C
    paul@debian10:~$ echo hello > output.txt
    -bash: output.txt: cannot overwrite existing file
    paul@debian10:~$

But even with the **noclobber** option active, a file can be overwritten
using the **&gt;|** notation.

    paul@debian10:~$ cat output.txt
    hello
    paul@debian10:~$ set -C
    paul@debian10:~$ echo hello > output.txt
    -bash: output.txt: cannot overwrite existing file
    paul@debian10:~$ echo hello >| output.txt
    paul@debian10:~$

## quick file clear

The above explanation has as a consequence that **&gt; file** is a very
quick way to clear a file (or create an empty file if it does not
exist).

    paul@debian10:~$ > empty.txt
    paul@debian10:~$

Using **&gt;|** of course when you suspect that the **noclobber** option
is active.

    paul@debian10:~$ set -o noclobber
    paul@debian10:~$ >| empty.txt
    paul@debian10:~$

## redirection by the shell

The **bash shell** is redirecting **stdout** when using **&gt;** or
**&gt;&gt;** and the **bash shell** is effectively removing the
redirection from the command line. This allows you to put the
redirection anywhere in the command line. The following three command
lines are identical, except that the first one is more readable.

    paul@debian10:~$ echo hello > output.txt
    paul@debian10:~$ > output.txt echo hello
    paul@debian10:~$ echo > output.txt hello
    paul@debian10:~$

The same is true for redirection of **stderr** using **2&gt;** or
**2&gt;&gt;**.

## 2&gt; stderr


In the image below we redirect **stream 2** to a file named
**error.txt** using **2&gt;** . In this way we redirect all errors that
would appear in the terminal window instead to the file **error.txt**.

<figure>
<img src="images/bash_redir_stderr.svg"
alt="images/bash_redir_stderr.svg" />
</figure>

On the command line this looks like this.

    paul@debian10:~$ ls *.no 2> error.txt
    paul@debian10:~$

Note that normal output (a.k.a. stdout) is still directed to the
terminal window, as shown in the example below.

    paul@debian10:~$ ls *.gz 2> error.txt
    all.txt.gz  services.gz  words.gz
    paul@debian10:~$

## 2&gt;&gt; stderr append


Errors can be appended to an existing file using the **2&gt;&gt;**
notation, as is shown in the screenshot below.

    paul@debian10:~$ ls *.no 2>> error.txt
    paul@debian10:~$ cat error.txt
    ls: cannot access '*.no': No such file or directory
    paul@debian10:~$ ls *.no 2>> error.txt
    paul@debian10:~$ cat error.txt
    ls: cannot access '*.no': No such file or directory
    ls: cannot access '*.no': No such file or directory
    paul@debian10:~$

## 2&gt;&1 combining stdout and stderr


You can combine **stdout** and **stderr** in the same file using the
**2&gt;&1** notation. See the example below where we redirect both
**streams** to **all.txt** .

<figure>
<img src="images/bash_redir_2_in_1.svg"
alt="images/bash_redir_2_in_1.svg" />
</figure>

In the command line this looks like this.

    paul@debian10:~$ find / > all.txt 2>&1
    paul@debian10:~$

There is no output on your terminal window when redirecting both
**stdout** and **stderr** to one file, or to two separate files.

In the case above the order matters, **&gt; all.txt** must come before
**2&gt;&1** !

## &&gt; combining stdout and stderr


You can also combine both **stdout** and **stderr** using the **&&gt;**
notation. Both statements in the next screenshot are identical.

    paul@debian10:~$ find / > all.txt 2>&1
    paul@debian10:~$ find / &> all.txt
    paul@debian10:~$

## swapping stdout and stderr

You can swap **stdout** and **stderr** using **stream 3** (streams 3 to
9 are undefined until you use them). The swap goes like this; redirect
stream 3 to 1, then stream 1 to 2, then stream 2 to 3. On the command
line this looks like this:

    paul@debian10:~$ echo hello 3>&1 1>&2 2>&3
    hello
    paul@debian10:~$

This swap can be useful when you want to do actions like **grep**,
**head** or other filters on **stderr** instead of on **stdout** .

## &lt; redirecting stdin


In the example below we redirect **stdin** to come from a file (instead
of the keyboard), the file is named **list** and the redirection symbol
is a **smaller than** sign **&lt;** .

<figure>
<img src="images/bash_redir_stdin.svg"
alt="images/bash_redir_stdin.svg" />
</figure>

On the command line it looks like the screenshot below. We use **cat**
and **grep** in this screenshot because we have not seen **filters** yet
that cannot read from a file (which **cat** and **grep** can).

    paul@debian10:~$ ls *.txt > list
    paul@debian10:~$ cat < list
    all.txt
    combi.txt
    count.txt
    dates.txt
    empty.txt
    error.txt
    hello.txt
    output.txt
    test.txt
    paul@debian10:~$ grep dates < list
    dates.txt
    paul@debian10:~$

## &lt;&lt; here document


The **here document** construct is a way to send text (from the
keyboard) to a running program until it receives the **limit string**.
For example let us create a music artist list, until we type **stop**.

    paul@debian10:~$ cat <<stop
    > Abba
    > Bowie
    > Queen
    > stop
    Abba
    Bowie
    Queen
    paul@debian10:~$

We can keep the result in a file using **stdout** redirection. The rest
is identical to the example above.

    paul@debian10:~$ cat <<stop > music.txt
    > Queen
    > Abba
    > Bowie
    > stop
    paul@debian10:~$ head music.txt
    Queen
    Abba
    Bowie
    paul@debian10:~$

## &lt;&lt;&lt; here string


In the example below we send the value of a variable to the **grep**
command. You can put any string here.

    paul@debian10:~$ vartext="The answer is 42."
    paul@debian10:~$ grep 42 <<< $vartext
    The answer is 42.
    paul@debian10:~$ grep 33 <<< $vartext
    paul@debian10:~$

## | pipe symbol


In the previous chapters we already used the pipe symbol **|** to
combine two commands, for example **cat** and **grep** as seen in this
example.

    paul@debian10:$ cat dates.txt | grep France
     FR France         1582-12-09      SE Sweden         1753-02-17
    paul@debian10:$

What actually happens is the **stdout** of **cat dates.txt** will be
used as **stdin** for **grep France**. So the pipe symbol takes
**stdout** from a command and serves it as **stdin** for the next
command.

The pipe symbol does not forward **stderr**.

## Cheat sheet

<table>
<caption>Shell redirection</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>redirection</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>stdin</p></td>
<td style="text-align: left;"><p>standard input</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>stream 0</p></td>
<td style="text-align: left;"><p>standard input</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>stdout</p></td>
<td style="text-align: left;"><p>standard output</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>stream 1</p></td>
<td style="text-align: left;"><p>standard output</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>stderr</p></td>
<td style="text-align: left;"><p>standard error</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>stream 2</p></td>
<td style="text-align: left;"><p>standard error</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>&gt;</p></td>
<td style="text-align: left;"><p>redirect stdout</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>1&gt;</p></td>
<td style="text-align: left;"><p>redirect stdout</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>&gt;&gt;</p></td>
<td style="text-align: left;"><p>append redirect stdout</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>set -C</p></td>
<td style="text-align: left;"><p>activate the <strong>noclobber</strong>
option</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>&gt; foo</p></td>
<td style="text-align: left;"><p>quickly clear (or create) the file
named <strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>2&gt;</p></td>
<td style="text-align: left;"><p>redirect stderr</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>2&gt;&gt;</p></td>
<td style="text-align: left;"><p>append redirect stderr</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>2&gt;&amp;1</p></td>
<td style="text-align: left;"><p>redirect stderr to stream 1
(stdout)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>&amp;&gt;foo</p></td>
<td style="text-align: left;"><p>redirect stream 1 and 2 into file
<strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>&lt;foo</p></td>
<td style="text-align: left;"><p>redirect stdin from the file named
<strong>foo</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>&lt;&lt;</p></td>
<td style="text-align: left;"><p>here document (until the <strong>limit
string</strong>)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>&lt;&lt;&lt;</p></td>
<td style="text-align: left;"><p>here string (redirect input from a
string)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>foo|bar</p></td>
<td style="text-align: left;"><p>pipe stdout of <strong>foo</strong> to
stdin of <strong>bar</strong></p></td>
</tr>
</tbody>
</table>

Shell redirection

## Practice

1.  Execute the **find /** command and notice that you get a lot of
    output in your terminal window.

2.  Execute the same command, but redirect standard output to a file
    named **all.txt**. You should see different and less output on the
    screen.

3.  Now while redirecting output, also redirect the errors to a file
    named **error.txt** .

4.  Verify with **head** and **tail** that there is a list of files in
    **all.txt** .

5.  Verify with **grep** that **error.txt** is filled with **Permission
    denied**.

6.  Quickly empty the **error.txt** file.

7.  Activate the **noclobber** shell option.

8.  Quickly empty the **all.txt** file (with the noclobber active).

9.  Use cat to display the **dates.txt** file. Then redirect **stdin**
    to display this file.

10. Use **cat** to create a file listing tennis players, use **quit** as
    a **limit string**.

## Solution

1.  Execute the **find /** command and notice that you get a lot of
    output in your terminal window.

        find /

2.  Execute the same command, but redirect standard output to a file
    named **all.txt**. You should see different and less output on the
    screen.

        find / > all.txt

3.  Now while redirecting output, also redirect the errors to a file
    named **error.txt** .

        find / > all.txt 2> error.txt

4.  Verify with **head** and **tail** that there is a list of files in
    **all.txt** .

        head all.txt
        tail all.txt

5.  Verify with **grep** that **error.txt** is filled with **Permission
    denied**.

        grep Permission error.txt

6.  Quickly empty the **error.txt** file.

        > error.txt

7.  Activate the **noclobber** shell option.

        set -o noclobber

    or

        set -C

8.  Quickly empty the **all.txt** file (with the noclobber active).

        >| all.txt

9.  Use cat to display the **dates.txt** file. Then redirect **stdin**
    to display this file.

        cat dates.txt
        cat < dates.txt

10. Use **cat** to create a file listing tennis players, use **quit** as
    a **limit string**.

        cat > tennis <<quit
        Venus Williams
        Serena Williams
        Justine Henin
        quit
