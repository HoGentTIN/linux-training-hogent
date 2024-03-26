# DNS

## Explaining DNS


DNS resolves hostnames to IP-addresses.

### host for an A record

Typing linux-training.be in a browser then e DNS query is sent to
resolve linux-training.be to 88.151.243.8. The browser will set up a TCP
connection with this IP-address and will use HTTP to obtain the website.

    paul@MBDebian$ host -t a linux-training.be
    linux-training.be has address 88.151.243.8
    paul@MBDebian$

The **-t a** option queries for the A record in DNS. An A record is a
record that associates a DNS name with an IP-address.

### host for PTR record

Reverse lookup of PTR record.

    paul@MBDebian$ host 88.151.243.8
    8.243.151.88.in-addr.arpa domain name pointer fosfor.openminds.be.
    paul@MBDebian$

### nslookup for A record (first time)

The **nslookup** tool will tell you which DNS server it queries (the
first two lines of the output) and then the answer to your query.

    paul@MBDebian$ nslookup linux-training.be
    Server:         195.130.130.11
    Address:        195.130.130.11#53

    Non-authoritative answer:
    Name:   linux-training.be
    Address: 88.151.243.8

    paul@MBDebian$

### dig for an A record

    paul@MBDebian$ dig linux-training.be

    ; <<>> DiG 9.11.5-P4-5.1-Debian <<>> linux-training.be
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 18378
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;linux-training.be.             IN      A

    ;; ANSWER SECTION:
    linux-training.be.      922     IN      A       88.151.243.8

    ;; Query time: 37 msec
    ;; SERVER: 195.130.130.11#53(195.130.130.11)
    ;; WHEN: Wed Nov 06 15:02:49 CET 2019
    ;; MSG SIZE  rcvd: 62

    paul@MBDebian$

### nslookup for NS record

Looking for **name servers** (or NS records) with **nslookup**.

    paul@MBDebian~$ nslookup
    > set type=NS
    > linux-training.be
    Server:         195.130.130.11
    Address:        195.130.130.11#53

    Non-authoritative answer:
    linux-training.be       nameserver = ns3.om-powered.net.
    linux-training.be       nameserver = ns2.openminds.be.
    linux-training.be       nameserver = ns1.openminds.be.

    Authoritative answers can be found from:
    >

### nslookup for authoritative NS response

To get an authoritative response query the authoritative **name server**
directly with **nslookup**.

    > server ns1.openminds.be
    Default server: ns1.openminds.be
    Address: 195.47.215.14#53
    Default server: ns1.openminds.be
    Address: 2a02:d08:53::a1#53
    > linux-training.be
    Server:         ns1.openminds.be
    Address:        195.47.215.14#53

    linux-training.be       nameserver = ns1.openminds.be.
    linux-training.be       nameserver = ns3.om-powered.net.
    linux-training.be       nameserver = ns2.openminds.be.
    >

### host for NS record

So which are the **DNS servers** or **name servers** that are
authoritative for linux-training.be? This can be answered by the **host
-t ns** command.

    paul@MBDebian$ host -t ns linux-training.be
    linux-training.be name server ns3.om-powered.net.
    linux-training.be name server ns2.openminds.be.
    linux-training.be name server ns1.openminds.be.
    paul@MBDebian$

### host for MX record

When sending e-mail your local mail server will need to know where to
send it. It obtains this information by querying for an MX record of the
domain.

    paul@MBDebian$ host -t mx linux-training.be
    linux-training.be mail is handled by 10 argon.openminds.be.
    linux-training.be mail is handled by 20 hotel.openminds.be.
    paul@MBDebian$

### dig for MX at 8.8.8.8

    paul@MBDebian$ dig @8.8.8.8 linux-training.be mx +short
    20 hotel.openminds.be.
    10 argon.openminds.be.
    paul@MBDebian$

### dig +short alias

    paul@MBDebian$ alias dig=dig +short
    paul@MBDebian$ dig linux-training.be
    88.151.243.8
    paul@MBDebian~$

## DNS software

### BIND


## Caching only DNS server

### What it is.


### Configuration

### Testing

===

===

===

===

===

===

===

## Practice

## Solution

.

\+

.

\+

.

\+

.

\+

.

\+

.

\+

.

\+

.

\+
