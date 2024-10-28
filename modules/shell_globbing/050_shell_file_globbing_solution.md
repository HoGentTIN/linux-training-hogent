## solution: shell globbing

1. Create a test directory `glob` and enter it.

    ```bash
    mkdir glob; cd glob
    ```

2. Create the files:

    ```console
    student@ubuntu:~$ touch file1 file10 file11 file2 File2 File3 file33 fileAB
    student@ubuntu:~$ touch filea fileá fileà fileå fileA fileAAA 'file(' 'file 2'
    ```

3. List all files starting with `file`

    ```console
    student@ubuntu:~/glob$ ls file*
    'file('   file10  'file 2'   file33   fileA   fileà   fileAAA
     file1    file11   file2     filea    fileá   fileå   fileAB
    ```

4. List all files starting with `File`

    ```console
    student@ubuntu:~/glob$ ls File*
    File2  File3
    ```

5. List all files starting with `file` and ending in *a number*.

    ```console
    student@ubuntu:~/glob$ ls file*[0-9]
    file1   file10   file11  'file 2'   file2   file33
    ```

6. List all files starting with `file` and ending with *a letter*

    ```console
    student@ubuntu:~/glob$ ls file*[A-Za-z]
    filea  fileA  fileAAA  fileAB
    student@ubuntu:~/glob$ ls file*[[:alpha:]]
    filea  fileA  fileá  fileà  fileå  fileAAA  fileAB
    ```

    > Remark that the first solution is not complete, as it does not list the files with special characters in the name! In this case, it's better to use the named class `[:alpha:]`.

7. List all files starting with `File` and having a *digit* as *fifth* character.

    ```console
    student@ubuntu:~/glob$ ls File[0-9]*
    File2  File3
    ```

8. List all files starting with `File` and having a *digit* as *fifth* and last character (i.e. the name consists of five characters).

    ```console
    student@ubuntu:~/glob$ ls File[0-9]
    File2
    ```

9. List all files starting with *a letter* and ending in *a number*.

    ```console
    student@ubuntu:~/glob$ ls [[:alpha:]]*[[:digit:]]
    file1   file10   file11  'file 2'   file2   File2   File3   file33
    ```

10. List all files that have *exactly five characters*.

    ```console
    student@ubuntu:~/glob$ ls ?????
    'file('   file1   file2   File2   File3   filea   fileA   fileá   fileà   fileå
    ```

11. List all files that start with `f` or `F` and end with `3` or `A`.

    ```console
    student@ubuntu:~/glob$ ls [fF]*[3A]
    File3  file33  fileA  fileAAA
    ```

12. List all files that start with `f` have `i` or `R` as second character and end in a number.

    ```console
    student@ubuntu:~/glob$ ls f[iR]*[0-9]
    file1   file10   file11  'file 2'   file2   file33
    ```

13. List all files that do not start with the letter `F`.

    ```console
    student@ubuntu:~/glob$ ls [^F]*
    'file('   file10  'file 2'   file33   fileA   fileà   fileAAA
     file1    file11   file2     filea    fileá   fileå   fileAB
    ```

14. Show the influence of `$LANG` (the system locale) in listing `A-Z` or `a-z` ranges.

    ```console
    student@ubuntu:~/glob$ LANG=C ls file[[:alpha:]]*
    fileA   fileAAA   fileAB   filea  'file'$'\303\240'  'file'$'\303\241'  'file'$'\303\245'
    student@ubuntu:~/glob$ LANG=en_US.UTF-8 ls file[[:alpha:]]*
    filea  fileA  fileá  fileà  fileå  fileAAA  fileAB
    student@ubuntu:~/glob$ LANG=da_DK.UTF-8 ls file[[:alpha:]]*
    fileA  filea  fileá  fileà  fileAB  fileå  fileAAA
    ```

15. You receive information that one of your servers was cracked. The cracker probably replaced the `ls` command with a rootkit so it can no longer be used safely. You know that the `echo` command is safe to use. Can `echo` replace `ls`? How can you list the files in the current directory with `echo`?

    ```console
    student@ubuntu:~/glob$ echo *
    file( file1 file10 file11 file 2 file2 File2 File3 file33 filea fileA fileá fileà fileå fileAAA fileAB
    ```

    > A disadvantage is that you can't see properties of the files, like permissions, owner, group, size, and date. For this, you can use `stat`.


