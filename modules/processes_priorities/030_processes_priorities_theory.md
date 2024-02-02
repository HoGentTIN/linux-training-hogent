## priority and nice values

### introduction

All processes have a `priority` and a `nice` value. Higher
priority processes will get more `cpu time` than lower priority
processes. You can influence this with the `nice` and
`renice` commands.

### pipes (mkfifo)

Processes can communicate with each other via `pipes`.
These `pipes` can be created with the `mkfifo` command.

The screenshots shows the creation of four distinct pipes (in a new
directory).

    paul@ubuntu910:~$ mkdir procs
    paul@ubuntu910:~$ cd procs/
    paul@ubuntu910:~/procs$ mkfifo pipe33a pipe33b pipe42a pipe42b
    paul@ubuntu910:~/procs$ ls -l
    total 0
    prw-r--r-- 1 paul paul 0 2010-04-12 13:21 pipe33a
    prw-r--r-- 1 paul paul 0 2010-04-12 13:21 pipe33b
    prw-r--r-- 1 paul paul 0 2010-04-12 13:21 pipe42a
    prw-r--r-- 1 paul paul 0 2010-04-12 13:21 pipe42b
    paul@ubuntu910:~/procs$
            

### some fun with cat

To demonstrate the use of the `top` and `renice` commands we will make
the `cat` command use the previously created `pipes` to generate a full
load on the `cpu`.

The `cat` is copied with a distinct name to the current directory. (This
enables us to easily recognize the processes within `top`. You could do
the same exercise without copying the cat command, but using different
users. Or you could just look at the `pid` of each process.)

    paul@ubuntu910:~/procs$ cp /bin/cat proj33
    paul@ubuntu910:~/procs$ cp /bin/cat proj42
    paul@ubuntu910:~/procs$ echo -n x | ./proj33 - pipe33a > pipe33b &
    [1] 1670
    paul@ubuntu910:~/procs$ ./proj33 <pipe33b >pipe33a &
    [2] 1671
    paul@ubuntu910:~/procs$ echo -n z | ./proj42 - pipe42a > pipe42b &
    [3] 1673
    paul@ubuntu910:~/procs$ ./proj42 <pipe42b >pipe42a &
    [4] 1674
            

The commands you see above will create two `proj33` processes that use
`cat` to bounce the x character between `pipe33a` and `pipe33b`. And
ditto for the z character and `proj42`.

### top

Just running `top` without options or arguments will display all
processes and an overview of innformation. The top of the `top` screen
might look something like this.

    top - 13:59:29 up 48 min,  4 users,  load average: 1.06, 0.25, 0.14
    Tasks: 139 total,   3 running, 136 sleeping,   0 stopped,   0 zombie
    Cpu(s):  0.3%us, 99.7%sy, 0.0%ni, 0.0%id, 0.0%wa, 0.0%hi, 0.0%si, 0.0%st
    Mem:    509352k total,   460040k used,    49312k free,    66752k buffers
    Swap:   746980k total,        0k used,   746980k free,   247324k cached
            

Notice the `cpu idle time (0.0%id)` is zero. This is because our `cat`
processes are consuming the whole `cpu`. Results can vary on systems
with four or more `cpu cores`.

### top -p

The `top -p 1670,1671,1673,1674` screenshot below shows four processes,
all of then using approximately 25 percent of the `cpu`.

    paul@ubuntu910:~$ top -p 1670,1671,1673,1674

      PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
     1674 paul      20   0  2972  616  524 S 26.6  0.1   0:11.92 proj42
     1670 paul      20   0  2972  616  524 R 25.0  0.1   0:23.16 proj33
     1671 paul      20   0  2972  616  524 S 24.6  0.1   0:23.07 proj33
     1673 paul      20   0  2972  620  524 R 23.0  0.1   0:11.48 proj42
            

All four processes have an equal `priority (PR)`, and are battling for
`cpu time`. On some systems the `Linux kernel` might attribute slightly
varying `priority values`, but the result will still be four processes
fighting for `cpu time`.

### renice

Since the processes are already running, we need to use the
`renice` command to change their `nice value (NI)`.

The screenshot shows how to use `renice` on both the `proj33` processes.

    paul@ubuntu910:~$ renice +8 1670
    1670: old priority 0, new priority 8
    paul@ubuntu910:~$ renice +8 1671
    1671: old priority 0, new priority 8
            

Normal users can attribute a `nice value` from zero to 20 to processes
they own. Only the `root` user can use negative nice values. Be very
careful with negative nice values, since they can make it impossible to
use the keyboard or ssh to a system.

### impact of nice values

The impact of a nice value on running processes can vary. The screenshot
below shows the result of our `renice +8` command. Look at the `%CPU`
values.

      PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
     1674 paul      20   0  2972  616  524 S 46.6  0.1   0:22.37 proj42
     1673 paul      20   0  2972  620  524 R 42.6  0.1   0:21.65 proj42
     1671 paul      28   8  2972  616  524 S  5.7  0.1   0:29.65 proj33
     1670 paul      28   8  2972  616  524 R  4.7  0.1   0:29.82 proj33
            

Important to remember is to always make less important processes nice to
more important processes. Using `negative nice values` can have a severe
impact on a system\'s usability.

### nice

The `nice` works identical to the `renice` but it is used
when starting a command.

The screenshot shows how to start a script with a `nice` value of five.

    paul@ubuntu910:~$ nice -5 ./backup.sh
            
