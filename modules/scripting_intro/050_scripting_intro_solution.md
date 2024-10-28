## solution: introduction to scripting

1. Write a Python Hello World script, give it a shebang and make it executable.

    ```python
    #!/usr/bin/python3
    print("Hello, World!")
    ```

    ```console
    $ chmod +x hello.py
    $ ./hello.py
    Hello, World!
    ```

2. What would happen if you remove the shebang and try to execute the script again?

    > The script will be executed by the default interpreter, in this case, the Bash shell, which will not understand the Python syntax.

    ```console
    $ ./hello.py
    ./hello.py: line 1: syntax error near unexpected token `"Hello world!"'
    ./hello.py: line 1: `print("Hello world!")'
    ```

3. Create a Bash script `greeting.sh` that says hello to the user (make use of the shell variable with the current user's login name), prints the current date and time, and prints a quote. Ensure that you apply the shell settings to make your script easier to debug.

    ```bash
    #! /bin/bash --

    set -o nounset
    set -o errexit
    set -o pipefail

    echo "Hello ${USER}, today is:"
    date
    echo "Quote of the day:"
    fortune | cowsay
    ```

4. Copy the script to `/usr/local/bin` without the extension and verify that you can run it from any directory as a command.

    ```console
    student@linux:~$ sudo cp greeting.sh /usr/local/bin/greeting
    student@linux:~$ greeting
    Hello student, today is:
    Wed Mar  6 09:17:00 PM UTC 2024
    Quote of the day:
     ______________________________________
    / You plan things that you do not even \
    | attempt because of your extreme      |
    \ caution.                             /
     --------------------------------------
            \   ^__^
             \  (oo)\_______
                (__)\       )\/\
                    ||----w |
                    ||     ||
    student@linux:~$ cd /tmp
    student@linux:/tmp$ greeting
    Hello student, today is:
    Wed Mar  6 09:17:08 PM UTC 2024
    Quote of the day:
     _________________________________
    < You will be successful in love. >
     ---------------------------------
            \   ^__^
             \  (oo)\_______
                (__)\       )\/\
                    ||----w |
                    ||     ||
    ```

5. Take another look at the script `hello-var.sh` where we printed a variable that was not assigned. What happens if you assign the value `Tux` to the variable `user` on the interactive shell and then run the script? What do we have to do to make sure the variable is available in the script?

    ```console
    student@linux:~$ ./hello-var.sh 
    Hello 
    student@linux:~$ user=Tux
    student@linux:~$ ./hello-var.sh 
    Hello
    student@linux:~$ export user
    student@linux:~$ ./hello-var.sh 
    Hello Tux
    ```

6. What if we change the value of the variable `user` in the script? Will this change affect the value of the variable in the interactive shell after the script is finished?

    > We change the script to:

    ```bash
    #!/bin/bash
    # hello-var.sh -- example of variable assignment
    user="Linus"

    echo "Hello ${user}"
    ```

    > And execute it:

    ```console
    student@linux:~$ export user=Tux
    student@linux:~$ echo $user
    Tux
    student@linux:~$ ./hello-var.sh 
    Hello Linus
    student@linux:~$ echo $user
    Tux
    ```

    > The change in the script does not affect the value of the variable in the interactive shell after the script is finished!

