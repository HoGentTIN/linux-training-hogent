# Introduction to processes

## process


A **process** is a piece of machine code that is running on one or more
CPU’s. A program becomes a **process** when it is executed. There are
several processes running on your Debian Linux system. In this chapter
we will take a look at the terminology around processes and how to
identify them.

## /proc


All processes are listed as a directory in **/proc**. Each number
represents a process, there are 92 processes running in this screenshot.

    paul@debian10:~$ ls /proc
    1    132  205  3    389  453  80           fb           loadavg       stat
    10   14   206  30   39   454  9            filesystems  locks         swaps
    11   15   21   31   391  46   acpi         fs           meminfo       sys
    116  16   22   32   392  462  buddyinfo    interrupts   misc          sysrq-trigger
    119  17   23   33   4    463  bus          iomem        modules       sysvipc
    12   171  239  34   40   467  cgroups      ioports      mounts        thread-self
    122  173  24   341  41   5    cmdline      irq          mtrr          timer_list
    123  175  25   342  418  6    consoles     kallsyms     net           tty
    124  177  257  35   42   61   cpuinfo      kcore        pagetypeinfo  uptime
    125  18   26   36   43   65   crypto       keys         partitions    version
    126  19   269  361  432  66   devices      key-users    sched_debug   vmallocinfo
    127  2    27   37   439  67   diskstats    kmsg         schedstat     vmstat
    129  20   28   38   44   7    dma          kpagecgroup  self          zoneinfo
    13   200  283  386  45   76   driver       kpagecount   slabinfo
    131  203  29   388  450  8    execdomains  kpageflags   softirqs
    paul@debian10:~$

## PID and pidof


Every process on Debian Linux gets a unique **process identifier** or
**PID**. This **PID** stays the same during the lifetime of the process.
The **PID** is visible as a directory in **/proc**. The **PID** of a
program can be found with the **pidof** command. For example the **PID**
of the current bash shell is displayed when typing **pidof bash** or
when executing **echo $$**.

    paul@debian10:~$ pidof bash
    463
    paul@debian10:~$ echo $$
    463
    paul@debian10:~$

If you get more than one number after **pidof bash** then there are more
**bash shells** running on the computer.

## PPID


Every process also has a **parent process identifier** or **PPID**. This
means that each process has a parent process, and that all processes are
organised in a tree. The **PPID** of the current bash shell is displayed
when echoing **$PPID**.

    paul@debian10:~$ echo $PPID
    462
    paul@debian10:~$

## init


Every process has a parent process, except **init** because **init** has
**PID 1**. The **init** process is the very first process that is
started by the kernel, at boot time. It is **init**'s job then to start
other processes.

    paul@debian10:~$ pidof init
    1
    paul@debian10:~$

## ps


The **ps** command, short for **process snapshot**, can display
information about some or all processes running on the system. Here we
ask for all processes with **ps -ef**, but we **grep** for our bash
shell’s **PID**.

    paul@debian10:~$ ps -ef | head -1
    UID        PID  PPID  C STIME TTY          TIME CMD
    paul@debian10:~$ ps -ef | grep $$
    paul       463   462  0 11:36 pts/0    00:00:00 -bash
    paul       469   463  0 11:38 pts/0    00:00:00 ps -ef
    paul       470   463  0 11:38 pts/0    00:00:00 grep 463
    paul@debian10:~$

We see the bash shell running with **PID** 463, and having a **PPID** of
462. We also see the **ps -ef** running with **PID** 469, having the
bash shell as parent. And at the same time the **grep $$** is running as
**grep 463** (remember shell expansion).

## daemon


Some processes are started when the system is starting, and continue to
run forever, or until the system shuts down. These processes are called
**daemon** processes or **daemons**. For example when using **ssh** to
connect to a computer, you make contact with **sshd**, which is the
**secure shell daemon**.

    paul@debian10:~$ ps -ef | grep ssh
    root       432     1  0 11:36?        00:00:00 /usr/sbin/sshd -D
    root       450   432  0 11:36?        00:00:00 sshd: paul [priv]
    paul       462   450  0 11:36?        00:00:00 sshd: paul@pts/0
    paul       472   463  0 11:39 pts/0    00:00:00 grep ssh
    paul@debian10:~$

In the screenshot above we see **sshd** running with PID 432, having PID
1 as parent. This is the **ssh daemon**. Further we see another **sshd**
process running with PID 462 having a connection with **paul@pts/0**.
This last one will disappear when logging out of the computer.

## kill


They say a process **dies** when it is no longer running. And to
communicate with a process, we use the **kill** command. The next
chapter is about the **kill** command.

## zombie


When a process dies, but something still remains in **/proc**, then we
call this a **zombie process**. **Zombies** take no resources and take
no CPU time, so you generally do not have to worry about them. Unless
there are many **zombies**. Also, you cannot **kill** a **zombie**
because it is already dead.

## fork - exec

A new process is created by a **fork** (copy) of an existing process,
usually followed by an **exec** of a program in that new process. When
you use the **exec** command, then you replace a process with a new
program.

If you use **exec** in the bash shell, for example with **cp** then the
shell will be replaced with **cp**. The **bash shell** effectively
ceases to exist when executing **exec cp**.

    paul@debian10:~$ exec cp dates.txt dates2.txt
    Connection to 192.168.56.101 closed.

The copy of dates.txt to dates2.txt happens, then the **cp** command
ends and there is no **bash** to return to.

## ps fax

All processes together form a tree with **init** at the top. You can see
the whole tree using **ps fax**. In the screenshot below we see part of
the tree, for example **ps fax** and **tail -8** are child processes of
**bash**.

    paul@debian10:~$ ps fax | tail -8
      432?        Ss     0:00 /usr/sbin/sshd -D
      543?        Ss     0:00  \_ sshd: paul [priv]
      558?        S      0:00      \_ sshd: paul@pts/0
      559 pts/0    Ss     0:00          \_ -bash
      613 pts/0    R+     0:00              \_ ps fax
      614 pts/0    S+     0:00              \_ tail -8
      547?        Ss     0:00 /lib/systemd/systemd --user
      549?        S      0:00  \_ (sd-pam)
    paul@debian10:~$

The **PID** of bash changed because we had to login again after the
**exec cp** command.

## top

The **top** command is a useful way to look at processes because **top**
will by default order the top processes that use most of the CPU. It
also tells you how many processes are active as **Tasks:** and how many
**zombies** there are. (Together with memory information which we see in
a later chapter.)

The **top** command can be stopped using the **q** key or by typing
**Ctrl-c**.

    paul@debian10:~$ top
    top - 13:08:38 up  1:32,  1 user,  load average: 0.00, 0.00, 0.00
    Tasks:  86 total,   1 running,  85 sleeping,   0 stopped,   0 zombie
    %Cpu(s):  0.0 us,  1.6 sy,  0.0 ni, 98.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
    MiB Mem :    987.0 total,    834.9 free,     73.9 used,     78.2 buff/cache
    MiB Swap:   1022.0 total,   1022.0 free,      0.0 used.    802.9 avail Mem

      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
        1 root      20   0   21860   9776   7724 S   0.0   1.0   0:01.10 systemd
        2 root      20   0       0      0      0 S   0.0   0.0   0:00.00 kthreadd
        3 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_gp
        4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_par_gp
        6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/0:0H-kblockd
        8 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 mm_percpu_wq
        9 root      20   0       0      0      0 S   0.0   0.0   0:00.00 ksoftirqd/0
       10 root      20   0       0      0      0 I   0.0   0.0   0:02.38 rcu_sched
       11 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_bh
       12 root      rt   0       0      0      0 S   0.0   0.0   0:00.03 migration/0
       13 root      20   0       0      0      0 I   0.0   0.0   0:04.34 kworker/0:1-events
       14 root      20   0       0      0      0 S   0.0   0.0   0:00.00 cpuhp/0
       15 root      20   0       0      0      0 S   0.0   0.0   0:00.00 cpuhp/1
       16 root      rt   0       0      0      0 S   0.0   0.0   0:00.03 migration/1
    paul@debian10:~$

Looking at **PID 1** which is it now, **init** or **systemd**? The
answer lies in the **/sbin/init** command. Debian 10 uses **systemd**,
which has its own chapter.

    paul@debian10:~$ file /sbin/init
    /sbin/init: symbolic link to /lib/systemd/systemd
    paul@debian10:~$

## ps -eo

With **ps -eo** you can select which fields you want to see in the
output of the **ps** command. For example in this screenshot we ask for
the **PID**, the **CMD** (the command, with arguments, that was used to
start this process) and the **COMMAND** (the binary that is actually
running). All fields are explained in **man ps**, under STANDARD FORMAT
SPECIFIERS.

    paul@debian10:~$ ps -eo pid,cmd,comm | head -2
      PID CMD                         COMMAND
        1 /sbin/init                  systemd
    paul@debian10:~$

## Cheat sheet

<table>
<caption>Processes terminology</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>term</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>PID</p></td>
<td style="text-align: left;"><p>Process Identification or Process
ID.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>PPID</p></td>
<td style="text-align: left;"><p>Parent PID.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>daemon</p></td>
<td style="text-align: left;"><p>A <em>guardian angel</em> process that
never dies.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>die</p></td>
<td style="text-align: left;"><p>What a process does when it no longer
exists.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>zombie</p></td>
<td style="text-align: left;"><p>A process that was killed, but
something still remains in /proc.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/proc</p></td>
<td style="text-align: left;"><p>A directory where all processes have a
directory.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>fork</p></td>
<td style="text-align: left;"><p>All processes are created as a fork
(copy) of an existing process (except init).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/sbin/init</p></td>
<td style="text-align: left;"><p>The process with PID 1.</p></td>
</tr>
</tbody>
</table>

Processes terminology

<table>
<caption>Processes commands</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>pidof foo</p></td>
<td style="text-align: left;"><p>Gives the PID of
<strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>echo $$</p></td>
<td style="text-align: left;"><p>Gives the PID of the current bash
shell.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>echo $PPID</p></td>
<td style="text-align: left;"><p>Gives the PPID of the current bash
shell.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ps -ef</p></td>
<td style="text-align: left;"><p>Display a list of all
processes.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ps fax</p></td>
<td style="text-align: left;"><p>Display a list of all
processes.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ps -eo</p></td>
<td style="text-align: left;"><p>A custom display of all
processes.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>kill</p></td>
<td style="text-align: left;"><p>A tool to communicate with processes or
the kernel.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>top</p></td>
<td style="text-align: left;"><p>A tool that displays system info and a
list of processes.</p></td>
</tr>
</tbody>
</table>

Processes commands

## Practice

1.  Issue a **cat /proc/1/cmdline** to see the command that started the
    first process on this computer.

2.  What type of file is this command from question 1.?

3.  Display the **PID** of your bash shell.

4.  Display the **PID** of all bash shells.

5.  Look at the complete process tree, page by page.

6.  Are there any zombies on your computer?

7.  Press **h** when in top to get some help on shortcuts in top. Can
    you sort the list by memory usage?

## Solution

1.  Issue a **cat /proc/1/cmdline** to see the command that started the
    first process on this computer.

        cat /proc/1/cmdline

2.  What type of file is this command from question 1.?

        ls -l /sbin/init

    or

        file /sbin/init

    or

        ls -l $(cat /proc/1/cmdline)
        file $(cat /proc/1/cmdline)

3.  Display the **PID** of your bash shell.

        echo $$

4.  Display the **PID** of all bash shells.

        pidof bash

5.  Look at the complete process tree, page by page.

        ps fax | more
        ps -ef | more

6.  Are there any zombies on your computer?

        top

7.  Press **h** when in top to get some help on shortcuts in top. Can
    you sort the list by memory usage?

        >
