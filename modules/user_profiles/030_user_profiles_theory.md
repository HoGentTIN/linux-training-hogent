## system profile

Both the `bash` and the `ksh` shell will
verify the existence of `/etc/profile` and `source` it if
it exists.

When reading this script, you will notice (both on Debian and on Red Hat
Enterprise Linux) that it builds the PATH environment variable (among
others). The script might also change the PS1 variable, set the HOSTNAME
and execute even more scripts like `/etc/inputrc`

This screenshot uses grep to show PATH manipulation in `/etc/profile` on
Debian.

    root@debian10:~# grep PATH /etc/profile
      PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
    export PATH
    root@debian10:~#

This screenshot uses grep to show PATH manipulation in `/etc/profile` on
RHEL7/CentOS7.

    [root@centos7 ~]# grep PATH /etc/profile
        case ":${PATH}:" in
                    PATH=$PATH:$1
                    PATH=$1:$PATH
    export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL
    [root@centos7 ~]#

The `root user` can use this script to set aliases, functions, and
variables for every user on the system.

## \~/.bash_profile

When this file exists in the home directory, then `bash` will source it.
On Debian Linux 5/6/7 this file does not exist by default.

RHEL7/CentOS7 uses a small `~/.bash_profile` where it
checks for the existence of `~/.bashrc` and then sources
it. It also adds \$HOME/bin to the \$PATH variable.

    [root@rhel7 ~]# cat /home/paul/.bash_profile
    # .bash_profile

    # Get the aliases and functions
    if [ -f ~/.bashrc ]; then
            . ~/.bashrc
    fi

    # User specific environment and startup programs

    PATH=$PATH:$HOME/.local/bin:$HOME/bin

    export PATH
    [root@rhel7 ~]#

## \~/.bash_login

When `.bash_profile` does not exist, then `bash` will check for
`~/.bash_login` and source it.

Neither Debian nor Red Hat have this file by default.

## \~/.profile

When neither `~/.bash_profile` and `~/.bash_login` exist, then bash will
verify the existence of `~/.profile` and execute it. This file does not
exist by default on Red Hat.

On Debian this script can execute `~/.bashrc` and will add
\$HOME/bin to the \$PATH variable.

    root@debian10:~# tail -11 /home/paul/.profile
    if [ -n "$BASH_VERSION" ]; then
        # include .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
            . "$HOME/.bashrc"
        fi
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ] ; then
        PATH="$HOME/bin:$PATH"
    fi

RHEL/CentOS does not have this file by default.

## \~/.bashrc

The `~/.bashrc` script is often sourced by other scripts. Let us take a
look at what it does by default.

Red Hat uses a very simple `~/.bashrc`, checking for
`/etc/bashrc` and sourcing it. It also leaves room for
custom aliases and functions.

    [root@rhel7 ~]# cat /home/paul/.bashrc
    # .bashrc

    # Source global definitions
    if [ -f /etc/bashrc ]; then
            . /etc/bashrc
    fi

    # Uncomment the following line if you don't like systemctl's auto-paging feature:
    # export SYSTEMD_PAGER=

    # User specific aliases and functions

On Debian this script is quite a bit longer and configures \$PS1, some
history variables and a number af active and inactive aliases.

    root@debian10:~# wc -l /home/paul/.bashrc
    110 /home/paul/.bashrc

## \~/.bash_logout

When exiting `bash`, it can execute `~/.bash_logout`.

Debian use this opportunity to clear the console screen.

    serena@deb106:~$ cat .bash_logout
    # ~/.bash_logout: executed by bash(1) when login shell exits.

    # when leaving the console clear the screen to increase privacy

    if [ "$SHLVL" = 1 ]; then
        [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
    fi

Red Hat Enterprise Linux 5 will simple call the `/usr/bin/clear` command
in this script.

    [serena@rhel53 ~]$ cat .bash_logout 
    # ~/.bash_logout

    /usr/bin/clear

Red Hat Enterprise Linux 6 and 7 create this file, but leave it empty
(except for a comment).

    paul@rhel65:~$ cat .bash_logout
    # ~/.bash_logout

## Debian overview

Below is a table overview of when Debian is running any of these bash
startup scripts.

  ----------------------------------------------
  script               su    su -   ssh    gdm
  ------------------ ------ ------ ------ ------
  \~./bashrc           no    yes    yes    yes

  \~/.profile          no    yes    yes    yes

  /etc/profile         no    yes    yes    yes

  /etc/bash.bashrc    yes     no     no    yes
  ----------------------------------------------

  : Debian User Environment

## RHEL5 overview

Below is a table overview of when Red Hat Enterprise Linux 5 is running
any of these bash startup scripts.

  ----------------------------------------------
  script               su    su -   ssh    gdm
  ------------------ ------ ------ ------ ------
  \~./bashrc          yes    yes    yes    yes

  \~/.bash_profile     no    yes    yes    yes

  /etc/profile         no    yes    yes    yes

  /etc/bashrc         yes    yes    yes    yes
  ----------------------------------------------

  : Red Hat User Environment

