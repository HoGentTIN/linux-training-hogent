## filters and pipes

Typical patterns for using filters are:

- `command file` reads input from a file, specified as an argument.
- `command < file` same, but if the command does not accept a file as argument, you can use input redirection.
- `command1 | command2` uses a *pipe* to send the output of `command1` to `command2`.

Sometimes, in a pipeline, unnecessary commands are used. For example:

- `cat file | command` can always be replaced by `command < file` or `command file` if the command accepts a file as argument.
- `echo "string" | command` can always be replaced by `command <<< "string"` (a here string).

This may seem trivial, but it can make a difference in performance and memory usage. The `cat` and `echo` commands must be loaded into memory and use system resources, while the input redirection and here string are handled by the shell itself.

## cat

Cat is short for *concatenate*. When between two *pipes*, the `cat` command does nothing except repeating `stdin` on `stdout`. The command can also take input from a file.

```console
student@linux:~$ cat count.txt
one
two
three
four
five
student@linux:~$ cat count.txt | cat | cat | cat | cat | cat
one
two
three
four
five
```

In scripts, `cat` is used to print out multiple lines (instead of using `echo` multiple times) using a here document.

```bash
#!/bin/bash
cat << _EOF_
one
two
three
four
five
_EOF_
```

## tac

The `tac` command is the reverse of `cat`. It prints the lines of a file in reverse order.

```console
student@linux:~$ tac count.txt
five
four
three
two
one
```

## shuf

The `shuf` command is used to randomly shuffle the lines of a file.

```console
student@linux:~$ shuf count.txt
four
one
three
five
two
```

## tee

Writing long *pipes* in Unix is fun, but sometimes you may want intermediate results. Or, you may want to see the standard output of a command and also save it to a file. This is were `tee` comes in handy.

The `tee` filter puts `stdin` on `stdout` and also into a file (specified as an argument). So `tee` is almost the same as `cat`, except that it has two identical outputs.

```console
[student@linux pipes]$ ls
[student@linux pipes]$ cal | tee month.txt
    October 2024    
Su Mo Tu We Th Fr Sa
       1  2  3  4  5
 6  7  8  9 10 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29 30 31      

[student@linux pipes]$ ls
month.txt
[student@linux pipes]$ cat month.txt 
    October 2024    
Su Mo Tu We Th Fr Sa
       1  2  3  4  5
 6  7  8  9 10 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29 30 31      
```

## head and tail

The `head` and `tail` commands are used to display the first and last lines of a file, respectively. By default, they displays 10 lines, unless you specify another amount.

```console
[student@linux pipes]$ head -3 count.txt 
one
two
three
[student@linux pipes]$ tail -3 count.txt 
three
four
five
```

With `tail -n+NUM` you can start at line `NUM`.

```console
[student@linux pipes]$ tail -n+3 count.txt 
three
four
five
```

With `head -n-NUM` you can stop at line `NUM`.

```console
[student@linux pipes]$ head -n-3 count.txt 
one
two
```

The `tail` command has an option `-f` to follow a file. That is, the command will display the last lines of the specified file, and then wait for new lines to be added to the file. This is useful for monitoring log files.

```console
[student@linux ~]$ sudo tail -f /var/log/httpd/access_log
```

## cut

The `cut` filter can select columns from files, depending on a delimiter or a count of bytes. The screenshot below uses `cut` to filter for the username and userid in the `/etc/passwd` file. It uses the colon as a delimiter, and selects fields 1 and 3.

```console
[student@linux pipes]$ cut -d: -f1,3 /etc/passwd | tail -4 
Figo:510
Pfaff:511
Harry:516
Hermione:517
```

When using a space as the delimiter for `cut`, you have to quote the space.

```console
[student@linux pipes]$ cut -d' ' -f1 tennis.txt 
Amelie
Kim
Justine
Serena
Venus
```

This example uses `cut` to display the second to the seventh character of `/etc/passwd`.

```console
[student@linux pipes]$ cut -c2-7 /etc/passwd | tail -4
igo:x:
faff:x
arry:x
ermion
```

## paste

The `paste` command will combine two files line by line. By default, it merges the first line of the first file with the first line of the second file, and so on. The screenshot below shows the result of merging two files.

```console
student@linux:~/pipes$ cat count.txt 
one
two
three
four
five
student@linux:~/pipes$ cat country.txt 
France,Paris,60
Italy,Rome,50
Belgium,Brussels,10
Iran,Teheran,70
Germany,Berlin,100
student@linux:~/pipes$ paste -d',' count.txt country.txt 
one,France,Paris,60
two,Italy,Rome,50
three,Belgium,Brussels,10
four,Iran,Teheran,70
five,Germany,Berlin,100
```

Option `-d` specifies a character to separate the columns. The default value is a tab character.

## join

The `join` command is used to join two files on a common field. The common field in both files should be in the same order.

```console
student@linux:~/pipes$ cat country-code.txt 
Belgium,be
France,fr
Germany,de
Iran,ir
Italy,it
student@linux:~/pipes$ cat country-sorted.txt 
Belgium,Brussels,10
France,Paris,60
Germany,Berlin,100
Iran,Teheran,70
Italy,Rome,50
student@linux:~/pipes$ join -t, country-code.txt country-sorted.txt 
Belgium,be,Brussels,10
France,fr,Paris,60
Germany,de,Berlin,100
Iran,ir,Teheran,70
Italy,it,Rome,50
```

Option `-t` specifies the delimiter character.

## sort

The `sort` filter will default to an alphabetical sort.

```console
student@linux:~/pipes$ cat music.txt 
Queen
Brel
Led Zeppelin
Abba
student@linux:~/pipes$ sort music.txt 
Abba
Brel
Led Zeppelin
Queen
```

But the `sort` filter has many options to tweak its usage. This example shows sorting different columns (column 1 or column 2).

```console
[student@linux pipes]$ sort -k1 country.txt 
Belgium,Brussels,10
France,Paris,60
Germany,Berlin,100
Iran,Teheran,70
Italy,Rome,50
[student@linux pipes]$ sort -k2 country.txt 
Germany,Berlin,100
Belgium,Brussels,10
France,Paris,60
Italy,Rome,50
Iran,Teheran,70
```

The screenshot below shows the difference between an alphabetical sort and a numerical sort (both on the third column).

```console
[student@linux pipes]$ sort -k3 country.txt 
Belgium,Brussels,10
Germany,Berlin,100
Italy,Rome,50
France,Paris,60
Iran,Teheran,70
[student@linux pipes]$ sort -n -k3 country.txt 
Belgium,Brussels,10
Italy,Rome,50
France,Paris,60
Iran,Teheran,70
Germany,Berlin,100
```

## uniq

With `uniq` you can remove duplicates from a *sorted list*.

```console
student@linux:~/pipes$ cat music.txt 
Queen
Brel
Queen
Abba
student@linux:~/pipes$ sort music.txt 
Abba
Brel
Queen
Queen
student@linux:~/pipes$ sort music.txt | uniq
Abba
Brel
Queen
```

`uniq` can also count occurrences with the `-c` option.

```console
student@linux:~/pipes$ sort music.txt |uniq -c
        1 Abba
        1 Brel
        2 Queen
```

## fmt

Reformats text files to a specified width, preserving paragraphs and ensuring words are not split.

```console
student@linux:~/pipes$ cat lorem.txt 
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
student@linux:~/pipes$ fmt -w 35 lorem.txt 
Lorem ipsum dolor sit amet,
consectetur adipiscing elit, sed
do eiusmod tempor incididunt ut
labore et dolore magna aliqua. Ut
enim ad minim veniam, quis nostrud
exercitation ullamco laboris
nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor
in reprehenderit in voluptate
velit esse cillum dolore eu fugiat
nulla pariatur. Excepteur sint
occaecat cupidatat non proident,
sunt in culpa qui officia deserunt
mollit anim id est laborum.
```

## nl

Add line numbers to input text.

```console
student@linux:~/pipes$ nl count.txt 
     1  one
     2  two
     3  three
     4  four
     5  five
```

## wc

Counting words, lines and characters is easy with `wc`.

```console
[student@linux pipes]$ wc tennis.txt 
    5  15 100 tennis.txt
[student@linux pipes]$ wc -l tennis.txt 
5 tennis.txt
[student@linux pipes]$ wc -w tennis.txt 
15 tennis.txt
[student@linux pipes]$ wc -c tennis.txt 
100 tennis.txt
[student@linux pipes]$
```

## column

Arrange the input in columns. Option `-t` will create a nicely formatted table. Option `-s` specifies the delimiter of the input text (default is whitespace).

```console
[student@linux pipes]$  column -t -s: < /etc/passwd | head -4
root      x    0    0    Super User    /root       /bin/bash
bin       x    1    1    bin           /bin        /usr/sbin/nologin
daemon    x    2    2    daemon        /sbin       /usr/sbin/nologin
adm       x    3    4    adm           /var/adm    /usr/sbin/nologin
```

It also allows you to emit JSON with option `-J`. Option `-N` specifies the column/key names.

```console
[vagrant@linux pipes]$ head -4 /etc/passwd | column -J -N user,passwd,uid,gid,name,home,shell -s:
{
   "table": [
      {
         "user": "root",
         "passwd": "x",
         "uid": "0",
         "gid": "0",
         "name": "Super User",
         "home": "/root",
         "shell": "/bin/bash"
      },{
         "user": "bin",
         "passwd": "x",
         "uid": "1",
         "gid": "1",
         "name": "bin",
         "home": "/bin",
         "shell": "/usr/sbin/nologin"
      },{
         "user": "daemon",
         "passwd": "x",
         "uid": "2",
         "gid": "2",
         "name": "daemon",
         "home": "/sbin",
         "shell": "/usr/sbin/nologin"
      },{
         "user": "adm",
         "passwd": "x",
         "uid": "3",
         "gid": "4",
         "name": "adm",
         "home": "/var/adm",
         "shell": "/usr/sbin/nologin"
      }
   ]
}
```

## comm

Comparing streams (or files) can be done with the `comm`. By default `comm` will output three columns. In this example, Abba, Cure and Queen are in both lists, Bowie and Sweet are only in the first file, Turner is only in the second.

```console
student@linux:~/pipes$ cat > list1.txt
Abba
Bowie
Cure
Queen
Sweet
student@linux:~/pipes$ cat > list2.txt
Abba
Cure
Queen
Turner
student@linux:~/pipes$ comm list1.txt list2.txt 
                Abba
Bowie
                Cure
                Queen
Sweet
        Turner
```

The output of `comm` can be easier to read when outputting only a single column. The digits point out which output columns should not be displayed.

```console
student@linux:~/pipes$ comm -12 list1.txt list2.txt 
Abba
Cure
Queen
student@linux:~/pipes$ comm -13 list1.txt list2.txt 
Turner
student@linux:~/pipes$ comm -23 list1.txt list2.txt 
Bowie
Sweet
```

## grep

The `grep` filter is famous among Unix users. The most common use of `grep` is to filter lines of text containing (or not containing) a certain text pattern. That pattern can be a simple string or a regular expression.

```console
[student@linux pipes]$ cat tennis.txt 
Amelie Mauresmo,Fra
Kim Clijsters,BEL
Justine Henin,Bel
Serena Williams,usa
Venus Williams,USA
[student@linux pipes]$ grep Williams tennis.txt
Serena Williams,usa
Venus Williams,USA
```

One of the most useful options of grep is `grep -i` which filters in a case insensitive way.

```console
[student@linux pipes]$ grep Bel tennis.txt 
Justine Henin,Bel
[student@linux pipes]$ grep -i Bel tennis.txt 
Kim Clijsters,BEL
Justine Henin,Bel
```

Another very useful option is `grep -v` which outputs lines *not* matching the string.

```console
[student@linux pipes]$ grep -v Fra tennis.txt 
Kim Clijsters,BEL
Justine Henin,Bel
Serena Williams,usa
Venus Williams,USA
```

And of course, both options can be combined to filter all lines not containing a case insensitive string.

```console
[student@linux pipes]$ grep -vi usa tennis.txt 
Amelie Mauresmo,Fra
Kim Clijsters,BEL
Justine Henin,Bel
```

With `grep -A1` one line `after` the result is also displayed.

```console
student@linux:~/pipes$ grep -A1 Henin tennis.txt 
Justine Henin,Bel
Serena Williams,usa
```

With `grep -B1` one line `before` the result is also displayed.

```console
student@linux:~/pipes$ grep -B1 Henin tennis.txt 
Kim Clijsters,BEL
Justine Henin,Bel
```

With `grep -C1` (context) one line `before` and one `after` are also displayed. All three options (A,B, and C) can display any number of lines (using e.g. A2, B4 or C20).

```console
student@linux:~/pipes$ grep -C1 Henin tennis.txt 
Kim Clijsters,BEL
Justine Henin,Bel
Serena Williams,usa
```

## tr

The filter `tr` (short for *translate*) is used to translate *characters*. It's a bit different from the other filters, as it works on single characters, instead of lines of text. Also, it's not possible to specify a file as input, only `stdin`.

You can translate characters with `tr`. The screenshot shows the translation of all occurrences of e to E.

```console
[student@linux pipes]$ cat tennis.txt | tr 'e' 'E'
AmEliE MaurEsmo,Fra
Kim ClijstErs,BEL
JustinE HEnin,BEl
SErEna Williams,usa
VEnus Williams,USA
```

Here we set all letters to uppercase by defining two ranges.

```console
[student@linux pipes]$ cat tennis.txt | tr 'a-z' 'A-Z'
AMELIE MAURESMO,FRA
KIM CLIJSTERS,BEL
JUSTINE HENIN,BEL
SERENA WILLIAMS,USA
VENUS WILLIAMS,USA
```

Here we translate all newlines to spaces.

```console
[student@linux pipes]$ cat count.txt 
one
two
three
four
five
[student@linux pipes]$ cat count.txt | tr '\n' ' '
one two three four five [student@linux pipes]$
```

The `tr -s` filter can also be used to squeeze multiple occurrences of a character to one.

```console
[student@linux pipes]$ cat spaces.txt 
one    two        three
        four   five  six
[student@linux pipes]$ cat spaces.txt | tr -s ' '
one two three
    four five six
```

You can also use `tr` to 'encrypt' texts with `rot13`.

```console
[student@linux pipes]$ cat count.txt | tr 'a-z' 'nopqrstuvwxyzabcdefghijklm'
bar
gjb
guerr
sbhe
svir
[student@linux pipes]$ cat count.txt | tr 'a-z' 'n-za-m'
bar
gjb
guerr
sbhe
svir
```

This last example uses `tr -d` to delete characters.

```console
student@linux:~/pipes$ cat tennis.txt | tr -d e
Amli Maursmo,Fra
Kim Clijstrs,BEL
Justin Hnin,Bl
Srna Williams,usa
Vnus Williams,USA
```

## sed

The `s`tream `ed`itor `sed` can perform editing functions in the stream, using *regular expressions*. It is very often used for search and replace operations.

The command `s` (short for substitute) takes a regular expression and a replacement string as arguments in the form `s/regexp/replacement/` and replaces the first occurrence of the regular expression on each line of input with the replacement string.

```console
student@linux:~/pipes$ sed 's/5/42/' <<< 'level5 level7'
level42 level7
student@linux:~/pipes$ sed 's/level/jump/' <<< 'level5 level7'
jump5 level7
```

Add `g` for global replacements (all occurrences of the string per line).

```console
student@linux:~/pipes$ sed 's/level/jump/g' <<< 'level5 level7'
jump5 jump7
```

With `/regex/d` you can remove lines from a stream matching the specified regular expression.

```console
student@linux:~/filters$ cat tennis.txt 
Venus Williams,USA
Martina Hingis,SUI
Justine Henin,BE
Serena williams,USA
Kim Clijsters,BE
Yanina Wickmayer,BE
student@linux:~/filters$ cat tennis.txt | sed '/BE/d'
Venus Williams,USA
Martina Hingis,SUI
Serena williams,USA
```

There are many more options for `sed`, but they are beyond the scope of this chapter. Check e.g. this list of [sed one-liners](https://www.pement.org/sed/sed1line.txt) and do an Internet search for more examples.

## awk

Maybe `awk` does not really belong in a list of filters "that do one specific thing", as it is a complete programming language. But it is often used in the same way as the other filters, so we give at least a few examples. Just like `sed`, `awk` is a very powerful tool, and we can only scratch the surface here. See the [GNU Awk User's Guide](https://www.gnu.org/software/gawk/manual/gawk.html) for in-depth information, or find examples like this list of [awk one-liners](https://www.pement.org/awk/awk1line.txt).

AWK was developed in the late 1970's. The name stands for the last names of its authors: Alfred Aho, Peter Weinberger, and Brian Kernighan. If the last name sounds familiar, it's because Brian Kernighan he is also co-authors of the C programming language and contributed to the development of Unix. Awk is a part of the POSIX standard and therefore is always available on Unix-like systems.

You can consider AWK as a programming language with a built-in for loop. For each line of input, it will perform the specified action (written out in a C-like syntax). The action is enclosed in curly braces `{}`. Awk also automatically splits each line into whitespace delimited fields, which can be accessed with `$1`, `$2`, etc. The whole line is `$0`.

The following example prints the first and third field of each line of the `passwd` file. Since the fields are separated by colons, we use `-F:` to specify the field separator. Compare to the `cut` example above!

```console
student@linux:~/pipes$ awk -F: '{print $1, $3}' /etc/passwd | tail -4
Figo 510
Pfaff 511
Harry 516
Hermione 517
```

You can apply an action only to lines matching a regular expression. This example prints the first and third field of each line of the `passwd` file, but only for lines ending on the string `bash`.

```console
student@linux:~/pipes$ awk -F: '/bash$/ {print $1, $3}' /etc/passwd
root 0
student 1000
paul 1001
serena 1002
```

Awk automatically interprets numbers as numbers, so you can do calculations with them. This example prints the first and third field of each line of the `passwd` file, but only for lines where the third field (UID) is greater than or equals to 1000 (i.e. "normal" users).

```console
student@linux:~/pipes$ awk -F: '$3 >= 1000 {print $1, $3}' /etc/passwd
student 1000
paul 1001
serena 1002
```

Awk can also be used to perform calculations.

```console
student@linux:~/pipes$ cat country.txt 
France,Paris,60
Italy,Rome,50
Belgium,Brussels,10
Iran,Teheran,70
Germany,Berlin,100
student@linux:~/pipes$ awk -F, '{ sum += $3 } END { print sum/NR }' country.txt
58
```

A lot is going on here. For each line of input, the numerical value of column 3 is added to the variable `sum`. This variable is implicitly initialized to 0. The `END` block is executed after all lines have been processed. It prints the value of `sum` divided by the number of records (lines) processed, which is stored in the built-in variable `NR`. So, this one-liner calculates the average of the third column of the file `country.txt`.

## pipe examples

### who | wc

How many users are logged  on to this system ?

```console
[student@linux pipes]$ who
root     tty1         Jul 25 10:50
paul     pts/0        Jul 25 09:29 (laika)
Harry    pts/1        Jul 25 12:26 (barry)
paul     pts/2        Jul 25 12:26 (pasha)
[student@linux pipes]$ who | wc -l
4
```

### who | cut | sort

Display a sorted  list of logged on users.

```console
[student@linux pipes]$ who | cut -d' ' -f1 | sort
Harry
paul
paul
root
```

Display a sorted list of logged on users, but every user only once .

```console
[student@linux pipes]$ who | cut -d' ' -f1 | sort | uniq
Harry
paul
root
```

### grep | cut

Display a list of all *user accounts* on this computer. Users accounts are explained in in the chapters about user management.

```console
student@linux:~$ grep bash /etc/passwd
root:x:0:0:root:/root:/bin/bash
paul:x:1000:1000:paul,,,:/home/paul:/bin/bash
serena:x:1001:1001::/home/serena:/bin/bash
student@linux:~$ grep bash /etc/passwd | cut -d: -f1
root
paul
serena
```

### ip | awk

Display only IPv4 addresses of this computer.

```console
student@linux:~/pipes$ ip -br a
lo      UNKNOWN    127.0.0.1/8 ::1/128 
eth0    UP         10.0.2.15/24 fe80::a00:27ff:fee6:f5c9/64 
eth1    UP         192.168.56.21/24 fe80::a00:27ff:fe0f:afa/64 
student@linux:~/pipes$ ip -br a | awk '{print $3}'
127.0.0.1/8
10.0.2.15/24
192.168.56.21/24
```

