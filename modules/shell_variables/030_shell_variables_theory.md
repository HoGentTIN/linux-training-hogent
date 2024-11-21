## `$` dollar sign

To retrieve the value of a **shell variable**, prefix the variable name with a dollar sign `$`. When you use the dollar sign syntax in a command, the shell will look for an existing variable named like the word following the `$` and replace it with the value of that variable. This is called **parameter substitution**. When the variable does not exist, the shell will replace it with an empty string.

When you open a terminal, several variables are already set. These are some examples using `$HOSTNAME`, `$USER`, `$UID`, `$SHELL`, and
`$HOME`.

```console
[student@linux ~]$ echo "This is the $SHELL shell"
This is the /bin/bash shell
[student@linux ~]$ echo "This is $SHELL on computer $HOSTNAME"
This is /bin/bash on computer linux.localdomain
[student@linux ~]$ echo "The userid of $USER is $UID"
The userid of studemt is 1000
[student@linux ~]$ echo "My homedir is $HOME"
My homedir is /home/student
```

The variable name can also be **enclosed in curly braces** `{}`, e.g. `${HOME}`, `${USER}`, etc. This is less ambiguous and in some situations even required to separate the variable name from text immediately following it. For example:

```console
[student@linux ~]$ prefix=Super
[student@linux ~]$ echo "Hello $prefixman and $prefixgirl"
Hello  and
[student@linux ~]$ echo "Hello ${prefix}man and ${prefix}girl"
Hello Superman and Supergirl
```

In a script, it's actually a best practice to *always* use the notation with the curly braces `${var}`.

## case sensitive

This example shows that shell variables are case sensitive!

```console
[student@linux ~]$ echo "Hello $USER"
Hello student
[student@linux ~]$ echo "Hello $user"
Hello 
```

## creating variables

This example creates the variable `$my_var` and sets its value. It then uses `echo` to verify the value.

```console
[student@linux gen]$ my_var=555
[student@linux gen]$ echo "$my_var"
555
```

**Remark!**

- The variable name must start with a letter or an underscore and can contain letters, numbers, and underscores.
- There must be *no spaces* around the equal sign.
- Don't use the dollar sign when you assign a value to a variable. The dollar sign is exclusively used to retrieve the *value* of a variable.
- This is not set in stone, but it's recommended to use lowercase letters for most variable names and underscores to separate words, e.g. `${my_var}`, `${file_name}`, etc.
- Variables are usually *strings*, but can in some cases be interpreted as *integer numbers*.

## quotes

Notice that double quotes still allow the parsing of variables, whereas single quotes prevent this.

```console
[student@linux ~]$ my_var=555
[student@linux ~]$ echo ${my_var}
555
[student@linux ~]$ echo "${my_var}"
555
[student@linux ~]$ echo '${my_var}'
${my_var}
```

The bash shell will replace variables with their value in double quoted lines, but not in single quoted lines.

```console
student@linux:~$ city=Burtonville
student@linux:~$ echo "We are in ${city} today."
We are in Burtonville today.
student@linux:~$ echo 'We are in ${city} today.'
We are in ${city} today. 
```

In most cases, it is best practice to **always enclose variables in double quotes**. For example, if a variable contains a file name that has spaces in it, the shell may interpret this incorrectly:

```console
student@linux:~/temp$ file_name='My file.txt'
student@linux:~/temp$ touch ${file_name}
student@linux:~/temp$ ls
file.txt  My
student@linux:~/temp$ ls -l
total 0
-rw-r--r-- 1 student student 0 Nov 21 19:28 file.txt
-rw-r--r-- 1 student student 0 Nov 21 19:28 My
```

What happened? The shell replaced `${file_name}` with the value of the variable resulting in:

```bash
touch My file.txt
```

Because there were no quotes in the command, word splitting occured and `My` and `file.txt` were interpreted as two separate arguments. This can be avoided by using double quotes:

```console
student@linux:~/temp$ touch "${file_name}"
student@linux:~/temp$ ls -l
total 0
-rw-r--r-- 1 student student 0 Nov 21 19:28  file.txt
-rw-r--r-- 1 student student 0 Nov 21 19:28  My
-rw-r--r-- 1 student student 0 Nov 21 19:28 'My file.txt'
```

Your scripts will become much more robust if you always use double quotes around variables and will be able to handle file names with spaces or other special characters.

## set

You can use the `set` command without options to display a list of shell variables. On Ubuntu and Debian systems, the `set` command will also list shell functions after the shell variables.

The `set` command can also be used to change the default behaviour of the shell. For example, `set -o nounset` (or `set -u`) at the start of a script will cause an error when an unbound variable is used, instead of replacing it with an empty string. Also, the script will exit immediately with a nonzero exit status, instead of continuing. Likewise, `set -o errexit` (or `set -e`) will cause the script to exit immediately when a command fails and `set -o pipefail` (no short option available) will print more informative error messages when a command in a pipeline fails. It is best practice to start each script with these three options!

```bash
set -o nounset
set -o errexit
set -o pipefail
```

These can be written in short form as:

```bash
set -euo pipefail
```

With `set -x` (or `set -o xtrace`), the shell will print each command before executing it, but after all forms of substitution have been applied. This is useful for debugging scripts, as it shows exactly how the shell has interpreted the command you executed.

```console
student@linux:~$ set -x
student@linux:~$ echo "Hello ${USER}"
+ echo Hello student
Hello student
student@linux:~$ set +x
```

Turn the option off with `set +x`.

For other uses of the `set` command, see the `builtins(7)` man page.

## unset

Use the `unset` command to remove a variable from your shell environment.

```console
[student@linux ~]$ my_var=8472
[student@linux ~]$ echo "${my_var}"
8472
[student@linux ~]$ unset my_var
[student@linux ~]$ echo "${my_var}"

[student@linux ~]$
```

## `$PS1`

The `$PS1` variable determines your shell prompt. You can use backslash escaped special characters like `\u` for the username or `\w` for the working directory. The `bash(1)` manual has a complete reference (in the section `PROMPTING`).

In this example we change the value of `$PS1` a couple of times.

```console
student@linux:~$ PS1=prompt
prompt
promptPS1='prompt '
prompt 
prompt PS1='> '
> 
> PS1='\u@\h$ '
student@linux$ 
student@linux$ PS1='\u@\h:\W$'
student@linux:~$
```

To avoid unrecoverable mistakes, you can set normal user prompts to green and the root prompt to red. Add the following to your `.bashrc` for a green user prompt:

```bash
# color prompt by paul
RED='\[\033[01;31m\]'
WHITE='\[\033[01;00m\]'
GREEN='\[\033[01;32m\]'
BLUE='\[\033[01;34m\]'
export PS1="${debian_chroot:+($debian_chroot)}${GREEN}\u${WHITE}@${BLUE}\h${WHITE}\w\$ "
```

## `$PATH`

The `$PATH` variable is determines where the shell is looking for commands to execute (unless the command is builtin or aliased). This variable contains a list of directories, separated by colons.

```console
[student@linux ~]$ echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
```

The shell will not look in the current directory for commands to execute! (Looking for executables in the current directory provided an easy way to hack PC-DOS computers). If you want the shell to look in the current directory, then add a `.` at the end of your `$PATH` (which is a shortcut to *the current working directory*). This is not recommended, though!

```console
[student@linux ~]$ PATH=$PATH:.
[student@linux ~]$ echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:.
```

Your path might be different when using `su` instead of `su -` because the latter will take on the environment of the target user. The root user typically has `sbin/` directories added to the `$PATH` variable (for commands relating to **s**ystem administration tasks).

```console
[student@linux ~]$ su
Password: 
[root@linux student]# echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
[root@linux student]# exit
[student@linux ~]$ su -
Password: 
[root@linux ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:
```

## variable scope

When you initialize a variable in some shell, it will not be available in child shells (also called *subshells*):

```console
[student@linux ~]$ penguin=tux
[student@linux ~]$ echo $penguin
tux
[student@linux ~]$ bash          #<---- this is where we create a subshell
[student@linux ~]$ echo $penguin

[student@linux ~]$ exit
[student@linux ~]$ echo $penguin
tux
```

We can use the `export` command to turn the variable into an **environment variable**. This will make the variable available in child shells.

```console
[student@linux ~]$ export penguin=tux
[student@linux ~]$ echo $penguin
tux
[student@linux ~]$ bash
[student@linux ~]$ echo $penguin
tux
[student@linux ~]$ exit
```

**Remark** that is actually a convention to give **environment variables uppercase names** and "normal" (non-exported) variables lowercase names.

When you execute a script, it will also run in a subshell, so only `export`ed variables will be available in the script.

If you try this example, first `unset` the variable `$penguin`.

```console
[student@linux ~]$ unset penguin
[student@linux ~]$ penguin=pingu
[student@linux ~]$ echo 'echo "${penguin}"' > script.sh
[student@linux ~]$ bash script.sh

[student@linux ~]$ export penguin
[student@linux ~]$ bash script.sh
pingu
```

Beware that exported variables cannot be seen in the parent shell! Assume the variable `$penguin` is unset:

```console
[student@linux ~]$ echo $penguin

[student@linux ~]$ bash
[student@linux ~]$ export penguin=pingu
[student@linux ~]$ echo $penguin
pingu
[student@linux ~]$ exit
[student@linux ~]$ echo $penguin

[student@linux ~]$
```

## env

The `env` command without options will display a list of **environment variables**, i.e. all variables that have been made available to subshells with `export`.

But `env` can also be used to start a clean shell (a shell without any inherited environment). The `env -i` command clears the environment for the subshell.

Notice in this screenshot that `bash` will set the `$SHELL` variable on startup.

```console
[student@linux ~]$ bash -c 'echo $SHELL $HOME $USER'
/bin/bash /home/student student
[student@linux ~]$ env -i bash -c 'echo $SHELL $HOME $USER'
/bin/bash
[student@linux ~]$
```

You can use the `env` command to set the `$LANG`, or any other, variable for just one instance of `bash` with one command. The example below uses this to show the influence of the `$LANG` variable on file globbing (see the chapter on file globbing).

```console
student@linux:~/test$ touch Filea Fileb FileA FileB
student@linux:~/test$ env LANG=C bash -c 'ls File[[:alpha:]]'
FileA  FileB  Filea  Fileb
student@linux:~/test$ env LANG=en_US.UTF-8 bash -c 'ls File[[:alpha:]]'
Filea  FileA  Fileb  FileB
```

