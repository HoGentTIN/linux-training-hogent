## solution: shell variables

1. Use `echo` to display `Hello` followed by your username (use an existing shell variable!)

    ```bash
    echo "Hello ${USER}"
    ```

2. Create a variable `answer` with a value of `42`.

    ```bash
    answer=42
    ```

3. Copy the value of `$LANG` to `$my_lang`.

    ```bash
    my_lang="${LANG}"
    ```

4. List all current shell variables.

    ```bash
    set
    ```

5. List all exported shell variables (i.e. environment variables).

    ```bash
    env
    export
    declare -x
    ```

6. Do the `env` and `set` commands display your variable ?

    ```console
    student@linux:~$ set | grep my_lang
    my_lang=en_US.UTF-8
    student@linux:~$ set | grep answer
    answer=42
    student@linux:~$ env | grep my_lang
    student@linux:~$ env | grep answer
    ```

    > The `env` command does not display the `my_lang` and `answer` variables, because they are not exported.

7. Destroy your `answer` variable.

    ```bash
    unset answer
    ```

8. Create two variables, and `export` one of them.

    ```bash
    var1=one
    export var2=two
    ```

9. Display these variables in an interactive child shell and check which one is still available.

    ```console
    student@linux:~$ bash
    bash
    student@linux:~$ echo "${var1} ${var2}"
     two
    student@linux:~$ exit
    ```

10. Create a variable, give it the value 'Dumb', create another variable with value 'do'. Use `echo` and the two variables to print 'Dumbledore'.

    ```bash
    var_x=Dumb
    var_y=do

    echo "${var_x}le${var_y}re"
    ```

    > solution by Yves from Dexia: `echo $varx'le'$vary're'`
    > solution by Erwin from Telenet: `echo "$varx"le"$vary"re`

11. Find the list of backslash escaped characters in the manual of bash. Add the time to your `PS1` prompt.

    ```console
    student@linux:~$ PS1='\t \u@\h \W$ '
    21:52:48 student@linux ~$ pwd
    /home/student
    21:52:52 student@linux ~$
    ```


