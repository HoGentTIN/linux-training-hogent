## creating a samba user

We will create a user for our samba file server and make this user the
owner of the directory and all of its files. This anonymous user gets a
clear description, but does not get a login shell.

    [root@RHEL52 samba]# useradd -s /bin/false sambanobody
    [root@RHEL52 samba]# usermod -c "Anonymous Samba Access" sambanobody
    [root@RHEL52 samba]# passwd sambanobody
    Changing password for user sambanobody.
    New UNIX password: 
    Retype new UNIX password: 
    passwd: all authentication tokens updated successfully.

## ownership of files

We can use this user as owner of files and directories, instead of using
the root account. This approach is clear and more secure.

    [root@RHEL52 samba]# chown -R sambanobody:sambanobody /srv/samba/
    [root@RHEL52 samba]# ls -al /srv/samba/writable/
    total 12
    drwxrwxrwx 2 sambanobody sambanobody 4096 Jan 21 06:11 .
    drwxr-xr-x 6 sambanobody sambanobody 4096 Jan 21 06:11 ..
    -rwxr--r-- 1 sambanobody sambanobody    6 Jan 21 06:16 hoi.txt

## /usr/bin/smbpasswd

The sambanobody user account that we created in the previous examples is
not yet used by samba. It just owns the files and directories that we
created for our shares. The goal of this section is to force ownership
of files created through the samba share to belong to our sambanobody
user. Remember, our server is still accessible to everyone, nobody needs
to know this user account or password. We just want a clean Linux
server.

To accomplish this, we first have to tell Samba about this user. We can
do this by adding the account to `smbpasswd`.

    [root@RHEL52 samba]# smbpasswd -a sambanobody
    New SMB password:
    Retype new SMB password:
    Added user sambanobody.

## /etc/samba/smbpasswd

To find out where Samba keeps this information (for now), use
`smbd -b`. The PRIVATE_DIR variable will show you where
the smbpasswd database is located.

    [root@RHEL52 samba]# smbd -b | grep PRIVATE
       PRIVATE_DIR: /etc/samba
    [root@RHEL52 samba]# ls -l smbpasswd 
    -rw------- 1 root root 110 Jan 21 06:19 smbpasswd

You can use a simple cat to see the contents of the
`smbpasswd` database. The sambanobody user does have a
password (it is secret).

    [root@RHEL52 samba]# cat smbpasswd 
    sambanobody:503:AE9 ... 9DB309C528E540978:[U          ]:LCT-4976B05B:

## passdb backend

Note that recent versions of Samba have `tdbsam` as
default for the `passdb backend` paramater.

    root@ubu1110:~# testparm -v 2>/dev/null| grep 'passdb backend'

        passdb backend = tdbsam

## forcing this user

Now that Samba knows about this user, we can adjust our writable share
to force the ownership of files created through it. For this we use the
`force user` and `force group` options. Now
we can be sure that all files in the Samba writable share are owned by
the same sambanobody user.

Below is the renewed definition of our share in smb.conf.

    [pubwrite]
     path = /srv/samba/writable
     comment = files to write
     force user = sambanobody
     force group = sambanobody
     read only = no
     guest ok = yes
        

When you reconnect to the share and write a file, then this sambanobody
user will own the newly created file (and nobody needs to know the
password).

