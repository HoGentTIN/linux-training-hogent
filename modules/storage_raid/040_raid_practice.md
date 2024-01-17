# practice: raid

1\. Add three virtual disks of 1GB each to a virtual machine.

2\. Create a software `raid 5` on the three disks. (It is not necessary
to put a filesystem on it)

3\. Verify with `fdisk` and in `/proc` that the `raid 5` exists.

4\. Stop and remove the `raid 5`.

5\. Create a `raid 1` to mirror two disks.
