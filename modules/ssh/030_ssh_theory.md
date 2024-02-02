## about ssh

### secure shell

Avoid using `telnet`, `rlogin` and
`rsh` to remotely connect to your servers. These older
protocols do not encrypt the login session, which means your user id and
password can be sniffed by tools like `wireshark` or
`tcpdump`. To securely connect to your servers, use `ssh`.

The `ssh protocol` is secure in two ways. Firstly the connection is
`encrypted` and secondly the connection is `authenticated` both ways.

An ssh connection always starts with a cryptographic handshake, followed
by `encryption` of the transport layer using a symmetric cypher. In
other words, the tunnel is encrypted before you start typing anything.

Then `authentication` takes place (using user id/password or
public/private keys) and communication can begin over the encrypted
connection.

The `ssh protocol` will remember the servers it connected to (and warn
you in case something suspicious happened).

The `openssh` package is maintained by the `OpenBSD`
people and is distributed with a lot of operating systems (it may even
be the most popular package in the world).

### /etc/ssh/

Configuration of `ssh` client and server is done in the
`/etc/ssh` directory. In the next sections we will discuss
most of the files found in `/etc/ssh/`.

### ssh protocol versions

The `ssh` protocol has two versions (1 and 2). Avoid using version 1
anywhere, since it contains some known vulnerabilities. You can control
the protocol version via `/etc/ssh/ssh_config` for the
client side and `/etc/ssh/sshd_config` for the
openssh-server daemon.

    paul@ubu1204:/etc/ssh$ grep Protocol ssh_config 
    #   Protocol 2,1
    paul@ubu1204:/etc/ssh$ grep Protocol sshd_config 
    Protocol 2

### public and private keys

The `ssh` protocol uses the well known system of
`public and private keys`. The below explanation is
succinct, more information can be found on wikipedia.

    http://en.wikipedia.org/wiki/Public-key_cryptography

Imagine Alice and Bob, two people that like to communicate
with each other. Using `public and private keys` they can communicate
with `encryption` and with `authentication`.

When Alice wants to send an encrypted message to Bob, she uses the
`public key` of Bob. Bob shares his `public key` with Alice, but keeps
his `private key` private! Since Bob is the only one to
have Bob\'s `private key`, Alice is sure that Bob is the only one that
can read the encrypted message.

When Bob wants to verify that the message came from Alice, Bob uses the
`public key` of Alice to verify that Alice signed the message with her
`private key`. Since Alice is the only one to have Alice\'s
`private key`, Bob is sure the message came from Alice.

### rsa and dsa algorithms

This chapter does not explain the technical implementation of
cryptographic algorithms, it only explains how to use the ssh tools with
`rsa` and `dsa`. More information about
these algorithms can be found here:

    http://en.wikipedia.org/wiki/RSA_(algorithm)
    http://en.wikipedia.org/wiki/Digital_Signature_Algorithm

## log on to a remote server

The following screenshot shows how to use `ssh` to log on to a remote
computer running Linux. The local user is named `paul` and he is logging
on as user `admin42` on the remote system.

    paul@ubu1204:~$ ssh admin42@192.168.1.30
    The authenticity of host '192.168.1.30 (192.168.1.30)' can't be established.
    RSA key fingerprint is b5:fb:3c:53:50:b4:ab:81:f3:cd:2e:bb:ba:44:d3:75.
    Are you sure you want to continue connecting (yes/no)?

As you can see, the user `paul` is presented with an `rsa`
authentication fingerprint from the remote system. The user can accepts
this bu typing `yes`. We will see later that an entry will be added to
the `~/.ssh/known_hosts` file.

    paul@ubu1204:~$ ssh admin42@192.168.1.30
    The authenticity of host '192.168.1.30 (192.168.1.30)' can't be established.
    RSA key fingerprint is b5:fb:3c:53:50:b4:ab:81:f3:cd:2e:bb:ba:44:d3:75.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '192.168.1.30' (RSA) to the list of known hosts.
    admin42@192.168.1.30's password: 
    Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-26-generic-pae i686)

     * Documentation:  https://help.ubuntu.com/

    1 package can be updated.
    0 updates are security updates.

    Last login: Wed Jun  6 19:25:57 2012 from 172.28.0.131
    admin42@ubuserver:~$

The user can get log out of the remote server by typing `exit` or by
using `Ctrl-d`.

    admin42@ubuserver:~$ exit
    logout
    Connection to 192.168.1.30 closed.
    paul@ubu1204:~$

## executing a command in remote

This screenshot shows how to execute the `pwd` command on the remote
server. There is no need to `exit` the server manually.

    paul@ubu1204:~$ ssh admin42@192.168.1.30 pwd
    admin42@192.168.1.30's password: 
    /home/admin42
    paul@ubu1204:~$

## scp

The `scp` command works just like `cp`, but allows the source and
destination of the copy to be behind `ssh`. Here is an example where we
copy the `/etc/hosts` file from the remote server to the home directory
of user paul.

    paul@ubu1204:~$ scp admin42@192.168.1.30:/etc/hosts /home/paul/serverhosts
    admin42@192.168.1.30's password: 
    hosts                                        100%  809     0.8KB/s   00:00

Here is an example of the reverse, copying a local file to a remote
server.

    paul@ubu1204:~$ scp ~/serverhosts admin42@192.168.1.30:/etc/hosts.new
    admin42@192.168.1.30's password: 
    serverhosts                                  100%  809     0.8KB/s   00:00

## setting up passwordless ssh

To set up passwordless ssh authentication through public/private keys,
use `ssh-keygen` to generate a key pair without a passphrase, and then
copy your public key to the destination server. Let\'s do this step by
step.

In the example that follows, we will set up ssh without password between
Alice and Bob. Alice has an account on a Red Hat Enterprise Linux
server, Bob is using Ubuntu on his laptop. Bob wants to give Alice
access using ssh and the public and private key system. This means that
even if Bob changes his password on his laptop, Alice will still have
access.

### ssh-keygen

The example below shows how Alice uses `ssh-keygen` to
generate a key pair. Alice does not enter a passphrase.

    [alice@RHEL5 ~]$ ssh-keygen -t rsa
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/alice/.ssh/id_rsa): 
    Created directory '/home/alice/.ssh'.
    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again: 
    Your identification has been saved in /home/alice/.ssh/id_rsa.
    Your public key has been saved in /home/alice/.ssh/id_rsa.pub.
    The key fingerprint is:
    9b:ac:ac:56:c2:98:e5:d9:18:c4:2a:51:72:bb:45:eb alice@RHEL5
    [alice@RHEL5 ~]$

You can use `ssh-keygen -t dsa` in the same way.

### \~/.ssh

While `ssh-keygen` generates a public and a private key, it will also
create a hidden `.ssh` directory with proper permissions.
If you create the `.ssh` directory manually, then you need to chmod 700
it! Otherwise ssh will refuse to use the keys (world readable private
keys are not secure!).

As you can see, the `.ssh` directory is secure in Alice\'s home
directory.

    [alice@RHEL5 ~]$ ls -ld .ssh
    drwx------ 2 alice alice 4096 May  1 07:38 .ssh
    [alice@RHEL5 ~]$

Bob is using Ubuntu at home. He decides to manually create the `.ssh`
directory, so he needs to manually secure it.

    bob@laika:~$ mkdir .ssh
    bob@laika:~$ ls -ld .ssh
    drwxr-xr-x 2 bob bob 4096 2008-05-14 16:53 .ssh
    bob@laika:~$ chmod 700 .ssh/
    bob@laika:~$

### id_rsa and id_rsa.pub

The `ssh-keygen` command generate two keys in .ssh. The
public key is named `~/.ssh/id_rsa.pub`. The private key
is named `~/.ssh/id_rsa`.

    [alice@RHEL5 ~]$ ls -l .ssh/
    total 16
    -rw------- 1 alice alice 1671 May  1 07:38 id_rsa
    -rw-r--r-- 1 alice alice  393 May  1 07:38 id_rsa.pub

The files will be named `id_dsa` and
`id_dsa.pub` when using `dsa` instead of `rsa`.

### copy the public key to the other computer

To copy the public key from Alice\'s server tot Bob\'s laptop, Alice
decides to use `scp`.

    [alice@RHEL5 .ssh]$ scp id_rsa.pub bob@192.168.48.92:~/.ssh/authorized_keys
    bob@192.168.48.92's password: 
    id_rsa.pub                                    100%  393     0.4KB/s   00:00

Be careful when copying a second key! Do not overwrite the first key,
instead append the key to the same `~/.ssh/authorized_keys` file!

    cat id_rsa.pub >> ~/.ssh/authorized_keys

Alice could also have used `ssh-copy-id` like in this example.

    ssh-copy-id -i .ssh/id_rsa.pub bob@192.168.48.92

### authorized_keys

In your \~/.ssh directory, you can create a file called
`authorized_keys`. This file can contain one or more
public keys from people you trust. Those trusted people can use their
private keys to prove their identity and gain access to your account via
ssh (without password). The example shows Bob\'s authorized_keys file
containing the public key of Alice.

    bob@laika:~$ cat .ssh/authorized_keys 
    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEApCQ9xzyLzJes1sR+hPyqW2vyzt1D4zTLqk\
    MDWBR4mMFuUZD/O583I3Lg/Q+JIq0RSksNzaL/BNLDou1jMpBe2Dmf/u22u4KmqlJBfDhe\
    yTmGSBzeNYCYRSMq78CT9l9a+y6x/shucwhaILsy8A2XfJ9VCggkVtu7XlWFDL2cum08/0\
    mRFwVrfc/uPsAn5XkkTscl4g21mQbnp9wJC40pGSJXXMuFOk8MgCb5ieSnpKFniAKM+tEo\
    /vjDGSi3F/bxu691jscrU0VUdIoOSo98HUfEf7jKBRikxGAC7I4HLa+/zX73OIvRFAb2hv\
    tUhn6RHrBtUJUjbSGiYeFTLDfcTQ== alice@RHEL5

### passwordless ssh

Alice can now use ssh to connect passwordless to Bob\'s laptop. In
combination with `ssh`\'s capability to execute commands on the remote
host, this can be useful in pipes across different machines.

    [alice@RHEL5 ~]$ ssh bob@192.168.48.92 "ls -l .ssh"
    total 4
    -rw-r--r-- 1 bob bob 393 2008-05-14 17:03 authorized_keys
    [alice@RHEL5 ~]$

## X forwarding via ssh

Another popular feature of `ssh` is called `X11 forwarding` and is
implemented with `ssh -X`.

Below an example of X forwarding: user paul logs in as user greet on her
computer to start the graphical application mozilla-thunderbird.
Although the application will run on the remote computer from greet, it
will be displayed on the screen attached locally to paul\'s computer.

    paul@debian10:~/PDF$ ssh -X greet@greet.dyndns.org -p 55555
    Warning: Permanently added the RSA host key for IP address \
    '81.240.174.161' to the list of known hosts.
    Password: 
    Linux raika 2.6.8-2-686 #1 Tue Aug 16 13:22:48 UTC 2005 i686 GNU/Linux
                    
    Last login: Thu Jan 18 12:35:56 2007
    greet@raika:~$ ps fax | grep thun
    greet@raika:~$ mozilla-thunderbird &
    [1] 30336

## troubleshooting ssh

Use `ssh -v` to get debug information about the ssh connection attempt.

    paul@debian10:~$ ssh -v bert@192.168.1.192
    OpenSSH_4.3p2 Debian-8ubuntu1, OpenSSL 0.9.8c 05 Sep 2006
    debug1: Reading configuration data /home/paul/.ssh/config
    debug1: Reading configuration data /etc/ssh/ssh_config
    debug1: Applying options for *
    debug1: Connecting to 192.168.1.192 [192.168.1.192] port 22.
    debug1: Connection established.
    debug1: identity file /home/paul/.ssh/identity type -1
    debug1: identity file /home/paul/.ssh/id_rsa type 1
    debug1: identity file /home/paul/.ssh/id_dsa type -1
    debug1: Remote protocol version 1.99, remote software version OpenSSH_3
    debug1: match: OpenSSH_3.9p1 pat OpenSSH_3.*
    debug1: Enabling compatibility mode for protocol 2.0
    ...

## sshd

The ssh server is called `sshd` and is provided by the
`openssh-server` package.

    root@ubu1204~# dpkg -l openssh-server | tail -1
    ii  openssh-server   1:5.9p1-5ubuntu1    secure shell (SSH) server,... 

## sshd keys

The public keys used by the sshd server are located in
`/etc/ssh` and
are world readable. The private keys are only readable by root.

    root@ubu1204~# ls -l /etc/ssh/ssh_host_*
    -rw------- 1 root root  668 Jun  7  2011 /etc/ssh/ssh_host_dsa_key
    -rw-r--r-- 1 root root  598 Jun  7  2011 /etc/ssh/ssh_host_dsa_key.pub
    -rw------- 1 root root 1679 Jun  7  2011 /etc/ssh/ssh_host_rsa_key
    -rw-r--r-- 1 root root  390 Jun  7  2011 /etc/ssh/ssh_host_rsa_key.pub

## ssh-agent

When generating keys with `ssh-keygen`, you have the option to enter a
passphrase to protect access to the keys. To avoid having to type this
passphrase every time, you can add the key to `ssh-agent` using
`ssh-add`.

Most Linux distributions will start the `ssh-agent` automatically when
you log on.

    root@ubu1204~# ps -ef | grep ssh-agent
    paul     2405  2365  0 08:13 ?        00:00:00 /usr/bin/ssh-agent...

This clipped screenshot shows how to use `ssh-add` to list the keys that
are currently added to the `ssh-agent`

    paul@debian10:~$ ssh-add -L
    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvgI+Vx5UrIsusZPl8da8URHGsxG7yivv3/\
    ...
    wMGqa48Kelwom8TGb4Sgcwpp/VO/ldA5m+BGCw== paul@deb106
