## practice: sticky, setuid and setgid bits

1a. Set up a directory, owned by the group sports.

1b. Members of the sports group should be able to create files in this
directory.

1c. All files created in this directory should be group-owned by the
sports group.

1d. Users should be able to delete only their own user-owned files.

1e. Test that this works!

2\. Verify the permissions on `/usr/bin/passwd`. Remove the `setuid`,
then try changing your password as a normal user. Reset the permissions
back and try again.

3\. If time permits (or if you are waiting for other students to finish
this practice), read about file attributes in the man page of chattr and
lsattr. Try setting the i attribute on a file and test that it works.

