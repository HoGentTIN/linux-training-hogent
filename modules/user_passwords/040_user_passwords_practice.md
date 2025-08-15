## practice: user passwords

1. Set the password for `serena` to `hunter2`.

2. Also set a password for `venus` and then lock the `venus` user account with `usermod`. Verify the locking in `/etc/shadow` before and after you lock it.

3. Use `passwd -d` to disable the `serena` password. Verify the `serena` line in `/etc/shadow` before and after disabling.

4. What is the difference between locking a user account and disabling a user account's password like we just did with `usermod -L` and `passwd -d`?

5. Try changing the password of serena to serena as serena.

6. Make sure `serena` has to change her password in 10 days.

7. Make sure every new user needs to change their password every 10 days.

8. Take a backup as root of `/etc/shadow`. Use `vi` to copy an encrypted `hunter2` hash from `venus` to `serena`. Can `serena` now log on with `hunter2` as a password ?

9. Why use `vipw` instead of `vi` ? What could be the problem when using `vi` or `vim` ?

10. Use `chsh` to list all shells (only works on RHEL/CentOS/Fedora), and compare to `cat /etc/shells`.

11. Which `useradd` option allows you to name a home directory ?

12. How can you see whether the password of user `serena` is locked or unlocked ? Give a solution with `grep` and a solution with `passwd`.

