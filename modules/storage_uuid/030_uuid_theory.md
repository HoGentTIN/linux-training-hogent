
## lsblk -f

You can quickly locate the `uuid` of file systems with `lsblk -f`. The following example is from a VM running Ubuntu 24.05.

```console
student@ubuntu:~$ lsblk -f
NAME     FSTYPE  FSVER   LABEL UUID                                FSAVAIL FSUSE% MOUNTPOINTS
sda
├─sda1
├─sda2   ext4    1.0           0e751ccc-2139-4c7a-a90e-e41e9a522aee   1.7G     5% /boot
└─sda3   LVM2_me LVM2 001      d2OsZK-N5Ih-NCA3-TOIv-h9Ul-wXzA-UoQKtz
  └─ubuntu--vg-ubuntu--lv
         ext4    1.0           40b3fedd-d848-4a74-b7ef-f3acac9554ed  25.5G    11% /
```

The same command will also work on recent EL systems, e.g. AlmaLinux 9:

```console
[student@el ~]$ lsblk -f
NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                           
├─sda1 swap   1           a4814ebe-c0b2-4819-8129-30f32b3e8772                [SWAP]
└─sda2 xfs                303db791-9236-4ac4-a176-e2a033576d89   60.4G     2% /
```

## tune2fs

Use `tune2fs` to find the `uuid` of a file system.

```console
student@ubuntu:~$ sudo tune2fs -l /dev/sda2 | grep UUID
Filesystem UUID:          0e751ccc-2139-4c7a-a90e-e41e9a522aee
```

## uuid

There is more information in the manual of `uuid(1)`, a tool that can generate uuid's.

```console
[student@el ~]$ sudo dnf install uuid
[student@el ~]$ uuid
c4212384-75ca-11ef-829a-080027c76768
[student@el ~]$ man uuid
```

(On Debian/Ubuntu/Mint, use `sudo apt install uuid`.)

## uuid in /etc/fstab

You can use the `uuid` in `/etc/fstab` to make sure that a volume is universally uniquely identified. The device name (`/dev/sdx`) can change depending on the disk devices that are present at boot time, but a `uuid` never changes.

First we use `tune2fs` to find the `uuid`.

```console
[student@linux ~]$ sudo tune2fs -l /dev/sdc1 | grep UUID
Filesystem UUID:          7626d73a-2bb6-4937-90ca-e451025d64e8
```

Then we check that it is properly added to `/etc/fstab`, the `uuid` replaces the variable devicename /dev/sdc1.

```console
[student@linux ~]$ grep UUID /etc/fstab 
UUID=7626d73a-2bb6-4937-90ca-e451025d64e8 /home/pro42 ext3 defaults 0 0
```

Now we can mount the volume using the mount point defined in `/etc/fstab`.

```console
[student@linux ~]$ sudo mount /home/pro42
[student@linux ~]$ df -h | grep 42
/dev/sdc1             397M   11M  366M   3% /home/pro42
```

The real test now, is to remove `/dev/sdb` from the system, reboot the machine and see what happens. After the reboot, the disk previously known as `/dev/sdc` is now `/dev/sdb`.

```console
[student@linux ~]$ sudo tune2fs -l /dev/sdb1 | grep UUID
Filesystem UUID:          7626d73a-2bb6-4937-90ca-e451025d64e8
```

And thanks to the `uuid` in `/etc/fstab`, the mountpoint is mounted on the same disk as before.

```console
[student@linux ~]$ df -h | grep sdb
/dev/sdb1             397M   11M  366M   3% /home/pro42
```

## uuid as a boot device

Recent Linux distributions (Debian, Ubuntu, Fedora, ...) use `grub` with a `uuid` to identify the root file system.

This example shows how a `root=/dev/sda1` is replaced with a `uuid`.

```text
title    Ubuntu 9.10, kernel 2.6.31-19-generic
uuid     f001ba5d-9077-422a-9634-8d23d57e782a
kernel   /boot/vmlinuz-2.6.31-19-generic root=UUID=f001ba5d-9077-422a-9634-8d23d57e782a ro quiet splash 
initrd   /boot/initrd.img-2.6.31-19-generic
```

EL and derived distributions boot from LVM after a default install.

