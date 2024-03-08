## solution: standard file permissions

1. As normal user, create a directory `~/permissions`. Create a file
owned by yourself in there.

    ```console
    [student@linux ~]$ mkdir permissions
    [student@linux ~]$ touch permissions/myfile.txt
    [student@linux ~]$ ls -l permissions/
    total 0
    -rw-r--r--. 1 student student 0 Mar  8 10:59 myfile.txt
    ```

2. Copy a file owned by root from /etc/ to your permissions dir, who
owns this file now ?

    ```console
    [student@linux ~]$ ls -l /etc/hosts
    -rw-r--r--. 1 root root 174 Feb 26 15:05 /etc/hosts
    [student@linux ~]$ cp /etc/hosts ~/permissions/
    [student@linux ~]$ ls -l permissions/hosts
    -rw-r--r--. 1 student student 174 Mar  8 11:00 permissions/hosts
    ```

    The copy is owned by you.

3. As root, create a file in the users `~/permissions` directory.

    ```console
    [student@linux ~]$ sudo touch permissions/rootfile.txt
    [sudo] password for student:
    ```

4. As normal user, look at who owns this file created by root.

    ```console
    [student@linux ~]$ ls -l permissions/*.txt
    -rw-r--r--. 1 student student 0 Mar  8 10:59 permissions/myfile.txt
    -rw-r--r--. 1 root    root    0 Mar  8 11:02 permissions/rootfile.txt
    ```

    The file created by root is owned by root.

5. Change the ownership of all files in \~/permissions to yourself.

    ```console
    [student@linux ~]$ chown student ~/permissions/*
    chown: changing ownership of '/home/student/permissions/rootfile.txt': Operation not permitted
    ```

    You cannot become owner of the file that belongs to root. Root must change the ownership.

6. Delete the file created by root. Is this possible?

    ```console
    [student@linux ~]$ rm ~/permissions/rootfile.txt
    rm: remove write-protected regular empty file '/home/student/permissions/rootfile.txt'? y
    [student@linux ~]$ ls -l permissions/*.txt
    -rw-r--r--. 1 student student 0 Mar  8 10:59 permissions/myfile.txt
    ```

    You can delete the file since you have write permission on the directory!

7. With chmod, is 770 the same as `rwxrwx---`?

    yes

8. With chmod, is 664 the same as `r-xr-xr--`?

    no, `rw-rw-r--` is 664 and `r-xr-xr--` is 774

9. With chmod, is 400 the same as `r--------`?

    yes

10. With chmod, is 734 the same as `rwxr-xr--`?

    no, `rwxr-xr--` is 754 and `rwx-wxr--` is 734

11. Display the umask in octal and in symbolic form.

    `umask` and `umask -S`

12. Set the umask to 0077, but use the symbolic format to set it. Verify
that this works.

    ```console
    [student@linux ~]$ umask -S u=rwx,go=
    u=rwx,g=,o=
    [student@linux ~]$ umask
    0077
    ```

13. Create a file as root, give only read to others. Can a normal user read this file? Test writing to this file with `vi` or `nano`.

    ```console
    [student@linux ~]$ sudo vi permissions/rootfile.txt
    [student@linux ~]$ sudo chmod 644 permissions/rootfile.txt
    [student@linux ~]$ ls -l permissions/*.txt
    -rw-r--r--. 1 student student 0 Mar  8 10:59 permissions/myfile.txt
    -rw-r--r--. 1 root    root    6 Mar  8 13:53 permissions/rootfile.txt
    [student@linux ~]$ cat permissions/rootfile.txt
    hello
    [student@linux ~]$ echo " world" >> permissions/rootfile.txt
    -bash: permissions/rootfile.txt: Permission denied
    ```

    Yes, a normal user can read the file, but not write to it.

14. Create a file as a normal user, take away all permissions for the group and others. Can you still read the file? Can root read the file? Can root write to the file?

    ```console
    [student@linux ~]$ vi permissions/privatefile.txt
    ... (editing the file) ...
    [student@linux ~]$ cat permissions/privatefile.txt
    hello
    [student@linux ~]$ chmod 600 permissions/privatefile.txt
    [student@linux ~]$ ls -l permissions/privatefile.txt
    -rw-------. 1 student student 0 Mar  8 16:06 permissions/privatefile.txt
    [student@linux ~]$ cat permissions/privatefile.txt
    hello
    ```

    Of course, the owner can still read (and write to) the file.

    ```console
    [student@linux ~]$ sudo vi permissions/privatefile.txt
    [sudo] password for student:
    ... (editing the file) ...
    [student@linux ~]$ cat permissions/privatefile.txt
    hello world
    ```

    Root can read and write to the file. In fact, root ignores all file permissions and can do anything with any file.

15. Create a directory `shared/` that belongs to group `users`, where every member of that group can read and write to files, and create files.

    ```console
    [student@linux ~]$ mkdir shared
    [student@linux ~]$ sudo chgrp users shared
    [student@linux ~]$ chmod 775 shared/
    [student@linux ~]$ ls -ld shared/
    drwxrwxr-x. 2 student users 6 Mar  8 18:26 shared/
    ```

