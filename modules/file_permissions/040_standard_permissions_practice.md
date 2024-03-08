## practice: standard file permissions

1. As normal user, create a directory `~/permissions`. Create a file
owned by yourself in there.

2. Copy a file owned by root from /etc/ to your permissions dir, who
owns this file now ?

3. As root, create a file in the users `~/permissions` directory.

4. As normal user, look at who owns this file created by root.

5. Change the ownership of all files in `~/permissions` to yourself.

6. Delete the file created by root. Is this possible?

7. With chmod, is 770 the same as `rwxrwx---`?

8. With chmod, is 664 the same as `r-xr-xr--`?

9. With chmod, is 400 the same as `r--------`?

10. With chmod, is 734 the same as `rwxr-xr--`?

11. Display the umask value in octal and in symbolic form.

12. Set the umask to 0077, but use the symbolic format to set it. Verify that this works.

13. Create a file as root, give only read to others. Can a normal user read this file? Test writing to this file with `vi` or `nano`.

14. Create a file as a normal user, take away all permissions for the group owner and others. Can you still read the file? Can root read the file? Can root write to the file?

15. Create a directory that belongs to group `users`, where every member of that group can read and write to files, and create files. Make sure that people can only delete their own files.

