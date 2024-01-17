# tcp en udp

Behalve `tcp` vinden we in `layer 4` ook nog `udp`. U hebt genoteerd dat
alvorens een `http request` verstuurd wordt, er eerst een
`tcp handshake` plaatsvindt, maar dat er voor de `dns query` helemaal
geen handshake was. Dat komt omdat `http` gebruikt maakt van `tcp` in
`layer 4`, terwijl `dns` hier werkt bovenop `udp`.

## tcp

`tcp` staat voor `Transmission Control Protocol`. Het is
een protocol dat een `connectie` opzet alvorens data te versturen. Als
je zekerheid wil dat je packetjes aankomen, dan is `tcp` het aangewezen
protocol. In de `tcp header` zit heel wat overhead. Als een
`tcp packetje` niet aankomt, dan wordt het nogmaals verstuurd.

De huidige `tcp` standaard werd vastgelegd in `rfc 793` van 1981.

De `tcp triple handshake` gaat steeds vooraf aan de `tcp`
connectie. Dit wil zeggen dat er minstens vier packetjes over het
netwerk gaan.

![](images/tcp_sessie.png)

## udp

In tegenstelling tot `tcp` is er bij `udp` geen connectie,
en ook geen handshake. Men noemt `udp` een `connectionless` protocol.

`udp` heeft minder overhead dan `tcp` en is bijgevolg sneller voor het
doorsturen van data. Maar `udp` doet geen controle of een packetje ook
wel degelijk aankomt. Als een `udp` packetje zijn bestemming niet
bereikt, dan ben je het kwijt.

![](images/udp.png)

## oefening

Bedenk zelf wanneer je udp zou gebruiken, en wanneer tcp.

e-mail van je manager ?

website van een klant ?

live radio uitzending van Clijsters tegen Henin ?

dns ?

# ping en arp

Het `arp` protocol is een `layer 2` protocol dat een link legt tussen
het `ip-adres` en het `mac-adres` van een computer. We hebben in de klas
deze werking aangetoond met behulp van het `ping` commando en de
`wireshark` sniffer. We hebben ook het `arp` commando uitgevoerd om de
`arp-cache-table` te bekijken.

![](images/arp_ping.png)

# packetjes

Op het bord heb ik regelmatig \'packetjes\' getekend. Technisch spreken
we van een `ethernet frame` en van een `ip datagram`. Het exacte formaat
(per bit of byte) van deze packetjes behoort niet tot de leerstof. Ik
veronderstel hier enkel dat jullie weten dat een ethernet netwerkkaart
de eerste zes bytes, zijnde het bestemmings-mac-adres vergelijkt met
haar eigen mac-adres.

Hieronder een `ethernet frame` met de bytes op ware grootte en enige
info op de juiste positie.

![](images/ethernet_frame.png)

Omdat we toch iets moeten kennen van `mac-adressen`, `ip-adressen` en
`poorten` om protocols en toestellen te begrijpen, gebruiken we
onderstaande vereenvoudigde voorstelling van een `packetje` op het
netwerk.

![](images/simple_packet.png)

# onze data op reis

Dit hoofdstuk beschrijft zeer beknopt de weg die onze data bewandelt als
we in een `browser` zoals `firefox` een
webpagina van de VRT (van teletekst) bekijken. Je kan dit hoofdstuk
bekijken als een beknopt overzicht van de hele cursus, alles wat we in
de cursus bekijken is wel ergens in dit verhaal te plaatsen.

## laag 7: applicatie

De reis begint in de bovenste laag. Dat is laag 7, de applicatielaag. We
gebruiken als voorbeeld de applicatie genaamd `firefox`
waarop pagina 525 van vrt teletekst open staat. Uiteraard bevindt de
applicatie `firefox` zich in de bovenste laag.

We klikten op het knopje `toon` om de pagina te verversen. Klikken op
dat knopje stuurt een `http request` naar de vrt teletekst
`webserver`. Het `layer 7 protocol` waar
webservers en web clients (aka browsers) mee werken is
`http (hyper text transfer protocol)`. Onze data zakt naar
laag 6.

![](images/pagina525.png)

## lagen 6 en 5: presentatie en sessie

Deze lagen zijn niet echt van toepassing omdat we met
`tcp/ip` werken en niet met een 7-lagig osi protocol. Je
zou kunnen zeggen dat de `browser` in laag 6 een `html` document
ontvangt van de `webserver`. Dit `html` document kan bestaan uit `ascii`
of `unicode` karakters.

## laag 4: transport

In deze laag zien we hoe de `tcp` van `tcp/ip` een
`sessie` opzet.

Zoals eerder al geschreven vindt er in deze laag wat knip- en plakwerk
plaats. Alleen is het nu net een geval waar er niet moet geknipt worden.
We vragen een `webpagina` aan een `webserver`, en deze vraag past
perfect in een packetje, dus er moet niet geknipt worden. Het protocol
aan het werk hier is `tcp (Transfer Control Protocol)`.

Maar er gebeurt toch nog iets meer dan enkel de vraag sturen van
`firefox` naar de vrt teletekst `webserver`. Het `tcp` protocol gaat
eerst een `tcp sessie` opzetten met de vrt webserver. We
kunnen dit controleren door een `sniffer` op te starten.

![](images/tcpsessie.png)

Je ziet drie `tcp packetjes` voordat het `http` packetje (wat ook een
tcp packetje is) wordt verstuurd. `tcp` zet een sessie op door eerst een
packetje te sturen met de vraag om een sessie op te zetten (SYN), hierop
komt een antwoord van de VRT webserver (SYN,ACK) en als laatste wordt er
vanuit mijn laptop nog een (ACK) gestuurd.

In het screenshot hierboven zie je een `http GET` van
pagina 511 i.p.v. pagina 525, maar dat heeft geen belang voor de
theorie.

## laag 3: netwerk

Onze vraag voor een webpagina moet terecht komen bij de `webserver` van
de vrt. Deze computer staat niet in onze klas (en ook niet bij mij
thuis). Het `ip` protocol zorgt voor de bezorging van het packetje ter
plaatse in de Reyerslaan (waar deze vrt webserver staat).

Om op de correcte plaats te geraken, is er een `ip-adres`
nodig. Het ip-adres van de vrt webserver is `193.191.175.137`. We vinden
dit terug in elke packetje dat we naar de webserver van de vrt sturen,
in de ruimte voorzien voor `destination IP-address`. Als bron ip-adres
wordt telkens het ip-adres van mijn laptop thuis gebruikt, in dit geval
`192.168.1.34`.

Onze sniffer vertaalt de `hexadecimale code` die de
computer gebruikt naar menselijk leesbare `decimale cijfers`.

![](images/ipadresvrt.png)

Hoe kan onze computer het `ip-adres` van de webserver van vrt teletekst
kennen ? Daarvoor doet `tcp/ip` een beroep op
`dns`. Indien je voor het eerst sinds een tijdje naar de
website van teletekst gaat op `url` `http://teletekst.een.be`, zal er
een `dns-query` gaan van onze computer naar onze lokale
`DNS server`.

`DNS (Domain Name System)` wordt later uitgebreid besproken, maar het
zou kunnen dat je het volgende ziet in de sniffer.

![](images/dnsteletekst.png)

## laag 2: data link

De `OSI data link layer` is een deel van de `DoD link layer` van
`tcp/ip`. In deze laag maken we gebruik van het `MAC`
adres van een netwerkkaart. Een `mac adres` is een fysisch adres dat
ingebrand is in de netwerkkaart.

Voordat ons eerste packetje kan vertrekken, moet het `mac-adres` van de
lokale bestemming gevonden worden. De webserver van vrt teletekst staat
niet bij mij thuis, dus de lokale bestemming is mijn
`router` (aka de adsl modem). Deze heeft `ip-adres`
192.168.1.1.

Mijn laptop zal een `arp` broadcast uitvoeren om het
mac-adres te vinden van de computer met ip-adres 192.168.1.1. Mijn
`router` zal hierop antwoorden. In een sniffer ziet dit er als volgt
uit.

![](images/arpillyria.png)

## laag 1: physical

De netwerkkaart is gelukkig als het packetje volledig is, en smijt het
letterlijk op mijn lokaal netwerk. Fysisch is dit een broadcast, alle
computers in het lokale netwerk ontvangen dit packetje, maar enkel de
enige correcte bestemmeling zal het packetje ook aanvaarden. Die
correcte bestemming is mijn lokale `router`.

In de OSI wereld is dit een aparte laag, in de DoD wereld is dit een
onderdeel van de `DoD link layer`.

## onze data onderweg

Onze `http request` voor een teletekst pagina is nu
onderweg van centrum Antwerpen naar de Reyerslaan in Brussel. Het
packetje springt van router tot router, totdat het op het netwerk van de
`webserver` van de vrt zit.

Je kan deze weg (de routers) bekijken door een
`traceroute` te doen. Hieronder zie je de uitvoer van het
`traceroute` commando op mijn laptop.

    traceroute to 193.191.175.137 (193.191.175.137), 30 hops max, 60 byte packets
    1  illyria (192.168.1.1)  0.812 ms  1.285 ms  1.764 ms
    2  213.219.148.1.adsl.dyn.edpnet.net (213.219.148.1) 26.453 ms 26.833 ms 27.216 ms
    3  ndl2-rb01.edpnet.be (213.219.132.237)  27.655 ms  28.035 ms  28.412 ms
    4  adslgwbe.edpnet.net (212.71.1.78)  28.924 ms  29.305 ms  29.798 ms
    5  10ge.cr1.brueve.belnet.net (194.53.172.65)  30.165 ms  30.543 ms  30.888 ms
    6  10ge.ar1.brucam.belnet.net (193.191.16.193)  31.991 ms  31.530 ms  31.960 ms
    7  vrt.customer.brussels.belnet.net (193.191.4.189) 32.046 ms 9.004 ms 24.205 ms
    8  * * *
    9  * * *
        

Wat je ziet, is dat de eerste router `illyria` heet en `192.168.1.1` als
ip-adres heeft. Dit is mijn lokale `adsl modem` met
ingebouwde router functie. Op de tweede lijn zie je de andere kant van
mijn adsl modem, de kant van mijn `internet service provider (ISP)`
genaamd `edpnet`.

Daarna passeren we enkele routers van edpnet, om vervolgens te reizen
naar `belnet`. Het Belgische `belnet` is een snel backbone
netwerk waar o.a. universiteiten en openbare instellingen op aangesloten
zijn.

De laatste router die we zien heet `vrt.customer.brussels.belnet.net`.
Uit deze naam kan je afleiden dat de VRT een klant is van `belnet` in
Brussel.

Nadien zien we enkel nog sterretjes, dat is omdat de `systeembeheerder`
van de VRT beslist heeft om geen `traceroute` door zijn
`firewall` te laten. Onze `http request` mag gelukkig wel
door.

## bestemming bereikt

Als alles goed gaat, dan bereikt onze data (of onze `http request`) zijn
bestemming. De laatste `router` gooit onze data op het lokale netwerk
van de `webserver` van de VRT.

De netwerkkaart van deze server converteert de elektrische signalen in
bytes, en controleert of de eerste zes bytes wel overeenstemmen met haar
`MAC adres`. Dat is gelukkig juist, dus is het de beurt
aan `IP`.

Het `ip protocol` controleert of het `destination ip address` wel
correct is, en dat is (gelukkig) weeral juist.

Verdere `metadata` in het packetje vertelt deze computer dat het een
`tcp packet` is, met als bestemming de `http-server`.

De `http server (of webserver)` zelf zoekt dan de gevraagde webpagina,
en stuurt deze webpagina als antwoord op onze vraag.

## er komt antwoord

De webserver heeft de bewuste `webpagina` klaar en wil een antwoord
sturen naar mijn laptop. Deze computer kent mijn
`ip-adres` omdat dit meegeleverd is in het packetje als
`source ip-adres`.

We zakken weer van de `applicatie-laag` (ja ook een http-server is een
applicatie) naar beneden.

Tussen haakjes, de `presentatie` van deze data aan de browser gebeurt
met een `mime type`. Email berichten (en websites) bestaan al lang niet
meer enkel uit `ascii` karakters, maar bevatten ook andere
karakters, foto\'s, geluid en film.

`MIME (Multipurpose Internet Mail Extensions)` defineert
een mechanisme om deze inhoud te versturen over e-mail (of zoals in ons
voorbeeld over `http`). Je zou `mime` in `osi layer 6` kunnen zetten.

De `tcp-sessie` die mijn laptop heeft opgezet, die is er
nog steeds. Het antwoord kan dus onmiddellijk door de `transport-laag`
naar `ip`, of toch bijna. De gevraagde webpagina is immers te groot om
in 1 packetje door te sturen, dus moet er geknipt en geplakt worden door
`tcp`. Dit kan je zien in de sniffer als een opeenvolging van
`tcp segment` packetjes, gevolgd door een
`tcp ack`nowledgement.

![](images/tcpknipplak.png)

Het `ip` protocol zal zorgen voor de terugweg van Brussel
naar Antwerpen, eventueel via andere `routers`.

Eens het antwoord terug op ons netwerk is, gaat de data van onder naar
boven door de lagen, totdat onze `browser` de webpagina kan tonen.

## vragen

1\. Hoe weet de computer van de VRT dat het packetje naar de http-server
moet ?

2\. Hoe weet mijn laptop voor welke applicatie het packetje is ?

# lagen oefening

0\. Kies een netwerk voor de volgende vragen : thuis, werk, klas

1\. Maak een tekening (papier of pc) van je netwerk voor laag 1.

2\. Maak een tekening (papier of pc) van je netwerk voor laag 2.

3\. Maak een tekening (papier of pc) van je netwerk voor laag 3 (wanneer
je een website bezoekt).

4\. Maak een tekening (papier of pc) van je netwerk voor laag 7 (wanneer
je een website bezoekt).
