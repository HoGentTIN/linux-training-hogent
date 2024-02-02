## practice: mounting file systems

1\. Mount the small 200MB partition on /home/project22.

2\. Mount the big 400MB primary partition on /mnt, then copy some files
to it (everything in /etc). Then umount, and mount the file system as
read only on /srv/nfs/salesnumbers. Where are the files you copied ?

3\. Verify your work with `fdisk`, `df` and `mount`. Also look in
`/etc/mtab` and `/proc/mounts`.

4\. Make both mounts permanent, test that it works.

5\. What happens when you mount a file system on a directory that
contains some files ?

6\. What happens when you mount two file systems on the same mount point
?

7\. (optional) Describe the difference between these commands: find,
locate, updatedb, makewhatis, whereis, apropos, which and type.

8\. (optional) Perform a file system check on the partition mounted at
/srv/nfs/salesnumbers.
