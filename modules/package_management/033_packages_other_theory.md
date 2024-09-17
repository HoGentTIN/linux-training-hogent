## pip, the Python package manager

Some programming languages, a.o. [Python](https://www.python.org), have their own package management system that allows you to install applications and/or libraries. In the case of Python, the package manager is called `pip`. It is used to install Python packages from the [Python Package Index](https://pypi.org) (PyPI). In fact, there are multiple package managers for Python (a.o. easy_install, conda, etc.), but `pip` is the most widely used.

As a system administrator, or as an end user, this sometimes puts you in a difficult position. Some widely known and used Python libraries can be installed both through your distribution's package manager, and through pip. Which one to choose is not always clear. In general, it is best to use the distribution's package manager, as it will integrate the package into the system and will be updated when the system is updated. However, some packages are not available in the distribution's repositories, or the version you get with `pip` is more recent. In that case, you can use `pip` to install the package.

Another thing to note is that `pip` can be used as a normal user, or as root, and in each case it will install the package in a different location. When you install a package as a normal user, it will be installed in your home directory, and will only be available to you. When you install a package as root, it will be installed system-wide, and will be available to all users. However, if you install a package as root, you will get a warning message:

```text
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
```

A virtual environment is a way to create an isolated environment for a Python project, where you can install packages without affecting the system's Python installation. This is especially useful when you are developing Python applications, and you want to make sure that the libraries you use are the same as the ones used in production. Using and managing virtual environments is beyond the scope of this course, but you can find more information in the [Python documentation](https://docs.python.org/3/library/venv.html).

As general guidelines, we suggest the following:

- If the library or application is available in the distribution's repositories, use the distribution's package manager to install it.
- Avoid installing Python libraries or applications system-wide as root using `pip`.
- Normal users may use `pip` to install Python libraries or applications in their home directory.

### installing pip

`pip` may not be installed by default on your system. You can install it using your distribution's package manager. For example, on Debian-based systems, you can install it using `apt`:

```bash
student@debian:~$ sudo apt install python3-pip
```

On Red Hat-based systems, you can install it using `dnf`:

```bash
student@el ~$ sudo dnf install python3-pip
```

### listing packages

You can list the packages installed with `pip` using the `list` command:

```console
student@linux:~$ pip list
Package         Version
--------------- --------
dbus-python     1.2.18
distro          1.5.0
gpg             1.15.1
libcomps        0.1.18
nftables        0.1
pip             21.2.3
PyGObject       3.40.1
python-dateutil 2.8.1
PyYAML          5.4.1
rpm             4.16.1.3
selinux         3.5
sepolicy        3.5
setools         4.4.3
setuptools      53.0.0
six             1.15.0
systemd-python  234
```

### searching for packages

Searching for packages can **NOT** be done on the command line. To search for packages, you can use the [Python Package Index](https://pypi.org) website instead. If you try `pip search`, you will get an error message:

```console
student@linux:~$ pip search ansible
ERROR: XMLRPC request failed [code: -32500]
RuntimeError: PyPI no longer supports 'pip search' (or XML-RPC search). Please use https://pypi.org/search (via a browser) instead. See https://warehouse.pypa.io/api-reference/xml-rpc.html#deprecated-methods for more information.
```

### installing packages

You can install a package using the `install` command:

```console
student@linux:~$ pip install ansible
```

Just like `apt` and `dnf`, `pip` will install the package and its dependencies.

### removing packages

Uninstalling a package is done with the `uninstall` command:

```console
student@linux:~$ pip uninstall ansible
```

Unfortunately, dependencies are not removed when you uninstall a package with `pip`.

## container-based package managers

With the release of Docker, container-based virtualization has become very popular as a method of distributing and deploying applications on servers. One of the advantages of containers is that they offer a sandbox environment for applications, meaning the application and its dependencies are isolated from the rest of the system. This makes it possible to run applications with different dependencies on the same server, without the risk of conflicts. Containers are also very lightweight, they don't impose much overhead on the host system.

Now, there is no reason why containers can't be used to deploy applications on desktop systems as well. In fact, there are several container-based package managers that allow you to install and run applications in containers on your desktop. The advantage is that third party software vendors can distribute their applications independent of the Linux distribution, so they don't need to maintain different packages for (each family of) distribution(s). The disadvantage is that each application comes with their own dependencies, so you lose the advantage of sharing libraries between applications. Also, since the application is running in a container, it may not integrate well with the rest of the system, or may have only limited permissions to access files or other resources on your computer.

As with many Linux-based technologies, there are multiple tools to choose from. The most popular ones are [Flatpak](https://flatpak.org) and [Snap](https://snapcraft.io).

### flatpak

[Flatpak](https://flatpak.org) is a container-based package manager developed by an independent community of contributors, volunteers and supporting organizations. It is available for most Linux distributions and is supported by a large number of third party software vendors. Red Hat was one of the first to endorse Flatpak, and many others followed. Fedora Silverblue is a variant of Fedora that uses Flatpak as its primary package manager. Linux Mint also has Flatpak support enabled by default: in the Software Manager, some applications like Bitwarden, Slack, VS Code, etc. are available as Flatpaks.

If you want to use a container based package manager, Flatpak is probably the best choice for any Linux distribution other than Ubuntu.

In the following example, we'll install the open source password manager Bitwarden with Flatpak on a Linux Mint system. Remark that you don't need to be root to install Flatpak applications!

```console
student@mint:~$ flatpak search Bitwarden
Name       Description                            Application ID         Version  Branch Remotes
Bitwarden  A secure and free password manager for com.bitwarden.desktop  2024.2.0 stable flathub
Goldwarden A Bitwarden compatible desktop client  com.quexten.Goldwarden 0.2.13   stable flathub
student@mint:~$ flatpak install Bitwarden
Looking for matches…
Found ref ‘app/com.bitwarden.desktop/x86_64/stable’ in remote ‘flathub’ (system).
Use this ref? [Y/n]: y
Required runtime for com.bitwarden.desktop/x86_64/stable (runtime/org.freedesktop.Platform/x86_64/23.08) found in remote flathub
Do you want to install it? [Y/n]: y

com.bitwarden.desktop permissions:
    ipc                    network                      wayland       x11       dri       file access [1]
    dbus access [2]        system dbus access [3]

    [1] xdg-download
    [2] com.canonical.AppMenu.Registrar, org.freedesktop.Notifications, org.freedesktop.secrets, org.kde.StatusNotifierWatcher
    [3] org.freedesktop.login1


        ID                                   Branch      Op Remote  Download
 1. [✓] com.bitwarden.desktop.Locale         stable      i  flathub 300.7 kB / 9.8 MB
 2. [✓] org.freedesktop.Platform.GL.default  23.08       i  flathub 162.0 MB / 162.3 MB
 3. [✓] org.freedesktop.Platform.GL.default  23.08-extra i  flathub  17.9 MB / 162.3 MB
 4. [✓] org.freedesktop.Platform.Locale      23.08       i  flathub  17.9 kB / 359.9 MB
 5. [✓] org.freedesktop.Platform             23.08       i  flathub 171.6 MB / 225.6 MB
 6. [✓] com.bitwarden.desktop                stable      i  flathub 132.5 MB / 133.4 MB

Installation complete.
```

To remove a Flatpak application, you can use the `uninstall` command:

```console
student@mint:~$ flatpak uninstall Bitwarden
Found installed ref ‘app/com.bitwarden.desktop/x86_64/stable’ (system). Is this correct? [Y/n]: y


        ID                                   Branch         Op
 1. [-] com.bitwarden.desktop                stable         r
 2. [-] com.bitwarden.desktop.Locale         stable         r

Uninstall complete.
```

### snap

[Snap](https://snapcraft.io) was developed by Canonical and is installed by default on Ubuntu. It is also available for other distributions (like the official Ubuntu derivatives, Solus and Zorin OS), but it is not as widely supported as Flatpak. Snap was also designed to work for cloud applications and Internet of Things devices.

In the following example, we'll install [Grafana](https://grafana.com) on an Ubuntu Server system.

```console
student@ubuntu:~$ snap search grafana
Name          Version Publisher  Notes Summary
grafana       6.7.4   canonical✓ -     feature rich metrics dashboard and graph editor        
grafana-agent 0.35.4  0x12b      -     Telemetry Agent
[...]
student@ubuntu:~$ sudo snap install grafana
grafana 6.7.4 from Canonical✓ installed
```

To uninstall a Snap application, you can use the `remove` command:

```console
student@ubuntu:~$ sudo snap remove grafana
grafana removed
```

## downloading software outside the repository

These days, the case where you need software that is not available as a binary package has become exceedingly rare. However, *if* you want to install some experimental tool that hasn't been packaged yet, or you want to test the very latest experimental version of an application, you may have to download the source code and compile it yourself. Usually, the source code is available on the project's website or on a code hosting platform like [GitHub](https://github.com), [GitLab](https://gitlab.com) or [Bitbucket](https://bitbucket.org). You then either download the source code as a `tgz`, `.tar.gz`, `.tar.bz2`, `tar.xz` file (also called a *tarball*) or you can clone the repository using `git`.

In the example below, we assume that you have downloaded the source code of an application written in C or C++, as is common for many Linux applications. Remark that in order to be able to compile the source code, you need to have the C compiler `gcc` and the build tool `make` installed on your system. You can install these using your distribution's package manager. Also, many applications depend on other libraries, which also have to be installed as source.

### example: compiling zork

As an example, we will download the source code for Zork, an ancient text based adventure game, and compile it on a Fedora system. The source code is available on [GitHub](https://github.com/devshane/zork). We have installed `git`, `gcc` and `make` beforehand.

```console
[student@fedora ~]$ git clone https://github.com/devshane/zork.git
Cloning into 'zork'...
remote: Enumerating objects: 79, done.
remote: Total 79 (delta 0), reused 0 (delta 0), pack-reused 79
Receiving objects: 100% (79/79), 241.70 KiB | 2.14 MiB/s, done.
Resolving deltas: 100% (20/20), done.
[student@fedora ~]$ cd zork/
[student@fedora zork]$ ls
actors.c  demons.c  dmain.c  dso3.c  dso6.c  dtextc.dat  dverb2.c  history   Makefile  np2.c  nrooms.c  README.md   sobjs.c   vars.h
ballop.c  dgame.c   dso1.c   dso4.c  dso7.c  dungeon.6   funcs.h   lightp.c  nobjs.c   np3.c  objcts.c  readme.txt  supp.c    verbs.c
clockr.c  dinit.c   dso2.c   dso5.c  dsub.c  dverb1.c    gdt.c     local.c   np1.c     np.c   parse.h   rooms.c     sverbs.c  villns.c
[student@fedora ~]$ make
cc -g    -c -o actors.o actors.c
cc -g    -c -o ballop.o ballop.c
cc -g    -c -o clockr.o clockr.c
[...etc...]
cc -g  -o zork actors.o ballop.o clockr.o demons.o dgame.o dinit.o dmain.o dso1.o dso2.o dso3.o dso4.o dso5.o dso6.o dso7.o dsub.o dverb1.o dverb2.o gdt.o lightp.o local.o nobjs.o np.o np1.o np2.o np3.o nrooms.o objcts.o rooms.o sobjs.o supp.o sverbs.o verbs.o villns.o -ltermcap
/usr/bin/ld: cannot find -ltermcap: No such file or directory
collect2: error: ld returned 1 exit status
make: *** [Makefile:69: dungeon] Error 1
```

As you can see, the `make` command fails because it cannot find the `termcap` library. This is a library that is used to control the terminal, and it is not installed on our system. This is a common problem when you try to install packages from source. You need to install these dependencies yourself and these are not always easy to find. In this case, we can install the `ncurses-devel` library, which is a modern replacement for `termcap`. How did we now that? We used `dnf provides` to find library files that contain the string `termcap` (remark that the command took a long time to finish):

```console
[student@fedora zork]$ dnf provides '*libtermcap.so*'
Last metadata expiration check: 1:56:05 ago on Mon 26 Feb 2024 05:46:43 PM UTC.
ncurses-devel-6.4-7.20230520.fc39.i686 : Development files for the ncurses library
Repo        : fedora
Matched from:
Other       : *libtermcap.so*
[student@fedora ~]$ sudo dnf install ncurses-devel
[...etc...]
```

Let's try to compile again:

```console
[student@fedora zork]$ make
cc -g    -c -o actors.o actors.c
cc -g    -c -o ballop.o ballop.c
[...etc...]
cc -g    -c -o villns.o villns.c
cc -g  -o zork actors.o ballop.o clockr.o demons.o dgame.o dinit.o dmain.o dso1.o dso2.o dso3.o dso4.o dso5.o dso6.o dso7.o dsub.o dverb1.o dverb2.o gdt.o lightp.o local.o nobjs.o np.o np1.o np2.o np3.o nrooms.o objcts.o rooms.o sobjs.o supp.o sverbs.o verbs.o villns.o -ltermcap
[student@fedora zork]$
```

The command seems to have succeeded. The current directory now contains a new file called `zork`. This is the compiled application and it has execute permissions. You can run it by typing `./zork`:

```console
[student@fedora zork]$ ls -l zork
-rwxr-xr-x. 1 vagrant vagrant 400968 Feb 26 19:45 zork
[student@fedora zork]$ file zork
zork: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=3089e3cb1c1a7fc1cc1db41c3aa578c0b52f83f3, for GNU/Linux 3.2.0, with debug_info, not stripped
[student@fedora zork]$ ./zork
Welcome to Dungeon.                     This version created 11-MAR-91.
You are in an open field west of a big white house with a boarded
front door.
There is a small mailbox here.
>
```

In this case, installing the game is as simple as copying the `zork` file to a directory in your `PATH`, like `/usr/local/bin` or (for a computer game) `/usr/local/games`. However, most Makefiles provide a way to install the application in the system, usually by running `make install`. This will copy the executable, manual pages and other documentation to the correct location.

```console
[student@fedora zork]$ sudo make install
mkdir -p /usr/games  /usr/share/man/man6
cp zork /usr/games
cp dtextc.dat /usr/games/lib
cp dungeon.6 /usr/share/man/man6/
```

Remark that the "official" location where manually installed applications belong in a Linux directory structure is `/usr/local` (for applications that follow the Filesystem Hierarchy Standard) or `/opt` (for applications that want to keep all files in a single directory).

### installing from a tarball

Before unpacking a tarball, it's useful to check its contents:

```console
student@linux:~$ tar tf $downloadedFile.tgz
```

The `t` option lists the content of the archive, `f` should be followed by the filename of the tarball. For `.tgz`, you may add option `z` and for `.tar.bz2` option `j`. However, the `tar` command should recognize the compression method automatically.

Check whether the package archive unpacks in a subdirectory (which is the preferred case) or in the current directory and create a subdirectory yourself if necessary. After that, you can unpack the tarball:

```console
student@linux:~$ tar xf $downloadedFile.tgz
```

Now, be sure to read the README file carefully! Normally the readme will explain what to do after download.

Usually the steps are always the same three:

1. running a script `./configure`. It will gather information about your system that is needed to compile the software so that it can actually run on your system
2. executing the command `make` (which is the actual compiling)
3. finally, executing `make install` to copy the files to their proper location.

