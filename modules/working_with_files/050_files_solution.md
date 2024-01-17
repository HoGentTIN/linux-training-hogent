# solution: working with files

1\. List the files in the /bin directory

    ls /bin

2\. Display the type of file of /bin/cat, /etc/passwd and
/usr/bin/passwd.

    file /bin/cat /etc/passwd /usr/bin/passwd

3a. Download wolf.jpg and LinuxFun.pdf from http://linux-training.be
(wget http://linux-training.be/files/studentfiles/wolf.jpg and wget
http://linux-training.be/files/books/LinuxFun.pdf)

    wget http://linux-training.be/files/studentfiles/wolf.jpg
    wget http://linux-training.be/files/studentfiles/wolf.png
    wget http://linux-training.be/files/books/LinuxFun.pdf

3b. Display the type of file of wolf.jpg and LinuxFun.pdf

    file wolf.jpg LinuxFun.pdf

3c. Rename wolf.jpg to wolf.pdf (use mv).

    mv wolf.jpg wolf.pdf

3d. Display the type of file of wolf.pdf and LinuxFun.pdf.

    file wolf.pdf LinuxFun.pdf

4\. Create a directory \~/touched and enter it.

    mkdir ~/touched ; cd ~/touched

5\. Create the files today.txt and yesterday.txt in touched.

    touch today.txt yesterday.txt

6\. Change the date on yesterday.txt to match yesterday\'s date.

    touch -t 200810251405 yesterday.txt (substitute 20081025 with yesterday)

7\. Copy yesterday.txt to copy.yesterday.txt

    cp yesterday.txt copy.yesterday.txt

8\. Rename copy.yesterday.txt to kim

    mv copy.yesterday.txt kim

9\. Create a directory called \~/testbackup and copy all files from
\~/touched into it.

    mkdir ~/testbackup ; cp -r ~/touched ~/testbackup/ 

10\. Use one command to remove the directory \~/testbackup and all files
into it.

    rm -rf ~/testbackup 

11\. Create a directory \~/etcbackup and copy all \*.conf files from
/etc into it. Did you include all subdirectories of /etc ?

    cp -r /etc/*.conf ~/etcbackup

    Only *.conf files that are directly in /etc/ are copied.

12\. Use rename to rename all \*.conf files to \*.backup . (if you have
more than one distro available, try it on all!)

    On RHEL: touch 1.conf 2.conf ; rename conf backup *.conf

    On Debian: touch 1.conf 2.conf ; rename 's/conf/backup/' *.conf
