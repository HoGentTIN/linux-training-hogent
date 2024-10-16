## solution: introduction to users

1. Run a command that displays only your currently logged on user name.

    ```console
    laura@linux:~$ whoami
    laura
    laura@linux:~$ echo $USER
    laura
    ```

2. Display a list of all logged on users.

    ```console
    laura@linux:~$ who
    laura     pts/0        2014-10-13 07:22 (10.104.33.101)
    laura@linux:~$
    ```

3. Display a list of all logged on users including the command they are
running at this very moment.

    ```console
    laura@linux:~$ w
     07:47:02 up 16 min,  2 users,  load average: 0.00, 0.00, 0.00
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    root     pts/0    10.104.33.101    07:30    6.00s  0.04s  0.00s w
    root     pts/1    10.104.33.101    07:46    6.00s  0.01s  0.00s sleep 42
    laura@linux:~$
    ```

4. Display your user name and your unique user identification (userid).

    ```console
    laura@linux:~$ id
    uid=1005(laura) gid=1007(laura) groups=1007(laura)
    laura@linux:~$
    ```

5. Use `su` to switch to another user account (unless you are root, you will need the password of the other account). And get back to the previous account.

    ```console
    laura@linux:~$ su tania
    Password:
    tania@linux:/home/laura$ id
    uid=1006(tania) gid=1008(tania) groups=1008(tania)
    tania@linux:/home/laura$ exit
    laura@linux:~$
    ```

6. Now use `su -` to switch to another user and notice the difference.

    ```console
    laura@linux:~$ su - tania
    Password:
    tania@linux:~$ pwd
    /home/tania
    tania@linux:~$ logout
    laura@linux:~$
    ```

    > Note that `su -` gets you into the home directory of `tania`.

7. ry to create a new user account (when using your normal user account). This should fail. (Details on adding user accounts are explained in the chapter about user management.)

    ```console
    laura@linux:~$ useradd valentina
    -su: useradd: command not found
    laura@linux:~$ /usr/sbin/useradd valentina
    useradd: Permission denied.
    useradd: cannot lock /etc/passwd; try again later.
    laura@linux:~$
    ```

    > It is possible that `useradd` is located in `/sbin/useradd` on your computer.

8. Now try the same, but with `sudo` before your command.

    ```console
    laura@linux:~$ sudo /usr/sbin/useradd valentina
    [sudo] password for laura:
    laura is not in the sudoers file.  This incident will be reported.
    laura@linux:~$
    ```

    > Notice that `laura` has no permission to use the `sudo` on this system.

