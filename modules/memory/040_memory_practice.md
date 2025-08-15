## practice : memory

1. Use `dmesg` to find the total amount of memory in your computer.

2. Use `free` to display memory usage in kilobytes (then in megabytes).

3. On a virtual machine, create a swap partition (you might need an
extra virtual disk for this).

4. Add a 20 megabyte swap file to the system.

5. Put all swap spaces in `/etc/fstab` and activate them. Test with a
reboot that they are mounted.

6. Use `free` to verify usage of current swap.

7. (optional) Display the usage of swap with `vmstat` and `free -s`
during a memory leak.

