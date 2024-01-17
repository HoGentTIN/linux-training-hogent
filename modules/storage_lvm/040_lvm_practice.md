# practice : lvm

1\. Create a volume group that contains a complete disk and a partition
on another disk.

2\. Create two logical volumes (a small one and a bigger one) in this
volumegroup. Format them wih ext3, mount them and copy some files to
them.

3\. Verify usage with fdisk, mount, pvs, vgs, lvs, pvdisplay, vgdisplay,
lvdisplay and df. Does fdisk give you any information about lvm?

4\. Enlarge the small logical volume by 50 percent, and verify your
work!

5\. Take a look at other commands that start with vg\* , pv\* or lv\*.

6\. Create a mirror and a striped Logical Volume.

7\. Convert a linear logical volume to a mirror.

8\. Convert a mirror logical volume to a linear.

9\. Create a snapshot of a Logical Volume, take a backup of the
snapshot. Then delete some files on the Logical Volume, then restore
your backup.

10\. Move your volume group to another disk (keep the Logical Volumes
mounted).

11\. If time permits, split a Volume Group with vgsplit, then merge it
again with vgmerge.
