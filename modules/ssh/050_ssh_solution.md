## solution: ssh

0\. Make sure that you have access to `two Linux computers`, or work
together with a partner for this exercise. For this practice, we will
name one of the machines the server.

1\. Install `sshd` on the server

    apt-get install openssh-server (on Ubuntu/Debian)
    yum -y install openssh-server (on Centos/Fedora/Red Hat)

2\. Verify in the ssh configuration files that only protocol version 2
is allowed.

    grep Protocol /etc/ssh/ssh*_config

3\. Use `ssh` to log on to the server, show your current directory and
then exit the server.

    user@client$ ssh user@server-ip-address
    user@server$ pwd
    /home/user
    user@server$ exit

4\. Use `scp` to copy a file from your computer to the server.

    scp localfile user@server:~

5\. Use `scp` to copy a file from the server to your computer.

    scp user@server:~/serverfile .

6\. (optional, only works when you have a graphical install of Linux)
Install the xeyes package on the server and use ssh to run xeyes on the
server, but display it on your client.

    on the server:
    apt-get install xeyes
    on the client:
    ssh -X user@server-ip
    xeyes

7\. (optional, same as previous) Create a bookmark in firefox, then quit
firefox on client and server. Use `ssh -X` to run firefox on your
display, but on your neighbour\'s computer. Do you see your neighbour\'s
bookmark ?

8\. Use `ssh-keygen` to create a key pair without passphrase. Setup
passwordless ssh between you and your neighbour. (or between your client
and your server)

    See solution in book "setting up passwordless ssh"

9\. Verify that the permissions on the server key files are correct;
world readable for the public keys and only root access for the private
keys.

    ls -l /etc/ssh/ssh_host_*

10\. Verify that the `ssh-agent` is running.

    ps fax | grep ssh-agent

11\. (optional) Protect your keypair with a `passphrase`, then add this
key to the `ssh-agent` and test your passwordless ssh to the server.

    man ssh-keygen
    man ssh-agent
    man ssh-add
