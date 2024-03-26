# Regular expressions

## What are regular expressions?


A regular expression is a string of characters defining a search
pattern. A lot of info can be found on the Wikipedia page
<https://en.wikipedia.org/wiki/Regular_expression> . In this chapter we
discuss commands that use regular expressions and learn by example.

Regular expressions sometimes use special characters like a **$** or a
**\*** or a **?**. To prevent the shell from interpreting these
characters we will enclose the regular expression in single quotes when
necessary. To play safe, you may choose to always enclose a **regex** in
single quotes.

## grep


We have already discussed **grep** in the previous chapters. This time
we will take it a step further by providing examples of **grep** with
regular expressions.

### ^ starts with

When using regular expressions the **^** sign means **starts with**. In
the screenshot below we **grep** for all lines starting with an
uppercase letter **K**.

    paul@debian10:~$ cat tennis
    Venus Williams, USA
    Justine Henin, Bel
    Serena Williams, Usa
    Martina Hingis, SUI
    Kim Clijsters, Bel
    paul@debian10:~$ cat tennis | grep ^K
    Kim Clijsters, Bel
    paul@debian10:~$

### $ ends with

The dollar sign can be used to search for lines that **end with** a
string of letters. Here we ask for all lines ending with **sa**.

    paul@debian10:~$ cat tennis | grep sa$
    Serena Williams, Usa

Remember that **grep** has the **-i** option for a case insensitive
search? Well this can still be used, as seen in this example.

    paul@debian10:~$ cat tennis | grep -i sa$
    Venus Williams, USA
    Serena Williams, Usa
    paul@debian10:~$

### ^ $ Match the whole line

When you want to **grep** for a whole line, then you can start your
regex with the **^** and end it with the **$**. Remember to escape the
spaces!

    paul@debian10:~$ cat tennis | grep ^Justine\ Henin,\ Bel$
    Justine Henin, Bel
    paul@debian10:~$

### . single character

The dot **.** matches any single character. This includes punctuation
characters. In the example below we need to match the exact number of
characters between **Ve** and **sa**.

    paul@debian10:~$ cat tennis | grep -i ^Ve...............sa$
    Venus Williams, USA

One dot less, and there is no match.

    paul@debian10:~$ cat tennis | grep -i ^Ve..............sa$
    paul@debian10:~$

One dot too many, and again there is no match.

    paul@debian10:~$ cat tennis | grep -i ^Ve................sa$
    paul@debian10:~$

### \* zero, one, or more

In the example below we put a **\*** behind the **.** meaning the
previous (this is the .) any number of times. So we read this **regex**
as **starts with Ve, then any number of characters, then ends with sa**.

    paul@debian10:~$ cat tennis | grep -i ^Ve.*sa$
    Venus Williams, USA
    paul@debian10:~$

### \[ \] single character

Just like with **file globbing** the **\[ \]** notation denotes a single
character, with the list of characters between the square brackets. In
the example below we ask for exactly three characters at the end, the
last character being uppercase A or lowercase a.

    paul@debian10:~$ cat tennis | grep U[sS][Aa]$
    Venus Williams, USA
    Serena Williams, Usa
    paul@debian10:~$

### \[^ \] not

Remember that the **^** meant **at the start of the line**, well
enclosed in square brackets the **^** means **not this list**. In the
example below we ask for no uppercase A or I at the end of the line.

    paul@debian10:~$ cat tennis | grep [^AI]$
    Justine Henin, Bel
    Serena Williams, Usa
    Kim Clijsters, Bel
    paul@debian10:~$

Here is another example of the **not ^** in combination with the **at
the start of ^** . The following **regex** can be read as **at the start
of the line, not an A or a** as first character and **not an A or e** as
the second character.

    paul@debian10:~$ cat cities
    Brussels, 5000
    Shanghai, 200000
    Antwerp, 40000
    LA, 600000
    Perth, 30000
    paul@debian10:~$ cat cities | grep ^[Aa][Ae]
    Brussels, 5000
    Shanghai, 200000
    paul@debian10:~$

### \[a-z\] \[0-9\] series

Just like with **file globbing** we can put series inside the square
brackets. In the example below we ask for no uppercase letter at the end
of the line.

    paul@debian10:~$ cat tennis | grep [^A-Z]$
    Justine Henin, Bel
    Serena Williams, Usa
    Kim Clijsters, Bel
    paul@debian10:~$

## rename


This section is about the **rename** command on Debian and derivatives
like Ubuntu, Mint and Raspbian. The **rename** command on RHEL and
CentOS is a completely different story.

The **rename** command in Debian 10 is not installed by default, the
**root** user can install it with **apt-get install rename**. The
**rename** command is installed as a symbolic link to a symbolic link to
a **Perl script**.

    paul@debian10:~$ file $(readlink -f $(which rename))
    /usr/bin/file-rename: Perl script text executable
    paul@debian10:~$

Links and **readlink -f** will be explained in the Links chapter.

In this section we will use a **renamedir** in our home directory
containing the following files.

    paul@debian10:~$ mkdir renamedir
    paul@debian10:~$ cp error.txt music*.txt dates.txt renamedir/
    paul@debian10:~$ cd renamedir/
    paul@debian10:~/renamedir$ ls
    dates.txt  error.txt  music2.txt  music.txt
    paul@debian10:~/renamedir$

### replace string

The **rename** command is often used to replace a string of characters
in file names to another string. For example this screenshot where we
replace **music** with **artist** for all files matching the **\*.txt**
glob.

    paul@debian10:~/renamedir$ rename 's/music/artist/' *.txt
    paul@debian10:~/renamedir$ ls
    artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$

Remember the **bash shell** is expanding this glob, **rename** receives
all the .txt files and verifies for each one whether it can do the
**artist-to-music** switch.

    paul@debian10:~/renamedir$ ls
    dates.txt  error.txt  music2.txt  music.txt
    paul@debian10:~/renamedir$ set -x
    paul@debian10:~/renamedir$ rename 's/music/artist/' *.txt
    + rename s/music/artist/ dates.txt error.txt music2.txt music.txt
    paul@debian10:~/renamedir$ set +x
    + set +x
    paul@debian10:~/renamedir$ ls
    artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$

### Renaming file 'extensions'

File extensions have no meaning for the **bash** shell, but can be
informative to end users. In this section we explain how to **rename**
file extensions.

At first this seems simple, in the example below we change all **.txt**
files to **.TXT**.

    paul@debian10:~/renamedir$ ls
    artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$ rename 's/txt/TXT/' *.txt
    paul@debian10:~/renamedir$ ls
    artist2.TXT  artist.TXT  dates.TXT  error.TXT
    paul@debian10:~/renamedir$

Except that the above example is wrong. Can you find the mistake?

The mistake becomes clear when we add the alltxt.txt file, as shown in
the following screenshot.

    paul@debian10:~/renamedir$ ls
    artist2.TXT  artist.TXT  dates.TXT  error.TXT
    paul@debian10:~/renamedir$ touch alltxt.txt
    paul@debian10:~/renamedir$ rename 's/txt/TXT/' *.txt
    paul@debian10:~/renamedir$ ls
    allTXT.txt  artist2.TXT  artist.TXT  dates.TXT  error.TXT
    paul@debian10:~/renamedir$

To rename extensions we will have to look at replacing strings **at the
end** of a filename. For this we can use the **dollar sign $** as can be
seen in this screenshot.

    paul@debian10:~/renamedir$ rename 's/TXT/txt/' * 
    paul@debian10:~/renamedir$ ls
    alltxt.txt  artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$ rename 's/txt$/TXT/' *.txt
    paul@debian10:~/renamedir$ ls
    alltxt.TXT  artist2.TXT  artist.TXT  dates.TXT  error.TXT
    paul@debian10:~/renamedir$

### global rename

The **s/string/replace/** will only replace the first occurrence of
**string** in **replace**, as can be seen in this example. Note the
second **rename** command and the resulting **allTXT.txt** file.

    paul@debian10:~/renamedir$ rename 's/TXT$/txt/' * 
    paul@debian10:~/renamedir$ ls
    alltxt.txt  artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$ rename 's/txt/TXT/' * 
    paul@debian10:~/renamedir$ ls
    allTXT.txt  artist2.TXT  artist.TXT  dates.TXT  error.TXT
    paul@debian10:~/renamedir$

You can use **rename** to **globally** replace all occurrences of the
**string** using the **/g** at the end of the regex.

    paul@debian10:~/renamedir$ ls
    alltxt.txt  artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$ rename 's/txt/TXT/g' * 
    paul@debian10:~/renamedir$ ls
    allTXT.TXT  artist2.TXT  artist.TXT  dates.TXT  error.TXT
    paul@debian10:~/renamedir$

### case insensitive replace

You can have **rename** ignore the case of the searched **string** by
adding a **/i** at the end of the regex. (This can be in combination
with /g and then becomes /gi).

In the screenshot below we **rename** all the .txt .TXT .Txt and
variations to **.text**.

    paul@debian10:~/renamedir$ ls
    allTXT.TXT  artist2.TXT  artist.TXT  dates.TXT  error.TXT
    paul@debian10:~/renamedir$ mv artist.TXT artist.txt
    paul@debian10:~/renamedir$ rename 's/txt$/text/i' * 
    paul@debian10:~/renamedir$ ls
    allTXT.text  artist2.text  artist.text  dates.text  error.text
    paul@debian10:~/renamedir$

### a dry run

You can test a rename command before executing it by performing a dry
run using the **-n** option. It will then display the names instead of
renaming files.

    paul@debian10:~/renamedir$ ls
    allTXT.txt  artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$ rename -n 's/txt$/TXT/' * 
    rename(allTXT.txt, allTXT.TXT)
    rename(artist2.txt, artist2.TXT)
    rename(artist.txt, artist.TXT)
    rename(dates.txt, dates.TXT)
    rename(error.txt, error.TXT)
    paul@debian10:~/renamedir$

### removing extensions

Until now, we have been ignoring the **.** part of a file 'extension'.
We cannot simply use a **.** in the expression since that means **any
character**. Luckily we can escape the **.** and thus make it a literal
**.** , as seen in the example below where we remove **.txt** from all
files.

    paul@debian10:~/renamedir$ mv allTXT.txt alltxt
    paul@debian10:~/renamedir$ ls
    alltxt  artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$ rename 's/\.txt$//' * 
    paul@debian10:~/renamedir$ ls
    alltxt  artist  artist2  dates  error
    paul@debian10:~/renamedir$

### adding extensions

Files without an extension can have one added **at the end**
(represented by a $ sign). See this screenshot for an example on how to
do this.

    paul@debian10:~/renamedir$ ls
    alltxt  artist  artist2  dates  error
    paul@debian10:~/renamedir$ rename 's/$/.txt/' * 
    paul@debian10:~/renamedir$ ls
    alltxt.txt  artist2.txt  artist.txt  dates.txt  error.txt
    paul@debian10:~/renamedir$

## sed


The **sed** command is a **stream editor**, it is created to edit a
stream of text. This first screenshot will look familiar (if you just
studied **rename**).

    paul@debian10:~$ echo Sunday | sed 's/Sun/Mon/'
    Monday
    paul@debian10:~$

The forward slashes in the above example can be replaced by colons,
underscores, vertical bars or commas to improve readability of the
**regex**.

    paul@debian10:~$ echo Sunday | sed 's:Sun:Mon:'
    Monday
    paul@debian10:~$ echo Sunday | sed 's|Sun|Mon|'
    Monday
    paul@debian10:~$ echo Sunday | sed 's_Sun_Mon_'
    Monday
    paul@debian10:~$ echo Sunday | sed 's,Sun,Mon,'
    Monday
    paul@debian10:~$

The **search** and **replace** strings do not need to be the same
length.

    paul@debian10:~$ cat tennis | sed 's/ SUI/ Switzerland/'
    Venus Williams, USA
    Justine Henin, Bel
    Serena Williams, Usa
    Martina Hingis, Switzerland
    Kim Clijsters, Bel
    paul@debian10:~$

### interactive sed

While **sed** was designed as a stream editor, it can be used
**in-place** using the **-i** option, as seen in this screenshot.

    paul@debian10:~$ echo Sunday > today
    paul@debian10:~$ cat today
    Sunday
    paul@debian10:~$ sed -i 's/Sun/Mon/' today
    paul@debian10:~$ cat today
    Monday
    paul@debian10:~$

### global /g

You may want **sed** to replace the **regex** in the whole stream
(instead of just the first occurrence of each line). To do this, apply
the **/g** option.

    paul@debian10:~$ cat tennis | sed 's/i/XX/g'
    Venus WXXllXXams, USA
    JustXXne HenXXn, Bel
    Serena WXXllXXams, Usa
    MartXXna HXXngXXs, SUI
    KXXm ClXXjsters, Bel
    paul@debian10:~$

### case insensitive /i

For a **case insensitive** replace, use the **/i** option (here together
with **/g** ).

    paul@debian10:~$ cat tennis | sed 's/ USA/ United States/gi'
    Venus Williams, United States
    Justine Henin, Bel
    Serena Williams, United States
    Martina Hingis, SUI
    Kim Clijsters, Bel
    paul@debian10:~$

### remove white space

A common use of **sed** is to remove spaces, in this screenshot at the
beginning of every line. Remember to escape the space character. Read
the **regex** as **beginning of the line**, **space**, **any number of
times**, and replace with nothing.

    paul@debian10:~$ cat > white
         There are spaces before this line.
       And also before this one.
    paul@debian10:~$ cat white
         There are spaces before this line.
       And also before this one.
    paul@debian10:~$ cat white | sed 's/^\ *//'
    There are spaces before this line.
    And also before this one.
    paul@debian10:~$

Instead of using **\\** to denote spaces, you can also use **\s** which
includes spaces and tabs.

### \\ \\ marked subexpressions

You can add escaped **parentheses** around part of your regex to mark it
as a **block**. Using the **\n** notation you can refer to these
**blocks** (using the numbers 1 to 9 in order). For example in this
screenshot we mark **Sun** and recall it thrice with the **\1**
notation.

    paul@debian10:~$ echo Sunday | sed 's/\(Sun\)/\1\1\1/' 
    SunSunSunday
    paul@debian10:~$

Remember the **dates.txt** file and the **cut** filter to get the
countries from that file? We left two spaces between the countries, for
a reason.

    paul@debian10:~$ cat dates.txt | cut -b 5-19,38-52 | tail -5 
    France          Sweden
    United Kingdom  Turkey
    Greece          United States
    Hungary         Yugoslavia
    Iceland
    paul@debian10:~$

Well we can use these two consecutive spaces followed by an uppercase
letter and replace them with a comma (followed by that same uppercase
letter). To do this we mark the search for that uppercase letter with
**escaped parentheses** so we can refer to those letters with **\1**
(and put them back right after the commas).

    paul@debian10:~$ cat dates.txt | cut -b 5-19,38-52 | sed s/\ \ \([A-Z]\)/,\1/ | head -5
    Albania       ,Italy
    Austria       ,Japan
    Australia     ,Lithuania
    Belgium       ,Latin
    Bulgaria      ,Luxembourg
    paul@debian10:~$

In this screenshot we do the same thing, except that we put **newlines**
instead of **commas**. So we get a country on each line.

    paul@debian10:~$ cat dates.txt | cut -b 5-19,38-52 | sed s/\ \ \([A-Z]\)/\n\1/ | head -5
    Albania
    Italy
    Austria
    Japan
    Australia
    paul@debian10:~$

Here is the country list sorted. And we also removed the *useless use*
of **cat** though some people find it easier to read with the **cat**
command included.

    paul@debian10:~$ cut -b 5-19,38-52 dates.txt | sed s/\ \ \([A-Z]\)/\n\1/ | sort | head -5
    Albania
    Australia
    Austria
    Belgium
    Bulgaria
    paul@debian10:~$

### multiple back referencing

In this example we convert an American date format (MM-DD-YYYY) to an
international date format which is YYYY-MM-DD.

    paul@debian10:~$ echo 12-31-2019 | sed s/\(..\)-\(..\)-\(....\)/\3-\1-\2/
    2019-12-31
    paul@debian10:~$

## bash history

The **bash shell** can also interpret regular expressions. In the
screenshot below we use a **s/search/replace** on the previous command.

    paul@debian10:~$ touch file1
    paul@debian10:~$ !t:s/1/42/
    touch file42
    paul@debian10:~$ ls file* 
    file1  file42
    paul@debian10:~$

This also works when repeating a command via its history number.

    paul@debian10:~$ history 5 
     1265  ls file*
     1266  touch file1
     1267  touch file42
     1268  ls file*
     1269  history 5
    paul@debian10:~$ !1267:s/42/33/
    touch file33
    paul@debian10:~$ ls file* 
    file1  file33  file42
    paul@debian10:~$

NOTE There are several other tools on Linux that use regular
expressions, like **vi**, **awk** and **more** for example.

## Cheat sheet

<table>
<caption>Regular expressions</caption>
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
<td style="text-align: left;"><p>grep ^foo</p></td>
<td style="text-align: left;"><p>grep for lines that start with
<strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grep foo$</p></td>
<td style="text-align: left;"><p>grep for lines that end with
<strong>foo</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>grep ^foo$</p></td>
<td style="text-align: left;"><p>grep for lines that contain just and
exactly <strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grep ^.$</p></td>
<td style="text-align: left;"><p>grep for lines containing a single
character</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>grep ^…$</p></td>
<td style="text-align: left;"><p>grep for lines containing exactly three
characters</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grep ^A.*</p></td>
<td style="text-align: left;"><p>grep for lines starting with A, then
zero one or more characters</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>grep [a2e]$</p></td>
<td style="text-align: left;"><p>grep for lines ending with a single
character, namely a or 2 or e</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>grep [^x7]$</p></td>
<td style="text-align: left;"><p>grep for lines ending with a single
character, but not x or 7</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>grep [^A-Z]$</p></td>
<td style="text-align: left;"><p>not an uppercase letter at the end of
the line</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>rename 's/foo/bar/' *</p></td>
<td style="text-align: left;"><p>Rename all files(*) replacing the first
occurrence of <strong>foo</strong> with <strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rename 's/foo/bar/i' *</p></td>
<td style="text-align: left;"><p>Rename all files(*) replacing the first
occurrence of case insensitive <strong>foo</strong> with
<strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>rename 's/foo/bar/g' *</p></td>
<td style="text-align: left;"><p>Rename all files(*) replacing all
occurrences of <strong>foo</strong> with <strong>bar</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rename 's/foo$/bar/' *</p></td>
<td style="text-align: left;"><p>Rename all files replacing
<strong>foo</strong> at the end of the filename with
<strong>bar</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>rename 's/$/.foo/' *</p></td>
<td style="text-align: left;"><p>Rename all files adding
<strong>.foo</strong> as an extension.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rename 's/\.foo//' *</p></td>
<td style="text-align: left;"><p>Rename all files removing
<strong>.foo</strong> as an extension.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>rename -n</p></td>
<td style="text-align: left;"><p>a dry run, just show what would be
done</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sed 's/foo/bar/'</p></td>
<td style="text-align: left;"><p>replace first occurrence of
<strong>foo</strong> with <strong>bar</strong> on each line</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sed 's:foo:bar:'</p></td>
<td style="text-align: left;"><p>replace first occurrence of
<strong>foo</strong> with <strong>bar</strong> on each line</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sed 's_foo_bar_'</p></td>
<td style="text-align: left;"><p>replace first occurrence of
<strong>foo</strong> with <strong>bar</strong> on each line</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sed 's,foo,bar,'</p></td>
<td style="text-align: left;"><p>replace first occurrence of
<strong>foo</strong> with <strong>bar</strong> on each line</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sed 's/foo/bar/g'</p></td>
<td style="text-align: left;"><p>replace all occurrences of
<strong>foo</strong> with <strong>bar</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sed 's/foo/bar/gi'</p></td>
<td style="text-align: left;"><p>replace all occurrences of case
insensitive <strong>foo</strong> with <strong>bar</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sed 's/^\ *//'</p></td>
<td style="text-align: left;"><p>remove all white space at the start of
each line</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sed 's/\(foo\)/\1\1\1/'</p></td>
<td style="text-align: left;"><p>mark <strong>foo</strong> as
subexpression 1, repeat it three times</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sed 's/\(foo\)\(bar\)/\2\1'</p></td>
<td style="text-align: left;"><p>mark <strong>foo</strong> as
subexpression 1, <strong>bar</strong> as subexpression 2, then reverse
the two</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sed -i regex foo</p></td>
<td style="text-align: left;"><p>change the file <strong>foo</strong>
(instead of writing to <strong>stdout</strong>)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>!foo:s/33/42/</p></td>
<td style="text-align: left;"><p>repeat the last command that starts
with <strong>foo</strong> replacing 33 with 42</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!42:s/foo/bar/</p></td>
<td style="text-align: left;"><p>repeat command number 42, replacing
<strong>foo</strong> with <strong>bar</strong></p></td>
</tr>
</tbody>
</table>

Regular expressions

## Practice

1.  List all lines of the **tennis** file that start with **Ma** .

2.  List all lines of the **tennis** file that end with **UI** .

3.  List all lines of the **tennis** file starting with **Se**, then any
    characters, then ending with **SA** .

4.  List all lines of the **tennis** file **not** ending in **a** or
    **A**.

5.  Rename all files ending in **.txt** to **.TXT** .

6.  Use **sed** in a stream to change all vowels in the tennis file to X
    (output on the terminal).

## Solution

1.  List all lines of the **tennis** file that start with **Ma** .

        grep ^Ma tennis

2.  List all lines of the **tennis** file that end with **UI** .

        grep 'UI$' tennis

3.  List all lines of the **tennis** file starting with **Se**, then any
    characters, then ending with **SA** .

        cat tennis | grep '^Se.*SA$'

4.  List all lines of the **tennis** file **not** ending in **a** or
    **A**.

        cat tennis | grep '[^aA]$'

5.  Rename all files ending in **.txt** to **.TXT** .

        rename 's/\.txt$/\.TXT/' *.txt

6.  Use **sed** in a stream to change all vowels in the tennis file to X
    (output on the terminal).

        cat tennis | sed 's/[aeiou]/X/g'
