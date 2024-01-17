# solution: shell history

1\. Issue the command
`echo The answer to the meaning of life, the universe and everything is 42`.

    echo The answer to the meaning of life, the universe and everything is 42

2\. Repeat the previous command using only two characters (there are two
solutions!)

    !!
    OR
    !e

3\. Display the last 5 commands you typed.

    paul@ubu1010:~$ history 5
     52  ls -l
     53  ls
     54  df -h | grep sda
     55  echo The answer to the meaning of life, the universe and everything is 42
     56  history 5

You will receive different line numbers.

4\. Issue the long `echo` from question 1 again, using the line numbers
you received from the command in question 3.

    paul@ubu1010:~$ !55
    echo The answer to the meaning of life, the universe and everything is 42
    The answer to the meaning of life, the universe and everything is 42

5\. How many commands can be kept in memory for your current shell
session ?

    echo $HISTSIZE

6\. Where are these commands stored when exiting the shell ?

    echo $HISTFILE

7\. How many commands can be written to the `history file` when exiting
your current shell session ?

    echo $HISTFILESIZE

8\. Make sure your current bash shell remembers the next 5000 commands
you type.

    HISTSIZE=5000

9\. Open more than one console (by press Ctrl-shift-t in gnome-terminal,
or by opening an extra putty.exe in MS Windows) with the same user
account. When is command history written to the history file ?

    when you type exit
