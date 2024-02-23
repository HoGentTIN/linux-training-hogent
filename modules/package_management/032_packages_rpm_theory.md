# rpm

## about rpm

The `Red Hat package manager` can be used on the command
line with `rpm` or in a graphical way going to Applications\--System
Settings\--Add/Remove Applications. Type `rpm --help` to see some of the
options.

Software distributed in the `rpm` format will be named
`foo-version.platform.rpm` .

## rpm -qa

To obtain a list of all installed software, use the `rpm -qa` command.

    [root@linux ~]# rpm -qa | grep samba
    system-config-samba-1.2.39-1.el5
    samba-3.0.28-1.el5_2.1
    samba-client-3.0.28-1.el5_2.1
    samba-common-3.0.28-1.el5_2.1

## rpm -q

To verify whether one package is installed, use `rpm -q`.

    root@linux:~# rpm -q gcc
    gcc-3.4.6-3
    root@linux:~# rpm -q laika
    package laika is not installed

## rpm -Uvh

To install or upgrade a package, use the -Uvh switches. The -U switch is
the same as -i for install, except that older versions of the software
are removed. The -vh switches are for nicer output.

    root@linux:~# rpm -Uvh gcc-3.4.6-3

## rpm -e

To remove a package, use the -e switch.

    root@linux:~# rpm -e gcc-3.4.6-3

`rpm -e` verifies dependencies, and thus will prevent you from
accidentailly erasing packages that are needed by other packages.

    [root@linux ~]# rpm -e gcc-4.1.2-42.el5
    error: Failed dependencies:
    gcc = 4.1.2-42.el5 is needed by (installed) gcc-c++-4.1.2-42.el5.i386
    gcc = 4.1.2-42.el5 is needed by (installed) gcc-gfortran-4.1.2-42.el5.i386
    gcc is needed by (installed) systemtap-0.6.2-1.el5_2.2.i386

## /var/lib/rpm

The `rpm` database is located at `/var/lib/rpm`. This
database contains all meta information about packages that are installed
(via rpm). It keeps track of all files, which enables complete removes
of software.

## rpm2cpio

We can use `rpm2cpio` to convert an `rpm` to a
`cpio` archive.

    [root@linux ~]# file kernel.src.rpm 
    kernel.src.rpm: RPM v3 src PowerPC kernel-2.6.18-92.1.13.el5
    [root@linux ~]# rpm2cpio kernel.src.rpm > kernel.cpio
    [root@linux ~]# file kernel.cpio 
    kernel.cpio: ASCII cpio archive (SVR4 with no CRC)

But why would you want to do this ?

Perhaps just to see of list of files in the `rpm` file.

    [root@linux ~]# rpm2cpio kernel.src.rpm | cpio -t | head -5
    COPYING.modules
    Config.mk
    Module.kabi_i686
    Module.kabi_i686PAE
    Module.kabi_i686xen

Or to extract one file from an `rpm` package.

    [root@linux ~]# rpm2cpio kernel.src.rpm | cpio -iv Config.mk
    Config.mk
    246098 blocks

# yum

## about yum

The `Yellowdog Updater, Modified (yum)` is an easier
command to work with `rpm` packages. It is installed by default on
Fedora and Red Hat Enterprise Linux since version 5.2.

## yum list

Issue `yum list available` to see a list of available packages. The
`available` parameter is optional.

    root@linux:/etc# yum list | wc -l
    This system is receiving updates from Red Hat Subscription Management.
    3935
    root@linux:/etc#

Issue `yum list $package` to get all versions (in different
repositories) of one package.

    [root@linux ~]# yum list samba
    Loaded plugins: rhnplugin, security
    Installed Packages
    samba.i386                 3.0.33-3.28.el5         installed         
    Available Packages
    samba.i386                 3.0.33-3.29.el5_5       rhel-i386-server-5

## yum search

To search for a package containing a certain string in the description
or name use `yum search $string`.

    [root@linux ~]# yum search gcc44
    Loaded plugins: rhnplugin, security
    ========================== Matched: gcc44 ===========================
    gcc44.i386 : Preview of GCC version 4.4
    gcc44-c++.i386 : C++ support for GCC version 4.4
    gcc44-gfortran.i386 : Fortran support for GCC 4.4 previe

## yum provides

To search for a package containing a certain file (you might need for
compiling things) use `yum provides $filename`.

    root@linux:/etc# yum provides /usr/share/man/man5/passwd.5.gz
    Loaded plugins: product-id, subscription-manager
    This system is receiving updates from Red Hat Subscription Management.
    rhel-6-server-cf-tools-1-rpms                                 | 2.8 kB     00:00
    rhel-6-server-rpms                                            | 3.7 kB     00:00
    man-pages-3.22-12.el6.noarch : Man (manual) pages from the Linux Documenta...
    Repo        : rhel-6-server-rpms
    Matched from:
    Filename    : /usr/share/man/man5/passwd.5.gz



    man-pages-3.22-20.el6.noarch : Man (manual) pages from the Linux Documenta...
    Repo        : rhel-6-server-rpms
    Matched from:
    Filename    : /usr/share/man/man5/passwd.5.gz



    man-pages-3.22-17.el6.noarch : Man (manual) pages from the Linux Documenta...
    Repo        : rhel-6-server-rpms
    Matched from:
    Filename    : /usr/share/man/man5/passwd.5.gz



    man-pages-3.22-20.el6.noarch : Man (manual) pages from the Linux Documenta...
    Repo        : installed
    Matched from:
    Other       : Provides-match: /usr/share/man/man5/passwd.5.gz



    root@linux:/etc#

## yum install

To install an application, use `yum install $package`. Naturally `yum`
will install all the necessary dependencies.

    [root@linux ~]# yum install sudo
    Loaded plugins: rhnplugin, security
    Setting up Install Process
    Resolving Dependencies
    --> Running transaction check
    ---> Package sudo.i386 0:1.7.2p1-7.el5_5 set to be updated
    --> Finished Dependency Resolution

    Dependencies Resolved

    =======================================================================
     Package     Arch      Version            Repository               Size
    =======================================================================
    Installing:
     sudo        i386      1.7.2p1-7.el5_5    rhel-i386-server-5      230 k

    Transaction Summary
    =======================================================================
    Install       1 Package(s)
    Upgrade       0 Package(s)

    Total download size: 230 k
    Is this ok [y/N]: y
    Downloading Packages:
    sudo-1.7.2p1-7.el5_5.i386.rpm                       | 230 kB     00:00 
    Running rpm_check_debug
    Running Transaction Test
    Finished Transaction Test
    Transaction Test Succeeded
    Running Transaction
      Installing     : sudo                                        1/1 

    Installed:
      sudo.i386 0:1.7.2p1-7.el5_5

    Complete!  

You can add more than one parameter here.

    yum install $package1 $package2 $package3

## yum update

To bring all applications up to date, by downloading and installing
them, issue `yum update`. All software that was installed via `yum` will
be updated to the latest version that is available in the repository.

    yum update

If you only want to update one package, use `yum update $package`.

    [root@linux ~]# yum update sudo
    Loaded plugins: rhnplugin, security
    Skipping security plugin, no data
    Setting up Update Process
    Resolving Dependencies
    Skipping security plugin, no data
    --> Running transaction check
    ---> Package sudo.i386 0:1.7.2p1-7.el5_5 set to be updated
    --> Finished Dependency Resolution

    Dependencies Resolved

    =====================================================================
     Package     Arch    Version           Repository                Size
    =====================================================================
    Updating:
     sudo        i386    1.7.2p1-7.el5_5   rhel-i386-server-5       230 k

    Transaction Summary
    =====================================================================
    Install       0 Package(s)
    Upgrade       1 Package(s)

    Total download size: 230 k
    Is this ok [y/N]: y
    Downloading Packages:
    sudo-1.7.2p1-7.el5_5.i386.rpm                      | 230 kB     00:00 
    Running rpm_check_debug
    Running Transaction Test
    Finished Transaction Test
    Transaction Test Succeeded
    Running Transaction
      Updating       : sudo                                           1/2
      Cleanup        : sudo                                           2/2

    Updated:
      sudo.i386 0:1.7.2p1-7.el5_5

    Complete!

## yum software groups

Issue `yum grouplist` to see a list of all available software groups.

    [root@linux ~]# yum grouplist
    Loaded plugins: rhnplugin, security
    Setting up Group Process
    Installed Groups:
       Administration Tools
       Authoring and Publishing
       DNS Name Server
       Development Libraries
       Development Tools
       Editors
       GNOME Desktop Environment
       GNOME Software Development
       Graphical Internet
       Graphics
       Legacy Network Server
       Legacy Software Development
       Legacy Software Support
       Mail Server
       Network Servers
       Office/Productivity
       Printing Support
       Server Configuration Tools
       System Tools
       Text-based Internet
       Web Server
       Windows File Server
       X Software Development
       X Window System
    Available Groups:
       Engineering and Scientific
       FTP Server
       Games and Entertainment
       Java Development
       KDE (K Desktop Environment)
       KDE Software Development
       MySQL Database
       News Server
       OpenFabrics Enterprise Distribution
       PostgreSQL Database
       Sound and Video
    Done

To install a set of applications, brought together via a group, use
`yum groupinstall $groupname`.

    [root@linux ~]# yum groupinstall 'Sound and video'
    Loaded plugins: rhnplugin, security
    Setting up Group Process
    Package alsa-utils-1.0.17-1.el5.i386 already installed and latest version
    Package sox-12.18.1-1.i386 already installed and latest version
    Package 9:mkisofs-2.01-10.7.el5.i386 already installed and latest version
    Package 9:cdrecord-2.01-10.7.el5.i386 already installed and latest version
    Package cdrdao-1.2.1-2.i386 already installed and latest version
    Resolving Dependencies
    --> Running transaction check
    ---> Package cdda2wav.i386 9:2.01-10.7.el5 set to be updated
    ---> Package cdparanoia.i386 0:alpha9.8-27.2 set to be updated
    ---> Package sound-juicer.i386 0:2.16.0-3.el5 set to be updated
    --> Processing Dependency: libmusicbrainz >= 2.1.0 for package: sound-juicer
    --> Processing Dependency: libmusicbrainz.so.4 for package: sound-juicer
    ---> Package vorbis-tools.i386 1:1.1.1-3.el5 set to be updated
    --> Processing Dependency: libao >= 0.8.4 for package: vorbis-tools
    --> Processing Dependency: libao.so.2 for package: vorbis-tools
    --> Running transaction check
    ---> Package libao.i386 0:0.8.6-7 set to be updated
    ---> Package libmusicbrainz.i386 0:2.1.1-4.1 set to be updated
    --> Finished Dependency Resolution
    ...

Read the manual page of `yum` for more information about managing groups
in `yum`.

## /etc/yum.conf and repositories

The configuration of `yum` repositories is done in `/etc/yum/yum.conf`
and `/etc/yum/repos.d/`.

Configurating `yum` itself is done in `/etc/yum.conf`.
This file will contain the location of a log file and a cache directory
for `yum` and can also contain a list of repositories.

Recently `yum` started accepting several `repo` files with each file
containing a list of `repositories`. These `repo` files are located in
the `/etc/yum.repos.d/` directory.

One important flag for yum is `enablerepo`. Use this command if you want
to use a repository that is not enabled by default.

    yum $command $foo --enablerepo=$repo

An example of the contents of the repo file: MyRepo.repo

    [$repo]
    name=My Repository
    baseurl=http://path/to/MyRepo
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-MyRep

