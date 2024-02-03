## changes in smb.conf

### workgroup

The `workgroup` option in the global section should match the netbios
name of the Active Directory domain.

    workgroup = STARGATE
            

### security mode

Authentication will not be handled by samba now, but by the Active
Directory domain controllers, so we set the `security` option to domain.

    security = Domain
            

### Linux uid\'s

Linux requires a user account for every user accessing its file system,
we need to provide Samba with a range of uid\'s and gid\'s that it can
use to create these user accounts. The range is determined with the
`idmap uid` and the `idmap gid` parameters.
The first Active Directory user to connect will receive Linux uid 20000.

    idmap uid = 20000-22000
    idmap gid = 20000-22000
            

### winbind use default domain

The `winbind use default domain` parameter makes sure
winbind also operates on users without a domain component in their name.

    winbind use default domain = yes
            

### \[global\] section in smb.conf

Below is our new global section in `smb.conf`.

    [global]
     workgroup = STARGATE
     security = Domain
     server string = Stargate Domain Member Server
     idmap uid = 20000-22000
     idmap gid = 20000-22000
     winbind use default domain = yes
            

### realm in /etc/krb5.conf

To connect to a Windows 2003 sp2 (or later) you will need to adjust the
kerberos realm in `/etc/krb5.conf` and set both lookup statements to
true.

    [libdefaults]
     default_realm = STARGATE.LOCAL
     dns_lookup_realm = true
     dns_lookup_kdc = true
            

### \[share\] section in smb.conf

Nothing special is required for the share section in smb.conf. Remember
that we do not manually create users in smbpasswd or on the Linux
(/etc/passwd). Only Active Directory users are allowed access.

    [domaindata]
     path = /srv/samba/domaindata
     comment = Active Directory users only
     read only = No
            

## joining an Active Directory domain

While the Samba server is stopped, you can use
`net rpc join` to join the Active Directory domain.

    [root@RHEL52 samba]# service smb stop
    Shutting down SMB services:                                [  OK  ]
    Shutting down NMB services:                                [  OK  ]
    [root@RHEL52 samba]# net rpc join -U Administrator
    Password:
    Joined domain STARGATE.
        

We can verify in the aduc (Active Directory Users and Computers) that a
computer account is created for this samba server.

![](../images/sambacomputeraccount.jpg)

## winbind

### adding winbind to nsswitch.conf

The `winbind daemon` is talking with the Active Directory
domain.

We need to update the `/etc/nsswitch.conf` file now, so
user group and host names can be resolved against the winbind daemon.

    [root@RHEL52 samba]# vi /etc/nsswitch.conf 
    [root@RHEL52 samba]# grep winbind /etc/nsswitch.conf 
    passwd:     files winbind
    group:      files winbind
    hosts:      files dns winbind
            

### starting samba and winbindd

Time to start Samba followed by `winbindd`.

    [root@RHEL8b samba]# service smb start
    Starting SMB services:                                     [  OK  ]
    Starting NMB services:                                     [  OK  ]
    [root@RHEL8b samba]# service winbind start
    Starting winbindd services:                                [  OK  ]
    [root@RHEL8b samba]# 
            

## wbinfo

### verify the trust

You can use `wbinfo -t` to verify the trust between your
samba server and Active Directory.

    [root@RHEL52 ~]# wbinfo -t
    checking the trust secret via RPC calls succeeded
            

### list all users

We can obtain a list of all user with the `wbinfo -u` command. The
domain is not shown when the `winbind use default domain` parameter is
set.

    [root@RHEL52 ~]# wbinfo -u
    TEACHER0\serena
    TEACHER0\justine
    TEACHER0\martina
    STARGATE\administrator
    STARGATE\guest
    STARGATE\support_388945a0
    STARGATE\pol
    STARGATE\krbtgt
    STARGATE\arthur
    STARGATE\harry
            

### list all groups

We can obtain a list of all domain groups with the `wbinfo -g` command.
The domain is not shown when the `winbind use default domain` parameter
is set.

    [root@RHEL52 ~]# wbinfo -g
    BUILTIN\administrators
    BUILTIN\users
    BATMAN\domain computers
    BATMAN\domain controllers
    BATMAN\schema admins
    BATMAN\enterprise admins
    BATMAN\domain admins
    BATMAN\domain users
    BATMAN\domain guests
    BATMAN\group policy creator owners
    BATMAN\dnsupdateproxy
            

### query a user

We can use `wbinfo -a` to verify authentication of a user
against Active Directory. Assuming a user account `harry` with password
`stargate` is just created on the Active Directory, we get the following
screenshot.

    [root@RHEL52 ~]# wbinfo -a harry%stargate
    plaintext password authentication succeeded
    challenge/response password authentication succeeded
            

## getent

We can use `getent` to verify that winbindd is working and
actually adding the Active directory users to /etc/passwd.

    [root@RHEL52 ~]# getent passwd harry
    harry:*:20000:20008:harry potter:/home/BATMAN/harry:/bin/false
    [root@RHEL52 ~]# getent passwd arthur
    arthur:*:20001:20008:arthur dent:/home/BATMAN/arthur:/bin/false
    [root@RHEL52 ~]# getent passwd bilbo
    bilbo:*:20002:20008:bilbo baggins:/home/BATMAN/bilbo:/bin/false
        

If the user already exists locally, then the local user account is
shown. This is because winbind is configured in
`/etc/nsswitch.conf` after `files`.

    [root@RHEL52 ~]# getent passwd paul
    paul:x:500:500:Paul Cobbaut:/home/paul:/bin/bash
        

All the Active Directory users can now easily connect to the Samba
share. Files created by them, belong to them.

## file ownership

    [root@RHEL8b samba]# ll /srv/samba/domaindata/
    total 0
    -rwxr--r--  1 justine 20000 0 Jun 22 19:54 create_by_justine_on_winxp.txt
    -rwxr--r--  1 venus   20000 0 Jun 22 19:55 create_by_venus.txt
    -rwxr--r--  1 maria   20000 0 Jun 22 19:57 Maria.txt
        
