## solution: getting started with samba

1. Take a backup copy of the original smb.conf, name it smb.conf.orig

    cd /etc/samba ; cp smb.conf smb.conf.orig

2. Enable SWAT and take a look at it.

    on Debian/Ubuntu: vi /etc/inetd.conf (remove # before swat)

    on RHEL/Fedora: vi /etc/xinetd.d/swat (set disable to no)

3. Stop the Samba server.

    /etc/init.d/smb stop (Red Hat)

    /etc/init.d/samba stop (Debian)

4. Create a minimalistic smb.conf.minimal and test it with testparm.

    cd /etc/samba ; mkdir my_smb_confs ; cd my_smb_confs

    vi smb.conf.minimal

    testparm smb.conf.minimal

5. Use tesparm -s to create /etc/samba/smb.conf from your
smb.conf.minimal .

    testparm -s smb.conf.minimal > ../smb.conf

6. Start Samba with your minimal smb.conf.

    /etc/init.d/smb restart (Red Hat)

    /etc/init.d/samba restart (Debian)

7. Verify with smbclient that your Samba server works.

    smbclient -NL 127.0.0.1

8. Verify that another computer can see your Samba server.

    smbclient -NL 'ip-address' (on a Linux)

9. Browse the network with net view, smbtree and with Windows Explorer.

    on Linux: smbtree

    on Windows: net view (and WindowsKey + e)

10. Change the \"Server String\" parameter in smb.conf. How long does
it take before you see the change (net view, smbclient, My Network
Places,...) ?

    vi /etc/samba/smb.conf

    (should take only seconds when restarting samba)

11. Will restarting Samba after a change to smb.conf speed up the
change ?

    yes

12. Which computer is the master browser master in your workgroup ?
What is the master browser ?

    The computer that won the elections.

    This machine will make the list of computers in the network

13. If time permits (or if you are waiting for other students to finish
this practice), then install a sniffer (wireshark) and watch the browser
elections.

    On ubuntu: sudo aptitude install wireshark

    then: sudo wireshark, select interface

