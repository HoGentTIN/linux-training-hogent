## solution: parameters and options

1\. Write a script that receives four parameters, and outputs them in
reverse order.

    echo $4 $3 $2 $1

2\. Write a script that receives two parameters (two filenames) and
outputs whether those files exist.

    #!/bin/bash

    if [ -f $1 ]
    then echo $1 exists!
    else echo $1 not found!
    fi

    if [ -f $2 ]
    then echo $2 exists!
    else echo $2 not found!
    fi
        

3\. Write a script that asks for a filename. Verify existence of the
file, then verify that you own the file, and whether it is writable. If
not, then make it writable.

4\. Make a configuration file for the previous script. Put a logging
switch in the config file, logging means writing detailed output of
everything the script does to a log file in /tmp.

