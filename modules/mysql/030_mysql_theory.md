## installing mysql

On Debian/Ubuntu you can use
`aptitude install mysql-server` to install the
`mysql server` and `client`.

    root@ubu1204~# aptitude install mysql-server
    The following NEW packages will be installed:
      libdbd-mysql-perl{a} libdbi-perl{a} libhtml-template-perl{a}
      libnet-daemon-perl{a} libplrpc-perl{a} mysql-client-5.5{a} 
      mysql-client-core-5.5{a} mysql-server mysql-server-5.5{a}
      mysql-server-core-5.5{a} 
    0 packages upgraded, 10 newly installed, 0 to remove and 1 not upgraded.
    Need to get 25.5 MB of archives. After unpacking 88.4 MB will be used.
    Do you want to continue? [Y/n/?]

During the installation you will be asked to provide a password for the
`root mysql user`, remember this password (or use
`hunter2` like i do.

To verify the installed version, use `dpkg -l` on
Debian/Ubuntu. This screenshot shows version 5.0 installed.

    root@ubu1204~# dpkg -l mysql-server | tail -1 | tr -s ' ' | cut -c-72
    ii mysql-server 5.5.24-0ubuntu0.12.04.1 MySQL database server (metapacka

Issue `rpm -q` to get version information about MySQL on
Red Hat/Fedora/CentOS.

    [paul@RHEL52 ~]$ rpm -q mysql-server
    mysql-server-5.0.45-7.el5

You will need at least version 5.0 to work with
`triggers`.

## accessing mysql

### Linux users

The installation of `mysql` creates a user account in
`/etc/passwd` and a group account in
`/etc/group`.

    kevin@ubu1204:~$ tail -1 /etc/passwd
    mysql:x:120:131:MySQL Server,,,:/nonexistent:/bin/false
    kevin@ubu1204:~$ tail -1 /etc/group
    mysql:x:131:

The mysql daemon `mysqld` will run with the credentials of
this user and group.

    root@ubu1204~# ps -eo uid,user,gid,group,comm | grep mysqld
      120 mysql      131 mysql    mysqld

### mysql client application

You can now use mysql from the commandline by just typing
`mysql -u root -p` and you \'ll be asked for the password
(of the `mysql root` account). In the screenshot below the user typed
`exit` to exit the mysql console.

    root@ubu1204~# mysql -u root -p
    Enter password: 
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 43
    Server version: 5.5.24-0ubuntu0.12.04.1 (Ubuntu)

    Copyright (c) 2000, 2011, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> exit
    Bye

You could also put the password in clear text on the command line, but
that would not be very secure. Anyone with access to your bash history
would be able to read your mysql root password.

    root@ubu1204~# mysql -u root -phunter2
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    ...

### \~/.my.cnf

You can save configuration in your home directory in the hidden file
`.my.cnf`. In the screenshot below we put the root user
and password in .my.cnf.

    kevin@ubu1204:~$ pwd
    /home/kevin
    kevin@ubu1204:~$ cat .my.cnf 
    [client]
    user=root
    password=hunter2
    kevin@ubu1204:~$

This enables us to log on as the `root mysql` user just by typing
`mysql`.

    kevin@ubu1204:~$ mysql
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 56
    Server version: 5.5.24-0ubuntu0.12.04.1 (Ubuntu)

### the mysql command line client

You can use the `mysql` command to take a look at the
databases, and to execute SQL queries on them. The screenshots below
show you how.

Here we execute the command `show databases`. Every command must be
terminated by a delimiter. The default delimiter is `;` (the semicolon).

    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    | test               |
    +--------------------+
    4 rows in set (0.00 sec)

We will use this prompt in the next sections.

## mysql databases

### listing all databases

You can use the `mysql` command to take a look at the
databases, and to execute SQL queries on them. The screenshots below
show you how. First, we log on to our MySQL server and execute the
command `show databases` to see which databases exist on
our mysql server.

    kevin@ubu1204:~$ mysql
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 57
    Server version: 5.5.24-0ubuntu0.12.04.1 (Ubuntu)

    Copyright (c) 2000, 2011, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    | test               |
    +--------------------+
    4 rows in set (0.00 sec)

### creating a database

You can create a new database with the `create database`
command.

    mysql> create database famouspeople;
    Query OK, 1 row affected (0.00 sec)

    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | famouspeople       |
    | mysql              |
    | performance_schema |
    | test               |
    +--------------------+
    5 rows in set (0.00 sec)

### using a database

Next we tell `mysql` to use one particular database with the
`use $database` command. This screenshot shows how to make
wikidb the current database (in use).

    mysql> use famouspeople;
    Database changed
    mysql>

### access to a database

To give someone access to a mysql database, use the
`grant` command.

    mysql> grant all on famouspeople.* to kevin@localhost IDENTIFIED BY "hunter2";
    Query OK, 0 rows affected (0.00 sec)

### deleting a database

When a database is no longer needed, you can permanently remove it with
the `drop database` command.

    mysql> drop database demodb;
    Query OK, 1 row affected (0.09 sec)
            

### backup and restore a database

You can take a backup of a database, or move it to another computer
using the `mysql` and `mysqldump` commands. In the screenshot below, we
take a backup of the wikidb database on the computer named laika.

    mysqldump -u root famouspeople > famouspeople.backup.20120708.sql

Here is a screenshot of a database restore operation from this backup.

    mysql -u root famouspeople < famouspeople.backup.20120708.sql

## mysql tables

### listing tables

You can see a list of tables in the current database with the
`show tables;` command. Our `famouspeople` database has no
tables yet.

    mysql> use famouspeople;
    Database changed
    mysql> show tables;
    Empty set (0.00 sec)

### creating a table

The `create table` command will create a new table.

This screenshot shows the creation of a country table. We use the
`countrycode` as a `primary key` (all country codes are uniquely
defined). Most country codes are two or three letters, so a
`char` of three uses less space than a
`varchar` of three. The `country name` and the name of the
capital are both defined as `varchar`. The population can be seen as an
`integer`.

    mysql> create table country (
        -> countrycode char(3) NOT NULL,
        -> countryname varchar(70) NOT NULL,
        -> population int,
        -> countrycapital varchar(50),
        -> primary key (countrycode)
        -> );
    Query OK, 0 rows affected (0.19 sec)

    mysql> show tables;
    +------------------------+
    | Tables_in_famouspeople |
    +------------------------+
    | country                |
    +------------------------+
    1 row in set (0.00 sec)

    mysql>

You are allowed to type the `create table` command on one long line, but
administrators often use multiple lines to improve readability.

    mysql> create table country ( countrycode char(3) NOT NULL, countryname\
     varchar(70) NOT NULL, population int, countrycapital varchar(50), prim\
    ary key (countrycode) );
    Query OK, 0 rows affected (0.18 sec)

### describing a table

To see a description of the structure of a table, issue the
`describe $tablename` command as shown below.

    mysql> describe country;
    +----------------+-------------+------+-----+---------+-------+
    | Field          | Type        | Null | Key | Default | Extra |
    +----------------+-------------+------+-----+---------+-------+
    | countrycode    | char(3)     | NO   | PRI | NULL    |       |
    | countryname    | varchar(70) | NO   |     | NULL    |       |
    | population     | int(11)     | YES  |     | NULL    |       |
    | countrycapital | varchar(50) | YES  |     | NULL    |       |
    +----------------+-------------+------+-----+---------+-------+
    4 rows in set (0.00 sec)

### removing a table

To remove a table from a database, issue the
`drop table $tablename` command as shown below.

    mysql> drop table country;
    Query OK, 0 rows affected (0.00 sec)

## mysql records

### creating records

Use `insert` to enter data into the table. The screenshot
shows several insert statements that insert values depending on the
position of the data in the statement.

    mysql> insert into country values ('BE','Belgium','11000000','Brussels');
    Query OK, 1 row affected (0.05 sec)

    mysql> insert into country values ('DE','Germany','82000000','Berlin');
    Query OK, 1 row affected (0.05 sec)

    mysql> insert into country values ('JP','Japan','128000000','Tokyo');
    Query OK, 1 row affected (0.05 sec)

Some administrators prefer to use uppercase for `sql`
keywords. The mysql client accepts both.

    mysql> INSERT INTO country VALUES ('FR','France','64000000','Paris');
    Query OK, 1 row affected (0.00 sec)

Note that you get an error when using a duplicate `primary key`.

    mysql> insert into country values ('DE','Germany','82000000','Berlin');
    ERROR 1062 (23000): Duplicate entry 'DE' for key 'PRIMARY'

### viewing all records

Below an example of a simple `select` query to look at the
contents of a table.

    mysql> select * from country;
    +-------------+---------------+------------+----------------+
    | countrycode | countryname   | population | countrycapital |
    +-------------+---------------+------------+----------------+
    | BE          | Belgium       |   11000000 | Brussels       |
    | CN          | China         | 1400000000 | Beijing        |
    | DE          | Germany       |   82000000 | Berlin         |
    | FR          | France        |   64000000 | Paris          |
    | IN          | India         | 1300000000 | New Delhi      |
    | JP          | Japan         |  128000000 | Tokyo          |
    | MX          | Mexico        |  113000000 | Mexico City    |
    | US          | United States |  313000000 | Washington     |
    +-------------+---------------+------------+----------------+
    8 rows in set (0.00 sec)

### updating records

Consider the following `insert` statement. The capital of Spain is not
Barcelona, it is Madrid.

    mysql> insert into country values ('ES','Spain','48000000','Barcelona');
    Query OK, 1 row affected (0.08 sec)

Using an `update` statement, the record can be updated.

    mysql> update country set countrycapital='Madrid' where countrycode='ES';
    Query OK, 1 row affected (0.07 sec)
    Rows matched: 1  Changed: 1  Warnings: 0

We can use a `select` statement to verify this change.

    mysql> select * from country;
    +-------------+---------------+------------+----------------+
    | countrycode | countryname   | population | countrycapital |
    +-------------+---------------+------------+----------------+
    | BE          | Belgium       |   11000000 | Brussels       |
    | CN          | China         | 1400000000 | Beijing        |
    | DE          | Germany       |   82000000 | Berlin         |
    | ES          | Spain         |   48000000 | Madrid         |
    | FR          | France        |   64000000 | Paris          |
    | IN          | India         | 1300000000 | New Delhi      |
    | JP          | Japan         |  128000000 | Tokyo          |
    | MX          | Mexico        |  113000000 | Mexico City    |
    | US          | United States |  313000000 | Washington     |
    +-------------+---------------+------------+----------------+
    9 rows in set (0.00 sec)

### viewing selected records

Using a `where` clause in a `select` statement, you can
specify which record(s) you want to see.

    mysql> SELECT * FROM country WHERE countrycode='ES';
    +-------------+-------------+------------+----------------+
    | countrycode | countryname | population | countrycapital |
    +-------------+-------------+------------+----------------+
    | ES          | Spain       |   48000000 | Madrid         |
    +-------------+-------------+------------+----------------+
    1 row in set (0.00 sec)

Another example of the `where` clause.

    mysql> select * from country where countryname='Spain';
    +-------------+-------------+------------+----------------+
    | countrycode | countryname | population | countrycapital |
    +-------------+-------------+------------+----------------+
    | ES          | Spain       |   48000000 | Madrid         |
    +-------------+-------------+------------+----------------+
    1 row in set (0.00 sec)

### primary key in where clause ?

The `primary key` of a table is a field that uniquely identifies every
record (every row) in the table. when using another field in the `where`
clause, it is possible to get multiple rows returned.

    mysql> insert into country values ('EG','Egypt','82000000','Cairo');
    Query OK, 1 row affected (0.33 sec)

    mysql> select * from country where population='82000000';
    +-------------+-------------+------------+----------------+
    | countrycode | countryname | population | countrycapital |
    +-------------+-------------+------------+----------------+
    | DE          | Germany     |   82000000 | Berlin         |
    | EG          | Egypt       |   82000000 | Cairo          |
    +-------------+-------------+------------+----------------+
    2 rows in set (0.00 sec)

### ordering records

We know that `select` allows us to see all records in a table. Consider
this table.

    mysql> select countryname,population from country;
    +---------------+------------+
    | countryname   | population |
    +---------------+------------+
    | Belgium       |   11000000 |
    | China         | 1400000000 |
    | Germany       |   82000000 |
    | Egypt         |   82000000 |
    | Spain         |   48000000 |
    | France        |   64000000 |
    | India         | 1300000000 |
    | Japan         |  128000000 |
    | Mexico        |  113000000 |
    | United States |  313000000 |
    +---------------+------------+
    10 rows in set (0.00 sec)

Using the `order by` clause, we can change the order in
which the records are presented.

    mysql> select countryname,population from country order by countryname;
    +---------------+------------+
    | countryname   | population |
    +---------------+------------+
    | Belgium       |   11000000 |
    | China         | 1400000000 |
    | Egypt         |   82000000 |
    | France        |   64000000 |
    | Germany       |   82000000 |
    | India         | 1300000000 |
    | Japan         |  128000000 |
    | Mexico        |  113000000 |
    | Spain         |   48000000 |
    | United States |  313000000 |
    +---------------+------------+
    10 rows in set (0.00 sec)

### grouping records

Consider this table of people. The screenshot shows how to use the `avg`
function to calculate an average.

    mysql> select * from people;
    +-----------------+-----------+-----------+-------------+
    | Name            | Field     | birthyear | countrycode |
    +-----------------+-----------+-----------+-------------+
    | Barack Obama    | politics  | 1961      | US          |
    | Deng Xiaoping   | politics  | 1904      | CN          |
    | Guy Verhofstadt | politics  | 1953      | BE          |
    | Justine Henin   | tennis    | 1982      | BE          |
    | Kim Clijsters   | tennis    | 1983      | BE          |
    | Li Na           | tennis    | 1982      | CN          |
    | Liu Yang        | astronaut | 1978      | CN          |
    | Serena Williams | tennis    | 1981      | US          |
    | Venus Williams  | tennis    | 1980      | US          |
    +-----------------+-----------+-----------+-------------+
    9 rows in set (0.00 sec)

    mysql> select Field,AVG(birthyear) from people;
    +----------+-------------------+
    | Field    | AVG(birthyear)    |
    +----------+-------------------+
    | politics | 1967.111111111111 |
    +----------+-------------------+
    1 row in set (0.00 sec)

Using the `group by` clause, we can have an average per
field.

    mysql> select Field,AVG(birthyear) from people group by Field;
    +-----------+--------------------+
    | Field     | AVG(birthyear)     |
    +-----------+--------------------+
    | astronaut |               1978 |
    | politics  | 1939.3333333333333 |
    | tennis    |             1981.6 |
    +-----------+--------------------+
    3 rows in set (0.00 sec)

### deleting records

You can use the `delete` to permanently remove a record
from a table.

    mysql> delete from country where countryname='Spain';
    Query OK, 1 row affected (0.06 sec)

    mysql> select * from country where countryname='Spain';
    Empty set (0.00 sec)

## joining two tables

### inner join

With an `inner join` you can take values from two tables and combine
them in one result. Consider the country and the people tables from the
previous section when looking at this screenshot of an `inner join`.

    mysql> select Name,Field,countryname
        -> from country
        -> inner join people on people.countrycode=country.countrycode;
    +-----------------+-----------+---------------+
    | Name            | Field     | countryname   |
    +-----------------+-----------+---------------+
    | Barack Obama    | politics  | United States |
    | Deng Xiaoping   | politics  | China         |
    | Guy Verhofstadt | politics  | Belgium       |
    | Justine Henin   | tennis    | Belgium       |
    | Kim Clijsters   | tennis    | Belgium       |
    | Li Na           | tennis    | China         |
    | Liu Yang        | astronaut | China         |
    | Serena Williams | tennis    | United States |
    | Venus Williams  | tennis    | United States |
    +-----------------+-----------+---------------+
    9 rows in set (0.00 sec)

This `inner join` will show only records with a match on `countrycode`
in both tables.

### left join

A `left join` is different from an `inner join` in that it will take all
rows from the left table, regardless of a match in the right table.

    mysql> select Name,Field,countryname from country left join people on people.countrycode=country.countrycode;
    +-----------------+-----------+---------------+
    | Name            | Field     | countryname   |
    +-----------------+-----------+---------------+
    | Guy Verhofstadt | politics  | Belgium       |
    | Justine Henin   | tennis    | Belgium       |
    | Kim Clijsters   | tennis    | Belgium       |
    | Deng Xiaoping   | politics  | China         |
    | Li Na           | tennis    | China         |
    | Liu Yang        | astronaut | China         |
    | NULL            | NULL      | Germany       |
    | NULL            | NULL      | Egypt         |
    | NULL            | NULL      | Spain         |
    | NULL            | NULL      | France        |
    | NULL            | NULL      | India         |
    | NULL            | NULL      | Japan         |
    | NULL            | NULL      | Mexico        |
    | Barack Obama    | politics  | United States |
    | Serena Williams | tennis    | United States |
    | Venus Williams  | tennis    | United States |
    +-----------------+-----------+---------------+
    16 rows in set (0.00 sec)

You can see that some countries are present, even when they have no
matching records in the `people` table.

## mysql triggers

### using a before trigger

Consider the following `create table` command. The last
field (`amount`) is the multiplication of the two fields named
`unitprice` and `unitcount`.

    mysql> create table invoices (
        -> id char(8) NOT NULL,
        -> customerid char(3) NOT NULL,
        -> unitprice int,
        -> unitcount smallint,
        -> amount int );
    Query OK, 0 rows affected (0.00 sec)

We can let mysql do the calculation for that by using a
`before trigger`. The screenshot below shows the creation
of a trigger that calculates the amount by multiplying two fields that
are about to be inserted.

    mysql> create trigger total_amount before INSERT on invoices
        -> for each row set new.amount = new.unitprice * new.unitcount ;
    Query OK, 0 rows affected (0.02 sec)

Here we verify that the trigger works by inserting a new record, without
providing the total amount.

    mysql> insert into invoices values ('20090526','ABC','199','10','');
    Query OK, 1 row affected (0.02 sec)
        

Looking at the record proves that the trigger works.

    mysql> select * from invoices;
    +----------+------------+-----------+-----------+--------+
    | id       | customerid | unitprice | unitcount | amount |
    +----------+------------+-----------+-----------+--------+
    | 20090526 | ABC        |       199 |        10 |   1990 | 
    +----------+------------+-----------+-----------+--------+
    1 row in set (0.00 sec)

### removing a trigger

When a `trigger` is no longer needed, you can delete it with the
`drop trigger` command.

    mysql> drop trigger total_amount;
    Query OK, 0 rows affected (0.00 sec)
