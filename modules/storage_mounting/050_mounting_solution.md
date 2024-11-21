## solution: mounting file systems

1. Mount the small 200MB partition on `/mnt/project22`.

    ```console
    mkdir /mnt/project22
    mount /dev/sdc1 /mnt/project22
    ```

2. Mount the big 400MB primary partition on /mnt/salesnumbers, then copy some files to it (e.g. everything in `/etc`). Then umount, and mount the file system as read only on `/srv/nfs/salesnumbers`. Where are the files you copied ?

    ```console
    sudo mount /dev/sdb1 /mnt
    sudo cp -r /etc /mnt
    ls -l /mnt

    sudo umount /mnt
    ls -l /mnt

    sudo mkdir -p /srv/nfs/salesnumbers
    sudo mount /dev/sdb1 /srv/nfs/salesnumbers
    ```

    > You see the files in `/srv/nfs/salenumbers` now. But physically they are on the `ext3` filesystem `/dev/sdb1`.

3. Verify your work with `fdisk`, `df` and `mount`. Also look in `/etc/mtab` and `/proc/mounts`.

    ```console
    fdisk -l
    df -h
    mount
    ```

    > All three the above commands should show your mounted partitions.

    ```console
    grep project22 /etc/mtab
    grep project22 /proc/mounts
    ```

4. Make both mounts permanent, test that it works.

    > add the following lines to `/etc/fstab`

    ```text
    /dev/sdc1 /mnt/project22         auto  defaults  0 0
    /dev/sdb1 /srv/nfs/salesnumbers  auto  defaults  0 0
    ```

5. What happens when you mount a file system on a directory that contains some files ?

    > The files are hidden until `umount`.

6. What happens when you mount two file systems on the same mount point?

    > Only the last mounted fs is visible.

7. (optional) Perform a file system check on the partition mounted at `/srv/nfs/salesnumbers`

    ```console
    umount /srv/nfs/salesnumbers
    fsck /dev/sdb1
    ```

