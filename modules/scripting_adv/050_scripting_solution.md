## solution : more scripting

1. Write a script that asks for two numbers, and outputs the sum and product (as shown here).

    ```
    Enter a number: 5
    Enter another number: 2

    Sum:       5 + 2 = 7
    Product:   5 x 2 = 10
    ```
        

    ```bash
    #!/bin/bash

    echo -n "Enter a number : "
    read n1

    echo -n "Enter another number : "
    read n2

    let sum="$n1+$n2"
    let pro="$n1*$n2"

    echo -e "Sum\t: $n1 + $n2 = $sum" 
    echo -e "Product\t: $n1 * $n2 = $pro"
    ```

2. Improve the previous script to test that the numbers are between 1 and 100, exit with an error if necessary.

    ```bash
    echo -n "Enter a number between 1 and 100 : "
    read n1

    if [ $n1 -lt 1 -o $n1 -gt 100 ]
    then
        echo Wrong number... 
        exit 1
    fi
    ```

3. Improve the previous script to congratulate the user if the sum equals the product.

    ```bash
    if [ $sum -eq $pro ]
    then
        echo Congratulations $sum == $pro
    fi
    ```

4. Write a script with a case insensitive case statement, using the shopt nocasematch option. The nocasematch option is reset to the value it had before the scripts started.

    ```bash
    #!/bin/bash
    #
    # Wild Animals Case Insensitive Helpdesk Advice
    #

    if shopt -q nocasematch; then
      nocase=yes;
    else
      nocase=no;
      shopt -s nocasematch;
    fi

    echo -n "What animal did you see? "
    read animal

    case $animal in
            "lion" | "tiger")
                    echo "You better start running fast!"
            ;;
            "cat")
                    echo "Let that mouse go..."
            ;;
            "dog")
                    echo "Don't worry, give it a cookie."
            ;;
            "chicken" | "goose" | "duck" )
                    echo "Eggs for breakfast!"
            ;;
            "liger")
                    echo "Approach and say 'Ah you big fluffy kitty.'"
            ;;
            "babelfish")
                    echo "Did it fall out your ear?"
            ;;
            *)
                    echo "You discovered an unknown animal, name it!"
            ;;
    esac

    if [ nocase = yes ] ; then
            shopt -s nocasematch;
    else
            shopt -u nocasematch;
    fi
    ```

5. If time permits (or if you are waiting for other students to finish this practice), take a look at Linux system scripts in /etc/init.d and /etc/rc.d and try to understand them. Where does execution of a script start in /etc/init.d/samba? There are also some hidden scripts in ~, we will discuss them later.

