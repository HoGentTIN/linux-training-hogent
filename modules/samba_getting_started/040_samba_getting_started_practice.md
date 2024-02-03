## practice: getting started with samba

1\. Take a backup copy of the original smb.conf, name it smb.conf.orig

2\. Enable SWAT and take a look at it.

3\. Stop the Samba server.

4\. Create a minimalistic smb.conf.minimal and test it with testparm.

5\. Use tesparm -s to create /etc/samba/smb.conf from your
smb.conf.minimal .

6\. Start Samba with your minimal smb.conf.

7\. Verify with smbclient that your Samba server works.

8\. Verify that another (Microsoft) computer can see your Samba server.

9\. Browse the network with net view, smbtree and with Windows Explorer.

10\. Change the \"Server String\" parameter in smb.conf. How long does
it take before you see the change (net view, smbclient, My Network
Places,\...) ?

11\. Will restarting Samba after a change to smb.conf speed up the
change ?

12\. Which computer is the master browser master in your workgroup ?
What is the master browser ?

13\. If time permits (or if you are waiting for other students to finish
this practice), then install a sniffer (wireshark) and watch the browser
elections.

