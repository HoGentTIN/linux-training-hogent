## solution: BIND

The solution below is for an EL-based system, set up in a Vagrant environment. You can find [code for this setup here](https://github.com/HoGentTIN/linux-training-labs/tree/main/dns-bind).

The setup is similar on a Debian-based system.

1. Set up `srv001` (Debian or EL-based) and install BIND.

    - Discover the default configuration files. Can you define the purpose of each file?

        > See theory section

    - Turn on the query log and start `tcpdump` to capture any traffic for port 53 (inbound and outbound).

        ```console
        [vagrant@srv001 ~]$ sudo tcpdump -i any -w /vagrant/dns.pcap port 53 &
        [vagrant@srv001 ~]$ sudo rndc querylog on
        ```

        > By saving the `tcpdump` output to a file in `/vagrant`, you can open it with Wireshark on your physical system.

    - Without changing the configuration, send a simple forward A query for any domain name from the VM itself. Do you expect this to work?

        ```console
        [vagrant@srv001 ~]$ dig @127.0.0.1 www.hogent.be +short
        hogent.be.
        193.190.173.135
        [vagrant@srv001 ~]$ sudo journalctl -lu named.service | tail -2
        Oct 01 18:10:35 srv001 named[4858]: query logging is now on
        Oct 01 18:10:38 srv001 named[4858]: client @0x7f4eb06e6488 127.0.0.1#59626 (www.hogent.be): query: www.hogent.be IN A +E(0)K (127.0.0.1)
        ```

        > on `localhost`, this should work. From a different host, it will not work, because the DNS server is only configured to listen on the loopback interface.
        >
        > The logs show that the query log was indeed turned on and also has a line for the query we just made.

    - Try to determine from the logs or the `tcpdump` output whether the DNS server is configured as a *caching name server* with or without a *forwarder*.

        ```console
        [vagrant@srv001 ~]$ tcpdump -n -t -r /vagrant/dns.pcap port 53 | head
        reading from file /vagrant/dns.pcap, link-type EN10MB (Ethernet), snapshot length 262144
        IP 10.0.2.15.38603 > 170.247.170.2.domain: 40159 [1au] A? _.be. (45)
        IP 170.247.170.2.domain > 10.0.2.15.38603: 40159-| 0/8/1 (231)
        [vagrant@srv001 ~]$ sudo grep 170 /var/named/named.ca
        b.root-servers.net.     518400  IN      A       170.247.170.2
        ```

        > The first packet in the PCAP file is a query to a root name server (b.root-servers.net at 170.247.170.2) for the .be nameservers. If you look further down the file, you'll find a query to a .be nameserver for the hogent.be nameserver, etc. This means that the DNS server is not configured as a *forwarding name server*.

    - Repeat the previous query. Do you see a difference in behavior? Can you explain why?

        > The query will still work, however, it is not necessary anymore to query the root name servers and the .be nameservers, because the answer is already in the cache.

2. Ensure that the DNS server is available to all hosts on the local network. Don't forget to check firewall settings! Test whether you can resolve the domain name from another VM or a physical machine on the same network.

    > Modify the following lines in `/etc/named.conf` to listen on all interfaces:

    ```text
    // Listen on all interfaces, allow any host to query
    listen-on port 53 { any; };
    listen-on-v6 port 53 { any; };
    allow-query     { any; };
    ```

    > Also, allow DNS traffic to pass through the firewall:

    ```console
    [vagrant@srv001 ~]$ sudo systemctl enable --now firewalld
    [vagrant@srv001 ~]$ sudo firewall-cmd --add-service=dns --permanent
    [vagrant@srv001 ~]$ sudo firewall-cmd --reload
    ```

3. Add a *forwarder* and verify that it works. Try to use a public DNS server as a forwarder. Google's is well known, but there are others, too! Search for "free public dns servers" to get some suggestions.

    > Add the following lines to `/etc/named.conf`, in the `options` section:

    ```text
    // Add Cloudflare's public DNS servers as forwarders
    forwarders {
            1.1.1.1; 1.0.0.1;
    };
    ```

    - Repeat the queries from the previous step. Do you see a difference in behavior?

        > If you look at the `tcpdump` output, you will see that the DNS server forwards the query to the Cloudflare DNS servers.

4. Create a *primary forward lookup zone* named `linuxtrn.lan` with a variety of resource records, e.g. NS, MX, A, CNAME. Also add an A record for the `@` shorthand.

    > Create a zone file `/var/named/linuxtrn.lan` with the following contents:

    ```text
    ;; Zone file for linuxtrn.lan
    $ORIGIN linuxtrn.lan.
    $TTL 1W

    @ IN SOA srv001.linuxtrn.lan. hostmaster.linuxtrn.lan. (
            24100102  ; Serial
            1D        ; Refresh time
            1H        ; Retry time
            1W        ; Expiry time
            1D )      ; Negative cache TTL

    ; Name servers

              IN  NS     srv001
              IN  NS     srv002

    srv001    IN  A      172.16.76.251
    srv002    IN  A      172.16.76.252

    ; Mail server

    @         IN  MX     10 srv003

    srv003    IN  A      172.16.76.3

    smtp      IN  CNAME  srv003
    imap      IN  CNAME  srv003

    ; Web server

    srv004    IN  A      172.16.76.4
    @         IN  A      172.16.76.4

    www       IN  CNAME  srv004
    ```

    > Check the zone file for syntax errors:

    ```console
    [vagrant@srv001 ~]$ sudo named-checkzone linuxtrn.lan /var/named/linuxtrn.lan
    zone linuxtrn.lan/IN: loaded serial 24100102
    OK
    ```

    > Add the zone to the configuration file `/etc/named.conf` (below the root hints):

    ```text
    zone "linuxtrn.lan" IN {
        type primary;
        file "linuxtrn.lan";
        allow-update { none; };
    };
    ```

    > Check the syntax of the configuration file and restart the DNS server:

    ```console
    [vagrant@srv001 ~]$ sudo named-checkconf
    [vagrant@srv001 ~]$ sudo systemctl restart named
    ```

   - Use `dig` and `nslookup` to verify all resource records.

        ```console
        [vagrant@srv001 ~]$ dig @localhost www.linuxtrn.lan +short
        srv004.linuxtrn.lan.
        172.16.76.4
        [vagrant@srv001 ~]$ dig @localhost linuxtrn.lan +short
        172.16.76.4
        [vagrant@srv001 ~]$ dig @localhost smtp.linuxtrn.lan +short
        srv003.linuxtrn.lan.
        172.16.76.3
        [vagrant@srv001 ~]$ dig @localhost MX linuxtrn.lan +short
        10 srv003.linuxtrn.lan.
        [vagrant@srv001 ~]$ dig @localhost NS linuxtrn.lan +short
        srv002.linuxtrn.lan.
        srv001.linuxtrn.lan.
        [vagrant@srv001 ~]$ dig @localhost AXFR linuxtrn.lan +short
        srv001.linuxtrn.lan. hostmaster.linuxtrn.lan. 24100102 86400 3600 604800 86400
        172.16.76.4
        srv001.linuxtrn.lan.
        srv002.linuxtrn.lan.
        10 srv003.linuxtrn.lan.
        srv003.linuxtrn.lan.
        srv003.linuxtrn.lan.
        172.16.76.251
        172.16.76.252
        172.16.76.3
        172.16.76.4
        srv004.linuxtrn.lan.
        srv001.linuxtrn.lan. hostmaster.linuxtrn.lan. 24100102 86400 3600 604800 86400
        ```

   - Optionally, write a test script that runs these queries automatically and compares the results with the expected values.

        > Example test script:

        ```bash
        #! /bin/bash
        # Run DNS queries against our BIND server

        # Variables
        readonly domain="linuxtrn.lan"
        readonly server="localhost"
        readonly query="dig @${server} +short"

        printf '\n=== A records ===\n'

        printf 'srv001 -> '
        ${query} "srv001.${domain}"
        printf 'srv002 -> '
        ${query} "srv002.${domain}"
        printf 'srv003 -> '
        ${query} "srv003.${domain}"
        printf 'srv004 -> '
        ${query} "srv004.${domain}"
        printf '@      -> '
        ${query} "${domain}"

        printf '\n=== CNAME records ===\n'

        printf 'www  -> '
        ${query} "www.${domain}"
        printf 'smtp -> '
        ${query} "smtp.${domain}"
        printf 'imap -> '
        ${query} "imap.${domain}"

        printf '\n=== MX record ===\n'

        ${query} MX "${domain}"

        printf '\n=== NS records ===\n'

        ${query} NS "${domain}"

        printf '\n=== SOA record ===\n'

        ${query} SOA "${domain}"

        printf '\n=== Zone transfer ===\n'

        ${query} AXFR ${domain}
        ```

5. On the client machine, set the system DNS server to the IP address of `srv001` and test (from the terminal, or using your test script) whether you can:

    > TODO

    - Ping the VMs by their hostnames.
    - Resolve the domain name `linuxtrn.lan` to an IP address.
    - Query the name and mail servers for the domain `linuxtrn.lan`.
    - Perform a reverse lookup for any of the IP addresses in the domain.
    - Access the website on `srv004` by entering `https://www.linuxtrn.lan` in a browser (or alternatively use `curl` if your client VM does not have a graphical UI).

6. Set up `srv002`, install BIND and set up a *secondary* server for your primary zone.

    > TODO

    - Rewrite your test script so it can also run queries against the secondary server.
    - Ensure that you have the query logs on the primary server turned on and that you are watching its logs before you start the secondary server.
    - Observe the zone transfer process when you start the secondary server.
    - Check that the secondary server responds to the same queries as the primary.
    - Try an AXFR query from the secondary server to the primary server. Try the same from the client machine. Also try it from the primary server to the secondary server. Which work and which don't?
    - Make a change to one of the resource records on the primary server (e.g. change an IP address) and update your test script. Restart the primary server. Query both the primary and the secondary server to see if the change has been propagated.
    - It probably hasn't, unless you thought of incrementing the seral number in the zone file. Do that now and repeat the previous step. Check whether the zone transfer happens and that both primary and secondary server respond with the updated information.

