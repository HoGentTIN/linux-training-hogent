## solution: introduction to scripting

0\. Give each script a different name, keep them for later!

1\. Write a script that outputs the name of a city.

    $ echo 'echo Antwerp' > first.bash
    $ chmod +x first.bash 
    $ ./first.bash 
    Antwerp

2\. Make sure the script runs in the bash shell.

    $ cat first.bash
    #!/bin/bash
    echo Antwerp

3\. Make sure the script runs in the Korn shell.

    $ cat first.bash
    #!/bin/ksh
    echo Antwerp

Note that while first.bash will technically work as a Korn shell script,
the name ending in .bash is confusing.

4\. Create a script that defines two variables, and outputs their value.

    $ cat second.bash
    #!/bin/bash

    var33=300
    var42=400

    echo $var33 $var42

5\. The previous script does not influence your current shell (the
variables do not exist outside of the script). Now run the script so
that it influences your current shell.

    source second.bash

6\. Is there a shorter way to `source` the script ?

    . ./second.bash

7\. Comment your scripts so that others may know what they are working
with.

    $ cat second.bash
    #!/bin/bash
    # script to test variables and sourcing

    # define two variables
    var33=300
    var42=400

    # output the value of these variables
    echo $var33 $var42
