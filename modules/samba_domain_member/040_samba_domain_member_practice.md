## practice : samba domain member

1\. Verify that you have a working Active Directory (AD) domain.

2\. Add the domain name and domain controller to /etc/hosts. Set the
AD-DNS in /etc/resolv.conf.

3\. Setup Samba as a member server in the domain.

4\. Verify the creation of a computer account in AD for your Samba
server.

5\. Verify the automatic creation of AD users in /etc/passwd with wbinfo
and getent.

6\. Connect to Samba shares with AD users, and verify ownership of their
files.
