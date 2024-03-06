## Exercises

1. Start with the scaffolding code of <https://github.com/bertvv/vagrant-shell-skeleton>.

2. Add entries to `vagrant-hosts.yml` for four VMs: `debian`, `ubuntu`, `fedora` and `alma` with the latest available base boxes from the Bento project for each distro. Assign them with an IP address in the network 192.168.56.0/24 (the default host-only network for VirtualBox).

3. Add install scripts to the `provisioning/` folder for each.

You now have a multi-VM environment to experiment with the different Linux distributions. You can use this environment to practice the commands and concepts you learn in the other chapters of this book. If the VM is broken, you can easily destroy it and recreate it from scratch! If you want to experiment with other distros, feel free to add more VMs to your environment.
