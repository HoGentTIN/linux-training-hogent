## creating the users on Linux

The goal of this example is to set up a file share accessible to a
number of different users. The users will need to authenticate with
their password before access to this share is granted. We will first
create three randomly named users, each with their own password. First
we add these users to Linux.

    [root@linux ~]# useradd -c "Serena Williams" serena
    [root@linux ~]# useradd -c "Justine Henin" justine
    [root@linux ~]# useradd -c "Martina Hingis" martina
    [root@linux ~]# passwd serena
    Changing password for user serena.
    New UNIX password: 
    Retype new UNIX password: 
    passwd: all authentication tokens updated successfully.
    [root@linux ~]# passwd justine
    Changing password for user justine.
    New UNIX password: 
    Retype new UNIX password: 
    passwd: all authentication tokens updated successfully.
    [root@linux ~]# passwd martina
    Changing password for user martina.
    New UNIX password: 
    Retype new UNIX password: 
    passwd: all authentication tokens updated successfully.
        

## creating the users on samba

Then we add them to the `smbpasswd` file, with the same
password.

    [root@linux ~]# smbpasswd -a serena
    New SMB password:
    Retype new SMB password:
    Added user serena.
    [root@linux ~]# smbpasswd -a justine
    New SMB password:
    Retype new SMB password:
    Added user justine.
    [root@linux ~]# smbpasswd -a martina
    New SMB password:
    Retype new SMB password:
    Added user martina.
            

## security = user

Remember that we set samba's security mode to share with the
`security = share` directive in the \[global\] section ?
Since we now require users to always provide a userid and password for
access to our samba server, we will need to change this. Setting
`security = user` will require the client to provide samba with a valid
userid and password before giving access to a share.

Our \[global\] section now looks like this.

    [global]
     workgroup = WORKGROUP
     netbios name = TEACHER0
     server string = Samba File Server
     security = user
        

## configuring the share

We add the following \[share\] section to our smb.conf (and we do not
forget to create the directory /srv/samba/authwrite).

    [authwrite]
    path = /srv/samba/authwrite
    comment = authenticated users only
    read only = no
    guest ok = no
        

## testing access with net use

After restarting samba, we test with different users from within
Microsoft computers. The screenshots use the
`net use`First serena from Windows XP.

    C:\>net use m: \\teacher0\authwrite stargate /user:serena
    The command completed successfully.

    C:\>m:

    M:\>echo greetings from Serena > serena.txt
            

The next screenshot is martina on a Windows 2000 computer, she succeeds
in writing her files, but fails to overwrite the file from serena.

    C:\>net use k: \\teacher0\authwrite stargate /user:martina
    The command completed successfully.

    C:\>k:

    K:\>echo greetings from martina > Martina.txt

    K:\>echo test overwrite > serena.txt
    Access is denied.
            

## testing access with smbclient

You can also test connecting with authentication with
`smbclient`. First we test with a wrong password.

    [root@linux samba]# smbclient //teacher0/authwrite -U martina wrongpass
    session setup failed: NT_STATUS_LOGON_FAILURE
        

Then we test with the correct password, and verify that we can access a
file on the share.

    [root@linux samba]# smbclient //teacher0/authwrite -U martina stargate
    Domain=[TEACHER0] OS=[Unix] Server=[Samba 3.0.33-3.7.el5]
    smb: \> more serena.txt 
    getting file \serena.txt of size 14 as /tmp/smbmore.QQfmSN (6.8 kb/s)
    one
    two
    three
    smb: \> q
        

## verify ownership

We now have a simple standalone samba file server with authenticated
access. And the files in the shares belong to their proper owners.

    [root@linux samba]# ls -l /srv/samba/authwrite/
    total 8
    -rwxr--r-- 1 martina martina  0 Jan 21 20:06 martina.txt
    -rwxr--r-- 1 serena  serena  14 Jan 21 20:06 serena.txt
    -rwxr--r-- 1 serena  serena   6 Jan 21 20:09 ser.txt
        

## common problems

### NT_STATUS_BAD_NETWORK_NAME

You can get `NT_STATUS_BAD_NETWORK_NAME` when you forget
to create the target directory.

    [root@linux samba]# rm -rf /srv/samba/authwrite/
    [root@linux samba]# smbclient //teacher0/authwrite -U martina stargate
    Domain=[TEACHER0] OS=[Unix] Server=[Samba 3.0.33-3.7.el5]
    tree connect failed: NT_STATUS_BAD_NETWORK_NAME
            

### NT_STATUS_LOGON_FAILURE

You can get `NT_STATUS_LOGON_FAILURE` when you type the
wrong password or when you type an unexisting username.

    [root@linux samba]# smbclient //teacher0/authwrite -U martina STARGATE
    session setup failed: NT_STATUS_LOGON_FAILURE
            

### usernames are (not) case sensitive

Remember that usernames om Linux are case sensitive.

    [root@linux samba]# su - MARTINA
    su: user MARTINA does not exist
    [root@linux samba]# su - martina
    [martina@linux ~]$ 
            

But usernames on Microsoft computers are not case sensitive.

    [root@linux samba]# smbclient //teacher0/authwrite -U martina stargate
    Domain=[TEACHER0] OS=[Unix] Server=[Samba 3.0.33-3.7.el5]
    smb: \> q
    [root@linux samba]# smbclient //teacher0/authwrite -U MARTINA stargate
    Domain=[TEACHER0] OS=[Unix] Server=[Samba 3.0.33-3.7.el5]
    smb: \> q
            

