## solution: scripting tests and loops

1. Write a script that uses a `for` loop to count from 3 to 7.

    ```bash
    #!/bin/bash

    for i in 3 4 5 6 7
    do
       echo "Counting from 3 to 7, now at ${i}"
    done
    ```

    > You can also use brace expansion, e.g. `for i in {3..7}`.

2. Write a script that uses a `for` loop to count from 1 to 17000.

    ```bash
    #!/bin/bash

    for i in $(seq 1 17000)
    do
        echo "Counting from 1 to 17000, now at ${i}"
    done
    ```

3. Write a script that uses a `while` loop to count from 3 to 7.

    ```bash
    #!/bin/bash

    i=3
    while [ "${i}" -le '7' ]
    do
       echo "Counting from 3 to 7, now at ${i}"
       i=(( i+1 ))   # or (( i++ ))
    done
    ```

4. Write a script that uses an `until` loop to count down from 8 to 4.

    ```bash
    #!/bin/bash

    i=8
    until [ "${i}" -lt '4' ]
    do
     echo "Counting down from 8 to 4, now at ${i}"
     (( i-- ))
    done
    ```

5. Write a script that uses a for loop to count the number of files ending in `.txt` in the current directory and displays a message "There are N files ending in .txt".

    ```bash
    #!/bin/bash

    i=0
    for file in *.txt
    do
        (( i++ ))
    done
    echo "There are ${i} files ending in .txt"
    ```

6. Improve the script with conditional statements so the displayed message is also correct when there are zero files or one file ending in `.txt`.

    ```bash
    #! /bin/bash

    if ! ls ./*.txt > /dev/null 2>&1; then
        echo "There are no files ending in .txt"
        exit 0
    fi

    i=0
    for file in *.txt
    do
        (( i++ ))
    done

    if [ "${i}" -eq '1' ]; then
        echo "There is 1 file ending in .txt"
    else
        echo "There are ${i} files ending in .txt"
    fi
    ```

