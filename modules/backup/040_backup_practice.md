## practice: backup

!! Careful with tar options and the position of the backup file,
mistakes can destroy your system!!

1\. Create a directory (or partition if you like) for backups. Link (or
mount) it under /mnt/backup.

2a. Use tar to backup /etc in /mnt/backup/etc_date.tgz, the backup must
be gzipped. (Replace date with the current date)

2b. Use tar to backup /bin to /mnt/backup/bin_date.tar.bz2, the backup
must be bzip2\'d.

2c. Choose a file in /etc and /bin and verify with tar that the file is
indeed backed up.

2d. Extract those two files to your home directory.

3a. Create a backup directory for your neighbour, make it accessible
under /mnt/neighbourName

3b. Combine ssh and tar to put a backup of your /boot on your neighbours
computer in /mnt/YourName

4a. Combine find and cpio to create a cpio archive of /etc.

4b. Choose a file in /etc and restore it from the cpio archive into your
home directory.

5\. Use dd and ssh to put a backup of the master boot record on your
neighbours computer.

6\. (On the real computer) Create and mount an ISO image of the ubuntu
cdrom.

7\. Combine dd and gzip to create a \'ghost\' image of one of your
partitions on another partition.

8\. Use dd to create a five megabyte file in \~/testsplit and name it
biggest. Then split this file in smaller two megabyte parts.

    mkdir testsplit

    dd if=/dev/zero of=~/testsplit/biggest count=5000 bs=1024

    split -b 2000000 biggest parts

