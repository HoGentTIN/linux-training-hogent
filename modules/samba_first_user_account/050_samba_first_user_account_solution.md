## solution: first samba user account

1. Create a user account for use with samba.

    useradd -s /bin/false smbguest

    usermod -c 'samba guest'

    passwd smbguest

2. Add this user to samba's user database.

    smbpasswd -a smbguest

3. Create a writable shared directory and use the \"force user\" and
\"force group\" directives to force ownership of files.

    [userwrite]
     path = /srv/samba/userwrite
     comment = everyone writes files owned by smbguest
     read only = no
     guest ok = yes
     force user = smbguest
     force group = smbguest
        

4. Test the working of force user with smbclient, net use and Windows
Explorer.

    ls -l /srv/samba/userwrite (and verify ownership)

