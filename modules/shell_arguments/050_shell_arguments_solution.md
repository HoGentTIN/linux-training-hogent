## solution: commands and arguments

1\. How many `arguments` are in this line (not counting the command
itself).

    touch '/etc/cron/cron.allow' 'file 42.txt' "file 33.txt"

    answer: three

2\. Is `tac` a shell builtin command ?

    type tac

3\. Is there an existing alias for `rm` ?

    alias rm

4\. Read the man page of `rm`, make sure you understand the `-i` option
of rm. Create and remove a file to test the `-i` option.

    man rm

    touch testfile

    rm -i testfile

5\. Execute: `alias rm='rm -i'` . Test your alias with a test file. Does
this work as expected ?

    touch testfile

    rm testfile (should ask for confirmation)

6\. List all current aliases.

    alias

7a. Create an alias called \'city\' that echoes your hometown.

    alias city='echo Antwerp'

7b. Use your alias to test that it works.

    city (it should display Antwerp)

8\. Execute `set -x` to display shell expansion for every command.

    set -x

9\. Test the functionality of `set -x` by executing your `city` and `rm`
aliases.

    shell should display the resolved aliases and then execute the command:
    student@linux:~$ set -x
    student@linux:~$ city
    + echo antwerp
    antwerp

10 Execute `set +x` to stop displaying shell expansion.

    set +x

11\. Remove your city alias.

    unalias city

12\. What is the location of the `cat` and the `passwd` commands ?

    which cat (probably /bin/cat)

    which passwd (probably /usr/bin/passwd)

13\. Explain the difference between the following commands:

    echo

    /bin/echo

The `echo` command will be interpreted by the shell as the
`built-in echo` command. The `/bin/echo` command will make the shell
execute the `echo binary` located in the `/bin` directory.

14\. Explain the difference between the following commands:

    echo Hello

    echo -n Hello

The -n option of the `echo` command will prevent echo from echoing a
trailing newline. `echo Hello` will echo six characters in total,
`echo -n hello` only echoes five characters.

(The -n option might not work in the Korn shell.)

15\. Display `A B C` with two spaces between B and C.

    echo "A B  C"

16\. Complete the following command (do not use spaces) to display
exactly the following output:

    4+4     =8
    10+14   =24

The solution is to use tabs with \\t.

    echo -e "4+4\t=8" ; echo -e "10+14\t=24"

17\. Use `echo` to display the following exactly:

    ??\\
    echo '??\\'
    echo -e '??\\\\'
    echo "??\\\\"
    echo -e "??\\\\\\"
    echo ??\\\\

Find two solutions with single quotes, two with double quotes and one
without quotes (and say thank you to René and Darioush from Google for
this extra).

18\. Use one `echo` command to display three words on three lines.

    echo -e "one \ntwo \nthree"

