## practice: mysql

Write a script that, without any user interaction, performs the following tasks on your favourite Linux distribution. Use variables to store the database name, user name and password. Use here documents for the SQL queries.

1. Install MariaDB or MySQL using the system package manager.

2. Execute the queries performed by the `mysql_secure_installation` script.

    Tip: in the case of MariaDB, you can locate the script and peruse its contents. In the script, a function `do_query` is defined that executes SQL statements. Look for lines containing `do_query` and extract the SQL statements.

3. Create a database user that has all privileges on the database `famouspeople` and that can log in from any host.

4. With this user, reconstruct the database `famouspeople` described above with all its contents: tables and records.

