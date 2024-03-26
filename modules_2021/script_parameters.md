# Script parameters

## script parameters


A **bash** script can be started with one or more **parameters** a.k.a.
arguments. You can refer to these arguments within the script. The
argument zero, referred to as **$0**, is the name of the script itself.

The script in the screenshot below explains some of the **parameters**
you can use.

    paul@debian10:~$ cat params.sh
    #!/bin/bash

    echo my name is $0
    echo The first argument is $1
    echo The second argument is $2
    echo The third argument is $3

    echo \$\$ $$ is the PID of this script
    echo \$\# $# is the number of arguments
    echo \$\* $* is a list of all the arguments
    paul@debian10:~$

In the screenshot below we execute the script. Note that we pass three
arguments to the script. These are **positional** arguments.

    paul@debian10:~$ ./params.sh one two three
    my name is ./params.sh
    The first argument is one
    The second argument is two
    The third argument is three
    $$ 628 is the PID of this script
    $# 3 is the number of arguments
    $* one two three is a list of all the arguments
    paul@debian10:~$

## shift through parameters


You can shift through all **parameters** using the **shift** command.
The script below shows how you can achieve this.

    paul@debian10:~$ cat shift.sh
    #!/bin/bash

    if [ "$#" == "0" ]
    then
            echo You have to give at least one parameter.
            exit 1
    fi

    while [ "$#" != "0" ]
    do
            echo You gave $1
            shift
    done
    paul@debian10:~$

The screenshot below tests the script first without any arguments, and
then with four arguments.

    paul@debian10:~$ ./shift.sh
    You have to give at least one parameter.
    paul@debian10:~$ ./shift.sh 33 42 8472 31337
    You gave 33
    You gave 42
    You gave 8472
    You gave 31337
    paul@debian10:~$

## Parsing options


Scripts can receive **options** in the form of letters preceded by a
**-**. These options can be parsed using the **getopts** bash built-in.
The script below demonstrates how to do this.

    paul@debian10:~$ cat options.sh
    #!/bin/bash

    while getopts ":afz" option
    do
            case $option in
                    a)
                            echo Received -a
                            ;;
                    f)
                            echo Received -f
                            ;;
                    z)
                            echo Received -z
                            ;;
                    *)
                            echo "Invalid option -$OPTARG"
                            ;;
            esac
    done
    paul@debian10:~$

Running the script with several valid and invalid options, results in
the following output.

    paul@debian10:~$ ./options.sh -a
    Received -a
    paul@debian10:~$ ./options.sh -zaf
    Received -z
    Received -a
    Received -f
    paul@debian10:~$ ./options.sh -f -i
    Received -f
    Invalid option -i
    paul@debian10:~$ ./options.sh -fia
    Received -f
    Invalid option -i
    Received -a
    paul@debian10:~$

## Options with an argument

Some options may require an argument, for example a path or a filename.
The script below requires an argument with the **-f** option.

    paul@debian10:~$ cat options2.sh
    #!/bin/bash

    while getopts ":af:z" option
    do
            case $option in
                    a)
                            echo Received -a
                            ;;
                    f)
                            echo Received -f with $OPTARG
                            ;;
                    z)
                            echo Received -z
                            ;;
                    :)
                            echo "$OPTARG needs an argument"
                            ;;
                    *)
                            echo "Invalid option -$OPTARG"
                            ;;
            esac
    done
    paul@debian10:~$

When running the script, you will notice that the **-f** option needs an
argument, but it will accept any argument.

    paul@debian10:~$ ./options2.sh -az
    Received -a
    Received -z
    paul@debian10:~$ ./options2.sh -af go
    Received -a
    Received -f with go
    paul@debian10:~$ ./options2.sh -z -f go
    Received -z
    Received -f with go
    paul@debian10:~$ ./options2.sh -z -f -a
    Received -z
    Received -f with -a
    paul@debian10:~$ ./options2.sh -f
    f needs an argument
    paul@debian10:~$

## Sourcing a configuration file

An application on Linux usually has a configuration file (often in
/etc). Below we show a configuration file for a humble script. This
configuration file will be sourced by our script.

    paul@debian10:~$ cat myapp.conf
    # this is the config file for myApp.sh
    #

    # Enter the path here
    myAppPath=/var/myapp

    # Enter the number of squirrels
    squirrels=42
    paul@debian10:~$

Below is the actual application that sources the configuration file
above, and then uses one of the values set in the configuration file.

    paul@debian10:~$ cat myApp.sh
    #!/bin/bash
    #
    # Welcome to myApp

    . ./myapp.conf

    echo There are $squirrels squirrels
    paul@debian10:~$

The running application (script in this case) can use the variable as if
it was defined in the application script itself.

    paul@debian10:~$ ./myApp.sh
    There are 42 squirrels
    paul@debian10:~$

## Cheat sheet

<table>
<caption>Parameters</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>parameter</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>$0</p></td>
<td style="text-align: left;"><p>argument 0, the name of the script
itself</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$1</p></td>
<td style="text-align: left;"><p>argument 1, the first positional
parameter given to the script</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>$2</p></td>
<td style="text-align: left;"><p>argument 2, the second positional
parameter</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$#</p></td>
<td style="text-align: left;"><p>the number of parameters received (not
counting argument 0)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>$$</p></td>
<td style="text-align: left;"><p>PID of the current script</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$*</p></td>
<td style="text-align: left;"><p>A string of all the parameters
(excluding argument 0)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>$?</p></td>
<td style="text-align: left;"><p>The last error code</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$-</p></td>
<td style="text-align: left;"><p>Expands to a list of active shell
options</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>$!</p></td>
<td style="text-align: left;"><p>Expands to the last job you put in
background</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>shift</p></td>
<td style="text-align: left;"><p>Removes $1 and shifts all $n to
$n-1</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>getopts</p></td>
<td style="text-align: left;"><p>filters options from a list of
options</p></td>
</tr>
</tbody>
</table>

Parameters

## Practice

1.  Write a shell script that receives four parameters, and outputs them
    in reverse order.

2.  Write a script that receives two filenames and outputs whether those
    files exist.

3.  Write a script that receives any number of filenames and outputs
    whether those files exist.

4.  Same as 3. , but write the script without an **if** statement.

5.  Look at **/etc/init.d/ssh** and determine whether it **sources** a
    configuration file.

## Solution

1.  Write a shell script that receives four parameters, and outputs them
    in reverse order.

        #!/bin/bash
        echo $4 $3 $2 $1

2.  Write a script that receives two filenames and outputs whether those
    files exist.

        #!/bin/bash
        if [ -f $1 ]
        then echo $1 exists
        else echo $1 not found
        fi
        if [ -f $2 ]
        then echo $2 exists
        else echo $2 not found
        fi

3.  Write a script that receives any number of filenames and outputs
    whether those files exist.

        #!/bin/bash

        while [ $# -gt "0" ]
        do
          if [ -f $1 ]
           then echo $1 exists
           else echo $1 not found
          fi
          shift
        done

4.  Same as 3. , but write the script without an **if** statement.

        #!/bin/bash

        while [ $# -gt "0" ]
        do
          [ -f $1 ] && echo $1 exists || echo $1 not found
          shift
        done

5.  Look at **/etc/init.d/ssh** and determine whether it **sources** a
    configuration file.

        Yes it does, line 22 (as of this writing) says ". /etc/default/ssh" .
