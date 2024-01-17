# about proxy servers

## usage

A `proxy server` is a server that caches the internet.
Clients connect to the proxy server with a request for an internet
server. The proxy server will connect to the internet server on behalf
of the client. The proxy server will also cache the pages retrieved from
the internet server. A proxy server may provide pages from his cache to
a client, instead of connecting to the internet server to retrieve the
(same) pages.

A proxy server has two main advantages. It improves web surfing speed
when returning cached data to clients, and it reduces the required
bandwidth (cost) to the internet.

Smaller organizations sometimes put the proxy server on the same
physical computer that serves as a NAT to the internet. In larger
organizations, the proxy server is one of many servers in the DMZ.

When web traffic passes via a proxy server, it is common practice to
configure the proxy with extra settings for access control. Access
control in a proxy server can mean user account access, but also
website(url), ip-address or dns restrictions.

## open proxy servers

You can find lists of open proxy servers on the internet that enable you
to surf anonymously. This works when the proxy server connects on your
behalf to a website, without logging your ip-address. But be careful,
these (listed) open proxy servers could be created in order to eavesdrop
upon their users.

## squid

This module is an introduction to the `squid` proxy server
(http://www.squid-cache.org). We will first configure squid as a normal
proxy server.
