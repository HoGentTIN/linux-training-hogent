After loading the Linux kernel into memory and starting the `init` process, the system will start all the necessary background processes (also known as daemons) to make the system usable. These processes are started in a specific order, and they are responsible for starting other processes that are required for the system to function properly.

Many Unix and Linux distributions have been using init scripts to start daemons in the same way that *Unix System V* did back in 1983. Starting 2015 this is considered legacy. Most Linux distributions, including Debian and Red Hat, have migrated to a new system called `systemd`. This is not without controversy, as `systemd` is a complete replacement for the init system and has been criticized among others for being too complex and broad in scope.

As is often the case in the open source community in this kind of situation, there are alternatives to `systemd` such as `runit`, `OpenRC`, and `s6`. However, these alternatives are not widely used in mainstream Linux distributions.

This chapter explains how to manage Linux with `systemd`.

