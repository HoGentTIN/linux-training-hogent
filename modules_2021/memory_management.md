# Memory management

## About memory


Back when computers were 32-bit every application received 2GB (in some
cases 3 or 4GB) of virtual memory. Now with 64-bit computers
applications get many terabytes of virtual memory to use. This is
independent of how much physical memory is installed on the computer.
Linux will map the virtual addresses to physical addresses.

Each application has its own virtual memory and cannot access the
address space of another application.

### physical memory


Information about physical memory installed on a computer can only be
obtained on non-virtual machines. The screenshot here is from
**dmidecode** running on a laptop (since all my servers are virtual).
The laptop has two 8GB memory modules.

    root@MBDebian# dmidecode -t memory | grep -A1 Size
            Size: 8192 MB
            Form Factor: SODIMM
    --
            Size: 8192 MB
            Form Factor: SODIMM
    root@MBDebian#

### /proc/meminfo


Many tools will read memory information in **/proc/meminfo** and display
it in a nicer format. In the screenshot you can see that this server
named **debian10** has 4GB of RAM, of which most is unused.

    root@debian10:# grep Mem /proc/meminfo
    MemTotal:        4041188 kB
    MemFree:         3886672 kB
    MemAvailable:    3811160 kB
    root@debian10:#

### free


The **free** command here was run a bit later when the computer was
using 651MB of memory. The **-m** option is used to display megabytes,
you can use **-g** for gigabytes. This **free** command also gives a
summary on swap space.

    paul@debian10:$ free -m
                  total        used        free      shared  buff/cache   available
    Mem:           3946         651        3040           0         253        3084
    Swap:          1021           0        1021
    paul@debian10:$

### pmap


The **pmap** tool will give an overview of the memory map of a process.
In this example we display the memory map of our **bash shell**. If you
have a wide terminal then you can try -X or even -XX.

    root@debian10:# pmap -x $$ | head -20
    806:   -bash
    Address           Kbytes     RSS   Dirty Mode  Mapping
    0000562e9f5a9000     180     180       0 r---- bash
    0000562e9f5d6000     696     696       0 r-x-- bash
    0000562e9f684000     216     108       0 r---- bash
    0000562e9f6bb000      12      12      12 r---- bash
    0000562e9f6be000      36      36      36 rw--- bash
    0000562e9f6c7000      40      28      28 rw---   [ anon ]
    0000562e9fa8a000    1704    1564    1564 rw---   [ anon ]
    00007f7a18cf4000      24      24       0 r---- libpthread-2.28.so
    00007f7a18cfa000      60      60       0 r-x-- libpthread-2.28.so
    00007f7a18d09000      24       0       0 r---- libpthread-2.28.so
    00007f7a18d0f000       4       4       4 r---- libpthread-2.28.so
    00007f7a18d10000       4       4       4 rw--- libpthread-2.28.so
    00007f7a18d11000      16       4       4 rw---   [ anon ]
    00007f7a18d15000       8       8       0 r---- librt-2.28.so
    00007f7a18d17000      16      16       0 r-x-- librt-2.28.so
    00007f7a18d1b000       8       0       0 r---- librt-2.28.so
    00007f7a18d1d000       4       4       4 r---- librt-2.28.so
    00007f7a18d1e000       4       4       4 rw--- librt-2.28.so
    root@debian10:#

## Swap space


A portion of the hard disk can be reserved as extra memory, this is
called **swap space** and can be a partition or a regular file. Linux
will use this **swap space** to swap pages of RAM to disk, to free up
RAM for applications.

    root@debian10:# grep Swap /proc/meminfo
    SwapCached:            0 kB
    SwapTotal:       1046524 kB
    SwapFree:        1046524 kB
    root@debian10:#

### /proc/swaps


The **/proc/swaps** file will list the current **swap space**. In the
screenshot below we see that **/dev/sda5** is a swap partition of 1GB
size.

    root@debian10:# cat /proc/swaps
    Filename                                Type            Size    Used    Priority
    /dev/sda5                               partition       1046524 0       -2
    root@debian10:#

### Creating a swap partition


You can create extra **swap partitions** by first creating a partition
and then running the **mkswap** command on said partition.

    root@debian10:# mkswap /dev/sdb1
    Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
    no label, UUID=255ca455-da29-4bac-a4b6-01c97e22cf5c
    root@debian10:#

### swapon


You still need to add the **swap partition** to the **swap space**,
after the **mkswap** command, with a **swapon** command followed by the
partition. The **swapon -s** command is equivalent to **cat
/proc/swaps** .

    root@debian10:# swapon /dev/sdb1
    root@debian10:# swapon -s
    Filename                                Type            Size    Used    Priority
    /dev/sda5                               partition       1046524 0       -2
    /dev/sdb1                               partition       2097148 0       -3
    root@debian10:~#

### Creating a swap file


Swap partitions are preferred over swap files, but if there is no free
disk space to create a partition, then a swap file can be a (temporary)
solution. The screenshot creates a two gibibyte swap file named
**/swapfile** .

    root@debian10:# fallocate -l 2G /swapfile
    root@debian10:# ls -lh /swapfile
    -rw-r--r-- 1 root root 2.0G Sep 13 14:11 /swapfile
    root@debian10:# chmod 600 /swapfile
    root@debian10:# mkswap /swapfile
    Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
    no label, UUID=05cc69e6-502f-4294-b669-ef10b68dc366
    root@debian10:~#

You can activate this swap file in the same way as a partition, with the
**swapon** command. We now have a total of 5 gibibyte of swap space.

    root@debian10:# swapon /swapfile
    root@debian10:# swapon -s
    Filename                                Type            Size    Used    Priority
    /dev/sda5                               partition       1046524 0       -2
    /dev/sdb1                               partition       2097148 0       -3
    /swapfile                               file            2097148 0       -4
    root@debian10:~#

### Swap space in /etc/fstab


If you want this swap partition and this swap file to be enabled by
default at boot, then you have to add them to the **/etc/fstab** file.

    root@debian10:# vi /etc/fstab
    root@debian10:# tail -2 /etc/fstab
    /dev/sdb1 swap swap defaults 0 0
    /swapfile swap swap defaults 0 0
    root@debian10:~#

### vmstat swap io


You can watch the moving of pages in and out of swap space by using the
**vmstat** tool. For this occasion I limited the RAM memory of this
server to 1GB, as can be seen here by this **free -tm** command.

    root@debian10:# free -tm
                  total        used        free      shared  buff/cache   available
    Mem:            986          53         881           0          51         838
    Swap:          5117          15        5102
    Total:         6104          68        5984
    root@debian10:#

And then I started some memory hungry scripts. You see a lot of **so**
or **swap out** writing to swap when the free memory goes below 70MB.

    root@debian10:# vmstat 2 200
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
     4  0      0 112408  10128  78468    0    0    88     7  219  409  6  2 92  0  0
     4  0   1280  70264   9140  61908    0  590    94   590 6856 14368 60 14 27  0  0
     3  0  18432  67264    436  27676   18 8562    80  8562 7539 14028 59 13 28  0  0
     4  0  68096  66476    200  18904    0 24716   134 24716 7291 13781 56 17 27  0  0
     5  0 133376  71796    200  18360   10 32550    12 32550 7356 13562 59 15 26  0  0
     3  0 186112  69424    200  18572   62 26394   266 26394 7471 13496 56 16 28  0  0
     4  0 251648  70208    200  18480   10 26016    12 26016 7397 14126 58 17 26  0  0
    ^C
    root@debian10:#

### swapoff


If you no longer need the extra swap space, then this can be removed
with the **swapoff** command, as shown in this screenshot. Do not forget
to remove the entries from the **/etc/fstab** file.

    root@debian10:# swapoff /swapfile
    root@debian10:# swapoff /dev/sdb1
    root@debian10:# swapon -s
    Filename                                Type            Size    Used    Priority
    /dev/sda5                               partition       1046524 0       -2
    root@debian10:#

## top


The **top** command also displays a summary of memory and swap usage in
mebibytes. Note that it is perfectly normal for a Linux server to
**use** all of its memory. As long as there is no extensive swapping
going on, everything is fine.

    paul@debian10:~$ top
    top - 20:53:35 up 14 min,  4 users,  load average: 1.80, 0.69, 0.27
    Tasks: 104 total,   4 running,  99 sleeping,   1 stopped,   0 zombie
    %Cpu(s): 58.9 us, 13.6 sy,  0.0 ni, 27.4 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
    MiB Mem :   3946.4 total,   2465.6 free,   1227.5 used,    253.4 buff/cache
    MiB Swap:   1022.0 total,   1022.0 free,      0.0 used.   2508.7 avail Mem

## other tools


Several other tools like **htop** (apt-get install htop), **atop**
(apt-get install atop) and **glances** (apt-get install glances) are
available that give a summary of memory and swap usage.

## Cheat sheet

<table>
<caption>Memory</caption>
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
<td style="text-align: left;"><p>dmidecode -t memory</p></td>
<td style="text-align: left;"><p>Obtain information about physical
memory in a Debian computer.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/proc/meminfo</p></td>
<td style="text-align: left;"><p>Contains kernel information about
memory (including swap).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>free</p></td>
<td style="text-align: left;"><p>This tool displays a summary of
physical, free and swap memory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>top</p></td>
<td style="text-align: left;"><p>This tool displays a summary of
physical, free and swap memory.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>pmap -x 42</p></td>
<td style="text-align: left;"><p>Display the memory map of a process
with PID 42.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/proc/swaps</p></td>
<td style="text-align: left;"><p>Kernel information about swap
space.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>swapon -s</p></td>
<td style="text-align: left;"><p>Display information about swap
space.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>mkswap /dev/foo</p></td>
<td style="text-align: left;"><p>Create a swap partition.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mkswap /foo</p></td>
<td style="text-align: left;"><p>Create a swap file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>swapoff /foo</p></td>
<td style="text-align: left;"><p>Turn off a swap file or swap
partition.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/fstab</p></td>
<td style="text-align: left;"><p>Can contain swap partitions or files to
mount at boot.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>vmstat 2 200</p></td>
<td style="text-align: left;"><p>Display virtual memory
statistics.</p></td>
</tr>
</tbody>
</table>

Memory

## Practice

1.  If you are on a bare metal server, then run **dmidecode** to see the
    installed memory modules.

2.  Display the total amount of memory, the used memory, the free memory
    and the cached memory.

3.  Same as the previous question, but adding the **Total** line.

4.  Display the memory map of the **init** process.

5.  Display the currently activated swap space.

6.  Create and activate a swap partition on an extra disk.

7.  Create and activate a two gibibyte swap file.

8.  Optional: Search a memory allocating script on the internet and
    watch your memory being consumed. Maybe also watch swap space being
    used.

9.  Deactivate your swap file and swap partition.

10. Optional: use top, atop, htop and glances to look at memory usage.

## Solution

1.  If you are on a bare metal server, then run **dmidecode** to see the
    installed memory modules.

        dmidecode -t memory

2.  Display the total amount of memory, the used memory, the free memory
    and the cached memory.

        free -m

3.  Same as the previous question, but adding the **Total** line.

        free -mt

4.  Display the memory map of the **init** process.

        pmap -x 1

5.  Display the currently activated swap space.

        cat /proc/swaps
        swapon -s

6.  Create and activate a swap partition on an extra disk.

        fdisk /dev/sdb
        mkswap /dev/sdb1
        swapon /dev/sdb1

7.  Create and activate a two gibibyte swap file.

        fallocate -l 2G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile

8.  Optional: Search a memory allocating script on the internet and
    watch your memory being consumed. Maybe also watch swap space being
    used.

        watch free -om
        vmstat 2 100

9.  Deactivate your swap file and swap partition.

        swapoff /swapfile
        swapoff /dev/sdb1

10. Optional: use top, atop, htop and glances to look at memory usage.

        top
        atop
        htop
        glances
