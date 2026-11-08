## solution : more scripting

1. Write a script that uses a case statement to check whether the first positional parameter has one of the given properties and outputs an appropriate message.

    ```bash
    #! /bin/bash

    case "${1}" in
        [0-9] | [0-9][0-9] | [0-9][0-9][0-9] )
            echo "number (0-999)" ;;
        [Tt] | [Tt][Rr][Uu][Ee] | [Yy][Ee][Ss] | [Oo][Nn] )
            echo "true" ;;
        [Ff] | [Ff][Aa][Ll][Ss][Ee] | [Nn][Oo] | [Oo][Ff][Ff] )
            echo "false" ;;
        [A-Z]* )
            echo "capitalized word" ;;
        [a-z]* )
            echo "lowercase word" ;;
        --* )
            echo "long option" ;;
        -* )
            echo "short option" ;;
        '' )
            echo "empty string" ;;
        * )
            echo "something else" ;;
    esac
    ```

2. Is it possible to use a case statement to check whether a string is a positive or negative integer value of arbitrary length? Why (not)?

    No, it is not. Globbing patterns do not allow you to specify a minimum or maximum number of specific characters. For example, the pattern `[0-9]*` would match the string '1abc', which is not a valid integer.

3. Write a script that asks for two numbers, and outputs the sum and product (as shown here). Use Bash's arithmetic capabilities whenever possible.

    ```bash
    #! /bin/bash

    read -rp "Enter a number       : " n1
    read -rp "Enter another number : " n2

    sum=$(( n1 + n2 ))
    pro=$(( n1 * n2 ))

    printf "Sum\t: %d + %d = %d\n" "${n1}" "${n2}" "${sum}"
    printf "Product\t: %d * %d = %d\n" "${n1}" "${n2}" "${pro}"
    ```

4. Rewrite the previous script to test that the numbers are between 0 and 100, exit with an error if necessary.

    Add the following lines after the `read` commands:

    ```bash
    if (( n1 < 0 || n1 > 100 || n2 < 0 || n2 > 100 )); then
        echo "Value out of range, exiting" >&2
        exit 1
    fi
    ```

5. Rewrite the previous script to congratulate the user if the sum equals the product.

    Add as the last lines of the script:

    ```bash
    if (( sum == pro )); then
        echo "Congratulations ${sum} == ${pro}"
    fi
    ```

6. Rewrite the previous script to take the two numbers as command line arguments. Exit with an error message if not exactly two arguments are given.

    In this solution, we continue using `$1` and `$2` throughout the script. Remark that you could also assign them to the variables from the previous versions, e.g. `n1=${1}` and `n2=${2}`.

    ```bash
    #! /bin/bash

    if (( $# != 2)); then
        printf 'Expected 2 arguments, got %d\n' "$#" >&2
        exit 1
    fi

    sum=$(( ${1} + ${2} ))
    pro=$(( ${1} * ${2} ))

    if (( ${1} < 0 || ${1} > 100 || ${2} < 0 || ${2} > 100 )); then
        printf 'Value out of range (0 - 100), exiting\n' >&2
        exit 1
    fi

    printf 'Sum\t: %d + %d = %d\n' "${1}" "${2}" "${sum}"
    printf 'Product\t: %d * %d = %d\n' "${1}" "${2}" "${pro}"

    if (( sum == pro )); then
        printf 'Congrats, %d == %d\n' "${sum}" "${pro}"
    fi
    ```

