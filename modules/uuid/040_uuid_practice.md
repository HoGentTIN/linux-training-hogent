# practice: uuid and filesystems

1\. Find the `uuid` of one of your `ext3` partitions with `tune2fs` (
and `vol_id` if you are on RHEL5).

2\. Use this `uuid` in `/etc/fstab` and test that it works with a simple
`mount`.

3\. (optional) Test it also by removing a disk (so the device name is
changed). You can edit settings in vmware/Virtualbox to remove a hard
disk.

4\. Display the `root=` directive in `/boot/grub/menu.lst`. (We see
later in the course how to maintain this file.)

5\. (optional on ubuntu) Replace the `/dev/xxx` in `/boot/grub/menu.lst`
with a `uuid` (use an extra stanza for this). Test that it works.
