## practice: ssh

Lab preparation: Make sure that you have access to *two Linux computers*, e.g. by setting up two [VirtualBox](https://www.virtualbox.org) VMs either manually or with an automation tool like [Vagrant](https://www.vagrantup.com). Ensure that both VMs are attached to the same type of network (preferably Host-only or Internal) and that they have an IP address within the same subnet. One VM will assume the role of the `client`, the other the `server`.

1. On the `server`, check which version of the OpenSSH `server` is installed, which *should* be the case (especially for VMs created with Vagrant). If not, install it.

2. Verify in the ssh configuration files that the `Protocol` setting is absent, or that only protocol version 2 is allowed.

3. Use `ssh` to log on to the `server`, show your current directory and then exit the `server`.

4. Use `scp` to copy a file from the `client` to the `server`.

5. Use `scp` to copy a file from the `server` to the `client`.

6. Use `ssh-keygen` to create a key pair without passphrase on the `client`. Set up passwordless ssh between the `client` and `server`

7. Verify that the permissions on the `client` key files are correct; world readable for the public keys and only root access for the private keys.

8. On the `server`, check which public keys are authorized for the user you are using to log in.

9. Verify that the `ssh-agent` is running.

10. (optional) Protect your keypair with a `passphrase`, then add this key to the `ssh-agent` and test your passwordless ssh to the `server`.

11. (optional, only works when you have a graphical install of Linux) Use ssh with X forwarding to run a graphical on the `server`, but display it on your `client`.

