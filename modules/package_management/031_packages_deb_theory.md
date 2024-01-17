# deb package management

## about deb

Most people use `aptitude` or `apt-get` to manage their Debian/Ubuntu
family of Linux distributions. Both are a front end for `dpkg` and are
themselves a back end for `synaptic` and other graphical tools.

## dpkg -l

The low level tool to work with `.deb` packages is `dpkg`.
Here you see how to obtain a list of all installed packages on a Debian
server.

    root@debian6:~# dpkg -l | wc -l
    265

Compare this to the same list on a Ubuntu Desktop computer.

    root@ubu1204~# dpkg -l | wc -l
    2527

## dpkg -l \$package

Here is an example on how to get information on an individual package.
The ii at the beginning means the package is installed.

    root@debian6:~# dpkg -l rsync | tail -1 | tr -s  ' ' 
    ii rsync 3.0.7-2 fast remote file copy program (like rcp)

## dpkg -S

You can find the package that installed a certain file on your computer
with `dpkg -S`. This example shows how to find the package for three
files on a typical Debian server.

    root@debian6:~# dpkg -S /usr/share/doc/tmux/ /etc/ssh/ssh_config /sbin/ifconfig 
    tmux: /usr/share/doc/tmux/
    openssh-client: /etc/ssh/ssh_config
    net-tools: /sbin/ifconfig

## dpkg -L

You can also get a list of all files that are installed by a certain
program. Below is the list for the `tmux` package.

    root@debian6:~# dpkg -L tmux
    /.
    /etc
    /etc/init.d
    /etc/init.d/tmux-cleanup
    /usr
    /usr/share
    /usr/share/lintian
    /usr/share/lintian/overrides
    /usr/share/lintian/overrides/tmux
    /usr/share/doc
    /usr/share/doc/tmux
    /usr/share/doc/tmux/TODO.gz
    /usr/share/doc/tmux/FAQ.gz
    /usr/share/doc/tmux/changelog.Debian.gz
    /usr/share/doc/tmux/NEWS.Debian.gz
    /usr/share/doc/tmux/changelog.gz
    /usr/share/doc/tmux/copyright
    /usr/share/doc/tmux/examples
    /usr/share/doc/tmux/examples/tmux.vim.gz
    /usr/share/doc/tmux/examples/h-boetes.conf
    /usr/share/doc/tmux/examples/n-marriott.conf
    /usr/share/doc/tmux/examples/screen-keys.conf
    /usr/share/doc/tmux/examples/t-williams.conf
    /usr/share/doc/tmux/examples/vim-keys.conf
    /usr/share/doc/tmux/NOTES
    /usr/share/man
    /usr/share/man/man1
    /usr/share/man/man1/tmux.1.gz
    /usr/bin
    /usr/bin/tmux

## dpkg

You could use `dpkg -i` to install a package and `dpkg -r` to remove a
package, but you\'d have to manually keep track of dependencies. Using
`apt-get` or `aptitude` is much easier.

# apt-get

`Debian` has been using `apt-get` to manage packages since
1998. Today Debian and many Debian-based distributions still actively
support `apt-get`, though some experts claim `aptitude` is better at
handling dependencies than `apt-get`.

Both commands use the same configuration files and can be used
alternately; whenever you see `apt-get` in documentation, feel free to
type `aptitude`.

We will start with `apt-get` and discuss `aptitude` in the next section.

## apt-get update

When typing `apt-get update` you are downloading the names, versions and
short description of all packages available on all configured
repositories for your system.

In the example below you can see some repositories at the url
`be.archive.ubuntu.com` because this computer was installed in Belgium.
This url can be different for you.

    root@ubu1204~# apt-get update
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
    root@mac~#

Run `apt-get update` every time before performing other package
operations.

## apt-get upgrade

One of the nicest features of `apt-get` is that it allows for a secure
update of `all software currently installed` on your computer with just
`one` command.

    root@debian6:~# apt-get upgrade
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    root@debian6:~# 

The above screenshot shows that all software is updated to the latest
version available for my distribution.

## apt-get clean

`apt-get` keeps a copy of downloaded packages in
`/var/cache/apt/archives`, as can be seen in this screenshot.

    root@ubu1204~# ls /var/cache/apt/archives/ | head
    accountsservice_0.6.15-2ubuntu9.4_i386.deb
    apport_2.0.1-0ubuntu14_all.deb
    apport-gtk_2.0.1-0ubuntu14_all.deb
    apt_0.8.16~exp12ubuntu10.3_i386.deb
    apt-transport-https_0.8.16~exp12ubuntu10.3_i386.deb
    apt-utils_0.8.16~exp12ubuntu10.3_i386.deb
    bind9-host_1%3a9.8.1.dfsg.P1-4ubuntu0.4_i386.deb
    chromium-browser_20.0.1132.47~r144678-0ubuntu0.12.04.1_i386.deb
    chromium-browser-l10n_20.0.1132.47~r144678-0ubuntu0.12.04.1_all.deb
    chromium-codecs-ffmpeg_20.0.1132.47~r144678-0ubuntu0.12.04.1_i386.deb

Running `apt-get clean` removes all .deb files from that directory.

    root@ubu1204~# apt-get clean
    root@ubu1204~# ls /var/cache/apt/archives/*.deb
    ls: cannot access /var/cache/apt/archives/*.deb: No such file or directory

## apt-cache search

Use `apt-cache search` to search for availability of a package. Here we
look for `rsync`.

    root@ubu1204~# apt-cache search rsync | grep ^rsync
    rsync - fast, versatile, remote (and local) file-copying tool
    rsyncrypto - rsync friendly encryption

## apt-get install

You can install one or more applications by appending their name behind
`apt-get install`. The screenshot shows how to install the `rsync`
package.

    root@ubu1204~# apt-get install rsync
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    The following NEW packages will be installed:
      rsync
    0 upgraded, 1 newly installed, 0 to remove and 8 not upgraded.
    Need to get 299 kB of archives.
    After this operation, 634 kB of additional disk space will be used.
    Get:1 http://be.archive.ubuntu.com/ubuntu/ precise/main rsync i386 3.0.9-1ubuntu1 [299 kB]
    Fetched 299 kB in 0s (740 kB/s)
    Selecting previously unselected package rsync.
    (Reading database ... 323649 files and directories currently installed.)
    Unpacking rsync (from .../rsync_3.0.9-1ubuntu1_i386.deb) ...
    Processing triggers for man-db ...
    Processing triggers for ureadahead ...
    Setting up rsync (3.0.9-1ubuntu1) ...
     Removing any system startup links for /etc/init.d/rsync ...
    root@ubu1204~#

## apt-get remove

You can remove one or more applications by appending their name behind
`apt-get remove`. The screenshot shows how to remove the `rsync`
package.

    root@ubu1204~# apt-get remove rsync
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    The following packages will be REMOVED:
      rsync ubuntu-standard
    0 upgraded, 0 newly installed, 2 to remove and 8 not upgraded.
    After this operation, 692 kB disk space will be freed.
    Do you want to continue [Y/n]? 
    (Reading database ... 323681 files and directories currently installed.)
    Removing ubuntu-standard ...
    Removing rsync ...
     * Stopping rsync daemon rsync                                                                                                                                                                 [ OK ] 
    Processing triggers for ureadahead ...
    Processing triggers for man-db ...
    root@ubu1204~#

Note however that some configuration information is not removed.

    root@ubu1204~# dpkg -l rsync | tail -1 | tr -s ' ' 
    rc rsync 3.0.9-1ubuntu1 fast, versatile, remote (and local) file-copying tool

## apt-get purge

You can purge one or more applications by appending their name behind
`apt-get purge`. Purging will also remove all existing configuration
files related to that application. The screenshot shows how to purge the
`rsync` package.

    root@ubu1204~# apt-get purge rsync
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    The following packages will be REMOVED:
      rsync*
    0 upgraded, 0 newly installed, 1 to remove and 8 not upgraded.
    After this operation, 0 B of additional disk space will be used.
    Do you want to continue [Y/n]? 
    (Reading database ... 323651 files and directories currently installed.)
    Removing rsync ...
    Purging configuration files for rsync ...
    Processing triggers for ureadahead ...
    root@ubu1204~#

Note that `dpkg` has no information about a purged package, except that
it is uninstalled and no configuration is left on the system.

    root@ubu1204~# dpkg -l rsync | tail -1 | tr -s ' ' 
    un rsync <none> (no description available)

# aptitude

Most people use `aptitude` for package management on
Debian, Mint and Ubuntu systems.

To synchronize with the repositories.

    aptitude update

To patch and upgrade all software to the latest version on Debian.

    aptitude upgrade

To patch and upgrade all software to the latest version on Ubuntu and
Mint.

    aptitude safe-upgrade

To install an application with all dependencies.

    aptitude install $package

To search the repositories for applications that contain a certain
string in their name or description.

    aptitude search $string

To remove an application.

    aptitude remove $package

To remove an application and all configuration files.

    aptitude purge $package

# apt

Both `apt-get` and `aptitude` use the same configuration information in
`/etc/apt/`. Thus adding a repository for one of them, will
automatically add it for both.

## /etc/apt/sources.list

The resource list used by `apt-get` and `aptitude` is located in
`/etc/apt/sources.list`. This file contains a list of http
or ftp sources where packages for the distribution can be downloaded.

This is what that list looks like on my Debian server.

    root@debian6:~# cat /etc/apt/sources.list
    deb http://ftp.be.debian.org/debian/ squeeze main
    deb-src http://ftp.be.debian.org/debian/ squeeze main

    deb http://security.debian.org/ squeeze/updates main
    deb-src http://security.debian.org/ squeeze/updates main

    # squeeze-updates, previously known as 'volatile'
    deb http://ftp.be.debian.org/debian/ squeeze-updates main
    deb-src http://ftp.be.debian.org/debian/ squeeze-updates main

On my Ubuntu there are four times as many online repositories in use.

    root@ubu1204~# wc -l /etc/apt/sources.list
    63 /etc/apt/sources.list

There is much more to learn about `apt`, explore commands like
`add-apt-repository`, `apt-key` and `apropos apt`.
