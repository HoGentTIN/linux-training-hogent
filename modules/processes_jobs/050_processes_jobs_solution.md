# solution : background processes

1\. Use the `jobs` command to verify whether you have any processes
running in background.

    jobs (maybe the catfun is still running?)

2\. Use `vi` to create a little text file. Suspend `vi` in background.

    vi text.txt
    (inside vi press ctrl-z)

3\. Verify with `jobs` that `vi` is suspended in background.

    [paul@rhel53 ~]$ jobs
    [1]+  Stopped                 vim text.txt

4\. Start `find / > allfiles.txt 2>/dev/null` in foreground. Suspend it
in background before it finishes.

    [paul@rhel53 ~]$ find / > allfiles.txt 2>/dev/null
       (press ctrl-z)
    [2]+  Stopped                 find / > allfiles.txt 2> /dev/null

5\. Start two long `sleep` processes in background.

    sleep 4000 & ; sleep 5000 &

6\. Display all `jobs` in background.

    [paul@rhel53 ~]$ jobs
    [1]-  Stopped                 vim text.txt
    [2]+  Stopped                 find / > allfiles.txt 2> /dev/null
    [3]   Running                 sleep 4000 &
    [4]   Running                 sleep 5000 &

7\. Use the `kill` command to suspend the last `sleep` process.

    [paul@rhel53 ~]$ kill -SIGSTOP 4519
    [paul@rhel53 ~]$ jobs
    [1]   Stopped                 vim text.txt
    [2]-  Stopped                 find / > allfiles.txt 2> /dev/null
    [3]   Running                 sleep 4000 &
    [4]+  Stopped                 sleep 5000

8\. Continue the `find` process in background (make sure it runs again).

    bg 2 (verify the job-id in your jobs list)

9\. Put one of the `sleep` commands back in foreground.

    fg 3 (again verify your job-id)

10\. (if time permits, a general review question\...) Explain in detail
where the numbers come from in the next screenshot. When are the
variables replaced by their value ? By which shell ?

    [paul@RHEL8b ~]$ echo $$ $PPID
    4224 4223
    [paul@RHEL8b ~]$ bash -c "echo $$ $PPID"
    4224 4223
    [paul@RHEL8b ~]$ bash -c 'echo $$ $PPID'
    5059 4224
    [paul@RHEL8b ~]$ bash -c `echo $$ $PPID`
    4223: 4224: command not found
        

The current bash shell will replace the \$\$ and \$PPID while scanning
the line, and before executing the echo command.

    [paul@RHEL8b ~]$ echo $$ $PPID
    4224 4223
        

The variables are now double quoted, but the current bash shell will
replace \$\$ and \$PPID while scanning the line, and before executing
the `bash -c` command.

    [paul@RHEL8b ~]$ bash -c "echo $$ $PPID"
    4224 4223
        

The variables are now single quoted. The current bash shell will `not`
replace the \$\$ and the \$PPID. The bash -c command will be executed
before the variables replaced with their value. This latter bash is the
one replacing the \$\$ and \$PPID with their value.

    [paul@RHEL8b ~]$ bash -c 'echo $$ $PPID'
    5059 4224
        

With backticks the shell will still replace both variable before the
embedded echo is executed. The result of this echo is the two process
id\'s. These are given as commands to bash -c. But two numbers are not
commands!

    [paul@RHEL8b ~]$ bash -c `echo $$ $PPID`
    4223: 4224: command not found
        
