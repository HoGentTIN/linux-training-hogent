## solutions: package management on debian

1. On your Debian system, install updates for all available packages. Is there any difference with the Enterprise Linux way of doing this?

    ```console
    $ sudo apt update
    $ sudo apt upgrade
    ```

    You need two commands on Debian, only one on EL. `apt update` refreshes the list of available packages, `apt upgrade` installs the updates. On EL, `dnf update` and `dnf upgrade` are synonyms and do both.

2. Do you always have to reboot your system after installing updates (like you usually have to do on Windows)? When do you have to reboot after updating?

    On Linux, a reboot is usually only necessary when a new kernel update has been installed. This is because the kernel is loaded into memory at boot time and cannot be replaced while the system is running. Other updates can usually be applied without rebooting.

3. Check whether the applications/commands `git`, `scp`, `gcc` and `zork` are installed.

    You can check whether a package is installed with `dpkg -l`

    ```console
    student@debian:~$ dpkg -l | grep git
    student@debian:~$ dpkg -l | grep scp
    student@debian:~$ dpkg -l | grep gcc
    student@debian:~$ dpkg -l | grep zork
    ```

    Remark that a package name is not necessarily the same as the name of the command. For example, the `scp` command may exist while no package called `scp` was found.

    ```console
    student@ubuntu:~$ dpkg -l  |grep scp
    student@ubuntu:~$ which scp
    /usr/bin/scp
    ```

    So, let's find the package that provides the `scp` command:

    ```console
    student@ubuntu:~$ dpkg -S /usr/bin/scp
    openssh-client: /usr/bin/scp
    ```

4. Use the package manager to install them. Did you find them all? Did the installation include any dependencies?

    ```console
    $ sudo apt install git
    $ sudo apt install openssh-client
    $ sudo apt install gcc
    ```

    `gcc` is part of the Gnu Compiler Collection and may include many other packages installed as dependencies.

    `scp` should be installed as part of the `openssh-client` package.

    The `zork` package is not available in the default repositories. You can search for it on the internet and download it from a website, or you can install it from a package file if you have one.

5. Search the internet for `webmin` and figure out how to install it.

    A web search should point you to [webmin.com](https://webmin.com/). The [download page](https://webmin.com/download/) helps you to download a repository file so you can install webmin with your package manager. The latest Webmin distribution is available in various package formats for download, a.o. .rpm, .deb, etc.

