## cat

When between two `pipes`, the `cat` command does nothing
(except putting `stdin` on `stdout`).

    [paul@RHEL8b pipes]$ tac count.txt | cat | cat | cat | cat | cat
    five
    four
    three
    two
    one
    [paul@RHEL8b pipes]$

## tee

Writing long `pipes` in Unix is fun, but sometimes you may want
intermediate results. This is were `tee` comes in handy.
The `tee` filter puts `stdin` on `stdout`
and also into a file. So `tee` is almost the same as `cat`, except that
it has two identical outputs.

    [paul@RHEL8b pipes]$ tac count.txt | tee temp.txt | tac
    one
    two
    three
    four
    five
    [paul@RHEL8b pipes]$ cat temp.txt 
    five
    four
    three
    two
    one
    [paul@RHEL8b pipes]$

## grep

The `grep` filter is famous among Unix users. The most
common use of `grep` is to filter lines of text containing (or not
containing) a certain string.

    [paul@RHEL8b pipes]$ cat tennis.txt 
    Amelie Mauresmo, Fra
    Kim Clijsters, BEL
    Justine Henin, Bel
    Serena Williams, usa
    Venus Williams, USA
    [paul@RHEL8b pipes]$ cat tennis.txt | grep Williams
    Serena Williams, usa
    Venus Williams, USA

You can write this without the cat.

    [paul@RHEL8b pipes]$ grep Williams tennis.txt 
    Serena Williams, usa
    Venus Williams, USA

One of the most useful options of grep is `grep -i` which
filters in a case insensitive way.

    [paul@RHEL8b pipes]$ grep Bel tennis.txt 
    Justine Henin, Bel
    [paul@RHEL8b pipes]$ grep -i Bel tennis.txt 
    Kim Clijsters, BEL
    Justine Henin, Bel
    [paul@RHEL8b pipes]$

Another very useful option is `grep -v` which outputs
lines not matching the string.

    [paul@RHEL8b pipes]$ grep -v Fra tennis.txt 
    Kim Clijsters, BEL
    Justine Henin, Bel
    Serena Williams, usa
    Venus Williams, USA
    [paul@RHEL8b pipes]$

And of course, both options can be combined to filter all lines not
containing a case insensitive string.

    [paul@RHEL8b pipes]$ grep -vi usa tennis.txt 
    Amelie Mauresmo, Fra
    Kim Clijsters, BEL
    Justine Henin, Bel
    [paul@RHEL8b pipes]$

With `grep -A1` one line `after` the result is also displayed.

    paul@debian10:~/pipes$ grep -A1 Henin tennis.txt 
    Justine Henin, Bel
    Serena Williams, usa

With `grep -B1` one line `before` the result is also displayed.

    paul@debian10:~/pipes$ grep -B1 Henin tennis.txt 
    Kim Clijsters, BEL
    Justine Henin, Bel

With `grep -C1` (context) one line `before` and one `after` are also
displayed. All three options (A,B, and C) can display any number of
lines (using e.g. A2, B4 or C20).

    paul@debian10:~/pipes$ grep -C1 Henin tennis.txt 
    Kim Clijsters, BEL
    Justine Henin, Bel
    Serena Williams, usa

## cut

The `cut` filter can select columns from files, depending
on a delimiter or a count of bytes. The screenshot below uses `cut` to
filter for the username and userid in the `/etc/passwd` file. It uses
the colon as a delimiter, and selects fields 1 and 3.

    [[paul@RHEL8b pipes]$ cut -d: -f1,3 /etc/passwd | tail -4 
    Figo:510
    Pfaff:511
    Harry:516
    Hermione:517
    [paul@RHEL8b pipes]$

When using a space as the delimiter for `cut`, you have to quote the
space.

    [paul@RHEL8b pipes]$ cut -d" " -f1 tennis.txt 
    Amelie
    Kim
    Justine
    Serena
    Venus
    [paul@RHEL8b pipes]$

This example uses `cut` to display the second to the seventh character
of `/etc/passwd`.

    [paul@RHEL8b pipes]$ cut -c2-7 /etc/passwd | tail -4
    igo:x:
    faff:x
    arry:x
    ermion
    [paul@RHEL8b pipes]$

## tr

You can translate characters with `tr`. The screenshot
shows the translation of all occurrences of e to E.

    [paul@RHEL8b pipes]$ cat tennis.txt | tr 'e' 'E'
    AmEliE MaurEsmo, Fra
    Kim ClijstErs, BEL
    JustinE HEnin, BEl
    SErEna Williams, usa
    VEnus Williams, USA

Here we set all letters to uppercase by defining two ranges.

    [paul@RHEL8b pipes]$ cat tennis.txt | tr 'a-z' 'A-Z'
    AMELIE MAURESMO, FRA
    KIM CLIJSTERS, BEL
    JUSTINE HENIN, BEL
    SERENA WILLIAMS, USA
    VENUS WILLIAMS, USA
    [paul@RHEL8b pipes]$

Here we translate all newlines to spaces.

    [paul@RHEL8b pipes]$ cat count.txt 
    one
    two
    three
    four
    five
    [paul@RHEL8b pipes]$ cat count.txt | tr '\n' ' '
    one two three four five [paul@RHEL8b pipes]$

The `tr -s` filter can also be used to squeeze multiple occurrences of a
character to one.

    [paul@RHEL8b pipes]$ cat spaces.txt 
    one    two        three
         four   five  six
    [paul@RHEL8b pipes]$ cat spaces.txt | tr -s ' '
    one two three
     four five six
    [paul@RHEL8b pipes]$

You can also use `tr` to \'encrypt\' texts with `rot13`.

    [paul@RHEL8b pipes]$ cat count.txt | tr 'a-z' 'nopqrstuvwxyzabcdefghijklm'
    bar
    gjb
    guerr
    sbhe
    svir
    [paul@RHEL8b pipes]$ cat count.txt | tr 'a-z' 'n-za-m'
    bar
    gjb
    guerr
    sbhe
    svir
    [paul@RHEL8b pipes]$

This last example uses `tr -d` to delete characters.

    paul@debian10:~/pipes$ cat tennis.txt | tr -d e
    Amli Maursmo, Fra
    Kim Clijstrs, BEL
    Justin Hnin, Bl
    Srna Williams, usa
    Vnus Williams, USA

## wc

Counting words, lines and characters is easy with `wc`.

    [paul@RHEL8b pipes]$ wc tennis.txt 
      5  15 100 tennis.txt
    [paul@RHEL8b pipes]$ wc -l tennis.txt 
    5 tennis.txt
    [paul@RHEL8b pipes]$ wc -w tennis.txt 
    15 tennis.txt
    [paul@RHEL8b pipes]$ wc -c tennis.txt 
    100 tennis.txt
    [paul@RHEL8b pipes]$

## sort

The `sort` filter will default to an alphabetical sort.

    paul@debian10:~/pipes$ cat music.txt 
    Queen
    Brel
    Led Zeppelin
    Abba
    paul@debian10:~/pipes$ sort music.txt 
    Abba
    Brel
    Led Zeppelin
    Queen

But the `sort` filter has many options to tweak its usage. This example
shows sorting different columns (column 1 or column 2).

    [paul@RHEL8b pipes]$ sort -k1 country.txt 
    Belgium, Brussels, 10
    France, Paris, 60
    Germany, Berlin, 100
    Iran, Teheran, 70
    Italy, Rome, 50
    [paul@RHEL8b pipes]$ sort -k2 country.txt 
    Germany, Berlin, 100
    Belgium, Brussels, 10
    France, Paris, 60
    Italy, Rome, 50
    Iran, Teheran, 70

The screenshot below shows the difference between an alphabetical sort
and a numerical sort (both on the third column).

    [paul@RHEL8b pipes]$ sort -k3 country.txt 
    Belgium, Brussels, 10
    Germany, Berlin, 100
    Italy, Rome, 50
    France, Paris, 60
    Iran, Teheran, 70
    [paul@RHEL8b pipes]$ sort -n -k3 country.txt 
    Belgium, Brussels, 10
    Italy, Rome, 50
    France, Paris, 60
    Iran, Teheran, 70
    Germany, Berlin, 100

## uniq

With `uniq` you can remove duplicates from a
`sorted list`.

    paul@debian10:~/pipes$ cat music.txt 
    Queen
    Brel
    Queen
    Abba
    paul@debian10:~/pipes$ sort music.txt 
    Abba
    Brel
    Queen
    Queen
    paul@debian10:~/pipes$ sort music.txt |uniq
    Abba
    Brel
    Queen

`uniq` can also count occurrences with the `-c` option.

    paul@debian10:~/pipes$ sort music.txt |uniq -c
          1 Abba
          1 Brel
          2 Queen

## comm

Comparing streams (or files) can be done with the `comm`.
By default `comm` will output three columns. In this example, Abba, Cure
and Queen are in both lists, Bowie and Sweet are only in the first file,
Turner is only in the second.

    paul@debian10:~/pipes$ cat > list1.txt
    Abba
    Bowie
    Cure
    Queen
    Sweet
    paul@debian10:~/pipes$ cat > list2.txt
    Abba
    Cure
    Queen
    Turner
    paul@debian10:~/pipes$ comm list1.txt list2.txt 
                    Abba
    Bowie
                    Cure
                    Queen
    Sweet
            Turner

The output of `comm` can be easier to read when outputting only a single
column. The digits point out which output columns should not be
displayed.

    paul@debian10:~/pipes$ comm -12 list1.txt list2.txt 
    Abba
    Cure
    Queen
    paul@debian10:~/pipes$ comm -13 list1.txt list2.txt 
    Turner
    paul@debian10:~/pipes$ comm -23 list1.txt list2.txt 
    Bowie
    Sweet

## od

European humans like to work with ascii characters, but computers store
files in bytes. The example below creates a simple file, and then uses
`od` to show the contents of the file in hexadecimal bytes

    paul@laika:~/test$ cat > text.txt
    abcdefg
    1234567
    paul@laika:~/test$ od -t x1 text.txt 
    0000000 61 62 63 64 65 66 67 0a 31 32 33 34 35 36 37 0a
    0000020

The same file can also be displayed in octal bytes.

    paul@laika:~/test$ od -b text.txt 
    0000000 141 142 143 144 145 146 147 012 061 062 063 064 065 066 067 012
    0000020

And here is the file in ascii (or backslashed) characters.

    paul@laika:~/test$ od -c text.txt 
    0000000   a   b   c   d   e   f   g  \n   1   2   3   4   5   6   7  \n
    0000020

## sed

The `s`tream `ed`itor `sed` can perform editing functions
in the stream, using `regular expressions`.

    paul@debian10:~/pipes$ echo level5 | sed 's/5/42/'
    level42
    paul@debian10:~/pipes$ echo level5 | sed 's/level/jump/'
    jump5
            

Add `g` for global replacements (all occurrences of the string per
line).

    paul@debian10:~/pipes$ echo level5 level7 | sed 's/level/jump/'
    jump5 level7
    paul@debian10:~/pipes$ echo level5 level7 | sed 's/level/jump/g'
    jump5 jump7
            

With `d` you can remove lines from a stream containing a character.

    paul@debian10:~/test42$ cat tennis.txt 
    Venus Williams, USA
    Martina Hingis, SUI
    Justine Henin, BE
    Serena williams, USA
    Kim Clijsters, BE
    Yanina Wickmayer, BE
    paul@debian10:~/test42$ cat tennis.txt | sed '/BE/d'
    Venus Williams, USA
    Martina Hingis, SUI
    Serena williams, USA

## pipe examples

### who \| wc

How many users are logged  on to this system ?

    [paul@RHEL8b pipes]$ who
    root     tty1         Jul 25 10:50
    paul     pts/0        Jul 25 09:29 (laika)
    Harry    pts/1        Jul 25 12:26 (barry)
    paul     pts/2        Jul 25 12:26 (pasha)
    [paul@RHEL8b pipes]$ who | wc -l
    4

### who \| cut \| sort

Display a sorted  list of logged on users.

    [paul@RHEL8b pipes]$ who | cut -d' ' -f1 | sort
    Harry
    paul
    paul
    root

Display a sorted list of logged on users, but every user
only once .

    [paul@RHEL8b pipes]$ who | cut -d' ' -f1 | sort | uniq
    Harry
    paul
    root

### grep \| cut

Display a list of all bash `user accounts` on this
computer. Users accounts are explained in detail later.

    paul@debian10:~$ grep bash /etc/passwd
    root:x:0:0:root:/root:/bin/bash
    paul:x:1000:1000:paul,,,:/home/paul:/bin/bash
    serena:x:1001:1001::/home/serena:/bin/bash
    paul@debian10:~$ grep bash /etc/passwd | cut -d: -f1
    root
    paul
    serena
