## About Disk Quotas

To limit the disk space used by user, you can set up
`disk quotas`. This requires adding
`usrquota` and/or `grpquota` to one or more
of the file systems in `/etc/fstab`.

    root@RHELv8u4:~# cat /etc/fstab | grep usrquota
    /dev/VolGroup00/LogVol02     /home     ext3     usrquota,grpquota   0 0
            

Next you need to remount the file system.

    root@RHELv8u4:~# mount -o remount /home
            

The next step is to build the `quota.user` and/or
`quota.group` files. These files (called the
`quota files`) contain the table of the disk usage on that file system.
Use the `quotacheck` command to accomplish this.

    root@RHELv8u4:~# quotacheck -cug /home
    root@RHELv8u4:~# quotacheck -avug
            

The `-c` is for create, `u` for user quota, `g` for group, `a` for
checking all quota enabled file systems in /etc/fstab and `v` for
verbose information. The next step is to edit individual user quotas
with `edquota` or set a general quota on the file system
with `edquota -t`. The tool will enable you to put `hard` (this is the
real limit) and `soft` (allows a grace period) limits on `blocks` and
`inodes`. The `quota` command will verify that quota for a
user is set. You can have a nice overview with `repquota`.

The final step (before your users start complaining about lack of disk
space) is to enable quotas with `quotaon(1)`.

    root@RHELv8u4:~# quotaon -vaug

Issue the `quotaoff` command to stop all complaints.

    root@RHELv8u4:~# quotaoff -vaug

## Practice Disk quotas

1\. Implement disk quotas on one of your new partitions. Limit one of
your users to 10 megabyte.

2\. Test that they work by copying many files to the quota\'d partition.

