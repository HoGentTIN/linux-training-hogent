## solution: securing shares

1\. Create a writable share called sales, and a readonly share called
budget. Test that it works.

    see previous solutions on how to do this...

2\. Limit access to the sales share to ann, sandra and veronique.

    valid users = ann, sandra, veronique

3\. Make sure that roberto cannot access the sales share.

    invalid users = roberto

4\. Even though the sales share is writable, ann should only have read
access.

    read list = ann

5\. Even though the budget share is read only, sandra should also have
write access.

    write list = sandra

6\. Limit one shared directory to the 192.168.1.0/24 subnet, and another
share to the two computers with ip-addresses 192.168.1.33 and
172.17.18.19.

    hosts allow = 192.168.1.

    hosts allow = 192.168.1.33, 172.17.18.19

7\. Make sure the computer with ip 192.168.1.203 cannot access the
budget share.

    hosts deny = 192.168.1.203

8\. Make sure (on the budget share) that users can see only files and
directories to which they have access.

    hide unreadable = yes

9\. Make sure the sales share is not visible when browsing the network.

    browsable = no

10\. All files created in the sales share should have 640 permissions or
less.

    create mask = 640

11\. All directories created in the budget share should have 750
permissions or more.

    force directory mode = 750

12\. Permissions for files on the sales share should never be set more
than 664.

    security mask = 750

13\. Permissions for files on the budget share should never be set less
than 500.

    force security directory mask = 500

14\. If time permits (or if you are waiting for other students to finish
this practice), then combine the \"read only\" and \"writable\"
statements to check which one has priority.

15\. If time permits then combine \"read list\", \"write list\", \"hosts
allow\" and \"hosts deny\". Which of these has priority ?

