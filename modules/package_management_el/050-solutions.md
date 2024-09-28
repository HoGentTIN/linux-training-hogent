## solutions: package management on enterprise linux

1. On your Enterprise Linux system, install updates for all available packages. Is there any difference with the Debian way of doing this?

    ```console
    $ sudo dnf upgrade
    ```

    > On EL, you only need one command, on Debian two (`apt update` and `apt upgrade`).

2. Do you always have to reboot your system after installing updates (like you usually have to do on Windows)? When do you have to reboot after updating?

    > On Linux, a reboot is usually only necessary when a new kernel update has been installed. This is because the kernel is loaded into memory at boot time and cannot be replaced while the system is running. Other updates can usually be applied without rebooting.

3. Check whether the applications/commands `git`, `scp`, `gcc` and `zork` are installed.

    > You can check whether a package is installed with `rpm -q`:

    ```console
    [student@fedora ~]$ rpm -q scp
    package scp is not installed
    [student@fedora ~]$ rpm -q git
    package git is not installed
    [student@fedora ~]$ rpm -q gcc
    package gcc is not installed
    [student@fedora ~]$ rpm -q zork
    package zork is not installed
    ```

    > Can we install them?

    ```console
    [student@fedora ~]$ dnf list available | grep '^git\.'
    git.x86_64        2.46.1-1.fc39      updates
    [student@fedora ~]$ dnf list available | grep '^scp\.'
    [student@fedora ~]$ dnf list available | grep '^zork\.'
    zork.x86_64       1.0.3-6.fc39       fedora
    [student@fedora ~]$ dnf list available | grep '^gcc\.'
    gcc.x86_64        13.3.1-3.fc39      updates
    ```

    > We can install `git`, `zork`, and `gcc`, but not `scp`. Is there a package that provides the `scp` command?

    ```console
    [student@fedora ~]$ dnf provides *bin/scp
    ...
    openssh-clients-9.3p1-9.fc39.x86_64 : An open source SSH client applications
    Repo        : fedora
    Matched from:
    Other       : *bin/scp
    ...
    ```

    > The `openssh-clients` package provides the `scp` command.

4. Use the package manager to install them. Did you find them all? Did the installation include any dependencies?

    ```console
    [student@fedora ~]$ sudo dnf install git openssh-clients gcc zork
    ```

    > `gcc` is part of the Gnu Compiler Collection and may include many other packages installed as dependencies.
    > `scp` should be installed as part of the `openssh-clients` package.
    > The `zork` package is available in the default repositories on Fedora (but not on Debian/Ubuntu!).

5. Search the internet for `webmin` and figure out how to install it.

    A web search should point you to [webmin.com](https://webmin.com/). The [download page](https://webmin.com/download/) helps you to download a repository file so you can install webmin with your package manager. The latest Webmin distribution is available in various package formats for download, a.o. .rpm, .deb, etc.

