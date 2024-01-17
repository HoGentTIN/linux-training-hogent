# network file system

## protocol versions

The older `nfs` versions 2 and 3 are stateless (udp) by
default, but they can use tcp. Clients connect to the server using
`rpc` (on Linux this is controlled by the
`portmap` daemon. Look at `rpcinfo` to
verify that `nfs` and its related services are running.

    root@RHELv8u2:~# /etc/init.d/portmap status
    portmap (pid 1920) is running...
    root@RHELv8u2:~# rpcinfo -p
    program vers proto   port
    100000    2   tcp    111  portmapper
    100000    2   udp    111  portmapper
    100024    1   udp  32768  status
    100024    1   tcp  32769  status
    root@RHELv8u2:~# service nfs start
    Starting NFS services:                                     [  OK  ]
    Starting NFS quotas:                                       [  OK  ]
    Starting NFS daemon:                                       [  OK  ]
    Starting NFS mountd:                                       [  OK  ]
            

The same `rpcinfo` command when `nfs` is started.

    root@RHELv8u2:~# rpcinfo -p
    program vers proto   port
    100000    2   tcp    111  portmapper
    100000    2   udp    111  portmapper
    100024    1   udp  32768  status
    100024    1   tcp  32769  status
    100011    1   udp    985  rquotad
    100011    2   udp    985  rquotad
    100011    1   tcp    988  rquotad
    100011    2   tcp    988  rquotad
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs
    100003    4   udp   2049  nfs
    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100021    1   udp  32770  nlockmgr
    100021    3   udp  32770  nlockmgr
    100021    4   udp  32770  nlockmgr
    100021    1   tcp  32789  nlockmgr
    100021    3   tcp  32789  nlockmgr
    100021    4   tcp  32789  nlockmgr
    100005    1   udp   1004  mountd
    100005    1   tcp   1007  mountd
    100005    2   udp   1004  mountd
    100005    2   tcp   1007  mountd
    100005    3   udp   1004  mountd
    100005    3   tcp   1007  mountd
    root@RHELv8u2:~#
            

`nfs version 4` requires tcp (port 2049) and supports
`Kerberos` user authentication as an option. `nfs`
authentication only takes place when mounting the share. `nfs` versions
2 and 3 authenticate only the host.

## server configuration

`nfs` is configured in `/etc/exports`. Here is a sample
`/etc/exports` to explain the syntax. You need some way (NIS domain or
LDAP) to synchronize userid\'s across computers when using `nfs` a lot.
The `rootsquash` option will change UID 0 to the UID of
the nfsnobody user account. The `sync` option will write writes to disk
before completing the client request.

    paul@laika:~$ cat /etc/exports 
    # Everyone can read this share
    /mnt/data/iso  *(ro)
                    
    # Only the computers barry and pasha can readwrite this one
    /var/www pasha(rw) barry(rw)
                    
    # same, but without root squashing for barry
    /var/ftp pasha(rw) barry(rw,no_root_squash)
                    
    # everyone from the netsec.lan domain gets access
    /var/backup       *.netsec.lan(rw)
                    
    # ro for one network, rw for the other
    /var/upload   192.168.1.0/24(ro) 192.168.5.0/24(rw)
            

You don\'t need to restart the nfs server to start exporting your newly
created exports. You can use the `exportfs -va` command to
do this. It will write the exported directories to
`/var/lib/nfs/etab`, where they are immediately applied.

## client configuration

We have seen the `mount` command and the
`/etc/fstab` file before.

    root@RHELv8u2:~# mount -t nfs barry:/mnt/data/iso /home/project55/
    root@RHELv8u2:~# cat /etc/fstab | grep nfs
    barry:/mnt/data/iso   /home/iso               nfs     defaults    0 0
    root@RHELv8u2:~# 
            

Here is another simple example. Suppose the project55 people tell you
they only need a couple of CD-ROM images, and you already have them
available on an `nfs` server. You could issue the following command to
mount this storage on their `/home/project55` mount point.

    root@RHELv8u2:~# mount -t nfs 192.168.1.40:/mnt/data/iso /home/project55/
    root@RHELv8u2:~# ls -lh /home/project55/
    total 3.6G
    drwxr-xr-x  2 1000 1000 4.0K Jan 16 17:55 RHELv8u1
    drwxr-xr-x  2 1000 1000 4.0K Jan 16 14:14 RHELv8u2
    drwxr-xr-x  2 1000 1000 4.0K Jan 16 14:54 RHELv8u3
    drwxr-xr-x  2 1000 1000 4.0K Jan 16 11:09 RHELv8u4
    -rw-r--r--  1 root root 1.6G Oct 13 15:22 sled10-vmwarews5-vm.zip
    root@RHELv8u2:~# 
            
