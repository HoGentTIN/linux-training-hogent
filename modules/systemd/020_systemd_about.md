Many Unix and Linux distributions have been using `init` scripts to
start daemons in the same way that `Unix System V` did
back in 1983.

Starting 2015 this is considered legacy. Most Linux distributions,
including Debian and Red Hat/CentOS, are in the process of migrating to
`systemd`. They will however, remain somewhat compatible with `init`
mainly, due to migration process might take a while. It is also need to
be mentioned that majority of OpenSource software and applications, have
already migrated to `systemd`, especially in case of RedHat and its
derivitieves.

This chapter explains how to manage Linux with `systemd`.
