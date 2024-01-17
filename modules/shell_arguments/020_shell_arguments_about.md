This chapter introduces you to `shell expansion` by taking a close look
at `commands` and `arguments`. Knowing `shell expansion` is important
because many `commands` on your Linux system are processed and most
likely changed by the `shell` before they are executed.

The command line interface or `shell` used on most Linux systems is
called `bash`, which stands for
`Bourne again shell`. The `bash` shell incorporates
features from `sh` (the original Bourne shell),
`csh` (the C shell), and `ksh` (the Korn
shell).

This chapter frequently uses the `echo` command to
demonstrate shell features. The `echo` command is very simple: it echoes
the input that it receives.

    paul@laika:~$ echo Burtonville
    Burtonville
    paul@laika:~$ echo Smurfs are blue
    Smurfs are blue
