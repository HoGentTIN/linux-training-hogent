## solution: shell embedding

1. Find the list of shell options in the man page of `bash`. What is the difference between `set -u` and `set -o nounset`?

    > read the manual of bash (man bash), search for nounset \-- both mean the
same thing.

2. Activate `nounset` in your shell. Test that it shows an error message when using non-existing variables.

    ```
    set -u
    OR
    set -o nounset
    ```

    Both these lines have the same effect.

3. Deactivate nounset.

    ```
    set +u
    OR
    set +o nounset
    ```

4. Execute `cd /var` and `ls` in an embedded shell.

    ```
    echo $(cd /var ; ls)
    ```

    The `echo` command is only needed to show the result of the `ls` command. Omitting will result in the shell trying to execute the first file as a command.

5. Create the variable embvar in an embedded shell and echo it. Does the variable exist in your current shell now?

    ```
    echo $(embvar=emb;echo $embvar) ; echo $embvar #the last echo fails

    $embvar does not exist in your current shell
    ```

6. Explain what \"set -x\" does. Can this be useful?

    It displays shell expansion for troubleshooting your command.

7. (optional) Given the following screenshot, add exactly four characters to that command line so that the total output is FirstMiddleLast.

    ```
    [student@linux ~]$ echo  First; echo  Middle; echo  Last

    echo -n First; echo -n Middle; echo Last
    ```

8. Display a `long listing` (ls -l) of the `passwd` command using the `which` command inside an embedded shell.

    ```
    ls -l $(which passwd)
    ```


