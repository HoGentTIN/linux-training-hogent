## practice: shell globbing

In the questions below, use the `ls` command with globbing patterns to list the specified files. Don't pipe the output to `grep` or another tool to filter on regular expressions!

1. Create a test directory `glob` and enter it.

2. Create the following files :

    ```text
    vagrant@ubuntu:~/glob$ ls
    'file('   file10  'file 2'   File2   file33   fileA   fileà   fileAAA
     file1    file11   file2     File3   filea    fileá   fileå   fileAB
    ```

    (remark that `file 2` has a space in the name!)

3. List all files starting with `file`

4. List all files starting with `File`

5. List all files starting with `file` and ending in *a number*.

6. List all files starting with `file` and ending with *a letter*

7. List all files starting with `File` and having a *digit* as *fifth* character.

8. List all files starting with `File` and having a *digit* as *fifth* and last character (i.e. the name consists of five characters).

9. List all files starting with *a letter* and ending in *a number*.

10. List all files that have *exactly five characters*.

11. List all files that start with `f` or `F` and end with `3` or `A`.

12. List all files that start with `f` have `i` or `R` as second character and end in a number.

13. List all files that do not start with the letter `F`.

14. Show the influence of `$LANG` (the system locale) in listing `A-Z` or `a-z` ranges.

15. You receive information that one of your servers was cracked. The cracker probably replaced the `ls` command with a rootkit so it can no longer be used safely. You know that the `echo` command is safe to use. Can `echo` replace `ls`? How can you list the files in the current directory with `echo`?

