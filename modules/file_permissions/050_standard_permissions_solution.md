## solution: standard file permissions

1\. As normal user, create a directory \~/permissions. Create a file
owned by yourself in there.

    mkdir ~/permissions ; touch ~/permissions/myfile.txt

2\. Copy a file owned by root from /etc/ to your permissions dir, who
owns this file now ?

    cp /etc/hosts ~/permissions/

The copy is owned by you.

3\. As root, create a file in the users \~/permissions directory.

    (become root)# touch /home/username/permissions/rootfile

4\. As normal user, look at who owns this file created by root.

    ls -l ~/permissions

The file created by root is owned by root.

5\. Change the ownership of all files in \~/permissions to yourself.

    chown user ~/permissions/*

You cannot become owner of the file that belongs to root.

6\. Make sure you have all rights to these files, and others can only
read.

    chmod 644 (on files)

    chmod 755 (on directories)

7\. With chmod, is 770 the same as rwxrwx\-\-- ?

yes

8\. With chmod, is 664 the same as r-xr-xr\-- ?

No

9\. With chmod, is 400 the same as r\-\-\-\-\-\-\-- ?

yes

10\. With chmod, is 734 the same as rwxr-xr\-- ?

no

11a. Display the umask in octal and in symbolic form.

    umask ; umask -S

11b. Set the umask to 077, but use the symbolic format to set it. Verify
that this works.

    umask -S u=rwx,go=

12\. Create a file as root, give only read to others. Can a normal user
read this file ? Test writing to this file with vi.

    (become root)

    # echo hello > /home/username/root.txt 

    # chmod 744 /home/username/root.txt

    (become user)

    vi ~/root.txt

13a. Create a file as normal user, give only read to others. Can another
normal user read this file ? Test writing to this file with vi.

    echo hello > file ; chmod 744 file

Yes, others can read this file

13b. Can root read this file ? Can root write to this file with vi ?

Yes, root can read and write to this file. Permissions do not apply to
root.

14\. Create a directory that belongs to a group, where every member of
that group can read and write to files, and create files. Make sure that
people can only delete their own files.

    mkdir /home/project42 ; groupadd project42

    chgrp project42 /home/project42 ; chmod 775 /home/project42

You can not yet do the last part of this exercise\...
