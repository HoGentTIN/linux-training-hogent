# practice: samba domain controller

1\. Setup Samba as a domain controller.

2\. Create the shares salesdata, salespresentations and meetings.
Salesdata must be accessible to all sales people and to all managers.
SalesPresentations is only for all sales people. Meetings is only
accessible to all managers. Use groups to accomplish this.

3\. Join a Microsoft computer to your domain. Verify the creation of a
computer account in /etc/passwd.

4\. Setup and verify the proper working of roaming profiles.

5\. Find information about home directories for users, set them up and
verify that users receive their home directory mapped under the H:-drive
in MS Windows Explorer.

6\. Use a couple of samba domain groups with members to set acls on
ntfs. Verify that it works!

7\. Knowing that the %m variable contains the computername, create a
separate log file for every computer(account).

8\. Knowing that %s contains the client operating system, include a
smb.%s.conf file that contains a share. (The share will only be visible
to clients with that OS).

9\. If time permits (or if you are waiting for other students to finish
this practice), then combine \"valid users\" and \"invalid users\" with
groups and usernames with \"hosts allow\" and \"hosts deny\" and make a
table of which get priority over which.
