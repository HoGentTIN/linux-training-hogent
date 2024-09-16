## solution: scripting tests and loops

1. Write a script that uses a `for` loop to count from 3 to 7.

    ```bash
    #!/bin/bash

    for i in 3 4 5 6 7
    do
       echo "Counting from 3 to 7, now at ${i}"
    done
    ```

2. Write a script that uses a `for` loop to count from 1 to 17000.

    ```bash
    #!/bin/bash

    for i in `seq 1 17000`
    do
        echo "Counting from 1 to 17000, now at ${i}"
    done
    ```

3. Write a script that uses a `while` loop to count from 3 to 7.

    ```bash
    #!/bin/bash

    i=3
    while [ $i -le 7 ]
    do
     echo "Counting from 3 to 7, now at ${i}"
     let i=i+1
    done
    ```

4. Write a script that uses an `until` loop to count down from 8 to 4.

    ```bash
    #!/bin/bash

    i=8
    until [ $i -lt 4 ]
    do
     echo "Counting down from 8 to 4, now at ${i}"
     let i=i-1
    done
    ```

5. Write a script that counts the number of files ending in `.txt` in
the current directory.

    ```bash
    #!/bin/bash

    let i=0
    for file in *.txt
    do
        let i++
    done
    echo "There are ${i} files ending in .txt"
    ```

6. Wrap an `if` statement around the script so it is also correct when
there are zero files ending in `.txt`.

    ```bash
    #!/bin/bash

    ls *.txt > /dev/null 2>&1
    if [ $? -ne 0 ] 
    then echo "There are 0 files ending in .txt"
    else
        let i=0
        for file in *.txt
        do
            let i++
        done
        echo "There are ${i} files ending in .txt"
    fi
    ```

