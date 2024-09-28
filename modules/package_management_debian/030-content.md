## about deb

Most people use `apt` or `apt-get` (APT = Advanced Package Tool) to manage their Debian/Ubuntu family of Linux distributions. Both are a front end for `dpkg` and are themselves a back end for *synaptic* and other graphical tools.

## dpkg

You could use `dpkg -i` to install a package and `dpkg -r` to remove a package, but you\'d have to manually download the packge and keep track of dependencies. Using `apt-get` or `apt` is much easier (see below).

### dpkg -l

The low level tool to work with `.deb` packages is `dpkg`. Among other things, you can use `dpkg` to list all installed packages on a Debian server.

```console
student@debian:~$ dpkg -l | wc -l
365
```

Compare this to the same list on a Linux Mint system with a graphical desktop installed.

```console
student@mint:~$ dpkg -l | wc -l
2118
```

### dpkg -l \$package

Here is an example on how to get information on an individual package.
The `ii` at the beginning means the package is installed.

```console
student@debian:~$ dpkg -l rsync
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version        Architecture Description
+++-==============-==============-============-=====================================================
ii  rsync          3.2.7-1ubuntu1 amd64        fast, versatile, remote (and local) file-copying tool
```

### dpkg -S

You can find the package responsible for installing a certain file on your computer using `dpkg -S`. This example shows how to find the package for three files on a typical Debian server.

```console
student@debian:~$ dpkg  -S /usr/share/doc/tmux/ /etc/ssh/ssh_config /sbin/ifconfig
dpkg-query: no path found matching pattern /usr/share/doc/tmux/
openssh-client: /etc/ssh/ssh_config
net-tools: /sbin/ifconfig
```

### dpkg -L

In reverse, you can also get a list of all files and directories that have been installed by a certain program. Below is the list for the `curl` package.

```console
student@debian:~$ dpkg -L curl
/.
/usr
/usr/bin
/usr/bin/curl
/usr/share
/usr/share/doc
/usr/share/doc/curl
/usr/share/doc/curl/changelog.Debian.gz
/usr/share/doc/curl/changelog.gz
/usr/share/doc/curl/copyright
/usr/share/man
/usr/share/man/man1
/usr/share/man/man1/curl.1.gz
/usr/share/zsh
/usr/share/zsh/vendor-completions
/usr/share/zsh/vendor-completions/_curl
```

## apt-get

`Debian` has been using `apt-get` to manage packages since 1998. Today Debian and many Debian-based distributions still actively support `apt-get`, though some experts claim `apt`, released in 2014, is better at handling dependencies than `apt-get`.

Both commands use the same configuration files and can be used interchangeably, at least on an interactive terminal. However, using `apt` in a script is not recommended, since the options and behaviour of `apt` are not considered to be stable.

We will start with `apt-get` and discuss `apt` in the next section. Whenever you see `apt-get` in documentation, feel free to type `apt` instead.

### apt-get update

When typing `apt-get update` you are downloading the names, versions and short description of all packages available on all configured repositories for your system. Remark that you need to be root to run this command.

```console
student@debian:~$ apt-get update
Reading package lists... Done
E: Could not open lock file /var/lib/apt/lists/lock - open (13: Permission denied)
E: Unable to lock directory /var/lib/apt/lists/
student@debian:~$ sudo apt-get update
Hit:1 http://security.debian.org/debian-security bookworm-security InRelease
Hit:2 http://httpredir.debian.org/debian bookworm InRelease
Hit:3 http://httpredir.debian.org/debian bookworm-updates InRelease
Reading package lists... Done
```

In the example below you can see an interaction with an Ubuntu system. Some repositories are at the url `be.archive.ubuntu.com` because this computer was installed in Belgium. This mirror URL can be different for you.

```console
student@ubuntu:~$ sudo apt-get update
Ign http://be.archive.ubuntu.com precise InRelease
Ign http://extras.ubuntu.com precise InRelease
Ign http://security.ubuntu.com precise-security InRelease            
Ign http://archive.canonical.com precise InRelease                                         
Ign http://be.archive.ubuntu.com precise-updates InRelease                                 
...
Hit http://be.archive.ubuntu.com precise-backports/main Translation-en                                                             
Hit http://be.archive.ubuntu.com precise-backports/multiverse Translation-en                                                       
Hit http://be.archive.ubuntu.com precise-backports/restricted Translation-en                                                       
Hit http://be.archive.ubuntu.com precise-backports/universe Translation-en                                                         
Fetched 13.7 MB in 8s (1682 kB/s)                                                                                                  
Reading package lists... Done
student@ubuntu:~$
```

**Tips:**

- Run `apt-get update` every time before performing other package operations to ensure your metadata is up-to-date.
- Since the package repositories are hosted on web servers, you can open any repository URL in your browser to see how the repository is structured.

### apt-get upgrade

One of the nicest features of `apt-get` is that it allows for a secure update of *all software currently installed* on your computer with just
*one* command.

```console
student@debian:~$ sudo apt-get upgrade
Reading package lists... Done
Building dependency tree       
Reading state information... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```

The above transcript shows that all software is updated to the latest version available for my distribution. Below is an example of a system with software that can be updated. Some lines were ommitted for brevity.

```console
student@debian:~$ sudo apt-get upgrade
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
The following packages have been kept back:
  linux-image-amd64
The following packages will be upgraded:
  base-files bind9-dnsutils bind9-host bind9-libs cryptsetup cryptsetup-bin libcryptsetup12 libgnutls30 libnss-systemd libpam-systemd libsystemd-shared libsystemd0 libudev1 systemd systemd-sysv
  systemd-timesyncd tar tzdata udev usr-is-merged
20 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Need to get 13.0 MB of archives.
After this operation, 75.8 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://security.debian.org/debian-security bookworm-security/main amd64 bind9-host amd64 1:9.18.24-1 [305 kB]
[...]
Get:20 http://httpredir.debian.org/debian bookworm/main amd64 cryptsetup amd64 2:2.6.1-4~deb12u2 [213 kB]
Fetched 13.0 MB in 1s (20.3 MB/s)
Reading changelogs... Done
Preconfiguring packages ...
(Reading database ... 29205 files and directories currently installed.)
Preparing to unpack .../base-files_12.4+deb12u5_amd64.deb ...
Unpacking base-files (12.4+deb12u5) over (12.4+deb12u4) ...
Setting up base-files (12.4+deb12u5) ...
Installing new version of config file /etc/debian_version ...
[...]
Preparing to unpack .../5-cryptsetup_2%3a2.6.1-4~deb12u2_amd64.deb ...
Unpacking cryptsetup (2:2.6.1-4~deb12u2) over (2:2.6.1-4~deb12u1) ...
Setting up systemd-sysv (252.22-1~deb12u1) ...
[...]
Setting up bind9-dnsutils (1:9.18.24-1) ...
Processing triggers for initramfs-tools (0.142) ...
update-initramfs: Generating /boot/initrd.img-6.1.0-17-amd64
[...]
Processing triggers for mailcap (3.70+nmu1) ...
```

**Tip:** Have you noticed that almost every time that you update software on Windows, you are asked to reboot your computer? This is **not** the case with Linux! The only time you need to reboot is when you update the kernel.

### apt-get clean

`apt-get` keeps a copy of downloaded packages in `/var/cache/apt/archives`, as can be seen in this screenshot.

```console
student@debian:~$ ls /var/cache/apt/archives/ | head
base-files_12.4+deb12u5_amd64.deb
bind9-dnsutils_1%3a9.18.24-1_amd64.deb
bind9-host_1%3a9.18.24-1_amd64.deb
bind9-libs_1%3a9.18.24-1_amd64.deb
cryptsetup_2%3a2.6.1-4~deb12u2_amd64.deb
cryptsetup-bin_2%3a2.6.1-4~deb12u2_amd64.deb
libcryptsetup12_2%3a2.6.1-4~deb12u2_amd64.deb
libgnutls30_3.7.9-2+deb12u2_amd64.deb
libnss-systemd_252.22-1~deb12u1_amd64.deb
libpam-systemd_252.22-1~deb12u1_amd64.deb
```

Running `apt-get clean` removes all .deb files from that directory.

```console
student@debian:~$ sudo apt-get clean
student@debian:~$ ls /var/cache/apt/archives/*.deb
ls: cannot access /var/cache/apt/archives/*.deb: No such file or directory
```

### apt-cache search

Use `apt-cache search` to search for availability of a package. Here we look for `rsync`.

```console
student@debian:~$ apt-cache search rsync | grep '^rsync'
rsync - fast, versatile, remote (and local) file-copying tool
rsyncrypto - rsync friendly encryption
```

### apt-get install

You can install one or more applications by appending their name behind `apt-get install`. The following example shows how to install the `tftp-hpa` package (a TFTP server).

```console
student@debian:~$ sudo apt-get install tftpd-hpa
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Suggested packages:
  pxelinux
The following NEW packages will be installed:
  tftpd-hpa
0 upgraded, 1 newly installed, 0 to remove and 1 not upgraded.
Need to get 41.9 kB of archives.
After this operation, 117 kB of additional disk space will be used.
Get:1 http://httpredir.debian.org/debian bookworm/main amd64 tftpd-hpa amd64 5.2+20150808-1.4 [41.9 kB]
Fetched 41.9 kB in 0s (241 kB/s)
Preconfiguring packages ...
Selecting previously unselected package tftpd-hpa.
(Reading database ... 29179 files and directories currently installed.)
Preparing to unpack .../tftpd-hpa_5.2+20150808-1.4_amd64.deb ...
Unpacking tftpd-hpa (5.2+20150808-1.4) ...
Setting up tftpd-hpa (5.2+20150808-1.4) ...
Processing triggers for man-db (2.11.2-2) ...
```

The `apt-get` command will ask the user to confirm the installation of the package by pressing "y" and ENTER. You can use the `-y` option to automatically answer yes to all questions.

The following example installs the `vim` package (VI iMproved, a powerful text editor for the terminal). **Remark** that some additional packages are installed as dependencies!

```console
student@debian:~$ sudo apt-get install -y vim
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libgpm2 libsodium23 vim-runtime
Suggested packages:
  gpm ctags vim-doc vim-scripts
The following NEW packages will be installed:
  libgpm2 libsodium23 vim vim-runtime
0 upgraded, 4 newly installed, 0 to remove and 1 not upgraded.
Need to get 8,768 kB of archives.
After this operation, 41.5 MB of additional disk space will be used.
[...]
Setting up libsodium23:amd64 (1.0.18-1) ...
Setting up libgpm2:amd64 (1.20.7-10+b1) ...
Setting up vim-runtime (2:9.0.1378-2) ...
Setting up vim (2:9.0.1378-2) ...
[...]
Processing triggers for man-db (2.11.2-2) ...
Processing triggers for libc-bin (2.36-9+deb12u4) ...
```

### apt-get remove

You can remove one or more applications by appending their name behind `apt-get remove`.

```console
student@debian:~$ sudo apt-get remove tftpd-hpa 
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be REMOVED:
  tftpd-hpa
0 upgraded, 0 newly installed, 1 to remove and 1 not upgraded.
After this operation, 117 kB disk space will be freed.
Do you want to continue? [Y/n] y 
(Reading database ... 29194 files and directories currently installed.)
Removing tftpd-hpa (5.2+20150808-1.4) ...
Processing triggers for man-db (2.11.2-2) ...
```

If we use `dpkg -l` to check the status of the `tftpd-hpa` package, we see that it is removed, some configuration (rc) files are left on the system. Indeed, the configuration file `/etc/init/tftpd-hpa.conf` is not removed! We'll solve this in the next section.

```console
student@debian:~$ dpkg -l tftpd-hpa | tail -1
rc  tftpd-hpa      5.2+20150808-1.4 amd64        HPA's tftp server
student@debian:~$ ls -l /etc/init/tftpd-hpa.conf 
-rw-r--r-- 1 root root 980 Oct 25  2022 /etc/init/tftpd-hpa.conf
```

The example below shows how to remove the `vim` package. Note that dependencies are **not** removed! You can execute `sudo apt autoremove` afterwards (as is suggested by the output of the command!) to remove those as well.

```console
student@debian:~$ sudo apt-get remove vim
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libsodium23 vim-runtime
Use 'sudo apt autoremove' to remove them.
The following packages will be REMOVED:
  vim
0 upgraded, 0 newly installed, 1 to remove and 1 not upgraded.
After this operation, 3,738 kB disk space will be freed.
Do you want to continue? [Y/n] y
(Reading database ... 31257 files and directories currently installed.)
Removing vim (2:9.0.1378-2) ...
[...]
student@debian:~$ sudo apt-get autoremove
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be REMOVED:
  libsodium23 vim-runtime
0 upgraded, 0 newly installed, 2 to remove and 1 not upgraded.
After this operation, 37.7 MB disk space will be freed.
Do you want to continue? [Y/n] y
(Reading database ... 31247 files and directories currently installed.)
Removing libsodium23:amd64 (1.0.18-1) ...
Removing vim-runtime (2:9.0.1378-2) ...
Removing 'diversion of /usr/share/vim/vim90/doc/help.txt to /usr/share/vim/vim90/doc/help.txt.vim-tiny by vim-runtime'
Removing 'diversion of /usr/share/vim/vim90/doc/tags to /usr/share/vim/vim90/doc/tags.vim-tiny by vim-runtime'
Processing triggers for man-db (2.11.2-2) ...
Processing triggers for libc-bin (2.36-9+deb12u4) ...
```

### apt-get purge

You can purge one or more applications by appending their name behind
`apt-get purge`. Purging will also remove all existing configuration
files related to that application. The screenshot shows how to purge the
`tftpd-hpa` package.

```console
student@debian:~$ ls -l /etc/init/tftpd-hpa.conf 
-rw-r--r-- 1 root root 980 Oct 25  2022 /etc/init/tftpd-hpa.conf
student@debian:~$ sudo apt-get purge tftpd-hpa
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be REMOVED:
  tftpd-hpa*
0 upgraded, 0 newly installed, 1 to remove and 1 not upgraded.
After this operation, 0 B of additional disk space will be used.
Do you want to continue? [Y/n] y
(Reading database ... 29182 files and directories currently installed.)
Purging configuration files for tftpd-hpa (5.2+20150808-1.4) ...
student@debian:~$ ls -l /etc/init/tftpd-hpa.conf 
ls: cannot access '/etc/init/tftpd-hpa.conf': No such file or directory
```

Note that `dpkg` has no information about a purged package!

```console
student@debian:~$ dpkg -l tftpd-hpa | tail -1 | tr -s ' ' 
dpkg-query: no packages found matching tftpd-hpa
```

## apt

Nowadays, most people use `apt` for package management on Debian, Mint and Ubuntu systems. That does not mean that `apt-get` is no longer useful. In scripts, it is actually recommended to use `apt-get` because its options and behaviour are more stable and predictable than `apt`. For interactive use, `apt` is more user-friendly.

To synchronize with the repositories.

```console
sudo apt update
```

To patch and upgrade all software to the latest version on Debian.

```console
sudo apt upgrade
```

To patch and upgrade all software to the latest version on Ubuntu and
Mint.

```console
sudo apt safe-upgrade
```

To install an application with all dependencies.

```console
sudo apt install $package
```

To search the repositories for applications that contain a certain
string in their name or description.

```console
apt search $string
```

To remove an application.

```console
sudo apt remove $package
```

To remove an application and all configuration files.

```console
sudo apt purge $package
```

## /etc/apt/sources.list

Both `apt-get` and `apt` use the same configuration information in `/etc/apt/`. The main configuration file is `/etc/apt/sources.list` and the directory `/etc/apt/sources.list.d/` contains additional files. These contain a list of http or ftp sources where packages for the distribution can be downloaded. Third party software vendors may provide their own package repositories for Debian or Ubuntu. These repositories are typically added through a new file in `/etc/apt/sources.list.d/`.

This is what that list looks like on a Debian server system shortly after installation.

```console
student@debian:~$ cat /etc/apt/sources.list
deb http://httpredir.debian.org/debian/ bookworm main non-free-firmware
deb-src http://httpredir.debian.org/debian/ bookworm main non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware

# bookworm-updates, to get updates before a point release is made;
deb http://httpredir.debian.org/debian/ bookworm-updates main non-free-firmware
deb-src http://httpredir.debian.org/debian/ bookworm-updates main non-free-firmware
```

If you use Linux as a daily driver, you may end up with a repository list with many more entries, like on this Ubuntu system:

```console
student@ubuntu:~$ wc -l /etc/apt/sources.list
63 /etc/apt/sources.list
```

There is much more to learn about `apt`, explore commands like `add-apt-repository`, `apt-key` and `apropos apt`.

