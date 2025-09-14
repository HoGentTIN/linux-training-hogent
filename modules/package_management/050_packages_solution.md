## solution: package management

1. Look up where your Linux distribution has published their package repositories. What is the URL? Can you find and download individual packages from there?

    > For Ubuntu, you can start by going to <http://archive.ubuntu.com/ubuntu/>. Information about which packages are available can be found in the `dists` directory. For example, the release Noble Nombat (24.04 LTS) has several subdirectories called `noble`, `noble-backports`, `noble-proposed`, and `noble-security`. The `pool` directory contains the actual `.deb` files.

    > For Fedora, you can go to <https://mirrormanager.fedoraproject.org> and look for a mirror for the Fedora release you are using and the architecture of your machine (typically `x86_64`). An example of such a repository mirror is <https://fedora.cu.be/linux/releases/> (in Belgium). You can then navigate to the subdirectory of your release (e.g. 40), and then to the `Everything` directory, `x86_64`, `os`, and `Packages` to find the RPM packages (sorted in subdirectories `a` to `z` according to the first letter of the package name).

2. Open the graphical package manager tool on your system. What kind of software is available? Can you find the software you need? Or games that you would like to play?

    > On Ubuntu, you can use the *Software Center*. On Fedora, you can use the *Software* application. Both tools provide a graphical interface to search for and install software, just like you would on the Appstore, Google Play store, Windows store, etc. In fact, graphical package managers on Linux predate these stores by many years.

    > You may not necessarily find commercial applications, but usually open source alternatives exist.

    > Installing games is also possible, but the selection is not as large as on Steam. However, you can install Steam on Linux and play many games that are available on that platform.

3. Why would it be a bad idea to install Python packages with `pip` as root? When would you install a package (e.g. `pandas`) with `pip` instead of the package manager (e.g. `python3-pandas`)?

    > Installing Python packages with `pip` as root could interfere with the Python packages installed with the system package manager. Generally, if you need Python packages to be available system-wide, use the system package manager.

    > If you only need the package for a specific user or a specific Python virtual environment, you can use `pip`. This is especially useful if the package is not available in the system package manager, or if you need a specific version of the package that is not available in the system package manager.

4. Check whether Snap or Flatpak is installed or available on your system. How can you search online for applications in these repositories?

    > On Ubuntu, Snap is installed by default. You can search for applications in the Snap store by going to <https://snapcraft.io/store>. You can also use the `snap find` command to search for applications from the command line.

    > On most other distributions, Flatpak is the default (if it is installed). You can search for applications in the Flathub repository by going to <https://flathub.org/>. You can also use the `flatpak search` command to search for applications from the command line.

    > Remark that installing Snap is usually also possible on distributions that default to Flatpak.

