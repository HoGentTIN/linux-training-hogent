# practice: shell embedding

1\. Find the list of shell options in the man page of `bash`. What is
the difference between `set -u` and `set -o nounset`?

2\. Activate `nounset` in your shell. Test that it shows an error
message when using non-existing variables.

3\. Deactivate nounset.

4\. Execute `cd /var` and `ls` in an embedded shell.

The `echo` command is only needed to show the result of the `ls`
command. Omitting will result in the shell trying to execute the first
file as a command.

5\. Create the variable embvar in an embedded shell and echo it. Does
the variable exist in your current shell now ?

6\. Explain what \"set -x\" does. Can this be useful ?

(optional)7. Given the following screenshot, add exactly four characters
to that command line so that the total output is FirstMiddleLast.

    [paul@RHEL8b ~]$ echo  First; echo  Middle; echo  Last

8\. Display a `long listing` (ls -l) of the `passwd` command using the
`which` command inside an embedded shell.
