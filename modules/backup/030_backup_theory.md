## About tape devices

Don't forget that the name of a device strictly speaking has no meaning
since the kernel will use the major and minor number to find the
hardware! See the man page of `mknod` and the devices.txt
file in the Linux kernel source for more info.

### SCSI tapes

On the official Linux device list
(http://www.lanana.org/docs/device-list/) we find the names for SCSI
tapes (major 9 char). SCSI tape devices are located underneath
`/dev/st` and are numbered starting with 0 for the first
tape device.

    /dev/st0   First tape device
    /dev/st1   Second tape device
    /dev/st2   Third tape device
            

To prevent `automatic rewinding of tapes`, prefix them
with the letter n.

    /dev/nst0   First no rewind tape device
    /dev/nst1   Second no rewind tape device
    /dev/nst2   Third no rewind tape device
            

By default, SCSI tapes on Linux will use the highest hardware
compression that is supported by the tape device. To lower the
compression level, append one of the letters l (low), m (medium) or a
(auto) to the tape name.

    /dev/st0l   First low compression tape device
    /dev/st0m   First medium compression tape device
    /dev/nst2m  Third no rewind medium compression tape device
            

### IDE tapes

On the official Linux device list
(http://www.lanana.org/docs/device-list/) we find the names for IDE
tapes (major 37 char). IDE tape devices are located underneath
`/dev/ht` and are numbered starting with 0 for the first
tape device. No rewind and compression is similar to SCSI tapes.

    /dev/ht0   First IDE tape device
    /dev/nht0  Second no rewind IDE tape device
    /dev/ht0m  First medium compression IDE tape device
            

### mt

To manage your tapes, use `mt` (Magnetic Tape). Some
examples.

To receive information about the status of the tape.

    mt -f /dev/st0 status

To rewind a tape...

    mt -f /dev/st0 rewind

To rewind and eject a tape...

    mt -f /dev/st0 eject

To erase a tape...

    mt -f /dev/st0 erase

## Compression

It can be beneficial to compress files before backup. The two most
popular tools for compression of regular files on Linux are
`gzip/gunzip` and `bzip2/bunzip2`. Below you
can see gzip in action, notice that it adds the `.gz` extension to the
file.

    student@linux:~/test$ ls -l allfiles.tx*
    -rw-rw-r--  1 paul paul 8813553 Feb 27 05:38 allfiles.txt
    student@linux:~/test$ gzip allfiles.txt 
    student@linux:~/test$ ls -l allfiles.tx*
    -rw-rw-r--  1 paul paul 931863 Feb 27 05:38 allfiles.txt.gz
    student@linux:~/test$ gunzip allfiles.txt.gz 
    student@linux:~/test$ ls -l allfiles.tx*
    -rw-rw-r--  1 paul paul 8813553 Feb 27 05:38 allfiles.txt
    student@linux:~/test$ 
        

In general, gzip is much faster than bzip2, but the latter one
compresses a lot better. Let us compare the two.

    student@linux:~/test$ cp allfiles.txt bllfiles.txt 
    student@linux:~/test$ time gzip allfiles.txt 
            
    real    0m0.050s
    user    0m0.041s
    sys     0m0.009s
    student@linux:~/test$ time bzip2 bllfiles.txt 
            
    real    0m5.968s
    user    0m5.794s
    sys     0m0.076s
    student@linux:~/test$ ls -l ?llfiles.tx*
    -rw-rw-r--  1 paul paul 931863 Feb 27 05:38 allfiles.txt.gz
    -rw-rw-r--  1 paul paul 708871 May 12 10:52 bllfiles.txt.bz2
    student@linux:~/test$ 
        

## tar

The `tar` utility gets its name from `Tape ARchive`. This
tool will receive and send files to a destination (typically a tape or a
regular file). The c option is used to create a tar archive (or
tarfile), the f option to name/create the `tarfile`. The example below
takes a backup of /etc into the file /backup/etc.tar .

    root@linux:~# tar cf /backup/etc.tar /etc
    root@linux:~# ls -l /backup/etc.tar 
    -rw-r--r--  1 root root 47800320 May 12 11:47 /backup/etc.tar
    root@linux:~#
        

Compression can be achieved without pipes since tar uses the z flag to
compress with gzip, and the j flag to compress with bzip2.

    root@linux:~# tar czf /backup/etc.tar.gz /etc
    root@linux:~# tar cjf /backup/etc.tar.bz2 /etc
    root@linux:~# ls -l /backup/etc.ta*
    -rw-r--r--  1 root root 47800320 May 12 11:47 /backup/etc.tar
    -rw-r--r--  1 root root  6077340 May 12 11:48 /backup/etc.tar.bz2
    -rw-r--r--  1 root root  8496607 May 12 11:47 /backup/etc.tar.gz
    root@linux:~# 
        

The t option is used to `list the contents of a tar file`. Verbose mode
is enabled with v (also useful when you want to see the files being
archived during archiving).

    root@linux:~# tar tvf /backup/etc.tar
    drwxr-xr-x root/root         0 2007-05-12 09:38:21 etc/
    -rw-r--r-- root/root      2657 2004-09-27 10:15:03 etc/warnquota.conf
    -rw-r--r-- root/root     13136 2006-11-03 17:34:50 etc/mime.types
    drwxr-xr-x root/root         0 2004-11-03 13:35:50 etc/sound/
    ...
        

To `list a specific file in a tar archive`, use the t option, added with
the filename (without leading /).

    root@linux:~# tar tvf /backup/etc.tar etc/resolv.conf
    -rw-r--r-- root/root        77 2007-05-12 08:31:32 etc/resolv.conf
    root@linux:~# 
        

Use the x flag to `restore a tar archive`, or a single file from the
archive. Remember that by default tar will restore the file in the
current directory.

    root@linux:~# tar xvf /backup/etc.tar etc/resolv.conf
    etc/resolv.conf
    root@linux:~# ls -l /etc/resolv.conf
    -rw-r--r--  2 root root 40 May 12 12:05 /etc/resolv.conf
    root@linux:~# ls -l etc/resolv.conf
    -rw-r--r--  1 root root 77 May 12 08:31 etc/resolv.conf
    root@linux:~# 
        

You can `preserve file permissions` with the p flag. And
you can exclude directories or file with `--exclude`.

    root ~# tar cpzf /backup/etc_with_perms.tgz /etc 
    root ~# tar cpzf /backup/etc_no_sysconf.tgz /etc --exclude /etc/sysconfig
    root ~# ls -l /backup/etc_*
    -rw-r--r--  1 root root 8434293 May 12 12:48 /backup/etc_no_sysconf.tgz
    -rw-r--r--  1 root root 8496591 May 12 12:48 /backup/etc_with_perms.tgz
    root ~# 
        

You can also create a text file with names of files and directories to
archive, and then supply this file to tar with the -T flag.

    root@linux:~# find /etc -name *.conf > files_to_archive.txt
    root@linux:~# find /home -name *.pdf >> files_to_archive.txt
    root@linux:~# tar cpzf /backup/backup.tgz -T files_to_archive.txt 
        

The tar utility can receive filenames from the find command, with the
help of xargs.

    find /etc -type f -name "*.conf" | xargs tar czf /backup/confs.tar.gz
        

You can also use tar to copy a directory, this is more efficient than
using cp -r.

    (cd /etc; tar -cf - . ) | (cd /backup/copy_of_etc/; tar -xpf - )
        

Another example of tar, this copies a directory securely over the
network.

    (cd /etc;tar -cf - . )|(ssh user@srv 'cd /backup/cp_of_etc/; tar -xf - ')
        

tar can be used together with gzip and copy a file to a remote server
through ssh

    cat backup.tar | gzip | ssh bashuser@192.168.1.105 "cat - > backup.tgz"
        

Compress the tar backup when it is on the network, but leave it
uncompressed at the destination.

    cat backup.tar | gzip | ssh user@192.168.1.105 "gunzip|cat - > backup.tar"
        

Same as the previous, but let ssh handle the compression

    cat backup.tar | ssh -C bashuser@192.168.1.105 "cat - > backup.tar"
        

## Backup Types

Linux uses `multilevel incremental` backups using distinct levels. A
full backup is a backup at level 0. A higher level x backup will include
all changes since the last level x-1 backup.

Suppose you take a full backup on Monday (level 0) and a level 1 backup
on Tuesday, then the Tuesday backup will contain all changes since
Monday. Taking a level 2 on Wednesday will contain all changes since
Tuesday (the last level 2-1). A level 3 backup on Thursday will contain
all changes since Wednesday (the last level 3-1). Another level 3 on
Friday will also contain all changes since Wednesday. A level 2 backup
on Saturday would take all changes since the last level 1 from Tuesday.

## dump and restore

While `dump` is similar to tar, it is also very different
because it looks at the file system. Where tar receives a lists of files
to backup, dump will find files to backup by itself by examining ext2.
Files found by dump will be copied to a tape or regular file. In case
the target is not big enough to hold the dump (end-of-media), it is
broken into multiple volumes.

Restoring files that were backed up with dump is done with the
`restore` command. In the example below we take a full
level 0 backup of two partitions to a SCSI tape. The no rewind is
mandatory to put the volumes behind each other on the tape.

    dump 0f /dev/nst0 /boot
    dump 0f /dev/nst0 /
        

Listing files in a dump archive is done with `dump -t`, and you can
compare files with `dump -C`.

You can omit files from a dump by changing the dump attribute with the
`chattr` command. The d attribute on ext will tell dump to
skip the file, even during a full backup. In the following example,
/etc/hosts is excluded from dump archives.

    chattr +d /etc/hosts
        

To restore the complete file system with `restore`, use the -r option.
This can be useful to change the size or block size of a file system.
You should have a clean file system mounted and cd'd into it. Like this
example shows.

    mke2fs /dev/hda3
    mount /dev/hda3 /mnt/data
    cd /mnt/data
    restore rf /dev/nst0
        

To extract only one file or directory from a dump, use the -x option.

    restore -xf /dev/st0 /etc
        

## cpio

Different from tar and dump is `cpio` (Copy Input and
Output). It can be used to receive filenames, but copies the actual
files. This makes it an easy companion with find! Some examples below.

find sends filenames to cpio, which puts the files in an archive.

    find /etc -depth -print | cpio -oaV -O archive.cpio

The same, but compressed with gzip

    find /etc -depth -print | cpio -oaV | gzip -c > archive.cpio.gz 

Now pipe it through ssh (backup files to a compressed file on another
machine)

    find /etc -depth -print|cpio -oaV|gzip -c|ssh server "cat - > etc.cpio.gz"
        

find sends filenames to cpio \| cpio sends files to ssh \| ssh sends
files to cpio 'cpio extracts files'

    find /etc -depth -print | cpio -oaV | ssh user@host 'cpio -imVd'

the same but reversed: copy a dir from the remote host to the local
machine

    ssh user@host "find path -depth -print | cpio -oaV" | cpio -imVd

## dd

### About dd

Some people use `dd` to create backups. This can be very
powerful, but dd backups can only be restored to very similar partitions
or devices. There are however a lot of useful things possible with dd.
Some examples.

### Create a CDROM image

The easiest way to create a `.ISO file` from any CD. The
if switch means Input File, of is the Output File. Any good tool can
burn a copy of the CD with this .ISO file.

    dd if=/dev/cdrom of=/path/to/cdrom.ISO

### Create a floppy image

A little outdated maybe, but just in case : make an image file from a
1.44MB floppy. Blocksize is defined by bs, and count contains the number
of blocks to copy.

    dd if=/dev/floppy of=/path/to/floppy.img bs=1024 count=1440
        

### Copy the master boot record

Use dd to copy the `MBR` (Master Boot Record) of hard disk
/dev/hda to a file.

    dd if=/dev/hda of=/MBR.img bs=512 count=1

### Copy files

This example shows how dd can copy files. Copy the file summer.txt to
copy_of_summer.txt .

    dd if=~/summer.txt of=~/copy_of_summer.txt

### Image disks or partitions

And who needs ghost when dd can create a (compressed) image of a
partition.

    dd if=/dev/hdb2 of=/image_of_hdb2.IMG
    dd if=/dev/hdb2 | gzip > /image_of_hdb2.IMG.gz
        

### Create files of a certain size

dd can be used to create a file of any size. The first example creates a
one MEBIbyte file, the second a one MEGAbyte file.

    dd if=/dev/zero of=file1MB count=1024 bs=1024
    dd if=/dev/zero of=file1MB count=1000 bs=1024
        

### CDROM server example

And there are of course endless combinations with ssh and bzip2. This
example puts a bzip2 backup of a cdrom on a remote server.

    dd if=/dev/cdrom |bzip2|ssh user@host "cat - > /backups/cd/cdrom.iso.bz2"
        

## split

The `split` command is useful to split files into smaller
files. This can be useful to fit the file onto multiple instances of a
medium too small to contain the complete file. In the example below, a
file of size 5000 bytes is split into three smaller files, with maximum
2000 bytes each.

     
    student@linux:~/test$ ls -l
    total 8
    -rw-r--r-- 1 paul paul 5000 2007-09-09 20:46 bigfile1
    student@linux:~/test$ split -b 2000 bigfile1 splitfile.
    student@linux:~/test$ ls -l
    total 20
    -rw-r--r-- 1 paul paul 5000 2007-09-09 20:46 bigfile1
    -rw-r--r-- 1 paul paul 2000 2007-09-09 20:47 splitfile.aa
    -rw-r--r-- 1 paul paul 2000 2007-09-09 20:47 splitfile.ab
    -rw-r--r-- 1 paul paul 1000 2007-09-09 20:47 splitfile.ac
           

