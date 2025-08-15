## about Domain Controllers

### Windows NT4

Windows NT4 works with single master replication domain controllers.
There is exactly one PDC (Primary Domain Controller) in the domain, and
zero or more BDC's (Backup Domain Controllers). Samba 3 has all
features found in Windows NT4 PDC and BDC, and more. This includes file
and print serving, domain control with single logon, logon scripts, home
directories and roaming profiles.

### Windows 200x

With Windows 2000 came Active Directory. AD includes multimaster
replication and group policies. Samba 3 can only be a member server in
Active Directory, it cannot manage group policies. Samba 4 can do this
(in beta).

### Samba 3

Samba 3 can act as a domain controller in its own domain. In a Windows
NT4 domain, with one Windows NT4 PDC and zero or more BDC's, Samba 3
can only be a member server. The same is valid for Samba 3 in an Active
Directory Domain. In short, a Samba 3 domain controller can not share
domain control with Windows domain controllers.

### Samba 4

Samba 4 can be a domain controller in an Active Directory domain,
including managing group policies. As of this writing, Samba 4 is not
released for production!

## About security modes

### security = share

The 'Windows for Workgroups' way of working, a client requests
connection to a share and provides a password for that connection.
Aanyone who knows a password for a share can access that share. This
security model was common in Windows 3.11, Windows 95, Windows 98 and
Windows ME.

### security = user

The client will send a userid + password before the server knows which
share the client wants to access. This mode should be used whenever the
samba server is in control of the user database. Both for standalone and
samba domain controllers.

### security = domain

This mode will allow samba to verify user credentials using NTLM in
Windows NT4 and in all Active Directory domains. This is similar to
Windows NT4 BDC's joining a native Windows 2000/3 Active Directory
domain.

### security = ads

This mode will make samba use Kerberos to connect to the Active
Directory domain.

### security = server

This mode is obsolete, it can be used to forward authentication to
another server.

## About password backends

The previous chapters all used the `smbpasswd` user
database. For domain control we opt for the `tdbsam`
password backend. Another option would be to use LDAP. Larger domains
will benefit from using LDAP instead of the not so scalable tdbsam. When
you need more than one Domain Controller, then the Samba team advises to
not use tdbsam.

## \[global\] section in smb.conf

Now is a good time to start adding comments in your smb.conf. First we
will take a look at the naming of our domain and server in the
`[global]` section, and at the domain controlling parameters.

### security

The security must be set to user (which is the default). This mode will
make samba control the user accounts, so it will allow samba to act as a
domain controller.

    security = user

### os level

A samba server is the most stable computer in the network, so it should
win all browser elections (`os level` above 32) to become the
`browser master`

    os level = 33

### passdb backend

The `passdb backend` parameter will determine whether samba uses
`smbpasswd`, `tdbsam` or ldap.

    passdb backend = tdbsam

### preferred master

Setting the `preferred master` parameter to yes will make the nmbd
daemon force an election on startup.

    preferred master = yes

### domain logons

Setting the `domain logons` parameter will make this samba server a
domain controller.

    domain logons = yes

### domain master

Setting the `domain master` parameter can cause samba to claim the
`domain master browser` role for its workgroup. Don't use this
parameter in a workgroup with an active NT4 PDC.

    domain master = yes

### \[global\] section

The screenshot below shows a sample \[global\] section for a samba
domain controller.

    [global]
    # names
        workgroup = SPORTS
        netbios name = DCSPORTS
        server string = Sports Domain Controller
    # domain control parameters
        security = user
        os level = 33
        preferred master = Yes
        domain master = Yes
        domain logons = Yes
            

## netlogon share

Part of the microsoft definition for a domain controller is that it
should have a `netlogon share`. This is the relevant part of smb.conf to
create this netlogon share on Samba.

    [netlogon]
    comment = Network Logon Service
    path = /srv/samba/netlogon
    admin users = root
    guest ok = Yes
    browseable = No
        

## other \[share\] sections

We create some sections for file shares, to test the samba server. Users
can all access the general sports file share, but only group members can
access their own sports share.

    [sports]
    comment = Information about all sports
    path = /srv/samba/sports
    valid users = @ntsports
    read only = No

    [tennis]
    comment = Information about tennis
    path = /srv/samba/tennis
    valid users = @nttennis
    read only = No

    [football]
    comment = Information about football
    path = /srv/samba/football
    valid users = @ntfootball
    read only = No
        

## Users and Groups

To be able to use users and groups in the samba domain controller, we
can first set up some groups on the Linux computer.

    [root@linux samba]# groupadd ntadmins
    [root@linux samba]# groupadd ntsports
    [root@linux samba]# groupadd ntfootball
    [root@linux samba]# groupadd nttennis
        

This enables us to add group membership info to some new users for our
samba domain. Don't forget to give them a password.

    [root@linux samba]# useradd -m -G ntadmins Administrator
    [root@linux samba]# useradd -m -G ntsports,nttennis venus
    [root@linux samba]# useradd -m -G ntsports,nttennis kim
    [root@linux samba]# useradd -m -G ntsports,nttennis jelena
    [root@linux samba]# useradd -m -G ntsports,ntfootball figo
    [root@linux samba]# useradd -m -G ntsports,ntfootball ronaldo
    [root@linux samba]# useradd -m -G ntsports,ntfootball pfaff
        

It is always safe to verify creation of users, groups and passwords in
/etc/passwd, /etc/shadow and /etc/group.

    [root@linux samba]# tail -11 /etc/group
    ntadmins:x:507:Administrator
    ntsports:x:508:venus,kim,jelena,figo,ronaldo,pfaff
    ntfootball:x:509:figo,ronaldo,pfaff
    nttennis:x:510:venus,kim,jelena
    Administrator:x:511:
    venus:x:512:
    kim:x:513:
    jelena:x:514:
    figo:x:515:
    ronaldo:x:516:
    pfaff:x:517:
        

## tdbsam

Next we must make these users known to samba with the smbpasswd tool.
When you add the first user to `tdbsam`, the file
`/etc/samba/passdb.tdb` will be created.

    [root@linux samba]# smbpasswd -a root
    New SMB password:
    Retype new SMB password:
    tdbsam_open: Converting version 0 database to version 3.
    Added user root.
        

Adding all the other users generates less output, because tdbsam is
already created.

    [root@linux samba]# smbpasswd -a root
    New SMB password:
    Retype new SMB password:
    Added user root.
        

## about computer accounts

Every NT computer (Windows NT, 2000, XP, Vista) can become a member of a
domain. Joining the domain (by right-clicking on My Computer) means that
a computer account will be created in the domain. This computer account
also has a password (but you cannot know it) to prevent other computers
with the same name from accidentally becoming member of the domain. The
computer account created by Samba is visible in the
`/etc/passwd` file on Linux. Computer accounts appear as a
normal user account, but end their name with a dollar sign. Below a
screenshot of the windows 2003 computer account, created by Samba 3.

    [root@linux samba]# tail -5 /etc/passwd
    jelena:x:510:514::/home/jelena:/bin/bash
    figo:x:511:515::/home/figo:/bin/bash
    ronaldo:x:512:516::/home/ronaldo:/bin/bash
    pfaff:x:513:517::/home/pfaff:/bin/bash
    w2003ee$:x:514:518::/home/nobody:/bin/false
        

To be able to create the account, you will need to provide credentials
of an account with the permission to create accounts (by default only
root can do this on Linux). And we will have to tell Samba how to to
this, by adding an `add machine script` to the global section of
smb.conf.

    add machine script = /usr/sbin/useradd -s /bin/false -d /home/nobody %u
        

You can now join a Microsoft computer to the sports domain (with the
root user). After reboot of the Microsoft computer, you will be able to
logon with Administrator (password Stargate1), but you will get an error
about your roaming profile. We will fix this in the next section.

When joining the samba domain, you have to enter the credentials of a
Linux account that can create users (usually only root can do this). If
the Microsoft computer complains with `The parameter is incorrect`, then
you possibly forgot to add the `add machine script`.

## local or roaming profiles

For your information, if you want to force local profiles instead of
roaming profiles, then simply add the following two lines to the global
section in smb.conf.

    logon home =
    logon path =
        

Microsoft computers store a lot of User Metadata and application data in
a user profile. Making this profile available on the network will enable
users to keep their Desktop and Application settings across computers.
User profiles on the network are called `roaming profiles`
or `roving profiles`. The Samba domain controller can manage these
profiles. First we need to add the relevant section in smb.conf.

    [Profiles]
     comment = User Profiles
     path = /srv/samba/profiles
     readonly = No
     profile acls = Yes
        

Besides the share section, we also need to set the location of the
profiles share (this can be another Samba server) in the global section.

    logon path = \\%L\Profiles\%U
        

The `%L` variable is the name of this Samba server, the `%U` variable
translates to the username. After adding a user to smbpasswd and letting
the user log on and off, the profile of the user will look like this.

    [root@linux samba]# ll /srv/samba/profiles/Venus/
    total 568
    drwxr-xr-x  4 Venus Venus   4096 Jul  5 10:03 Application Data
    drwxr-xr-x  2 Venus Venus   4096 Jul  5 10:03 Cookies
    drwxr-xr-x  3 Venus Venus   4096 Jul  5 10:03 Desktop
    drwxr-xr-x  3 Venus Venus   4096 Jul  5 10:03 Favorites
    drwxr-xr-x  4 Venus Venus   4096 Jul  5 10:03 My Documents
    drwxr-xr-x  2 Venus Venus   4096 Jul  5 10:03 NetHood
    -rwxr--r--  1 Venus Venus 524288 Jul  5  2007 NTUSER.DAT
    -rwxr--r--  1 Venus Venus   1024 Jul  5  2007 NTUSER.DAT.LOG
    -rw-r--r--  1 Venus Venus    268 Jul  5 10:03 ntuser.ini
    drwxr-xr-x  2 Venus Venus   4096 Jul  5 10:03 PrintHood
    drwxr-xr-x  2 Venus Venus   4096 Jul  5 10:03 Recent
    drwxr-xr-x  2 Venus Venus   4096 Jul  5 10:03 SendTo
    drwxr-xr-x  3 Venus Venus   4096 Jul  5 10:03 Start Menu
    drwxr-xr-x  2 Venus Venus   4096 Jul  5 10:03 Templates
        

## Groups in NTFS acls

We have users on Unix, we have groups on Unix that contain those users.

    [root@linux samba]# grep nt /etc/group
    ...
    ntadmins:x:506:Administrator
    ntsports:x:507:Venus,Serena,Kim,Figo,Pfaff
    nttennis:x:508:Venus,Serena,Kim
    ntfootball:x:509:Figo,Pfaff
    [root@linux samba]# 
        

We already added Venus to the `tdbsam` with `smbpasswd`.

    smbpasswd -a Venus

Does this mean that Venus can access the tennis and the sports shares ?
Yes, all access works fine on the Samba server. But the nttennis group
is not available on the windows machines. To make the groups available
on windows (like in the ntfs security tab of files and folders), we have
to map unix groups to windows groups. To do this, we use the
`net groupmap` command.

    [root@linux samba]# net groupmap add ntgroup="tennis" unixgroup=nttennis type=d
    No rid or sid specified, choosing algorithmic mapping
    Successully added group tennis to the mapping db
    [root@linux samba]# net groupmap add ntgroup="football" unixgroup=ntfootball type=d
    No rid or sid specified, choosing algorithmic mapping
    Successully added group football to the mapping db
    [root@linux samba]# net groupmap add ntgroup="sports" unixgroup=ntsports type=d
    No rid or sid specified, choosing algorithmic mapping
    Successully added group sports to the mapping db
    [root@linux samba]# 
        

Now you can use the Samba groups on all NTFS volumes on members of the
domain.

## logon scripts

Before testing a logon script, make sure it has the proper carriage
returns that DOS files have.

    [root@linux netlogon]# cat start.bat 
    net use Z: \\DCSPORTS0\SPORTS
    [root@linux netlogon]# unix2dos start.bat 
    unix2dos: converting file start.bat to DOS format ...
    [root@linux netlogon]# 
        

Then copy the scripts to the netlogon share, and add the following
parameter to smb.conf.

    logon script = start.bat

