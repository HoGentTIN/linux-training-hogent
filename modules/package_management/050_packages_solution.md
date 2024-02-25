## solution: package management

1. Verify whether gcc, sudo and zork are installed.

    On Enterprise Linux:

        rpm -qa | grep gcc
        rpm -qa | grep sudo
        rpm -qa | grep zork

    On Debian/Ubuntu:

        dpkg -l | grep gcc
        dpkg -l | grep sudo
        dpkg -l | grep zork

2. Use dnf or apt to search for and install the `scp`, `tmux`, and
`man-pages` packages. Did you find them all ?

    On Red Hat/CentOS:

        dnf search scp
        dnf search tmux
        dnf search man-pages

    On Debian/Ubuntu:

        apt search scp
        apt search tmux
        apt search man-pages

3. Search the internet for 'webmin' and figure out how to install it.

    Google should point you to [webmin.com](https://webmin.com/). The [download page](https://webmin.com/download/) helps you to download a repository file so you can install webmin with your package manager. The latest Webmin distribution is available in various package formats for download, a.o. .rpm, .deb, etc.

4. If time permits, search for and install samba including the samba
docs pdf files (thousands of pages in two pdf\'s).

