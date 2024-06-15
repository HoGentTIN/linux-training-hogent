## practice: dns

Log in to a Linux system and try the following:

1. What's the IP address for the DNS server for this system? How did you find it? This may differ depending on your Linux distribution.

2. Try some DNS queries using `getent`, `host`, `nslookup` and `dig`. See how the output differs.

    - Try to resolve the IP address for `www.linux-training.be` or some well known websites.
    - Try reverse DNS lookups (PTR) and other types of queries (AAAA, MX, SOA, etc.).

3. Try to determine the authoritative DNS server for your Internet Service Provider, or for the DNS server of the organization you are affiliated with.

   - Try some forward (IPv4 and IPv6) and reverse DNS queries.
   - Try to find the mail server for this domain
   - The following exercise may yield different results depending whether you're inside the organization's network or not. Can you request a zone transfer? What happens? If you do get a zone transfer, what information do you get?

4. Go to <https://www.dns.toys> and try some of the tools there.

5. Go to <https://digi.ninja/projects/zonetransferme.php> and try the suggested exercises there.


