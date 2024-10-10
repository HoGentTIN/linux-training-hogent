## solution: mysql

In this solution, we install MariaDB on an Enterprise Linux system (tested on AlmaLinux 9). You can adapt to your favourite Linux distribution.

In order to find which queries are performed by `mysql_secure_installation`, you can do the following:

```console
[student@el ~]$ which mysql_secure_installation 
/usr/bin/mysql_secure_installation
[student@el ~]$ file /usr/bin/mysql_secure_installation
/usr/bin/mysql_secure_installation: symbolic link to mariadb-secure-installation
[student@el my.cnf.d]$ file /usr/bin/mariadb-secure-installation 
/usr/bin/mariadb-secure-installation: a /usr/bin/sh script, ASCII text executable
[student@el ~]$ grep do_query /usr/bin/mariadb-secure-installation 
do_query() {
	do_query "show create user root@localhost"
    do_query "UPDATE mysql.global_priv SET priv=json_set(priv, '$.plugin', 'mysql_native_password', '$.authentication_string', PASSWORD('$esc_pass')) WHERE User='root';"
    do_query "DELETE FROM mysql.global_priv WHERE User='';"
    do_query "DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    do_query "DROP DATABASE IF EXISTS test;"
    do_query "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
    do_query "  "
  do_query "UPDATE mysql.global_priv SET priv=json_set(priv, '$.password_last_changed', UNIX_TIMESTAMP(), '$.plugin', 'mysql_native_password', '$.authentication_string', 'invalid', '$.auth_or', json_array(json_object(), json_object('plugin', 'unix_socket'))) WHERE User='root';"
```

We're not going to use the query to set the user password, since we'll keep `unix_socket` authentication.

```bash
#!/bin/bash
#
# init-db.sh -- Install and initialize a MariaDB database instance

set -o nounset
set -o errexit
set -o pipefail

# Variables
db_name="famouspeople"
db_user="kevin"
db_password="hunter2"

## Install the MariaDB server
dnf install -y mariadb-server

## Allow remote access to the database
sed -i 's/^#bind-address.*$/bind-address=0.0.0.0/' /etc/my.cnf.d/mariadb-server.cnf

## Start and enable the MariaDB service
if ! sudo systemctl is-enabled mariadb; then
  systemctl enable --now mariadb
else
  # Restart the service if it's already enabled
  systemctl restart mariadb
fi

## Perform the tasks of mysql_secure_installation:
# Remove anonymous users, disallow root login remotely, remove test database
# Root password is not set, we'll use `unix_socket` authentication
echo "Securing the MariaDB installation"

mysql << _EOF_
DELETE FROM mysql.global_priv WHERE User='';
DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

## Initialize the database

echo "Creating a database and user"

mysql << _EOF_
CREATE DATABASE IF NOT EXISTS ${db_name};
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'%' IDENTIFIED BY '${db_password}';
FLUSH PRIVILEGES;
_EOF_

echo "Creating tables and adding content as the newly created database user"

mysql -u"${db_user}" -p"${db_password}" ${db_name} << _EOF_
DROP TABLE IF EXISTS country;
CREATE TABLE country (
  countrycode char(3) NOT NULL,
  countryname varchar(70) NOT NULL,
  population int,
  countrycapital varchar(50),
  PRIMARY KEY (countrycode)
);
INSERT INTO country VALUES ('BE','Belgium','11977634','Brussels');
INSERT INTO country VALUES ('DE','Germany','84119100','Berlin');
INSERT INTO country VALUES ('JP','Japan','123201945','Tokyo');
INSERT INTO country VALUES ('FR','France','68374591','Paris');
INSERT INTO country VALUES ('ES','Spain','47280433','Madrid');

DROP TABLE IF EXISTS people;
CREATE TABLE people (
  name varchar(70) NOT NULL,
  field varchar(20),
  birthyear int,
  countrycode char(3)
);
INSERT INTO people VALUES ('Barack Obama','politics','1961','US');
INSERT INTO people VALUES ('Deng Xiaoping','politics','1904','CN');
INSERT INTO people VALUES ('Guy Verhofstadt','politics','1953','BE');
INSERT INTO people VALUES ('Justine Henin','tennis','1982','BE');
INSERT INTO people VALUES ('Kim Clijsters','tennis','1983','BE');
INSERT INTO people VALUES ('Li Na','tennis','1982','CN');
INSERT INTO people VALUES ('Liu Yang','astronaut','1978','CN');
INSERT INTO people VALUES ('Serena Williams','tennis','1981','US');
INSERT INTO people VALUES ('Venus Williams','tennis','1980','US');
_EOF_

```

Afterwards, we can test the result from the command line. In this case, the database VM has the IP address 192.168.56.11. On another machine on the same network where the `mysql` client is installed, issue (for example) the following command:

```console
student@linux:~$ mysql -h 192.168.56.11 -ukevin -phunter2 famouspeople -e "select * from people;"
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
```

