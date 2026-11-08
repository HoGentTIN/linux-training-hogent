## case

You can sometimes simplify nested if statements with a `case` construct. For example, the following script uses a `case` statement:

```bash
#!/bin/bash
#
# help.sh - Wild Animals Helpdesk Advice
#
read -rp "What animal did you see ? " animal
case "${animal}" in
        "lion" | "tiger")
                echo "You better start running fast!"
                ;;
        "cat")
                echo "Let that mouse go..."
                ;;
        "dog")
                echo "Don't worry, give it a cookie."
                ;;
        "chicken" | "goose" | "duck" )
                echo "Eggs for breakfast!"
                ;;
        "liger")
                echo "Approach and say 'Ah you big fluffy kitty...'."
                ;;
        "babelfish")
                echo "Did it fall out your ear ?"
                ;;
        *)
                echo "You discovered an unknown animal, name it!"
                ;;
esac
```

Running the script produces the following output:

```console
[student@linux ~]$ ./help.sh
What animal did you see ? lion
You better start running fast!
[student@linux ~]$ ./help.sh
What animal did you see ? dog
Don't worry, give it a cookie.
```

The syntax of the `case` statement is as follows:

```bash
case STRING_VALUE in
        PATTERN11 | PATTERN12 )
                COMMANDS
                ;;
        PATTERN21 | PATTERN22 | PATTERN23 )
                COMMANDS
                ;;
        * )
                COMMANDS
                ;;
esac
```

A given `STRING_VALUE` is compared against the globbing patterns in the `case` statement. You can use the `|` operator to separate multiple patterns that should match the same commands.

The patterns are terminated with a bracket `)`, which is a bit weird, since we're used to always having balanced brackets in code. In fact, you *can* write an opening bracket before the pattern, but this is very rarely done in practice.

If a match is found, the corresponding commands are executed. The list of commands must be terminated with a double semicolon `;;`. The `case` command completes when it encounters a `;;`. A `case' statement is terminated with the `esac` keyword, which is `case` spelled backwards.

Since patterns can contain globbing characters, you can use `*` to match any string. This is often used as a catch-all pattern at the end of the `case` statement.

Here's an example with some more globbing patterns:

```bash
#! /bin/bash
#
# casedemo.sh - Demonstrate the case statement
#
case "${1}" in
  [Hh?] | [Hh][Ee][Ll][Pp] )
    echo "If you need help, try the man pages"
    ;;
  [Aa]* )
    echo "${1} starts with an A"
    ;;
  ??? )
    echo "${1} has three characters"
    ;;
  -* )
    echo "That looks like an option"
    ;;
  * )
    echo "Sorry, I didn't understand"
    ;;
esac
```

```console
[student@linux ~]$ ./casedemo.sh HeLp
If you need help, try the man pages
[student@linux ~]$ ./casedemo.sh ?
If you need help, try the man pages
[student@linux ~]$ ./casedemo.sh apple
apple starts with an A
[student@linux ~]$ ./casedemo.sh cat
cat has three characters
[student@linux ~]$ ./casedemo.sh -v
That looks like an option
[student@linux ~]$ ./casedemo.sh banana
Sorry, I didn't understand
```

What output would `./casedemo.sh abc` produce?

Finally, here's an example of a `case` statement that is used to parse command line arguments. The idea is to loop over the positional parameters with `while`, check the first positional parameter with `case`, and then shift it away to move to the next one.

```bash
#! /bin/bash
#
# Usage: info.sh [OPTION]... [FILE]...
# 
# The script builds a format string for stat from the options given on the
# command line, and prints the output in neat columns.

# The format string always starts with the file name
format_string='%n'

# Loop for parsing CLI arguments
while [ "$#" -gt '0' ]; do

  # Check the first positional parameter
  case "${1}" in

    # Was help asked? Print usage message and exit the script immediately
    -h | --help )
      printf 'Usage: %s [OPTION]... [FILE]...\n\n' "${0}"
      printf '  Show info about files:\n\n  OPTIONS:\n'
      grep '[^*])$' "${0}" | sed 's/)$//'
      exit 0
      ;;

    # Several options (with a short and long variant) that expand the format
    # string with the appropriate code. We use the colon as a separator.
    -g | --group )
      format_string="${format_string}:%G"
      ;;
    -p | --permissions )
      format_string="${format_string}:%A"
      ;;
    -s | --size )
      format_string="${format_string}:%s"
      ;;
    -t | --type )
      format_string="${format_string}:%F"
      ;;
    -u | --user )
      format_string="${format_string}:%U"
      ;;

    # Catch-all rule for any option not described above (e.g. -b, --verbose,
    # etc.). Immediately exit the script with an error code.
    -*)
      printf 'Unrecognized option: %s\n' "${1}" >&2
      exit 2
      ;;

    # If a positional parameter does not start with a -, it's an argument,
    # rather than an option. All remaining parameters should be considered to
    # be arguments (i.e. file names), so break out of the while loop.
    *)
      break
      ;;
  esac

  # After processing a positional parameter, shift it away and move to the 
  # next one.
  shift
done

# If no positional parameters remain, then no arguments were given.
# In that case, take all files (*) in the current directory.
if [ "$#" -eq '0' ]; then
  set ./*
fi

# If you want to see the resulting stat command, uncomment the next line
# set -x

# Use stat to print the requested info of the remaining positional parameters
# and pipe the output to column to format it nicely. The colon is now used
# to separate the different "fields".
stat --printf="${format_string}\n" "${@}" \
  | column -t -s ':'
```

Try it out in a directory with some files and try the different options. For example:

```console
[student@linux ~]$ ls
 casedemo.sh   help.sh   info.sh  'my file.txt'
 README.txt   tennis.txt   while.sh
[student@linux ~]$ ./info.sh -u --permissions
./casedemo.sh  student  -rwxr-xr-x
./help.sh      student  -rwxr-xr-x
./info.sh      student  -rwxr-xr-x
./my file.txt  student  -rw-r--r--
./README.txt   student  -rw-r--r--
./tennis.txt   student  -rw-r--r--
./while.sh     student  -rw-r--r--
[student@linux ~]$ ./info.sh -t -s *.txt
my file.txt  regular file  128
README.txt   regular file  4067
tennis.txt   regular file  51
```

## arithmetics

Bash was not designed to be a full-fledged programming language and we use it mainly to automate system administration tasks. Arithmetic is consequently not a strong point of Bash. It is possible to perform some calculations and logical operators on integer values, but floating point numbers are not supported at all. For more advanced calculations, you can use the `bc` command (or use a scripting or programming language that is more suited for mathematical operations).

There are several ways to perform arithmetic operations in shell scripts. Some are defined by the POSIX standard (and are therefore more portable), others are specific to Bash. We won't go into details here, but will show you the most common ways to perform arithmetic operations in Bash.

The most common ways are:

- `$(( ))` - arithmetic expansion
- `(( ))` - compound command for arithmetic evaluation
- `let` - built-in command for arithmetic evaluation

The builtin `let` is subject to word splitting and pathname expansion, so it is recommended to use the `(( ))` compound command instead.

## arithmetic expansion

In Bash, you can use the `$(( ))` syntax to perform arithmetic expansion. This allows you to evaluate an arithmetic expression and substitute its result into the command line. Basically: use arithmetic expansion if you need the result of a calculation.

```console
student@linux:~$ echo $(( 1 + 1))
2
student@linux:~$ echo $(( 2 - 4 ))
-2
student@linux:~$ echo $(( 123 * 456 ))
56088
student@linux:~$ echo $(( 9 / 2 ))
4
student@linux:~$ echo $(( 9 % 2 ))
1
student@linux:~$ echo $(( 2 ** 16 ))
65536
student@linux:~$ echo $(( 999999999999999999 * 10 ))
-8446744073709551626
student@linux:~$ echo $(( 9223372036854775806 + 1))
9223372036854775807
student@linux:~$ echo $(( 9223372036854775807 + 1))
-9223372036854775808
```

We already see a few caveats here. The division operator `/` performs integer division, so if the result is not an integer, it will be truncated. Use the modulo operator `%` to get the remainder of a division.

Also, the last examples show that Bash's arithmetic expansion doesn't check for overflow, so when calculating large numbers, the result may not be what you would expect. The maximum value for a signed 64-bit integer is 9223372036854775807, so adding 1 will cause an overflow.

You can use variables in arithmetic expansion as well. The use of the `$` is optional.

```console
student@linux:~$ x=42
student@linux:~$ echo $(( x + 1 ))
43
student@linux:~$ echo $(( $x + 1 ))
43
student@linux:~$ echo $(( ${x} + 1 ))
43
```

Evaluating logical expressions is also possible:

```console
student@linux:~$ echo $(( x < 100 ))
1
student@linux:~$ echo $(( x > 100 ))
0
student@linux:~$ echo $(( x == 42 ))
1
```

Remark that true is represented by 1 and false by 0, which is the opposite of how Bash normally evaluates exit codes, where 0 is true and non-zero is false. This may be very confusing, so be careful when using arithmetic expansion in conditional statements!

## arithmetic evaluation compound command

The `(( ))` compound command allows you to evaluate arithmetic expressions. It is similar to `$(( ))`, but it does not perform substitution of the result into the command line. Instead, it returns an exit status of 0 (true) if the expression evaluates to a non-zero value, and 1 (false) if the expression evaluates to zero.

```console
student@linux:~/test42$ (( 42 > 33 )) && echo true || echo false
true
student@linux:~/test42$ (( 42 > 1201 )) && echo true || echo false
false
student@linux:~/test42$ var42=42
student@linux:~/test42$ (( 42 == var42 )) && echo true || echo false
true
student@linux:~/test42$ (( 42 == $var42 )) && echo true || echo false
true
student@linux:~/test42$ var42=33
student@linux:~/test42$ (( 42 == var42 )) && echo true || echo false
false
```

You can use the `(( ))` compound command in conditional statements, such as `if` and `while`, to evaluate arithmetic expressions.

The following example also shows how to decrement the value of a variable with the `--` operator.

```console
student@linux:~$ i=10
student@linux:~$ while (( i-- )); do printf '%d' "${i}"; done
9876543210
```

In the first iteration of the loop, `i` is 10 and the expression `i--` evaluates to the value of `i` before it is decremented, i.e. 10. This is nonzero, so the exit status of the compound command is 0 (true) and the loop body is executed. At this time, the value of `i` is decremented to 9, which is printed.

This continues to the iteration where `i` is 1. Now, the expression `i--` evaluates to 1. This is still nonzero, so the exit status of the compound command is 0 (true) and the loop body is executed, printing 0.

In the next iteration, `i` is 0 and the expression `i--` evaluates to 0. This is zero, so the exit status of the compound command is 1 (false) and the loop terminates.

Other operators supported by the `(( ))` compound command are:

- `+`, `-`, `*`, `/`, `%`, `**` - arithmetic operators
- `++`, `--` - increment and decrement operators (prefix and postfix)
- `+=`, `-=`, `*=`, `/=`, `%=` - compound assignment operators
- `==`, `!=`, `<`, `>`, `<=`, `>=` - comparison operators
- `&&`, `||`, `!` - logical AND, OR, and NOT operators
- `&`, `|`, `^`, `~`, `<<`, `>>` - bitwise operators (and, or, xor, not, left shift, right shift, respectively)

## eval

`eval` reads arguments as input to the shell, i.e. dynamically evaluates and executes code that is constructed or stored in a variable.

This allows e.g. using the value of a variable as a variable.

```console
student@linux:~/test42$ answer=42
student@linux:~/test42$ word=answer
student@linux:~/test42$ eval x=\$$word ; echo $x
42
```

Both in `bash` and `Korn` the arguments can be quoted.

```console
kahlan@solexp11$ answer=42
kahlan@solexp11$ word=answer
kahlan@solexp11$ eval "y=\$$word" ; echo $y
42
```

For this use case, Bash has specific syntax, referred to as *indirect substitution*. This may be preferrable to using `eval`, but it is less portable as it won't work in `sh` or `zsh`.

```console
student@linux:~/test42$ x="${!word}" ; echo $x
42
```

Sometimes the `eval` is needed to have correct parsing of arguments. Consider this example where the `date` command receives one parameter `1 week ago`.

```console
student@linux~$ date --date="1 week ago"
Thu Mar  8 21:36:25 CET 2012
```

When we set this command in a variable, then executing that variable fails unless we use `eval`.

```console
student@linux~$ lastweek='date --date="1 week ago"'
student@linux~$ $lastweek
date: extra operand `ago"'
Try `date --help' for more information.
student@linux~$ eval $lastweek
Thu Mar  8 21:36:39 CET 2012
```

Be aware that using `eval` is a security risk. Evaluating code based on user input opens the door to command injection and has been the root cause of real-world vulnerabilities.


