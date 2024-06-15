*DNS* is a fundamental part of every large computer network. *DNS* is used by many network services to translate names into network addresses and to locate services on the network (by name).

Whenever you visit a web site, send an e-mail, log on to Active Directory, play Minecraft, chat, or use VoIP, there will be one or (many) more queries to *DNS* services.

For example, when you type <https://linux-training.be> in a browser address bar, a DNS query is sent to resolve *linux-training.be* to 188.40.26.208. The browser will set up a TCP connection with this IP-address and will use HTTP to obtain the website.

Should *DNS* fail on any level, then the whole network will grind to a halt (unless you hardcoded the network addresses, which is infeasible nowadays).

You will notice that even the largest of organizations benefit greatly from having a *DNS* infrastructure. Thus *DNS* requires all business units to work together.

Even at home, most home modems and routers have builtin *DNS* functionality.

This module will explain what *DNS* actually is and how to interact with a DNS server on a Linux system.

