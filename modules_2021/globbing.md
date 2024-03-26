# Shell file globbing

## About globbing

File globbing is the use of wildcards to specify a set of filenames.
There are several of these wildcards in use in Linux (or rather in the
bash shell).

All the examples here are shown in the **~/globbing** directory.

## asterisk \*


The first wildcard we will use is the asterisk **\*** . This asterisk
stands for **zero, one or any number of characters**. Note that in the
screenshot below all four files match the pattern.

    paul@debian10:~$ mkdir globbing
    paul@debian10:~$ cd globbing/
    paul@debian10:~/globbing$ touch file file2 fileA fileABC
    paul@debian10:~/globbing$ ls file*
    file  file2  fileA  fileABC
    paul@debian10:~/globbing$

We get of course the same result using **f**\* instead of using
**file**\* .

    paul@debian10:~/globbing$ ls f*
    file  file2  fileA  fileABC
    paul@debian10:~/globbing$

## question mark?


The second wildcard character to show is the question mark **?** . This
question mark represents **exactly one character**. Note that only two
out of four files in the next screenshot match this pattern.

    paul@debian10:~/globbing$ ls file?
    file2  fileA
    paul@debian10:~/globbing$ ls
    file  file2  fileA  fileABC
    paul@debian10:~/globbing$

Here is another example that uses multiple question marks, each one
representing one single character.

    paul@debian10:~/globbing$ touch first
    paul@debian10:~/globbing$ ls
    file  file2  fileA  fileABC  first
    paul@debian10:~/globbing$ ls fi???
    file2  fileA  first
    paul@debian10:~/globbing$

## square brackets \[ \]


You can put a selection of characters between square brackets to
represent an **exactly one character** wildcard. For example \[ab\]
means one character a or one character b. Similarly \[5d\] means exactly
one 5 or exactly one d.

    paul@debian10:~/globbing$ ls
    file  file2  fileA  fileABC  first
    paul@debian10:~/globbing$ ls file[2A]
    file2  fileA
    paul@debian10:~/globbing$ ls file[ace9]
    ls: cannot access file[ace9]: No such file or directory
    paul@debian10:~/globbing$

The order between square brackets is not important.

## square brackets series

You can put series inside the square brackets. For example \[a-z\] means
**exactly one letter between a and z** . Similarly \[0-9\] means
**exactly one number between 0 and 9** .

    paul@debian10:~/globbing$ touch file23
    paul@debian10:~/globbing$ ls
    file  file2  file23  fileA  fileABC  first
    paul@debian10:~/globbing$ ls file[0-9]
    file2
    paul@debian10:~/globbing$ ls file[0-9][0-9]
    file23
    paul@debian10:~/globbing$

## ascii series

You can put any series between brackets that is present in the ASCII
table. So the **space to tilde** **\[ -~\]** series contains every
readable ASCII character. (Remember to escape the space, otherwise the
shell will interpret it as two separate arguments.)

    paul@debian10:~/globbing$ ls
    file  file2  file23  fileA  fileABC  first
    paul@debian10:~/globbing$ ls file[\ -~]
    file2  fileA
    paul@debian10:~/globbing$

## multiple series

You can put multiple series between one pair of square brackets. The
**\[0-9A-Z\]** means exactly one number or uppercase letter.

    paul@debian10:~/globbing$ ls
    file  file2  file23  fileA  fileABC  first
    paul@debian10:~/globbing$ ls file[0-9A-Z]
    file2  fileA
    paul@debian10:~/globbing$

## exclude letters

Using the **exclamation mark** inside the square brackets means the
inverse, so **not** the characters listed. In the example we ask for the
fifth character to **not** be a number.

    paul@debian10:~/globbing$ ls
    file  file2  file23  fileA  fileABC  first
    paul@debian10:~/globbing$ ls file[!0-9]
    fileA
    paul@debian10:~/globbing$

## Cheat sheet

<table>
<caption>file globbing</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>glob</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>*</p></td>
<td style="text-align: left;"><p>zero, one or any number of
characters.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ls f*</p></td>
<td style="text-align: left;"><p>list all files starting with f
(including a file named <strong>f</strong>).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>?</p></td>
<td style="text-align: left;"><p>exactly one character</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ls f?</p></td>
<td style="text-align: left;"><p>list all files that start with f and
have exactly two characters</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ls?????</p></td>
<td style="text-align: left;"><p>list all files with exactly five
characters</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>[abc]</p></td>
<td style="text-align: left;"><p>Exactly one character a, b, or
c.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>[z2a]</p></td>
<td style="text-align: left;"><p>Exactly one character z, 2 or
a.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>[0-9]</p></td>
<td style="text-align: left;"><p>Exactly one digit.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>[a-z][a-z][0-9]</p></td>
<td style="text-align: left;"><p>Exactly two letters and one digit
(three characters in total)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>[!0-9]</p></td>
<td style="text-align: left;"><p>Not a digit.</p></td>
</tr>
</tbody>
</table>

file globbing

## Practice

1.  Create and enter a **~/globbing** directory.

2.  Create the following files: **text text4 textB text.txt** .

3.  List all files starting with **te** .

4.  List all files ending in a number.

5.  List all files of exactly 8 characters.

6.  Create a file named 5test.txt, then list all files not starting with
    a letter.

## Solution

1.  Create and enter a **~/globbing** directory.

        mkdir ~/globbing
        cd ~/globbing

2.  Create the following files: **text text4 textB text.txt** .

        touch text text4 textB text.txt

3.  List all files starting with **te** .

        ls te*

4.  List all files ending in a number.

        ls *[0-9]

5.  List all files of exactly 8 characters.

        ls????????

6.  Create a file named 5test.txt, then list all files not starting with
    a letter.

        ls [!A-Za-z]*
