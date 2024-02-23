## solution: uuid and filesystems

1\. Find the `uuid` of one of your `ext3` partitions with `tune2fs` (
and `vol_id` if you are on RHEL5).

    root@linux:~# /lib/udev/vol_id -u /dev/hda1
    60926898-2c78-49b4-a71d-c1d6310c87cc

    root@ubu1004:~# tune2fs -l /dev/sda2 | grep UUID
    Filesystem UUID:          3007b743-1dce-2d62-9a59-cf25f85191b7

2\. Use this `uuid` in `/etc/fstab` and test that it works with a simple
`mount`.

    tail -1 /etc/fstab
    UUID=60926898-2c78-49b4-a71d-c1d6310c87cc /home/pro42 ext3 defaults 0 0

3\. (optional) Test it also by removing a disk (so the device name is
changed). You can edit settings in vmware/Virtualbox to remove a hard
disk.

4\. Display the `root=` directive in `/boot/grub/menu.lst`. (We see
later in the course how to maintain this file.)

    student@linux:~$ grep ^[^#] /boot/grub/menu.lst | grep root=
    kernel          /boot/vmlinuz-2.6.26-2-686 root=/dev/hda1 ro selinux=1 quiet
    kernel          /boot/vmlinuz-2.6.26-2-686 root=/dev/hda1 ro selinux=1 single

5\. (optional on ubuntu) Replace the `/dev/xxx` in `/boot/grub/menu.lst`
with a `uuid` (use an extra stanza for this). Test that it works.

