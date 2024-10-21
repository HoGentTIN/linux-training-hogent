## Installing MySQL

On Ubuntu or Enterprise Linux you can install the package `mysql-server` with a package manager. This will install both the MySQL server and client application.

On recent versions of Debian (e.g. 12), the package `mysql-server` is *not* available in the default repositories. You can download a .deb package from the MySQL website, or use the MariaDB package instead by installing the package `default-mysql-server`.

On recent versions of Fedora (e.g. 39), installing the package `mysql-server` will in fact install MariaDB instead of MySQL. You can install MySQL from the package `community-mysql-server` or download a package from the MySQL website.

For example, the installation on Ubuntu 24.04 LTS:

```console
student@ubuntu:~$ sudo apt install mysql-server
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libcgi-fast-perl libcgi-pm-perl libclone-perl libencode-locale-perl libevent-pthreads-2.1-7t64 libfcgi-bin libfcgi-perl libfcgi0t64 libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
  libhttp-date-perl libhttp-message-perl libio-html-perl liblwp-mediatypes-perl libmecab2 libprotobuf-lite32t64 libtimedate-perl liburi-perl mecab-ipadic mecab-ipadic-utf8 mecab-utils mysql-client-8.0
  mysql-client-core-8.0 mysql-common mysql-server-8.0 mysql-server-core-8.0
Suggested packages:
  libdata-dump-perl libipc-sharedcache-perl libio-compress-brotli-perl libbusiness-isbn-perl libregexp-ipv6-perl libwww-perl mailx tinyca
The following NEW packages will be installed:
  libcgi-fast-perl libcgi-pm-perl libclone-perl libencode-locale-perl libevent-pthreads-2.1-7t64 libfcgi-bin libfcgi-perl libfcgi0t64 libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl
  libhttp-date-perl libhttp-message-perl libio-html-perl liblwp-mediatypes-perl libmecab2 libprotobuf-lite32t64 libtimedate-perl liburi-perl mecab-ipadic mecab-ipadic-utf8 mecab-utils mysql-client-8.0
  mysql-client-core-8.0 mysql-common mysql-server mysql-server-8.0 mysql-server-core-8.0
0 upgraded, 28 newly installed, 0 to remove and 175 not upgraded.
Need to get 29.6 MB of archives.
After this operation, 242 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu noble/main amd64 mysql-common all 5.8+1.1.0build1 [6,746 B]
[...some output omitted...]
student@ubuntu:~$ systemctl status mysql
● mysql.service - MySQL Community Server
     Loaded: loaded (/usr/lib/systemd/system/mysql.service; enabled; preset: enabled)
     Active: active (running) since Wed 2024-10-09 09:50:34 UTC; 1min 40s ago
    Process: 2527 ExecStartPre=/usr/share/mysql/mysql-systemd-start pre (code=exited, status=0/SUCCESS)
   Main PID: 2536 (mysqld)
     Status: "Server is operational"
      Tasks: 37 (limit: 2275)
     Memory: 365.2M (peak: 379.5M)
        CPU: 1.568s
     CGroup: /system.slice/mysql.service
             └─2536 /usr/sbin/mysqld

Oct 09 09:50:34 ubuntu systemd[1]: Starting mysql.service - MySQL Community Server...
Oct 09 09:50:34 ubuntu systemd[1]: Started mysql.service - MySQL Community Server.
```

As you can see, the database server is started immediately on Ubuntu. This will not be the case on Enterprise Linux, where you have to start the service manually:

```console
[student@el ~]$ sudo dnf install -y mysql-server
[...output omitted...]
[student@el ~]$ systemctl status mysqld.service 
○ mysqld.service - MySQL 8.0 database server
     Loaded: loaded (/usr/lib/systemd/system/mysqld.service; disabled; preset: disabled)
     Active: inactive (dead)
[student@el ~]$ sudo systemctl enable --now mysqld.service 
Created symlink /etc/systemd/system/multi-user.target.wants/mysqld.service → /usr/lib/systemd/system/mysqld.service.
[student@el ~]$ systemctl status mysqld.service 
● mysqld.service - MySQL 8.0 database server
     Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; preset: disabled)
     Active: active (running) since Wed 2024-10-09 09:56:00 UTC; 2s ago
    Process: 7915 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
    Process: 7937 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mysqld.service (code=exited, status=0/SUCCESS)
   Main PID: 8011 (mysqld)
     Status: "Server is operational"
      Tasks: 38 (limit: 11128)
     Memory: 455.9M
        CPU: 2.541s
     CGroup: /system.slice/mysqld.service
             └─8011 /usr/libexec/mysqld --basedir=/usr
```

To verify the installed version, use `dpkg -l` on Ubuntu:

```console
student@ubuntu:~$ dpkg -l mysql-server | tail -1 | awk '{ print $2,$3 }'
mysql-server 8.0.39-0ubuntu0.24.04.2
```

Issue `rpm -q` to get version information about MySQL on Enterprise Linux:

```console
[student@el ~]$ rpm -q mysql-server
mysql-server-8.0.36-1.el9_3.x86_64
```

Finally, to check if MySQL is listening on a network socket (and which one), use `ss`:

```console
[student@el ~]$ sudo ss -tlnp
State   Recv-Q  Send-Q Local Address:Port  Peer Address:Port  Process                                                                       
LISTEN  0       128          0.0.0.0:22         0.0.0.0:*      users:(("sshd",pid=629,fd=3))                                                
LISTEN  0       4096         0.0.0.0:111        0.0.0.0:*      users:(("rpcbind",pid=517,fd=4),("systemd",pid=1,fd=31))                     
LISTEN  0       70                 *:33060            *:*      users:(("mysqld",pid=847,fd=21))                                             
LISTEN  0       151                *:3306             *:*      users:(("mysqld",pid=847,fd=23))                                             
LISTEN  0       128             [::]:22            [::]:*      users:(("sshd",pid=629,fd=4))                                                
LISTEN  0       4096            [::]:111           [::]:*      users:(("rpcbind",pid=517,fd=6),("systemd",pid=1,fd=34)) 
```

MySQL listens on port 3306 by default. Some systems may have a default configuration causing the service to only listen on the loopback interface. We'll discuss below how to change this. In this example, we see that MySQL listens on all interfaces (`*:3306`). It also listens on port 33060, which is used for the X Protocol, a new protocol used by MySQL Shell.

## Installing MariaDB

On Debian, the package `mysql-server` is *not* available. You can install the package `default-mysql-server` or `mariadb-server` instead, which has the same result.

```console
student@debian:~$ sudo apt install default-mysql-server
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  galera-4 gawk libcgi-fast-perl libcgi-pm-perl libclone-perl libconfig-inifiles-perl libdaxctl1 libdbd-mariadb-perl libdbi-perl libencode-locale-perl libfcgi-bin libfcgi-perl libfcgi0ldbl libgpm2
  libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl libhttp-date-perl libhttp-message-perl libio-html-perl liblwp-mediatypes-perl liblzo2-2 libmariadb3 libncurses6 libndctl6 libpmem1
  libregexp-ipv6-perl libsigsegv2 libsnappy1v5 libterm-readkey-perl libtimedate-perl liburi-perl liburing2 mariadb-client mariadb-client-core mariadb-common mariadb-plugin-provider-bzip2
  mariadb-plugin-provider-lz4 mariadb-plugin-provider-lzma mariadb-plugin-provider-lzo mariadb-plugin-provider-snappy mariadb-server mariadb-server-core mysql-common psmisc pv socat
Suggested packages:
  gawk-doc libmldbm-perl libnet-daemon-perl libsql-statement-perl gpm libdata-dump-perl libipc-sharedcache-perl libbusiness-isbn-perl libwww-perl mailx mariadb-test netcat-openbsd doc-base
The following NEW packages will be installed:
  default-mysql-server galera-4 gawk libcgi-fast-perl libcgi-pm-perl libclone-perl libconfig-inifiles-perl libdaxctl1 libdbd-mariadb-perl libdbi-perl libencode-locale-perl libfcgi-bin libfcgi-perl
  libfcgi0ldbl libgpm2 libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl libhttp-date-perl libhttp-message-perl libio-html-perl liblwp-mediatypes-perl liblzo2-2 libmariadb3 libncurses6 libndctl6
  libpmem1 libregexp-ipv6-perl libsigsegv2 libsnappy1v5 libterm-readkey-perl libtimedate-perl liburi-perl liburing2 mariadb-client mariadb-client-core mariadb-common mariadb-plugin-provider-bzip2
  mariadb-plugin-provider-lz4 mariadb-plugin-provider-lzma mariadb-plugin-provider-lzo mariadb-plugin-provider-snappy mariadb-server mariadb-server-core mysql-common psmisc pv socat
0 upgraded, 48 newly installed, 0 to remove and 58 not upgraded.
Need to get 19.4 MB of archives.
After this operation, 196 MB of additional disk space will be used.
Do you want to continue? [Y/n]
```

On EL (including Fedora), install Mariadb with `sudo dnf install mariadb-server`.

Again, on Debian, the service will be started automatically, while on EL, you have to do this yourself.

```console
[student@fedora ~]$ sudo dnf install mariadb-server
[...output omitted...]
[student@fedora ~]$ systemctl status mariadb.service
○ mariadb.service - MariaDB 10.5 database server
     Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; preset: disabled)
    Drop-In: /usr/lib/systemd/system/service.d
             └─10-timeout-abort.conf
     Active: inactive (dead)
       Docs: man:mariadbd(8)
             https://mariadb.com/kb/en/library/systemd/
[student@fedora ~]$ sudo systemctl enable --now mariadb.service
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
[student@fedora ~]$ systemctl status mariadb.service
● mariadb.service - MariaDB 10.5 database server
     Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; preset: disabled)
    Drop-In: /usr/lib/systemd/system/service.d
             └─10-timeout-abort.conf
     Active: active (running) since Wed 2024-10-09 10:10:41 UTC; 1s ago
       Docs: man:mariadbd(8)
             https://mariadb.com/kb/en/library/systemd/
    Process: 4593 ExecStartPre=/usr/libexec/mariadb-check-socket (code=exited, status=0/SUCCESS)
    Process: 4616 ExecStartPre=/usr/libexec/mariadb-prepare-db-dir mariadb.service (code=exited, status=0/SUCCESS)
    Process: 4717 ExecStartPost=/usr/libexec/mariadb-check-upgrade (code=exited, status=0/SUCCESS)
   Main PID: 4699 (mariadbd)
     Status: "Taking your SQL requests now..."
      Tasks: 15 (limit: 2322)
     Memory: 66.2M
        CPU: 357ms
     CGroup: /system.slice/mariadb.service
             └─4699 /usr/libexec/mariadbd --basedir=/usr
```

## Securing MySQL/MariaDB

After installation, some default settings are in place that are not very secure. For example, MySQL has its own user management system, which is separate from the Linux users. It also has a root/admin user and initially, the password is empty.

You can (and should) run the `mysql_secure_installation` script to improve security. This script will ask you to set a root password, remove anonymous users, disallow root login remotely and remove the test database.

Remark that for MariaDB, the script is also called `mysql_secure_installation` (although it may be a symbolic link to a script called `mariadb-secure-installation`)!

The example below shows how the script runs on Debian. Carefully read the output and answer the questions.

```console
student@debian:~$ sudo mysql_secure_installation 

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] 
Enabled successfully!
Reloading privilege tables..
 ... Success!

You already have your root account protected, so you can safely answer 'n'.

Change the root password? [Y/n] n
 ... skipping.

By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] y
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

The script performs the following tasks:

- Secure the root user. There are two ways to do this:
    - Switch to `unix_socket` authentication: this means that the root user does not get a password, but you can only log in as the database root user if you have superuser privileges on the system (i.e. with the command `sudo mysql`). This is a more recent method and may not be available on older distributions or MySQL/MariaDB versions.
    - Set a root password: you enter a password that you later can use to authenticate with the command `mysql -uroot -pPASSWORD` (see below). In this case, you don't need superuser privileges on the system, so it can be more convenient (but arguably less secure).
    - In the example above, we chose for `unix_socket` authentication, so we did *not* set a root password.
- Remove anonymous users: these are users with a blank user name and are used to define default access permissions. However, this can pose a security risk so it's better to remove them.
- Disallow root login remotely: the root user should only be allowed to connect from the local machine. This is a security measure to prevent unauthorized access.
- Remove the default test database that is present in new installations. There is no reason to keep it, especially in a production system.

## Accessing MySQL

### Linux users

The installation of `mysql` creates a user account in `/etc/passwd` and a group account in `/etc/group`. Details of the user may differ between distributions. For example, here is the output on Debian:

```console
student@debian:~$ getent passwd mysql
mysql:x:104:109:MySQL Server,,,:/nonexistent:/bin/false
student@debian:~$ getent group mysql
mysql:x:109:
```

On Fedora, you get:

```console
[student@fedora ~]$ getent passwd mysql
mysql:x:27:27:MySQL Server:/var/lib/mysql:/sbin/nologin
[student@fedora ~]$ getent group mysql
mysql:x:27:
```

As you can see, it's not possible for the mysql user to log in, as the shell is set to `/bin/false` or `/sbin/nologin`. However, the process that runs the MySQL server will be started as this user:

```console
student@debian:~$ ps -eo uid,user,gid,group,comm | grep maria
  104 mysql      109 mysql    mariadbd
```

### MySQL Client Application

You can now access the MySQL or MariaDB server from the commandline using the `mysql` client application. If you chose `unix_socket` authentication, you can log in with `sudo mysql` (see the example below).

If you set a root password during the execution of the `mysql_secure_installation` script, you can log in with `mysql -uroot -p`. It will prompt you for the password. 

```console
student@debian:~$ sudo mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 39
Server version: 10.11.6-MariaDB-0+deb12u1 Debian 12

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> 
```

Or on Enterprise Linux, with MySQL installed:

```console
[student@el ~]$ sudo mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.36 Source distribution

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

You can quit the MySQL client with the command `quit` or `exit`, or by pressing `Ctrl-D`.

You could also put the password in clear text on the command line, but that would not be very secure. Anyone with access to your bash history would be able to read your mysql root password. Remark that there should *not* be a space between the option `-p` and the password!

```console
student@linux~$ mysql -uroot -phunter2
Welcome to the MySQL monitor.  Commands end with ; or \g.
...
```

On the prompt, you can issue SQL statements (ending with a semicolon) to interact with the database. For example, to see which databases are available, use the command `show databases;`. More examples are given below.

Remark that the prompt has full history, even over previous sessions. You can use the up and down arrow keys to navigate through the history or search it using `Ctrl-R`.

### ~/.my.cnf

You can save the MySQL configuration in your home directory in the hidden file
`.my.cnf`. In the screenshot below we put the root user
and password in .my.cnf.

```console
student@linux:~$ pwd
/home/kevin
student@linux:~$ cat .my.cnf 
[client]
user=root
password=hunter2
student@linux:~$
```

This enables us to log on as the `root mysql` user just by typing `mysql`.

```console
student@linux:~$ mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 56
Server version: 5.5.24-0ubuntu0.12.04.1 (Ubuntu)
```

## Interacting with MySQL/MariaDB databases

### Listing all databases

You can use the `mysql` command to take a look at the databases and to execute SQL queries on them. The screenshots below show you how. First, we log on to our MySQL server and execute the
command `show databases` to see which databases exist on our MySQL server.

```console
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.004 sec)
```

### Creating a database

You can create a new database with the `create database` command.

```console
MariaDB [(none)]> create database famouspeople;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| famouspeople       |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.001 sec)
```

You can create the database on the condition that it doesn't already exist. If you try to create a database that already exists, you will get a warning.

```console
MariaDB [(none)]> create database if not exists famouspeople;
Query OK, 0 rows affected, 1 warning (0.000 sec)

MariaDB [(none)]> show warnings;
+-------+------+-------------------------------------------------------+
| Level | Code | Message                                               |
+-------+------+-------------------------------------------------------+
| Note  | 1007 | Can't create database 'famouspeople'; database exists |
+-------+------+-------------------------------------------------------+
1 row in set (0.000 sec)
```

### Using a database

Next we tell `mysql` to use one particular database with the `use $database` command. This screenshot shows how to make `famouspeople` the current database (in use).

```console
MariaDB [(none)]> use famouspeople;
Database changed
MariaDB [famouspeople]> 
```

On MariaDB, the prompt shows the name of the current database. On MySQL, you can use the command `select database();` to see the current database.

```console
mysql> use famouspeople;
Database changed
mysql> select database();
+--------------+
| database()   |
+--------------+
| famouspeople |
+--------------+
1 row in set (0.00 sec)
```

### Database access

To create a database user and give them access to a MySQL database, use the `grant` command.

```console
MariaDB [famouspeople]> grant all on famouspeople.* to kevin@localhost IDENTIFIED BY "hunter2";
Query OK, 0 rows affected (0.008 sec)
```

This user can now log in to the database `famouspeople` from the local machine:

```console
student@debian:~$ mysql -ukevin -phunter2 famouspeople
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 43
Server version: 10.11.6-MariaDB-0+deb12u1 Debian 12

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [famouspeople]> 
```

The `mysql` database has a table `user` that contains information about (database) users. You can use the `select` command to see this information. The table has a lot of columns, as you can see in the output of the `describe` query, so we will only select a few important fields: `Host`, `User` and `Password`.

```console
MariaDB [(none)]> use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [mysql]> describe user;
+------------------------+---------------------+------+-----+----------+-------+
| Field                  | Type                | Null | Key | Default  | Extra |
+------------------------+---------------------+------+-----+----------+-------+
| Host                   | char(255)           | NO   |     |          |       |
| User                   | char(128)           | NO   |     |          |       |
| Password               | longtext            | YES  |     | NULL     |       |
| Select_priv            | varchar(1)          | YES  |     | NULL     |       |
[...some output omitted...]
| default_role           | longtext            | NO   |     |          |       |
| max_statement_time     | decimal(12,6)       | NO   |     | 0.000000 |       |
+------------------------+---------------------+------+-----+----------+-------+
47 rows in set (0.002 sec)

MariaDB [mysql]> select User,Host,Password from user;
+-------------+-----------+-------------------------------------------+
| User        | Host      | Password                                  |
+-------------+-----------+-------------------------------------------+
| mariadb.sys | localhost |                                           |
| root        | localhost | invalid                                   |
| mysql       | localhost | invalid                                   |
| kevin       | localhost | *58815970BE77B3720276F63DB198B1FA42E5CC02 |
+-------------+-----------+-------------------------------------------+
4 rows in set (0.001 sec)
```

We see that there are four users in the `mysql` database. The `root` user has an invalid password, as does the `mysql` user. This means that they can not log in using the `mysql -uUSER` command. The `kevin` user does have a password hash, so he can log in with `mysql -ukevin -p`.

The `Host` field mentions `localhost`, which means that the user can only log in from the local machine. If you want to allow a user to log in from any machine, you can use the wildcard `%`, e.g.

```console
MariaDB [mysql]> grant all on famouspeople.* to kyra@'%' IDENTIFIED BY "prey42";
Query OK, 0 rows affected (0.008 sec)

MariaDB [mysql]> select User,Host,Password from user;
+-------------+-----------+-------------------------------------------+
| User        | Host      | Password                                  |
+-------------+-----------+-------------------------------------------+
| mariadb.sys | localhost |                                           |
| root        | localhost | invalid                                   |
| mysql       | localhost | invalid                                   |
| kevin       | localhost | *58815970BE77B3720276F63DB198B1FA42E5CC02 |
| kyra        | %         | *AA6D4E2D10EF6CC8E577E2169F131F8A9144D29B |
+-------------+-----------+-------------------------------------------+
5 rows in set (0.001 sec)
```

### Deleting a database

When a database is no longer needed, you can permanently remove it with the `drop database` command.

```console
mysql> drop database demodb;
Query OK, 1 row affected (0.09 sec)
```

Here, too, you can add a condition to only drop the database if it exists.

```console
MariaDB [(none)]> drop database if exists famouspeople;
Query OK, 0 rows affected (0.012 sec)

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.000 sec)
```

### Backup and restore a database

You can take a backup of a database, or move it to another computer using the `mysql` and `mysqldump` commands. In the screenshot below, we take a backup of the `famouspeople` database.

```console
student@debian:~$ sudo mysqldump famouspeople > famouspeople-backup-$(date -I).sql
student@debian:~$ ls
famouspeople-backup-2024-10-09.sql
student@debian:~$ file mysql-backup-2024-10-09.sql
famouspeople-backup-2024-10-09.sql: Unicode text, UTF-8 text, with very long lines (2374)
```

To restore the database, you can use the `mysql` command.

```console
student@debian:~$ sudo mysql famouspeople < famouspeople-backup-2024-10-09.sql
```

### Using MySQL non-interactively

When you are automating the process of initialising a database on a new system, you may want to execute SQL queries non-interactively. The `mysql` command provides two ways of doing this:

- The `-e "$sql_query"` option
- The `stdin` stream of the command

The latter is useful when you need to execute multiple queries. In this case, you can use a *here document* to pass the queries to the `mysql` command.

This example shows the `-e` option, used by the root user:

```console
student@debian:~$ sudo mysql -e 'select user,host,password from mysql.user;'
+-------------+-----------+-------------------------------------------+
| User        | Host      | Password                                  |
+-------------+-----------+-------------------------------------------+
| mariadb.sys | localhost |                                           |
| root        | localhost | invalid                                   |
| mysql       | localhost | invalid                                   |
| kevin       | localhost | *58815970BE77B3720276F63DB198B1FA42E5CC02 |
| kyra        | %         | *AA6D4E2D10EF6CC8E577E2169F131F8A9144D29B |
+-------------+-----------+-------------------------------------------+
```

And here is an example for a "normal" database user executing multiple queries in a *here document* (the database tables in the output will be created in the next section).

```console
student@debian:~$ mysql -ukevin -phunter2 famouspeople << _EOF_
SHOW TABLES;
DESCRIBE people;
_EOF_
Tables_in_famouspeople
country
invoices
people
Field	Type	Null	Key	Default	Extra
name	varchar(70)	YES		NULL	
field	varchar(20)	YES		NULL	
birthyear	int(5)	YES		NULL	
countrycode	char(3)	YES		NULL	
```

### Accessing a MySQL database over the network

In order to allow users to access the database server over the network, you may need to reconfigure it to listen on external network interfaces. On some installations, the default install only listens on the loopback interface `lo`. You can check this with `ss`:

```console
student@debian:~$ ss -tln
State   Recv-Q  Send-Q     Local Address:Port     Peer Address:Port  Process
LISTEN  0       4096             0.0.0.0:111           0.0.0.0:*
LISTEN  0       128              0.0.0.0:22            0.0.0.0:*
LISTEN  0       80             127.0.0.1:3306          0.0.0.0:*
LISTEN  0       4096                [::]:111              [::]:*
LISTEN  0       128                 [::]:22               [::]:*
```

The `127.0.0.1:3306` output shows that MariaDB/MySQL is in this case only listening on the loopback interface. We need to change this setting in the configuration. The structure of the MariaDB/MySQL configuration files (stored in `/etc/mysql` on Debian or `/etc/my.cnf.d/` on EL) is a bit complicated, so it's not always clear where to make the necessary changes.

In the screenshot below, we search all configuration files for the setting we need, i.e. `bind-address` and print the file and line number where it is found.

```console
student@debian:~$ find /etc/mysql/ -type f -exec grep -nH '^bind-address' {} \;
grep: /etc/mysql/debian.cnf: Permission denied
/etc/mysql/mariadb.conf.d/50-server.cnf:27:bind-address            = 127.0.0.1
```

In this case, the setting we need is in the file `/etc/mysql/mariadb.conf.d/50-server.cnf`. We can change the setting to `0.0.0.0` to make the server listen on all interfaces. Alternatively, you could specify the IP address of a specific network interface to only listen on that interface.

```console
student@debian:~$ sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf 
student@debian:~$ find /etc/mysql/ -type f -exec grep -nH ' bind-address' {} \;
grep: /etc/mysql/debian.cnf: Permission denied
/etc/mysql/mariadb.conf.d/50-server.cnf:27:bind-address            = 0.0.0.0
student@debian:~$ sudo systemctl restart mariadb
student@debian:~$ ss -tlnp
State   Recv-Q  Send-Q     Local Address:Port     Peer Address:Port  Process
LISTEN  0       80               0.0.0.0:3306          0.0.0.0:*
LISTEN  0       4096             0.0.0.0:111           0.0.0.0:*
LISTEN  0       128              0.0.0.0:22            0.0.0.0:*
LISTEN  0       4096                [::]:111              [::]:*
LISTEN  0       128                 [::]:22               [::]:*
```

After making the necessary change and restarting the service, the server now listens on all interfaces (`0.0.0.0:3306`). You can then access the database from another machine using the IP address (or hostname, if it has a DNS record) of the server.

```console
[student@fedora ~]$ mysql -h 192.168.56.21 -ukyra -pprey42 famouspeople -e 'show tables;'
+------------------------+
| Tables_in_famouspeople |
+------------------------+
| country                |
| invoices               |
| people                 |
+------------------------+
```

Remark that you may need to adjust the firewall settings on the server to allow incoming connections on port 3306! Also, the user should be allowed to connect from the remote host. In the example above, the user `kyra` is allowed to connect from any host (`%`). If you do the same for the user `kevin`, this will fail since he is only allowed to connect from `localhost`.

```console
[student@fedora ~]$ mysql -h 192.168.56.21 -ukevin -phunter2 -e 'show tables;'
ERROR 1045 (28000): Access denied for user 'kevin'@'192.168.56.109' (using password: YES)
```

## MySQL tables

In a relational database, you can create tables to store data. A table is a collection of rows and columns. Each row represents a record and each column represents a field in the record.

### Listing tables

You can see a list of tables in the current database with the `show tables;` command. Our `famouspeople` database has no tables yet.

```console
MariaDB [(none)]> use famouspeople;
Database changed
MariaDB [famouspeople]> show tables;
Empty set (0.000 sec)
```

### Creating a table

The `create table` command will create a new table.

This screenshot shows the creation of a `country` table. We use the `countrycode` as a `primary key` (all country codes are uniquely defined). Most country codes are two or three letters, so a
`char` of three uses less space than a `varchar` of three. The `country name` and the name of the capital are both defined as `varchar`. The population can be seen as an `integer`.

```console
MariaDB [famouspeople]> create table country (
    -> countrycode char(3) not null,
    -> countryname varchar(70) not null,
    -> population int,
    -> countrycapital varchar(50),
    -> primary key (countrycode)
    -> );
Query OK, 0 rows affected (0.017 sec)

MariaDB [famouspeople]> show tables;
+------------------------+
| Tables_in_famouspeople |
+------------------------+
| country                |
+------------------------+
1 row in set (0.001 sec)
```

You are allowed to type the `create table` command on one long line, but administrators often use multiple lines to improve readability.

```console
MariaDB [famouspeople]> create table country ( countrycode char(3) NOT NULL, countryname varchar(70) NOT NULL, population int, countrycapital varchar(50), primary key (countrycode) );
Query OK, 0 rows affected (0.18 sec)
```

### Describing a table

To see a description of the structure of a table, issue the `describe $tablename` command as shown below.

```console
MariaDB [famouspeople]> describe country;
+----------------+-------------+------+-----+---------+-------+
| Field          | Type        | Null | Key | Default | Extra |
+----------------+-------------+------+-----+---------+-------+
| countrycode    | char(3)     | NO   | PRI | NULL    |       |
| countryname    | varchar(70) | NO   |     | NULL    |       |
| population     | int(11)     | YES  |     | NULL    |       |
| countrycapital | varchar(50) | YES  |     | NULL    |       |
+----------------+-------------+------+-----+---------+-------+
4 rows in set (0.002 sec)
```

### Removing a table

To remove a table from a database, issue the `drop table $tablename` command as shown below.

```console
MariaDB [famouspeople]> drop table country;
Query OK, 0 rows affected (0.020 sec)
```

## MySQL records

### Creating records

Use `insert` to enter data into the table. The screenshot shows several insert statements that insert values depending on the position of the data in the statement.

```console
MariaDB [famouspeople]> insert into country values ('BE','Belgium','11977634','Brussels');
Query OK, 1 row affected (0.003 sec)

MariaDB [famouspeople]> insert into country values ('DE','Germany','84119100','Berlin');
Query OK, 1 row affected (0.002 sec)

MariaDB [famouspeople]> insert into country values ('JP','Japan','123201945','Tokyo');
Query OK, 1 row affected (0.001 sec)
```

Some administrators prefer to use uppercase for SQL keywords. The MySQL client accepts both.

```console
MariaDB [famouspeople]> INSERT INTO country VALUES ('FR','France','68374591','Paris');
Query OK, 1 row affected (0.003 sec)
```

Note that you get an error when using a duplicate `primary key`.

```console
MariaDB [famouspeople]> insert into country values ('DE','Germany','84119100','Berlin');
ERROR 1062 (23000): Duplicate entry 'DE' for key 'PRIMARY'
```

### Viewing all records

Below an example of a simple `select` query to look at the contents of a table.

```console
MariaDB [famouspeople]> select * from country;
+-------------+-------------+------------+----------------+
| countrycode | countryname | population | countrycapital |
+-------------+-------------+------------+----------------+
| BE          | Belgium     |   11977634 | Brussels       |
| DE          | Germany     |   84119100 | Berlin         |
| FR          | France      |   68374591 | Paris          |
| JP          | Japan       |  123201945 | Tokyo          |
+-------------+-------------+------------+----------------+
4 rows in set (0.001 sec)
```

### Updating records

Consider the following `insert` statement. The capital of Spain is not Barcelona, it is Madrid.

```console
MariaDB [famouspeople]> insert into country values ('ES','Spain','47280433','Barcelona');
Query OK, 1 row affected (0.003 sec)
```

Using an `update` statement, the record can be updated.

```console
MariaDB [famouspeople]> update country set countrycapital='Madrid' where countrycode='ES';
Query OK, 1 row affected (0.003 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

### Viewing selected records

We can use a `select` statement to verify this change, using a `where` clause to only show the record(s) we want to see.

```console
MariaDB [famouspeople]> select * from country where countrycode='ES';
+-------------+-------------+------------+----------------+
| countrycode | countryname | population | countrycapital |
+-------------+-------------+------------+----------------+
| ES          | Spain       |   47280433 | Madrid         |
+-------------+-------------+------------+----------------+
1 row in set (0.000 sec)
```

Another example of the `where` clause with the wildcard `%`. This will show all countries with a country code ending in `E`.

```console
MariaDB [famouspeople]> select * from country where countrycode like '%E';
+-------------+-------------+------------+----------------+
| countrycode | countryname | population | countrycapital |
+-------------+-------------+------------+----------------+
| BE          | Belgium     |   11977634 | Brussels       |
| DE          | Germany     |   84119100 | Berlin         |
+-------------+-------------+------------+----------------+
2 rows in set (0.000 sec)
```

What is the total population of these countries?

```console
MariaDB [famouspeople]> select sum(population) from country where countrycode like '%E';
+-----------------+
| sum(population) |
+-----------------+
|        96096734 |
+-----------------+
1 row in set (0.000 sec)
```

### Ordering records

We know that `select` allows us to see all records in a table. Using the `order by` clause, we can change the order in which the records are presented.

```console
MariaDB [famouspeople]> select countryname,population from country order by population;
+-------------+------------+
| countryname | population |
+-------------+------------+
| Belgium     |   11977634 |
| Spain       |   47280433 |
| France      |   68374591 |
| Germany     |   84119100 |
| Japan       |  123201945 |
+-------------+------------+
5 rows in set (0.001 sec)
```

### Grouping records

Consider this table of people. The screenshot shows how to use the `avg` function to calculate an average.

```console
MariaDB [famouspeople]> select * from people;
+-----------------+-----------+-----------+-------------+
| name            | field     | birthyear | countrycode |
+-----------------+-----------+-----------+-------------+
| Barack Obama    | politics  |      1961 | US          |
| Deng Xiaoping   | politics  |      1904 | CN          |
| Guy Verhofstadt | politics  |      1953 | BE          |
| Justine Henin   | tennis    |      1982 | BE          |
| Kim Clijsters   | tennis    |      1983 | BE          |
| Li Na           | tennis    |      1982 | CN          |
| Liu Yang        | astronaut |      1978 | CN          |
| Serena Williams | tennis    |      1981 | US          |
| Venus Williams  | tennis    |      1980 | US          |
+-----------------+-----------+-----------+-------------+
9 rows in set (0.001 sec)

MariaDB [famouspeople]> select AVG(birthyear) from people;
+----------------+
| AVG(birthyear) |
+----------------+
|      1967.1111 |
+----------------+
1 row in set (0.001 sec)
```

Using the `group by` clause, we can have an average per field.

```console
MariaDB [famouspeople]> select field,avg(birthyear) from people group by field;
+-----------+----------------+
| field     | avg(birthyear) |
+-----------+----------------+
| astronaut |      1978.0000 |
| politics  |      1939.3333 |
| tennis    |      1981.6000 |
+-----------+----------------+
3 rows in set (0.000 sec)
```

### Deleting records

You can use `delete` to permanently remove a record
from a table.

```console
MariaDB [famouspeople]> delete from country where countryname='Spain';
Query OK, 1 row affected (0.06 sec)

MariaDB [famouspeople]> select * from country where countryname='Spain';
Empty set (0.00 sec)
```

## Joining two tables

### Inner join

With an `inner join` you can take values from two tables and combine them in one result. Consider the country and the people tables from the previous section when looking at this screenshot of an `inner join`.

```console
MariaDB [famouspeople]> select name,field,countryname from country inner join people on people.countrycode=country.countrycode;
+-----------------+-----------+-------------+
| name            | field     | countryname |
+-----------------+-----------+-------------+
| Deng Xiaoping   | politics  | China       |
| Guy Verhofstadt | politics  | Belgium     |
| Justine Henin   | tennis    | Belgium     |
| Kim Clijsters   | tennis    | Belgium     |
| Li Na           | tennis    | China       |
| Liu Yang        | astronaut | China       |
+-----------------+-----------+-------------+
6 rows in set (0.000 sec)
```

This `inner join` will show only records with a match on `countrycode` in both tables.

### Left join

A `left join` is different from an `inner join` in that it will take all rows from the left table, regardless of a match in the right table.

```console
MariaDB [famouspeople]> select Name,Field,countryname from country left join people on people.countrycode=country.countrycode;
+-----------------+-----------+-------------+
| Name            | Field     | countryname |
+-----------------+-----------+-------------+
| Deng Xiaoping   | politics  | China       |
| Guy Verhofstadt | politics  | Belgium     |
| Justine Henin   | tennis    | Belgium     |
| Kim Clijsters   | tennis    | Belgium     |
| Li Na           | tennis    | China       |
| Liu Yang        | astronaut | China       |
| NULL            | NULL      | Germany     |
| NULL            | NULL      | Spain       |
| NULL            | NULL      | France      |
| NULL            | NULL      | Japan       |
+-----------------+-----------+-------------+
10 rows in set (0.000 sec)
```

You can see that some countries are present, even when they have no matching records in the `people` table.

## MySQL triggers

### Using a *before* trigger

Consider the following `create table` command. The last field (`amount`) is the multiplication of the two fields named `unitprice` and `unitcount`.

```console
MariaDB [famouspeople]> create table invoices (
    -> id char(8) NOT NULL,
    -> customerid char(3) NOT NULL,
    -> unitprice int,
    -> unitcount smallint,
    -> amount int );
Query OK, 0 rows affected (0.018 sec)
```

We can let MySQL do the calculation for that by using a `before trigger`. The screenshot below shows the creation of a trigger that calculates the amount by multiplying two fields that
are about to be inserted.

```console
MariaDB [famouspeople]> create trigger total_amount before INSERT on invoices
    -> for each row set new.amount = new.unitprice * new.unitcount ;
Query OK, 0 rows affected (0.02 sec)
```

Here we verify that the trigger works by inserting a new record, without providing the total amount. In the first attempt, we provide an empty value for the `amount` field. This will result in an error. In the second attempt, we do provide a value (0), but it will be overwritten by the trigger.

```console
MariaDB [famouspeople]> insert into invoices values ('20241009','ABC','199','10','');
ERROR 1366 (22007): Incorrect integer value: '' for column `famouspeople`.`invoices`.`amount` at row 1
MariaDB [famouspeople]> insert into invoices values ('20241009','DEF','159','40','0');
Query OK, 1 row affected (0.004 sec)
```

Looking at the record proves that the trigger works.

```console
MariaDB [famouspeople]> select * from invoices;
+----------+------------+-----------+-----------+--------+
| id       | customerid | unitprice | unitcount | amount |
+----------+------------+-----------+-----------+--------+
| 20241009 | ABC        |       199 |        10 |   1990 |
+----------+------------+-----------+-----------+--------+
1 row in set (0.000 sec)
```

### Removing a trigger

When a `trigger` is no longer needed, you can delete it with the `drop trigger` command.

```console
mysql> drop trigger total_amount;
Query OK, 0 rows affected (0.00 sec)
```

