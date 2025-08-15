## solution: samba authentication

1. Create three users (on the Linux and on the samba), remember their passwords!

    ```
    useradd -c 'SMB user1' userx

    passwd userx
    ```

2. Set up a shared directory that is only accessible to authenticated users.

    ```
    The shared section in smb.conf could look like this:

    [authwrite]
     path = /srv/samba/authwrite
     comment = authenticated users only
     read only = no  
     guest ok = no
    ``` 

3. Use smbclient and a windows computer to access your share, use more
than one user account (windows requires a logoff/logon for this).

    - on Linux: `smbclient //studentX/authwrite -U user1 password`

    - on Windows: `net use p: \\studentX\authwrite password /user:user2`

4. Verify that files created by these users belong to them.

    ```
    ls -l /srv/samba/authwrite
    ```

5. Try to change or delete a file from another user.

    you should not be able to change or overwrite files from others.

