## practice: sticky, setuid and setgid bits

1. Create a directory `/home/sports`.

    1. Ensure the directory is owned by the group sports.

    2. Members of the sports group should be able to create files in this directory.

    3. All files created in this directory should be group-owned by the sports group.

    4. Users should be able to delete only their own user-owned files.

    5. Test that this works!

2. Verify the permissions on `/usr/bin/passwd`. Remove the `setuid`, then try changing your password as a normal user. Reset the permissions back and try again.

3. If time permits (or if you are waiting for other students to finish this practice), read about file attributes in the man page of `chattr` and `lsattr`. Try setting the `i` attribute on a file and test that it works.

