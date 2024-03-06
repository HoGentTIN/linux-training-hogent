## practice: introduction to scripting

1. Write a Python "Hello World" script, give it a shebang and make it executable. Execute it like you would a shell script and verify that this works.

2. What would happen if you remove the shebang and try to execute the script again?

3. Create a Bash script `greeting.sh` that says hello to the user (make use of the shell variable with the current user's login name), prints the current date and time, and prints a quote, e.g.:

    ```console
    student@linux:~$ ./greeting.sh 
    Hello student, today is:
    Wed Mar  6 09:04:19 PM UTC 2024
    Quote of the day:
     ______________________________________
    / Having nothing, nothing can he lose. \
    |                                      |
    \ -- William Shakespeare, "Henry VI"   /
     --------------------------------------
            \   ^__^
             \  (oo)\_______
                (__)\       )\/\
                    ||----w |
                    ||     ||
    ```

    Ensure that you apply the shell settings to make your script easier to debug.

4. Copy the script to `/usr/local/bin` without the extension and verify that you can run it from any directory as a command.

5. Take another look at the script `hello-var.sh` where we printed a variable that was not assigned:

    ```bash
    #!/bin/bash
    # hello-var.sh -- example of variable assignment
    # user="Tux" # Remark: this line is commented out

    echo "Hello ${user}"
    ```

    What happens if you assign the value `Tux` to the variable `user` on the interactive shell and then run the script? What do we have to do to make sure the variable is available in the script?

6. What if we change the value of the variable `user` in the script? Will this change affect the value of the variable in the interactive shell after the script is finished?

