## `*` asterisk

The asterisk `*` is interpreted by the shell as a sign to generate filenames, matching the asterisk to any combination of characters (even none). When no path is given, the shell will use filenames in the current directory. See the man page of `glob(7)` for more information.

```console
student@linux:~/gen$ ls
file1  file2  file3  File4  File55  FileA  fileå  fileab  Fileab  FileAB  fileabc  fileæ  fileø  filex  filey  filez
student@linux:~/gen$ ls File*
File4  File55  FileA  Fileab  FileAB
student@linux:~/gen$ ls file*
file1  file2  file3  fileå  fileab  fileabc  fileæ  fileø  filex  filey  filez
student@linux:~/gen$ ls *ile55
File55
student@linux:~/gen$ ls F*ile55
File55
student@linux:~/gen$ ls F*55
File55
```

## `?` question mark

Similar to the asterisk, the question mark `?` is interpreted by the shell as a sign to generate filenames, matching the question mark with exactly one character.

```console
student@linux:~/gen$ ls File?
File4  FileA
student@linux:~/gen$ ls Fil?4
File4
student@linux:~/gen$ ls Fil??
File4  FileA
student@linux:~/gen$ ls File??
File55  Fileab  FileAB
```

## `[]` square brackets

The square bracket `[` is interpreted by the shell as a sign to generate filenames, matching any of the characters between `[` and the first subsequent `]`. The order in this list between the brackets is not important. Each pair of brackets is replaced by exactly one character.

```console
student@linux:~/gen$ ls File[5A]
FileA
student@linux:~/gen$ ls File[A5]3
ls: cannot access 'File[A5]3': No such file or directory
student@linux:~/gen$ ls File[A5]
FileA
student@linux:~/gen$ ls File[A5][5b]
File55
student@linux:~/gen$ ls File[a5][5b]
File55  Fileab
student@linux:~/gen$ ls File[a5][5b][abcdefghijklm]
ls: cannot access 'File[a5][5b][abcdefghijklm]': No such file or directory
student@linux:~/gen$ ls file[a5][5b][abcdefghijklm]
fileabc
```

You can also exclude characters from a list between square brackets with the exclamation mark `!`. And you are allowed to make combinations of these *wildcards*.

```console
student@linux:~/gen$ ls file[a5][!Z]
fileab
student@linux:~/gen$ ls file[!5]*
file1  file2  file3  fileå  fileab  fileabc  fileæ  fileø  filex  filey  filez
student@linux:~/gen$ ls file[!5]?
fileab
```

## `a-z` and `0-9` ranges

The bash shell will also understand ranges of characters between brackets.

```console
student@linux:~/gen$ ls file[a-z]*
fileab  fileabc  filex  filey  filez
student@linux:~/gen$ ls file[0-9]
file1  file2  file3
student@linux:~/gen$ ls file[a-z][a-z][0-9]*
ls: cannot access 'file[a-z][a-z][0-9]*': No such file or directory
student@linux:~/gen$ ls file[a-z][a-z][a-z]*
fileabc
```

## named character classes

Instead of ranges, you can also specify named character classes: `[[:alnum:]]`,, `[[:alpha:]]`, `[[:blank:]]`, `[[:cntrl:]]`, `[[:digit:]]`, `[[:graph:]]`, `[[:lower:]]`, `[[:print:]]`, `[[:punct:]]`, `[[:space:]]`, `[[:upper:]]`, `[[:xdigit:]]`. Instead of, e.g. `[a-z]`, you can also use `[[:lower:]]`.

```console
student@linux:~/gen$ ls file[a-z]*
fileab  fileabc  filex  filey  filez
student@linux:~/gen$ ls file[[:lower:]]*
fileå  fileab  fileabc  fileæ  fileø  filex  filey  filez
```

Remark that the named character classes work better for international characters. In the example above, `[a-z]` does not match the Danish characters `æ`, `ø`, and `å`, but `[[:lower:]]` does.

## `$LANG` and square brackets

But, don't forget the influence of the `$LANG` variable. Depending on the selected language or locale, the shell will interpret the square brackets and named character classes differently. Sort order may also be affected.

For example, when we select the default locale called `C`:

```console
student@linux:~/gen$ sudo localectl set-locale C
[... log out and log in again ...]
student@linux:~/gen$ echo $LANG
C
student@linux:~/gen$ ls
 File4   File55   FileA   FileAB   Fileab   file1   file2   file3   fileab   fileabc   filex   filey   filez  'file'$'\303\245'  'file'$'\303\246'  'file'$'\303\270'
student@linux:~/gen$ ls file[[:lower:]]*
fileab  fileabc  filex  filey  filez
```

The Danish characters can't be displayed properly and don't match the `[[:lower:]]` character class.

Let us change the locale to `da_DK.UTF-8` (Danish/Denmark with UTF-8 support) and see what happens:

```console
student@linux:~/gen$ sudo localectl set-locale da_DK.UTF-8
[... log out and log in again ...]
student@linux:~/gen$ echo $LANG
da_DK.UTF-8
student@linux:~/gen$ ls
file1  file2  file3  File4  File55  FileA  FileAB  Fileab  fileab  fileabc  filex  filey  filez  fileæ  fileø  fileå
student@linux:~/gen$ ls file[[:lower:]]*
fileab  fileabc  filex  filey  filez  fileæ  fileø  fileå
```

Now the Danish characters are displayed properly and match the `[[:lower:]]` character class.

In the `en_US.UTF-8` locale (US English, with UTF-8 support), the Danish characters are displayed properly, and also match the `[[:lower:]]` character class. However, they are sorted differently:

```console
student@linux:~/gen$ sudo localectl set-locale en_US.UTF-8
[... log out and log in again ...]
student@linux:~/gen$ echo $LANG
en_US.UTF-8
student@linux:~/gen$ ls
file1  file2  file3  File4  File55  FileA  fileå  fileab  Fileab  FileAB  fileabc  fileæ  fileø  filex  filey  filez
student@linux:~/gen$ ls file[[:lower:]]*
fileå  fileab  fileabc  fileæ  fileø  filex  filey  filez
```

## preventing file globbing

If a wildcard pattern does not match any filenames, the shell will not expand the pattern. Consequently, when in an empty directory, `echo *` will display a `*`. It will echo the names of all files when the directory is not empty.

```console
student@linux:~$ mkdir test42
student@linux:~$ cd test42/
student@linux:~/test42$ echo *
*
student@linux:~/test42$ touch test{1,2,3}
student@linux:~/test42$ echo *
test1 test2 test3
```

Globbing can be prevented using quotes or by escaping the special characters, as shown in this screenshot.

```console
student@linux:~/test42$ echo *
test1 test2 test3
student@linux:~/test42$ echo \*
*
student@linux:~/test42$ echo '*'
*
student@linux:~/test42$ echo "*"
*
```

