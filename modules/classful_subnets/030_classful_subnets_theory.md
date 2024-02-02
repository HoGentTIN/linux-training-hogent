## ip address classes

In the previous chapter we divided ip addresses into classes.

  ----------------------------------------------------------
      class      first bit(s)        first decimal byte
  -------------- -------------- ----------------------------
        A        0                         0-127

        B        10                       128-191

        C        110                      192-223

        D        1110                     224-239

        E        1111                     240-255
  ----------------------------------------------------------

  : ip address classes

## classful subnet masks

The first three classes of ipv4 addresses each have a default
`subnet mask`.

Class A addresses have a subnet with eight bits set to 1 followed by 24
bits set to zero. Class B addresses have 16 bits set to 1 followed by 16
bits set to 0. Class C addresses have 24 bits set to 1 followed by eight
bits set to 0. This gives us the following tables.

  ------------------------------------------------------
      class       bits set to 1    default subnet mask
  ------------- ----------------- ----------------------
        A               8               255.0.0.0

        B              16              255.255.0.0

        C              24             255.255.255.0
  ------------------------------------------------------

  : default decimal subnet mask

  ------------------------------------------------------------------------
    class       bits set to 1               default subnet mask
  ---------- -------------------- ----------------------------------------
      A               8             11111111.00000000.00000000.00000000

      B               16            11111111.11111111.00000000.00000000

      C               24            11111111.11111111.11111111.00000000
  ------------------------------------------------------------------------

  : default binary subnet mask

## practice default subnet masks

Write down the default subnet mask for the following ip addresses:

  -------------------------------------------------
         ip address             default mask ?
  ------------------------ ------------------------
       192.168.42.33       

        9.101.12.01               255.0.0.0

        188.33.42.33       

         9.42.12.33        

        230.19.4.42        

        11.19.6.200        

      191.192.193.194      

         134.0.0.42        
  -------------------------------------------------

  : practice default subnet masks

## network id en host id

Bij het uitvoeren van `ifconfig` op een Unix/Linux en
`ipconfig` op een MS Windows computer merkt je dat je
steeds een `ip-adres` en en `subnet mask`
krijgt. De combinatie van die twee bepaalt in welk netwerk een computer
zich bevindt.

Als het subnet mask gelijk is aan 255.0.0.0, dan vormt de eerste byte
van het ip-adres aangevuld met nullen het `network id`.
Bij 255.255.0.0 als subnet mask zijn er twee bytes (aangevuld met
nullen) die het `network id` vormen. Bij 255.255.255.0 zijn er drie
bytes (en een nul) die het `network id` vormen.

De rest van het ip-adres is dan het `host id`. Het `network id` bepaalt
het netwerk waarin een computer zich bevindt, het
`host id` is uniek voor een host binnen het netwerk.

Een overzichtje met voorbeelden:

  ---------------------------------------------------------------------
      ip-adres        default subnet mask       network id     host id
  ---------------- ------------------------- ---------------- ---------
    192.168.1.42         255.255.255.0         192.168.1.0       42

    192.168.1.33         255.255.255.0         192.168.1.0       33

    192.168.12.1         255.255.255.0         192.168.12.0       1

    172.16.12.1           255.255.0.0           172.16.0.0      12.1

    172.16.33.42          255.255.0.0           172.16.0.0      33.42

      10.3.0.4             255.0.0.0             10.0.0.0       3.0.4

     10.33.0.42            255.0.0.0             10.0.0.0      33.0.42
  ---------------------------------------------------------------------

  : network id en host id

## oefening network id en host id

1\. Noteer de `network id` en `host id` voor de volgende ip-adressen.

    192.168.42.42

    9.8.7.6

    42.42.42.42

    169.254.42.1

    191.42.17.18

    193.42.17.18

## lokale computer of niet ?

Wat is het nut van het kennen van een `network id`? Wel het `network id`
bepaalt of een computer lokaal in je netwerk staat of niet.

Indien je wil communiceren met een andere computer, dan heb je zijn
`ip-adres` nodig. Als die computer dan op hetzelfde netwerk zit, dan
doet jouw computer een `arp` om het
`MAC adres` van de andere computer te vinden. Als die
computer echter op een ander netwerk zet, dan stuurt jouw computer het
packetje naar de `router`.

Alvorens over te gaan tot een `arp` (voor die andere computer of voor de
router) zal jouw computer het `network id` van jouw computer vergelijken
met dat van de andere computer. Indien gelijk, dan betreft het een
computer op hetzelfde netwerk, indien verschillend, dan staat die
computer achter de `router`.

Een overzichtje met voorbeelden (gebruik standaard subnet mask):

    computer A     computer B    network id A   network id B   lokaal ?
  -------------- -------------- -------------- -------------- ----------
   192.168.1.42   192.168.1.33   192.168.1.0    192.168.1.0       ja
   192.168.1.33   192.168.12.1   192.168.1.0    192.168.12.0     nee
     10.3.0.4      10.33.0.42      10.0.0.0       10.0.0.0        ja

  : local or remote computer?

## oefening lokale computer of niet?

1\. Staan de volgende computers in hetzelfde netwerk ?

    192.168.1.42 en 192.168.1.33

    10.105.42.42 en 10.105.42.33

    10.105.42.42 en 10.99.42.33

    11.16.42.42 en 12.16.42.33

    169.254.18.42 en 169.254.33.42

    191.168.42.42 en 191.168.33.33

    9.1.2.3 en 9.123.234.42

## subnet notatie

We kunnen de notatie van `ip-adres/subnet mask` afkorten
als we voor de subnet mask enkel het aantal bits vernoemen dat op 1
staat. Zo wordt 255.0.0.0 gelijk aan /8, wordt 255.255.0.0 gelijk aan
/16 en 255.255.255.0 gelijk aan /24.

Afgekort kunnen we dus 192.168.1.42/24 schrijven i.p.v. 192.168.1.42 met
subnet mask 255.255.255.0 .

  ----------------------------------------------------------
      klasse         default subnet mask         notatie
  -------------- ---------------------------- --------------
        A                 255.0.0.0                 /8

        B                255.255.0.0               /16

        C               255.255.255.0              /24
  ----------------------------------------------------------

  : cidr notatie

## computers in een netwerk tellen

Hoeveel computers kan je zetten in een netwerk? Houd rekening met de
`network id` die zelf al een ip-adres gebruikt. Elk
netwerk heeft ook een `broadcast` adres (alle decimale
delen van het host id zijn dan 255).

Bijvoorbeeld:

  -----------------------------------------------------------------------------
       network        network id     broadcast ip        max aantal hosts
  ----------------- -------------- ---------------- ---------------------------
   192.168.1.0/24    192.168.1.0    192.168.1.255          256 - 2 = 254

   192.168.15.0/24   192.168.15.0   192.168.15.255         256 - 2 = 254

    172.16.0.0/16     172.16.0.0    172.16.255.255     256\*256 - 2 = 65534

     10.0.0.0/8        10.0.0.0     10.255.255.255      256\*256\*256 - 2 =
                                                             16777214
  -----------------------------------------------------------------------------

  : aantal computers in een subnet

## te weinig ip-adressen ?

Is vier miljard dan niet genoeg ? We verspillen enorm veel ip-adressen
door de verkoop van klasse A en klasse B aan organisaties die eigenlijk
veel minder adressen nodig hebben.

Wat doe je als je 300 adressen nodig hebt ? Of 2000 ? Je kan kiezen voor
een klasse B range, maar dan verspil je meer dan 90
procent. Je kan ook zeggen dat 8 klasse C adressen voldoen
voor 2000 computers, maar dan vergroot je de `routing tables` weer.

### ip-adressen verdelen

`Klasse A` adressen kunnen dus een dikke 16 miljoen
computers bevatten, `klasse B` een goeie 65 duizend en
`klasse C` iets meer dan 200.

Stel dat jouw organisatie 3000 ip-adressen nodig heeft, dan moet je een
klasse B gebruiken. Maar dat wil zeggen dat je meer dan 62 duizend
ip-adressen `verspilt`. Onthou ook dat heel wat klasse A ranges begin
jaren 90 in hun geheel verkocht zijn.

In de jaren 70-80 was dit een goed systeem, er waren immers maar enkele
duizenden computers op dit `internetwerk`. Maar de laatste
jaren zijn er meer dan een miljard computers verbonden met internet. Met
een totaal van vier miljard (256\*256\*256\*256) ip-adressen kunnen we
ons niet langer veroorloven om ip-adressen te verspillen.

### probleem voor de routing tables

Je zou kunnen argumenteren op het vorige dat je ook twaalf
`klasse C` kan gebruiken voor een netwerk met 3000
computers. En dat is correct, maar heeft wel tot gevolg dat de
`routing tables` in de internet routers er twaalf routes
bij krijgen i.p.v. slechts eentje.

Alle grote netwerken opbouwen met klasse C ip ranges is dus ook geen
oplosssing. (routing tables bespreken we later)

### Is nat een oplossing ?

Een andere verzachtende techniek voor het naderende tekort aan
ip-adressen is `nat`. Een `nat` toestel kan meerdere
`private ip-adressen`(en dus meerdere computers) met een
(of enkele) publieke adressen verbinden met het internet.

Maar `nat` heeft dan weer het nadeel dat niet alle applicaties kunnen
werken achter een `nat`. Bijvoorbeeld `ipsec` (want de
poort-informatie is versleuteld), `sip` (Voice over IP),
`ftp`, `dns zone transfers` (we bespreken
dit later), `dhcp`, `snmp` en sommige multiplayer spelletjes op
Microsofts xbox werken niet over `nat`.
