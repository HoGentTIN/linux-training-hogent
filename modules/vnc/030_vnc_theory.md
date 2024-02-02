## About VNC

VNC can be configured in gnome or KDE using the
`Remote Desktop Preferences`. `VNC` can be
used to run your desktop on another computer, and you can also use it to
see and take over the Desktop of another user. The last part can be
useful for help desks to show users how to do things. VNC has the added
advantage of being operating system independent, a lot of products
(realvnc, tightvnc, xvnc, \...) use the same protocol on Solaris, Linux,
BSD and more.

## VNC Server

Starting the vnc server for the first time.

    [root@RHELv8u3 conf]# rpm -qa | grep -i vnc
    vnc-server-4.0-8.1
    vnc-4.0-8.1
    [root@RHELv8u3 conf]# vncserver :2
                    
    You will require a password to access your desktops.
                    
    Password: 
    Verify: 
    xauth:  creating new authority file /root/.Xauthority
                    
    New 'RHELv8u3.localdomain:2 (root)' desktop is RHELv8u3.localdomain:2
                    
    Creating default startup script /root/.vnc/xstartup
    Starting applications specified in /root/.vnc/xstartup
    Log file is /root/.vnc/RHELv8u3.localdomain:2.log
                    
    [root@RHELv8u3 conf]# 
            

## VNC Client

You can now use the `vncviewer` from another machine to
connect to your vnc server. It will default to a very simple graphical
interface\...

    paul@laika:~$ vncviewer 192.168.1.49:2
    VNC viewer version 3.3.7 - built Nov 20 2006 13:05:04
    Copyright (C) 2002-2003 RealVNC Ltd.
    Copyright (C) 1994-2000 AT&T Laboratories Cambridge.
    See http://www.realvnc.com for information on VNC.
    VNC server supports protocol version 3.8 (viewer 3.3)
    Password: 
    VNC authentication succeeded
    Desktop name "RHELv8u3.localdomain:2 (root)"
    Connected to VNC server, using protocol version 3.3
    ...
            

If you don\'t like the simple twm window manager, you can comment out
the last two lines of `~/.vnc/xstartup` and add a
`gnome-session &` line to have vnc default to gnome
instead.

    [root@RHELv8u3 ~]# cat .vnc/xstartup 
    #!/bin/sh
                    
    # Uncomment the following two lines for normal desktop:
    # unset SESSION_MANAGER
    # exec /etc/X11/xinit/xinitrc
                    
    [ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
    [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
    xsetroot -solid grey
    vncconfig -iconic &
    # xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
    # twm &
    gnome-session &
    [root@RHELv8u3 ~]#
            

Don\'t forget to restart your vnc server after changing this file.

    [root@RHELv8u3 ~]# vncserver -kill :2
    Killing Xvnc process ID 5785
    [root@RHELv8u3 ~]# vncserver :2
            
    New 'RHELv8u3.localdomain:2 (root)' desktop is RHELv8u3.localdomain:2
                    
    Starting applications specified in /root/.vnc/xstartup
    Log file is /root/.vnc/RHELv8u3.localdomain:2.log
            

## Practice VNC

1\. Use VNC to connect from one machine to another.
