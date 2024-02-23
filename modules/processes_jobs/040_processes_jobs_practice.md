## practice : background processes

1\. Use the `jobs` command to verify whether you have any processes
running in background.

2\. Use `vi` to create a little text file. Suspend `vi` in background.

3\. Verify with `jobs` that `vi` is suspended in background.

4\. Start `find / > allfiles.txt 2>/dev/null` in foreground. Suspend it
in background before it finishes.

5\. Start two long `sleep` processes in background.

6\. Display all `jobs` in background.

7\. Use the `kill` command to suspend the last `sleep` process.

8\. Continue the `find` process in background (make sure it runs again).

9\. Put one of the `sleep` commands back in foreground.

10\. (if time permits, a general review question\...) Explain in detail
where the numbers come from in the next screenshot. When are the
variables replaced by their value ? By which shell ?

    [student@linux ~]$ echo $$ $PPID
    4224 4223
    [student@linux ~]$ bash -c "echo $$ $PPID"
    4224 4223
    [student@linux ~]$ bash -c 'echo $$ $PPID'
    5059 4224
    [student@linux ~]$ bash -c `echo $$ $PPID`
    4223: 4224: command not found

