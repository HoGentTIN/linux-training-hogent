## install Vagrant and scaffolding code

Vagrant can be installed on Windows, macOS, and Linux. The installation instructions are available on the [Vagrant website](https://developer.hashicorp.com/vagrant/install). For example, on Windows, you can install Vagrant by opening an elevated PowerShell prompt and running the following command:

```console
> winget install Hashicorp.Vagrant
```

Users of macOS can install Vagrant using [Homebrew](https://brew.sh) and Linux users can install Vagrant using their package manager. Do remark that some Linux distributions may have a version of Vagrant that does not work with VirtualBox out-of-the-box, but with the native libvirt hyperviser. In that case, it's best to follow the instructions on the Vagrant website and ensure you install a package provided by Hashicorp.

Remark that Vagrant is a command line application, so you will need to open a terminal to use it. Regardless of your operating system, the default terminal will do, e.g. Powershell for Windows, Bash or zsh for macOS or Bash for Linux. In fact, after you ascertain that Vagrant is installed correctly, you don't even need to start the VirtualBox GUI anymore!

Check that the installation was successful by running `vagrant --version` in your terminal.

```console
> vagrant --version
Vagrant 2.4.1
```

The following step is to create some scaffolding code for a Vagrant project. You could create a new directory go to that directory and issue the command `vagrant init`. A `Vagrantfile` will be created that you can then edit to define the VMs. However, one of the authors of this course has prepared some starter code that you can download from the Github repository [bertvv/vagrant-shell-skeleton](https://github.com/bertvv/vagrant-shell-skeleton). You can download the code as a zip file and extract it to a directory of your choice. The directory will contain a `Vagrantfile`, a file called `vagrant-hosts.yml` that contains the list of VMs to be created, and a directory called `provisioning` that contains the provisioning scripts.

## Creating and booting a VM

In the console transcripts below, do remark that the commands are executed on your physical system, not inside a VM. We'll indicate these commands by prefixing them with the character `>`. Commands issued inside the VM will be prefixed with the prompt that you will see there, e.g. `vagrant@srv001:~$`.

We assume that you extracted the zip with the starter code to a directory called `vagrant-demo`. Change to that directory and issue the command `vagrant status`.

```console
> cd vagrant-demo
> vagrant status
Current machine states:

srv001                    not created (virtualbox)

The environment has not yet been created. Run `vagrant up` to
create the environment. If a machine is not created, only the
default provider will be shown. So if a provider is not listed,
then the machine is not created for that environment.
```

So, apparently, this environment consists of a single VM called `srv001` that has not been created yet. Let's create it by running `vagrant up`. You may want to start the VirtualBox GUI to see the effect of the Vagrant commands, but as mentioned before, this is not necessary.

There's a lot going on if you do this for the first time, so take a look at the output. This is what you may expect:

```console
> vagrant up
Bringing machine 'srv001' up with 'virtualbox' provider...
==> srv001: Box 'bento/almalinux-9' could not be found. Attempting to find and install...
    srv001: Box Provider: virtualbox
    srv001: Box Version: >= 0
==> srv001: Loading metadata for box 'bento/almalinux-9'
    srv001: URL: https://vagrantcloud.com/api/v2/vagrant/bento/almalinux-9
==> srv001: Adding box 'bento/almalinux-9' (v202401.31.0) for provider: virtualbox (amd64)
    srv001: Downloading: https://vagrantcloud.com/bento/boxes/almalinux-9/versions/202401.31.0/providers/virtualbox/amd64/vagrant.box
    srv001:
==> srv001: Successfully added box 'bento/almalinux-9' (v202401.31.0) for 'virtualbox (amd64)'!
==> srv001: Importing base box 'bento/almalinux-9'...
==> srv001: Matching MAC address for NAT networking...
==> srv001: Checking if box 'bento/almalinux-9' version '202401.31.0' is up to date...
==> srv001: Setting the name of the VM: vagrant-demo_srv001_1708772855256_55931
==> srv001: Clearing any previously set network interfaces...
==> srv001: Preparing network interfaces based on configuration...
    srv001: Adapter 1: nat
    srv001: Adapter 2: hostonly
==> srv001: Forwarding ports...
    srv001: 22 (guest) => 2222 (host) (adapter 1)
==> srv001: Running 'pre-boot' VM customizations...
==> srv001: Booting VM...
==> srv001: Waiting for machine to boot. This may take a few minutes...
    srv001: SSH address: 127.0.0.1:2222
    srv001: SSH username: vagrant
    srv001: SSH auth method: private key
    srv001: 
    srv001: Vagrant insecure key detected. Vagrant will automatically replace
    srv001: this with a newly generated keypair for better security.
    srv001: 
    srv001: Inserting generated public key within guest...
==> srv001: Machine booted and ready!
==> srv001: Checking for guest additions in VM...
==> srv001: Setting hostname...
==> srv001: Configuring and enabling network interfaces...
==> srv001: Mounting shared folders...
    srv001: /vagrant => C:/Users/student/Downloads/vagrant-demo
==> srv001: Running provisioner: shell...
    srv001: Running: C:/Users/student/AppData/Local/Temp/vagrant-shell20240224-2812-261dwi.sh
    srv001: [LOG]  Starting common provisioning tasks
    srv001: [LOG]  Starting server specific provisioning tasks on srv001
```

Let's go through this step by step:

- First, Vagrant checks if the base box `bento/almalinux-9` is available locally. If not, it will download it from the Vagrant Cloud. This is a public repository of Vagrant boxes that you can use to create VMs. The box is a pre-configured VM image that Vagrant uses as a starting point to create a VM. The box is downloaded only once and stored on your system. If you want to create another VM based on the same box, Vagrant will use the local copy.
- The line with `Importing base box 'bento/almalinux-9'` indicates that the box is being imported into VirtualBox. That means that a VirtualBox VM is created, the disk image of the base box is copied to the directory of that VM, the VM is configured according to the settings in the `Vagrantfile` (memory, CPU, network interfaces, etc.).
- The line with `Booting VM...` indicates that the VM is started. Vagrant uses SSH to communicate with the VM, so it needs to wait until the SSH server inside the VM is ready to accept connections. This may take a while. Vagrant base boxes should always have a default user `vagrant` with password `vagrant` and a private key that Vagrant uses to authenticate to the VM. Vagrant will replace this insecure key with a newly generated keypair for better security.
- Vagrant then applies some basic settings, like the hostname and network interfaces.
- Next, on the line with `Mounting shared folders...`, Vagrant will make the directory where the `Vagrantfile` is located available inside the VM. This is very useful to share files between the host and the VM. The directory is mounted at `/vagrant` inside the VM.
- Finally, Vagrant will run the provisioning script. In this setup, the provisioning script should be located inside the directory `provisioning` and should have the same name as the VM (in this case `srv001.sh`). The script is executed inside the VM with root privileges and should install and configure the software that is needed for the VM to fulfill its role. In this case, the script will only print some log messages.

## Basic Vagrant commands

After the VM has been created, you can check its status with the command `vagrant status`. You can also see the VM in the VirtualBox GUI. The VM is running and you can connect to it with SSH. Vagrant provides a command to do this: `vagrant ssh`. This command will open an SSH connection to the VM and log in as the user `vagrant`.

```console
> vagrant status
Current machine states:

srv001                    running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.
> vagrant ssh srv001

This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
[vagrant@srv001 ~]$ pwd
/home/vagrant
[vagrant@srv001 ~]$ ls /vagrant
LICENSE.md  provisioning  README.md  Vagrantfile  vagrant-hosts.yml
[vagrant@srv001 ~]$ 
```

The user Vagrant has sudo privileges, so you can execute commands as root.

The table below lists the most important Vagrant commands. You can run these commands from the directory where the `Vagrantfile` is located.

| Command                 | Description                                              |
| :---------------------- | :------------------------------------------------------- |
| `vagrant up`            | Create and start the VMs defined in the `Vagrantfile`    |
| `vagrant halt`          | Stop the VMs                                             |
| `vagrant suspend`       | Suspend the VMs (save the state to disk and stop the VM) |
| `vagrant resume`        | Resume the VMs (start the VMs from the saved state)      |
| `vagrant reload`        | Reload the VMs (restart the VMs)                         |
| `vagrant destroy`       | Destroy the VMs (delete the VMs and their disk images)   |
| `vagrant status`        | Show the status of the VMs in the current environment    |
| `vagrant global-status` | Show the status of all Vagrant VMs on your system        |
| `vagrant ssh`           | Open an SSH connection to the VM                         |
| `vagrant provision`     | Run the provisioning script                              |

Add the name of a VM to apply the command to that specific VM, e.g. `vagrant halt srv001`.

## Updating the provisioning script

The provisioning script `provisioning/srv001.sh` is a Bash script that is executed as the final step of `vagrant up`, when creating the VM. If you reload the VM or boot it back up at a later time, the provisioning script will not be executed again. If you want to re-run the provisioning script, you can use the command `vagrant provision`. This is useful if you have made changes to the provisioning script and want to apply them to the VM.

At this time, the script does nothing useful. Let's change that. Open the file `provisioning/srv001.sh` in a text editor, either on your physical system, or inside the VM (under directory /vagrant). Add the following lines to the end of the file:

```bash
dnf -y install httpd
systemctl enable --now httpd
```

Run the provisioning script again with the command `vagrant provision srv001`. This will install the Apache web server and start it. You can check if the web server is running by executing the command `curl localhost` inside the VM. You should see the HTML code for the default web page of the Apache web server.

You can make changes to the provisioning script and run it again with `vagrant provision`. There's two important things to keep in mind when you write a provisioning script:

- The script should be able to run **non-interactively**. This means that it should *never* ask for user input. If it does, the script will fail immediately and Vagrant will issue an error message. Remark that the `dnf` command in the example above uses the `-y` option to answer "yes" to all questions so that it can run non-interactively.

- The script should be **idempotent**. This means that it should be safe to run the script multiple times, e.g. when you update the script and run it again. If a desired operation was already performed, the script should not try it again. Some Linux commands are inherently idempotent, like `dnf install`, but others are not. For example, if your script wants to add a user with the `useradd` command, running it the second time wil fail. In this case, you should first test if the user exists, and only run the `useradd` command if they don't.

## Changing VM settings, adding VMs

In this setup, the VM settings can be changed in the file `vagrant-hosts.yml`. This file is a YAML file that contains a list of VMs and their settings. The file looks like this:

```yaml
---
- name: srv001
  box: bento/almalinux-9
  ip: 192.168.56.31
```

Every VM should at least have a `name` defined, other settings are optional.

The `box` setting determines the base box that will be used to create the VM. You can discover available boxes on the [Vagrant Cloud](https://app.vagrantup.com/boxes/search). We used an [AlmaLinux 9 box](https://app.vagrantup.com/bento/boxes/almalinux-9) created by the [Bento project](https://github.com/chef/bento).

The advantage of setting an `ip` address is that your VM can be reached over the network from your physical system with a predictable IP address. Note that the network range 192.169.56.0/24 is used by VirtualBox for a host-only network. The first host-only network that you create in VirtualBox will have this exact range. Your physical system wil get the IP address 192.168.56.1 and your VM the one indicated above. Check this by pinging the VM from your physical system and vice versa!

```console
> ping 192.168.56.31

Pinging 192.168.56.31 with 32 bytes of data:
Reply from 192.168.56.31: bytes=32 time=3ms TTL=64
Reply from 192.168.56.31: bytes=32 time<1ms TTL=64
Reply from 192.168.56.31: bytes=32 time<1ms TTL=64
Reply from 192.168.56.31: bytes=32 time<1ms TTL=64

Ping statistics for 192.168.56.31:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 3ms, Average = 0ms
> vagrant ssh srv001
[vagrant@srv001 ~]$ ping -c3 192.168.56.1
PING 192.168.56.1 (192.168.56.1) 56(84) bytes of data.
64 bytes from 192.168.56.1: icmp_seq=1 ttl=128 time=0.903 ms
64 bytes from 192.168.56.1: icmp_seq=2 ttl=128 time=2.05 ms
64 bytes from 192.168.56.1: icmp_seq=3 ttl=128 time=0.725 ms

--- 192.168.56.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2011ms
rtt min/avg/max/mdev = 0.725/1.226/2.050/0.587 ms
```

Now you know this, you can check if the web server can be reached from your physical system by opening a web browser and navigating to <http://192.168.56.31>. You should see the default web page of the Apache web server.

If you want to add another VM, you can add another entry to the `vagrant-hosts.yml` file. For example:

```yaml
---
- name: srv001
  box: bento/almalinux-9
  ip: 192.168.56.31

- name: srv002
  box: bento/almalinux-9
  ip: 192.168.56.32
  memory: 2048
  cpus: 2
```

This second VM uses the same base box, but we assigned an extra processor core and more memory.

Save the changes to the file and run `vagrant status`:

```console
> vagrant status
Current machine states:

srv001                    running (virtualbox)
srv002                    not created (virtualbox)
```

Start the new VM with `vagrant up srv002`. You can then SSH into the VM with `vagrant ssh srv002`. You can also run the provisioning script with `vagrant provision srv002`. Remark that at this time there is no provisioning script for `srv002` yet! Copy the `srv001.sh` script to `provisioning/srv002.sh` and modify it to your liking.

When you have multiplte VMs, you will probably repeat some steps for all of them. For this purpose, the starter code already provides two extra scripts:

- `provisioning/common.sh` contains tasks that are common to all VMs, like installing a package that is needed on all VMs (e.g. `bash-completion`, `vim-enhanced`, ...), ensuring the firewall is running, etc.

- `provisioning/utils.sh` contains reusible functions that can be called from your provisioning script. As an example, it has functions for printing log messages (`log`, `debug` and `error`), an idempotent function to add a user (`ensure_user_exists`), or a group (`ensure_group_exists`), etc.

A comprehensive list of all settings that you can define for a VM in `vagrant-hosts.yml`:

- Box settings
    - `box`: A box name in the form `USER/BOX` (e.g. `bento/almalinux-9`) is fetched from Vagrant Cloud.
    - `box_url`: Download the box from the specified URL instead of from Vagrant Cloud.
- VM properties
    - `memory`: The amount of memory to allocate to the VM.
    - `cpus`: The number of CPUs to allocate to the VM.
- Network settings
    - `ip`: by default, an IP will be assigned by DHCP. If you want a fixed addres, specify it.
    - `netmask`: by default, the network mask is `255.255.255.0`. If you want another one, it should be specified.
    - `mac`: The MAC address to be assigned to the NIC. Several notations are accepted, including "Linux-style" (`00:11:22:33:44:55`) and "Windows-style" `00-11-22-33-44-55`). The separator characters can be omitted altogether (`001122334455`).
    - `intnet`: If set to `true`, the network interface will be attached to an internal network rather than a host-only adapter.
    - `auto_config`: If set to `false`, Vagrant will not attempt to configure the network interface.
    - `forwarded_ports`: a list of dicts that specify port forwarding. Each dict should have a `host` and a `guest` key. The `host` key specifies the port on the host system, and the `guest` key specifies the port on the guest system.
- Login settings:
    - `ssh_username` and `ssh_password`: Credentials for logging in to the VM (if
   the VM does not use the default SSH key or username/password combination).
- `synced_folders`: A list of dicts that specify synced folders. `src` and `dest` are mandatory, `options:` are optional. For the possible options, see the [Vagrant documentation](https://developer.hashicorp.com/vagrant/docs/synced-folders/basic_usage). Keys of options should be prefixed with a colon, e.g. `:owner:`.

An elaborate example of a host definition:

```yaml
---
- name: srv002
  box: bento/fedora-latest
  memory: 2048
  cpus: 2
  ip: 172.20.0.10
  netmask: 255.255.0.0
  mac: '13:37:de:ad:be:ef'
  forwarded_ports:
    - host: 8080
      guest: 80
    - host: 8443
      guest: 443
  synced_folders:
    - src: test
      dest: /tmp/test
    - src: www
      dest: /var/www/html
      options:
        :create: true
        :owner: root
        :group: root
        :mount_options: ['dmode=0755', 'fmode=0644']
```

## Managing base boxes

Vagrant base boxes are stored on your system. You can an overview of locally available base boxes with `vagrant box list`, for example:

```console
> vagrant box list
bento/almalinux-9   (virtualbox, 202401.31.0, (amd64))
bento/fedora-latest (virtualbox, 202309.08.0)
bento/ubuntu-22.04  (virtualbox, 202309.08.0)
vyos/current        (virtualbox, 20231011.00.22)
```

Installing a new base box (without creating a VM) is done with the command `vagrant box add`. For example, to add the base box `bento/debian-12.4`:

```console
> vagrant box add bento/debian-12.4                                                                                                                               14:48:09
==> box: Loading metadata for box 'bento/debian-12.4'
    box: URL: https://vagrantcloud.com/api/v2/vagrant/bento/debian-12.4
This box can work with multiple providers! The providers that it
can work with are listed below. Please review the list and choose
the provider you will be working with.

1) parallels
2) virtualbox
3) vmware_desktop

Enter your choice: 2
==> box: Adding box 'bento/debian-12.4' (v202401.31.0) for provider: virtualbox (amd64)
    box: Downloading: https://vagrantcloud.com/bento/boxes/debian-12.4/versions/202401.31.0/providers/virtualbox/amd64/vagrant.box
    box:
==> box: Successfully added box 'bento/debian-12.4' (v202401.31.0) for 'virtualbox (amd64)'!
```

You can prevent Vagrant from asking for the provider by specifying it on the command line:

```console
> vagrant box add --provider=virtualbox bento/debian-12.4
```

Now, if you want to create a VM based on Debian 12.4, you won't have to download the box at that point.

You can remove a base box with `vagrant box remove`. For example, to remove the base box `bento/almalinux-9`:

```console
> vagrant box remove bento/almalinux-9
Removing box 'bento/almalinux-9' (v202401.31.0) with provider 'virtualbox'...
```

Remark that we still have a few VMs based on this box. If we need to recreate these VMs later on, Vagrant will have to download the box again.

Every time you run `vagrant up`, Vagrant will check if the base box is still up-to-date. If a new version of the box is available, Vagrant issue a warning. In that case, you can update all base boxes used in the current environment with `vagrant box update`.

Updating a specific base box (not tied to the current environment) can be done by specifying the box name, e.g:

```console
> vagrant box update --box bento/fedora-latest
Checking for updates to 'bento/fedora-latest'
Latest installed version: 202309.08.0
Version constraints: > 202309.08.0
Provider: virtualbox
Updating 'bento/fedora-latest' with provider 'virtualbox' from version
'202309.08.0' to '202401.31.0'...
Loading metadata for box 'https://vagrantcloud.com/api/v2/vagrant/bento/fedora-latest'
Adding box 'bento/fedora-latest' (v202401.31.0) for provider: virtualbox (amd64)
Downloading: https://vagrantcloud.com/bento/boxes/fedora-latest/versions/202401.31.0/providers/virtualbox/amd64/vagrant.box

Successfully added box 'bento/fedora-latest' (v202401.31.0) for 'virtualbox (amd64)'!
```

Now, Vagrant does keep the old version of the box

```console
> vagrant box list
...
bento/fedora-latest (virtualbox, 202309.08.0)
bento/fedora-latest (virtualbox, 202401.31.0, (amd64))
...
```

You can remove the old version with by explicity specifying it:

```console
> vagrant box remove --box-version=202309.08.0 bento/fedora-latest
Removing box 'bento/fedora-latest' (v202309.08.0) with provider 'virtualbox'...
```

