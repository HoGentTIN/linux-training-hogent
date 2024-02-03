## practice: file contents

1\. Display the first 12 lines of `/etc/services`.

2\. Display the last line of `/etc/passwd`.

3\. Use cat to create a file named `count.txt` that looks like this:

    One
    Two
    Three
    Four
    Five

4\. Use `cp` to make a backup of this file to `cnt.txt`.

5\. Use `cat` to make a backup of this file to `catcnt.txt`.

6\. Display `catcnt.txt`, but with all lines in reverse order (the last
line first).

7\. Use more to display `/etc/services`.

8\. Display the readable character strings from the `/usr/bin/passwd`
command.

9\. Use `ls` to find the biggest file in `/etc`.

10\. Open two terminal windows (or tabs) and make sure you are in the
same directory in both. Type `echo this is the first line > tailing.txt`
in the first terminal, then issue `tail -f tailing.txt` in the second
terminal. Now go back to the first terminal and type
`echo This is another line >> tailing.txt` (note the double \>\>),
verify that the `tail -f` in the second terminal shows both lines. Stop
the `tail -f` with `Ctrl-C`.

11\. Use `cat` to create a file named `tailing.txt` that contains the
contents of `tailing.txt` followed by the contents of `/etc/passwd`.

12\. Use `cat` to create a file named `tailing.txt` that contains the
contents of `tailing.txt` preceded by the contents of `/etc/passwd`.

