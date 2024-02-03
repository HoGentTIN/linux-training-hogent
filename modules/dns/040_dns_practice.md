## practice: dns

1\. Install `bind9` and verify with a sniffer how it works.

2\. Add a `forwarder` and verify that it works.

3\. Create a `primary forward lookup zone` named yourname.local with at
least two NS records and four A records.

4\. Use `dig` and `nslookup` to verify your NS and A records.

5\. Create a `slave` of your primary zone (on another server) and verify
the `zone transfer`.

6\. Set up two primary zones on two servers and implement a
`conditional forwarder` (you can use the two servers from before).

