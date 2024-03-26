# Introduction to vi

## vim

Most Linux administrators use **vim** (**v**i **im**proved) rather than
the old **vi** itself. An administrator can install **vim** by typing
**apt-get install vim**. The **vi** command will then start **vim**
instead. Whenever we say **vi** we actually mean **vim** (vi saves a
letter).

People often say that **vi** is hard to use. It is not! It is however
true that **vi** requires an effort to learn, but once you know it, it
is easy to use. (This book and all its predecessors are written in
**vi**.)

This introduction to **vi** chapter teaches you the minimal knowledge
you need to do simple edits in **vi**. The next chapter, if you
persevere, teaches you all the basics of the **vi** editor.

## :q! exiting vi

It can happen, as a junior, that you open a file in **vi** for editing…
and that you completely mess up the file. No worries, just hit the
**Esc** key followed by **:q!** and enter and you will quit **vi**
without saving changes to the opened file.

Do it now, open the tennis file with **vi** and quit it immediately.

    vim tennis
    :q!

Practice this on some of the other text files in your home directory.

## a for insert mode

We are now ready to edit a file for real. Open the tennis file in **vi**
and walk around with the arrow keys. Don’t type anything yet, you are
still in **command mode** which means anything you type will be
interpreted as a command.

Type **a** to go from **command mode** to **insert mode**. The **a**
will not appear on the screen (because it was a command), but now you
can type anything. Try to add another tennis (or football) player to the
list. When you are finished typing hit **Esc** to get back to **command
mode**.

Remember to hit **a** if you want to type some more.

## :w write to file

When you are happy with your changes to the **tennis** file, hit **Esc**
followed by **:w**. You have now saved the file. You can verify with
**head** or **cat** that the changes are written to the file.

## 0 and $ start and end of line

Open a file in **vi** again and while you are in the middle of a line,
press the **0** key. You jump to the start of the line. Press the **$**
key and you jump to the end of the line.

## w and b word and back

While a file is open in **vi** use the **w** key to jump one word ahead
and the **b** key to jump one word back.

## d for delete

The **d** key can be combined with the previous commands to delete text
in **vi**. For example, when in the middle of a line of text, press
**d$** to delete all characters until the end of the line. Similarly
press **d0** to delete all until the start of the line.

Pressing **w** jumps one word ahead, and pressing **dw** will delete a
word. Pressing **db** will delete a word back.

## dd delete line and p P paste

Pressing **dd** will delete a line of text. Pressing **p** will paste
that line after the current line. Pressing uppercase **P** will paste
that line before the current line.

The pasting with **p** and **P** also works after **dw**, **db**,
**d0**, and **d$**.

## y for yank

The **yanking** or copying of text can be done with **y**. Press **yy**
to yank a line and then use **p** or **P** to paste it. Similarly you
can **y0**, **y$**, **yw**, and **yb**.

## repeat command

When in command mode, before giving any of the previous commands, you
can type a number to repeat the command. For example **5dw** will delete
the next five words and **3yy** will yank three lines. **5p** will paste
five times.

## choice

This is it for this humble introduction to **vi**. You now face a
choice, either you make the effort to learn **vi** or you go back to
**nano** or something to edit text files on Linux. The next chapter digs
further into **vi** and can be considered optional.

## Practice

Execute the **vimtutor** command. This is a 30 minute introduction to
**vi**.
