## solution: input/output redirection

1\. Activate the `noclobber` shell option.

    set -o noclobber
    set -C

2\. Verify that `noclobber` is active by repeating an `ls` on `/etc/`
with redirected output to a file.

    ls /etc > etc.txt 
    ls /etc > etc.txt (should not work)

3\. When listing all shell options, which character represents the
`noclobber` option ?

    echo $- (noclobber is visible as C)

4\. Deactivate the `noclobber` option.

    set +o noclobber

5\. Make sure you have two shells open on the same computer. Create an
empty `tailing.txt` file. Then type `tail -f tailing.txt`. Use the
second shell to `append` a line of text to that file. Verify that the
first shell displays this line.

    student@linux:~$ > tailing.txt
    student@linux:~$ tail -f tailing.txt 
    hello
    world

    in the other shell:
    student@linux:~$ echo hello >> tailing.txt 
    student@linux:~$ echo world >> tailing.txt

6\. Create a file that contains the names of five people. Use `cat` and
output redirection to create the file and use a `here document` to end
the input.

    student@linux:~$ cat > tennis.txt << ace
    > Justine Henin
    > Venus Williams
    > Serena Williams
    > Martina Hingis
    > Kim Clijsters
    > ace
    student@linux:~$ cat tennis.txt 
    Justine Henin
    Venus Williams
    Serena Williams
    Martina Hingis
    Kim Clijsters
    student@linux:~$

