## GNU Make

Since `make` is part of the POSIX standard, there exist multiple implementations of the command. On Linux, the most common implementation is GNU Make, which is the version that will be used in this course. The GNU Make manual can be found at [https://www.gnu.org/software/make/manual/make.html](https://www.gnu.org/software/make/manual/make.html).

The disadvantage of having multiple implementations is that they are not all fully compatible with each other. Indeed, GNU Make has several extensions to the POSIX standard that are not supported by other implementations. This means that a `Makefile` written for GNU Make may not work with other implementations of `make`.

In this chapter, we will limit the use of these extensions to a minimum to keep the `Makefile' as portable as possible.

To follow the examples in the following sections, ensure that you have GNU Make and the GNU Compiler Collection installed on your system. On both Debian and Enterprise Linux, the package names are `make` and `gcc`, respectively. Of course, this is not a C course, so we will keep the examples as simple as possible.

## Makefile

In order to use `make`, you need to create a text file named `Makefile` (exactly like this: with a capital `M` and no filename extension) in the directory with your source files.

The general syntax of a "recipe" in a `Makefile` is as follows:

```makefile
target: source1 source2 ...
    command1
    command2
    ...
```

- `target` is the name of the file that you want to generate (e.g. `output.pdf`).
- `source1`, `source2`, ... are the names of the files that are used as input for generating the target (e.g. `input.tex`).
- `command1`, `command2`, ... are the commands that are executed to generate the target from the sources (e.g. `pdflatex input.tex`).
    - When executing a Makefile, the commands are printed to the terminal, so you can see what is happening. If you want to suppress this output, you can prefix the command with `@` (e.g. `@pdflatex input.tex`).
- The commands must be indented with a tab character, not spaces.

## a simple example

We will start with a simple example to illustrate the use of `make`. The goal is to compile a C program that prints "Hello World" to the terminal.

Create a directory `hello` and create a file `hello.c` in it with the following content:

```c
#include <stdio.h>
int main()
{
    printf("Hello World");
    return 0;
}
```

The command needed to compile this program is `gcc -o hello hello.c`. It takes the .c file as input and compiles it in to the executable binary file `hello`.

To avoid having to remember this command, we can create a `Makefile` with the following content:

```makefile
hello: hello.c
    gcc -o hello hello.c
```

The result:

```console
student@linux:~$ mkdir hello
student@linux:~$ cd hello
student@linux:~/hello$ nano hello.c
student@linux:~/hello$ nano Makefile
student@linux:~/hello$ ls -l
total 8
-rw-rw-r-- 1 student student 76 Nov 11 18:18 hello.c
-rw-rw-r-- 1 student student 37 Nov 11 18:19 Makefile
student@linux:~/hello$ make
gcc -o hello hello.c
student@linux:~/hello$ ls -l
total 24
-rwxrwxr-x 1 student student 15952 Nov 11 18:33 hello
-rw-rw-r-- 1 student student    76 Nov 11 18:18 hello.c
-rw-rw-r-- 1 student student    37 Nov 11 18:19 Makefile
student@linux:~/hello$ ./hello 
Hello Worldstudent@linux:~/hello$ make
make: 'hello' is up to date.
```

The command `make` will look for a file named `Makefile` in the current directory. It will read the first target in the file (in this case `hello`) and check if it is up to date. If it is not, it will execute the commands to build it. If it is up to date, it will print a message and do nothing.

Do you get an error like this?

```console
student@linux:~/hello$ make
Makefile:2: *** missing separator.  Stop.
```

Then you probably used spaces instead of a tab character to indent the command in the `Makefile`!

We see that the output of our little program doesn't have a newline at the end. We can fix this by changing the `printf` statement in `hello.c` to:

```c
printf("Hello World\n");
```

Next, we run `make` again. This time, it will detect that `hello.c` has changed and will recompile the program.

```console
student@linux:~/hello$ nano hello.c 
student@linux:~/hello$ make
gcc -o hello hello.c
student@linux:~/hello$ ./hello 
Hello World
```

## multiple prerequisites

In the next example, we will create a program that consists of multiple source files. We will reimplement the commands `true` and `false` that do nothing but return a success (0) or failure (1) exit status.

Create a new directory `bool` and create a file `booleans.h` with the following content:

```c
// booleans.h
int EXIT_TRUE  = 0;
int EXIT_FALSE = 2;
```

This file defines two constants that we will use in our programs. The exit status of our `true` implementation should be zero and the exit status of `false` should be nonzero. For now, the exit status of `false` is set to 2, which is not wrong, but we will change it to the more standard value of 1 later.

Next, create a file `true.c` with the following content:

```c
// true.c
#include "booleans.h"
int main(void)
{
    return EXIT_TRUE;
}
```

The program loads the constants defined in `booleans.h` and returns the value of `EXIT_TRUE` as the exit status.

You can write the `false.c` yourself!

Now, let's define the recipe to build the `true` and `false` binaries. The command to compile `true.c` is `gcc -o true true.c`. We don't need to specify `booleans.h` on the command line, because it is included in `true.c`. However, when we change the definition of one of the constants in `booleans.h`, we want to recompile `true.c` and `false.c`. Therefore, we will need to add `booleans.h` as a prerequisite for both targets. In the `Makefile`, this looks like:

```makefile
true: true.c booleans.h
    gcc -o true true.c
false: false.c booleans.h
    gcc -o false false.c
```

Executing `make true` will compile the `true` binary and executing `make false` will compile the `false` binary. Executing `make` without any arguments will build the first target in the `Makefile`, which is `true`. For convenience, we can add a `all` target that builds both binaries at the start of our `Makefile`.

```makefile
all: true false
```

Another common convenience is to add a `clean` target that removes the generated binaries. This is useful when you want to start from a clean slate, for example when you want to test if your `Makefile` works correctly.

```makefile
clean:
    rm -f true false
```

## phony targets

Now, `all` and `clean` are not the names of files that can be generated by their corresponding recipes. We can tell `make` that they are "phony" targets, and that the commands should always be executed.

This is done by adding the following line to the `Makefile`:

```makefile
.PHONY: all clean
```

The `.PHONY` special target is actually a GNU Make extension, and may not be available in all implementations of `make`. However, it is so widely used that we include it in our examples.

At this point, the `Makefile` looks like this:

```makefile
.PHONY: all clean
all: true false
true: true.c booleans.h
    gcc -o true true.c
false: false.c booleans.h
    gcc -o false false.c
clean:
    rm -f true false
```

Let's check if everything works as expected:

```console
student@linux:~/bool$ ls
booleans.h  false.c  Makefile  true.c
student@linux:~/bool$ make
gcc -o true true.c
gcc -o false false.c
student@linux:~/bool$ ls
booleans.h  false  false.c  Makefile  true  true.c
student@linux:~/bool$ ./true ; echo $?
0
student@linux:~/bool$ ./false ; echo $?
2
student@linux:~/bool$ if ./true; then echo "yes!"; else echo "no!"; fi
yes!
student@linux:~/bool$ if ./false; then echo "yes!"; else echo "no!"; fi
no!
```

Both binaries give the expected exit status ánd behave as expected when you use them in a conditional statement!

If you only want to build one of the binaries, specify the target on the command line. For example:

```console
student@linux:~/bool$ touch *.c
student@linux:~/bool$ make true
gcc -o true true.c
student@linux:~/bool$ make false
gcc -o false false.c
```

Let's change the exit status of `false` to the more standard value for indicating a failure. Change the definition of `EXIT_FALSE` in `booleans.h` to 1 and run `make` again. This time, `make` will detect that `booleans.h` has changed and will recompile both `true.c` and `false.c`.

```console
student@linux:~/bool$ nano booleans.h 
student@linux:~/bool$ make
gcc -o true true.c
gcc -o false false.c
student@linux:~/bool$ ./true ; echo $?
0
student@linux:~/bool$ ./false ; echo $?
1
```

The exit status of `false` is now 1, which is what we wanted.

To test what would happen if only the implementation of `true.c` changed, you can run the command `touch true.c`. This updates the timestamp of the file without changing its content. Since `true.c` is now newer than the generated binary `true`, `make` will recompile it. However, since `false.c` has not changed, it will not be recompiled.

```console
student@linux:~/bool$ touch true.c
student@linux:~/bool$ make
gcc -o true true.c
```

To clean up the directory, you can run `make clean`, which will remove the generated binaries.

```console
student@linux:~/bool$ ls
booleans.h  false  false.c  Makefile  true  true.c
student@linux:~/bool$ make clean
rm -f true false
student@linux:~/bool$ ls
booleans.h  false.c  Makefile  true.c
```

## pattern rules

Our `Makefile` works fine, but it already contains some copy/paste patterns. The commands to compile `true.c` and `false.c` are basically the same, except for the name of the target and the source file. In a `Makefile`, you can use so-called pattern rules to avoid this duplication. Pattern rules are the heart of a `Makefile` and allow you to write very generic recipes that can be used for multiple targets.

In our example, we can replace the two rules for `true` and `false` with a single pattern rule:

```makefile
all: true false
%: %.c booleans.h
    gcc -o $@ $<
```

The `%` is a wildcard that matches any string. Make won't know with which value(s) it can replace the `%`, but since we defined the `all` target with prerequisites `true` and `false` and we don't have any other rules for these targets, `make` will use the pattern rule to build them.

The `$@` is a special variable that expands to the name of the target (e.g. `true` or `false`) and the `$<` expands to the name of the first prerequisite (e.g. `true.c` or `false.c`). There are several other special variables that you can use in your `Makefile`. You can find a complete list in the [GNU Make manual](https://www.gnu.org/software/make/manual/make.html#Automatic-Variables). Unfortunately, the names of these variables are not very descriptive, which is inconvenient.

Replace the two rules for `true` and `false` in your `Makefile` with the pattern rule above and check if everything still works as expected.

```console
student@linux:~/bool$ nano Makefile 
[ ... make the necessary changes ... ]
student@linux:~/bool$ touch *.c
student@linux:~/bool$ make
gcc -o true true.c
gcc -o false false.c
```

## defining variables

In a `Makefile`, you can define variables to store values that you want to use multiple times. Variables are defined using the syntax `VARIABLE_NAME := value`. For example, we could define variables for the compiler and any options we want to pass to the compiler. This way, if we want to change the compiler or the options, we only need to change it in one place, at the beginning of the `Makefile`. For example, we could define a variable `CC` for the compiler and a variable `CFLAGS` for the options:

```makefile
CC := gcc
CFLAGS := -Wall -O
```

The option `-Wall` enables all compiler warnings and the option `-O` enables optimizations.

The value of a variable can be retrieved by using the syntax `$(VARIABLE_NAME)`. For example, we can use the variables `CC` and `CFLAGS` in our pattern rule:

```makefile
%: %.c booleans.h
    $(CC) $(CFLAGS) -o $@ $<
```

Let's try:

```console
student@linux:~/bool$ nano Makefile
[ ... make the necessary changes ... ]
student@linux:~/bool$ touch *.c
student@linux:~/bool$ make
gcc -Wall -O -o true true.c
gcc -Wall -O -o false false.c
```

The options `-Wall` and `-O` are now passed to the compiler.

## built-in functions

As our project grows, we will probably add more source files. Instead of having to add each source file to the `all` target, we can define a variable `sources` that contains a list of all the source files (*.c) and a variable `executables` with a list of all the binaries that we want to generate. Make has built-in functions that help us to generate these lists:

```makefile
sources := $(wildcard *.c)
executables := $(patsubst %.c,%,$(sources))
headers := $(wildcard *.h)
```

The `wildcard` function returns a list of all files that match the given pattern (in this case, all .c files in the current directory). The `patsubst` function (short for *pattern substitution*) replaces the pattern `%.c` with `%` in each element of the list of sources, effectively removing the .c extension and giving us a list of executables.

For other built-in functions, see the GNU Make manual chapter on [Functions for Transformating Text](https://www.gnu.org/software/make/manual/make.html#Functions).

Update the `Makefile` to use these variables, use the value of `$(executables)` where appropriate and check if everything still works as expected.

```console
student@linux:~/bool$ nano Makefile 
[ ... make the necessary changes ... ]
student@linux:~/bool$ touch *.c
student@linux:~/bool$ make
gcc -Wall -O -o false false.c
gcc -Wall -O -o true true.c
```

This version of our `Makefile` is very generic. Without ever explicitly mentioning the names of the source files or the binaries, it correctly deduces that it needs to compile `true.c` and `false.c` into the binaries `true` and `false`. If we add a new source file, for example `maybe.c`, it will automatically be included in the build process.

Create a file `maybe.c` with the content given below. It will return either a success (0) or failure (1) exit status at random.

```c
#include "booleans.h"
#include <stdlib.h>
#include <time.h>

int main(void)
{
        srand(time(NULL)); // seed rng with current time

        // Generate a random integer.
        // If even, return TRUE, else FALSE
        if (rand() % 2 == 0) {
                return EXIT_TRUE;
        } else {
                return EXIT_FALSE;
        }
}
```

Without any change to the Makefile, we can now build the `maybe` binary as well:

```console

student@linux:~/bool$ make
gcc -Wall -O -o maybe maybe.c
student@linux:~/bool$ ./maybe ; echo $?
1
student@linux:~/bool$ ./maybe ; echo $?
0
student@linux:~/bool$ ./maybe ; echo $?
0
```

The binaries `true`, `false` were up to date, so they were not recompiled. However, the new source file `maybe.c` was compiled into the binary `maybe`. The exit status of `maybe` is random, as expected.

## special built-in targets

The line starting with `.PHONY` is an example of a special built-in target. There are several other special built-in targets that you can use in your `Makefile`. You can find a complete list in the [GNU Make manual](https://www.gnu.org/software/make/manual/make.html#Special-Targets).

The following built-in targets are particularly useful:

- `.POSIX:` This target tells `make` to follow the POSIX standard as closely as possible. This can be useful if you want to write a `Makefile` that is portable across different platforms or implementations of `make`.

- `.SECONDARY:` If you want to keep the intermediate files generated during the build process, you can add this target to your `Makefile`. By default, `make` will delete these files after the build is complete. This can be useful for debugging or if you want to inspect the intermediate files.

- `.SUFFIXES:` `make` was designed for building C programs, so it has some implicit built-in rules for that particular purpose. Adding an empty `.SUFFIXES:` target to your `Makefile` will remove all these implicit rules, which can be useful if you want to avoid any unexpected behavior when using `make` for other purposes.

Usually, it is a good practice to start your `Makefile` with the following lines:

```makefile
.POSIX:     # Get reliable POSIX behaviour
.SUFFIXES:  # Clear built-in inference rules
.SECONDARY: # Don't delete intermediate files
```

## documenting your Makefile

Here's a trick that you can use to document how to use your `Makefile`. Add this as the first target in your `Makefile`:

```makefile
help: ## Show this help message (default)
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
```

The idea is that you add a comment starting with `##` after each target in your `Makefile` that a user may want to specify on the command line. The `help` target will then print the name of the target and the comment, nicely formatted.

The `awk` command is prefixed with `@` to prevent printing the command itself. The `awk` command uses a regular expression to match lines in the `Makefile` that define a target and have a comment starting with `##`. It then prints the name of the target and the comment, with some formatting to make it look nice.

Add appropriate comments to the targets in your `Makefile` and check what happens when you run `make`:

```console
student@linux:~/bool$ nano Makefile 
[ ... make the necessary changes ... ]
student@linux:~/bool$ make
help                 Show this help message (default)
all                  Build all binaries
clean                Remove all compiled binaries
```

## other common targets

Here are some other common targets that you may want to add to your `Makefile`:

- Some `Makefile`s have two cleanup tasks: one for removing auxiliary, intermediate files (usually called `clean`) and one for removing all generated files (usually called `distclean` or `mrproper`). The latter usually has the `clean` target as a prerequisite, so that it will also remove the intermediate files.

- A `Makefile` can have an `install` target that copies the generated binaries to a system-wide location (e.g. `/usr/local/bin`, specified in a variable) so that they can be used by other users on the system. This target usually requires superuser privileges, so it is common to run it with `sudo make install`. For our little example, a possible implementation could be:

    ```makefile
    install_dir := /usr/local/bin

    install: all ## Install binaries
        [ -d $(install_dir) ] || mkdir -p $(install_dir)
        install -m 755 $(executables) $(install_dir)
    ```

    This will create the installation directory if it doesn't exist and copy the binaries to that directory with the correct permissions.

    ```console
    student@linux:~/bool$ sudo make install
    [ -d /usr/local/bin ] || mkdir -p /usr/local/bin
    install -m 755 false maybe true /usr/local/bin
    student@linux:~/bool$ ls /usr/local/bin
    false maybe true
    student@linux:~/bool$ which true
    /usr/local/bin/true
    student@linux:~/bool$ which maybe
    /usr/local/bin/maybe
    ```

    On this system, from now on, our own implementations of `true`, `false` and `maybe` will be used instead of the system-wide versions!

- An `uninstall` target can be added to remove the installed binaries, e.g.:

    ```makefile
    uninstall: ## Uninstall binaries
        rm -vf $(addprefix $(install_dir)/,$(executables))
    ```

    The `addprefix` function adds the installation directory as a prefix to each of the binaries in the list of executables. The `-v` option of `rm` prints the name of each file that is removed.

    Usage:

    ```console
    student@linux:~/bool$ sudo make uninstall 
    rm -vf /usr/local/bin/false /usr/local/bin/maybe /usr/local/bin/true
    removed '/usr/local/bin/false'
    removed '/usr/local/bin/maybe'
    removed '/usr/local/bin/true'
    ```

- You can add targets for running tests, generating documentation, packaging the project, etc. The possibilities are endless!

## task runners

If you find yourself writing a `Makefile` that doesn't really have any pattern rules, but only `.PHONY` targets that execute a series of commands, you are probably using `make` as a *task runner*, rather than a build tool.

This is not necessarily a bad thing, but it is worth considering if there are other tools that are better suited for this purpose. These tools are usually more user-friendly and have more features for this specific use case.

Examples include [Grunt](https://gruntjs.com), [Gulp](https://gulpjs.com), [Invoke](https://www.pyinvoke.org/), [just](https://just.systems/), [Rake](https://ruby.github.io/rake/), etc.

They are not part of the POSIX standard, so they are not available on all systems. Therefore, they are out of the scope of this course. However, if you are interested in using one of these tools, installing is easy and you can find plenty of documentation and tutorials online.

