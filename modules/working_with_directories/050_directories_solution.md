## solution: working with directories

1\. Display your current directory.

    pwd

2\. Change to the /etc directory.

    cd /etc

3\. Now change to your home directory using only three key presses.

    cd (and the enter key)

4\. Change to the /boot/grub directory using only eleven key presses.

    cd /boot/grub (use the tab key)

5\. Go to the parent directory of the current directory.

    cd .. (with space between cd and ..)

6\. Go to the root directory.

    cd /

7\. List the contents of the root directory.

    ls

8\. List a long listing of the root directory.

    ls -l

9\. Stay where you are, and list the contents of /etc.

    ls /etc

10\. Stay where you are, and list the contents of /bin and /sbin.

    ls /bin /sbin

11\. Stay where you are, and list the contents of \~.

    ls ~

12\. List all the files (including hidden files) in your home directory.

    ls -al ~

13\. List the files in /boot in a human readable format.

    ls -lh /boot

14\. Create a directory testdir in your home directory.

    mkdir ~/testdir

15\. Change to the /etc directory, stay here and create a directory
newdir in your home directory.

    cd /etc ; mkdir ~/newdir

16\. Create in one command the directories \~/dir1/dir2/dir3 (dir3 is a
subdirectory from dir2, and dir2 is a subdirectory from dir1 ).

    mkdir -p ~/dir1/dir2/dir3

17\. Remove the directory testdir.

    rmdir testdir

18\. If time permits (or if you are waiting for other students to finish
this practice), use and understand `pushd` and `popd`. Use the man page
of `bash` to find information about these commands.

    man bash           # opens the manual
    /pushd             # searches for pushd
    n                  # next (do this two/three times)

The Bash shell has two built-in commands called `pushd`
and `popd`. Both commands work with a common stack of
previous directories. Pushd adds a directory to the stack and changes to
a new current directory, popd removes a directory from the stack and
sets the current directory.

    paul@debian10:/etc$ cd /bin
    paul@debian10:/bin$ pushd /lib
    /lib /bin
    paul@debian10:/lib$ pushd /proc
    /proc /lib /bin
    paul@debian10:/proc$ popd
    /lib /bin
    paul@debian10:/lib$ popd
    /bin

