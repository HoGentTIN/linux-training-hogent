# solution : basic process management

1\. Use `ps` to search for the `init` process by name.

    root@rhel53 ~# ps -C init
      PID TTY          TIME CMD
        1 ?        00:00:04 init
        

2\. What is the `process id` of the `init` process ?

    1

3\. Use the `who am i` command to determine your terminal name.

    root@rhel53 ~# who am i
    paul     pts/0        2010-04-12 17:44 (192.168.1.38)
        

4\. Using your terminal name from above, use `ps` to find all processes
associated with your terminal.

    oot@rhel53 ~# ps fax | grep pts/0
     2941 ?        S      0:00      \_ sshd: paul@pts/0 
     2942 pts/0    Ss     0:00          \_ -bash
     2972 pts/0    S      0:00              \_ su -
     2973 pts/0    S      0:00                  \_ -bash
     3808 pts/0    R+     0:00                      \_ ps fax
     3809 pts/0    R+     0:00                      \_ grep pts/0
        

or also

    root@rhel53 ~# ps -ef | grep pts/0
    paul      2941  2939  0 17:44 ?        00:00:00 sshd: paul@pts/0 
    paul      2942  2941  0 17:44 pts/0    00:00:00 -bash
    root      2972  2942  0 17:45 pts/0    00:00:00 su -
    root      2973  2972  0 17:45 pts/0    00:00:00 -bash
    root      3816  2973  0 21:25 pts/0    00:00:00 ps -ef
    root      3817  2973  0 21:25 pts/0    00:00:00 grep pts/0
        

5\. What is the `process id` of your shell ?

    2973 in the screenshot above, probably different for you

`echo $$` should display same number as the one you found

6\. What is the `parent process id` of your shell ?

    2972 in the screenshot above, probably different for you

in this example the PPID is from the `su -` command, but when inside
gnome then for example gnome-terminal can be the parent process

7\. Start two instances of the `sleep 3342` in background.

    sleep 3342 &
    sleep 3342 &

8\. Locate the `process id` of all `sleep` commands.

    pidof sleep

9\. Display only those two `sleep` processes in `top`. Then quit top.

    top -p pidx,pidy (replace pidx pidy with the actual numbers)

10\. Use a `standard kill` to kill one of the `sleep` processes.

    kill pidx

11\. Use one command to kill all `sleep` processes.

    pkill sleep
