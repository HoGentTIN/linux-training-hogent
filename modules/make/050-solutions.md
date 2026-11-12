## solutions: make

The resulting `Makefile` after exercise 3 could look something like this:

```makefile
# Generic Makefile for C development. All .c files in the current directory
# will be compiled into binaries with the same name (without the .c
# extension)

#
# Special targets
#

.POSIX:     # Get reliable POSIX behaviour
.SUFFIXES:  # Clear built-in inference rules
.SECONDARY: # Don't delete intermediate files

.PHONY: help all clean mrproper install uninstall

#
# Variables
#
CC := gcc            # Compiler
CFLAGS := -Wall -O   # Compiler options

headers := $(wildcard *.h)
sources := $(wildcard *.c)
objects := $(patsubst %.c,%.o,$(sources))
executables := $(patsubst %.c,%,$(sources))

install_dir := /usr/local/bin

#
# Targets
#

help: ## Show this help message (default)
        @awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: $(executables) ## Build all binaries

# Pattern rule for linking the binary from the .o object file
%: %.o
        $(CC) $(CFLAGS) -o $@ $<

# Pattern rule for compiling an .o object file from the .c source
%.o: %.c $(headers)
        $(CC) $(CFLAGS) -c $<

clean: ## Remove intermediate files
        rm -f $(objects)

mrproper: clean ## Remove binaries and intermediate files
        rm -f $(executables)

install: all  ## Install binaries
        [ -d $(install_dir) ] || mkdir -p $(install_dir)
        install -m 755 $(executables) $(install_dir)

uninstall: ## Uninstall binaries
        rm -vf $(addprefix $(install_dir)/,$(executables))

```

Usage examples (starting with a "clean" directory):

```console
student@linux:~/bool$ ls
booleans.h  false.c  Makefile  maybe.c  true.c
student@linux:~/bool$ make
help                 Show this help message (default)
all                  Build all binaries
clean                Remove intermediate files
mrproper             Remove binaries and intermediate files
install              Install binaries
uninstall            Uninstall binaries
student@linux:~/bool$ make all
gcc             -Wall -O    -c false.c
gcc             -Wall -O    -o false false.o
gcc             -Wall -O    -c maybe.c
gcc             -Wall -O    -o maybe maybe.o
gcc             -Wall -O    -c true.c
gcc             -Wall -O    -o true true.o
student@linux:~/bool$ sudo make install
[ -d /usr/local/bin ] || mkdir -p /usr/local/bin
install -m 755 false maybe true /usr/local/bin
student@linux:~/bool$ which false
/usr/local/bin/false
student@linux:~/bool$ which maybe
/usr/local/bin/maybe
student@linux:~/bool$ touch true.c
student@linux:~/bool$ make all
gcc             -Wall -O    -c true.c
gcc             -Wall -O    -o true true.o
student@linux:~/bool$ make clean
rm -f false.o maybe.o true.o
student@linux:~/bool$ ls
booleans.h  false  false.c  Makefile  maybe  maybe.c  true  true.c
student@linux:~/bool$ make mrproper
rm -f false.o maybe.o true.o
rm -f false maybe true
student@linux:~/bool$ ls
booleans.h  false.c  Makefile  maybe.c  true.c
student@linux:~/bool$ sudo make uninstall
rm -vf /usr/local/bin/false /usr/local/bin/maybe /usr/local/bin/true
removed '/usr/local/bin/false'
removed '/usr/local/bin/maybe'
removed '/usr/local/bin/true'
```

If you remove the line with `.SECONDARY:` from the `Makefile` (or comment it out):

```console
student@linux:~/bool$ ls
booleans.h  false.c  Makefile  maybe.c  true.c
student@linux:~/bool$ make all
gcc             -Wall -O    -c false.c
gcc             -Wall -O    -o false false.o
gcc             -Wall -O    -c maybe.c
gcc             -Wall -O    -o maybe maybe.o
gcc             -Wall -O    -c true.c
gcc             -Wall -O    -o true true.o
rm false.o maybe.o true.o
student@linux:~/bool$ ls
booleans.h  false  false.c  Makefile  maybe  maybe.c  true  true.c
```

As you can see, the intermediate object files are deleted after the build.


