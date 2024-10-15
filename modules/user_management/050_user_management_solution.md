## solution: user management

1. Create a user account named `serena`, including a home directory and a description (or comment) that reads `Serena Williams`. Do all this in one single command.

    ```console
    student@debian:~$ sudo useradd -m -c 'Serena Williams' serena
    ```

2. Create a second user named `venus`, including home directory, Bash as login shell, a description that reads `Venus Williams` all in one single command.

    ```console
    student@debian:~$ sudo useradd -m -s /bin/bash -c 'Venus Williams' venus
    ```

3. Verify that both users have correct entries in `/etc/passwd`,
`/etc/shadow` and `/etc/group`.

    ```console
    student@debian:~$ getent passwd serena
    serena:x:1002:1002:Serena Williams:/home/serena:/bin/sh
    student@debian:~$ sudo getent shadow serena
    serena:!:20011:0:99999:7:::
    student@debian:~$ getent passwd venus
    venus:x:1003:1003:Venus Williams:/home/venus:/bin/bash
    student@debian:~$ sudo getent shadow venus
    venus:!:20011:0:99999:7:::
    ```

    > At this time, their password isn't set yet, so the shadow file will show `!` as the password hash, which also denotes that the account is locked.

    ```console
    student@debian:~$ sudo passwd serena
    New password: 
    Retype new password: 
    passwd: password updated successfully
    student@debian:~$ sudo getent shadow serena
    serena:$y$j9T$7VErSS/8GYyeALTc7nC0Y.$PeNsJlxzG3tfZ9yEk1rKgDRc4KJVZvHiWjwfdIeKSi0:20011:0:99999:7:::
    ```

    > Setting the password for `venus` is equivalent.

4. Verify that their home directory was created.

    ```console
    student@debian:~$ ls -l /home
    total 16
    drwxr-xr-x 2 serena  serena  4096 Oct 15 14:38 serena
    drwxr-xr-x 2 student student 4096 Oct 15 15:04 student
    drwxr-xr-x 2 venus   venus   4096 Oct 15 14:38 venus
    ```

5. Create a user named `einstime` with the `date` command as their default logon shell, `/tmp` as their home directory and an empty string as password.

    ```console
    student@debian:~$ sudo useradd -s $(which date) -d /tmp -p '' einstime
    student@debian:~$ getent passwd einstime
    einstime:x:1004:1004::/tmp:/bin/date
    student@debian:~$ sudo getent shadow einstime
    einstime::20011:0:99999:7:::
    ```

6. What happens when you log on with the `einstime` user? Can you
think of a useful real world example for changing a user's login shell to an application?

    ```console
    student@debian:~$ su - einstime
    Tue Oct 15 04:33:59 PM UTC 2024
    ```

    > You get to see the current time. This trick can also be useful when you want to restrict a user to a specific application only. Just logging in opens the application for them, and closing the application automatically logs them out.

7. Create a file named `welcome.txt` and make sure every new user will see this file in their home directory.

    ```console
    student@debian:~$ sudo nano /etc/skel/welcome.txt
    student@debian:~$ cat /etc/skel/welcome.txt 
    Welcome to Debian 12! Have fun while learning!
    ```

8. Verify this setup by creating (and deleting) a test user account.

    ```console
    student@debian:~$ sudo useradd -m -s /bin/bash testuser
    student@debian:~$ sudo su - testuser
    testuser@debian:~$ ls -l
    total 4
    -rw-r--r-- 1 testuser testuser 47 Oct 15 16:36 welcome.txt
    testuser@debian:~$ cat welcome.txt 
    Welcome to Debian 12! Have fun while learning!
    testuser@debian:~$ ^D
    logout
    student@debian:~$ sudo userdel -r testuser
    ```

9. Change the default login shell for the `serena` user to `/bin/zsh`. Verify before and after you make this change.

    ```console
    student@debian:~$ getent passwd serena
    serena:x:1002:1002:Serena Williams:/home/serena:/bin/sh
    student@debian:~$ sudo usermod -s /bin/zsh serena
    student@debian:~$ getent passwd serena
    serena:x:1002:1002:Serena Williams:/home/serena:/bin/zsh
    student@debian:~$ su - serena
    Password:
    serena@debian ~ % echo $SHELL
    /bin/zsh
    ```

