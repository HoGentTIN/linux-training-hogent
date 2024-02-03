Many Unix and Linux distributions use `init` scripts to start daemons in
the same way that `Unix System V` did. This chapter will
explain in detail how that works.

Init starts daemons by using scripts, where each script starts one
daemon, and where each script waits for the previous script to finish.
This serial process of starting daemons is slow, and although slow
booting is not a problem on servers where uptime is measured in years,
the recent uptake of Linux on the desktop results in user complaints.

To improve Linux startup speed, `Canonical` has developed
`upstart`, which was first used in Ubuntu. Solaris also
used `init` up to Solaris 9, for Solaris 10 `Sun`
developed `Service Management Facility`. Both systems
start daemons in parallel and can replace the SysV init scripts. There
is also an ongoing effort to create `initng` (init next
generation).

In 2014 the `systemd` initiative has taken a lead when after Fedora,
RHEL7 and CentOS8 also Debian has chosen this to be the prefered
replacement for init. The end of this module contains an introduction to
`systemd`.

