# the Red Hat package manager (rpm)

On Red Hat and other distro's of that family, the *Red Hat package manager* (RPM) is used to install, upgrade and remove software. There's a basic command,  `rpm`, and a more advanced tool, `dnf` (comparable with the situation on Debian-based systems, where `dpkg` is the basic tool and `apt` the more advanced one). When you install a graphical desktop, there's also a GUI tool for package management, but we won't be discussing that here.

Software distributed in the `rpm` format will have a file name be named `package-version-release.architecture.rpm`. For example, the package name `openssh-server-8.7p1-34.el9.x86_64.rpm` has the following components:

- package name: `openssh-server`
- version: `8.7p1`
- release: `34.el9` (el9 stands for Enterprise Linux 9, indicating it is compatible with RHEL 9)
- architecture: `x86_64` (suitable for a 64-bit Intel/AMD processor)

We will start with discussing the `dnf` command, since that's the one that is most commonly used nowadays. After that, we'll show how to use the `rpm` command.

## dnf

The name of the `dnf` command has a bit of a convoluted history. It stands for "Dandified Yum", and is a fork/improvement of the `yum` package manager command. Yum stands for *Yellowdog Updater, Modified*, and was originally developed for the now defunct Yellow Dog Linux distribution (for the IBM POWER7 processor). Red Hat started using it in RHEL 5, and it was the default package manager for Red Hat and its derivatives for many years. However, more recently, they developed `dnf` to replace `yum` and that is now the default package manager for Fedora,  Red Hat Enterprise Linux and its derivatives.

The `dnf` command works quite similarly to the `apt` command on Debian-based systems. It has similar subcommands, which we will discuss in the next sections. However, an equivalent for `apt update` does *not* exist. The `dnf` command will automatically update its package database whenever you execute it.

## dnf list

Issue `dnf list` to see a list of all packages that DNF knows about.

```console
[student@el ~]$ dnf list | wc -l
6751
[student@el ~]$ dnf list --all | wc -l
6751
```

Add the option `--available` or `--installed` to see only the packages that are available for installation or installed on the system.

```console
[student@el ~]$ dnf list --available | wc -l
6392
[student@el ~]$ dnf list --installed | wc -l
353
```

Issue `dnf list $package` to get all versions (in different repositories) of one package.

```console
[student@el ~]$ dnf list kernel
Last metadata expiration check: 0:12:15 ago on Sun 25 Feb 2024 07:16:59 PM UTC.
Installed Packages
kernel.x86_64              5.14.0-362.8.1.el9_3        @anaconda
kernel.x86_64              5.14.0-362.13.1.el9_3       @baseos  
Available Packages
kernel.x86_64              5.14.0-362.18.1.el9_3       baseos   
```

## dnf search

To search for a package containing a certain string in the description or name use `dnf search $string`.

```console
[student@el ~]$ dnf search openssh
Last metadata expiration check: 0:15:35 ago on Sun 25 Feb 2024 07:16:59 PM UTC.
========================= Name Exactly Matched: openssh ========================
openssh.x86_64 : An open source implementation of SSH protocol version 2
======================== Name & Summary Matched: openssh =======================
openssh-askpass.x86_64 : A passphrase dialog for OpenSSH and X
openssh-keycat.x86_64 : A mls keycat backend for openssh
============================= Name Matched: openssh ============================
openssh-clients.x86_64 : An open source SSH client applications
openssh-server.x86_64 : An open source SSH server daemon
[student@el ~]$ dnf search epel
Last metadata expiration check: 0:18:51 ago on Sun 25 Feb 2024 07:16:59 PM UTC.
============================== Name Matched: epel ==============================
epel-release.noarch : Extra Packages for Enterprise Linux repository configuration
```

## dnf info

Information about a specific package can be obtained with `dnf info $package`.

```console
[student@el ~]$ dnf info epel-release
Last metadata expiration check: 1:15:53 ago on Sun 25 Feb 2024 07:55:24 PM UTC.
Installed Packages
Name         : epel-release
Version      : 9
Release      : 7.el9
Architecture : noarch
Size         : 26 k
Source       : epel-release-9-7.el9.src.rpm
Repository   : @System
From repo    : epel
Summary      : Extra Packages for Enterprise Linux repository configuration     
URL          : http://download.fedoraproject.org/pub/epel
License      : GPLv2
Description  : This package contains the Extra Packages for Enterprise Linux    
             : (EPEL) repository GPG key as well as configuration for yum.      
```

This gives you a lot of information about the package, including the version, release, architecture, size, source, repository, summary, link to the project website, license and description.

If the repository is indicated as `@System`, it means that the package is installed. Otherwise, it would show the name of the repository from which the package would be installed.

```console
[student@el ~]$ dnf info zork
Last metadata expiration check: 1:19:14 ago on Sun 25 Feb 2024 07:55:24 PM UTC.
Available Packages
Name         : zork
Version      : 1.0.3
Release      : 5.el9
Architecture : x86_64
Size         : 179 k
Source       : zork-1.0.3-5.el9.src.rpm
Repository   : epel
Summary      : Public Domain original DUNGEON game (Zork I)
URL          : https://github.com/devshane/zork
License      : Public Domain
Description  : Public Domain source code to the original DUNGEON game (Zork I). 
[...]
```

## dnf install

To install an application, use `dnf install $package`. Naturally `dnf` will install all the necessary dependencies.

```console
[student@el ~]$ sudo dnf install epel-release
Last metadata expiration check: 2:07:04 ago on Sun 25 Feb 2024 05:32:50 PM UTC.
Dependencies resolved.
================================================================================
 Package               Architecture    Version           Repository        Size 
================================================================================
Installing:
 epel-release          noarch          9-5.el9           extras            18 k 

Transaction Summary
================================================================================
Install  1 Package

Total download size: 18 k
Installed size: 25 k
Is this ok [y/N]: y
Downloading Packages:
epel-release-9-5.el9.noarch.rpm                       62 kB/s |  18 kB     00:00
--------------------------------------------------------------------------------
Total                                                 23 kB/s |  18 kB     00:00
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                         1/1
  Installing       : epel-release-9-5.el9.noarch                             1/1
  Running scriptlet: epel-release-9-5.el9.noarch                             1/1
Many EPEL packages require the CodeReady Builder (CRB) repository.
It is recommended that you run /usr/bin/crb enable to enable the CRB repository.

  Verifying        : epel-release-9-5.el9.noarch                             1/1

Installed:
  epel-release-9-5.el9.noarch

Complete!
```

Add the option `-y` to skip the confirmation question. If the package is already installed, `install` will upgrade the package to the latest version.

```console
[student@el ~]$ sudo dnf install -y sudo
Last metadata expiration check: 0:01:45 ago on Sun 25 Feb 2024 07:43:07 PM UTC.
Package sudo-1.9.5p2-9.el9.x86_64 is already installed.
Dependencies resolved.
================================================================================
 Package       Architecture    Version                    Repository       Size
================================================================================
Upgrading:
 sudo          x86_64          1.9.5p2-10.el9_3           baseos          1.0 M

Transaction Summary
================================================================================
Upgrade  1 Package

Total download size: 1.0 M
Downloading Packages:
sudo-1.9.5p2-10.el9_3.x86_64.rpm                3.0 MB/s | 1.0 MB     00:00    
--------------------------------------------------------------------------------
Total                                           1.3 MB/s | 1.0 MB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Upgrading        : sudo-1.9.5p2-10.el9_3.x86_64                           1/2 
  Running scriptlet: sudo-1.9.5p2-10.el9_3.x86_64                           1/2 
  Cleanup          : sudo-1.9.5p2-9.el9.x86_64                              2/2 
  Running scriptlet: sudo-1.9.5p2-9.el9.x86_64                              2/2 
  Verifying        : sudo-1.9.5p2-10.el9_3.x86_64                           1/2 
  Verifying        : sudo-1.9.5p2-9.el9.x86_64                              2/2 

Upgraded:
  sudo-1.9.5p2-10.el9_3.x86_64

Complete!
```

You can add more than one parameter here.

```console
[student@el ~]$ sudo dnf install httpd mod_ssl mariadb-server php php-mysqlnd
```

## dnf upgrade

To bring all applications up to date, by downloading and installing them, issue `dnf upgrade`. All software that was installed via `dnf` will be updated to the latest version that is available in the repository.

```console
[student@el ~]$ sudo dnf upgrade
Last metadata expiration check: 0:05:19 ago on Sun 25 Feb 2024 07:43:07 PM UTC.
Dependencies resolved.
================================================================================
 Package                  Arch    Version                      Repository  Size 
================================================================================
Installing:
 kernel                   x86_64  5.14.0-362.18.1.el9_3        baseos     9.4 k 
Upgrading:
 epel-release             noarch  9-7.el9                      epel        19 k 
 gnutls                   x86_64  3.7.6-23.el9_3.3             baseos     1.0 M 
[...]

Transaction Summary
================================================================================
Install  10 Packages
Upgrade  12 Packages

Total download size: 89 M
Is this ok [y/N]: y
Downloading Packages:
(1/22): graphite2-1.3.14-9.el9.x86_64.rpm       189 kB/s |  94 kB     00:00    
(2/22): freetype-2.10.4-9.el9.x86_64.rpm        752 kB/s | 387 kB     00:00     
[...]
Complete!
```

If you only want to update one package, use `dnf upgrade $package`. It behaves the same as `dnf install $package`.

## dnf provides

To search for a package containing a certain file use `dnf provides $filename` (or globbing pattern). This is especially useful if you want to install a specific command that has a different name than the package name. For example, say that you've heard about the [`ag` command](https://github.com/ggreer/the_silver_searcher) that is a faster alternative to `grep`. The command `dnf search ag` spews out too much output, so no useful results:

```console
[student@el ~]$ dnf search ag | wc -l
Last metadata expiration check: 0:02:48 ago on Sun 25 Feb 2024 07:55:24 PM UTC.
2979
```

Listing available packages with `ag` shows that there is no such package:

```console
[student@el ~]$ dnf list --available ag
Last metadata expiration check: 0:04:05 ago on Sun 25 Feb 2024 07:55:24 PM UTC.
Error: No matching Packages to list
[student@el ~]$ dnf list --available ag*
Last metadata expiration check: 0:04:09 ago on Sun 25 Feb 2024 07:55:24 PM UTC.
Available Packages
Agda.x86_64                    2.6.2.2-36.el9                               epel
Agda-common.noarch             2.6.2.2-36.el9                               epel
aggregate6.noarch              1.0.12-2.el9                                 epel
agrep.x86_64                   0.8.0-34.20140228gitc2f5d13.el9              epel
```

The last package looks promising, but it's not the one we're looking for. So let's use `dnf provides` to find out which package contains the `ag` command. If the command is `ag`, we expect that it is installed in one of the `bin/` directories, i.e. `/bin`, `/usr/bin`, `/sbin`, `/usr/sbin`, `/usr/local/bin`, `/usr/local/sbin`, `/usr/local/bin`, `/usr/local/sbin`. We can summarize the possible path names with globbing pattern `*bin/ag`:

```console
[student@el ~]$ dnf provides *bin/ag
Last metadata expiration check: 0:07:13 ago on Sun 25 Feb 2024 07:55:24 PM UTC.
the_silver_searcher-2.2.0^2020704.5a1c8d8-3.el9.x86_64 : Super-fast text
                                                       : searching tool (ag)
Repo        : epel
Matched from:
Other       : *bin/ag
[student@el ~]$ sudo dnf install -y the_silver_searcher
```

So, the name of the package is `the_silver_searcher` (`ag` being the chemical symbol for silver), and it is provided by the [EPEL repository](https://docs.fedoraproject.org/en-US/epel/) (Extra Packages for Enterprise Linux). We can install it with `dnf install the_silver_searcher`.

## dnf remove

Removing a package is done with `dnf remove $package`. This will remove the package and all its dependencies that are not needed by other packages.

```console
[student@el ~]$ sudo dnf remove net-tools
Dependencies resolved.
================================================================================
 Package        Arch        Version                        Repository      Size 
================================================================================
Removing:
 net-tools      x86_64      2.0-0.62.20160912git.el9       @anaconda      912 k 

Transaction Summary
================================================================================
Remove  1 Package

Freed space: 912 k
Is this ok [y/N]: y
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Erasing          : net-tools-2.0-0.62.20160912git.el9.x86_64              1/1 
  Verifying        : net-tools-2.0-0.62.20160912git.el9.x86_64              1/1 

Removed:
  net-tools-2.0-0.62.20160912git.el9.x86_64

Complete!
```

By the way, this package, `net-tools`, contains commands that are considered to be obsolete and have been replaced by other, newer implementations. You don't really need it, so it's a good example for this section. If you removed it, feel free to reinstall it if you want!

## dnf software groups

Issue `dnf grouplist` to see a list of all available software groups.

```console
[student@el ~]$ dnf grouplist
Last metadata expiration check: 1:00:37 ago on Sun 25 Feb 2024 07:55:24 PM UTC.
Available Environment Groups:
   Server with GUI
   Server
   Minimal Install
   Workstation
   KDE Plasma Workspaces
   Virtualization Host
   Custom Operating System
Available Groups:
   RPM Development Tools
   .NET Development
   Container Management
   Console Internet Tools
   Graphical Administration Tools
   Scientific Support
   Headless Management
   Smart Card Support
   Legacy UNIX Compatibility
   Security Tools
   Network Servers
   System Tools
   Development Tools
   Fedora Packager
   VideoLAN Client
   Xfce
```

To install a set of applications, brought together via a group, use
`yum groupinstall $groupname`.

```console
[student@el ~]$ sudo dnf groupinstall 'Security Tools'
Last metadata expiration check: 1:00:35 ago on Sun 25 Feb 2024 08:03:34 PM UTC.
Dependencies resolved.
================================================================================
 Package                Arch      Version                    Repository    Size 
================================================================================
Installing group/module packages:
 scap-security-guide    noarch    0.1.69-3.el9_3.alma.1      appstream    813 k 
Installing dependencies:
 libtool-ltdl           x86_64    2.4.6-45.el9               appstream     36 k 
 libxslt                x86_64    1.1.34-9.el9               appstream    240 k 
 openscap               x86_64    1:1.3.8-1.el9_2.alma.2     appstream    1.9 M 
 openscap-scanner       x86_64    1:1.3.8-1.el9_2.alma.2     appstream     57 k 
 xml-common             noarch    0.6.3-58.el9               appstream     31 k 
 xmlsec1                x86_64    1.2.29-9.el9               appstream    189 k 
 xmlsec1-openssl        x86_64    1.2.29-9.el9               appstream     90 k 
Installing Groups:
 Security Tools

Transaction Summary
================================================================================
Install  8 Packages

Total download size: 3.3 M
Installed size: 103 M
Is this ok [y/N]: 
[...]
```

Read the manual page of `dnf` for more information about managing groups in `dnf`. In practice, chances are that you won't need this feature very often.

## rpm -qa

In the following sections, we'll show what you can do with the `rpm` command.

To obtain a list of all installed software, use the `rpm -qa` command.

```console
[student@el ~]$ rpm -qa | grep ssh
libssh-config-0.10.4-11.el9.noarch
libssh-0.10.4-11.el9.x86_64
openssh-8.7p1-34.el9.x86_64
openssh-clients-8.7p1-34.el9.x86_64
openssh-server-8.7p1-34.el9.x86_64
```

## rpm -q

To verify whether one package is installed, use `rpm -q`.

```console
[student@el ~]$ rpm -q vim-enhanced
package vim-enhanced is not installed
[student@el ~]$ rpm -q vim-minimal
vim-minimal-8.2.2637-20.el9_1.x86_64
[student@el ~]$ rpm -q kernel
kernel-5.14.0-362.8.1.el9_3.x86_64
kernel-5.14.0-362.13.1.el9_3.x86_64
kernel-5.14.0-362.18.1.el9_3.x86_64
```

## rpm -ql

To see which files are installed by a package, use `rpm -ql`.

```console
[student@el ~]$ rpm -ql vim-minimal
/etc/virc
/usr/bin/ex
/usr/bin/rvi
/usr/bin/rview
/usr/bin/vi
/usr/bin/view
/usr/lib/.build-id
/usr/lib/.build-id/c6
/usr/lib/.build-id/c6/aa3d8d79f09dd48e99475c332bed4df39d76e1
/usr/libexec/vi
/usr/share/man/man1/ex.1.gz
/usr/share/man/man1/rvi.1.gz
/usr/share/man/man1/rview.1.gz
/usr/share/man/man1/vi.1.gz
/usr/share/man/man1/view.1.gz
/usr/share/man/man5/virc.5.gz
```

## rpm -Uvh

To install or upgrade a package, use the -Uvh switches. The -U switch is the same as -i for install, except that older versions of the software are removed. The -vh switches are for nicer output.

You would typically use this command to install an .rpm package that you have downloaded from the internet. Beware, though, that `rpm` does not resolve dependencies, so you might need to install other packages first.

```console

[student@el ~]$ sudo rpm -Uvh ./htop-3.3.0-1.el9.x86_64.rpm 
error: Failed dependencies:
        libhwloc.so.15()(64bit) is needed by htop-3.3.0-1.el9.x86_64
```

## rpm -e

To remove a package, use the -e switch.

```console
[student@el ~]$ rpm -q net-tools
net-tools-2.0-0.62.20160912git.el9.x86_64
[student@el ~]$ sudo rpm -e net-tools
[student@el ~]$ rpm -q net-tools
package net-tools is not installed
```

`rpm -e` verifies dependencies, and thus will prevent you from accidentailly erasing packages that are needed by other packages.

```console
[student@el ~]$ sudo rpm -e slang
error: Failed dependencies:
        libslang.so.2()(64bit) is needed by (installed) newt-0.52.21-11.el9.x86_64
        libslang.so.2(SLANG2)(64bit) is needed by (installed) newt-0.52.21-11.el9.x86_64
```

## Package cache

When `dnf` installs or upgrades a package, it will download the package from the repository and store it temporarily in the cache. The cache also contains repository metadata. The default location of the cache is `/var/cache/dnf`. You can clean the cache with `dnf clean all`.

```console
[student@el ~]$ dnf clean all 
51 files removed
```

Remark that .rpm files will normally be removed automatically after they were installed successfully. You can change this behavior in `/etc/dnf/dnf.conf` by setting `keepcache=1`.

## Configuration

The main configuration file for `dnf` is `/etc/dnf/dnf.conf`. This file contains a few basic settings. The location of package repositories that are available to the system are kept in the directory `/etc/yum.repos.d/`. Each repository has its own file, with a `.repo` extension.

```console
[student@el ~]$ ls /etc/yum.repos.d/
almalinux-appstream.repo         almalinux-resilientstorage.repo
almalinux-baseos.repo            almalinux-rt.repo
almalinux-crb.repo               almalinux-saphana.repo
almalinux-extras.repo            almalinux-sap.repo
almalinux-highavailability.repo  epel-cisco-openh264.repo
almalinux-nfv.repo               epel.repo
almalinux-plus.repo              epel-testing.repo
```

A repo file is a text file in the [INI format](https://en.wikipedia.org/wiki/INI_file), and contains information about the repository, such as the name, the base URL, the GPG key, etc. Here's an example with part of the contents of the `epel.repo` file:

```ini
[epel]
name=Extra Packages for Enterprise Linux $releasever - $basearch
# It is much more secure to use the metalink, but if you wish to use a local mirror
# place its address here.
#baseurl=https://download.example/pub/epel/$releasever/Everything/$basearch/    
metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=$basearch&infra=$infra&content=$contentdir
enabled=1
gpgcheck=1
countme=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$releasever
```

## Working with multiple repositories

You can get a list of the currently enabled repositories with `dnf repolist`.

```console
[student@el ~]$ dnf repolist
repo id             repo name
appstream           AlmaLinux 9 - AppStream
baseos              AlmaLinux 9 - BaseOS
epel                Extra Packages for Enterprise Linux 9 - x86_64
epel-cisco-openh264 Extra Packages for Enterprise Linux 9 openh264 (From Cisco) - x86_64
extras              AlmaLinux 9 - Extras
```

And specific information about a repository with `dnf repoinfo $repo`.

```console
[student@el ~]$ dnf repoinfo epel-testing
Last metadata expiration check: 0:02:40 ago on Sun 25 Feb 2024 10:32:04 PM UTC.
Repo-id            : epel-testing
Repo-name          : Extra Packages for Enterprise Linux 9 - Testing - x86_64   
Repo-status        : disabled
Repo-metalink      : https://mirrors.fedoraproject.org/metalink?repo=testing-epel9&arch=x86_64&infra=$infra&content=$contentdir
Repo-expire        : 172,800 second(s) (last: unknown)
Repo-filename      : /etc/yum.repos.d/epel-testing.repo
Total packages: 0
```

One important flag for dnf is `--enablerepo`. Use this command if you want to use a repository that is not enabled by default. For example, let's say you want to install the latest version of `fail2ban`, but the one in the "normal" repository is too old:

```console
[student@el ~]$ dnf list --available fail2ban
Last metadata expiration check: 0:01:44 ago on Sun 25 Feb 2024 10:32:04 PM UTC.
Available Packages
fail2ban.noarch                         1.0.2-7.el9                         epel
```

Maybe `epel-testing` has a newer version:

```console
[student@el ~]$ dnf list --available --repo epel-testing fail2ban
Last metadata expiration check: 0:06:10 ago on Sun 25 Feb 2024 10:30:33 PM UTC.
Available Packages
fail2ban.noarch                    1.0.2-12.el9                     epel-testing
```

It does, but you won't be able to install it due to the fact that `epel-testing` is disabled. However, you can temporarily enable it with the `--enablerepo` flag:

```console
[student@el ~]$ sudo dnf install --enablerepo=epel-testing fail2ban
[sudo] password for student: 
Last metadata expiration check: 0:13:34 ago on Sun 25 Feb 2024 10:24:12 PM UTC.
Dependencies resolved.
================================================================================
 Package                 Arch        Version            Repository         Size
================================================================================
Installing:
 fail2ban                noarch      1.0.2-12.el9       epel-testing      8.8 k 
Installing dependencies:
 esmtp                   x86_64      1.2-19.el9         epel               52 k 
 fail2ban-firewalld      noarch      1.0.2-12.el9       epel-testing      8.9 k 
 fail2ban-selinux        noarch      1.0.2-12.el9       epel-testing       29 k 
 fail2ban-sendmail       noarch      1.0.2-12.el9       epel-testing       12 k 
 fail2ban-server         noarch      1.0.2-12.el9       epel-testing      444 k 
 libesmtp                x86_64      1.0.6-24.el9       epel               66 k 
 liblockfile             x86_64      1.14-10.el9        baseos             28 k 

Transaction Summary
================================================================================
Install  8 Packages

Total download size: 647 k
Installed size: 1.8 M
Is this ok [y/N]:
```

