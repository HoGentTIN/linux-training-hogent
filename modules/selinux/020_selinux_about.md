Security Enhanced Linux or `SELinux` is a set of
modifications developed by the United States National Security Agency
(NSA) to provide a variety of security policies for Linux. SELinux was
released as open source at the end of 2000. Since kernel version 2.6 it
is an integrated part of Linux.

SELinux offers security! SELinux can control what kind of access users
have to files and processes. Even when a file received `chmod 777`,
SELinux can still prevent applications from accessing it (Unix file
permissions are checked first!). SELinux does this by placing users in
`roles` that represent a security context. Administrators have very
strict control on access permissions granted to roles.

SELinux is present in the latest versions of Red Hat Enterprise Linux,
Debian, CentOS, Fedora, and many other distributions..

