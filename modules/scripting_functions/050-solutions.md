## solutions: functions in shell scripts

1. See code examples in the text.

2. An implementation of the script:

    ```bash
    #! /bin/bash

    print_positional_parameters() {
        printf 'function: %s\t%s\t%s\t%s\t%s\n' \
            "${0}" "$#" "${1}" "${2}" "${3}"
    }
    
    print_positional_parameters fun1 fun2 fun3 fun4 
    
    printf 'main:     %s\t%s\t%s\t%s\t%s\n' \
        "${0}" "$#" "${1}" "${2}" "${3}"
    ```

    The output is:

    ```console
    $ bash function-params.sh cli1 cli2 cli3
    function: function-params.sh    4       fun1    fun2    fun3
    main:     function-params.sh    3       cli1    cli2    cli3
    ```

    In the first line, we're inside the function. The script name `${0}` is never changed inside a function. The number of arguments and the positional parameters are, so we see the parameters that were passed to the function.

    In the next line, we're back outside the function. At this point, the values of the positional parameters are those that were passed to the script from the command line.


