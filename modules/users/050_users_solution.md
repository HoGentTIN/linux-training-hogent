## solution: introduction to users

1\. Run a command that displays only your currently logged on user name.

    laura@debian9:~$ whoami
    laura
    laura@debian9:~$ echo $USER
    laura

2\. Display a list of all logged on users.

    laura@debian9:~$ who
    laura     pts/0        2014-10-13 07:22 (10.104.33.101)
    laura@debian9:~$

3\. Display a list of all logged on users including the command they are
running at this very moment.

    laura@debian9:~$ w
     07:47:02 up 16 min,  2 users,  load average: 0.00, 0.00, 0.00
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    root     pts/0    10.104.33.101    07:30    6.00s  0.04s  0.00s w
    root     pts/1    10.104.33.101    07:46    6.00s  0.01s  0.00s sleep 42
    laura@debian9:~$

4\. Display your user name and your unique user identification (userid).

    laura@debian9:~$ id
    uid=1005(laura) gid=1007(laura) groups=1007(laura)
    laura@debian9:~$

5\. Use `su` to switch to another user account (unless you are root, you
will need the password of the other account). And get back to the
previous account.

    laura@debian9:~$ su tania
    Password:
    tania@debian9:/home/laura$ id
    uid=1006(tania) gid=1008(tania) groups=1008(tania)
    tania@debian9:/home/laura$ exit
    laura@debian9:~$

6\. Now use `su -` to switch to another user and notice the difference.

    laura@debian9:~$ su - tania
    Password:
    tania@debian9:~$ pwd
    /home/tania
    tania@debian9:~$ logout
    laura@debian9:~$

Note that `su -` gets you into the home directory of `Tania`.

7\. Try to create a new user account (when using your normal user
account). this should fail. (Details on adding user accounts are
explained in the next chapter.)

    laura@debian9:~$ useradd valentina
    -su: useradd: command not found
    laura@debian9:~$ /usr/sbin/useradd valentina
    useradd: Permission denied.
    useradd: cannot lock /etc/passwd; try again later.

It is possible that `useradd` is located in `/sbin/useradd` on your
computer.

8\. Now try the same, but with `sudo` before your command.

    laura@debian9:~$ sudo /usr/sbin/useradd valentina
    [sudo] password for laura:
    laura is not in the sudoers file.  This incident will be reported.
    laura@debian9:~$

Notice that `laura` has no permission to use the `sudo` on this system.

