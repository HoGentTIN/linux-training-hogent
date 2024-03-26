# Filters

## Filters


Programs, like **grep**, **cat**, **head**, **tail**, and many more,
that take text input from **stdin** and give text output to **stdout**
are called **filters** . These **filters** can be used to manipulate and
transform text files into usable data files.

In this chapter we will take a look at a limited set of **filters** .

## | pipe symbol


We use the pipe symbol **|** between two filters to use **stdout** from
the first filter as **stdin** to the second filter. In the screenshot
below we send the **stdout** from the **cat** command via the pipe
symbol and as **stdin** to the **grep** command.

    paul@debian10:~$ cat dates.txt | grep Turkey
     GB United Kingdom 1752-09-02      TR Turkey         1926-12-18
    paul@debian10:~$

Note that **stderr** is *not* passed through the | pipe symbol.

## cat


The simplest filter of all is the **cat** command, because it does
nothing. It takes **stdin** and puts it on **stdout**. Text is not
changed when piping it through the **cat** command.

    paul@debian10:~$ cat count.txt | cat | cat | cat | cat
    one
    two
    three
    four
    paul@debian10:~$

## tac


The **tac** filter also takes **stdin**, but it puts the last line first
in **stdout**. It reverses the lines of a file.

    paul@debian10:~$ cat count.txt | tac
    four
    three
    two
    one
    paul@debian10:~$

## tee


The **tee** filter takes **stdin** and creates two outputs, one to
**stdout** and one to a file. This filter can help in troubleshooting
long command lines with many pipes, or just to keep intermediate results
of a complex text manipulation.

    paul@debian10:~$ cat count.txt | tac | tee temp.txt | tac
    one
    two
    three
    four
    paul@debian10:~$ cat temp.txt
    four
    three
    two
    one
    paul@debian10:~$

Note that both **cat** and **tee** do not change anything in the pipe
line.

## grep


The **grep** filter can select lines that contain a certain **string**.
For example in the screenshot below we filter for **Belgium**. Note that
**grep** is case sensitive by default.

    paul@debian10:~$ cat dates.txt | grep Belgium
     BE Belgium        1582-12-14      LN Latin          9999-05-31
    paul@debian10:~$ cat dates.txt | grep belgium
    paul@debian10:~$

You can force **grep** to be case insensitive by using the **-i**
option.

    paul@debian10:~$ cat dates.txt | grep -i belgium
     BE Belgium        1582-12-14      LN Latin          9999-05-31
    paul@debian10:~$ cat dates.txt | grep -i CHINA
     CN China          1911-12-18      NO Norway         1700-02-18
    paul@debian10:~$

And you can select lines **not** containing a certain string using the
**-v** option.

    paul@debian10:~$ head -3 dates.txt
     AL Albania        1912-11-30      IT Italy          1582-10-04
     AT Austria        1583-10-05      JP Japan          1918-12-18
     AU Australia      1752-09-02      LI Lithuania      1918-02-01
    paul@debian10:~$ head -3 dates.txt | grep -v Italy
     AT Austria        1583-10-05      JP Japan          1918-12-18
     AU Australia      1752-09-02      LI Lithuania      1918-02-01
    paul@debian10:~$

And you can, of course, combine the two options.

    paul@debian10:~$ head -3 dates.txt | grep -iv ITALY
     AT Austria        1583-10-05      JP Japan          1918-12-18
     AU Australia      1752-09-02      LI Lithuania      1918-02-01
    paul@debian10:~$ head -3 dates.txt | grep -v -i italy
     AT Austria        1583-10-05      JP Japan          1918-12-18
     AU Australia      1752-09-02      LI Lithuania      1918-02-01
    paul@debian10:~$

The **grep** command is often used to search for text in **log files**,
and then it can be useful to have some context. You can use the **-A**
option to add lines following the grepped string. The screenshot below
uses **grep** to find **Canada** and the two lines following right
behind the line containing **Canada**.

    paul@debian10:~$ grep -A2 Canada dates.txt
     CA Canada         1752-09-02      LV Latvia         1918-02-01
     CH Switzerland    1655-02-28      NL Netherlands    1582-12-14
     CN China          1911-12-18      NO Norway         1700-02-18
    paul@debian10:~$

Similarly you can **grep** for lines **before** a certain string using
the **-B** option. This screenshot uses **grep** to find **Canada** and
the three lines before the line with **Canada**.

    paul@debian10:~$ grep -B3 Canada dates.txt
     AU Australia      1752-09-02      LI Lithuania      1918-02-01
     BE Belgium        1582-12-14      LN Latin          9999-05-31
     BG Bulgaria       1916-03-18      LU Luxembourg     1582-12-14
     CA Canada         1752-09-02      LV Latvia         1918-02-01
    paul@debian10:~$

You can combine the **-A** and **-B** options, but you can also use
**-C** (which stands for **c**ontext). Using **-C** gives you a number
of lines before and after the searched string.

    paul@debian10:~$ grep -C1 Spain dates.txt
     DK Denmark        1700-02-18      RO Romania        1919-03-31
     ES Spain          1582-10-04      RU Russia         1918-01-31
     FI Finland        1753-02-17      SI Slovenia       1919-03-04
    paul@debian10:~$

We will come back to the **grep** command in the **regular expressions**
chapter.

## cut


The **cut** filter can select columns from a text file. Columns can be
delimited by many different characters, or even by position in the text
file. We use a file called **tennis** which can be downloaded from
linux-training.be ( wget <http://linux-training.be/tennis> ).

In the screenshot below we use the **cut** filter with a comma as
**delimiter** **-d,** to receive the text of each line until the first
comma **-f1** . So the **-d** is short for **delimiter** and the **-f**
is short for **field**.

    paul@debian10:~$ cat tennis
    Venus Williams, USA
    Justine Henin, Bel
    Serena Williams, Usa
    Martina Hingis, SUI
    Kim Clijsters, Bel
    paul@debian10:~$ cat tennis | cut -d, -f1
    Venus Williams
    Justine Henin
    Serena Williams
    Martina Hingis
    Kim Clijsters
    paul@debian10:~$

Using **-f2** we get the field right behind the first comma, as is shown
in this screenshot.

    paul@debian10:~$ cat tennis | cut -d, -f2
     USA
     Bel
     Usa
     SUI
     Bel
    paul@debian10:~$

Instead of the comma as **delimiter** we can also use a space (remember
to escape or quote the space because the shell removes all spaces from
the command line). In the screenshot below we ask for the third field.

    paul@debian10:~$ cat tennis | cut -d" " -f3
    USA
    Bel
    Usa
    SUI
    Bel
    paul@debian10:~$

Using spaces to **cut** the **dates.txt** file is not very useful (try
if you like to get the country names out of it, this fails for United
*space* Kingdom). Luckily we can **cut** by position. In the example
below we cut **byte** (or character) 5 to 19 from the **dates.txt**
file.

    paul@debian10:~$ cat dates.txt | cut -b 5-19 | tail -4
    United Kingdom
    Greece
    Hungary
    Iceland
    paul@debian10:~$

The **tail** filter is here to limit the size of the screenshots, you
don’t need to type it in your terminal window.

We can cut both **country** columns by counting the characters in the
file. See this example, note that we keep **two** spaces between the
country columns.

    paul@debian10:~$ cat dates.txt | cut -b 5-19,38-52 | tail -4
    United Kingdom  Turkey
    Greece          United States
    Hungary         Yugoslavia
    Iceland
    paul@debian10:~$

## paste


The complement of **cut** is **paste**. The **paste** filter can take
separate files (or text streams) and join them together by columns. By
default **paste** will put a **tab** between columns, as can be seen in
this screenshot.

    paul@debian10:~$ cat music.txt | head -2
    Queen
    Abba
    paul@debian10:~$ cat tennis | head -2
    Venus Williams, USA
    Justine Henin, Bel
    paul@debian10:~$ paste music.txt tennis | head -2
    Queen   Venus Williams, USA
    Abba    Justine Henin, Bel
    paul@debian10:~$

The **delimiter** can be adjusted to any ASCII character. In this
example we use the comma.

    paul@debian10:~$ paste -d, music.txt tennis | head -2
    Queen,Venus Williams, USA
    Abba,Justine Henin, Bel
    paul@debian10:~$

## tr


The **tr** filter can **translate** characters. In the example below we
first translate all comma’s to a space, and the second **tr** translates
all spaces to comma’s.

    paul@debian10:~$ cat tennis
    Venus Williams, USA
    Justine Henin, Bel
    Serena Williams, Usa
    Martina Hingis, SUI
    Kim Clijsters, Bel
    paul@debian10:~$ cat tennis | tr ',' ' '
    Venus Williams  USA
    Justine Henin  Bel
    Serena Williams  Usa
    Martina Hingis  SUI
    Kim Clijsters  Bel
    paul@debian10:~$ cat tennis | tr ' ' ,
    Venus,Williams,,USA
    Justine,Henin,,Bel
    Serena,Williams,,Usa
    Martina,Hingis,,SUI
    Kim,Clijsters,,Bel
    paul@debian10:~$

We can define ranges to translate with **tr**, for example to convert
all letters to uppercase as shown in this example.

    paul@debian10:~$ cat tennis | tr 'a-z' 'A-Z'
    VENUS WILLIAMS, USA
    JUSTINE HENIN, BEL
    SERENA WILLIAMS, USA
    MARTINA HINGIS, SUI
    KIM CLIJSTERS, BEL
    paul@debian10:~$

And **tr** can also be used to **squeeze** consecutive characters to one
character. In the example below we make sure that consecutive spaces are
reduced to one space.

    paul@debian10:~$ cat tennis | tr ',' ' ' | tr -s ' '
    Venus Williams USA
    Justine Henin Bel
    Serena Williams Usa
    Martina Hingis SUI
    Kim Clijsters Bel
    paul@debian10:~$

And **tr** can also **delete** characters from a file, as shown here.

    paul@debian10:~$ cat tennis | tr -d ,
    Venus Williams USA
    Justine Henin Bel
    Serena Williams Usa
    Martina Hingis SUI
    Kim Clijsters Bel
    paul@debian10:~$

## wc


The **wc** filter is a simple command that can count the number of
words, lines or characters in a file. We use the **all.txt** and
**error.txt** files from **find / &gt; all.txt 2&gt; error.txt**.

In the first example we count the number of lines in **all.txt**, using
the **-l** option.

    paul@debian10:~$ find / > all.txt 2> error.txt
    paul@debian10:~$ cat all.txt | wc -l
    73573
    paul@debian10:~$

And here we count the number of words in a text stream, using the **-w**
option.

    paul@debian10:~$ cat tennis | tr -d , | wc -w
    15
    paul@debian10:~$

## sort


We can **sort** words according to the alphabet using the **sort**
command. In this example we **sort** each line.

    paul@debian10:~$ cat tennis | sort
    Justine Henin, Bel
    Kim Clijsters, Bel
    Martina Hingis, SUI
    Serena Williams, Usa
    Venus Williams, USA
    paul@debian10:~$

This looks correct, but maybe we want to sort on the second column using
the **-k** option.

    paul@debian10:~$ cat tennis | sort -k2
    Kim Clijsters, Bel
    Justine Henin, Bel
    Martina Hingis, SUI
    Serena Williams, Usa
    Venus Williams, USA
    paul@debian10:~$

Consider the following sort on the numbers column in this **cities**
file.

    paul@debian10:~$ wget http://linux-training.be/cities
    paul@debian10:~$ cat cities
    Brussels, 5000
    Shanghai, 200000
    Antwerp, 40000
    LA, 600000
    Perth, 30000
    paul@debian10:~$ cat cities | sort -k2
    Shanghai, 200000
    Perth, 30000
    Antwerp, 40000
    Brussels, 5000
    LA, 600000
    paul@debian10:~$

Maybe that alphabetical **sort** on numbers is not what we want. So let
us do a **numerical sort** using the **-n** option.

    paul@debian10:~$ cat cities | sort -n -k2
    Brussels, 5000
    Perth, 30000
    Antwerp, 40000
    Shanghai, 200000
    LA, 600000
    paul@debian10:~$

Let us expand the **music.txt** file so we have a double.

    paul@debian10:~$ cat >>music.txt <<stop
    > Abba
    > Led Zeppelin
    > stop
    paul@debian10:~$ cat music.txt
    Queen
    Abba
    Bowie
    Abba
    Led Zeppelin
    paul@debian10:~$

Now we can **sort** it, and then **sort** and output unique **-u**
values.

    paul@debian10:~$ cat music.txt | sort
    Abba
    Abba
    Bowie
    Led Zeppelin
    Queen
    paul@debian10:~$ cat music.txt | sort -u
    Abba
    Bowie
    Led Zeppelin
    Queen
    paul@debian10:~$

## uniq


We can also use the **uniq** command instead of **sort -u**. But
**uniq** only works on a sorted list.

    paul@debian10:~$ cat music.txt | sort | uniq
    Abba
    Bowie
    Led Zeppelin
    Queen
    paul@debian10:~$

And with **uniq** we can also **count** **-c** the number of occurrences
of each name.

    paul@debian10:~$ cat music.txt | sort | uniq -c
          2 Abba
          1 Bowie
          1 Led Zeppelin
          1 Queen
    paul@debian10:~$

## comm

The last command of this chapter is **comm**, it compares two sorted
files (or one file and stdin). In the screenshot below we first **sort**
and **uniq** the music.txt file and then compare it to the sorted
music2.txt file.

The **-** after the **comm** command refers to **stdin** .

    paul@debian10:~$ cat music.txt
    Queen
    Abba
    Bowie
    Abba
    Led Zeppelin
    paul@debian10:~$ cat music2.txt
    Abba
    Bowie
    Led Zeppelin
    Sting
    paul@debian10:~$ cat music.txt | sort | uniq | comm - music2.txt
                    Abba
                    Bowie
                    Led Zeppelin
    Queen
            Sting
    paul@debian10:~$

The result of the **comm** command are three columns; the first column
contains lines unique to **stdin** , the second column are lines unique
to **music2.txt** and the third column are lines that appear in both
columns.

## What about sed?


The **stream editor** **sed** is indeed a commonly used filter on Linux,
we discuss how to use **sed** in the **regular expressions** chapter.

## Cheat sheet

<table>
<caption>Filters</caption>
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
<td style="text-align: left;"><p>cat</p></td>
<td style="text-align: left;"><p>copy <strong>stdin</strong> to
<strong>stdout</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tac</p></td>
<td style="text-align: left;"><p>reverse of <strong>cat</strong>, last
line first</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>tee</p></td>
<td style="text-align: left;"><p>copy <strong>stdin</strong> to a file
and to <strong>stdout</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grep</p></td>
<td style="text-align: left;"><p>filter lines from
<strong>stdin</strong> or a file that contain a string</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>grep</p></td>
<td style="text-align: left;"><p>filter lines that match a regular
expression (see later)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grep -i</p></td>
<td style="text-align: left;"><p>case insensitive filter</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>grep -v</p></td>
<td style="text-align: left;"><p>filter the lines not matching a
string/regex</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grep -A2</p></td>
<td style="text-align: left;"><p>filter the lines and also output the
two next (After) lines</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>grep -B2</p></td>
<td style="text-align: left;"><p>filter the lines and also output the
two previous (Before) lines</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grep -C2</p></td>
<td style="text-align: left;"><p>filter the lines and also output the
two next and previous (Context) lines</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>cut</p></td>
<td style="text-align: left;"><p>select columns from
<strong>stdin</strong> or from a file</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cut -dx -f2</p></td>
<td style="text-align: left;"><p>separate columns by x and display the
second column (field)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>cut -b5-42</p></td>
<td style="text-align: left;"><p>display the fifth till 42nd character
of each line</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>paste</p></td>
<td style="text-align: left;"><p>join lines by column (the reverse of
cut)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>tr</p></td>
<td style="text-align: left;"><p>translate characters</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tr a b</p></td>
<td style="text-align: left;"><p>translate each a to a b (from
<strong>stdin</strong> to <strong>stdout</strong>)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>tr 'a-z' 'A-Z'</p></td>
<td style="text-align: left;"><p>translate text to uppercase</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tr -d x</p></td>
<td style="text-align: left;"><p>remove all occurrences of x</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>wc</p></td>
<td style="text-align: left;"><p>count lines, words or
characters</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sort</p></td>
<td style="text-align: left;"><p>sort by alphabet (or by ASCII
value)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sort -n</p></td>
<td style="text-align: left;"><p>numerical sort</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sort -u</p></td>
<td style="text-align: left;"><p>remove doubles (and triples etc) from a
list</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>uniq</p></td>
<td style="text-align: left;"><p>remove doubles from a sorted
list</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>comm</p></td>
<td style="text-align: left;"><p>compare sorted lists</p></td>
</tr>
</tbody>
</table>

Filters

## Practice

1.  Do a case insensitive **grep** for 'Bel' in the **tennis** file.

2.  Filter the lines containing 'Henin' and the line before and after
    from the **tennis** file.

3.  Filter the surname column from the **tennis** file.

4.  Again filter the surname from the **tennis** file, but remove the
    comma’s.

5.  Filter the dates from the **dates.txt** file and put each date on a
    separate line.

6.  Count the number of files and directories in **/etc** .

7.  Sort the **cities** file and put the result in
    **sorted\_cities.txt**

8.  Knowing that **/usr/share/dict/words** is a dictionary, write a
    simple spell checker on the command line.

## Solution

1.  Do a case insensitive **grep** for 'Bel' in the **tennis** file.

        grep -i Bel tennis

2.  Filter the lines containing 'Henin' and the line before and after
    from the **tennis** file.

        cat tennis | grep -C1 Henin

3.  Filter the surname column from the **tennis** file.

        cut -d\' ' -f2 tennis

4.  Again filter the surname from the **tennis** file, but remove the
    comma’s.

        cat tennis | cut -d\  -f2 | tr -d ,

5.  Filter the dates from the **dates.txt** file and put each date on a
    separate line.

        cat dates.txt | cut -b 20-29,53-63 | tr ' ' '\n'

6.  Count the number of files and directories in **/etc** .

        ls /etc | wc -l

7.  Sort the **cities** file and put the result in
    **sorted\_cities.txt**

        sort cities > sorted_cities.txt

8.  Knowing that **/usr/share/dict/words** is a dictionary, write a
    simple spell checker on the command line.

        echo "The zun is shining today!" > text
        sort /usr/share/dict/words > dict
        cat text | tr -d '!?' | tr 'A-Z' 'a-z' | tr ' ' '\n' | sort | uniq | comm -23 - dict
