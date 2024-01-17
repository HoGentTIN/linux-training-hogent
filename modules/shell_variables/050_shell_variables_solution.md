# solution: shell variables

1\. Use echo to display Hello followed by your username. (use a bash
variable!)

    echo Hello $USER

2\. Create a variable `answer` with a value of `42`.

    answer=42

3\. Copy the value of \$LANG to \$MyLANG.

    MyLANG=$LANG

4\. List all current shell variables.

    set

    set|more on Ubuntu/Debian

5\. List all exported shell variables.

    env
    export
    declare -x

6\. Do the `env` and `set` commands display your variable ?

    env | more
    set | more

6\. Destroy your `answer` variable.

    unset answer

7\. Create two variables, and `export` one of them.

    var1=1; export var2=2

8\. Display the exported variable in an interactive child shell.

    bash
    echo $var2

9\. Create a variable, give it the value \'Dumb\', create another
variable with value \'do\'. Use `echo` and the two variables to echo
Dumbledore.

    varx=Dumb; vary=do

    echo ${varx}le${vary}re
    solution by Yves from Dexia : echo $varx'le'$vary're'
    solution by Erwin from Telenet : echo "$varx"le"$vary"re

10\. Find the list of backslash escaped characters in the manual of
bash. Add the time to your `PS1` prompt.

    PS1='\t \u@\h \W$ '
