## solution: user management

1\. Create a user account named `serena`, including a home directory and
a description (or comment) that reads `Serena Williams`. Do all this in
one single command.

    root@linux:~# useradd -m -c 'Serena Williams' serena

2\. Create a user named `venus`, including home directory, bash shell, a
description that reads `Venus Williams` all in one single command.

    root@linux:~# useradd -m -c "Venus Williams" -s /bin/bash venus

3\. Verify that both users have correct entries in `/etc/passwd`,
`/etc/shadow` and `/etc/group`.

    root@linux:~# tail -2 /etc/passwd
    serena:x:1008:1010:Serena Williams:/home/serena:/bin/sh
    venus:x:1009:1011:Venus Williams:/home/venus:/bin/bash
    root@linux:~# tail -2 /etc/shadow
    serena:!:16358:0:99999:7:::
    venus:!:16358:0:99999:7:::
    root@linux:~# tail -2 /etc/group
    serena:x:1010:
    venus:x:1011:

4\. Verify that their home directory was created.

    root@linux:~# ls -lrt /home | tail -2
    drwxr-xr-x 2 serena    serena    4096 Oct 15 10:50 serena
    drwxr-xr-x 2 venus     venus     4096 Oct 15 10:59 venus
    root@linux:~#

5\. Create a user named `einstime` with `/bin/date` as his default logon
shell.

    root@linux:~# useradd -s /bin/date einstime

Or even better:

    root@linux:~# useradd -s $(which date) einstime

6\. What happens when you log on with the `einstime` user ? Can you
think of a useful real world example for changing a user\'s login shell
to an application ?

    root@linux:~# su - einstime
    Wed Oct 15 11:05:56 UTC 2014    # You get the output of the date command
    root@linux:~#

It can be useful when users need to access only one application on the
server. Just logging in opens the application for them, and closing the
application automatically logs them out.

7\. Create a file named `welcome.txt` and make sure every new user will
see this file in their home directory.

    root@linux:~# echo Hello > /etc/skel/welcome.txt

8\. Verify this setup by creating (and deleting) a test user account.

    root@linux:~# useradd -m test
    root@linux:~# ls -l /home/test
    total 4
    -rw-r--r-- 1 test test 6 Oct 15 11:16 welcome.txt
    root@linux:~# userdel -r test
    root@linux:~#

9\. Change the default login shell for the `serena` user to `/bin/bash`.
Verify before and after you make this change.

    root@linux:~# grep serena /etc/passwd
    serena:x:1008:1010:Serena Williams:/home/serena:/bin/sh
    root@linux:~# usermod -s /bin/bash serena
    root@linux:~# grep serena /etc/passwd
    serena:x:1008:1010:Serena Williams:/home/serena:/bin/bash
    root@linux:~#

