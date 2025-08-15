## solution: sticky, setuid and setgid bits

1. Create a directory `/home/sports`.

    1. Ensure the directory is owned by the group sports.

        ```bash
        groupadd sports
        mkdir /home/sports
        chown root:sports /home/sports
        ```

    2. Members of the sports group should be able to create files in this directory.
    
        ```bash
        chmod 770 /home/sports
        ```

    3. All files created in this directory should be group-owned by the sports group.
    
        ```bash
        chmod 2770 /home/sports
        ```

    4. Users should be able to delete only their own user-owned files.
    
        ```bash
        chmod +t /home/sports
        ```

    5. Test that this works!
    
       > Log in with different users (group members and others and root), create files and watch the permissions. Try changing and deleting files...

2. Verify the permissions on `/usr/bin/passwd`. Remove the `setuid`, then try changing your password as a normal user. Reset the permissions back and try again.

    ```console
    root@linux:~# ls -l /usr/bin/passwd 
    -rwsr-xr-x 1 root root 31704 2009-11-14 15:41 /usr/bin/passwd
    root@linux:~# chmod 755 /usr/bin/passwd 
    root@linux:~# ls -l /usr/bin/passwd 
    -rwxr-xr-x 1 root root 31704 2009-11-14 15:41 /usr/bin/passwd
    ```
        
    A normal user cannot change password now.

    ```console
    root@linux:~# chmod 4755 /usr/bin/passwd 
    root@linux:~# ls -l /usr/bin/passwd 
    -rwsr-xr-x 1 root root 31704 2009-11-14 15:41 /usr/bin/passwd
    ```

3. If time permits (or if you are waiting for other students to finish this practice), read about file attributes in the man page of `chattr` and `lsattr`. Try setting the `i` attribute on a file and test that it works.

    ```console
    student@linux:~$ sudo su -
    [sudo] password for paul: 
    root@linux:~# mkdir attr
    root@linux:~# cd attr/
    root@linux:~/attr# touch file42
    root@linux:~/attr# lsattr
    ------------------ ./file42
    root@linux:~/attr# chattr +i file42 
    root@linux:~/attr# lsattr
    ----i------------- ./file42
    root@linux:~/attr# rm -rf file42 
    rm: cannot remove `file42': Operation not permitted
    root@linux:~/attr# chattr -i file42 
    root@linux:~/attr# rm -rf file42 
    root@linux:~/attr#
    ```

