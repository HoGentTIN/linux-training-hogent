## /etc/samba/smb.conf

### smbd -b

Samba configuration is done in the `smb.conf` file. The
file can be edited manually, or you can use a web based interface like
webmin or swat to manage it. The file is usually located in /etc/samba.
You can find the exact location with `smbd -b`.

    [root@linux ~]# smbd -b | grep CONFIGFILE
    CONFIGFILE: /etc/samba/smb.conf

### the default smb.conf

The default smb.conf file contains a lot of examples with explanations.

    [student@linux ~]$ ls -l /etc/samba/smb.conf 
    -rw-r--r--  1 root root 10836 May 30 23:08 /etc/samba/smb.conf

Also on Ubuntu and Debian, smb.conf is packed with samples and
explanations.

    student@linux:~$ ls -l /etc/samba/smb.conf 
    -rw-r--r-- 1 root root 10515 2007-05-24 00:21 /etc/samba/smb.conf

### minimal smb.conf

Below is an example of a very minimalistic `smb.conf`. It allows samba
to start, and to be visible to other computers (Microsoft shows
computers in Network Neighborhood or My Network Places).

    [student@linux ~]$ cat /etc/samba/smb.conf
    [global]
    workgroup = WORKGROUP
    [firstshare]
    path = /srv/samba/public

### net view

Below is a screenshot of the `net view` command on
Microsoft Windows Server 2003 sp2. It shows how a Red Hat Enterprise
Linux 5.3 and a Ubuntu 9.04 Samba server, both with a minimalistic
smb.conf, are visible to Microsoft computers nearby.

    C:\Documents and Settings\Administrator>net view
    Server Name            Remark
    ----------------------------------------------------------------------
    \\LAIKA                Samba 3.3.2                                             
    \\RHEL53               Samba 3.0.33-3.7.el5                                    
    \\W2003                                                                        
    The command completed successfully.

### long lines in smb.conf

Some parameters in smb.conf can get a long list of values behind them.
You can continue a line (for clarity) on the next by ending the line
with a backslash.

    valid users = Serena, Venus, Lindsay \
                  Kim, Justine, Sabine \
                  Amelie, Marie, Suzanne

### curious smb.conf

Curious but true: smb.conf accepts synonyms like `create mode` and
`create mask`, and (sometimes) minor spelling errors like `browsable`
and `browseable`. And on occasion you can even switch words, the
`guest only` parameter is identical to `only guest`. And
`writable = yes` is the same as `readonly = no`.

### man smb.conf

You can access a lot of documentation when typing
`man smb.conf`.

    [root@linux samba]# apropos samba
    cupsaddsmb       (8)  - export printers to samba for windows clients
    lmhosts          (5)  - The Samba NetBIOS hosts file
    net              (8)  - Tool for administration of Samba and remote CIFS servers
    pdbedit          (8)  - manage the SAM database (Database of Samba Users)
    samba            (7)  - A Windows SMB/CIFS fileserver for UNIX
    smb.conf [smb]   (5)  - The configuration file for the Samba suite
    smbpasswd        (5)  - The Samba encrypted password file
    smbstatus        (1)  - report on current Samba connections
    swat             (8)  - Samba Web Administration Tool
    tdbbackup        (8)  - tool for backing up and ... of samba .tdb files
    [root@linux samba]#

## /usr/bin/testparm

### syntax check smb.conf

To verify the syntax of the smb.conf file, you can use
`testparm`.

    [student@linux ~]$ testparm
    Load smb config files from /etc/samba/smb.conf
    Processing section "[firstshare]"
    Loaded services file OK.
    Server role: ROLE_STANDALONE
    Press enter to see a dump of your service definitions

### testparm -v

An interesting option is `testparm -v`, which will output
all the global options with their default value.

    [root@linux ~]# testparm -v | head
    Load smb config files from /etc/samba/smb.conf
    Processing section "[pub0]"
    Processing section "[global$]"
    Loaded services file OK.
    Server role: ROLE_STANDALONE
    Press enter to see a dump of your service definitions

    [global]
        dos charset = CP850
        unix charset = UTF-8
        display charset = LOCALE
        workgroup = WORKGROUP
        realm = 
        netbios name = TEACHER0
        netbios aliases = 
        netbios scope = 
        server string = Samba 3.0.28-1.el5_2.1
    ...  

There were about 350 default values for smb.conf parameters in Samba
3.0.x. This number grew to almost 400 in Samba 3.5.x.

### testparm -s

The samba daemons are constantly (once every 60 seconds) checking the
smb.conf file, so it is good practice to keep this file small. But it is
also good practice to document your samba configuration, and to
explicitly set options that have the same default values. The
`testparm -s` option allows you to do both. It will output
the smallest possible samba configuration file, while retaining all your
settings. The idea is to have your samba configuration in another file
(like smb.conf.full) and let testparm parse this for you. The screenshot
below shows you how. First the smb.conf.full file with the explicitly
set option workgroup to WORKGROUP.

    [root@linux samba]# cat smb.conf.full 
    [global]
    workgroup = WORKGROUP

    # This is a demo of a documented smb.conf
    # These two lines are removed by testparm -s

    server string = Public Test Server

    [firstshare]
    path = /srv/samba/public

Next, we execute testparm with the -s option, and redirect stdout to the
real `smb.conf` file.

    [root@linux samba]# testparm -s smb.conf.full > smb.conf
    Load smb config files from smb.conf.full
    Processing section "[firstshare]"
    Loaded services file OK.

And below is the end result. The two comment lines and the default
option are no longer there.

    [root@linux samba]# cat smb.conf
    # Global parameters
    [global]
    server string = Public Test Server

    [firstshare]
    path = /srv/samba/public
    [root@linux samba]#

## /usr/bin/smbclient

### smbclient looking at Samba

With `smbclient` you can see browsing and share
information from your smb server. It will display all your shares, your
workgroup, and the name of the Master Browser. The -N switch is added to
avoid having to enter an empty password. The -L switch is followed by
the name of the host to check.

    [root@linux init.d]# smbclient -NL RHEL8b
    Anonymous login successful
    Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.0.10-1.4E.9]

    Sharename       Type      Comment
    ---------       ----      -------
    firstshare      Disk      
    IPC$            IPC       IPC Service (Public Test Server)
    ADMIN$          IPC       IPC Service (Public Test Server)
    Anonymous login successful
    Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.0.10-1.4E.9]

    Server               Comment
    ---------            -------
    RHEL8b               Public Test Server
    WINXP                

    Workgroup            Master
    ---------            -------
    WORKGROUP            WINXP

### smbclient anonymous

The screenshot below uses `smbclient` to display information about a
remote smb server (in this case a computer with Ubuntu 11.10).

    root@linux:/etc/samba# testparm smbclient -NL 127.0.0.1
    Anonymous login successful
    Domain=[LINUXTR] OS=[Unix] Server=[Samba 3.5.11]

        Sharename       Type      Comment
        ---------       ----      -------
        share1          Disk      
        IPC$            IPC       IPC Service (Samba 3.5.11)
    Anonymous login successful
    Domain=[LINUXTR] OS=[Unix] Server=[Samba 3.5.11]

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------
        LINUXTR              DEBIAN6
        WORKGROUP            UBU1110

### smbclient with credentials

Windows versions after xp sp2 and 2003 sp1 do not accept guest access
(the NT_STATUS_ACCESS_DENIED error). This example shows how to provide
credentials with `smbclient`.

    [student@linux ~]$ smbclient -L w2003 -U administrator%stargate
    Domain=[W2003] OS=[Windows Server 2003 3790 Service Pack 2] Server=...

        Sharename       Type      Comment
        ---------       ----      -------
        C$              Disk      Default share
        IPC$            IPC       Remote IPC
        ADMIN$          Disk      Remote Admin
    ...  

## /usr/bin/smbtree

Another useful tool to troubleshoot Samba or simply to browse the SMB
network is `smbtree`. In its simplest form, smbtree will
do an anonymous browsing on the local subnet. displaying all SMB
computers and (if authorized) their shares.

Let's take a look at two screenshots of smbtree in action (with blank
password). The first one is taken immediately after booting four
different computers (one MS Windows 2000, one MS Windows xp, one MS
Windows 2003 and one RHEL 4 with Samba 3.0.10).

    [student@linux ~]$ smbtree
    Password: 
    WORKGROUP
    PEGASUS
        \\WINXP          
        \\RHEL8b                        Pegasus Domain Member Server
    Error connecting to 127.0.0.1 (Connection refused)
    cli_full_connection: failed to connect to RHEL8b<20> (127.0.0.1)
        \\HM2003         
    [student@linux ~]$

The information displayed in the previous screenshot looks incomplete.
The browsing elections are still ongoing, the browse list is not yet
distributed to all clients by the (to be elected) browser master. The
next screenshot was taken about one minute later. And it shows even
less.

    [student@linux ~]$ smbtree
    Password: 
    WORKGROUP
        \\W2000          
    [student@linux ~]$

So we wait a while, and then run `smbtree` again, this time it looks a
lot nicer.

    [student@linux ~]$ smbtree
    Password: 
    WORKGROUP
        \\W2000          
    PEGASUS
        \\WINXP          
        \\RHEL8b                        Pegasus Domain Member Server
            \\RHEL8b\ADMIN$                 IPC Service (Pegasus Domain Member Server)
            \\RHEL8b\IPC$                   IPC Service (Pegasus Domain Member Server)
            \\RHEL8b\domaindata             Active Directory users only
        \\HM2003         
    [student@linux ~]$ smbtree --version
    Version 3.0.10-1.4E.9
    [student@linux ~]$

I added the version number of `smbtree` in the previous screenshot, to
show you the difference when using the latest version of smbtree (below
a screenshot taken from Ubuntu Feisty Fawn). The latest version shows a
more complete overview of machines and shares.

    student@linux:~$ smbtree --version
    Version 3.0.24
    student@linux:~$ smbtree
    Password: 
    WORKGROUP
        \\W2000          
            \\W2000\firstshare     
            \\W2000\C$              Default share
            \\W2000\ADMIN$          Remote Admin
            \\W2000\IPC$            Remote IPC
    PEGASUS
        \\WINXP          
    cli_rpc_pipe_open: cli_nt_create failed on pipe \srvsvc to machine WINXP.
    Error was NT_STATUS_ACCESS_DENIED
        \\RHEL8b                        Pegasus Domain Member Server
            \\RHEL8b\ADMIN$                 IPC Service (Pegasus Domain Member Server)
            \\RHEL8b\IPC$                   IPC Service (Pegasus Domain Member Server)
            \\RHEL8b\domaindata             Active Directory users only
        \\HM2003         
    cli_rpc_pipe_open: cli_nt_create failed on pipe \srvsvc to machine HM2003.
    Error was NT_STATUS_ACCESS_DENIED
    student@linux:~$

The previous screenshot also provides useful errors on why we cannot see
shared info on computers winxp and w2003. Let us try the old
`smbtree` version on our RHEL server, but this time with
Administrator credentials (which are the same on all computers).

    [student@linux ~]$ smbtree -UAdministrator%Stargate1
    WORKGROUP
         \\W2000          
    PEGASUS
         \\WINXP          
            \\WINXP\C$              Default share
            \\WINXP\ADMIN$          Remote Admin
            \\WINXP\share55        
            \\WINXP\IPC$            Remote IPC
         \\RHEL8b                   Pegasus Domain Member Server
            \\RHEL8b\ADMIN$         IPC Service (Pegasus Domain Member Server)
            \\RHEL8b\IPC$           IPC Service (Pegasus Domain Member Server)
            \\RHEL8b\domaindata     Active Directory users only
         \\HM2003         
            \\HM2003\NETLOGON       Logon server share 
            \\HM2003\SYSVOL         Logon server share 
            \\HM2003\WSUSTemp       A network share used by Local Publishing ...
            \\HM2003\ADMIN$         Remote Admin
            \\HM2003\tools          
            \\HM2003\IPC$           Remote IPC
            \\HM2003\WsusContent    A network share to be used by Local ...
            \\HM2003\C$             Default share
    [student@linux ~]$

As you can see, this gives a very nice overview of all SMB computers and
their shares.

## server string

The comment seen by the `net view` and the `smbclient`
commands is the default value for the `server string` option. Simply
adding this value to the global section in `smb.conf` and restarting
samba will change the option.

    [root@linux samba]# testparm -s 2>/dev/null | grep server
        server string = Red Hat Server in Paris

After a short while, the changed option is visible on the Microsoft
computers.

    C:\Documents and Settings\Administrator>net view
    Server Name            Remark

    -------------------------------------------------------------------------------
    \\LAIKA                Ubuntu 9.04 server in Antwerp                           
    \\RHEL53               Red Hat Server in Paris                                 
    \\W2003

## Samba Web Administration Tool (SWAT)

Samba comes with a web based tool to manage your samba configuration
file. `SWAT` is accessible with a web browser on port 901
of the host system. To enable the tool, first find out whether your
system is using the `inetd` or the `xinetd`
superdaemon.

    [root@linux samba]# ps fax | grep inet
        15026 pts/0    S+     0:00                      \_ grep inet
         2771 ?        Ss     0:00 xinetd -stayalive -pidfile /var/run/xinetd.pid
        [root@linux samba]#

Then edit the `inetd.conf` or change the disable = yes
line in `/etc/xinetd.d/swat` to disable = no.

    [root@linux samba]# cat /etc/xinetd.d/swat 
    # default: off
    # description: SWAT is the Samba Web Admin Tool. Use swat \
    #              to configure your Samba server. To use SWAT, \
    #              connect to port 901 with your favorite web browser.
    service swat
    {
        port            = 901
        socket_type     = stream
        wait            = no
        only_from       = 127.0.0.1
        user            = root
        server          = /usr/sbin/swat
        log_on_failure  += USERID
        disable         = no
    }
    [root@linux samba]# /etc/init.d/xinetd restart
    Stopping xinetd:                                           [  OK  ]
    Starting xinetd:                                           [  OK  ]
    [root@linux samba]#

Change the `only from` value to enable swat from remote computers. This
examples shows how to provide swat access to all computers in a /24
subnet.

    [root@linux xinetd.d]# grep only /etc/xinetd.d/swat 
        only_from   = 192.168.1.0/24

Be careful when using SWAT, it erases all your manually edited comments
in smb.conf.

