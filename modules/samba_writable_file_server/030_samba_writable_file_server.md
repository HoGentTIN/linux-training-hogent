## set up a directory to share

In this second example, we will create a share where everyone can create
files and write to files. Again, we start by creating a directory

    [root@RHEL52 samba]# mkdir -p /srv/samba/writable
    [root@RHEL52 samba]# chmod 777 /srv/samba/writable/

## share section in smb.conf

There are two parameters to make a share writable. We can use
`read only` or `writable`. This example
shows how to use `writable` to give write access to a share.

    writable = yes

And this is an example of using the `read only` parameter to give write
access to a share.

    read only = no

## configure the share

Then we simply add a share to our file server by editing
`smb.conf`. Below the check with testparm. (We could have
changed the description of the server\...)

    [root@RHEL52 samba]# testparm
    Load smb config files from /etc/samba/smb.conf
    Processing section "[pubwrite]"
    Processing section "[pubread]"
    Loaded services file OK.
    Server role: ROLE_STANDALONE
    Press enter to see a dump of your service definitions

    [global]
        netbios name = TEACHER0
        server string = Public Anonymous File Server
        security = SHARE

    [pubwrite]
        comment = files to write
        path = /srv/samba/writable
        read only = No
        guest ok = Yes

    [pubread]
        comment = files to read
        path = /srv/samba/readonly
        guest ok = Yes

## test connection with windows

We can now test the connection on a windows 2003 computer. We use the
`net use` for this.

    C:\>net use L: \\teacher0\pubwrite
    net use L: \\teacher0\pubwrite
    The command completed successfully.

## test writing with windows

We mounted the `pubwrite` share on the L: drive in windows. Below we
test that we can write to this share.

    L:\>echo hoi > hoi.txt

    L:\>dir
     Volume in drive L is pubwrite
     Volume Serial Number is 0C82-272A

     Directory of L:\

    21/01/2009  06:11    <DIR>          .
    21/01/2009  06:11    <DIR>          ..
    21/01/2009  06:16                 6 hoi.txt
                   1 File(s)              6 bytes
                   2 Dir(s)  13.496.238.080 bytes free

## How is this possible ?

Linux (or any Unix) always needs a user account to gain access to a
system. The windows computer did not provide the samba server with a
user account or a password. Instead, the Linux owner of the files
created through this writable share is the Linux guest account (usually
named nobody).

    [root@RHEL52 samba]# ls -l /srv/samba/writable/
    total 4
    -rwxr--r-- 1 nobody nobody 6 Jan 21 06:16 hoi.txt

So this is not the cleanest solution. We will need to improve this.

