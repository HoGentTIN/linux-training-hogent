# File contents

This chapter uses some of the files that were downloaded in the previous
chapter.

## head


The Linux command line is good at dealing with text files. The first
command we will look at is called **head**. This command will display
the first ten lines of a file.

First verify with the **file** command that the file is indeed a text
file. Running text commands on non-text files can have awkward results.

    paul@debian10:~$ file dates.txt
    dates.txt: ASCII text
    paul@debian10:~$ head dates.txt
     AL Albania        1912-11-30      IT Italy          1582-10-04
     AT Austria        1583-10-05      JP Japan          1918-12-18
     AU Australia      1752-09-02      LI Lithuania      1918-02-01
     BE Belgium        1582-12-14      LN Latin          9999-05-31
     BG Bulgaria       1916-03-18      LU Luxembourg     1582-12-14
     CA Canada         1752-09-02      LV Latvia         1918-02-01
     CH Switzerland    1655-02-28      NL Netherlands    1582-12-14
     CN China          1911-12-18      NO Norway         1700-02-18
     CZ Czech Republic 1584-01-06      PL Poland         1582-10-04
     DE Germany        1700-02-18      PT Portugal       1582-10-04
    paul@debian10:~$

You can change the default of 10 lines to any other number by writing
the desired number as an option to the **head** command. The example
below displays the first three line of a text file.

    paul@debian10:~$ file dates.txt
    dates.txt: ASCII text
    paul@debian10:~$ head -3 dates.txt
     AL Albania        1912-11-30      IT Italy          1582-10-04
     AT Austria        1583-10-05      JP Japan          1918-12-18
     AU Australia      1752-09-02      LI Lithuania      1918-02-01
    paul@debian10:~$

## tail


The **tail** command is complementary to **head** in that it displays
the last ten lines of a text file. And just like with **head**, you can
choose another number.

    paul@debian10:~$ tail -4 dates.txt
     GB United Kingdom 1752-09-02      TR Turkey         1926-12-18
     GR Greece         1924-03-09      US United States  1752-09-02
     HU Hungary        1587-10-21      YU Yugoslavia     1919-03-04
     IS Iceland        1700-11-16
    paul@debian10:~$

## cat


The **cat** command will display the full text file on the screen. Even
for very long text files. This might not seem very useful now, but we
will use **cat** a lot in this book.

    paul@debian10:~$ cat dates.txt
     AL Albania        1912-11-30      IT Italy          1582-10-04
     AT Austria        1583-10-05      JP Japan          1918-12-18
     AU Australia      1752-09-02      LI Lithuania      1918-02-01
     BE Belgium        1582-12-14      LN Latin          9999-05-31
     BG Bulgaria       1916-03-18      LU Luxembourg     1582-12-14
     CA Canada         1752-09-02      LV Latvia         1918-02-01
     CH Switzerland    1655-02-28      NL Netherlands    1582-12-14
     CN China          1911-12-18      NO Norway         1700-02-18
     CZ Czech Republic 1584-01-06      PL Poland         1582-10-04
     DE Germany        1700-02-18      PT Portugal       1582-10-04
     DK Denmark        1700-02-18      RO Romania        1919-03-31
     ES Spain          1582-10-04      RU Russia         1918-01-31
     FI Finland        1753-02-17      SI Slovenia       1919-03-04
     FR France         1582-12-09      SE Sweden         1753-02-17
     GB United Kingdom 1752-09-02      TR Turkey         1926-12-18
     GR Greece         1924-03-09      US United States  1752-09-02
     HU Hungary        1587-10-21      YU Yugoslavia     1919-03-04
     IS Iceland        1700-11-16
    paul@debian10:~$

Again, don’t use these commands on random files, always verify with the
**file** command that the target file is a text file.

## Creating files with cat

The **cat** command can be used to create simple text files. In this
example we create a text file that contains four words, one on each
line. We will explain how this works in the Redirection chapter.

After typing **four** and the enter key, type **Ctrl d** to send an EOF
character to the **cat** command.

    paul@debian10:~$ cat > count.txt
    one
    two
    three
    four
    paul@debian10:~$

Take a look at the file with **head** and **tail** to discover its
contents.

    paul@debian10:~$ head -3 count.txt
    one
    two
    three
    paul@debian10:~$ tail -3 count.txt
    two
    three
    four
    paul@debian10:~$

## tac


Complementary to **cat** is **tac**. The **tac** command is the reverse
of the **cat** command.

    paul@debian10:~$ cat count.txt
    one
    two
    three
    four
    paul@debian10:~$ tac count.txt
    four
    three
    two
    one
    paul@debian10:~$

In Linux there are a lot of simple small commands that do only one
thing, but they do that one thing very efficiently. Consider these
commands as **building blocks** for more complex solutions. More about
this in the Filters chapter.

## wc


The **wc** (short for **w**ord **c**ount) command can count characters,
words and lines in a (text) file. In the example below we count the
number of **l**ines of our humble **count.txt** file and of the
**/etc/services** file.

    paul@debian10:~$ wc -l count.txt
    4 count.txt
    paul@debian10:~$ file /etc/services
    /etc/services: ASCII text
    paul@debian10:~$ wc -l /etc/services
    578 /etc/services
    paul@debian10:~$

The example below shows the **-w** option to count the number of words
in a file.

    paul@debian10:~$ wc -w index.htm
    149 index.htm
    paul@debian10:~$

And finally we count the number of characters in the **dates.txt** file
using the **-c** option.

    paul@debian10:~$ wc -l dates.txt
    18 dates.txt
    paul@debian10:~$ wc -c dates.txt
    1118 dates.txt
    paul@debian10:~$

## grep


As you can see in the previous example, the **/etc/services** file has
too many lines to display on the screen. The first tool that we will see
to cope with this is the **grep** command. With **grep** you can select
lines from a text file.

In this example we select all the lines containing the string **http**.

    paul@debian10:~$ grep http /etc/services
    # Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml .
    http            80/tcp          www             # WorldWideWeb HTTP
    https           443/tcp                         # http protocol over TLS/SSL
    http-alt        8080/tcp        webcache        # WWW caching service
    http-alt        8080/udp
    paul@debian10:~$

Notice that with **grep** the target file is the last argument.

## more


Another way to display parts of or the whole file is using the **more**
command. With the **more** command you can display text files page by
page (using the space key) or even line by line (using the enter key).

    paul@debian10:~$ more /etc/services
    # Network services, Internet style
    #
    # Note that it is presently the policy of IANA to assign a single well-known
    # port number for both TCP and UDP; hence, officially ports have two entries
    # even if the protocol doesn't support UDP operations.
    #
    # Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-p
    ort-numbers.xhtml .
    #
    # New ports will be added on request if they have been officially assigned
    # by IANA and used in the real-world or are needed by a debian package.
    # If you need a huge list of used numbers please install the nmap package.

    tcpmux          1/tcp                           # TCP port service multiplexer
    echo            7/tcp
    echo            7/udp
    discard         9/tcp           sink null
    discard         9/udp           sink null
    systat          11/tcp          users
    daytime         13/tcp
    daytime         13/udp
    netstat         15/tcp
    qotd            17/tcp          quote
    msp             18/tcp                          # message send protocol
    --More--(4%)

Try using the enter key and the space bar to advance in this file. Press
**q** to quit the **more** command.

## echo


Another very simple command is **echo**. The **echo** command will
display whatever you give it as arguments. In combination with the
**greater than** sign, you can create a simple file with **echo**.

    paul@debian10:~$ echo hello world
    hello world
    paul@debian10:~$ echo hello world > hello.txt
    paul@debian10:~$ cat hello.txt
    hello world
    paul@debian10:~$

We can expand the **hello.txt** file using two **greater than** signs.
See the example below.

    paul@debian10:~$ cat hello.txt
    hello world
    paul@debian10:~$ echo hello again >> hello.txt
    paul@debian10:~$ cat hello.txt
    hello world
    hello again
    paul@debian10:~$

## Cheat sheet

<table>
<caption>File contents</caption>
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
<td style="text-align: left;"><p>head foo</p></td>
<td style="text-align: left;"><p>Show the top ten lines of the text file
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>head -5</p></td>
<td style="text-align: left;"><p>Show the top 5 lines.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>tail</p></td>
<td style="text-align: left;"><p>Show the last ten lines.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tail -42</p></td>
<td style="text-align: left;"><p>Show the last 42 lines.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>cat</p></td>
<td style="text-align: left;"><p>Show the complete file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tac</p></td>
<td style="text-align: left;"><p>Reverse of <strong>cat</strong>, shows
last line first.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>wc foo</p></td>
<td style="text-align: left;"><p>Count lines, words and characters in
(text) file <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>wc -l</p></td>
<td style="text-align: left;"><p>Count lines.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>wc -w</p></td>
<td style="text-align: left;"><p>Count words.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>wc -c</p></td>
<td style="text-align: left;"><p>Count characters.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>grep foo bar</p></td>
<td style="text-align: left;"><p>Show the lines containing
<strong>foo</strong> in the (text) file <strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>more foo</p></td>
<td style="text-align: left;"><p>Show the (text) file
<strong>foo</strong> page by page.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo foo</p></td>
<td style="text-align: left;"><p>Display the string
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cat &gt; foo</p></td>
<td style="text-align: left;"><p>Create (or empty) a file named
<strong>foo</strong>, end input with <strong>Ctrl-d</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>head -33 foo &gt; bar</p></td>
<td style="text-align: left;"><p>Create (or empty) the
<strong>bar</strong> file, then put the first 33 lines of
<strong>foo</strong> in it.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tail -1201 foo &gt; bar</p></td>
<td style="text-align: left;"><p>Create (or empty) the
<strong>bar</strong> file, then put the last 1201 lines of
<strong>foo</strong> in it.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo foo &gt; bar</p></td>
<td style="text-align: left;"><p>Put the string <strong>foo</strong> in
the file named <strong>bar</strong> after clearing
<strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo foo &gt;&gt; bar</p></td>
<td style="text-align: left;"><p>Append the string <strong>foo</strong>
to the file named <strong>bar</strong>.</p></td>
</tr>
</tbody>
</table>

File contents

## Practice

1.  Display the top five lines of the **dates.txt** file.

2.  Display the bottom eleven lines of **/etc/services**.

3.  Use **cat** to display the **studentfiles.html** file.

4.  Use **more** to display the **/etc/services** file, advance in the
    file with the **enter** key and the **space** bar.

5.  Use **cat** to create a file that contains five lines, name the file
    **five.txt**.

6.  Display the **five.txt** file in reverse.

7.  Count the number of lines in **five.txt**.

8.  Count the number of characters in **five.txt**

9.  Use echo to create a file named **abc.txt** that contains "**The
    quick brown fox jumps over the lazy dog.**"

10. Use echo to expand the file named **abc.txt** with this line "**The
    answer to life, the universe, and everything is 42.**"

## Solution

1.  Display the top five lines of the **dates.txt** file.

        head -5 dates.txt

2.  Display the bottom eleven lines of **/etc/services**.

        tail -11 /etc/services

3.  Use **cat** to display the **studentfiles.html** file.

        cat studentfiles.html

4.  Use **more** to display the **/etc/services** file, advance in the
    file with the **enter** key and the **space** bar.

        more /etc/services

5.  Use **cat** to create a file that contains five lines, name the file
    **five.txt**.

        cat > five.txt
        one
        two
        three
        four
        five

    Followed by a **Ctrl d** key.

6.  Display the **five.txt** file in reverse.

        tac five.txt

7.  Count the number of lines in **five.txt**.

        wc -l five.txt

8.  Count the number of characters in **five.txt**

        wc -c five.txt

9.  Use echo to create a file named **abc.txt** that contains "**The
    quick brown fox jumps over the lazy dog.**"

        echo The quick brown fox jumps over the lazy dog. > abc.txt

10. Use echo to expand the file named **abc.txt** with this line "**The
    answer to life, the universe, and everything is 42.**"

        echo The answer to life, the universe and everything is 42. >> abc.txt
