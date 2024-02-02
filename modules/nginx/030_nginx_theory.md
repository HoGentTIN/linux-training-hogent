## introduction to apache

### installing on Debian

This screenshot shows that there is no `apache` server installed, nor
does the `/var/www` directory exist.

    root@debian10:~# ls -l /var/www
    ls: cannot access /var/www: No such file or directory
    root@debian10:~# dpkg -l | grep apache

To install `apache` on Debian:

    root@debian10:~# aptitude install apache2
    The following NEW packages will be installed:
      apache2 apache2-mpm-worker{a} apache2-utils{a} apache2.2-bin{a} apache2.2-com\
    mon{a} libapr1{a} libaprutil1{a} libaprutil1-dbd-sqlite3{a} libaprutil1-ldap{a}\
     ssl-cert{a} 
    0 packages upgraded, 10 newly installed, 0 to remove and 0 not upgraded.
    Need to get 1,487 kB of archives. After unpacking 5,673 kB will be used.
    Do you want to continue? [Y/n/?]

After installation, the same two commands as above will yield a
different result:

    root@debian10:~# ls -l /var/www
    total 4
    -rw-r--r-- 1 root root 177 Apr 29 11:55 index.html
    root@debian10:~# dpkg -l | grep apache | tr -s ' '
    ii apache2 2.2.22-13+deb7u1 amd64 Apache HTTP Server metapackage
    ii apache2-mpm-worker 2.2.22-13+deb7u1 amd64 Apache HTTP Server - high speed th\
    readed model
    ii apache2-utils 2.2.22-13+deb7u1 amd64 utility programs for webservers
    ii apache2.2-bin 2.2.22-13+deb7u1 amd64 Apache HTTP Server common binary files
    ii apache2.2-common 2.2.22-13+deb7u1 amd64 Apache HTTP Server common files

### installing on RHEL/CentOS

Note that Red Hat derived distributions use `httpd` as package and
process name instead of `apache`.

To verify whether `apache` is installed in CentOS/RHEL:

    [root@centos65 ~]# rpm -q httpd
    package httpd is not installed
    [root@centos65 ~]# ls -l /var/www
    ls: cannot access /var/www: No such file or directory

To install apache on CentOS:

    [root@centos65 ~]# yum install httpd

After running the `yum install httpd` command, the Centos 6.5 server has
apache installed and the `/var/www` directory exists.

    [root@centos65 ~]# rpm -q httpd
    httpd-2.2.15-30.el6.centos.x86_64
    [root@centos65 ~]# ls -l /var/www
    total 16
    drwxr-xr-x. 2 root root 4096 Apr  3 23:57 cgi-bin
    drwxr-xr-x. 3 root root 4096 May  6 13:08 error
    drwxr-xr-x. 2 root root 4096 Apr  3 23:57 html
    drwxr-xr-x. 3 root root 4096 May  6 13:08 icons
    [root@centos65 ~]#

### running apache on Debian

This is how you start `apache2` on Debian.

    root@debian10:~# service apache2 status
    Apache2 is NOT running.
    root@debian10:~# service apache2 start
    Starting web server: apache2apache2: Could not reliably determine the server's \
    fully qualified domain name, using 127.0.1.1 for ServerName
    .

To verify, run the `service apache2 status` command again or use `ps`.

    root@debian10:~# service apache2 status
    Apache2 is running (pid 3680).
    root@debian10:~# ps -C apache2
      PID TTY          TIME CMD
     3680 ?        00:00:00 apache2
     3683 ?        00:00:00 apache2
     3684 ?        00:00:00 apache2
     3685 ?        00:00:00 apache2
    root@debian10:~#

Or use `wget` and `file` to verify that your web server serves an html
document.

    root@debian10:~# wget 127.0.0.1
    --2014-05-06 13:27:02--  http://127.0.0.1/
    Connecting to 127.0.0.1:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 177 [text/html]
    Saving to: `index.html'

    100%[==================================================>] 177    --.-K/s   in 0s

    2014-05-06 13:27:02 (15.8 MB/s) - `index.html' saved [177/177]

    root@debian10:~# file index.html
    index.html: HTML document, ASCII text
    root@debian10:~#

Or verify that apache is running by opening a web browser, and browse to
the ip-address of your server. An Apache test page should be shown.

You can do the following to quickly avoid the \'could not reliably
determine the fqdn\' message when restarting apache.

    root@debian10:~# echo ServerName debian10 >> /etc/apache2/apache2.conf
    root@debian10:~# service apache2 restart
    Restarting web server: apache2 ... waiting .
    root@debian10:~#

### running apache on CentOS

Starting the `httpd` on RHEL/CentOS is done with the
`service` command.

    [root@centos65 ~]# service httpd status
    httpd is stopped
    [root@centos65 ~]# service httpd start
    Starting httpd: httpd: Could not reliably determine the server's fully qualifie\
    d domain name, using 127.0.0.1 for ServerName
                                                               [  OK  ]
    [root@centos65 ~]#

To verify that `apache` is running, use `ps` or issue the
`service httpd status` command again.

    [root@centos65 ~]# service httpd status
    httpd (pid  2410) is running...
    [root@centos65 ~]# ps -C httpd
      PID TTY          TIME CMD
     2410 ?        00:00:00 httpd
     2412 ?        00:00:00 httpd
     2413 ?        00:00:00 httpd
     2414 ?        00:00:00 httpd
     2415 ?        00:00:00 httpd
     2416 ?        00:00:00 httpd
     2417 ?        00:00:00 httpd
     2418 ?        00:00:00 httpd
     2419 ?        00:00:00 httpd
    [root@centos65 ~]#

To prevent the \'Could not reliably determine the fqdn\' message, issue
the following command.

    [root@centos65 ~]# echo ServerName Centos65 >> /etc/httpd/conf/httpd.conf
    [root@centos65 ~]# service httpd restart
    Stopping httpd:                                            [  OK  ]
    Starting httpd:                                            [  OK  ]
    [root@centos65 ~]#

### index file on CentOS

CentOS does not provide a standard index.html or index.php file. A
simple `wget` gives an error.

    [root@centos65 ~]# wget 127.0.0.1
    --2014-05-06 15:10:22--  http://127.0.0.1/
    Connecting to 127.0.0.1:80... connected.
    HTTP request sent, awaiting response... 403 Forbidden
    2014-05-06 15:10:22 ERROR 403: Forbidden.

Instead when visiting the ip-address of your server in a web browser you
get a `noindex.html` page. You can verify this using `wget`.

    [root@centos65 ~]# wget http://127.0.0.1/error/noindex.html
    --2014-05-06 15:16:05--  http://127.0.0.1/error/noindex.html
    Connecting to 127.0.0.1:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 5039 (4.9K) [text/html]
    Saving to: “noindex.html”

    100%[=============================================>] 5,039       --.-K/s   in 0s

    2014-05-06 15:16:05 (289 MB/s) - “noindex.html” saved [5039/5039]

    [root@centos65 ~]# file noindex.html
    noindex.html: HTML document text
    [root@centos65 ~]#

Any custom `index.html` file in `/var/www/html` will immediately serve
as an index for this web server.

    [root@centos65 ~]# echo 'Welcome to my website' > /var/www/html/index.html
    [root@centos65 ~]# wget http://127.0.0.1
    --2014-05-06 15:19:16--  http://127.0.0.1/
    Connecting to 127.0.0.1:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 22 [text/html]
    Saving to: “index.html”

    100%[=============================================>] 22          --.-K/s   in 0s

    2014-05-06 15:19:16 (1.95 MB/s) - “index.html” saved [22/22]

    [root@centos65 ~]# cat index.html
    Welcome to my website

### default website

Changing the default website of a freshly installed apache web server is
easy. All you need to do is create (or change) an index.html file in the
DocumentRoot directory.

To locate the DocumentRoot directory on Debian:

    root@debian10:~# grep DocumentRoot /etc/apache2/sites-available/default
            DocumentRoot /var/www

This means that `/var/www/index.html` is the default web site.

    root@debian10:~# cat /var/www/index.html
    <html><body><h1>It works!</h1>
    <p>This is the default web page for this server.</p>
    <p>The web server software is running but no content has been added, yet.</p>
    </body></html>
    root@debian10:~#

This screenshot shows how to locate the `DocumentRoot` directory on
RHEL/CentOS.

    [root@centos65 ~]# grep ^DocumentRoot /etc/httpd/conf/httpd.conf
    DocumentRoot "/var/www/html"

RHEL/CentOS have no default web page (only the noindex.html error page
mentioned before). But an `index.html` file created in `/var/www/html/`
will automatically be used as default page.

    [root@centos65 ~]# echo '<html><head><title>Default website</title></head><body\
    ><p>A new web page</p></body></html>' > /var/www/html/index.html
    [root@centos65 ~]# cat /var/www/html/index.html
    <html><head><title>Default website</title></head><body><p>A new web page</p></b\
    ody></html>
    [root@centos65 ~]#

### apache configuration

There are many similarities, but also a couple of differences when
configuring `apache` on Debian or on CentOS. Both Linux families will
get their own chapters with examples.

All configuration on RHEL/CentOS is done in `/etc/httpd`.

    [root@centos65 ~]# ls -l /etc/httpd/
    total 8
    drwxr-xr-x. 2 root root 4096 May  6 13:08 conf
    drwxr-xr-x. 2 root root 4096 May  6 13:08 conf.d
    lrwxrwxrwx. 1 root root   19 May  6 13:08 logs -> ../../var/log/httpd
    lrwxrwxrwx. 1 root root   29 May  6 13:08 modules -> ../../usr/lib64/httpd/modu\
    les
    lrwxrwxrwx. 1 root root   19 May  6 13:08 run -> ../../var/run/httpd
    [root@centos65 ~]#

Debian (and ubuntu/mint/\...) use `/etc/apache2`.

    root@debian10:~# ls -l /etc/apache2/
    total 72
    -rw-r--r-- 1 root root  9659 May  6 14:23 apache2.conf
    drwxr-xr-x 2 root root  4096 May  6 13:19 conf.d
    -rw-r--r-- 1 root root  1465 Jan 31 18:35 envvars
    -rw-r--r-- 1 root root 31063 Jul 20  2013 magic
    drwxr-xr-x 2 root root  4096 May  6 13:19 mods-available
    drwxr-xr-x 2 root root  4096 May  6 13:19 mods-enabled
    -rw-r--r-- 1 root root   750 Jan 26 12:13 ports.conf
    drwxr-xr-x 2 root root  4096 May  6 13:19 sites-available
    drwxr-xr-x 2 root root  4096 May  6 13:19 sites-enabled
    root@debian10:~#

## port virtual hosts on Debian

### default virtual host

Debian has a virtualhost configuration file for its default website in
`/etc/apache2/sites-available/default`.

    root@debian10:~# head -2 /etc/apache2/sites-available/default
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost

### three extra virtual hosts

In this scenario we create three additional websites for three customers
that share a clubhouse and want to jointly hire you. They are a model
train club named `Choo Choo`, a chess club named `Chess Club 42` and a
hackerspace named `hunter2`.

One way to put three websites on one web server, is to put each website
on a different port. This screenshot shows three newly created
`virtual hosts`, one for each customer.

    root@debian10:~# vi /etc/apache2/sites-available/choochoo
    root@debian10:~# cat /etc/apache2/sites-available/choochoo
    <VirtualHost *:7000>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/choochoo
    </VirtualHost>
    root@debian10:~# vi /etc/apache2/sites-available/chessclub42
    root@debian10:~# cat /etc/apache2/sites-available/chessclub42
    <VirtualHost *:8000>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/chessclub42
    </VirtualHost>
    root@debian10:~# vi /etc/apache2/sites-available/hunter2
    root@debian10:~# cat /etc/apache2/sites-available/hunter2
    <VirtualHost *:9000>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/hunter2
    </VirtualHost>

Notice the different port numbers 7000, 8000 and 9000. Notice also that
we specified a unique `DocumentRoot` for each website.

Are you using `Ubuntu` or `Mint`, then these configfiles need to end in
`.conf`.

### three extra ports

We need to enable these three ports on apache in the `ports.conf` file.
Open this file with `vi` and add three lines to `listen` on three extra
ports.

    root@debian10:~# vi /etc/apache2/ports.conf

Verify with `grep` that the `Listen` directives are added correctly.

    root@debian10:~# grep ^Listen /etc/apache2/ports.conf
    Listen 80
    Listen 7000
    Listen 8000
    Listen 9000

### three extra websites

Next we need to create three `DocumentRoot` directories.

    root@debian10:~# mkdir /var/www/choochoo
    root@debian10:~# mkdir /var/www/chessclub42
    root@debian10:~# mkdir /var/www/hunter2

And we have to put some really simple website in those directories.

    root@debian10:~# echo 'Choo Choo model train Choo Choo' > /var/www/choochoo/inde\
    x.html
    root@debian10:~# echo 'Welcome to chess club 42' > /var/www/chessclub42/index.ht\
    ml
    root@debian10:~# echo 'HaCkInG iS fUn At HuNtEr2' > /var/www/hunter2/index.html

### enabling extra websites

The last step is to enable the websites with the `a2ensite` command.
This command will create links in `sites-enabled`.

The links are not there yet\...

    root@debian10:~# cd /etc/apache2/ 
    root@debian10:/etc/apache2# ls sites-available/ 
    chessclub42  choochoo  default  default-ssl  hunter2
    root@debian10:/etc/apache2# ls sites-enabled/ 
    000-default

So we run the `a2ensite` command for all websites.

    root@debian10:/etc/apache2# a2ensite choochoo 
    Enabling site choochoo.
    To activate the new configuration, you need to run:
      service apache2 reload
    root@debian10:/etc/apache2# a2ensite chessclub42 
    Enabling site chessclub42.
    To activate the new configuration, you need to run:
      service apache2 reload
    root@debian10:/etc/apache2# a2ensite hunter2 
    Enabling site hunter2.
    To activate the new configuration, you need to run:
      service apache2 reload

The links are created, so we can tell `apache`.

    root@debian10:/etc/apache2# ls sites-enabled/ 
    000-default  chessclub42  choochoo  hunter2
    root@debian10:/etc/apache2# service apache2 reload 
    Reloading web server config: apache2.
    root@debian10:/etc/apache2#

### testing the three websites

Testing the model train club named `Choo Choo` on port 7000.

    root@debian10:/etc/apache2# wget 127.0.0.1:7000 
    --2014-05-06 21:16:03--  http://127.0.0.1:7000/
    Connecting to 127.0.0.1:7000... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 32 [text/html]
    Saving to: `index.html'

    100%[============================================>] 32          --.-K/s   in 0s

    2014-05-06 21:16:03 (2.92 MB/s) - `index.html' saved [32/32]

    root@debian10:/etc/apache2# cat index.html 
    Choo Choo model train Choo Choo

Testing the chess club named `Chess Club 42` on port 8000.

    root@debian10:/etc/apache2# wget 127.0.0.1:8000 
    --2014-05-06 21:16:20--  http://127.0.0.1:8000/
    Connecting to 127.0.0.1:8000... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 25 [text/html]
    Saving to: `index.html.1'

    100%[===========================================>] 25          --.-K/s   in 0s

    2014-05-06 21:16:20 (2.16 MB/s) - `index.html.1' saved [25/25]

    root@debian10:/etc/apache2# cat index.html.1 
    Welcome to chess club 42

Testing the hacker club named `hunter2` on port 9000.

    root@debian10:/etc/apache2# wget 127.0.0.1:9000 
    --2014-05-06 21:16:30--  http://127.0.0.1:9000/
    Connecting to 127.0.0.1:9000... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 26 [text/html]
    Saving to: `index.html.2'

    100%[===========================================>] 26          --.-K/s   in 0s

    2014-05-06 21:16:30 (2.01 MB/s) - `index.html.2' saved [26/26]

    root@debian10:/etc/apache2# cat index.html.2 
    HaCkInG iS fUn At HuNtEr2

Cleaning up the temporary files.

    root@debian10:/etc/apache2# rm index.html index.html.1 index.html.2 

Try testing from another computer using the ip-address of your server.

## named virtual hosts on Debian

### named virtual hosts

The chess club and the model train club find the port numbers too hard
to remember. They would prefere to have their website accessible by
name.

We continue work on the same server that has three websites on three
ports. We need to make sure those websites are accesible using the names
`choochoo.local`, `chessclub42.local` and `hunter2.local`.

We start by creating three new virtualhosts.

    root@debian10:/etc/apache2/sites-available# vi choochoo.local 
    root@debian10:/etc/apache2/sites-available# vi chessclub42.local 
    root@debian10:/etc/apache2/sites-available# vi hunter2.local 
    root@debian10:/etc/apache2/sites-available# cat choochoo.local 
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            ServerName choochoo.local
            DocumentRoot /var/www/choochoo
    </VirtualHost>
    root@debian10:/etc/apache2/sites-available# cat chessclub42.local 
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            ServerName chessclub42.local
            DocumentRoot /var/www/chessclub42
    </VirtualHost>
    root@debian10:/etc/apache2/sites-available# cat hunter2.local 
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            ServerName hunter2.local
            DocumentRoot /var/www/hunter2
    </VirtualHost>
    root@debian10:/etc/apache2/sites-available#

Notice that they all listen on `port 80` and have an extra `ServerName`
directive.

### name resolution

We need some way to resolve names. This can be done with DNS, which is
discussed in another chapter. For this demo it is also possible to
quickly add the three names to the `/etc/hosts` file.

    root@debian10:/etc/apache2/sites-available# grep ^192 /etc/hosts 
    192.168.42.50 choochoo.local
    192.168.42.50 chessclub42.local
    192.168.42.50 hunter2.local

Note that you may have another ip address\...

### enabling virtual hosts

Next we enable them with `a2ensite`.

    root@debian10:/etc/apache2/sites-available# a2ensite choochoo.local 
    Enabling site choochoo.local.
    To activate the new configuration, you need to run:
      service apache2 reload
    root@debian10:/etc/apache2/sites-available# a2ensite chessclub42.local 
    Enabling site chessclub42.local.
    To activate the new configuration, you need to run:
      service apache2 reload
    root@debian10:/etc/apache2/sites-available# a2ensite hunter2.local 
    Enabling site hunter2.local.
    To activate the new configuration, you need to run:
      service apache2 reload

### reload and verify

After a `service apache2 reload` the websites should be available by
name.

    root@debian10:/etc/apache2/sites-available# service apache2 reload
    Reloading web server config: apache2.
    root@debian10:/etc/apache2/sites-available# wget chessclub42.local 
    --2014-05-06 21:37:13--  http://chessclub42.local/
    Resolving chessclub42.local (chessclub42.local)... 192.168.42.50
    Connecting to chessclub42.local (chessclub42.local)|192.168.42.50|:80... conne\
    cted.
    HTTP request sent, awaiting response... 200 OK
    Length: 25 [text/html]
    Saving to: `index.html'

    100%[=============================================>] 25         --.-K/s   in 0s

    2014-05-06 21:37:13 (2.06 MB/s) - `index.html' saved [25/25]

    root@debian10:/etc/apache2/sites-available# cat index.html 
    Welcome to chess club 42

## password protected website on Debian

You can secure files and directories in your website with a `.htaccess`
file that refers to a `.htpasswd` file. The `htpasswd`
command can create a `.htpasswd` file that contains a
userid and an (encrypted) password.

This screenshot creates a user and password for the hacker named `cliff`
and uses the `-c` flag to create the `.htpasswd` file.

    root@debian10:~# htpasswd -c /var/www/.htpasswd cliff 
    New password:
    Re-type new password:
    Adding password for user cliff
    root@debian10:~# cat /var/www/.htpasswd
    cliff:$apr1$vujll0KL$./SZ4w9q0swhX93pQ0PVp.

Hacker `rob` also wants access, this screenshot shows how to add a
second user and password to `.htpasswd`.

    root@debian10:~# htpasswd /var/www/.htpasswd rob 
    New password:
    Re-type new password:
    Adding password for user rob
    root@debian10:~# cat /var/www/.htpasswd 
    cliff:$apr1$vujll0KL$./SZ4w9q0swhX93pQ0PVp.
    rob:$apr1$HNln1FFt$nRlpF0H.IW11/1DRq4lQo0

Both Cliff and Rob chose the same password (hunter2), but that is not
visible in the `.htpasswd` file because of the different salts.

Next we need to create a `.htaccess` file in the `DocumentRoot` of the
website we want to protect. This screenshot shows an example.

    root@debian10:~# cd /var/www/hunter2/ 
    root@debian10:/var/www/hunter2# cat .htaccess 
    AuthUserFile /var/www/.htpasswd
    AuthName "Members only!"
    AuthType Basic
    require valid-user

Note that we are protecting the website on `port 9000` that we created
earlier.

And because we put the website for the Hackerspace named hunter2 in a
subdirectory of the default website, we will need to adjust the
`AllowOvveride` parameter in `/etc/apache2/sites-available/default` as
this screenshot shows (with line numbers on debian10, your may vary).

    9         <Directory /var/www/>
    10                 Options Indexes FollowSymLinks MultiViews
    11                 AllowOverride Authconfig
    12                 Order allow,deny
    13                 allow from all
    14         </Directory

Now restart the apache2 server and test that it works!

## port virtual hosts on CentOS

### default virtual host

Unlike Debian, CentOS has no virtualHost configuration file for its
default website. Instead the default configuration will throw a standard
error page when no index file can be found in the default location
(/var/www/html).

### three extra virtual hosts

In this scenario we create three additional websites for three customers
that share a clubhouse and want to jointly hire you. They are a model
train club named `Choo Choo`, a chess club named `Chess Club 42` and a
hackerspace named `hunter2`.

One way to put three websites on one web server, is to put each website
on a different port. This screenshot shows three newly created
`virtual hosts`, one for each customer.

    [root@CentOS65 ~]# vi /etc/httpd/conf.d/choochoo.conf
    [root@CentOS65 ~]# cat /etc/httpd/conf.d/choochoo.conf
    <VirtualHost *:7000>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/html/choochoo
    </VirtualHost>
    [root@CentOS65 ~]# vi /etc/httpd/conf.d/chessclub42.conf
    [root@CentOS65 ~]# cat /etc/httpd/conf.d/chessclub42.conf
    <VirtualHost *:8000>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/html/chessclub42
    </VirtualHost>
    [root@CentOS65 ~]# vi /etc/httpd/conf.d/hunter2.conf
    [root@CentOS65 ~]# cat /etc/httpd/conf.d/hunter2.conf
    <VirtualHost *:9000>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/html/hunter2
    </VirtualHost>

Notice the different port numbers 7000, 8000 and 9000. Notice also that
we specified a unique `DocumentRoot` for each website.

### three extra ports

We need to enable these three ports on apache in the `httpd.conf` file.

    [root@CentOS65 ~]# vi /etc/httpd/conf/httpd.conf
    root@debian10:~# grep ^Listen /etc/httpd/conf/httpd.conf
    Listen 80
    Listen 7000
    Listen 8000
    Listen 9000

### SELinux guards our ports

If we try to restart our server, we will notice the following error:

    [root@CentOS65 ~]# service httpd restart
    Stopping httpd:                                            [  OK  ]
    Starting httpd: 
           (13)Permission denied: make_sock: could not bind to address 0.0.0.0:7000
    no listening sockets available, shutting down
                                                               [FAILED]

This is due to SELinux reserving ports 7000 and 8000 for other uses. We
need to tell SELinux we want to use these ports for http traffic

    [root@CentOS65 ~]# semanage port -m -t http_port_t -p tcp 7000
    [root@CentOS65 ~]# semanage port -m -t http_port_t -p tcp 8000
    [root@CentOS65 ~]# service httpd restart
    Stopping httpd:                                            [  OK  ]
    Starting httpd:                                            [  OK  ]

### three extra websites

Next we need to create three `DocumentRoot` directories.

    [root@CentOS65 ~]# mkdir /var/www/html/choochoo
    [root@CentOS65 ~]# mkdir /var/www/html/chessclub42
    [root@CentOS65 ~]# mkdir /var/www/html/hunter2

And we have to put some really simple website in those directories.

    [root@CentOS65 ~]# echo 'Choo Choo model train Choo Choo' > /var/www/html/chooc\
    hoo/index.html
    [root@CentOS65 ~]# echo 'Welcome to chess club 42' > /var/www/html/chessclub42/\
    index.html
    [root@CentOS65 ~]# echo 'HaCkInG iS fUn At HuNtEr2' > /var/www/html/hunter2/ind\
    ex.html

### enabling extra websites

The only way to enable or disable configurations in RHEL/CentOS is by
renaming or moving the configuration files. Any file in
/etc/httpd/conf.d ending on .conf will be loaded by Apache. To disable a
site we can either rename the file or move it to another directory.

The files are created, so we can tell `apache`.

    [root@CentOS65 ~]# ls /etc/httpd/conf.d/
    chessclub42.conf  choochoo.conf  hunter2.conf  README  welcome.conf
    [root@CentOS65 ~]# service httpd reload
    Reloading httpd: 

### testing the three websites

Testing the model train club named `Choo Choo` on port 7000.

    [root@CentOS65 ~]# wget 127.0.0.1:7000
    --2014-05-11 11:59:36--  http://127.0.0.1:7000/
    Connecting to 127.0.0.1:7000... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 32 [text/html]
    Saving to: `index.html'

    100%[===========================================>] 32          --.-K/s   in 0s

    2014-05-11 11:59:36 (4.47 MB/s) - `index.html' saved [32/32]

    [root@CentOS65 ~]# cat index.html 
    Choo Choo model train Choo Choo

Testing the chess club named `Chess Club 42` on port 8000.

    [root@CentOS65 ~]# wget 127.0.0.1:8000
    --2014-05-11 12:01:30--  http://127.0.0.1:8000/
    Connecting to 127.0.0.1:8000... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 25 [text/html]
    Saving to: `index.html.1'

    100%[===========================================>] 25          --.-K/s   in 0s

    2014-05-11 12:01:30 (4.25 MB/s) - `index.html.1' saved [25/25]

    root@debian10:/etc/apache2# cat index.html.1 
    Welcome to chess club 42

Testing the hacker club named `hunter2` on port 9000.

    [root@CentOS65 ~]# wget 127.0.0.1:9000 
    --2014-05-11 12:02:37--  http://127.0.0.1:9000/
    Connecting to 127.0.0.1:9000... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 26 [text/html]
    Saving to: `index.html.2'

    100%[===========================================>] 26          --.-K/s   in 0s

    2014-05-11 12:02:37 (4.49 MB/s) - `index.html.2' saved [26/26]

    root@debian10:/etc/apache2# cat index.html.2 
    HaCkInG iS fUn At HuNtEr2

Cleaning up the temporary files.

    [root@CentOS65 ~]# rm index.html index.html.1 index.html.2 

### firewall rules

If we attempt to access the site from another machine however, we will
not be able to view the website yet. The firewall is blocking incoming
connections. We need to open these incoming ports first

    [root@CentOS65 ~]# iptables -I INPUT -p tcp --dport 80 -j ACCEPT
    [root@CentOS65 ~]# iptables -I INPUT -p tcp --dport 7000 -j ACCEPT
    [root@CentOS65 ~]# iptables -I INPUT -p tcp --dport 8000 -j ACCEPT
    [root@CentOS65 ~]# iptables -I INPUT -p tcp --dport 9000 -j ACCEPT

And if we want these rules to remain active after a reboot, we need to
save them

    [root@CentOS65 ~]# service iptables save
    iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]

## named virtual hosts on CentOS

### named virtual hosts

The chess club and the model train club find the port numbers too hard
to remember. They would prefere to have their website accessible by
name.

We continue work on the same server that has three websites on three
ports. We need to make sure those websites are accesible using the names
`choochoo.local`, `chessclub42.local` and `hunter2.local`.

First, we need to enable named virtual hosts in the configuration

    [root@CentOS65 ~]# vi /etc/httpd/conf/httpd.conf
    [root@CentOS65 ~]# grep ^NameVirtualHost /etc/httpd/conf/httpd.conf
    NameVirtualHost *:80
    [root@CentOS65 ~]#

Next we need to create three new virtualhosts.

    [root@CentOS65 ~]# vi /etc/httpd/conf.d/choochoo.local.conf
    [root@CentOS65 ~]# vi /etc/httpd/conf.d/chessclub42.local.conf
    [root@CentOS65 ~]# vi /etc/httpd/conf.d/hunter2.local.conf
    [root@CentOS65 ~]# cat /etc/httpd/conf.d/choochoo.local.conf
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            ServerName choochoo.local
            DocumentRoot /var/www/html/choochoo
    </VirtualHost>
    [root@CentOS65 ~]# cat /etc/httpd/conf.d/chessclub42.local.conf
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            ServerName chessclub42.local
            DocumentRoot /var/www/html/chessclub42
    </VirtualHost>
    [root@CentOS65 ~]# cat /etc/httpd/conf.d/hunter2.local.conf
    <VirtualHost *:80>
            ServerAdmin webmaster@localhost
            ServerName hunter2.local
            DocumentRoot /var/www/html/hunter2
    </VirtualHost>
    [root@CentOS65 ~]#

Notice that they all listen on `port 80` and have an extra `ServerName`
directive.

### name resolution

We need some way to resolve names. This can be done with DNS, which is
discussed in another chapter. For this demo it is also possible to
quickly add the three names to the `/etc/hosts` file.

    [root@CentOS65 ~]# grep ^192 /etc/hosts
    192.168.1.225 choochoo.local
    192.168.1.225 chessclub42.local
    192.168.1.225 hunter2.local

Note that you may have another ip address\...

### reload and verify

After a `service httpd reload` the websites should be available by name.

    [root@CentOS65 ~]# service httpd reload
    Reloading httpd: 
    [root@CentOS65 ~]# wget chessclub42.local
    --2014-05-25 16:59:14--  http://chessclub42.local/
    Resolving chessclub42.local... 192.168.1.225
    Connecting to chessclub42.local|192.168.1.225|:80... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 25 [text/html]
    Saving to: âindex.htmlâ

    100%[=============================================>] 25          --.-K/s   in 0s      

    2014-05-25 16:59:15 (1014 KB/s) - `index.html' saved [25/25]

    [root@CentOS65 ~]# cat index.html
    Welcome to chess club 42

## password protected website on CentOS

You can secure files and directories in your website with a `.htaccess`
file that refers to a `.htpasswd` file. The `htpasswd`
command can create a `.htpasswd` file that contains a
userid and an (encrypted) password.

This screenshot creates a user and password for the hacker named `cliff`
and uses the `-c` flag to create the `.htpasswd` file.

    [root@CentOS65 ~]# htpasswd -c /var/www/.htpasswd cliff
    New password: 
    Re-type new password: 
    Adding password for user cliff
    [root@CentOS65 ~]# cat /var/www/.htpasswd
    cliff:QNwTrymMLBctU

Hacker `rob` also wants access, this screenshot shows how to add a
second user and password to `.htpasswd`.

    [root@CentOS65 ~]# htpasswd /var/www/.htpasswd rob
    New password: 
    Re-type new password: 
    Adding password for user rob
    [root@CentOS65 ~]# cat /var/www/.htpasswd
    cliff:QNwTrymMLBctU
    rob:EC2vOCcrMXDoM
    [root@CentOS65 ~]#

Both Cliff and Rob chose the same password (hunter2), but that is not
visible in the `.htpasswd` file because of the different salts.

Next we need to create a `.htaccess` file in the `DocumentRoot` of the
website we want to protect. This screenshot shows an example.

    [root@CentOS65 ~]# cat /var/www/html/hunter2/.htaccess 
    AuthUserFile /var/www/.htpasswd
    AuthName "Members only!"
    AuthType Basic
    require valid-user

Note that we are protecting the website on `port 9000` that we created
earlier.

And because we put the website for the Hackerspace named hunter2 in a
subdirectory of the default website, we will need to adjust the
`AllowOvveride` parameter in `/etc/httpd/conf/httpd.conf` under the
`<Directory "/var/www/html">` directive as this screenshot shows.

    [root@CentOS65 ~]# vi /etc/httpd/conf/httpd.conf

    <Directory "/var/www/html">

    # 
    # Possible values for the Options directive are "None", "All",
    # or any combination of:
    #   Indexes Includes FollowSymLinks SymLinksifOwnerMatch ExecCGI MultiViews
    # 
    # Note that "MultiViews" must be named *explicitly* --- "Options All"
    # doesn't give it to you.
    # 
    # The Options directive is both complicated and important.  Please see
    # http://httpd.apache.org/docs/2.2/mod/core.html#options
    # for more information.
    # 
        Options Indexes FollowSymLinks

    # 
    # AllowOverride controls what directives may be placed in .htaccess files.
    # It can be "All", "None", or any combination of the keywords:
    #   Options FileInfo AuthConfig Limit
    #  
        AllowOverride Authconfig

    # 
    # Controls who can get stuff from this server.
    # 
        Order allow,deny
        Allow from all

    </Directory>

Now restart the apache2 server and test that it works!

## troubleshooting apache

When apache restarts, it will verify the syntax of files in the
configuration folder `/etc/apache2` on debian or `/etc/httpd` on CentOS
and it will tell you the name of the faulty file, the line number and an
explanation of the error.

    root@debian10:~# service apache2 restart
    apache2: Syntax error on line 268 of /etc/apache2/apache2.conf: Syntax error o\
    n line 1 of /etc/apache2/sites-enabled/chessclub42: /etc/apache2/sites-enabled\
    /chessclub42:4: <VirtualHost> was not closed.\n/etc/apache2/sites-enabled/ches\
    sclub42:1: <VirtualHost> was not closed.
    Action 'configtest' failed.
    The Apache error log may have more information.
     failed!

Below you see the problem\... a missing / before on line 4.

    root@debian10:~# cat /etc/apache2/sites-available/chessclub42
    <VirtualHost *:8000>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/chessclub42
    <VirtualHost>

Let us force another error by renaming the directory of one of our
websites:

    root@debian10:~# mv /var/www/choochoo/ /var/www/chooshoo
    root@debian10:~# !ser
    service apache2 restart
    Restarting web server: apache2Warning: DocumentRoot [/var/www/choochoo] does n\
    ot exist
    Warning: DocumentRoot [/var/www/choochoo] does not exist
     ... waiting Warning: DocumentRoot [/var/www/choochoo] does not exist
    Warning: DocumentRoot [/var/www/choochoo] does not exist
    .

As you can see, apache will tell you exactly what is wrong.

You can also troubleshoot by connecting to the website via a browser and
then checking the apache log files in `/var/log/apache`.

## virtual hosts example

Below is a sample virtual host configuration. This virtual hosts
overrules the default Apache `ErrorDocument` directive.

    <VirtualHost 83.217.76.245:80>
    ServerName cobbaut.be
    ServerAlias www.cobbaut.be
    DocumentRoot /home/paul/public_html
    ErrorLog /home/paul/logs/error_log
    CustomLog /home/paul/logs/access_log common
    ScriptAlias /cgi-bin/ /home/paul/cgi-bin/
    <Directory /home/paul/public_html>
        Options Indexes IncludesNOEXEC FollowSymLinks
        allow from all
    </Directory>
    ErrorDocument 404 http://www.cobbaut.be/cobbaut.php
    </VirtualHost>
            

## aliases and redirects

Apache supports aliases for directories, like this example shows.

    Alias /paul/ "/home/paul/public_html/"

Similarly, content can be redirected to another website or web server.

    Redirect permanent /foo http://www.foo.com/bar

## more on .htaccess

You can do much more with `.htaccess`. One example is to
use .htaccess to prevent people from certain domains to access your
website. Like in this case, where a number of referer spammers are
blocked from the website.

    paul@lounge:~/cobbaut.be$ cat .htaccess 
    # Options +FollowSymlinks
    RewriteEngine On
    RewriteCond %{HTTP_REFERER} ^http://(www\.)?buy-adipex.fw.nu.*$ [OR]
    RewriteCond %{HTTP_REFERER} ^http://(www\.)?buy-levitra.asso.ws.*$ [NC,OR]
    RewriteCond %{HTTP_REFERER} ^http://(www\.)?buy-tramadol.fw.nu.*$ [NC,OR]
    RewriteCond %{HTTP_REFERER} ^http://(www\.)?buy-viagra.lookin.at.*$ [NC,OR]
    ...
    RewriteCond %{HTTP_REFERER} ^http://(www\.)?www.healthinsurancehelp.net.*$ [NC]
    RewriteRule .* - [F,L]
    paul@lounge:~/cobbaut.be$

## traffic

Apache keeps a log of all visitors. The `webalizer` is
often used to parse this log into nice html statistics.

## self signed cert on Debian

Below is a very quick guide on setting up Apache2 on Debian 7 with a
self-signed certificate.

Chances are these packages are already installed.

    root@debian10:~# aptitude install apache2 openssl
    No packages will be installed, upgraded, or removed.
    0 packages upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    Need to get 0 B of archives. After unpacking 0 B will be used.

Create a directory to store the certs, and use `openssl` to create a
self signed cert that is valid for 999 days.

    root@debian10:~# mkdir /etc/ssl/localcerts
    root@debian10:~# openssl req -new -x509 -days 999 -nodes -out /etc/ssl/local\
    certs/apache.pem -keyout /etc/ssl/localcerts/apache.key
    Generating a 2048 bit RSA private key
    ...
    ...
    writing new private key to '/etc/ssl/localcerts/apache.key'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [AU]:BE
    State or Province Name (full name) [Some-State]:Antwerp
    Locality Name (eg, city) []:Antwerp
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:linux-training.be
    Organizational Unit Name (eg, section) []:
    Common Name (e.g. server FQDN or YOUR name) []:Paul
    Email Address []:

A little security never hurt anyone.

    root@debian10:~# ls -l /etc/ssl/localcerts/
    total 8
    -rw-r--r-- 1 root root 1704 Sep 16 18:24 apache.key
    -rw-r--r-- 1 root root 1302 Sep 16 18:24 apache.pem
    root@debian10:~# chmod 600 /etc/ssl/localcerts/*
    root@debian10:~# ls -l /etc/ssl/localcerts/
    total 8
    -rw------- 1 root root 1704 Sep 16 18:24 apache.key
    -rw------- 1 root root 1302 Sep 16 18:24 apache.pem

Enable the `apache ssl mod`.

    root@debian10:~# a2enmod ssl
    Enabling module ssl.
    See /usr/share/doc/apache2.2-common/README.Debian.gz on how to configure SSL\
     and create self-signed certificates.
    To activate the new configuration, you need to run:
      service apache2 restart

Create the website configuration.

    root@debian10:~# vi /etc/apache2/sites-available/choochoos
    root@debian10:~# cat /etc/apache2/sites-available/choochoos
    <VirtualHost *:7000>
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/choochoos
            SSLEngine On
            SSLCertificateFile /etc/ssl/localcerts/apache.pem
            SSLCertificateKeyFile /etc/ssl/localcerts/apache.key
    </VirtualHost>
    root@debian10:~#

And create the website itself.

    root@debian10:/var/www/choochoos# vi index.html
    root@debian10:/var/www/choochoos# cat index.html
    Choo Choo HTTPS secured model train Choo Choo

Enable the website and restart (or reload) apache2.

    root@debian10:/var/www/choochoos# a2ensite choochoos
    Enabling site choochoos.
    To activate the new configuration, you need to run:
      service apache2 reload
    root@debian10:/var/www/choochoos# service apache2 restart
    Restarting web server: apache2 ... waiting .

Chances are your browser will warn you about the self signed
certificate.

![](images/apache_selfsigned.png)

## self signed cert on RHEL/CentOS

Below is a quick way to create a self signed cert for https on
RHEL/CentOS. You may need these packages:

    [root@paulserver ~]# yum install httpd openssl mod_ssl
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
     * base: ftp.belnet.be
     * extras: ftp.belnet.be
     * updates: mirrors.vooservers.com
    base                                                         | 3.7 kB     00:00
    Setting up Install Process
    Package httpd-2.2.15-31.el6.centos.x86_64 already installed and latest version
    Package openssl-1.0.1e-16.el6_5.15.x86_64 already installed and latest version
    Package 1:mod_ssl-2.2.15-31.el6.centos.x86_64 already ins... and latest version
    Nothing to do

We use `openssl` to create the certificate.

    [root@paulserver ~]# mkdir certs
    [root@paulserver ~]# cd certs
    [root@paulserver certs]# openssl genrsa -out ca.key 2048
    Generating RSA private key, 2048 bit long modulus
    .........+++
    .........................................................+++
    e is 65537 (0x10001)
    [root@paulserver certs]# openssl req -new -key ca.key -out ca.csr
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [XX]:BE
    State or Province Name (full name) []:antwerp
    Locality Name (eg, city) [Default City]:antwerp
    Organization Name (eg, company) [Default Company Ltd]:antwerp
    Organizational Unit Name (eg, section) []:
    Common Name (eg, your name or your server's hostname) []:paulserver
    Email Address []:

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:
    [root@paulserver certs]# openssl x509 -req -days 365 -in ca.csr -signkey ca.ke\
    y -out ca.crt
    Signature ok
    subject=/C=BE/ST=antwerp/L=antwerp/O=antwerp/CN=paulserver
    Getting Private key

We copy the keys to the right location (You may be missing SELinux info
here).

    [root@paulserver certs]# cp ca.crt /etc/pki/tls/certs/
    [root@paulserver certs]# cp ca.key ca.csr /etc/pki/tls/private/

We add the location of our keys to this file, and also add the
`NameVirtualHost *:443` directive.

    [root@paulserver certs]# vi /etc/httpd/conf.d/ssl.conf
    [root@paulserver certs]# grep ^SSLCerti /etc/httpd/conf.d/ssl.conf
    SSLCertificateFile /etc/pki/tls/certs/ca.crt
    SSLCertificateKeyFile /etc/pki/tls/private/ca.key

Create a website configuration.

    [root@paulserver certs]# vi /etc/httpd/conf.d/choochoos.conf
    [root@paulserver certs]# cat /etc/httpd/conf.d/choochoos.conf
    <VirtualHost *:443>
            SSLEngine on
            SSLCertificateFile /etc/pki/tls/certs/ca.crt
            SSLCertificateKeyFile /etc/pki/tls/private/ca.key
            DocumentRoot /var/www/choochoos
            ServerName paulserver
    </VirtualHost>
    [root@paulserver certs]#

Create a simple website and restart apache.

    [root@paulserver certs]# mkdir /var/www/choochoos
    [root@paulserver certs]# echo HTTPS model train choochoos > /var/www/choochoos/\
    index.html
    [root@paulserver httpd]# service httpd restart
    Stopping httpd:                                            [  OK  ]
    Starting httpd:                                            [  OK  ]

And your browser will probably warn you that this certificate is self
signed.

![](images/apache_selfsigned_centos.png)
