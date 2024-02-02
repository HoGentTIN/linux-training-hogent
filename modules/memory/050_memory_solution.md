## solution : memory

1\. Use `dmesg` to find the total amount of memory in your computer.

    dmesg | grep Memory

2\. Use `free` to display memory usage in kilobytes (then in megabytes).

    free ; free -m

3\. On a virtual machine, create a swap partition (you might need an
extra virtual disk for this).

    mkswap /dev/sdd1 ; swapon /dev/sdd1

4\. Add a 20 megabyte swap file to the system.

    dd if=/dev/zero of=/swapfile20mb bs=1024 count=20000
    mkswap /swapfile20mb
    swapon /swapfile20mb

5\. Put all swap spaces in `/etc/fstab` and activate them. Test with a
reboot that they are mounted.

    root@computer# tail -2 /etc/fstab
    /dev/sdd1     swap swap defaults 0 0
    /swapfile20mb swap swap defaults 0 0

6\. Use `free` to verify usage of current swap.

    free -om

7\. (optional) Display the usage of swap with `vmstat` and `free -s`
during a memory leak.
