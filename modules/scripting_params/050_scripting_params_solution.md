## solution: parameters and options

1. Write a script that receives four parameters, and outputs them in
reverse order.

    ```bash
    #!/bin/bash
    echo "${4} ${3} ${2} ${1}"
    ```

2. Write a script that receives two parameters (two filenames) and outputs whether those files exist.

    ```bash
    #!/bin/bash

    if [ "$#" -ne '2' ]
    then
        echo "This script needs two parameters, got $#" >&2
        echo "Usage: ${0} <file1> <file2>" >&2
        exit 1
    fi

    if [ -f "${1}" ]
    then
        echo "${1} exists!"
    else
        echo "${1} not found!"
    fi

    if [ -f "${2}" ]
    then
        echo "${2} exists!"
    else
        echo "${2} not found!"
    fi
    ```

3. Write a script (e.g. named `chkw.sh`) that takes a filename as parameter, or asks for a filename if none was given. Verify the existence of the file, then verify that you own the file, and whether it is writable. If not, then make it writable.

    ```bash
    #! /bin/bash

    # Check if a filename was given as a parameter
    if [ "$#" -eq '0' ]; then
        read -r -p "Enter a filename: " filename
    else
        filename="${1}"
    fi

    # Check if the file exists
    if [ ! -f "${filename}" ]; then
        echo "File does not exist, or is not a file"
        exit 1
    fi

    # Check if the file is owned by the user
    if [ ! -O "${filename}" ]; then
        echo "You do not own this file"
        exit 1
    fi

    # Check if the file is writable
    if [ ! -w "${filename}" ]; then
        echo "File is not writable"
        chmod u+w "${filename}"
        echo "File is now writable"
    else
        echo "File is writable"
    fi
    ```

    > Interaction with the script:

    ```console
    [student@linux scripts]$ touch test{1..3}.txt
    [student@linux scripts]$ ls -l
    total 4
    -rwxr--r--. 1 student student 970 25 okt 12:39 chkw.sh
    -rw-------. 1 student student   0 25 okt 12:41 test1.txt
    -rw-------. 1 student student   0 25 okt 12:41 test2.txt
    -rw-------. 1 student student   0 25 okt 12:41 test3.txt
    [student@linux scripts]$ chmod -w test1.txt
    [student@linux scripts]$ sudo chown root:root test2.txt
    [student@linux scripts]$ ls -l
    total 4
    -rwxr--r--. 1 student student 970 25 okt 12:39 chkw.sh
    -r--------. 1 student student   0 25 okt 12:41 test1.txt
    -rw-------. 1 root    root      0 25 okt 12:41 test2.txt
    -rw-------. 1 student student   0 25 okt 12:41 test3.txt
    [student@linux scripts]$ ./chkw.sh
    Enter a filename: test1.txt
    File is not writable
    File is now writable
    [student@linux scripts]$ ./chkw.sh test2.txt
    You do not own this file
    [student@linux scripts]$ ./chkw.sh test3.txt
    File is writable
    [student@linux scripts]$ ls -l
    total 4
    -rwxr--r--. 1 student student 970 25 okt 12:39 chkw.sh
    -rw-------. 1 student student   0 25 okt 12:41 test1.txt
    -rw-------. 1 root    root      0 25 okt 12:41 test2.txt
    -rw-------. 1 student student   0 25 okt 12:41 test3.txt
    ```

4. Make a configuration file for the previous script. Put a logging switch in the config file, logging means writing detailed output of everything the script does to a log file in /tmp.

    ```bash
    #! /bin/bash

    . .chkwrc

    if [ "${logging}" = 'on' ]; then
        log="tee -a ${logfile}"
        date -Is >> "${logfile}"
        echo "Filename: ${1}" >> "${logfile}"
    else
        log='cat'
    fi

    # Check if a filename was given as a parameter
    if [ "$#" -eq '0' ]; then
        read -r -p "Enter a filename: " filename
    else
        filename="${1}"
    fi

    # Check if the file exists
    if [ ! -f "${filename}" ]; then
        echo "File does not exist, or is not a file" | ${log}
        exit 1
    fi

    # Check if the file is owned by the user
    if [ ! -O "${filename}" ]; then
        echo "You do not own this file" | ${log}
        exit 1
    fi

    # Check if the file is writable
    if [ ! -w "${filename}" ]; then
        echo "File is not writable" | ${log}
        chmod u+w "${filename}"
        echo "File is now writable" | ${log}
    else
        echo "File is writable" | ${log}
    fi
    ```

    > Configuration file (`.chkwrc`):

    ```bash
    logging=on
    logfile=/tmp/chkw.log
    ```

    > Interaction with the script:

    ```console
    [student@linux scripts] $ ls -l
    total 4
    -rwxr--r--. 1 student student 1133 26 okt 13:26 chkw.sh
    -r--------. 1 student student    0 25 okt 12:41 test1.txt
    -rw-------. 1 root    root       0 25 okt 12:41 test2.txt
    -r--r-----. 1 student student    0 25 okt 12:41 test3.txt
    [student@linux scripts] $ ./chkw.sh test1.txt
    File is not writable
    File is now writable
    [student@linux scripts] $ ./chkw.sh test2.txt
    You do not own this file
    [student@linux scripts] $ ./chkw.sh test3.txt
    File is not writable
    File is now writable
    [student@linux scripts] $ cat /tmp/chkw.log 
    2024-10-26T13:27:26+02:00
    File is not writable
    File is now writable
    2024-10-26T13:27:50+02:00
    Filename: test2.txt
    You do not own this file
    2024-10-26T13:27:54+02:00
    Filename: test3.txt
    File is not writable
    File is now writable
    ```

