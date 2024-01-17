# displaying memory and cache

## /proc/meminfo

Displaying `/proc/meminfo` will tell you a lot about the
memory on your Linux computer.

    paul@ubu1010:~$ cat /proc/meminfo 
    MemTotal:        3830176 kB
    MemFree:          244060 kB
    Buffers:           41020 kB
    Cached:          2035292 kB
    SwapCached:         9892 kB
    ...

The first line contains the total amount of physical RAM, the second
line is the unused RAM. `Buffers` is RAM used for buffering files,
`cached` is the amount of RAM used as cache and `SwapCached` is the
amount of swap used as cache. The file gives us much more information
outside of the scope of this course.

## free

The `free` tool can display the information provided by
`/proc/meminfo` in a more readable format. The example below displays
brief memory information in megabytes.

    paul@ubu1010:~$ free -om
               total       used       free     shared    buffers     cached
    Mem:        3740       3519        221          0         42       1994
    Swap:       6234         82       6152

## top

The `top` tool is often used to look at processes
consuming most of the cpu, but it also displays memory information on
line four and five (which can be toggled by pressing `m`).

Below a screenshot of top on the same ubu1010 from above.

    top - 10:44:34 up 16 days, 9:56, 6 users, load average: 0.13, 0.09, 0.12
    Tasks: 166 total,   1 running, 165 sleeping,   0 stopped,   0 zombie
    Cpu(s):  5.1%us, 4.6%sy, 0.6%ni, 88.7%id, 0.8%wa, 0.0%hi, 0.3%si, 0.0%st
    Mem:   3830176k total,  3613720k used,   216456k free,    45452k buffers
    Swap:  6384636k total,    84988k used,  6299648k free,  2050948k cached

# managing swap space

## about swap space

When the operating system needs more memory than physically present in
RAM, it can use `swap space`. Swap space is located on
slower but cheaper memory. Notice that, although hard disks are commonly
used for swap space, their access times are one hundred thousand times
slower.

The swap space can be a file, a partition, or a combination of files and
partitions. You can see the swap space with the `free` command, or with
`cat /proc/swaps`.

    paul@ubu1010:~$ free -o | grep -v Mem
               total       used       free     shared    buffers     cached
    Swap:    6384636      84988    6299648
    paul@ubu1010:~$ cat /proc/swaps
    Filename                Type            Size     Used   Priority
    /dev/sda3               partition       6384636  84988  -1

The amount of swap space that you need depends heavily on the services
that the computer provides.

## creating a swap partition

You can activate or deactivate swap space with the
`swapon` and `swapoff` commands. New swap
space can be created with the `mkswap` command. The
screenshot below shows the creation and activation of a swap partition.

    root@RHELv8u4:~# fdisk -l 2> /dev/null | grep hda
    Disk /dev/hda: 536 MB, 536870912 bytes
    /dev/hda1               1        1040      524128+  83  Linux
    root@RHELv8u4:~# mkswap /dev/hda1
    Setting up swapspace version 1, size = 536702 kB
    root@RHELv8u4:~# swapon /dev/hda1

Now you can see that `/proc/swaps` displays all swap spaces separately,
whereas the `free -om` command only makes a human readable summary.

    root@RHELv8u4:~# cat /proc/swaps
    Filename                          Type         Size    Used    Priority
    /dev/mapper/VolGroup00-LogVol01   partition    1048568 0       -1
    /dev/hda1                         partition    524120  0       -2
    root@RHELv8u4:~# free -om
              total     used    free   shared    buffers    cached
    Mem:        249      245       4        0        125        54
    Swap:      1535        0    1535

## creating a swap file

Here is one more example showing you how to create a `swap file`. On
Solaris you can use `mkfile` instead of
`dd`.

    root@RHELv8u4:~# dd if=/dev/zero of=/smallswapfile bs=1024 count=4096
    4096+0 records in
    4096+0 records out
    root@RHELv8u4:~# mkswap /smallswapfile 
    Setting up swapspace version 1, size = 4190 kB
    root@RHELv8u4:~# swapon /smallswapfile 
    root@RHELv8u4:~# cat /proc/swaps 
    Filename                          Type        Size    Used   Priority
    /dev/mapper/VolGroup00-LogVol01   partition   1048568 0      -1
    /dev/hda1                         partition   524120  0      -2
    /smallswapfile                    file        4088    0      -3

## swap space in /etc/fstab

If you like these swaps to be permanent, then don\'t forget to add them
to `/etc/fstab`. The lines in /etc/fstab will be similar
to the following.

    /dev/hda1         swap       swap     defaults      0 0
    /smallswapfile    swap       swap     defaults      0 0

# monitoring memory with vmstat

You can find information about `swap usage` using
`vmstat`.

Below a simple `vmstat` displaying information in megabytes.

    paul@ubu1010:~$ vmstat -S m
    procs ---------memory-------- ---swap-- -----io---- -system- ----cpu----
     r  b  swpd  free  buff cache  si   so   bi    bo    in   cs us sy id wa
     0  0    87   225    46  2097   0    0    2     5    14    8  6  5 89  1

Below a sample `vmstat` when (in another terminal) root launches a
`find /`. It generates a lot of disk i/o (bi and bo are disk blocks in
and out). There is no need for swapping here.

    paul@ubu1010:~$ vmstat 2 100
    procs ----------memory---------- ---swap-- -----io---- -system-- ----cpu----
     r  b   swpd   free  buff  cache   si   so    bi    bo   in   cs us sy id wa
     0  0  84984 1999436 53416 269536   0    0     2     5    2   10  6  5 89  1
     0  0  84984 1999428 53416 269564   0    0     0     0 1713 2748  4  4 92  0
     0  0  84984 1999552 53416 269564   0    0     0     0 1672 1838  4  6 90  0
     0  0  84984 1999552 53424 269560   0    0     0    14 1587 2526  5  7 87  2
     0  0  84984 1999180 53424 269580   0    0     0   100 1748 2193  4  6 91  0
     1  0  84984 1997800 54508 269760   0    0   610     0 1836 3890 17 10 68  4
     1  0  84984 1994620 55040 269748   0    0   250   168 1724 4365 19 17 56  9
     0  1  84984 1978508 55292 269704   0    0   126     0 1957 2897 19 18 58  4
     0  0  84984 1974608 58964 269784   0    0  1826   478 2605 4355  7  7 44 41
     0  2  84984 1971260 62268 269728   0    0  1634   756 2257 3865  7  7 47 39

Below a sample `vmstat` when executing (on RHEL6) a simple memory
leaking program. Now you see a lot of memory being swapped (si is
\'swapped in\').

    [paul@rhel6c ~]$ vmstat 2 100

    procs ----------memory-------- ---swap-- ----io---- --system-- -----cpu-----
     r  b   swpd  free  buff cache   si   so   bi    bo   in   cs us sy id wa st
     0  3 245208  5280   232  1916  261    0    0    42   27   21  0  1 98  1  0
     0  2 263372  4800    72   908 143840  128  0  1138  462  191  2 10  0 88  0
     1  3 350672  4792    56   992 169280  256  0  1092  360  142  1 13  0 86  0
     1  4 449584  4788    56  1024 95880   64   0   606  471  191  2 13  0 85  0
     0  4 471968  4828    56  1140 44832   80   0   390  235   90  2 12  0 87  0
     3  5 505960  4764    56  1136 68008   16   0   538  286  109  1 12  0 87  0

The code below was used to simulate a memory leak (and force swapping).
This code was found on wikipedia without author.

    paul@mac:~$ cat memleak.c 
    #include <stdlib.h>
     
    int main(void)
    {
         while (malloc(50));
         return 0;
    }
