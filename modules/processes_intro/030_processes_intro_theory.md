## terminology

### process

A `process` is compiled source code that is currently running on the system.

### PID

All processes have a `process id` or `PID`.

### PPID

Every process has a parent process (with a `PPID`). The `child` process is often started by the `parent` process.

### init

The `init` process always has process ID 1. The `init` process is started by the `kernel` itself so technically it does not have a parent process. `init` serves as a `foster parent` for `orphaned` processes.

### kill

When a process stops running, the process dies, when you want a process to die, you `kill` it.

### daemon

Processes that start at system startup and keep running forever are called `daemon` processes or `daemons`. These `daemons` never die.

### zombie

When a process is killed, but it still shows up on the system, then the process is referred to as `zombie`. You cannot kill zombies, because they are already dead.

## basic process management

### `$$` and `$PPID`

Some shell environment variables contain information about processes. The `$$` variable will hold your current `process ID`, and `$PPID` contains the `parent PID`. Actually `$$` is a shell parameter and not a variable, you cannot assign a value to it.

Below we use `echo` to display the values of `$$` and `$PPID`.

```console
[student@linux ~]$ echo $$ $PPID
4224 4223
``` 

### pidof

You can find all process id's by name using the `pidof` command.

```console
root@linux ~# pidof mingetty
2819 2798 2797 2796 2795 2794
```

### parent and child

Processes have a `parent-child` relationship. Every process has a parent process.

When starting a new `bash` you can use `echo` to verify that the `pid` from before is the `ppid` of the new shell. The `child` process from above is now the `parent` process.

```console
[student@linux ~]$ bash
[student@linux ~]$ echo $$ $PPID
4812 4224
```        

Typing `exit` will end the current process and brings us back to our original values for `$$` and `$PPID`.

```console
[student@linux ~]$ echo $$ $PPID
4812 4224
[student@linux ~]$ exit
exit
[student@linux ~]$ echo $$ $PPID
4224 4223
[student@linux ~]$
```

### fork and exec

A process starts another process in two phases. First the process creates a `fork` of itself, an identical copy. Then the forked process executes an `exec` to replace the forked process with the target child process.

```console
[student@linux ~]$ echo $$
4224
[student@linux ~]$ bash
[student@linux ~]$ echo $$ $PPID
5310 4224
[student@linux ~]$
```
            
### exec

With the `exec` command, you can execute a process without forking a new process. In the following screenshot a `Korn shell` (ksh) is started and is being replaced with a `bash shell` using the `exec` command. The `pid` of the `bash shell` is the same as the `pid` of the `Korn shell`. Exiting the child `bash shell` will get me back to the parent `bash`, not to the `Korn shell` (which does not exist anymore).

```console
[student@linux ~]$ echo $$
4224                                # PID of bash
[student@linux ~]$ ksh
$ echo $$ $PPID
5343 4224                           # PID of ksh and bash
$ exec bash
[student@linux ~]$ echo $$ $PPID
5343 4224                           # PID of bash and bash
[student@linux ~]$ exit
exit
[student@linux ~]$ echo $$
4224
```

### ps

One of the most common tools on Linux to look at processes is `ps`. The following screenshot shows the parent child relationship between three bash processes.

```console
[student@linux ~]$ echo $$ $PPID
4224 4223
[student@linux ~]$ bash
[student@linux ~]$ echo $$ $PPID
4866 4224
[student@linux ~]$ bash
[student@linux ~]$ echo $$ $PPID
4884 4866
[student@linux ~]$ ps fx
    PID TTY      STAT   TIME COMMAND
    4223 ?        S      0:01 sshd: student@pts/0 
    4224 pts/0    Ss     0:00  \_ -bash
    4866 pts/0    S      0:00      \_ bash
    4884 pts/0    S      0:00          \_ bash
    4902 pts/0    R+     0:00              \_ ps fx
[student@linux ~]$ exit
exit
[student@linux ~]$ ps fx
    PID TTY      STAT   TIME COMMAND
    4223 ?        S      0:01 sshd: student@pts/0 
    4224 pts/0    Ss     0:00  \_ -bash
    4866 pts/0    S      0:00      \_ bash
    4903 pts/0    R+     0:00          \_ ps fx
[student@linux ~]$ exit
exit
[student@linux ~]$ ps fx
    PID TTY      STAT   TIME COMMAND
    4223 ?        S      0:01 sshd: student@pts/0 
    4224 pts/0    Ss     0:00  \_ -bash
    4904 pts/0    R+     0:00      \_ ps fx
[student@linux ~]$        
```

On Linux, `ps fax` is often used. On Solaris `ps -ef` (which also works on Linux) is common. Here is a partial output from `ps fax`.

```console
[student@linux ~]$ ps fax
PID TTY      STAT   TIME COMMAND
1 ?        S      0:00 init [5]

...

3713 ?        Ss     0:00 /usr/sbin/sshd
5042 ?        Ss     0:00  \_ sshd: paul [priv]
5044 ?        S      0:00      \_ sshd: student@pts/1 
5045 pts/1    Ss     0:00          \_ -bash
5077 pts/1    R+     0:00              \_ ps fax
```

### pgrep

Similar to the `ps -C`, you can also use `pgrep` to search for a process by its command name.

```console
[student@linux ~]$ sleep 1000 &
[1] 32558
[student@linux ~]$ pgrep sleep
32558
[student@linux ~]$ ps -C sleep
    PID TTY          TIME CMD
32558 pts/3    00:00:00 sleep
```

You can also list the command name of the process with pgrep.

```console
student@linux:~$ pgrep -l sleep
9661 sleep
```
        
### top

Another popular tool on Linux is `top`. The `top` tool can order processes according to `cpu usage` or other properties. You can also `kill` processes from within top. Press `h` inside `top` for help.

In case of trouble, top is often the first tool to fire up, since it also provides you memory and swap space information.

## signalling processes

### kill

The `kill` command will kill (or stop) a process. The screenshot shows how to use a standard `kill` to stop the process with `pid` 1942.

```console
student@linux:~$ kill 1942
student@linux:~$
```

By using the `kill` we are sending a `signal` to the process.

### list signals

Running processes can receive signals from each other or from the users. You can have a list of signals by typing `kill -l`, that is a letter `l`, not the number 1.

```console
[student@linux ~]$ kill -l
1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL
5) SIGTRAP      6) SIGABRT      7) SIGBUS       8) SIGFPE
9) SIGKILL     10) SIGUSR1     11) SIGSEGV     12) SIGUSR2
13) SIGPIPE     14) SIGALRM     15) SIGTERM     17) SIGCHLD
18) SIGCONT     19) SIGSTOP     20) SIGTSTP     21) SIGTTIN
22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO
30) SIGPWR      31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1
36) SIGRTMIN+2  37) SIGRTMIN+3  38) SIGRTMIN+4  39) SIGRTMIN+5
40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8  43) SIGRTMIN+9
44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13
52) SIGRTMAX-12 53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9
56) SIGRTMAX-8  57) SIGRTMAX-7  58) SIGRTMAX-6  59) SIGRTMAX-5
60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2  63) SIGRTMAX-1
64) SIGRTMAX
[student@linux ~]$ 
```

### kill -1 (SIGHUP)

It is common on Linux to use the first signal `SIGHUP` (or HUP or 1) to tell a process that it should re-read its configuration file. Thus, the `kill -1 1` command forces the `init` process (`init` always runs with `pid 1`) to re-read its configuration file.

```console
root@linux:~# kill -1 1
root@linux:~#
```

It is up to the developer of the process to decide whether the process can do this running, or whether it needs to stop and start. It is up to the user to read the documentation of the program.

### kill -15 (SIGTERM)

The `SIGTERM` signal is also called a `standard kill`. Whenever `kill` is executed without specifying the signal, a `kill -15` is assumed.

Both commands in the screenshot below are identical.

```console
student@linux:~$ kill 1942
student@linux:~$ kill -15 1942
```

### kill -9 (SIGKILL)

The `SIGKILL` is different from most other signals in that it is not being sent to the process, but to the `Linux kernel`. A `kill -9` is also called a `sure kill`. The `kernel` will shoot down the process. As a developer you have no means to intercept a `kill -9` signal.

```console
root@linux ~# kill -9 3342
```

### SIGSTOP and SIGCONT

A running process can be `suspended` when it receives a `SIGSTOP` signal. This is the same as `kill -19` on Linux, but might have a different number in other Unix systems.

A `suspended` process does not use any `cpu cycles`, but it stays in memory and can be re-animated with a `SIGCONT` signal (`kill -18` on Linux).

Both signals will be used in the section about `background` processes.

### pkill

You can use the `pkill` command to kill a process by its command name.

```console
[student@linux ~]$ sleep 1000 &
[1] 30203
[student@linux ~]$ pkill sleep
[1]+  Terminated              sleep 1000
[student@linux ~]$ 
```

### killall

The `killall` command will send a `signal 15` to all processes with a certain name.

```console
student@linux:~$ sleep 8472 &
[1] 18780
student@linux:~$ sleep 1201 &
[2] 18781
student@linux:~$ jobs
[1]-  Running                 sleep 8472 &
[2]+  Running                 sleep 1201 &
student@linux:~$ killall sleep
[1]-  Terminated              sleep 8472
[2]+  Terminated              sleep 1201
student@linux:~$ jobs
student@linux:~$
```

### killall5

Its SysV counterpart `killall5` can by used when shutting down the system. This screenshot shows how Red Hat Enterprise Linux 5.3 uses `killall5` when halting the system.

```console
root@linux ~# grep killall /etc/init.d/halt
action $"Sending all processes the TERM signal..." /sbin/killall5 -15
action $"Sending all processes the KILL signal..."  /sbin/killall5 -9
```

### top

Inside `top` the `k` key allows you to select a `signal` and `pid` to kill. Below is a partial screenshot of the line just below the summary in `top` after pressing `k`.

```
PID to kill: 1932

Kill PID 1932 with signal [15]: 9
```


