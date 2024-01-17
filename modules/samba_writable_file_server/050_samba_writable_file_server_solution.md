# solution: writable file server

1\. Create a directory and share it with Samba.

    mkdir /srv/samba/writable

    chmod 777 /srv/samba/writable

    the share section in smb.conf can look like this:

    [pubwrite]
     path = /srv/samba/writable
     comment = files to write
     read only = no
     guest ok = yes

2\. Make sure everyone can read and write files, test writing with
smbclient and from a Microsoft computer.

    to test writing with smbclient:

    echo one > count.txt
    echo two >> count.txt
    echo three >> count.txt
    smbclient //localhost/pubwrite
    Password: 
    smb: \> put count.txt

3\. Verify the ownership of files created by (various) users.

    ls -l /srv/samba/writable
