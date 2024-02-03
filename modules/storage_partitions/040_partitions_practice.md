## practice: partitions

1\. Use `fdisk -l` to display existing partitions and sizes.

2\. Use `df -h` to display existing partitions and sizes.

3\. Compare the output of `fdisk` and `df`.

4\. Create a 200MB primary partition on a small disk.

5\. Create a 400MB primary partition and two 300MB logical drives on a
big disk.

6\. Use `df -h` and `fdisk -l` to verify your work.

7\. Compare the output again of `fdisk` and `df`. Do both commands
display the new partitions ?

8\. Create a backup with `dd` of the `mbr` that contains your 200MB
primary partition.

9\. Take a backup of the `partition table` containing your 400MB primary
and 300MB logical drives. Make sure the logical drives are in the
backup.

10\. (optional) Remove all your partitions with fdisk. Then restore your
backups.

