## practice: read only file server

1\. Create a directory in a good location (FHS) to share files for
everyone to read.

2\. Make sure the directory is owned properly and is world accessible.

3\. Put a textfile in this directory.

4\. Share the directory with Samba.

5\. Verify from your own and from another computer (smbclient, net use,
\...) that the share is accessible for reading.

6\. Make a backup copy of your smb.conf, name it
smb.conf.ReadOnlyFileServer.

