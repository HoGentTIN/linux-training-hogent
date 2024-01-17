# acl in /etc/fstab

File systems that support `access control lists`, or
`acls`, have to be mounted with the `acl` option listed in
`/etc/fstab`. In the example below, you can see that the
root file system has `acl` support, whereas /home/data does not.

    root@laika:~# tail -4 /etc/fstab
    /dev/sda1        /              ext3     acl,relatime    0  1
    /dev/sdb2        /home/data     auto     noacl,defaults  0  0
    pasha:/home/r    /home/pasha    nfs      defaults        0  0
    wolf:/srv/data   /home/wolf     nfs      defaults        0  0

# getfacl

Reading `acls` can be done with `/usr/bin/getfacl`. This
screenshot shows how to read the `acl` of `file33` with
`getfacl`.

    paul@laika:~/test$ getfacl file33
    # file: file33
    # owner: paul
    # group: paul
    user::rw-
    group::r--
    mask::rwx
    other::r--

# setfacl

Writing or changing `acls` can be done with
`/usr/bin/setfacl`. These screenshots show how to change
the `acl` of `file33` with `setfacl`.

First we add `u`ser `sandra` with octal permission `7` to the `acl`.

    paul@laika:~/test$ setfacl -m u:sandra:7 file33

Then we add the `g`roup tennis with octal permission `6` to the `acl` of
the same file.

    paul@laika:~/test$ setfacl -m g:tennis:6 file33

The result is visible with `getfacl`.

    paul@laika:~/test$ getfacl file33 
    # file: file33
    # owner: paul
    # group: paul
    user::rw-
    user:sandra:rwx
    group::r--
    group:tennis:rw-
    mask::rwx
    other::r--

# remove an acl entry

The `-x` option of the `setfacl` command will remove an `acl` entry from
the targeted file.

    paul@laika:~/test$ setfacl -m u:sandra:7 file33 
    paul@laika:~/test$ getfacl file33 | grep sandra
    user:sandra:rwx
    paul@laika:~/test$ setfacl -x sandra file33
    paul@laika:~/test$ getfacl file33 | grep sandra

Note that omitting the `u` or `g` when defining the `acl` for an account
will default it to a user account.

# remove the complete acl

The `-b` option of the `setfacl` command will remove the `acl` from the
targeted file.

    paul@laika:~/test$ setfacl -b file33 
    paul@laika:~/test$ getfacl file33 
    # file: file33
    # owner: paul
    # group: paul
    user::rw-
    group::r--
    other::r--

# the acl mask

The `acl mask` defines the maximum effective permissions for any entry
in the `acl`. This `mask` is calculated every time you execute the
`setfacl` or `chmod` commands.

You can prevent the calculation by using the `--no-mask` switch.

    paul@laika:~/test$ setfacl --no-mask -m u:sandra:7 file33
    paul@laika:~/test$ getfacl file33
    # file: file33
    # owner: paul
    # group: paul
    user::rw-
    user:sandra:rwx         #effective:rw-
    group::r--
    mask::rw-
    other::r--
            

# eiciel

Desktop users might want to use `eiciel` to manage
`acls` with a graphical tool.

![](../images/eiciel_acls.jpg)

You will need to install `eiciel` and `nautilus-actions` to have an
extra tab in `nautilus` to manage `acls`.

    paul@laika:~$ sudo aptitude install eiciel nautilus-actions
            
