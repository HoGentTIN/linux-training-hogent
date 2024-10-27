## script parameters

On the CLI, you often pass on options and arguments to a command to alter its behaviour. Bash *shell scripts* also can have options and arguments, called *positional parameters*. These parameters are stored in variables with names `${1}`, `${2}`, `${3}`, and so on.

```bash
#! /bin/bash --
echo "The first argument is ${1}"
echo "The second argument is ${2}"
echo "The third argument is ${3}"
```

If you save this script in a file called `pars.sh`, and make it executable, you can run it with parameters:

```console
[student@linux scripts]$ ./pars.sh one two three
The first argument is one
The second argument is two
The third argument is three
```

**Pay attention!** In many code examples you encounter on the Internet, you'll see the positional parameters referenced as `$1`, `$2`, `$3`, etc, without the braces. This is also valid in Bash. However, if you want to reference the tenth positional parameter and you write `$10`, Bash will interpret this as the value of the first positional parameter followed by a zero. To avoid this, you should always use braces around the number, like `${10}`. For example:

```bash
#! /bin/bash --

# Confusing use of positional parameters, this will not expand as expected
echo "The first argument is $1"
echo "The tenth argument is $10"
```

If you run this script (let's call it `tenparams.sh`):

```console
[student@linux scripts]$ ./tenparams.sh one two three four five six seven eight nine ten
The first argument is one
The tenth argument is one0
```

So, if you write a `$` followed by a number, only the first digit will be interpreted as the positional parameter! We recommend to always using braces to avoid this confusion.

```bash
#! /bin/bash --

# Confusing use of positional parameters, this will not expand as expected
echo "The first argument is ${1}"
echo "The tenth argument is ${10}"
```

When you run a script, other special pre-defined variables are available. The man page of `bash(1)` has a full list, but we list a few here.

| Variable | Description                                 |
| :------- | :------------------------------------------ |
| `${0}`   | The name of the script                      |
| `$#`     | The number of parameters                    |
| `$*`     | All the parameters (as one long string)     |
| `$@`     | All the parameters (as a list)              |
| `$?`     | The return code (0-255) of the last command |
| `$$`     | The process ID of the script                |

An example script that uses these variables:

```bash
#! /bin/bash --

cat << _EOF_
The script name is: ${0}
Number of arguments: $#
The first argument is ${1}
The second argument is ${2}
The third argument is ${3}
PID of the script: $$
Last return code: $?
All the arguments (list): $@
All the arguments (string): $*
_EOF_
```

The output would look like this (if you save the script in a file called `special-vars.sh`):

```console
[student@linux scripts]$ ./special-vars.sh one two three
The script name is: ./special-vars.sh
Number of arguments: 3
The first argument is one
The second argument is two
The third argument is three
PID of the script: 5612
Last return code: 0
All the arguments (list): one two three
All the arguments (string): one two three
```

If you pass on less parameters than the script expects, the missing parameters will be interpreted as empty strings. If you start the script with `set -o nounset` (or `set -u` for short), the script will exit with an error if you try to reference a positional parameter that was not passed on. When parsing parameters, always check the number of arguments first to avoid this.

## shift through parameters

The `shift` command will drop the first positional parameter, and move all the others one position to the left, i.e. `${1}` will dissapear, `${2}` will become `${1}`, `${3}` will become `${2}`, and so on.

Using a `while` loop in combination with `shift` statement, you can parse all parameters one by one. This is a sample script (called `shift.sh`) that does this:

```bash
#! /bin/bash --

if [ "$#" -eq "0" ] 
then
    echo "You have to give at least one parameter."
    exit 1
fi

while (( $# ))
do
    echo "arg: ${1}"
    shift
done
```

The `while` loop can also be written as `while [ "$#" -gt "0" ]`.

Below is some sample output of the script above.

```console
[student@linux scripts]$ ./shift.sh one
arg: one
[student@linux scripts]$ ./shift.sh one two three 1201 "33 42"
arg: one
arg: two
arg: three
arg: 1201
arg: 33 42
[student@linux scripts]$ ./shift.sh
You have to give at least one parameter.
```

## for loop through parameters

You can also use a `for` loop to iterate over the positional parameters. This is a sample script (called `for.sh`) that does this:

```bash
#! /bin/bash --

if [ "$#" -eq "0" ] 
then
    echo "You have to give at least one parameter."
    exit 1
fi

for arg in "${@}"
do
    echo "arg: ${arg}"
done
```

This script behaves in the same way as the `shift.sh` script. However, after the loop, all positional parameters are still available.

## runtime input

You can ask the user for input with the `read` command in a script.

```bash
#!/bin/bash
read -p 'Enter your name ' -r name
echo "Hello, ${name}!"
```

Use option `-p` to display a prompt, and `-r` to prevent backslashes from being interpreted as escape characters.

You can also use `read` to read lines from a file and then iterate on them.

```bash
#! /bin/bash --
while read -r line
do
    echo "line: ${line}"
done < inputfile.txt
```

Example output:

```console
[student@linux scripts]$ cat inputfile.txt
one
two
three
[student@linux scripts]$ ./readlines.sh
line: one
line: two
line: three
```

## sourcing a config file

The `source` (as seen in the shell chapters), or the shortcut `.` can be used to source a configuration file. With `source`, the specified file is executed *in the current shell*, i.e. without creating a subshell. Consequently, variables set in the configuration file are available in the script that sources the file.

Below a sample configuration file for an application.

```bash
[student@linux scripts]$ cat myApp.conf 
# The config file of myApp

# Enter the path here
myAppPath=/var/myApp

# Enter the number of quines here
quines=5
```

And here an application (`my-app.sh`) that uses this file.

```bash
#! /bin/bash --
#
# Welcome to the myApp application
# 

# Source the configuration file
. ./myApp.conf

echo "There are ${quines} quines"
```

The running application can use the values inside the sourced configuration file.

```console
[student@linux scripts]$ ./my-app.sh
There are 5 quines
```

## get script options with getopts

The `getopts` function allows you to parse options given to a command. The following script allows for any combination of the options a, f and z.

```bash
#! /bin/bash --

while getopts ":afz" option;
do
    case "${option}" in
        a)
            echo 'received -a'
            ;;
        f)
            echo 'received -f'
            ;;
        z)
            echo 'received -z'
            ;;
        *)
            echo "invalid option -${OPTARG}" 
            ;;
    esac
done
```

This is sample output from the script above. First we use correct options, then we enter twice an invalid option.

```console
student@linux$ ./options.ksh        
student@linux$ ./options.ksh -af
received -a
received -f
student@linux$ ./options.ksh -zfg
received -z
received -f
invalid option -g
student@linux$ ./options.ksh -a -b -z
received -a
invalid option -b
received -z
```

You can also check for options that need an argument, as this example script(`argoptions.sh`) shows.

```bash
#! /bin/bash --

while getopts ":af:z" option
do
    case $option in
        a)
            echo 'received -a'
            ;;
        f)
            echo "received -f with ${OPTARG}"
            ;;
        z)
            echo 'received -z'
            ;;
        :)
            echo "option -${OPTARG} needs an argument"
            ;;
        *)
            echo "invalid option -${OPTARG}"
            ;;
    esac
done
```

This is sample output from the script above.

```console
student@linux$ ./argoptions.sh -a -f hello -z
received -a
received -f with hello
received -z
student@linux$ ./argoptions.sh -zaf 42
received -z
received -a
received -f with 42
student@linux$ ./argoptions.sh -zf
received -z
option -f needs an argument
```

Additionally, there's a utility command called `getopt` (part of the GNU project) that can be used to parse complex cases with mixed use of long options (like `--verbose`), combinations of multiple short options (like `-abc` for `-a -b -c`), and options with arguments (like `-f file`). The `getopt` command will rewrite the command line options in a "canonical" form that is easier to parse with a `while` loop. However, `getopt` is not portable: BSD and macOS don't have GNU `getopt`, but they have their own version of `getopt` that is less powerful. Using `getopt` is out of the scope of this chapter.

## get shell options with shopt

You can toggle the values of variables controlling optional shell behaviour with the `shopt` built-in shell command. The example below first verifies whether the cdspell option is set; it is not. The next shopt command sets the value, and the third shopt command verifies that the option really is set. You can now use minor spelling mistakes in the `cd` command. The man page of `bash(1)` has a complete list of options.

```console
student@linux:~$ shopt -q cdspell ; echo $?
1
student@linux:~$ shopt -s cdspell
student@linux:~$ shopt -q cdspell ; echo $?
0
student@linux:~$ cd /Etc
/etc
```
