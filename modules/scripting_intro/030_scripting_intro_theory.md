## introduction

When you open a terminal and type a command, you are using a *shell*, an interactive environment that interprets your commands, executes them, and shows you the output the command generates. Most Linux distributions have  Bash (the "Bourne Again Shell") as the default, but there are others as well: the original "Bourne shell" (`sh`), the "Debian Amquist Shell" (`dash`, a modern implementation of `sh`), the "Korn shell" (`ksh`), the "C shell" (`csh`), and the "Z shell" (`zsh`), to name a few.

A sequence of commands can be saved in a file and executed as a single command. This is called a *script*. Shell scripts are used to automate tasks, and are an essential tool for system administrators and developers. Subsequently, this means that system administrators or SysOps also need solid knowledge of *scripting* to understand how their servers and their applications are started, updated, upgraded, patched, maintained, configured and removed, and also to understand how a user environment is built.

Shells have also support for programming constructs (like loops, functions, variables, etc.) so that you can write more complex scripts. This makes a scripting language basically as powerful as a programming language. Scripting languages are often interpreted, rather than compiled.

If you copy a script to one of the `bin` directories (e.g. `/usr/local/bin`), you can execute it from the command line just like any other command. In fact, many UNIX/Linux commands are essentially `scripts`. You can check this for yourself by executing the `file` command on the executables in the `/bin` directory. For example:

```console
student@linux:~$ file /usr/bin/* | awk '{ print($2, $3, $4) }' \
  | sort | uniq -c | sort -nr
    466 ELF 64-bit LSB
    168 symbolic link to
     74 POSIX shell script,
     71 Perl script text
     14 Python script, ASCII
     10 setuid ELF 64-bit
      7 setgid ELF 64-bit
      6 Bourne-Again shell script,
      2 Python script, Unicode
      1 Python script, ISO-8859
```

We find POSIX (Bourne), Bash, Perl and Python scripts, as well as ELF binaries (compiled programs). This shows that a significant portion of the commands in a typical Linux system are actually scripts.

Bash scripting is a valuable skill for any Linux user, but these days, its applications are no longer limited to Linux. Bash is also present on macOS (albeit an older version), and with the advent of Windows Subsystem for Linux (WSL), Bash is now available for Windows users as well. Moreover, Git Bash, a Bash shell for Windows, is also available.

## hello world

Just like in every programming course, we start with a simple `hello_world` script. The following script will output `Hello World`.

```bash
echo Hello World
```

After creating this simple script in `nano`, `vi`, or with `echo`, you'll have to `chmod +x hello_world` to make it executable. And unless you add the scripts directory to your path, you'll have to type the path to the script for the shell to be able to find it.

```console
student@linux:~$ echo echo Hello World > hello_world
student@linux:~$ chmod +x hello_world 
student@linux:~$ ./hello_world 
Hello World
student@linux:~$
```

## she-bang

Let's expand our example a little further by putting `#!/bin/bash` on the first line of the script. The `#!` is called a `she-bang` (sometimes called `sha-bang`), where the `she-bang` is the first two characters of the script.

Open the file with `nano hello_world` of `vi hello_world` and add the following line at the top of the file.

```bash
#!/bin/bash
echo Hello World
```

You can never be sure which (interactive) shell a user is running. A script that works flawlessly in `bash` might not work in `ksh`, `csh`, or `dash`. To instruct a shell to run your script with a specific interpreter, you should start your script with a `she-bang` followed by the absolute path to the executable of the interpreter.

This script will run in a bash shell.

```bash
#!/bin/bash
echo -n hello
echo A bash subshell $(echo -n hello)
```

This script will be interpreted by Python:

```python
#!/usr/bin/env python3
print("Hello World!")
```

The following script will run in a Korn shell (unless `/bin/ksh` is a hard link to `/bin/bash`). The `/etc/shells` file contains a list of shells available on your system. Check it to see which ones are available to you

```bash
#!/bin/ksh
echo -n hello
echo a Korn subshell $(echo -n hello)
```

If you're not sure in which `bin` directory the shell executable is located,you can use `env`. The command `env` is normally used to print environment variables, but in the context of a script, it is used to launch the correct interpreter.

```bash
#!/usr/bin/env bash
echo -n hello
echo A bash subshell $(echo -n hello)
```

This is particularly useful for macOS users: out-of-the-box, a macOS system has a very old version of `bash` in `/bin/bash`. If you want to use a more recent version, you can install it with [Homebrew](https://brew.sh), that will put it in `/usr/local/bin/bash`. If you use `#!/usr/bin/env bash` in your scripts, the newer version will be used.

## comments

When writing Bash scripts, it is always a good practice to make your code clean and easily understandable. Organizing your code in blocks, indenting, giving variables and functions descriptive names are several ways to do this. Another way to improve the readability of your code is by using comments. A comment is a human-readable explanation or annotation that is written in the shell script.

Let's expand our example a little further by adding comment lines.

```bash
#!/usr/bin/env bash
#
# hello_world.sh -- My first script
#
echo Hello World

# this is old way of calling for subshell with backtick ``
echo A bash subshell `echo -n hello` 

# this is more modern way of calling for subshell with dollar and brackets $()
echo A bash subshell $(echo -n hello) 

#NOTICE: backtick might not work in future versions of bash shell
```

## extension

A general convention is to give files an extension that indicates the file type. On a Linux system, this is not strictly necessary. Remember that you can always use the `file` command to determine the type of a file by scanning its contents. The system will not care if you call your script `hello_world.sh` or `hello_world`. However, it is a good practice to use an extension, as it makes it easier to identify the type of file.

We recommend to always give your scripts the `.sh` extension, but to remove the extension when you install it in a `bin` directory as a command.

## shell variables

Here is a simple example of a shell variable used inside a script.

```bash
#!/bin/bash
# hello-user.sh -- example of a shell variable in a script
echo "Hello ${USER}"
```

In Bash, you can access the value of a variable by prefixing the variable name with the `$` sign. The braces are not mandatory in this case, but they are a good practice to avoid ambiguity. In some cases they are required, so it's best to be consistent in your coding style.

The variable `${USER}` is a shell variable that is defined by the system when you log in.

```console
student@linux:~$ chmod +x hello-user.sh 
student@linux:~$ ./hello-user.sh 
Hello student
```

## variable assignment

Assigning a variable is done by using the `=` operator. The variable name must start with a letter or an underscore, and can contain only letters, digits, or underscores. Remark that spaces are not allowed around the `=` sign!

```bash
#!/bin/bash
# hello-var.sh -- example of variable assignment
user="Tux"

echo "Hello ${user}"
```

Because variable names are case-sensitive, this variable `${user}` is different from `${USER}` in the previous example!

> **Tip: naming convention.**
> You can use any name for a variable, but it is a good practice to use all uppercase letters for environment variables (e.g. `${USER}`) and constants and all lowercase letters for local variables (e.g. `${user}`). This is also recommended by the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s7.2-variable-names). If a variable consists of multiple words, use underscores to separate them (e.g. `${current_user}`).

Running the script:

```console
student@linux:~$ chmod +x hello-var.sh
student@linux:~$ ./hello-var.sh
Hello Tux
```

Scripts can contain variables, but since scripts are run in their own subshell, the variables do not survive the end of the script.

```console
student@linux:~$ echo $user

student@linux:~$ ./hello-var.sh
Hello Tux
student@linux:~$ echo $user

student@linux:~$
```

## unbound variables

Remove the line `user="Tux"` from the script, or comment out the line and run it again. What do you expect to happen if the variable user is not assigned, but we try to use it in the script?

```console
student@linux:~$ ./hello-var.sh
Hello
```

Bash will not complain if you use a variable that is not assigned, but it will simply replace the variable with an empty string. This can lead to unexpected results and is a common cause of bugs that can be hard to find. However, you can change the behavior of the shell by starting your scripts with the command `set -o nounset` (or shorter: `set -u`). This will cause the script to exit with an error if you try to use an unassigned variable.

Add the line to the script, right below the comment lines and try again!

```bash
#!/bin/bash
# hello-var.sh -- example of variable assignment

set -o nounset

echo "Hello ${user}"
```

Running the script:

```console
student@linux:~$ ./hello-var.sh
./hello-var.sh: line 6: user: unbound variable
```

This is what you want to see. The script exits with an error, and you can see the line number where the error occurred and which variable is unbound. Start all your scripts with `set -o nounset` to prevent this kind of error!

## sourcing a script

Luckily, you can force a script to run in the same shell; this is called
`sourcing` a script.

```console
student@linux:~$ source hello-var.sh 
Hello Tux
student@linux:~$ echo $name
Tux
```

Instead of `source`, you can use the `.` (dot) command.

```console
student@linux:~$ . hello-var.sh 
Hello Tux
student@linux:~$ echo $name
Tux
```

## quoting

Go back to `hello-user.sh` and replace the double quotes with single quotes:

```bash
#!/bin/bash
# hello-user.sh -- example of a shell variable in a script
echo 'Hello ${USER}'
```

Run the script again:

```console
student@linux:~$ ./hello-user.sh
Hello ${USER}
```

What happened? By using single quotes, we turned off the shell's variable expansion. The shell will not replace `${USER}` with the value of the `USER` variable. This is why you should use double quotes when you want to use a variable.

Using quotes is important. Most of the times, when you reference the value of a variable, you should enclose it in double quotes. To illustrate this, write the following script:

```bash
#!/bin/bash
# create-file.sh -- example of using quotes
file="my file.txt"
touch $file
```

What we expect is that the script will create a file called `my file.txt`. However, when we run the script:

```console
student@linux:~$ ./create-file.sh
student@linux:~$ ls -l
total 4
-rwxr-xr-x 1 student student     88 Mar  6 16:20 create-file.sh
-rw-r--r-- 1 student student      0 Mar  6 16:20 file.txt
-rw-r--r-- 1 student student      0 Mar  6 16:20 my
```

So actually two files were created, one named `my` and the other `file.txt`. The reason has to do with the way Bash interprets a command and how it substitutes variables. The line

```bash
touch $file
```

is expanded to

```bash
touch my file.txt
```

without the quotes. The `touch` command now sees two arguments, `my` and `file.txt`, and creates two files. To fix this, you should always use double quotes:

```bash
#!/bin/bash
# create-file.sh -- example of using quotes
file="my file.txt"
touch "${file}"
```

Now the expansion of the variable is done within the quotes, and the `touch` command sees only one argument.

```console
student@linux:~$ ./create-file.sh
student@linux:~$ ls -l
total 4
-rwxr-xr-x 1 student student     92 Mar  6 16:20 create-file.sh
-rw-r--r-- 1 student student      0 Mar  6 16:20 'my file.txt'
```

## troubleshooting a script

Another way to run a script in a separate shell is by typing `bash` with the name of the script as a parameter. Expanding this to `bash -x` allows you to see the commands that the shell is executing (after shell expansion).

Try this with the `create-file.sh` script! The incorrect version without the quotes:

```console
$ bash -x create-file.sh 
+ file='my file.txt'
+ touch my file.txt
```

Notice the absence of the commented (#) line, and the replacement of the
variable in the argument `touch`.

After the fix, you get:

```console
$ bash -x create-file.sh
+ file='my file.txt'
+ touch 'my file.txt'
```

Do you notice the difference?

In longer scripts, this setting produces a lot of output, which may be hard to read. You can limit the output to a specific problematic part of your script by using `set -x` and `set +x` to turn the debugging on and off.

```bash
#!/bin/bash
# create-file.sh -- example of using quotes
file="my file.txt"

set -x
touch "${file}"
set +x
```

## Bash's "strict mode"

Apart from the `nounset` shell option, there are two other options that are very useful for debugging scripts: `set -o errexit` (or `set -e`) and `set -o pipefail`. The first option causes the script to exit with an error if any command fails. The second option gives better error messages when a command in a pipeline fails.

Start all your scripts with the following lines to prevent errors and to make debugging easier:

```bash
#!/bin/bash --
set -o nounset
set -o errexit
set -o pipefail
```

This is called "strict mode" by some. You can write this shorter in one line as `set -euo pipefail`, but this is less readable.

## prevent setuid root spoofing

Some user may try to perform `setuid` based script `root spoofing`. This is a rare but possible attack. To improve script security and to avoid interpreter spoofing, you need to add `--` after the `#!/bin/bash`, which disables further option processing so the shell will not accept any options.

```bash
#!/usr/bin/env bash -
or
#!/usr/bin/env bash --
```

Any arguments after the `--` are treated as filenames and arguments. An argument of `-` is equivalent to `--`.

