## practice : more scripting

1. Write a script that uses a case statement to check whether the first positional parameter has one of the following properties (in the order listed), and outputs an appropriate message:

    - a number between 0 and 999 (inclusive)
    - a "truthy" value, i.e. a string that can be interpreted as a boolean value (true/false, yes/no, on/off, T/F). Make the check case insensitive.
    - a string that starts with a capital letter
    - a string that starts with a lowercase letter
    - a "short" or "long" option (single or double dash)
    - a string that is empty
    - a string that does not match any of the above properties

    ```console
    student@linux:~$ ./casecheck.sh 99
    number (0-999)
    student@linux:~$ ./casecheck.sh Yes
    true
    student@linux:~$ ./casecheck.sh FALSE
    false
    student@linux:~$ ./casecheck.sh AZERTY
    capitalized word
    student@linux:~$ ./casecheck.sh qWeRtY
    lowercase word
    student@linux:~$ ./casecheck.sh --help
    long option
    student@linux:~$ ./casecheck.sh -a
    short option
    student@linux:~$ ./casecheck.sh ''
    empty string
    student@linux:~$ ./casecheck.sh 1a2b3c
    something else
    ```

2. Is it possible to use a case statement to check whether a string is a positive or negative integer value of arbitrary length? Why (not)?

3. Write a script that asks for two numbers, and outputs the sum and product (as shown here). Use Bash's arithmetic capabilities whenever possible.

    ```console
    $ ./sumprod.sh
    Enter a number: 5
    Enter another number: 2

    Sum:       5 + 2 = 7
    Product:   5 x 2 = 10
    ```

4. Rewrite the previous script to test that the numbers are between 0 and 100, exit with an error if necessary.

5. Rewrite the previous script to congratulate the user if the sum equals the product.

6. Rewrite the previous script to take the two numbers as command line arguments. Exit with an error message if not exactly two arguments are given.

