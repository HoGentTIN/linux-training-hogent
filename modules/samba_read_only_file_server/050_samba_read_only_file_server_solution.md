# solution: read only file server

1\. Create a directory in a good location (FHS) to share files for
everyone to read.

    choose one of these...

    mkdir -p /srv/samba/readonly

    mkdir -p /home/samba/readonly

    /home/paul/readonly is wrong!!

    /etc/samba/readonly is wrong!!

    /readonly is wrong!!

2\. Make sure the directory is owned properly and is world accessible.

    chown root:root /srv/samba/readonly

    chmod 755 /srv/samba/readonly

3\. Put a textfile in this directory.

    echo Hello World > hello.txt

4\. Share the directory with Samba.

    You smb.conf.readonly could look like this:
    [global]
     workgroup = WORKGROUP
     server string = Read Only File Server
     netbios name = STUDENTx
     security = share

    [readonlyX]
     path = /srv/samba/readonly
     comment = read only file share
     read only = yes
     guest ok = yes
        

    test with testparm before going in production!

5\. Verify from your own and from another computer (smbclient, net use,
\...) that the share is accessible for reading.

    On Linux: smbclient -NL 127.0.0.1

    On Windows Explorer: browse to My Network Places

    On Windows cmd.exe: net use L: //studentx/readonly

6\. Make a backup copy of your smb.conf, name it
smb.conf.ReadOnlyFileServer.

    cp smb.conf smb.conf.ReadOnlyFileServer
