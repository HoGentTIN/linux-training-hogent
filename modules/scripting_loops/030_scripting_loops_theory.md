## test

The `test` command can evaluate **logical expressions** and indicate through their *exit status* whether the expression was *true* or *false*. In Bash, boolean values *do not exist* as a data type and are represented by the exit status of commands. *True* is represented by the exit status `0` (denoting that the command finished successfully), and *false* is represented by any other exit status (1-255, denoting any failure).

Let's start by testing whether 10 is greater than 55, and then show the exit status.

```console
[student@linux ~]$ test 10 -gt 55 ; echo $?
1
```

The test command returns 1 if the test fails. And as you see in the next screenshot, test returns 0 when a test succeeds.

```console
[student@linux ~]$ test 56 -gt 55 ; echo $?
0
```

If you prefer true and false, then write the test like this.

```console
[student@linux ~]$ test 56 -gt 55 && echo true || echo false
true
[student@linux ~]$ test 6 -gt 55 && echo true || echo false
false
```

## square brackets `[ ]`

The test command can also be written as square brackets. In this case, the final argument must be a closing square bracket `]`.

The screenshot below is identical to the one above.

```console
[student@linux ~]$ [ 56 -gt 55 ] && echo true || echo false
true
[student@linux ~]$ [ 6 -gt 55 ] && echo true || echo false
false
```

**Remark** that the square bracket is a **command** that takes arguments like any other command. Consequently, you **must** put a space between the square bracket and the arguments. You can check this fact by looking at the contents of the `/bin` directory.

```console
[vagrant@el ~]$ ls /bin | head -3
[
addr2line
alias
```

The first command in `/bin` is the square bracket!

**Remark** that there also exists a test written as `[[ ]]`. This is a **Bash built-in** and is more powerful than the square bracket. The double square bracket is a **keyword** and not a command. However, this notation is specific to recent versions of Bash and is not POSIX compliant. Using it makes your script less portable. We will not discuss this notation here.

## more tests

Below are some example tests. Take a look at the man page of `test(1)` and `bash(1)` (under *CONDITIONAL EXPRESSIONS*) to see more options for tests.

| Test                      | Description                                          |
| :------------------------ | :--------------------------------------------------- |
| `[ -d foo ]`              | Does the *directory* foo exist?                      |
| `[ -e bar ]`              | Does the file (or directory) bar *exist*?            |
| `[ -f foo ]`              | Is foo a *regular file*?                             |
| `[ -r bar ]`              | Is bar a *readable* file?                            |
| `[ -w bar ]`              | Is bar a *writeable* file?                           |
| `[ foo -nt bar ]`         | Is file foo newer than file bar?                     |
| `[ '/etc' = "${PWD}" ]`   | Is the string `/etc` *equal to* the variable `$PWD`? |
| `[ "${1}" != 'secret' ]`  | Is the first parameter *not equal to* `secret`?      |
| `[ 55 -lt "${bar}" ]`     | Is 55 *less than* the value of `${bar}`?             |
| `[ "${foo}" -ge '1000' ]` | Is the value of `${foo}` greater or equal to 1000?   |

Numerical values must be *integers*. Floating point numbers can not be interpreted by Bash.

Tests can be combined with logical AND and OR.

```console
student@linux:~$ [ 66 -gt 55 -a 66 -lt 500 ]; echo $?
0
student@linux:~$ [ 66 -gt 55 -a 660 -lt 500 ]; echo $?
1
student@linux:~$ [ 66 -gt 55 -o 660 -lt 500 ]; echo $?
0
```

However, the `-a` and `-o` options are deprecated and *not recommended*. Instead, use the `&&` and `||` operators.

```console
student@linux:~$ [ 66 -gt 55 ] && [ 66 -lt 500 ]; echo $?
0
student@linux:~$ [ 66 -gt 55 ] && [ 660 -lt 500 ]; echo $?
1
student@linux:~$ [ 66 -gt 55 ] || [ 660 -lt 500 ]; echo $?
0
```

## if then else

The `if then else` construction is about choice. If a certain condition is met, then execute something, else execute something else. The example below tests whether a file exists, and if the file exists then a proper message is echoed.

```bash
#!/bin/bash
file="isit.txt"

if [ -f "${file}" ]
then
    echo "${file} exists!"
else
    echo "${file} not found!"
fi
```

If we name the above script `choice.sh`, then it executes like this:

```console
[student@linux scripts]$ ./choice.sh
isit.txt not found!
[student@linux scripts]$ touch isit.txt
[student@linux scripts]$ ./choice.sh
isit.txt exists!
[student@linux scripts]$
```

## if then elif

You can nest a new `if` inside an `else` with `elif`. This is a simple example.

```bash
#!/bin/bash
count=42
if [ "${count}" -eq '42' ]
then
    echo "42 is correct."
elif [ "${count}" -gt '42' ]
then
    echo "Too much."
else
    echo "Not enough."
fi
```

## for loop

The example below shows the syntax of a typical `for` loop in bash.

```bash
for i in 1 2 4
do
    echo "${i}"
done
```

An example of a `for` loop combined with an embedded shell.

```bash
#!/bin/bash
for counter in $(seq 1 20)
do
    echo "counting from 1 to 20, now at ${counter}"
    sleep 1
done
```

The same example as above can be written without the embedded shell using the Bash `{from..to}` shorthand.

```bash
#!/bin/bash
for counter in {1..20}
do
    echo "counting from 1 to 20, now at ${counter}"
    sleep 1
done
```

This `for loop` uses file globbing (from the shell expansion). Putting the instruction on the command line has identical functionality.

```bash
[student@linux ~]$ ls
count.sh  go.sh
[student@linux ~]$ for file in *.sh ; do cp "${file}" "${file.backup}" ; done
[student@linux ~]$ ls                                                 
count.sh  count.sh.backup  go.sh  go.sh.backup 
```

The for loop you know from C-like programming languages like Java can also be used in Bash. However, it is much less common.

```bash
#!/bin/bash
for (( i=0; i<10; i++ ))
do
    echo "counting from 0 to 9, now at ${i}"
done
```

## while loop

Below a simple example of a `while loop`.

```bash
i=100;
while [ "${i}" -ge '0' ]
do
    echo "Counting down from 100 to 0, now at $i;"
    (( i-- ))
done
```

Endless loops can be made with `while true` or `while :` , where the colon `:` is the equivalent of *no operation* in the *Korn* and *Bash* shells.

```bash
#!/bin/ksh
# endless loop
while :
do
    echo "hello"
    sleep 1
done
```

## until loop

Below a simple example of an `until` loop.

```bash
i=100
until [ "${i}" -le '0' ]
do
    echo "Counting down from 100 to 1, now at ${i}"
    (( i-- ))
done
```

