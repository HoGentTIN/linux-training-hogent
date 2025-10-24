Security Enhanced Linux or **SELinux** is a set of modifications to the Linux kernel developed by the United States National Security Agency (NSA) to provide a variety of security policies. SELinux was released as open source at the end of 2000. Since kernel version 2.6 it is an integrated part of Linux.

SELinux offers security! Several recent and highly publicized security vulnerabilities in the Linux world (like e.g. Heartbleed) would not be able to exploit a system with SELinux enabled.

SELinux is based on the principle of *Mandatory Access control* and basically answers the question "Is *thing* allowed to perform *action* on *object*?", e.g. "is *the web server* allowed *network access* on *a remote database*?" The default answer is *no*, but you can configure SELinux *policies* to allow specific actions. Even when a file received `chmod 777`, SELinux can still prevent applications from accessing it! SELinux does this by placing users in *roles* that represent a security context.

Administrators have very strict control on access permissions granted to roles. This may sound quite daunting, since every single action that should be allowed needs to be explicitly configured. However, distributions that support SELinux already come with a set of predefined policies that cover most common use cases.

SELinux is present in many recent Linux distributions. Red Hat Enterprise Linux (and other distros within the EL family like AlmaLinux, Rocky Linux, Fedora, etc.) have SELinux installed by default. Debian has SELinux available, but it is not installed or enabled by default. For Ubuntu, Canonical has chosen AppArmor instead of SELinux for security hardening.

Since SELinux is a default part of Red Hat Enterprise Linux, we'll use that in the examples in this chapter.

Further reading:

- RHEL 9 documentation: Using SELinux: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_selinux/>
- Setting up SELinux on Debian: <https://wiki.debian.org/SELinux>
- SELinux project wiki: <https://selinuxproject.org/>

