# solution: package management

1\. Verify whether gcc, sudo and wesnoth are installed.

    On Red Hat/CentOS:
    rpm -qa | grep gcc
    rpm -qa | grep sudo
    rpm -qa | grep wesnoth

    On Debian/Ubuntu:
    dpkg -l | grep gcc
    dpkg -l | grep sudo
    dpkg -l | grep wesnoth

2\. Use yum or aptitude to search for and install the scp, tmux, and
man-pages packages. Did you find them all ?

    On Red Hat/CentOS:
    yum search scp
    yum search tmux
    yum search man-pages

    On Debian/Ubuntu:
    aptitude search scp
    aptitude search tmux
    aptitude search man-pages

3\. Search the internet for \'webmin\' and figure out how to install it.

    Google should point you to webmin.com.

    There are several formats available there choose .rpm, .deb or .tgz .

4\. If time permits, search for and install samba including the samba
docs pdf files (thousands of pages in two pdf\'s).
