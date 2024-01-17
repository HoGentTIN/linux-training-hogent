# terminology

## process

A `process` is compiled source code that is currently
running on the system.

## PID

All processes have a `process id` or `PID`.

## PPID

Every process has a parent process (with a `PPID`). The
`child` process is often started by the `parent` process.

## init

The `init` process always has process ID 1. The `init`
process is started by the `kernel` itself so technically it does not
have a parent process. `init` serves as a `foster parent` for `orphaned`
processes.

## kill

When a process stops running, the process dies, when you want a process
to die, you `kill` it.

## daemon

Processes that start at system startup and keep running forever are
called `daemon` processes or `daemons`. These `daemons`
never die.

## zombie

When a process is killed, but it still shows up on the system, then the
process is referred to as `zombie`. You cannot kill
zombies, because they are already dead.

# basic process management

## \$\$ and \$PPID

Some shell environment variables contain information about processes.
The `$$` variable will hold your current `process ID`, and
`$PPID` contains the `parent PID`. Actually `$$` is a
shell parameter and not a variable, you cannot assign a value to it.

Below we use `echo` to display the values of `$$` and
`$PPID`.

    [paul@RHEL8b ~]$ echo $$ $PPID
    4224 4223
            

## pidof

You can find all process id\'s by name using the `pidof`
command.

    root@rhel53 ~# pidof mingetty
    2819 2798 2797 2796 2795 2794
            

## parent and child

Processes have a `parent-child` relationship. Every process has a parent
process.

When starting a new `bash` you can use `echo` to verify that the `pid`
from before is the `ppid` of the new shell. The `child` process from
above is now the `parent` process.

    [paul@RHEL8b ~]$ bash
    [paul@RHEL8b ~]$ echo $$ $PPID
    4812 4224
            

Typing `exit` will end the current process and brings us back to our
original values for `$$` and `$PPID`.

    [paul@RHEL8b ~]$ echo $$ $PPID
    4812 4224
    [paul@RHEL8b ~]$ exit
    exit
    [paul@RHEL8b ~]$ echo $$ $PPID
    4224 4223
    [paul@RHEL8b ~]$
            

## fork and exec

A process starts another process in two phases. First the process
creates a `fork` of itself, an identical copy. Then the
forked process executes an `exec` to replace the forked
process with the target child process.

    [paul@RHEL8b ~]$ echo $$
    4224
    [paul@RHEL8b ~]$ bash
    [paul@RHEL8b ~]$ echo $$ $PPID
    5310 4224
    [paul@RHEL8b ~]$
            

## exec

With the `exec` command, you can execute a process without forking a new
process. In the following screenshot a `Korn shell` (ksh) is started and
is being replaced with a `bash shell` using the `exec` command. The
`pid` of the `bash shell` is the same as the `pid` of the `Korn shell`.
Exiting the child `bash shell` will get me back to the parent `bash`,
not to the `Korn shell` (which does not exist anymore).

    [paul@RHEL8b ~]$ echo $$
    4224                                # PID of bash
    [paul@RHEL8b ~]$ ksh
    $ echo $$ $PPID
    5343 4224                           # PID of ksh and bash
    $ exec bash
    [paul@RHEL8b ~]$ echo $$ $PPID
    5343 4224                           # PID of bash and bash
    [paul@RHEL8b ~]$ exit
    exit
    [paul@RHEL8b ~]$ echo $$
    4224
            

## ps

One of the most common tools on Linux to look at processes is
`ps`. The following screenshot shows the parent child
relationship between three bash processes.

    [paul@RHEL8b ~]$ echo $$ $PPID
    4224 4223
    [paul@RHEL8b ~]$ bash
    [paul@RHEL8b ~]$ echo $$ $PPID
    4866 4224
    [paul@RHEL8b ~]$ bash
    [paul@RHEL8b ~]$ echo $$ $PPID
    4884 4866
    [paul@RHEL8b ~]$ ps fx
      PID TTY      STAT   TIME COMMAND
     4223 ?        S      0:01 sshd: paul@pts/0 
     4224 pts/0    Ss     0:00  \_ -bash
     4866 pts/0    S      0:00      \_ bash
     4884 pts/0    S      0:00          \_ bash
     4902 pts/0    R+     0:00              \_ ps fx
    [paul@RHEL8b ~]$ exit
    exit
    [paul@RHEL8b ~]$ ps fx
      PID TTY      STAT   TIME COMMAND
     4223 ?        S      0:01 sshd: paul@pts/0 
     4224 pts/0    Ss     0:00  \_ -bash
     4866 pts/0    S      0:00      \_ bash
     4903 pts/0    R+     0:00          \_ ps fx
    [paul@RHEL8b ~]$ exit
    exit
    [paul@RHEL8b ~]$ ps fx
      PID TTY      STAT   TIME COMMAND
     4223 ?        S      0:01 sshd: paul@pts/0 
     4224 pts/0    Ss     0:00  \_ -bash
     4904 pts/0    R+     0:00      \_ ps fx
    [paul@RHEL8b ~]$        

On Linux, `ps fax` is often used. On Solaris
`ps -ef` (which also works on Linux) is common. Here is a
partial output from `ps fax`.

    [paul@RHEL8a ~]$ ps fax
    PID TTY      STAT   TIME COMMAND
    1 ?        S      0:00 init [5]

    ...

    3713 ?        Ss     0:00 /usr/sbin/sshd
    5042 ?        Ss     0:00  \_ sshd: paul [priv]
    5044 ?        S      0:00      \_ sshd: paul@pts/1 
    5045 pts/1    Ss     0:00          \_ -bash
    5077 pts/1    R+     0:00              \_ ps fax
            

## pgrep

Similar to the `ps -C`, you can also use `pgrep` to search
for a process by its command name.

    [paul@RHEL5 ~]$ sleep 1000 &
    [1] 32558
    [paul@RHEL5 ~]$ pgrep sleep
    32558
    [paul@RHEL5 ~]$ ps -C sleep
      PID TTY          TIME CMD
    32558 pts/3    00:00:00 sleep
            

You can also list the command name of the process with pgrep.

    paul@laika:~$ pgrep -l sleep
    9661 sleep
            

## top

Another popular tool on Linux is `top`. The `top` tool can
order processes according to `cpu usage` or other properties. You can
also `kill` processes from within top. Press `h` inside `top` for help.

In case of trouble, top is often the first tool to fire up, since it
also provides you memory and swap space information.

# signalling processes

## kill

The `kill` command will kill (or stop) a process. The
screenshot shows how to use a standard `kill` to stop the process with
`pid` 1942.

    paul@ubuntu910:~$ kill 1942
    paul@ubuntu910:~$
            

By using the `kill` we are sending a `signal` to the process.

## list signals

Running processes can receive signals from each other or from the users.
You can have a list of signals by typing `kill -l`, that
is a letter `l`, not the number 1.

    [paul@RHEL8a ~]$ kill -l
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
    [paul@RHEL8a ~]$ 
            

## kill -1 (SIGHUP)

It is common on Linux to use the first signal `SIGHUP` (or
HUP or 1) to tell a process that it should re-read its configuration
file. Thus, the `kill -1 1` command forces the `init` process (`init`
always runs with `pid 1`) to re-read its configuration file.

    root@deb106:~# kill -1 1
    root@deb106:~#
            

It is up to the developer of the process to decide whether the process
can do this running, or whether it needs to stop and start. It is up to
the user to read the documentation of the program.

## kill -15 (SIGTERM)

The `SIGTERM` signal is also called a `standard kill`. Whenever `kill`
is executed without specifying the signal, a `kill -15` is assumed.

Both commands in the screenshot below are identical.

    paul@ubuntu910:~$ kill 1942
    paul@ubuntu910:~$ kill -15 1942
            

## kill -9 (SIGKILL)

The `SIGKILL` is different from most other signals in that it is not
being sent to the process, but to the `Linux kernel`. A `kill -9` is
also called a `sure kill`. The `kernel` will shoot down the process. As
a developer you have no means to intercept a `kill -9` signal.

    root@rhel53 ~# kill -9 3342
            

## SIGSTOP and SIGCONT

A running process can be `suspended` when it receives a `SIGSTOP`
signal. This is the same as `kill -19` on Linux, but might have a
different number in other Unix systems.

A `suspended` process does not use any `cpu cycles`, but it stays in
memory and can be re-animated with a `SIGCONT` signal (`kill -18` on
Linux).

Both signals will be used in the section about `background` processes.

## pkill

You can use the `pkill` command to kill a process by its
command name.

    [paul@RHEL5 ~]$ sleep 1000 &
    [1] 30203
    [paul@RHEL5 ~]$ pkill sleep
    [1]+  Terminated              sleep 1000
    [paul@RHEL5 ~]$ 
            

## killall

The `killall` command will send a
`signal 15` to all processes with a certain name.

    paul@rhel65:~$ sleep 8472 &
    [1] 18780
    paul@rhel65:~$ sleep 1201 &
    [2] 18781
    paul@rhel65:~$ jobs
    [1]-  Running                 sleep 8472 &
    [2]+  Running                 sleep 1201 &
    paul@rhel65:~$ killall sleep
    [1]-  Terminated              sleep 8472
    [2]+  Terminated              sleep 1201
    paul@rhel65:~$ jobs
    paul@rhel65:~$

## killall5

Its SysV counterpart `killall5` can by used when shutting down the
system. This screenshot shows how Red Hat Enterprise Linux 5.3 uses
`killall5` when halting the system.

    root@rhel53 ~# grep killall /etc/init.d/halt
    action $"Sending all processes the TERM signal..." /sbin/killall5 -15
    action $"Sending all processes the KILL signal..."  /sbin/killall5 -9

## top

Inside `top` the `k` key allows you to select a `signal`
and `pid` to kill. Below is a partial screenshot of the line just below
the summary in `top` after pressing `k`.

    PID to kill: 1932

    Kill PID 1932 with signal [15]: 9
