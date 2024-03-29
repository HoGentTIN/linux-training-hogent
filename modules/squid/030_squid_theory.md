## installing squid

This screenshot shows how to install squid on Debian with `aptitude`.
Use `yum` if you are on Red Hat/CentOS.

    root@linux:~# aptitude install squid
    The following NEW packages will be installed:
      squid squid-common{a} squid-langpack{a}
    0 packages upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
    Need to get 1,513 kB of archives. After unpacking 4,540 kB will be used.
    Do you want to continue? [Y/n/?]
    ...output truncated...
    Setting up squid-langpack (20120616-1) ...
    Setting up squid-common (2.7.STABLE9-4.1) ...
    Setting up squid (2.7.STABLE9-4.1) ...
    Creating squid spool directory structure
    2014/08/01 15:19:31| Creating Swap Directories
    Restarting Squid HTTP proxy: squid.

`squid`\'s main configuration file is
`/etc/squid/squid.conf`. The file explains every parameter
in great detail.

    root@linux:~# wc -l /etc/squid/squid.conf
    4948 /etc/squid/squid.conf

## port 3128

By default the `squid proxy server` will lsiten to `port 3128`.

    root@linux:~# grep ^http_port /etc/squid/squid.conf
    http_port 3128
    root@linux:~#

## starting and stopping

You can manage `squid` with the standard `service` command as shown in
this screenshot.

    root@linux:~# service squid start
    Starting Squid HTTP proxy: squid.
    root@linux:~# service squid restart
    Restarting Squid HTTP proxy: squid.
    root@linux:~# service squid status
    squid is running.
    root@linux:~# service squid stop
    Stopping Squid HTTP proxy: squid.
    root@linux:~#

## client proxy settings

To enable a proxy server in `Firefox` or `Iceweasel` go to
`Edit Preferences` and configure as shown in this screenshot (replace
192.168.1.60 with the ip address of your proxy server).

![](assets/proxy_firefoxsettings.png)

Test that your internet works with the proxy enabled. Also test that
after a `service squid stop` command on your proxy server that you get a
message similar to this schreenshot.

![](assets/firefox_noproxy.png)

To enable a proxy server with Google Chrome (or Debian Chromium) start
the program from the command line like this:

    student@linux:~$ chromium --proxy-server='192.168.1.60:3128'

Disabling the proxy with `service squid stop` should result in an error
message similar to this screenshot.

![](assets/chromium_noproxy.png)

## upside down images

A proxy server sits inbetween your browser and the internet. So besides
caching of internet data (the original function of a proxy server) and
besides firewall like restrictions based on www content, a proxy server
is in the perfect position to alter the webpages that you visit.

You could for instance change the advertising on a webpage (or remove
certain advertisers), or like we do in this example; change all images
so they are upside down.

The server needs command line tools to manipulate images and a perl
script that uses these tools (and `wget` to download the images locally
and serve them with `apache2`). In this example we use `imagemagick`
(which provides tools like `convert` and `mogrify`).

    root@linux:~# aptitude install imagemagick wget perl apache2
    ...output truncated...
    root@linux:~# dpkg -S $(readlink -f $(which mogrify))
    imagemagick: /usr/bin/mogrify.im6
    root@linux:~#

The perl script that is shown in the screenshot below can be found on
several websites, yet I have not found the original author. It is
however a very simple script that uses `wget` and `mogrify` to download
images (.jpg .gif and .png), flip them and store them in
`/var/www/images`.

    root@linux:~# cat /usr/local/bin/flip.pl
    #!/usr/bin/perl
    $|=1;
    $count = 0;
    $pid = $$;
    while (<>) {
     chomp $_;
     if ($_ =~ /(.*\.jpg)/i) {
      $url = $1;
      system("/usr/bin/wget", "-q", "-O","/var/www/images/$pid-$count.jpg", "$url");
      system("/usr/bin/mogrify", "-flip","/var/www/images/$pid-$count.jpg");
      print "http://127.0.0.1/images/$pid-$count.jpg\n";
     }
     elsif ($_ =~ /(.*\.gif)/i) {
      $url = $1;
      system("/usr/bin/wget", "-q", "-O","/var/www/images/$pid-$count.gif", "$url");
      system("/usr/bin/mogrify", "-flip","/var/www/images/$pid-$count.gif");
      print "http://127.0.0.1/images/$pid-$count.gif\n";
     }
     elsif ($_ =~ /(.*\.png)/i) {
      $url = $1;
      system("/usr/bin/wget", "-q", "-O","/var/www/images/$pid-$count.png", "$url");
      system("/usr/bin/mogrify", "-flip","/var/www/images/$pid-$count.png");
      print "http://127.0.0.1/images/$pid-$count.png\n";
     }
     else {
             print "$_\n";;
     }
     $count++;
    }

Change (or enable) also the following line in `/etc/squid/suiqd.conf`.

    http_access allow localnet
    http_port 3128 transparent
    url_rwwrite_program /usr/local/bin/flip.pl

The directory this script uses is `/var/www/images` and should be
accessible by both the `squid server` (which uses the user named `proxy`
and by the `apache2` webserver (which uses the user `www-data`. The
screenshot below shows how to create this directory, set the permissions
and make the users a member of the other groups.

    root@linux:~# mkdir /var/www/images
    root@linux:~# chown www-data:www-data /var/www/images
    root@linux:~# chmod 755 /var/www/images
    root@linux:~# usermod -aG www-data proxy
    root@linux:~# usermod -aG proxy www-data

Test that it works after restarting `squid` and `apache2`.

![](assets/proxy_upsidedown_xkcd.png)

## /var/log/squid

The standard log file location for squid is
`/var/log/squid`.

    [root@RHEL4 ~]# grep "/var/log" /etc/squid/squid.conf
    # cache_access_log /var/log/squid/access.log
    # cache_log /var/log/squid/cache.log
    # cache_store_log /var/log/squid/store.log

## access control

The default squid setup only allows localhost access. To enable access
for a private network range, look for the \"INSERT YOUR OWN RULE(S)
HERE\...\" sentence in squid.conf and add two lines similar to the
screenshot below.

    # INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS

    acl company_network src 192.168.1.0/24
    http_access allow company_network

## testing squid

First, make sure that the server running squid has access to the
internet.

    [root@RHEL4 ~]# wget -q http://linux-training.be/index.html
    [root@RHEL4 ~]# ls -l index.html 
    -rw-r--r--  1 root root 2269 Sep 18 13:18 index.html
    [root@RHEL4 ~]#

Then configure a browser on a client to use the proxy server, or you
could set the HTTP_PROXY (sometimes http_proxy) variable to point
command line programs to the proxy.

    [root@fedora ~]# export HTTP_PROXY=http://192.168.1.39:8080
    [root@ubuntu ~]# export http_proxy=http://192.168.1.39:8080

Testing a client machine can then be done with wget (wget -q is used to
simplify the screenshot).

    [root@linux ~]# > /etc/resolv.conf
    [root@linux ~]# wget -q http://www.linux-training.be/index.html
    [root@linux ~]# ls -l index.html 
    -rw-r--r-- 1 root root 2269 Sep 18  2008 index.html
    [root@linux ~]#

## name resolution

You need name resolution working on the `squid` server, but you don\'t
need name resolution on the clients.

    [student@linux ~]$ wget http://grep.be
    --14:35:44--  http://grep.be
    Resolving grep.be... failed: Temporary failure in name resolution.
    [student@linux ~]$ export http_proxy=http://192.168.1.39:8080
    [student@linux ~]$ wget http://grep.be
    --14:35:49--  http://grep.be/
    Connecting to 192.168.1.39:8080... connected.
    Proxy request sent, awaiting response... 200 OK
    Length: 5390 (5.3K) [text/html]
    Saving to: `index.html.1'

    100%[================================>] 5,390       --.-K/s   in 0.1s

    14:38:29 (54.8 KB/s) - `index.html' saved [5390/5390]

    [student@linux ~]$

