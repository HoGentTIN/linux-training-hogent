## practice: network configuration

The best way to learn this material is by setting up a multi-VM lab environment and practicing the commands. We suggest to use Vagrant to create several VMs that are all connected to a host-only or internal network. With the instructions below, you will create an Ubuntu and a Fedora VM, each with an internal network interface. These won't be configured out-of-the-box, so the goal of exercises below is to allow both VMs to communicate with each other by configuring the network interfaces.

### lab setup

To set up the lab environment, follow these steps:

1. Ensure Vagrant and VirtualBox (and, optionally, Git) are installed on your system.
2. Download the code of Github repository [bertvv/vagrant-shell-skeleton](https://github.com/bertvv/vagrant-shell-skeleton) (as a .zip or by cloning the repository). Give the directory a name that reflects the purpose of the lab environment, e.g. `network-config-lab`.
3. Edit the file `vagrant-hosts.yml` and add the following content:

    ```yaml
    ---
    - name: ubuntu
      box: bento/ubuntu-22.04 # Or a more recent LTS version if available
      intnet: true
      auto_config: false
    - name: fedora
      box: bento/fedora-latest
      intnet: true
      auto_config: false
    ```

    The existing entry can be removed or commented out. Check the changes with `vagrant status`.

    ```console
    > vagrant status
    Current machine states:

    fedora              not created (virtualbox)
    ubuntu              not created (virtualbox)
    ```

4. Start the VMs with `vagrant up`. This will create two VMs, `ubuntu` and `fedora`, each with an unconfigured `intnet` network interface. You can log in to the VMs with `vagrant ssh ubuntu` and `vagrant ssh fedora`.

### exercises

1. Log in to each VM and look up the following information:

    - MAC addresses of each network interface

    - IPv4 and IPv6 addresses and network masks of each network interface

    - The public IP address of your VMs, lab environment or home network

    - The routing table and default gateway

    - The DNS server(s)

    - ARP address cache

2. Use the results with the information about the lab setup to draw a network diagram and fill out an IP address table that states for each host and network interface the MAC address, IPv4/6 addresses, network masks, and default gateway.

    For now, leave open the values for interfaces that aren't configured yet, but complete the table as you progress through the exercises.

    Never underestimate the value of a good network diagram and an overview table to understand and troubleshoot network issues!

3. Assign a static IP address to the `eth1` interface of each VM. Use the following addresses:

    - Ubuntu: 192.168.100.1/24, fd00:1337:cafe:1::1/64
    - Fedora: 192.168.100.2/24, fd00:1337:cafe:1::2/64

4. Check if the VMs can ping each other. If not, troubleshoot the issue and fix it.

5. Check the ARP cache on each VM. Is there a difference with the previous time you did this?