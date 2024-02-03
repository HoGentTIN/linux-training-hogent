## about keyboard layout

Many people (like US-Americans) prefer the default US-qwerty keyboard
layout. So when you are not from the USA and want a local keyboard
layout on your system, then the best practice is to select this keyboard
at installation time. Then the keyboard layout will always be correct.
Also, whenever you use ssh to remotely manage a Linux system, your local
keyboard layout will be used, independent of the server keyboard
configuration. So you will not find much information on changing
keyboard layout on the fly on linux, because not many people need it.
Below are some tips to help you.

## X Keyboard Layout

This is the relevant portion in /etc/X11/xorg.conf, first for Belgian
azerty, then for US-qwerty.

    [paul@RHEL5 ~]$ grep -i xkb /etc/X11/xorg.conf 
            Option      "XkbModel" "pc105"
            Option      "XkbLayout" "be"

    [paul@RHEL5 ~]$ grep -i xkb /etc/X11/xorg.conf
            Option      "XkbModel" "pc105"
            Option      "XkbLayout" "us"

When in Gnome or KDE or any other graphical environment, look in the
graphical menu in preferences, there will be a keyboard section to
choose your layout. Use the graphical menu instead of editing xorg.conf.

## shell keyboard layout

When in bash, take a look in the /etc/sysconfig/keyboard file. Below a
sample US-qwerty configuration, followed by a Belgian azerty
configuration.

    [paul@RHEL5 ~]$ cat /etc/sysconfig/keyboard 
    KEYBOARDTYPE="pc"
    KEYTABLE="us"
        

    [paul@RHEL5 ~]$ cat /etc/sysconfig/keyboard 
    KEYBOARDTYPE="pc"
    KEYTABLE="be-latin1"
        

The keymaps themselves can be found in /usr/share/keymaps or
/lib/kbd/keymaps.

    [paul@RHEL5 ~]$ ls -l /lib/kbd/keymaps/
    total 52
    drwxr-xr-x 2 root root 4096 Apr  1 00:14 amiga
    drwxr-xr-x 2 root root 4096 Apr  1 00:14 atari
    drwxr-xr-x 8 root root 4096 Apr  1 00:14 i386
    drwxr-xr-x 2 root root 4096 Apr  1 00:14 include
    drwxr-xr-x 4 root root 4096 Apr  1 00:14 mac
    lrwxrwxrwx 1 root root    3 Apr  1 00:14 ppc -> mac
    drwxr-xr-x 2 root root 4096 Apr  1 00:14 sun

