## practice: BIND

1. Set up a Linux VM (Debian or EL-based) and install BIND.

    - Discover the default configuration files. Can you define the purpose of each file?
    - Turn on the query log and start `tcpdump` to capture any traffic for port 53 (inbound and outbound).
    - Without changing the configuration, send a simple forward A query for any domain name from the VM itself. Do you expect this to work?
    - Try to determine from the logs or the `tcpdump` output whether the DNS server is configured as a *caching name server* with or without a *forwarder*.
    - Repeat the previous query. Do you see a difference in behavior? Can you explain why?

2. Ensure that the DNS server is available to all hosts on the local network. Don't forget to check firewall settings! Test whether you can resolve the domain name from another VM or a physical machine on the same network.

3. Add a *forwarder* and verify that it works. Try to use a public DNS server as a forwarder. Google's is well known, but there are others, too! Search for "free public dns servers" to get some suggestions.

    - Repeat the queries from the previous step. Do you see a difference in behavior?

4. Create a *primary forward lookup zone* named `yourname.local` with a variety of resource records, e.g. NS, MX, A, AAAA, CNAME. Also add an A record for the `@` shorthand. Use 192.0.2.0/24 as IP range.

   - Use `dig` and `nslookup` to verify all resource records.
   - Optionally, write a test script that runs these queries automatically and compares the results with the expected values.

5. Create a new VM, install BIND and set up a *secondary* server of your primary zone.

    - Rewrite your test script so it can also run queries against the secondary server.
    - Ensure that you have the query logs on the primary server turned on and that you are watching its logs before you start the secondary server.
    - Observe the zone transfer process when you start the secondary server.
    - Check that the secondary server responds to the same queries as the primary.
    - Make a change to one of the resource records on the primary server (e.g. change an IP address) and update your test script. Restart the primary server. Query both the primary and the secondary server to see if the change has been propagated.
    - It probably hasn't, unless you thought of incrementing the seral number in the zone file. Do that now and repeat the previous step. Check whether the zone transfer happens and that both primary and secondary server respond with the updated information.

6. Set up two primary zones on two servers and implement a
*conditional forwarder* (you can use the two servers from before).

