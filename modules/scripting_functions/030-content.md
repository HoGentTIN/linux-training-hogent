## defining a function

This example defines a **function** with name `my_function`:

```bash
my_function() {
    printf 'Hello world!\n'
}
```

There is an alternative syntax for a function definition, like in the example below, but this is less portable and therefore not recommended:

```bash
function my_function {
    printf 'Hello world!\n'
}
```

It is not possible to specify arguments or a return type, these are handled differently. That means that the brackets `()` in the function definition should always be empty!

Also, a Bash function does not return a value, so it actually behaves more like a **procedure** than a function. It is more useful to think about Bash functions as custom commands for private use.

## calling a function

You call a function by using the function name as a command:

```bash
my_function
```

Which would produce the output `Hello world!`

## passing arguments to functions

You can pass arguments to a function like you pass arguments to a command. Inside a function, the positional parameters and related variables (`$#`, `$*`, `$@`, `${1}`, `${2}`, ...) will be re-initialized to the arguments added to the function call.
 
Consider the following script, `greeter.sh`:

```bash
#! /bin/bash

greet() {
    printf 'Hello %s!\n' "${1}"
}

greet Paul
```

The function `greet()` will print out a message using the first argument that it got. On the last line of the script, we call the function with argument `paul`, which will result in the output `Hello paul!`.

Remark that this implies that it is not really possible to limit the number of arguments that you pass to a function and what their type should be. Calling the function like this:

```bash
greet Paul John George Ringo
```

will not produce an error and will in fact result in the same output as the original version. The positional parameters `${2}`, `${3}`, and `${4}`, will be initialized, but since they are never used, this has no impact on the behavior of the script.

## documenting the expected number of arguments

In larger functions that expect multiple arguments, the positional parameter variables make the code harder to read. For example, the following function will generate a passphrase selecting the specified number (second argument) of random words from a dictionary file (first argument). 

```bash
generate_passphrase() {
  if [ ! -f "${1}" ]; then
    printf 'Not a file: %s\n' "${1}" >&2
    return 1
  fi

  shuf "${1}" | head -"${2}" | tr '\n' ' '
  printf '\n'
}
```

This code is not easy to interpret since it's not very clear what `${1}` and `${2}` mean.

You can document the expected number of arguments by initializing variables with descriptive names and assign the value of a positional parameter. A comment explaining the expected usage is also recommended:

```bash
# Usage: generate_passphrase DICTIONARY NUM_WORDS
#  generates a pass phrase by selecting the specified number of words at random
#  from the specified dictionary file.
generate_passphrase() {
  local dictionary="${1}"
  local num_words="${2}"

  if [ ! -f "${dictionary}" ]; then
    printf 'Not a file: %s\n' "${dictionary}" >&2
    return 1
  fi

  shuf "${dictionary}" \
    | head --lines="${num_words}" \
    | tr '\n' ' '
  printf '\n'
}
```

The first two lines of the function indicate that it expects two arguments, the first being a dictionary and the second the number of words. In the function body, using the more descriptive variable names makes the code more readable.
 
## return status

As stated before, it is not possible to specify a return type and in fact, a Bash function only has an *exit status* like a command. The exit (or return) status of a function is either the status of the last command that was executed inside the function, or the status specified with the builtin command `return STATUS`, with `STATUS` an integer value between 0 and 255. Return status 0 is interpreted as *success* or a logical *true*, any other value as *failure* or a logical *false* (just like commands!).

In the example below, the functions `true_f` and `false_f` behave like the corresponding boolean commands `true` and `false`:

```bash
true_f() {
    return 0
}

false_f() {
    return 1
}
```

## returning a value

In order to return an actual (string or integer) value, print it out to stdout and catch the output using command substitution. For example:

```bash
#! /bin/bash

get_greeting() {
    printf 'Hello %s!\n' "${1}"
}

message=$(get_greeting Paul)

echo "${message}"
```

Here, whatever the function `get_greeting()` prints to stdout, is stored in the variable `${message}`.

## variable scope

A variable that is declared within a function has the same scope as a "global" variable. Consider the following script:

```bash
#! /bin/bash

greet() {
  name="${1}"
  printf 'Hello %s!\n' "${user}"
}

greet Paul

echo "${user}"
```

In this example, you would expect that the output should be:

```text
Hello Paul!

```

The variable `${user}` was defined inside the function, so you would expect that once the function call has ended, this variable is no longer accessible. However, in Bash, all variables are added to the context of the current shell. So, the output will in fact be:

```text
Hello Paul!
Paul
```

You can limit the scope of a variable to the function where it is declared with the `local` builtin:

```bash
#! /bin/bash

greet() {
  local name="${1}"
  printf 'Hello %s!\n' "${user}"
}

greet Paul

echo "${user}"
```

In this case the output will be as expected, since the variable `${name}` will be unset at the end of the function execution.

It is recommended to declare all variables defined in functions as `local` 

## dynamic scope

Consider the following script:

```bash
#!/bin/bash

var='val global'

func1() {
  local var='val func1'
  func2
}

func2() {
  printf '%s\n' "${var}"  
}

func1
func2
```

What will the output of this script be, `val global` or `val func1`? In a language with *static scoping*, the value of unbound variables is searched in the context where the function was *defined*. In that case, retreiving the value of `${var}` inside of `func2()` would result in `var global`.

However, Bash uses *dynamic scoping*, so the value of the variable `${var}` is searched in the context where the function was *called*. In this case, when `func1()` calls `func2()`, the "global" value of `${var}` is masked by the declaration of the local variable in `func1()`.

Consequently, the output of the script will be:

```text
val func1
val global
```

## predicates

A Bash function is useful for defining a predicate (i.e. a function with a boolean return value) when an `if` condition becomes too complex.

For example, consider the following script where we want to ensure that a specific user is present on the current system. The `useradd` command will fail if the user already exists, so we first need to check if it is necessary to create them.

```bash
#! /bin/bash

user=student

if ! getent passwd "${user}" > /dev/null 2>&1
then
    printf 'Creating user %s\n' "${user}" >&2
    useradd --user-group --create-home --shell /bin/bash "${user}"
else
    printf 'User %s already exists' "${user}" >&2
fi
```

The command `getent passwd "${user}"` checks if the specified user exists, and returns status 0 if they do. If they don't exist, exit status 2 is returned. The command may produce output, so stdout and stderr is sent to `/dev/null`. The `if` condition has become quite wordy and becomes harder to read. You could rewrite the script as follows:

```bash
#! /bin/bash

user=student

# Usage: is_user_present USER
#  Predicate that checks whether the specified USER exists.
is_user_present() {
    local user_name="${1}"
    getent passwd "${user_name}" > /dev/null 2>&1
}

if ! is_user_present "${user}"
then
    printf 'Creating user %s\n' "${user}" >&2
    useradd --user-group --create-home --shell /bin/bash "${user}"
else
    printf 'User %s already exists' "${user}" >&2
fi
```

This way, the `if` condition becomes more readable.

## conclusion

- Bash functions are more like *procedures* than functions.
- They behave like commands in that they take *positional parameters* and have an *exit (return) status*.
- If you want a function to yield a value other than the return status, print it to stdout and capture it using command substitution.
- All variables have *global scope*, unless they are declared `local` to the function.
- Bash uses *dynamic scoping* to search the value of unbound variables.
- It is recommended to document the expected arguments by assigning positional parameters to local variables with descriptive names in the beginning of the function body.


