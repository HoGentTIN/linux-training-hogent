## solution: dns

1\. Install `bind9` and verify with a sniffer how it works.

    You should see queries to the root name servers with tcpdump or wireshark.

2\. Add a `forwarder` and verify that it works.

    The forwarder van be added in named.conf.options as seen in the theory.

3\. Create a `primary forward lookup zone` named yourname.local with at
least two NS records and four A records.

    This is literally explained in the theory.

4\. Use `dig` and `nslookup` to verify your NS and A records.

    This is literally explained in the theory.

5\. Create a `slave` of your primary zone (on another server) and verify
the `zone transfer`.

    This is literally explained in the theory.

6\. Set up two primary zones on two servers and implement a
`conditional forwarder` (you can use the two servers from before).

    A conditional forwarder is set in named.conf.local as a zone.
    (see the theory on forwarder)
