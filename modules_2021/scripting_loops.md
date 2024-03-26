# Scripting loops

## test


Script loops will run while or until a certain condition is met. This
condition can be written with the **test** command. In this screenshot
we first test whether 42 is greater than 33 and subsequently we test
whether 42 is less than 33. The second **test** fails (with error code
1).

    paul@debian10:~$ test 42 -gt 33 ; echo $?
    0
    paul@debian10:~$ test 42 -lt 33 ; echo $?
    1
    paul@debian10:~$

The **test** command can also be written using square brackets, as the
following screenshot shows. This is identical to writing **test**
followed by an expression.

    paul@debian10:~$ [ 42 -gt 33 ] && echo true || echo false
    true
    paul@debian10:~$ [ 42 -lt 33 ] && echo true || echo false
    false
    paul@debian10:~$

Both **test** and **\[** are commands in **/usr/bin/**, but both are
also builtin to the bash shell.

    paul@debian10:$ which test [
    /usr/bin/test
    /usr/bin/[
    paul@debian10:$ type test [
    test is a shell builtin
    [ is a shell builtin
    paul@debian10:~$

Below is a table with some common **test** cases. See the **man test**
for a complete list.

<table style="width:70%;">
<caption>test command</caption>
<colgroup>
<col style="width: 14%" />
<col style="width: 55%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>test</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>-d foo</p></td>
<td style="text-align: left;"><p>Does the directory <strong>foo</strong>
exist?</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>-e bar</p></td>
<td style="text-align: left;"><p>Does the file <strong>bar</strong>
exist?</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>-f foo</p></td>
<td style="text-align: left;"><p>Is <strong>foo</strong> a regular
file?</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>-r bar</p></td>
<td style="text-align: left;"><p>Is <strong>bar</strong> a readable
file?</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>'/var' == $path</p></td>
<td style="text-align: left;"><p>Is the string <strong>'/var'</strong>
equal to the value of <strong>$path</strong>?</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>42 -lt $foo</p></td>
<td style="text-align: left;"><p>Is 42 less than the value of
<strong>$foo</strong>?</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>$foo -ge 8472</p></td>
<td style="text-align: left;"><p>Is the value of <strong>$foo</strong>
greater than or equal to 8472?</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>"abc" &lt; $bar</p></td>
<td style="text-align: left;"><p>Does <strong>"abc"</strong> sort before
the value of <strong>$bar</strong>?</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>foo -nt bar</p></td>
<td style="text-align: left;"><p>Is file <strong>foo</strong> newer than
file <strong>bar</strong>?</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>-o nounset</p></td>
<td style="text-align: left;"><p>Is the shell option
<strong>nounset</strong> active?</p></td>
</tr>
</tbody>
</table>

test command

Further more it is possible to combine these expression with **-a** for
a logical AND and **-o** for a logical OR.

    paul@debian10:~$ [ 42 -gt 33 -a 8472 -gt 42 ] && echo true || echo false
    true
    paul@debian10:~$ [ 42 -gt 33 -o 8472 -gt 42 ] && echo true || echo false
    true
    paul@debian10:~$ [ 42 -gt 33 -o 8472 -lt 42 ] && echo true || echo false
    true
    paul@debian10:~$

## if

The reserved keywords **if**, **then**, **else**, **elif**, and **fi**
can be used to execute commands depending on one or more **test**
statements. Let us start with a simple example.

### if then fi

In this example we **test** whether a file named **file.txt** exists,
and only if the **test** statement evaluates to **true** the statement
after **then** will be executed.

    paul@debian10:~$ cat choice.sh
    #!/bin/bash

    if [ -f file.txt ]
    then echo the file exists
    fi
    paul@debian10:~$

In a diagram the above example looks like this.

<figure>
<img src="images/if.svg" alt="images/if.svg" />
</figure>

You can also write this as a one-liner in the bash shell.

    paul@debian10:$ if [ -f file.txt ] ; then echo the file exists ; fi
    the file exists
    paul@debian10:$

The above program can also be written with the bash logical AND.

    paul@debian10:$ [ -f file.txt ] && echo the file exists
    the file exists
    paul@debian10:$

### if then else fi

You may want to execute some commands when the **test** succeeds, and
some other commands when the **test** fails. This can be done by adding
an **else** statement to the above program.

    paul@debian10:~$ cat choice.sh
    #!/bin/bash

    if [ -f file.txt ]
    then echo the file exists
    else echo the file is gone
    fi
    paul@debian10:~$

The screenshot below shows the two possible outputs of the little
script.

    paul@debian10:~$ ./choice.sh
    the file is gone
    paul@debian10:~$ touch file.txt
    paul@debian10:~$ ./choice.sh
    the file exists
    paul@debian10:~$

In a diagram the above program looks like this.

<figure>
<img src="images/ifthen.svg" alt="images/ifthen.svg" />
</figure>

You can again also write this as a one-liner on the bash command prompt.

    paul@debian10:$ if [ -f file.txt ] ; then echo the file exists ; else echo the file is gone ; fi
    the file exists
    paul@debian10:$

The above program can also be written with the bash logical AND and the
bash logical OR.

    paul@debian10:$ [ -f file.txt ] && echo the file exists || echo the file is gone
    the file exists
    paul@debian10:$

You can execute multiple commands after the **then** keyword and after
the **else** keyword, as this example shows.

    paul@debian10:$ cat choice2.sh
    #!/bin/bash

    if [ -f file.txt ]
    then
         echo the file exists
         echo the file really exists
    else
         echo the file is gone
         echo the file is really gone
    fi
    paul@debian10:$

### if then elif then else fi

An **if** statement can be nested using the **elif** keyword. Avoid
nesting of **if** statements since this is not beneficial to the
readability of your script.

    paul@debian10:~$ cat choice.sh
    #!/bin/bash

    if [ -f file.txt ]
    then echo the file exists
    elif [ -f file2.txt ]
      then echo file2.txt is there
      else echo the files are both gone
    fi
    paul@debian10:~$

In a diagram this code snippet looks like this.

<figure>
<img src="images/ifthenelif.svg" alt="images/ifthenelif.svg" />
</figure>

This is not very readable as a bash one-liner on the command prompt.

    paul@debian10:$ if [ -f file.txt ] ; then echo the file exists ; elif [ -f file2.txt ] ; then echo file2.txt is there; else echo the files are both gone ; fi
    the files are both gone
    paul@debian10:$

Though you could write it as a multi-part one-liner, as this screenshot
shows.

    paul@debian10:$ if [ -f file.txt ]
    > then echo file exists
    > elif [ -f file2.txt ]
    > then echo file2.txt is there
    > else echo the files are both gone
    > fi
    the files are both gone
    paul@debian10:$

## case

It is often easier to read and write a **case** statement instead of
several nested **if** and **elif** statements. Below is an example of a
**case** statement with many options.

    paul@debian10:~$ cat help.sh
    #!/bin/bash
    #
    # Wild Animals Helpdesk
    #
    echo -n "What animal did you see? "
    read animal
    case $animal in
      "lion" | "tiger")
        echo "You better start running fast!"
        ;;
      "cat")
        echo "Let that mouse go."
        ;;
      "dog")
        echo "Don't worry, give it a cookie."
        ;;
      "chicken" | "goose" | "duck")
        echo "Yeah, eggs for breakfast!"
        ;;
      "liger")
        echo "Approach and say 'Ah you big fluffy kitty...'"
        ;;
      "babelfish")
        echo "Did it fall out of your ear?"
        ;;
       *)
        echo "You discovered an new animal, name it!"
        ;;
    esac
    paul@debian10:~$

A **case** statement can be represented in a diagram like this. The
diagram resembles the **if-then-elif-then-fi** diagram, but a **case**
statement in a bash script is easier to read.

<figure>
<img src="images/case.svg" alt="images/case.svg" />
</figure>

## for loop

A **for** loop will loop through a list and execute all the statements
between **do** and **done** for each item of the list.

    paul@debian10:~$ cat forloop.sh
    #!/bin/bash

    for i in 33 42 8472
    do
            echo the number is $i
    done
    paul@debian10:~$ ./forloop.sh
    the number is 33
    the number is 42
    the number is 8472
    paul@debian10:~$

A diagram of a **for** loop looks like this. The **"next item?"**
question can be read as **"Is there still an item in the list that was
not processed?"**.

<figure>
<img src="images/forloop.svg" alt="images/forloop.svg" />
</figure>

Here is an example of a **for** loop but with the list created by an
**embedded** shell. Can you figure out what the **seq** command is
doing?

    paul@debian10:~$ cat forloop2.sh
    #!/bin/bash

    for i in $(seq 1 5)
    do
            echo We are at number $i
    done
    paul@debian10:~$ ./forloop2.sh
    We are at number 1
    We are at number 2
    We are at number 3
    We are at number 4
    We are at number 5
    paul@debian10:~$

The following **for** loop has the same output. The **bash** shell is
expanding **{1..5}** to **1 2 3 4 5**.

    paul@debian10:~$ cat forloop3.sh
    #!/bin/bash

    for counter in {1..5}
    do
            echo We are at number $counter
    done
    paul@debian10:~$ ./forloop3.sh
    We are at number 1
    We are at number 2
    We are at number 3
    We are at number 4
    We are at number 5
    paul@debian10:~$

You can also use file **globbing** when writing a **for** loop. This
example walks through all the **.txt** files in the current directory.

    paul@debian10:~$ cat forloop4.sh
    #!/bin/bash

    for tfile in *.txt
    do
            echo We can see the $tfile file here.
    done
    paul@debian10:~$ ./forloop4.sh
    We can see the combi.txt file here.
    We can see the count.txt file here.
    We can see the dates.txt file here.
    We can see the error.txt file here.
    We can see the file.txt file here.
    We can see the hello.txt file here.
    We can see the music2.txt file here.
    We can see the music.txt file here.
    We can see the temp.txt file here.
    We can see the test.txt file here.
    paul@debian10:~$

A **for** loop can also be written directly on the command line. This
screenshot shows a very similar **for** loop as the one above.

    paul@debian10:~$ for tf in *.txt; do echo We see $tf; done
    We see combi.txt
    We see count.txt
    We see dates.txt
    We see error.txt
    We see file.txt
    We see hello.txt
    We see music2.txt
    We see music.txt
    We see temp.txt
    We see test.txt
    paul@debian10:~$

And of course you can substitute the **echo** command in the examples
with something more useful like **cp** to copy all **.txt** files to the
backup directory.

    paul@debian10:~$ for tf in *.txt; do cp $tf backup/ ; done
    paul@debian10:~$

## while loop

A **while** loop will verify a condition and will then execute all
commands between **do** and **done** and will then go back to checking
the condition, lather, rinse, repeat. Here is an example.

    paul@debian10:~$ cat while1.sh
    #!/bin/bash

    i=5
    while [ $i -ge 0 ] ;
    do
            echo Counting down, from 5 to 0, now at $i
            let i--
    done
    paul@debian10:~$ ./while1.sh
    Counting down, from 5 to 0, now at 5
    Counting down, from 5 to 0, now at 4
    Counting down, from 5 to 0, now at 3
    Counting down, from 5 to 0, now at 2
    Counting down, from 5 to 0, now at 1
    Counting down, from 5 to 0, now at 0
    paul@debian10:~$

Note that the above **while** loop is executed **six** times.

The diagram of a **while** loop in bash looks like this (Hey this
diagram is identical to the diagram for a **for** loop!). Notice how the
**test** statement is evaluated before any command is executed, so it is
possible that the command(s) between **do** and **done** are never
executed.

<figure>
<img src="images/whileloop.svg" alt="images/whileloop.svg" />
</figure>

Note that you can write a **while** loop as a one-liner on the command
line, as this example shows.

    paul@debian10:$ i=5; while [ $i -ge 0 ] ; do echo $i ; let i-- ; done
    5
    4
    3
    2
    1
    0
    paul@debian10:$

A **while** loop can be endless so be careful when writing the **test**
condition. In the screenshot below you can see an endless **while**
loop. The script is interrupted by typing **Ctrl-c** (which sends a
keyboard interrupt to the script).

    paul@debian10:~$ cat while2.sh
    #!/bin/bash

    while :
    do
            echo hello
            sleep 3
    done
    paul@debian10:~$ ./while2.sh
    hello
    hello
    hello
    ^C
    paul@debian10:~$

An endless **while** loop can easily be achieved writing **while :** or
**while true**. The **:** basically means **no operation** and evaluates
to **true**.

## until loop

For completeness, here is an example of an **until** loop. The loop will
check the **test** statement and run everything between **do** and
**done** . Note that the loop below runs only **five** times.

    paul@debian10:~$ cat until1.sh
    #!/bin/bash

    i=5
    until [ $i -le 0 ]
    do
            echo Counting down now at $i
            let i--
    done
    paul@debian10:~$ ./until1.sh
    Counting down now at 5
    Counting down now at 4
    Counting down now at 3
    Counting down now at 2
    Counting down now at 1
    paul@debian10:~$

In a diagram the **until** loop looks similar to a while loop, except
that the **true** and **false** checks have switched places.

<figure>
<img src="images/untilloop.svg" alt="images/untilloop.svg" />
</figure>

As a one-liner this statement becomes this.

    paul@debian10:$ i=5; until [ $i -le 0 ] ; do echo $i ; let i-- ; done
    5
    4
    3
    2
    1
    paul@debian10:$

## Cheat sheet

<table>
<caption>Scripting loops</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>test $foo -gt $bar</p></td>
<td style="text-align: left;"><p>Compare two variables with "greater
than".</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>test $foo -lt $bar</p></td>
<td style="text-align: left;"><p>Compare two variables with "less
than".</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>[ $foo -gt $bar ]</p></td>
<td style="text-align: left;"><p>Compare two variables with "greater
than".</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>[ $foo -lt $bar ]</p></td>
<td style="text-align: left;"><p>Compare two variables with "less
than".</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>-a</p></td>
<td style="text-align: left;"><p>A logical AND to combine two test
expressions.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>-o</p></td>
<td style="text-align: left;"><p>A logical OR to combine two test
expressions.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>if foo ; then bar; fi</p></td>
<td style="text-align: left;"><p>Execute <strong>bar</strong> if
<strong>foo</strong> is true.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>if foo ; then bar1; else bar2;
fi</p></td>
<td style="text-align: left;"><p>Execute <strong>bar2</strong> if
<strong>foo</strong> is false.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>case $foo in … esac</p></td>
<td style="text-align: left;"><p>Keywords for a <strong>case</strong>
statement.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>for var in foo; do bar; done</p></td>
<td style="text-align: left;"><p>Execute <strong>bar</strong> for each
item in the list <strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>while foo; do bar; done</p></td>
<td style="text-align: left;"><p>Execute <strong>bar</strong> as long as
<strong>foo</strong> is true.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>until foo; do bar; done</p></td>
<td style="text-align: left;"><p>Execute <strong>bar</strong> until
<strong>foo</strong> is true.</p></td>
</tr>
</tbody>
</table>

Scripting loops

## Practice

1.  Write a script that uses a **for** loop to count from 3 to 7.

2.  Write a script that uses a **for** loop to count from 42 to 8472.

3.  Write a script that uses a **while** loop to count from 3 to 7.

4.  Write a script that uses an **until** loop to count from 8 to 4.

5.  Write a script that counts the number of **.txt** files in the
    current directory.

6.  Write an **if** statement around the script so it is also correct
    when there are zero files ending in **.txt** .

## Solution

1.  Write a script that uses a **for** loop to count from 3 to 7.

        #!/bin/bash

        for i in 3 4 5 6 7
        do
          echo Counting from 3 to 7, now at $i
        done

    or as a one liner

        for i in 3 4 5 6 7; do echo "Counting from 3 to 7, now at $i" ; done

2.  Write a script that uses a **for** loop to count from 42 to 8472.

        #!/bin/bash

        for i in $(seq 42 8472)
        do
          echo Counting from 42 to 8472, now at $i
        done

3.  Write a script that uses a **while** loop to count from 3 to 7.

        #!/bin/bash

        i=3
        while [ $i -le 7 ]
        do
         echo Counting from 3 to 7, now at $i
         let i=i+1
        done

4.  Write a script that uses an **until** loop to count from 8 to 4.

        #!/bin/bash

        i=8
        until [ $i -lt 4 ]
        do
          echo Counting from 8 to 4, now at $i
          let i=i-1
        done

5.  Write a script that counts the number of **.txt** files in the
    current directory.

        #!/bin/bash

        let i=0
        for file in *.txt
        do
          let i++
        done
        echo "There are $i files ending in .txt"

6.  Write an **if** statement around the script so it is also correct
    when there are zero files ending in **.txt** .

        #!/bin/bash

        ls *.txt > /dev/null 2>&1
        if [ $? -ne 0 ]
        then echo "There are 0 files ending in .txt"
        else
                let i=0
                for file in *.txt
                do
                          let i++
                done
                echo "There are $i files ending in .txt"
        fi
