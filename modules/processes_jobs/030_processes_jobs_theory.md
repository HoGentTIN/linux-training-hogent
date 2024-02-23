## background processes

### jobs

Stuff that runs in background of your current shell can be displayed
with the `jobs` command. By default you will not have any
`jobs` running in background.

    root@linux ~# jobs
    root@linux ~#
            

This `jobs` command will be used several times in this section.

### control-Z

Some processes can be `suspended` with the `Ctrl-Z` key
combination. This sends a `SIGSTOP` signal to the `Linux kernel`,
effectively freezing the operation of the process.

When doing this in `vi(m)`, then `vi(m)` goes to the background. The
background `vi(m)` can be seen with the `jobs` command.

    [student@linux ~]$ vi procdemo.txt

    [5]+  Stopped                 vim procdemo.txt
    [student@linux ~]$ jobs
    [5]+  Stopped                 vim procdemo.txt
            

### & ampersand

Processes that are started in background using the `&` character at the
end of the command line are also visible with the `jobs` command.

    [student@linux ~]$ find / > allfiles.txt 2> /dev/null &
    [6] 5230
    [student@linux ~]$ jobs
    [5]+  Stopped                 vim procdemo.txt
    [6]-  Running                 find / >allfiles.txt 2>/dev/null &
    [student@linux ~]$
            

### jobs -p

An interesting option is `jobs -p` to see the `process id` of background
processes.

    [student@linux ~]$ sleep 500 &
    [1] 4902
    [student@linux ~]$ sleep 400 &
    [2] 4903
    [student@linux ~]$ jobs -p
    4902
    4903
    [student@linux ~]$ ps `jobs -p`
      PID TTY      STAT   TIME COMMAND
     4902 pts/0    S      0:00 sleep 500
     4903 pts/0    S      0:00 sleep 400
    [student@linux ~]$
            

### fg

Running the `fg` command will bring a background job to
the foreground. The number of the background job to bring forward is the
parameter of `fg`.

    [student@linux ~]$ jobs
    [1]   Running                 sleep 1000 &
    [2]-  Running                 sleep 1000 &
    [3]+  Running                 sleep 2000 &
    [student@linux ~]$ fg 3
    sleep 2000
            

### bg

Jobs that are `suspended` in background can be started in background
with `bg`. The `bg` will send a `SIGCONT` signal.

Below an example of the sleep command (suspended with `Ctrl-Z`) being
reactivated in background with `bg`.

    [student@linux ~]$ jobs
    [student@linux ~]$ sleep 5000 &
    [1] 6702
    [student@linux ~]$ sleep 3000

    [2]+  Stopped                 sleep 3000
    [student@linux ~]$ jobs
    [1]-  Running                 sleep 5000 &
    [2]+  Stopped                 sleep 3000
    [student@linux ~]$ bg 2
    [2]+ sleep 3000 &
    [student@linux ~]$ jobs
    [1]-  Running                 sleep 5000 &
    [2]+  Running                 sleep 3000 &
    [student@linux ~]$ 
            

