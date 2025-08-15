## practice : links

1. Create two files named winter.txt and summer.txt, put some text in
them.

2. Create a hard link to winter.txt named hlwinter.txt.

3. Display the inode numbers of these three files, the hard links
should have the same inode.

4. Use the find command to list the two hardlinked files

5. Everything about a file is in the inode, except two things : name
them!

6. Create a symbolic link to summer.txt called slsummer.txt.

7. Find all files with inode number 2. What does this information tell
you ?

8. Look at the directories /etc/init.d/ /etc/rc2.d/ /etc/rc3.d/ ... do
you see the links ?

9. Look in /lib with ls -l...

10. Use `find` to look in your home directory for regular files that
have more than one hard link (hint: this is identical to all regular
files that do not have exactly one hard link).

