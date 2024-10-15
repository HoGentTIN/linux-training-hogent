## practice: user management

1. Create a user account named `serena`, including a home directory and a description (or comment) that reads `Serena Williams`. Do all this in one single command.

2. Create a second user named `venus`, including home directory, Bash as login shell, a description that reads `Venus Williams` all in one single command.

3. Verify that both users have correct entries in `/etc/passwd`,
`/etc/shadow` and `/etc/group`.

4. Verify that their home directory was created.

5. Create a user named `einstime` with the `date` command as their default logon shell, `/tmp` as their home directory and an empty string as password.

6. What happens when you log on with the `einstime` user? Can you
think of a useful real world example for changing a user's login shell to an application?

7. Create a file named `welcome.txt` and make sure every new user will see this file in their home directory.

8. Verify this setup by creating (and deleting) a test user account.

9. Change the default login shell for the `serena` user to `/bin/zsh`. Verify before and after you make this change.

