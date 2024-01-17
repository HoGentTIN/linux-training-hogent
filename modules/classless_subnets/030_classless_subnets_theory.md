# binaire subnets

Stel je eens voor dat computers `binair` rekenen i.p.v.
decimaal ;-)

Computers rekenen met `bits` en `bytes`,
mensen rekenen decimaal. Onze computers zien een
`ip-adres` als een 32-bit getal, hetzelfde geldt voor de
`subnet mask`. De drie subnet masks die we tot nu toe
kennen zijn decimaal en binair voorgesteld in de volgende tabel:

  ------------------------------------------------------------------
   class      subnet                    binary subnet
  ------- --------------- ------------------------------------------
     A       255.0.0.0       11111111.00000000.00000000.00000000

     B      255.255.0.0      11111111.11111111.00000000.00000000

     C     255.255.255.0     11111111.11111111.11111111.00000000
  ------------------------------------------------------------------

  : binary classful subnets

Voor de volledigheid volgt ook nog eens het aantal computers dat in een
`classful` netwerk past.

  ------------------------------------------------------------------
   class              binary subnet                   computers
  ------- -------------------------------------- -------------------
     A     11111111.00000000.00000000.00000000    256\*256\*256 - 2

     B     11111111.11111111.00000000.00000000      256\*256 - 2

     C     11111111.11111111.11111111.00000000         256 - 2
  ------------------------------------------------------------------

  : max computers classful subnets

# supernetting

Zoals je ziet, begint de subnet mask binair steeds met eentjes en
eindigt steeds met nulletjes. Wat als we nu een eentje meer of minder
zetten ?

Onze verkorte notatie laat toe om dit snel te noteren. We
schrijven simpelweg 172.16.0.0/17 i.p.v. 172.16.0.0/16 . Maar wat zijn
de gevolgen hiervan ?

Ten eerste is een eentje meer hetzelfde als het halveren van het aantal
computers in het netwerk. Want we vergroten het
`network id` en verkleinen het aantal mogelijke
`host id's`.

Laten we ons voorbeeld beginnen met het netwerk in de klas zoals het er
nu uitziet:

  --------------------------------------------------------------------------
   network id    subnet              binair subnet                 aantal
                                                                 computers
  ------------- -------- -------------------------------------- ------------
   192.168.0.0    /24     11111111.11111111.11111111.00000000    256 - 2 =
                                                                    254

  --------------------------------------------------------------------------

  : /24 netwerk in de klas

En kijk wat er gebeurt als we de `subnet mask` veranderen
van 24 `bits` naar 25 `bits` die op 1 staan.

  --------------------------------------------------------------------------
   network id    subnet              binair subnet                 aantal
                                                                 computers
  ------------- -------- -------------------------------------- ------------
   192.168.0.0    /25     11111111.11111111.11111111.10000000    128 - 2 =
                                                                    126

  --------------------------------------------------------------------------

  : /25 netwerk in de klas

De reeks ip-adressen die behoren tot 192.168.0.0/25 begint
met 192.168.0.1 en eindigt met 192.168.0.126, de network id is
192.168.0.0 en het `broadcast` adres is 192.168.0.127.

Als we dit binair voorstellen wordt het duidelijk:

  -----------------------------------------------------------------------
   omschrijving                  binair                     decimaal
  -------------- -------------------------------------- -----------------
    network id    11000000.10101000.00000000.00000000      192.168.0.0

   subnet mask    11111111.11111111.11111111.10000000    255.255.255.128

    eerste ip     11000000.10101000.00000000.00000001      192.168.0.1

    tweede ip     11000000.10101000.00000000.00000010      192.168.0.2

     derde ip     11000000.10101000.00000000.00000011      192.168.0.3

    vierde ip     11000000.10101000.00000000.00000100      192.168.0.4

    vijfde ip     11000000.10101000.00000000.00000101      192.168.0.5

       \...                       \...                        \...

  voorlaatste ip  11000000.10101000.00000000.01111101     192.168.0.125

    laatste ip    11000000.10101000.00000000.01111110     192.168.0.126

   broadcast ip   11000000.10101000.00000000.01111111     192.168.0.127
  -----------------------------------------------------------------------

  : /25 binair bekijken

We voegen nog een `bit` toe aan de
`subnet mask`, dan komen we aan /26 (255.255.255.192). De
tabel ziet er dan als volgt uit:

  -----------------------------------------------------------------------
   omschrijving                  binair                     decimaal
  -------------- -------------------------------------- -----------------
    network id    11000000.10101000.00000000.00000000      192.168.0.0

   subnet mask    11111111.11111111.11111111.11000000    255.255.255.192

    eerste ip     11000000.10101000.00000000.00000001      192.168.0.1

    tweede ip     11000000.10101000.00000000.00000010      192.168.0.2

     derde ip     11000000.10101000.00000000.00000011      192.168.0.3

       \...                       \...                        \...

  voorlaatste ip  11000000.10101000.00000000.00111101     192.168.0.61

    laatste ip    11000000.10101000.00000000.00111110     192.168.0.62

   broadcast ip   11000000.10101000.00000000.00111111     192.168.0.63
  -----------------------------------------------------------------------

  : /26 binair bekijken

# binaire subnets decimaal voorstellen

We weten al dat 255 `decimaal` gelijk is aan 11111111
`binair` en dat 0 decimaal gelijk is aan 00000000 binair
(in byte-vorm). Een binair `subnet mask` begint steeds met
eentjes, en eindigt met nulletjes. De volgende tabel kan dus handig zijn
bij het decimaal neerschrijven van een binair subnet mask.

  -------------------------------------------------
     binair subnet mask         decimaal getal
  ------------------------ ------------------------
          11111111                   255

          11111110                   254

          11111100                   252

          11111000                   248

          11110000                   240

          11100000                   224

          11000000                   192

          10000000                   128

          00000000                    0
  -------------------------------------------------

  : decimale waarde binaire subnet bytes

# 32 binaire subnet masks

Bij supernetting zijn er theoretisch 32 `binaire`
`subnet masks` i.p.v. de drie `classful`
(255.255.255.0, 255.255.0.0, 255.0.0.0). We zetten er 31 op een rijtje.

  --------------------------------------------------
  aantal bits op 1          decimale waarde
  ---------------- ---------------------------------
         1                     128.0.0.0

         2                     192.0.0.0

         3                     224.0.0.0

         4                     240.0.0.0

         5                     248.0.0.0

         6                     252.0.0.0

         7                     254.0.0.0

         8                     255.0.0.0

         9                    255.128.0.0

         10                   255.192.0.0

         11                   255.224.0.0

         12                   255.240.0.0

         13                   255.248.0.0

         14                   255.252.0.0

         15                   255.254.0.0

         16                   255.255.0.0

         17                  255.255.128.0

         18                  255.255.192.0

         19                  255.255.224.0

         20                  255.255.240.0

         21                  255.255.248.0

         22                  255.255.252.0

         23                  255.255.254.0

         24                  255.255.255.0

         25                 255.255.255.128

         26                 255.255.255.192

         27                 255.255.255.224

         28                 255.255.255.240

         29                 255.255.255.248

         30                 255.255.255.252

         31                 255.255.255.254
  --------------------------------------------------

  : 31 binaire subnets

# aantal computers

We kunnen de tabel uitbreiden met een kolom die het aantal computers
telt dat we in deze `binaire` netwerkjes kunnen plaatsen.

De simpelste formule om het aantal computers in een
`subnet` te berekenen is twee verheffen tot de macht \'het
aantal bits op 0 in de subnet\' min twee. Bij 16 bits op 1 wordt dat dus
2 tot de zestiende min twee. In de tabel gebruiken we 256 i.p.v. twee
tot de achtste.

  -----------------------------------------------------------------
    aantal bits op 1         berekening         aantal computers
  --------------------- --------------------- ---------------------
            8              256\*256\*256-2          16777214

            9              256\*256\*128-2           8388606

           10              256\*256\*64-2            4194302

           11              256\*256\*32-2            2097150

           12              256\*256\*16-2            1048574

           13               256\*256\*8-2            524286

           14               256\*256\*4-2            262142

           15               256\*256\*2-2            131070

           16                256\*256-2               65534

           17                256\*128-2               32766

           18                 256\*64-2               16382

           19                 256\*32-2               8190

           20                 256\*16-2               4094

           21                 256\*8-2                2046

           22                 256\*4-2                1022

           23                 256\*2-2                 510

           24                   256-2                  254

           25                   128-2                  126

           26                   64-2                   62

           27                   32-2                   30

           28                   16-2                   14

           29                    8-2                    6

           30                    4-2                    2
  -----------------------------------------------------------------

  : aantal computers in binaire subnets

Zie ook eens op `http://www.rfc-editor.org/rfc/rfc1878.txt`.

# network id en host id vinden

Als we een `ip-adres` krijgen, kunnen we dan het
`network id` en het `host id` vinden ?

We zullen beginnen met een simpel classful voorbeeld: `192.168.1.5/24`.

    ip-adres    : 192.168.  1.5
    subnet mask : 255.255.255.0
    network id  : 192.168.  1.0
    host id     :             5

We kunnen dit ook binair bekijken:

    ip-adres    : 11000000.10101000.00000001.00000101
    subnet mask : 11111111.11111111.11111111.00000000
    network id  : 11000000.10101000.00000001.00000000
    host id     : 00000000.00000000.00000000.00000101

Nog een tweede voorbeeld: `192.168.199.233/24`.

    ip-adres    : 192.168.199.233
    subnet mask : 255.255.255.0
    network id  : 192.168.199.0
    host id     :             233

We kunnen dit tweede voorbeeld ook binair bekijken.

    ip-adres    : 11000000.10101000.11000111.11101001
    subnet mask : 11111111.11111111.11111111.00000000
    network id  : 11000000.10101000.11000111.00000000
    host id     : 00000000.00000000.00000000.11101001

Als derde voorbeeld zullen we hetzelfde ip-adres nemen als in het
tweede, maar met een supernet: `192.168.199.233/22`. We bekijken het
eerst binair, want dit is het eenvoudigste.

    ip-adres    : 11000000.10101000.11000111.11101001
    subnet mask : 11111111.11111111.11111100.00000000
    network id  : 11000000.10101000.11000100.00000000
    host id     : 00000000.00000000.00000011.11101001

Decimaal wordt dat dan:

    ip-adres    : 192.168.199.233
    subnet mask : 255.255.252.0
    network id  : 192.168.196.0
    host id     :           3.233

# voorbeeldoefening binaire subnets

De vraag \"Zitten de volgende computers in hetzelfde netwerk?\" was met
classful subnets niet zo moeilijk. Deze vraag komt bijna letterlijk
terug op het examen, maar dan met binaire subnet masks.

Vul de volgende tabel aan voor `192.168.234.234/17`.

  -----------------------------------------------------------------------
                               binair                       decimaal
  ----------- ----------------------------------------- -----------------
  ip address     11000000.10101000.11101010.11101010     192.168.234.234

  subnet mask    11111111.11111111.10000000.00000000      255.255.128.0

  network id                                            

  eerste ip                                             

  laatste ip                                            

  broadcast                                             
  ip                                                    

  aantal                                                
  ip\'s                                                 
  -----------------------------------------------------------------------

  : oefening 192.168.234.234/17

Hieronder vind je de oplossing van bovenstaande oefening.

  ------------------------------------------------------------------------
                               binair                        decimaal
  ----------- ----------------------------------------- ------------------
  ip address     11000000.10101000.11101010.11101010     192.168.234.234

  subnet mask    11111111.11111111.10000000.00000000      255.255.128.0

  network id     11000000.10101000.10000000.00000000      192.168.128.0

  eerste ip      11000000.10101000.10000000.00000001      192.168.128.1

  laatste ip     11000000.10101000.11111111.11111110     192.168.255.254

  broadcast      11000000.10101000.11111111.11111111     192.168.255.255
  ip                                                    

  aantal      van 0000000.00000001 tot 1111111.11111110  128\*256-2=32766
  ip\'s                                                 
  ------------------------------------------------------------------------

  : oplossing 192.168.234.234/17

Het bovenstaande netwerk bevat exact de helft van alle ip-adressen in de
192.168.0.0/16 reeks. Kan je de tabel ook invullen voor de andere helft
?

  -----------------------------------------------------------------------
                               binair                       decimaal
  ----------- ----------------------------------------- -----------------
  ip address                                            

  subnet mask    11111111.11111111.10000000.00000000      255.255.128.0

  network id                                            

  eerste ip                                             

  laatste ip                                            

  broadcast                                             
  ip                                                    

  aantal                                                
  ip\'s                                                 
  -----------------------------------------------------------------------

  : andere helft van 192.168.234.234/17

Hieronder de oplossing van de andere helft.

  ------------------------------------------------------------------------
                               binair                        decimaal
  ----------- ----------------------------------------- ------------------
  ip address    11000000.10101000.`0`1101010.11101010    192.168.106.234

  subnet mask    11111111.11111111.10000000.00000000      255.255.128.0

  network id    11000000.10101000.`0`0000000.00000000      192.168.0.0

  eerste ip     11000000.10101000.`0`0000000.00000001      192.168.0.1

  laatste ip    11000000.10101000.`0`1111111.11111110    192.168.127.254

  broadcast     11000000.10101000.`0`1111111.11111111    192.168.127.255
  ip                                                    

  aantal      van 0000000.00000001 tot 1111111.11111110  128\*256-2=32766
  ip\'s                                                 
  ------------------------------------------------------------------------

  : oplossing andere helft 192.168.234.234/17

# oefeningen binaire subnets

Probeer nu dezelfde oefening voor:

    168.186.240.192/11
    192.168.248.234/17
    168.190.248.199/27

Kan je de network id, subnet mask, eerste ip, laatste ip, broadcast ip
en aantal ip\'s geven voor de subnets van die drie ip-adressen ? Zonder
naar de oplossing hieronder te kijken ?

Hieronder eerst drie lege tabellen om te oefenen, dan de oplossing.

  -----------------------------------------------------------------------
                               binair                       decimaal
  ----------- ----------------------------------------- -----------------
  ip address                                            

  subnet mask                                           

  network id                                            

  eerste ip                                             

  laatste ip                                            

  broadcast                                             
  ip                                                    

  aantal                                                
  ip\'s                                                 
  -----------------------------------------------------------------------

  : lege tabel 168.186.240.192/11

  -----------------------------------------------------------------------
                               binair                       decimaal
  ----------- ----------------------------------------- -----------------
  ip address                                            

  subnet mask                                           

  network id                                            

  eerste ip                                             

  laatste ip                                            

  broadcast                                             
  ip                                                    

  aantal                                                
  ip\'s                                                 
  -----------------------------------------------------------------------

  : lege tabel 192.168.248.234/17

  -----------------------------------------------------------------------
                               binair                       decimaal
  ----------- ----------------------------------------- -----------------
  ip address                                            

  subnet mask                                           

  network id                                            

  eerste ip                                             

  laatste ip                                            

  broadcast                                             
  ip                                                    

  aantal                                                
  ip\'s                                                 
  -----------------------------------------------------------------------

  : lege tabel 168.190.248.199/27

  -----------------------------------------------------------------------
                               binair                       decimaal
  ----------- ----------------------------------------- -----------------
  ip address     10101000.10111010.11110000.11000000     168.186.240.192

  subnet mask   `11111111.111`00000.00000000.00000000      255.224.0.0

  network id    `10101000.101`00000.00000000.00000000      168.160.0.0

  eerste ip    `10101000.101`00000.00000000.0000000`1`     168.160.0.1

  laatste ip    `10101000.101`11111.11111111.11111110    168.191.255.254

  broadcast     `10101000.101`11111.11111111.11111111    168.191.255.255
  ip                                                    

  aantal           van 00000.00000000.00000001 tot       32\*256\*256-2
  ip\'s                11111.11111111.11111110          
  -----------------------------------------------------------------------

  : oplossing 168.186.240.192/11

  -----------------------------------------------------------------------
                               binair                       decimaal
  ----------- ----------------------------------------- -----------------
  ip address     11000000.10101000.11111000.11101010     192.168.248.234

  subnet mask   `11111111.11111111.1`0000000.00000000     255.255.128.0

  network id    `11000000.10101000.1`0000000.00000000     192.168.128.0

  eerste ip    `11000000.10101000.1`0000000.0000000`1`    192.168.128.1

  laatste ip    `11000000.10101000.1`1111111.11111110    192.168.255.254

  broadcast     `11000000.10101000.1`1111111.11111111    192.168.255.255
  ip                                                    

  aantal      van 0000000.00000001 tot 1111111.11111110    128\*256-2
  ip\'s                                                 
  -----------------------------------------------------------------------

  : oplossing 192.168.248.234/17

  -----------------------------------------------------------------------
                               binair                       decimaal
  ----------- ----------------------------------------- -----------------
  ip address     10101000.10111110.11111000.11000111     168.190.248.199

  subnet mask   `11111111.11111111.11111111.111`00000    255.255.255.224

  network id    `10101000.10111110.11111000.110`00000    168.190.248.192

  eerste ip    `10101000.10111110.11111000.110`0000`1`   168.190.248.193

  laatste ip    `10101000.10111110.11111000.110`11110    168.190.248.222

  broadcast     `10101000.10111110.11111000.110`11111    168.190.248.223
  ip                                                    

  aantal                 van 00001 tot 11110                  32-2
  ip\'s                                                 
  -----------------------------------------------------------------------

  : oplossing 168.190.248.199/27

# zelfde of ander netwerk ?

Zitten de computers 192.168.117.5/18 en 192.168.34.18/18 in hetzelfde
netwerk ?

# subnetworks

Je beheert een departement met 200 computers, verdeeld over vier
verdiepingen in eenzelfde gebouw, met ongeveer vijftig computers per
verdieping. Je krijgt van je netwerkbeheerder `192.168.5.0/24` en moet
deze reeks verdelen over de vier verdiepen. Hoe doe je dat ?

Je begint met uit te rekenen hoeveel computers er in die reeks kunnen:

    192.168.5.0/24 --> 256 - 2 = 254 computers

Je weet ook uit de tabel hierboven dat een `/26`
`subnet mask` volstaat voor elke individuele verdieping.
Je verdeelt jouw /24 netwerk in vier /26 netwerken.

We bekijken dit eerst binair:

    192.168.5.0 == 11000000.10101000.00000101.00000000
    /24 mask    == 11111111.11111111.11111111.00000000
    /26 mask    == 11111111.11111111.11111111.11000000

We moeten dus twee `bits` toevoegen aan de /24
`netword id` om een /26 network id te maken. Twee bits
kunnen exact vier mogelijke waarden hebben: 00, 01, 10 of 11. We komen
dus tot de volgende vier nieuwe /26 network id\'s.

    /26 network id 1 == 11000000.10101000.00000101.00000000
    /26 network id 2 == 11000000.10101000.00000101.01000000
    /26 network id 3 == 11000000.10101000.00000101.10000000
    /26 network id 4 == 11000000.10101000.00000101.11000000

Hieronder een tabel van eerste en laatste ip van de vier /26 netwerken.
Tel bij de laatste ip eentje bij voor de broadcast ip.

  --------------------------------------------------------
      verdieping         eerste ip          laatste ip
  ------------------ ------------------ ------------------
          1             192.168.5.1        192.168.5.62

          2             192.168.5.65      192.168.5.126

          3            192.168.5.129      192.168.5.190

          4            192.168.5.193      192.168.5.254
  --------------------------------------------------------

  : echt supernetten

Tussen haakjes, nu zijn we echt aan het `supernetten`.
Want in de routers van buitenaf staat er enkel 192.168.5.0/24 als
bestemming, terwijl er intern eigenlijk vier /26 netwerkjes zijn.
