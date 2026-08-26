## practice: systemd

You can repeat these exercises on different Linux distributions, e.g. Debian, Ubuntu, AlmaLinux, Fedora, Gentoo, Arch, etc. The commands should be the same, but the service names may differ and the behaviour of the system may be different.

1. Determine on which target you are at the moment

2. List all systemctl units with type of service. Do the same for units with type of socket. In which man page can you find information about this type of unit?What does this type of unit do? What other types of units are there?

3. Check the status of the cron service.

4. Disable the cron service

5. Install apache, and check the status. If necessary, enable and start the service (with a single command). Now install nginx. Check the status of both services right after installation. Try this both on a Debian based and a RedHat based system and observe the difference in behaviour. Can you start both services at the same time? Check the status. Disable and stop Apache, then enable and start nginx, using a minimum of commands.


