## practice: uuid and filesystems

1. Find the `uuid` of one of your Linux system's partitions with `tune2fs`.

2. Use this `uuid` in `/etc/fstab` and test that it works with a simple `mount`.

3. (optional) Test it also by removing a disk (so the device name is changed). You can edit settings in vmware/Virtualbox to remove a hard disk.

4. Display the `root=` directive in `/boot/grub/menu.lst`.

5. (optional on ubuntu) Replace the `/dev/xxx` in `/boot/grub/menu.lst` with a `uuid` (use an extra stanza for this). Test that it works.

