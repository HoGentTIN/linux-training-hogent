# Shell history

## history


The **history** command shows you a list of all the commands that you
typed. By default the last one thousand commands are kept in this list.

    paul@debian10:~$ history | grep export
      825  export varans
      830  export
      834  which export
      841  export | tail -3
      849  export varans=42
      852  export varans=42
      857  export varans=42
      861  history | grep export
    paul@debian10:~$

You can add a number to see only the last number of commands. In the
screenshot below we show the last five commands.

    paul@debian10:~$ history 5
      858  varmin=33
      859  env -i varspe=8472  bash
      860  history | grep varans
      861  history | grep export
      862  history 5
    paul@debian10:~$

## !n


You can execute any command from the history list by typing an
exclamation mark followed by the line number.

    paul@debian10:~$ !858
    varmin=33
    paul@debian10:~$

You can also execute a command from history by typing the exclamation
mark followed by the first letter(s) of the command you want to repeat.

    paul@debian10:~$ !ex
    export varans=42
    paul@debian10:~$

Make sure you know exactly which command you are repeating with this
last option.

To execute the last command again simply type **!!** (often called bang
bang), as seen in the screenshot below. <span class="indexterm"></span>

    paul@debian10:~$ !!
    export varans=42
    paul@debian10:~$

## Ctrl-r


You can also search backwards in your history by typing **Ctrl-r**
followed by the string you are looking for. In the screenshot below we
type **Ctrl-r** followed by **de**.

    paul@debian10:~$ !858
    varmin=33
    (reverse-i-search)‘de’: declare -x varmin=33

You can search further down the history by typing **Ctrl-r** several
times.

## ~/.bash\_history


The list of commands that forms your **history** is stored in a hidden
file in your home directory named **.bash\_history** .

    paul@debian10:~$ file .bash_history
    .bash_history: ASCII text
    paul@debian10:~$ tail -4 .bash_history
    echo $varans $varmin
    exit
    echo $varspe $varans $varmin
    exit
    paul@debian10:~$


The **.bash\_history** file is updated with your current history every
time you **properly** exit the bash shell (by typing **exit** or
**Ctrl-d**)!

## $HISTSIZE


By default the **$HISTSIZE** variable is set to a value of **1000** in
Debian. You can change this to have the **active shell** retain more (or
less) commands. We will see later in this book how to make this change
permanent.

    paul@debian10:~$ echo $HISTSIZE
    1000
    paul@debian10:~$ HISTSIZE=4000
    paul@debian10:~$ echo $HISTSIZE
    4000
    paul@debian10:~$

## $HISTFILESIZE


The number of commands stored in the **.bash\_history** file is by
default set to **2000**. In the screenshot below we set this to
**9000**. (Again we will see later in this book how to make this change
permanent for a user.)

    paul@debian10:~$ echo $HISTFILESIZE
    2000
    paul@debian10:~$ HISTFILESIZE=9000
    paul@debian10:~$ echo $HISTFILESIZE
    9000
    paul@debian10:~$

## $HISTCONTROL


By default the $HISTCONTROL variable is set to **ignoreboth** which
means that command lines that start with a space character are not
stored in the shell history, and identical repeating commands are only
stored once in the history.

    paul@debian10:$ echo $HISTCONTROL
    ignoreboth
    paul@debian10:$

## Ctrl-a Ctrl-e


Whenever you have text on the command line, you can use **Ctrl-a** to
get to the start of your command line, and **Ctrl-e** to get to the end
of your command line.

## Cheat sheet

<table>
<caption>Shell history</caption>
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
<td style="text-align: left;"><p>history</p></td>
<td style="text-align: left;"><p>Display all the commands you
entered.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>history 5</p></td>
<td style="text-align: left;"><p>Display the last 5 commands you
entered.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!42</p></td>
<td style="text-align: left;"><p>Execute the 42nd command
again.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>!ex</p></td>
<td style="text-align: left;"><p>Execute the last command that started
with <strong>ex</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!!</p></td>
<td style="text-align: left;"><p>Execute the last command
again.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Ctrl-r</p></td>
<td style="text-align: left;"><p>Search back in your command
history.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>~/.bash_history</p></td>
<td style="text-align: left;"><p>The file that contains your history of
entered commands.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$HISTSIZE</p></td>
<td style="text-align: left;"><p>This variable contains the maximum
number of commands in your history.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>SHISTFILESIZE</p></td>
<td style="text-align: left;"><p>The maximum number of commands in the
$HISTFILE.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$HISTFILE</p></td>
<td style="text-align: left;"><p>Contains the name of the history
file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-a</p></td>
<td style="text-align: left;"><p>Jump to the start of the current
command line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Ctrl-e</p></td>
<td style="text-align: left;"><p>Jump to the end of the current command
line.</p></td>
</tr>
</tbody>
</table>

Shell history

## Practice

1.  Display all the previous commands you entered.

2.  Display the last 10 commands you entered.

3.  Find your last **echo** commands.

4.  Use the number in front of the last **echo** command to re-execute
    it.

5.  Repeat the last echo command using only two characters.

6.  Search your history for the last **export** command.

7.  Display the first five lines of your all-time history on this
    computer.

8.  Set the number of commands remembered to 5000.

9.  Set the number of commands in the history file to 8000.

10. Repeat the last command.

## Solution

1.  Display all the previous commands you entered.

        history

2.  Display the last 10 commands you entered.

        history 10

3.  Find your last **echo** commands.

        history | grep echo

4.  Use the number in front of the last **echo** command to re-execute
    it.

        !874 (or something)

5.  Repeat the last echo command using only two characters.

        !ec

6.  Search your history for the last **export** command.

        Ctrl-r ex

7.  Display the first five lines of your all-time history on this
    computer.

        head -5 .bash_history

8.  Set the number of commands remembered to 5000.

        HISTSIZE=5000

9.  Set the number of commands in the history file to 8000.

        HISTFILESIZE=8000

10. Repeat the last command.

        !!
