## solution: user passwords

1\. Set the password for `serena` to `hunter2`.

    root@linux:~# passwd serena
    Enter new UNIX password:
    Retype new UNIX password:
    passwd: password updated successfully

2\. Also set a password for `venus` and then lock the `venus` user
account with `usermod`. Verify the locking in `/etc/shadow` before and
after you lock it.

    root@linux:~# passwd venus
    Enter new UNIX password:
    Retype new UNIX password:
    passwd: password updated successfully
    root@linux:~# grep venus /etc/shadow | cut -c1-70
    venus:$6$gswzXICW$uSnKFV1kFKZmTPaMVS4AvNA/KO27OxN0v5LHdV9ed0gTyXrjUeM/
    root@linux:~# usermod -L venus
    root@linux:~# grep venus /etc/shadow | cut -c1-70
    venus:!$6$gswzXICW$uSnKFV1kFKZmTPaMVS4AvNA/KO27OxN0v5LHdV9ed0gTyXrjUeM

Note that `usermod -L` precedes the password hash with an exclamation
mark (!).

3\. Use `passwd -d` to disable the `serena` password. Verify the
`serena` line in `/etc/shadow` before and after disabling.

    root@linux:~# grep serena /etc/shadow | cut -c1-70
    serena:$6$Es/omrPE$F2Ypu8kpLrfKdW0v/UIwA5jrYyBD2nwZ/dt.i/IypRgiPZSdB/B
    root@linux:~# passwd -d serena
    passwd: password expiry information changed.
    root@linux:~# grep serena /etc/shadow
    serena::16358:0:99999:7:::
    root@linux:~#

4\. What is the difference between locking a user account and disabling
a user account\'s password like we just did with `usermod -L` and
`passwd -d`?

Locking will prevent the user from logging on to the system with his
password by putting a ! in front of the password in `/etc/shadow`.

Disabling with `passwd` will erase the password from `/etc/shadow`.

5\. Try changing the password of serena to serena as serena.

    log on as serena, then execute: passwd serena... it should fail!

6\. Make sure `serena` has to change her password in 10 days.

    chage -M 10 serena

7\. Make sure every new user needs to change their password every 10
days.

    vi /etc/login.defs (and change PASS_MAX_DAYS to 10)

8\. Take a backup as root of `/etc/shadow`. Use `vi` to copy an
encrypted `hunter2` hash from `venus` to `serena`. Can `serena` now log
on with `hunter2` as a password ?

    Yes.

9\. Why use `vipw` instead of `vi` ? What could be the problem when
using `vi` or `vim` ?

    vipw will give a warning when someone else is already using that file (with vipw).

10\. Use `chsh` to list all shells (only works on RHEL/CentOS/Fedora),
and compare to `cat /etc/shells`.

    chsh -l
    cat /etc/shells

11\. Which `useradd` option allows you to name a home directory ?

    -d

12\. How can you see whether the password of user `serena` is locked or
unlocked ? Give a solution with `grep` and a solution with `passwd`.

    grep serena /etc/shadow

    passwd -S serena

