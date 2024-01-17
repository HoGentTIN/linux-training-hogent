# solution: sticky, setuid and setgid bits

1a. Set up a directory, owned by the group sports.

    groupadd sports

    mkdir /home/sports

    chown root:sports /home/sports

1b. Members of the sports group should be able to create files in this
directory.

    chmod 770 /home/sports

1c. All files created in this directory should be group-owned by the
sports group.

    chmod 2770 /home/sports

1d. Users should be able to delete only their own user-owned files.

    chmod +t /home/sports

1e. Test that this works!

Log in with different users (group members and others and root), create
files and watch the permissions. Try changing and deleting files\...

2\. Verify the permissions on `/usr/bin/passwd`. Remove the `setuid`,
then try changing your password as a normal user. Reset the permissions
back and try again.

    root@deb106:~# ls -l /usr/bin/passwd 
    -rwsr-xr-x 1 root root 31704 2009-11-14 15:41 /usr/bin/passwd
    root@deb106:~# chmod 755 /usr/bin/passwd 
    root@deb106:~# ls -l /usr/bin/passwd 
    -rwxr-xr-x 1 root root 31704 2009-11-14 15:41 /usr/bin/passwd
        

A normal user cannot change password now.

    root@deb106:~# chmod 4755 /usr/bin/passwd 
    root@deb106:~# ls -l /usr/bin/passwd 
    -rwsr-xr-x 1 root root 31704 2009-11-14 15:41 /usr/bin/passwd
        

3\. If time permits (or if you are waiting for other students to finish
this practice), read about file attributes in the man page of chattr and
lsattr. Try setting the i attribute on a file and test that it works.

    paul@laika:~$ sudo su -
    [sudo] password for paul: 
    root@laika:~# mkdir attr
    root@laika:~# cd attr/
    root@laika:~/attr# touch file42
    root@laika:~/attr# lsattr
    ------------------ ./file42
    root@laika:~/attr# chattr +i file42 
    root@laika:~/attr# lsattr
    ----i------------- ./file42
    root@laika:~/attr# rm -rf file42 
    rm: cannot remove `file42': Operation not permitted
    root@laika:~/attr# chattr -i file42 
    root@laika:~/attr# rm -rf file42 
    root@laika:~/attr#
