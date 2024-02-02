## solution: shell globbing

1\. Create a test directory and enter it.

    mkdir testdir; cd testdir

2\. Create the following files :

    file1
    file10
    file11
    file2
    File2
    File3
    file33
    fileAB
    filea
    fileA
    fileAAA
    file(
    file 2

(the last one has 6 characters including a space)

    touch file1 file10 file11 file2 File2 File3
    touch file33 fileAB filea fileA fileAAA
    touch "file("
    touch "file 2"

3\. List (with ls) all files starting with file

    ls file*

4\. List (with ls) all files starting with File

    ls File*

5\. List (with ls) all files starting with file and ending in a number.

    ls file*[0-9]

6\. List (with ls) all files starting with file and ending with a letter

    ls file*[a-z]

7\. List (with ls) all files starting with File and having a digit as
fifth character.

    ls File[0-9]*

8\. List (with ls) all files starting with File and having a digit as
fifth character and nothing else.

    ls File[0-9]

9\. List (with ls) all files starting with a letter and ending in a
number.

    ls [a-z]*[0-9]

10\. List (with ls) all files that have exactly five characters.

    ls ?????

11\. List (with ls) all files that start with f or F and end with 3 or
A.

    ls [fF]*[3A]

12\. List (with ls) all files that start with f have i or R as second
character and end in a number.

    ls f[iR]*[0-9]

13\. List all files that do not start with the letter F.

    ls [!F]*

14\. Copy the value of \$LANG to \$MyLANG.

    MyLANG=$LANG

15\. Show the influence of \$LANG in listing A-Z or a-z ranges.

    see example in book

16\. You receive information that one of your servers was cracked, the
cracker probably replaced the `ls` command. You know that the `echo`
command is safe to use. Can `echo` replace `ls` ? How can you list the
files in the current directory with `echo` ?

    echo *

17\. Is there another command besides cd to change directories ?

    pushd popd
