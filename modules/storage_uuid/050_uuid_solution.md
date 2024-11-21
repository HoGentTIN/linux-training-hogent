## solution: uuid and filesystems

1. Find the `uuid` of one of your Linux system's partitions with `tune2fs`.

    ```console
    student@ubuntu:~$ sudo tune2fs -l /dev/sda2 | grep UUID
    Filesystem UUID:          0e751ccc-2139-4c7a-a90e-e41e9a522aee
    ```

2. Use this `uuid` in `/etc/fstab` and test that it works with a simple `mount`.

    ```console
    $ tail -1 /etc/fstab
    UUID=60926898-2c78-49b4-a71d-c1d6310c87cc /home/pro42 ext3 defaults 0 0
    ```

3. (optional) Test it also by removing a disk (so the device name is changed). You can edit settings in vmware/Virtualbox to remove a hard disk.

4. Display the `root=` directive in `/boot/grub/menu.lst`.

    ```console
    student@ubuntu:~$ grep root= /boot/grub/menu.lst
    kernel          /boot/vmlinuz-2.6.26-2-686 root=/dev/hda1 ro selinux=1 quiet
    kernel          /boot/vmlinuz-2.6.26-2-686 root=/dev/hda1 ro selinux=1 single
    ```

5. (optional on ubuntu) Replace the `/dev/xxx` in `/boot/grub/menu.lst` with a `uuid` (use an extra stanza for this). Test that it works.


