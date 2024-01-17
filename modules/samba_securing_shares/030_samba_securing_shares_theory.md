# security based on user name

## valid users

To restrict users per share, you can use the `valid users`
parameter. In the example below, only the users listed as valid will be
able to access the tennis share.

    [tennis]
        path = /srv/samba/tennis
        comment = authenticated and valid users only
        read only = No
        guest ok = No
        valid users = serena, kim, venus, justine 

## invalid users

If you are paranoia, you can also use `invalid users` to
explicitely deny the listed users access. When a user is in both lists,
the user has no access!

    [tennis]
        path = /srv/samba/tennis
        read only = No
        guest ok = No
        valid users = kim, serena, venus, justine
        invalid users = venus

## read list

On a writable share, you can set a list of read only users with the
`read list` parameter.

    [football]
        path = /srv/samba/football
        read only = No
        guest ok = No
        read list = martina, roberto

## write list

Even on a read only share, you can set a list of users that can write.
Use the `write list` parameter.

    [football]
        path = /srv/samba/golf
        read only = Yes
        guest ok = No
        write list = eddy, jan

# security based on ip-address

## hosts allow

The `hosts allow` or `allow hosts` parameter
is one of the key advantages of Samba. It allows access control of
shares on the ip-address level. To allow only specific hosts to access a
share, list the hosts, separated by comma\'s.

    allow hosts = 192.168.1.5, 192.168.1.40

Allowing entire subnets is done by ending the range with a dot.

    allow hosts = 192.168.1.

Subnet masks can be added in the classical way.

    allow hosts = 10.0.0.0/255.0.0.0

You can also allow an entire subnet with exceptions.

    hosts allow = 10. except 10.0.0.12

## hosts deny

The `hosts deny` or `deny hosts` parameter
is the logical counterpart of the previous. The syntax is the same as
for hosts allow.

    hosts deny = 192.168.1.55, 192.168.1.56

# security through obscurity

## hide unreadable

Setting `hide unreadable` to yes will prevent users from
seeing files that cannot be read by them.

    hide unreadable = yes

## browsable

Setting the `browseable = no` directive will hide shares
from My Network Places. But it will not prevent someone from accessing
the share (when the name of the share is known).

Note that `browsable` and `browseable` are both correct
syntax.

    [pubread]
     path = /srv/samba/readonly
     comment = files to read
     read only = yes
     guest ok = yes
     browseable = no

# file system security

## create mask

You can use `create mask` and
`directory mask` to set the maximum allowed permissions
for newly created files and directories. The mask you set is an AND mask
(it takes permissions away).

    [tennis]
        path = /srv/samba/tennis
        read only = No
        guest ok = No
        create mask = 640
        directory mask = 750

## force create mode

Similar to `create mask`, but different. Where the mask from above was a
logical AND, the mode you set here is a logical OR (so it adds
permissions). You can use the `force create mode` and
`force directory mode` to set the minimal required
permissions for newly created files and directories.

    [tennis]
        path = /srv/samba/tennis
        read only = No
        guest ok = No
        force create mode = 444
        force directory mode = 550

## security mask

The `security mask` and
`directory security mask` work in the same way as
`create mask` and `directory mask`, but apply only when a windows user
is changing permissions using the windows security dialog box.

## force security mode

The `force security mode` and
`force directory security mode` work in the same way as
`force create mode` and `force directory mode`, but apply only when a
windows user is changing permissions using the windows security dialog
box.

## inherit permissions

With `inherit permissions = yes` you can force newly created files and
directories to inherit permissions from their parent directory,
overriding the create mask and directory mask settings.

    [authwrite]
        path = /srv/samba/authwrite
        comment = authenticated users only
        read only = no  
        guest ok = no   
        create mask = 600
        directory mask = 555
        inherit permissions = yes
