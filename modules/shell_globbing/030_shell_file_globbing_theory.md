## \* asterisk

The asterisk `*` is interpreted by the shell as a sign to
generate filenames, matching the asterisk to any combination of
characters (even none). When no path is given, the shell will use
filenames in the current directory. See the man page of
`glob(7)` for more information. (This is part of LPI topic
1.103.3.)

    [student@linux gen]$ ls
    file1  file2  file3  File4  File55  FileA  fileab  Fileab  FileAB  fileabc
    [student@linux gen]$ ls File*
    File4  File55  FileA  Fileab  FileAB
    [student@linux gen]$ ls file*
    file1  file2  file3  fileab  fileabc
    [student@linux gen]$ ls *ile55
    File55
    [student@linux gen]$ ls F*ile55
    File55
    [student@linux gen]$ ls F*55
    File55
    [student@linux gen]$

## ? question mark

Similar to the asterisk, the question mark `?` is
interpreted by the shell as a sign to generate filenames, matching the
question mark with exactly one character.

    [student@linux gen]$ ls
    file1  file2  file3  File4  File55  FileA  fileab  Fileab  FileAB  fileabc
    [student@linux gen]$ ls File?
    File4  FileA
    [student@linux gen]$ ls Fil?4
    File4
    [student@linux gen]$ ls Fil??
    File4  FileA
    [student@linux gen]$ ls File??
    File55  Fileab  FileAB
    [student@linux gen]$

## \[\] square brackets

The square bracket `[` is interpreted by the shell as a
sign to generate filenames, matching any of the characters between `[`
and the first subsequent `]`. The order in this list between the
brackets is not important. Each pair of brackets is replaced by exactly
one character.

    [student@linux gen]$ ls 
    file1  file2  file3  File4  File55  FileA  fileab  Fileab  FileAB  fileabc
    [student@linux gen]$ ls File[5A]
    FileA
    [student@linux gen]$ ls File[A5]
    FileA
    [student@linux gen]$ ls File[A5][5b]
    File55
    [student@linux gen]$ ls File[a5][5b]
    File55  Fileab
    [student@linux gen]$ ls File[a5][5b][abcdefghijklm]
    ls: File[a5][5b][abcdefghijklm]: No such file or directory
    [student@linux gen]$ ls file[a5][5b][abcdefghijklm]
    fileabc
    [student@linux gen]$

You can also exclude characters from a list between square brackets with
the exclamation mark `!`. And you are allowed to make
combinations of these `wild cards`.

    [student@linux gen]$ ls 
    file1  file2  file3  File4  File55  FileA  fileab  Fileab  FileAB  fileabc
    [student@linux gen]$ ls file[a5][!Z]
    fileab
    [student@linux gen]$ ls file[!5]*
    file1  file2  file3  fileab  fileabc
    [student@linux gen]$ ls file[!5]?
    fileab
    [student@linux gen]$

## a-z and 0-9 ranges

The bash shell will also understand ranges of characters between
brackets.

    [student@linux gen]$ ls
    file1  file3  File55  fileab  FileAB   fileabc
    file2  File4  FileA   Fileab  fileab2
    [student@linux gen]$ ls file[a-z]*
    fileab  fileab2  fileabc
    [student@linux gen]$ ls file[0-9]
    file1  file2  file3
    [student@linux gen]$ ls file[a-z][a-z][0-9]*
    fileab2
    [student@linux gen]$

## \$LANG and square brackets

But, don\'t forget the influence of the `LANG` variable.
Some languages include lower case letters in an upper case range (and
vice versa).

    student@linux:~/test$ ls [A-Z]ile?
    file1  file2  file3  File4
    student@linux:~/test$ ls [a-z]ile?
    file1  file2  file3  File4
    student@linux:~/test$ echo $LANG
    en_US.UTF-8
    student@linux:~/test$ LANG=C
    student@linux:~/test$ echo $LANG
    C
    student@linux:~/test$ ls [a-z]ile?
    file1  file2  file3
    student@linux:~/test$ ls [A-Z]ile?
    File4
    student@linux:~/test$

If `$LC_ALL` is set, then this will also need to be reset to prevent
file globbing.

## preventing file globbing

The screenshot below should be no surprise. The `echo *`
will echo a \* when in an empty directory. And it will echo the names of
all files when the directory is not empty.

    student@linux:~$ mkdir test42
    student@linux:~$ cd test42
    student@linux:~/test42$ echo *
    *
    student@linux:~/test42$ touch file42 file33
    student@linux:~/test42$ echo *
    file33 file42

Globbing can be prevented using quotes or by escaping the
special characters, as shown in this screenshot.

    student@linux:~/test42$ echo *
    file33 file42
    student@linux:~/test42$ echo \*
    *
    student@linux:~/test42$ echo '*'
    *
    student@linux:~/test42$ echo "*"
    *

