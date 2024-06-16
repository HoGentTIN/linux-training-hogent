## a bottom-up approach to troubleshooting

As you know by the time you reach this chapter, the Internet is designed as a layered system. The [OSI model](https://nl.wikipedia.org/wiki/OSI-model) is often used to explain how networking works, but for our purposes, the four layer TCP/IP model is more practical and sufficient.

For reference, here is a summary of the TCP/IP model:

| Layer       | Protocols                 | Keywords              |
| :---------- | :------------------------ | :-------------------- |
| Application | HTTP, DNS, DHCP, FTP, ... |                       |
| Transport   | TCP, UDP                  | sockets, port numbers |
| Internet    | IP, ICMP                  | routing, IP address   |
| Link        | Ethernet, ARP             | switch, MAC address   |
| (Physical)  |                           | cables, RF signals    |

The physical layer at the bottom is not really part of the TCP/IP family of protocols and is out of scope for this chapter.

In order to troubleshoot effectively, it is essential to understand that interventions on the higher layers will not solve issues if problems on the lower layers aren't fixed first. This is why you should **always use a bottom-up approach to troubleshooting**. That is, start at the bottom layer of the stack, check *everything* on that layer before moving up to the next layer.

In the following sections, we'll show what to check on each layer and which commands to use. We'll also provide some general guidelines for troubleshooting network services.

It is always a good idea to open a separate terminal window and follow the logs in real-time with `sudo journalctl -fl` or, specific to a service, `sudo journalctl -flu <service>`.

## the link layer

On this layer, check:

- Are cables connected properly?
    - On a physical device, look for blinking lights on the network interface of the system under test and the network device it is attached to. Testing the cables with a cable tester is also a good idea.
    - On a Virtual Machine, check if the network adapter is connected to the right network.
- Are the network interfaces up?

TODO: examples of `ip link` and what to check

## the internet layer

On this layer, check:

- Local network configuration of the system under test:
    - IP address and subnet mask
    - Default gateway
    - DNS servers
- Routing within the LAN:
    - Can you ping the default gateway and DNS servers?
    - Can you ping another system on the same network?
    - Does the DNS server respond to queries?

It is important to know the expected values for these settings. For example, you may see that a system does have an IP address, say, 169.254.152.12, but no internet access. If you don't know that this particular address range is used for providing a host with an IP address when no DHCP server is available, you might spend a lot of time troubleshooting the wrong issue.

### checking the local network configuration

- IP address and subnet mask: `ip address`

    - Do you have an IP address?
        - If not, the DHCP server may be down, is unreachable from this system, or doesn't give an IP address to this system.
        - The problem may also be on the DHCP server side.
    - Is it in the correct subnet?
        - If not, check if the system has an "link-local" address, e.g. in the range 169.254.0.0/16. This is a sign that the system couldn't get an IP address from a DHCP server.
        - If the address is plain wrong, check the configuration of the network interface. Maybe you configured a static IP address when the system should get one from DHCP, or maybe you forgot to restart the network service after a config change.
    - Is the subnet mask correct? E.g. the IP is correct, but pinging another system in the LAN gives a "network unreachable" error.
        - If not, routing within the LAN may not be possible.
        - Check the configuration of the network interface.

- Default gateway: `ip route`

    - Is the default gateway present?
    - Is it the correct IP address in the expected subnet?

- DNS servers: `cat /etc/resolv.conf` or `resolvectl dns`

    - Is the `nameserver` entry present
    - Is the DNS server IP correct?

TODO: examples

### routing within the LAN

- Ping between hosts within the LAN

- Ping the default gateway

    - Remark: some system administrators deliberately disable ICMP echo requests (ping) on network devices for security purposes. If you can't ping the default gateway, it may be that the device is configured this way.

- Ping the DNS server

- Query the DNS server (with `dig` or `nslookup`)

TODO: examples

### internet connectivity

After this step, you might want to test Internet connectivity by e.g. pinging the WAN interface of the default gateway, or the IP address of the next hop (if you know it).

If the previous steps were successful, but you can't reach the Internet, the problem may be with the default gateway or the routing table on the default gateway.

This is outside the scope of this troubleshooting guide, since we're focusing on troubleshooting services we are setting up ourselves.

## the transport layer

On this layer, check:

- Is the service running?
- Is the service listening on the correct port? `sudo ss -tulpn`
- Does the firewall allow traffic to the service port? `sudo firewall-cmd --list-all`

### is the service running?

Use the command  `systemctl status <service>`. Check for `active (running)` in the output, or `inactive (dead)`. If the service is not running, you can try to start it with `sudo systemctl start <service>`. If this fails, check the logs for error messages.

Also check whether the service is `enabled`, i.e. will start automatically when the system boots. If not, enable it with `sudo systemctl enable <service>`.

TODO: examples

### is the service listening on the correct port?

Use the command `sudo ss -tulpn` (show sockets). The options have the following meaning:

- `-t`: show TCP sockets.
- `-u`: show UDP sockets (not relevant for pure TCP-based services like HTTP(S), can be omitted in that case).
- `-l`: show only listening (server) sockets.
- `-p`: show the process that owns the socket. This requires root privileges, hence the `sudo` before the command.
- `-n`: show IP addresses instead of trying to resolve them to host names and show port numbers instead of the service name (as enumerated in the file `/etc/services`).

The order of the options is not important, but for Dutch speaking people, the mnemonic "TULPeN" may help to remember the options.

You need to know which interfaces and ports the service is supposed to listen on! If the service is running, but not listening on the expected port (e.g. 8443 instead of 443 for a web server). Some services are configured to only listen on the loopback interface, which also can be determined with `ss`.

TODO: examples

## the application layer

The application layer is the most diverse, as it comprises all services that run on top of the transport layer. This includes web servers, mail servers, DNS servers, etc. Troubleshooting specific behaviour of these services is beyond the scope of this chapter, but there are a few things that you should always check, regardless of the service:

- Check the logs
- Validate the syntax of the configuration files
- Read the manual
- Use command-line client tools to test the service

All other checks are specific to the application.

### check the logs

Linux systems based on `systemd` use `journalctl` to manage system logs. You can use `journalctl` (with root privileges) to view the logs of a specific service, e.g. `sudo journalctl -u <service>`. The `-f` option will show new log entries as they are written and the `-l` option will show the full log entries (instead of truncating lines that do not fit within the width of the terminal).

Some services also write logs to a file in `/var/log`. For example, when troubleshooting a web server, you might want to check `/var/log/httpd/error_log` for messages that do not appear with `journalctl`. Check the documentation of the service to find out where the logs are stored.

Following log files in real-time can be done with the command `tail -f /var/log/<logfile>`.

### validate config file syntax

Most services have a command that checks the syntax of a configuration file before/without starting the service. It is useful to always run this command first to check for existing errors. Also, after making any change to the configuration file, run the command again to ensure you don't introduce new errors.

A few examples:

- Apache web server: `sudo apachectl configtest`
- Nginx web server: `sudo nginx -t`
- Bind DNS server: `sudo named-checkconf` and `sudo named-checkzone <zone> <zonefile>`
- Vsftpd FTP server: `sudo vsftpd -t`

Check the manual of the service for the exact command to use.

### read the manual

When you are responsible for managing a service in production, you must know the system inside out in order to be effective in your job. At a certain point, googling for solutions will no longer be sufficient. You need to know the service's configuration file, log files, and the commands to manage the service.

That's information that you won't find on Stack Overflow or Reddit, but in the manuals. Finding help is a topic that is covered in another chapter, so we won't go into detail here. A few suggestions and examples without striving to be comprehensive:

- Check the man page of the command, configuration file or service
- Check the documentation of your Linux distribution (e.g. [the RedHat Manuals](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/) or [Debian Documentation](https://www.debian.org/doc/))
- Check the reference manual of the service (e.g. [the Apache HTTP Server Documentation](https://httpd.apache.org/docs/), [the Nginx Documentation](https://nginx.org/en/docs/), [the Bind 9 Administrator Reference Manual](https://bind9.readthedocs.io/en/latest/))
- Read a (good) book about the service, e.g. [DNS for Rocket Scientists](http://zytrax.com/books/dns/)

### use command-line tools

For troubleshooting purposes, it is often more useful to use command-line client tools than the graphical user interface that you would run for daily use. GUIs often hide important details, or give only generic error messages.

The specific tools you can use depend on the service you are troubleshooting and there are a lot. Here are a few examples, again without trying to be complete:

- `curl` for web servers
- `dig` for DNS servers
- `smbclient` for Samba file servers
- `netcat` for general network troubleshooting, setting up raw TCP connections
- `nmap` for network scanning (which also includes scripts to test specific services)

## general guidelines

To conclude, here are some general guidelines that you should use when troubleshooting issues with network services:

- Before making any change, **back up** configuration files.

- Always **be systematic**, follow the bottom-up approach.

- Be **thorough**, don't skip any step. You can't solve problems higher up in the stack if issues lower down are not resolved.

- **Do not assume: test!** The fact that "it doesn't work" means that one of your assumptions is wrong.

- **Know your environment.** What is the topology? What are the IP addresses (summarize them in a table)? What services should be running? Read the documentation of the services you are responsible for.

- **Read The Fine Log Files!** You need to be able to interpret the log files of the services you are troubleshooting. Keep a real time log viewer open in a separate terminal window, study the effect that interventions on a system have in the logs.

- **Read The Fine Error Message!** Error messages are essential to understand what is going wrong, and on which layer in the TCP/IP stack the issue is located.

- Work in **small steps**. Make one change at a time, and immediately test the effect of that change.

- If possible, **validate config file syntax** after each change and before restarting a service.

- Don't forget to **restart the service** after making changes to their configuration files.

- **Verify each change** so you don't introduce new issues.

- Keep a **cheat sheet** or **troubleshooting checklist** with all the steps to follow and commands you need. For an example, see <https://github.com/bertvv/cheat-sheets>

- **Automate** to avoid human error. Use a configuration management system to describe the desired state of the infrastructure under your control. Automate tests as well, or implement a monitoring and log aggregation solution.

- Finally, **don't ping Google** as your first troubleshooting step. If it doesn't work (and it probably wont, or you wouldn't need to troubleshoot), too many things could have gone wrong. Go back to the beginning of this list and start there... ;-)

