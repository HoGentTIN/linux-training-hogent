## solution: ssh

In this setup, we have two VMs created with Vagrant:

| Hostname | Role       | Distro      | IP address       |
| :------- | :--------- | :---------- | :--------------- |
| `debian` | SSH client | Debian 12   | 192.168.56.21/24 |
| `el`     | SSH server | AlmaLinux 9 | 192.168.56.11/24 |

1. On the `server`, check which version of the OpenSSH `server` is installed, which *should* be the case (especially for VMs created with Vagrant). If not, install it.

    ```console
    [vagrant@el ~]$ dnf list installed openssh*
    Installed Packages
    openssh.x86_64                   8.7p1-38.el9_4.4         @baseos
    openssh-clients.x86_64           8.7p1-38.el9_4.4         @baseos
    openssh-server.x86_64            8.7p1-38.el9_4.4         @baseos
    [vagrant@el ~]$ ssh -V
    OpenSSH_8.7p1, OpenSSL 3.0.7 1 Nov 2022
    [vagrant@el ~]$ systemctl status sshd
    ● sshd.service - OpenSSH server daemon
        Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
        Active: active (running) since Mon 2024-11-11 10:03:58 UTC; 4h 22min ago
        Docs: man:sshd(8)
                man:sshd_config(5)
    Main PID: 668 (sshd)
        Tasks: 1 (limit: 11128)
        Memory: 6.5M
            CPU: 208ms
        CGroup: /system.slice/sshd.service
                └─668 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
    ```

2. Verify in the ssh configuration files that the `Protocol` setting is absent, or that only protocol version 2 is allowed.

    ```console
    [vagrant@el ~]$ sudo find /etc/ssh/ -type f -exec grep -nHi protocol {} \;
    [vagrant@el ~]$
    ```

    > No output, so the Protocol setting is absent. Since we have OpenSSH 8.7p1, this is what we can expect, as support for Protocol 1 was dropped in OpenSSH 7.6.

3. Use `ssh` to log on to the `server`, show your current directory and then exit the `server`.

    ```console
    vagrant@debian:~$ ssh vagrant@192.168.56.11 pwd
    The authenticity of host '192.168.56.11 (192.168.56.11)' can't be established.
    ED25519 key fingerprint is SHA256:yw/ZrRXF4zpgbcjCSvM47MyFfg2DfOoiO1tMLVlthGU.
    This key is not known by any other names.
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    Warning: Permanently added '192.168.56.11' (ED25519) to the list of known hosts.
    vagrant@192.168.56.11's password: 
    /home/vagrant
    ```

4. Use `scp` to copy a file from the `client` to the `server`.

    > On the server, the home directory of user `vagrant` is now empty:

    ```console
    [vagrant@el ~]$ ls -l
    total 0
    ```

    > On the client, we create a file and copy it to the server:

    ```console
    vagrant@debian:~$ echo "Hello from Debian" > hello.txt
    vagrant@debian:~$ scp hello.txt vagrant@192.168.56.11:/home/vagrant
    vagrant@192.168.56.11's password: 
    hello.txt
    ```

    > On the server, the file is now present:

    ```console
    [vagrant@el ~]$ ls -l
    total 4
    -rw-r--r--. 1 vagrant vagrant 18 Nov 11 14:37 hello.txt
    [vagrant@el ~]$ cat hello.txt 
    Hello from Debian
    ```

5. Use `scp` to copy a file from the `server` to the `client`.

    > Let's remove the file locally and copy it back from the server:

    ```console
    vagrant@debian:~$ ls
    hello.txt
    vagrant@debian:~$ rm hello.txt 
    vagrant@debian:~$ ls -l
    total 0
    vagrant@debian:~$ scp vagrant@192.168.56.11:/home/vagrant/hello.txt .
    vagrant@192.168.56.11's password: 
    hello.txt                                   100%   18     7.3KB/s   00:00
    vagrant@debian:~$ ls -l
    total 4
    -rw-r--r-- 1 vagrant vagrant 18 Nov 11 14:36 hello.txt
    vagrant@debian:~$ cat hello.txt 
    Hello from Debian
    ```

6. Use `ssh-keygen` to create a key pair without passphrase on the `client`. Set up passwordless ssh between the `client` and `server`.

    ```console
    vagrant@debian:~$ ssh-keygen 
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): 
    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again: 
    Your identification has been saved in /home/vagrant/.ssh/id_rsa
    Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
    The key fingerprint is:
    SHA256:U1EQJVRL/BV8IX9XwVBGIBfAJfdtLkds5VNvM70kFxU vagrant@debian
    The key's randomart image is:
    +---[RSA 3072]----+
    |         .B@BOOE@|
    |           =*.==@|
    |          . .o X#|
    |         .    =*B|
    |        S     ..o|
    |         .     o |
    |                 |
    |                 |
    |                 |
    +----[SHA256]-----+
    vagrant@debian:~$ ssh-copy-id -i .ssh/id_rsa.pub vagrant@192.168.56.11
    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: ".ssh/id_rsa.pub"
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
    /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
    vagrant@192.168.56.11's password: 

    Number of key(s) added: 1

    Now try logging into the machine, with:   "ssh 'vagrant@192.168.56.11'"
    and check to make sure that only the key(s) you wanted were added.

    vagrant@debian:~$ ssh vagrant@192.168.56.11

    This system is built by the Bento project by Chef Software
    More information can be found at https://github.com/chef/bento

    Use of this system is acceptance of the OS vendor EULA and License Agreements.
    Last login: Mon Nov 11 10:04:49 2024 from 10.0.2.2
    [vagrant@el ~]$ 
    ```

7. Verify that the permissions on the `client` key files are correct; world readable for the public keys and only root access for the private keys.

    ```console
    vagrant@debian:~$ ls -ld .ssh/
    drwx------ 2 vagrant root 4096 Nov 11 14:41 .ssh/
    vagrant@debian:~$ ls -l .ssh/
    total 16
    -rw------- 1 vagrant vagrant   89 Oct 11 14:35 authorized_keys
    -rw------- 1 vagrant vagrant 2602 Nov 11 14:40 id_rsa
    -rw-r--r-- 1 vagrant vagrant  568 Nov 11 14:40 id_rsa.pub
    -rw------- 1 vagrant vagrant  978 Nov 11 14:30 known_hosts
    ```

8. On the `server`, check which public keys are authorized for the user you are using to log in.

    ```console
    [vagrant@el ~]$ ls -l .ssh/
    total 4
    -rw-------. 1 vagrant vagrant 657 Nov 11 14:47 authorized_keys
    [vagrant@el ~]$ cat .ssh/authorized_keys 
    ssh-ed25519 AAAAC3NzaC1lZDI1N......KVM04 vagrant
    ssh-rsa AAAAB3NzaC1yc2EAAAADA......8Toc= vagrant@debian
    ```

    > The first key is the one used by Vagrant to log in to the VM, the other one is the key we just added.

9. Verify that the `ssh-agent` is running.

    > In this case, the SSH agent is *not* running on the client, so we start it manually:

    ```console
    vagrant@debian:~$ ps -ef | grep ssh-agent
    vagrant     1608    1393  0 14:52 pts/0    00:00:00 grep ssh-agent
    vagrant@debian:~$ eval $(ssh-agent)
    Agent pid 1610
    vagrant@debian:~$ ps -ef | grep ssh-agent
    vagrant     1610       1  0 14:52 ?        00:00:00 ssh-agent
    vagrant     1612    1393  0 14:52 pts/0    00:00:00 grep ssh-agent
    ```

10. (optional) Protect your keypair with a `passphrase`, then add this key to the `ssh-agent` and test your passwordless ssh to the `server`.

    > We removed the RSA keypair and created a new ED25519 keypair with a passphrase.

    ```console
    vagrant@debian:~$ rm -rf .ssh/id_rsa*
    vagrant@debian:~$ ssh-keygen -t ed25519
    Generating public/private ed25519 key pair.
    Enter file in which to save the key (/home/vagrant/.ssh/id_ed25519): 
    Enter passphrase (empty for no passphrase): [ENTER PASSPHRASE HERE]
    Enter same passphrase again: [ENTER PASSPHRASE HERE]
    Your identification has been saved in /home/vagrant/.ssh/id_ed25519
    Your public key has been saved in /home/vagrant/.ssh/id_ed25519.pub
    The key fingerprint is:
    SHA256:yo7yb0/iQK6TOGazv7DjibRb0pS5XPkiJ5xdxptoVhw vagrant@debian
    The key's randomart image is:
    +--[ED25519 256]--+
    |                 |
    |                 |
    |       E         |
    |    o + .        |
    |   +.o *S        |
    |  =o=.*.o        |
    | = @oB++.        |
    |==@.*=oo         |
    |=OB*+o+..        |
    +----[SHA256]-----+
    ```

    > Next, we copy the public key to the server. Remark that we are *not* prompted for the passphrase here! This is only necessary when we want to access the *private key*.

    ```console
    vagrant@debian:~$ ssh-copy-id -i .ssh/id_ed25519.pub vagrant@192.168.56.11
    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: ".ssh/id_ed25519.pub"
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
    /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys

    Number of key(s) added: 1

    Now try logging into the machine, with:   "ssh 'vagrant@192.168.56.11'"
    and check to make sure that only the key(s) you wanted were added.
    ```

    > We remove all current keys from the agent and add the new key. At this point, we are prompted for the passphrase.

    ```console
    vagrant@debian:~$ ssh-add -D
    All identities removed.
    vagrant@debian:~$ ssh-add -L
    The agent has no identities.
    vagrant@debian:~$ ssh-add
    Enter passphrase for /home/vagrant/.ssh/id_ed25519: [ENTER PASSPHRASE HERE]
    Identity added: /home/vagrant/.ssh/id_ed25519 (vagrant@debian)
    ```

    > Now we can log in to the server without being prompted for the passphrase:

    ```console
    vagrant@debian:~$ ssh vagrant@192.168.56.11
    Last login: Mon Nov 11 14:47:53 2024 from 192.168.56.21
    [vagrant@el ~]$ 
    ```

11. (optional, only works when you have a graphical install of Linux) Use ssh with X forwarding to run a graphical on the `server`, but display it on your `client`.

    > See example in the theory section.

