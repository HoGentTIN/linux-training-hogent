# More vi

## About this chapter

Congratulations on starting this chapter which goes deeper into **vi**
and assumes you have read and understood the previous chapter (including
the **vimtutor** practice).

We start the chapter with a couple of tables explaining **vi** commands,
some of which are already familiar to you. Don’t learn these commands by
heart, learn by using them in **vi**. It is okay as a junior Linux
administrator to use only some of the commands discussed in these
tables.

## a A i I o O

These six commands **a A i I o** and **O** put **vi** in insert mode.
Each differ on the position where you can start typing.

<table style="width:80%;">
<caption>a A i I o O</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>a</p></td>
<td style="text-align: left;"><p>append</p></td>
<td style="text-align: left;"><p>Start writing after the current
character.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>A</p></td>
<td style="text-align: left;"><p>Append</p></td>
<td style="text-align: left;"><p>Start writing at the end of the current
line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>i</p></td>
<td style="text-align: left;"><p>insert</p></td>
<td style="text-align: left;"><p>Start writing before the current
character.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>I</p></td>
<td style="text-align: left;"><p>Insert</p></td>
<td style="text-align: left;"><p>Start writing at the start of the
current line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>o</p></td>
<td style="text-align: left;"><p>open</p></td>
<td style="text-align: left;"><p>Start writing on a new line after the
current line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>O</p></td>
<td style="text-align: left;"><p>Open</p></td>
<td style="text-align: left;"><p>Start writing on a new line above the
current line.</p></td>
</tr>
</tbody>
</table>

a A i I o O

## r R x X

The **x** key can be used to delete the character underneath the cursor,
while the uppercase **X** key deletes the character just before the
cursor. The **r** key will replace one character underneath the cursor,
while the uppercase **R** key will allow you to keep replacing
characters on the current line until you hit **Esc**.

<table style="width:80%;">
<caption>x X r R</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>x</p></td>
<td style="text-align: left;"><p>delete</p></td>
<td style="text-align: left;"><p>Delete the current character.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>X</p></td>
<td style="text-align: left;"><p>delete</p></td>
<td style="text-align: left;"><p>Delete the character before the current
character.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>paste</p></td>
<td style="text-align: left;"><p>Paste the last deleted
character.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>xp</p></td>
<td style="text-align: left;"><p>switch</p></td>
<td style="text-align: left;"><p>switch the current and the next
character.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>r</p></td>
<td style="text-align: left;"><p>replace</p></td>
<td style="text-align: left;"><p>Replace the current character.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>R</p></td>
<td style="text-align: left;"><p>Replace</p></td>
<td style="text-align: left;"><p>Replace characters on this line until
<strong>Esc</strong>.</p></td>
</tr>
</tbody>
</table>

x X r R

## u . Ctrl-r

The **u** command will undo you last command in **vi**, if you keep
using **u** then you end up with the original document. With **Ctrl-r**
you can undo the undo commands until the most recent change. And the
**.** command will redo your last command.

<table style="width:80%;">
<caption>u . Ctrl-r</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>u</p></td>
<td style="text-align: left;"><p>undo</p></td>
<td style="text-align: left;"><p>Undo the last command.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>uu</p></td>
<td style="text-align: left;"><p>undo</p></td>
<td style="text-align: left;"><p>Undo the last two commands.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-r</p></td>
<td style="text-align: left;"><p>undo the undo</p></td>
<td style="text-align: left;"><p>Undo the last <strong>u</strong>
command.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>.</p></td>
<td style="text-align: left;"><p>redo</p></td>
<td style="text-align: left;"><p>Redo the last command.</p></td>
</tr>
</tbody>
</table>

u . Ctrl-r

## dd yy p P

The **dd** command deletes a line, and **yy** will copy a line. Both
commands can be preceded by a number to repeat the command.

<table style="width:80%;">
<caption>dd yy p P</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>dd</p></td>
<td style="text-align: left;"><p>delete</p></td>
<td style="text-align: left;"><p>Delete the current line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>yy</p></td>
<td style="text-align: left;"><p>yank</p></td>
<td style="text-align: left;"><p>Yank (copy) the current line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>300dd</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Delete the next 300 lines.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>5yy</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Copy the next five lines.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>paste</p></td>
<td style="text-align: left;"><p>Paste (after dd or yy) as the next
line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>P</p></td>
<td style="text-align: left;"><p>Paste</p></td>
<td style="text-align: left;"><p>Paste (after dd or yy) as the previous
line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>yyp</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Duplicate the current line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ddp</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Switch two lines.</p></td>
</tr>
</tbody>
</table>

dd yy p P

## w b dw db p P

With **w** and **b** you can jump forward and back in the text by word.
In combination with **d** this allows for deletion of words.

<table style="width:80%;">
<caption>w b dw dp p P</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>w</p></td>
<td style="text-align: left;"><p>word</p></td>
<td style="text-align: left;"><p>Move forward one word.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>b</p></td>
<td style="text-align: left;"><p>back</p></td>
<td style="text-align: left;"><p>Move back one word.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>3w</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Move forward three words.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>dw</p></td>
<td style="text-align: left;"><p>delete word</p></td>
<td style="text-align: left;"><p>Delete the current word (at the start
of the word!).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>d5w or 5dw</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Delete five words.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>4db</p></td>
<td style="text-align: left;"><p>delete back</p></td>
<td style="text-align: left;"><p>Delete four words back.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>paste</p></td>
<td style="text-align: left;"><p>Paste (after dw or db) after the
current character.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>P</p></td>
<td style="text-align: left;"><p>Paste</p></td>
<td style="text-align: left;"><p>Paster (after dw or db) before the
current character.</p></td>
</tr>
</tbody>
</table>

w b dw dp p P

## 0 $ d0 d$

With **0** you can jump to the start of the current line and with **$**
you jump to the end of the current line. Both can be combined with
**y**ank and **d**elete.

<table style="width:80%;">
<caption>0 $ d0 d$ y0 y$</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>start</p></td>
<td style="text-align: left;"><p>Jump to start if the current
line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$</p></td>
<td style="text-align: left;"><p>end</p></td>
<td style="text-align: left;"><p>Jump to end if the current
line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>d0</p></td>
<td style="text-align: left;"><p>delete</p></td>
<td style="text-align: left;"><p>Delete from before the cursor to the
start of the line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>d$</p></td>
<td style="text-align: left;"><p>delete</p></td>
<td style="text-align: left;"><p>Delete from the cursor to the end of
the line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>y0</p></td>
<td style="text-align: left;"><p>yank</p></td>
<td style="text-align: left;"><p>Copy from before the cursor to the
start of the line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>y$</p></td>
<td style="text-align: left;"><p>yank</p></td>
<td style="text-align: left;"><p>Copy from the cursor to the end of the
line.</p></td>
</tr>
</tbody>
</table>

0 $ d0 d$ y0 y$

## J G H

The **J** command allows you to **join** the current line with the next
line. While **42J** will join the next 42 lines on the current line.

With **G** you jump to last line of the file. Putting a number before
**G** will jump to that line number. So **5G** jumps to the fifth line
of the document and **8472G** will jump to the 8472nd line in the
current file.

The **H** command will jump to the top of the current screen, while
**4H** will jump to the fourth line of the current screen.

<table style="width:80%;">
<caption>J G H</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>J</p></td>
<td style="text-align: left;"><p>Join</p></td>
<td style="text-align: left;"><p>Join the next line with the
current.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>5J</p></td>
<td style="text-align: left;"><p>Join</p></td>
<td style="text-align: left;"><p>Join the next five lines with the
current line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>G</p></td>
<td style="text-align: left;"><p>Go</p></td>
<td style="text-align: left;"><p>Go to the last line of the current
file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>gg</p></td>
<td style="text-align: left;"><p>Go</p></td>
<td style="text-align: left;"><p>Go to the first line of the current
file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>1G</p></td>
<td style="text-align: left;"><p>Go</p></td>
<td style="text-align: left;"><p>Go to the first line of the current
file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>33G</p></td>
<td style="text-align: left;"><p>Go</p></td>
<td style="text-align: left;"><p>Go to line 33 of the current
file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>dG</p></td>
<td style="text-align: left;"><p>delete</p></td>
<td style="text-align: left;"><p>Delete up to the end of the
file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>H</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Go to the top of the current
screen.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>5H</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Go to the fifth line of the current
screen.</p></td>
</tr>
</tbody>
</table>

J G H

## v V Ctrl-v

Using the **v** or **V** or **Ctrl-v** commands you can highlight a
portion of the text for **yanking** or **deleting**.

<table style="width:80%;">
<caption>v V Ctrl-v</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 66%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>v</p></td>
<td style="text-align: left;"><p>highlight by character</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>Paste after the current character
(after v)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>V</p></td>
<td style="text-align: left;"><p>highlight by line</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>p</p></td>
<td style="text-align: left;"><p>Paste after the current line (after
V)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-v</p></td>
<td style="text-align: left;"><p>highlight by column</p></td>
</tr>
</tbody>
</table>

v V Ctrl-v

## Writing and quitting

Whenever you are in command mode (after pressing **Esc**), you can press
the colon **:** which will appear at the bottom of the screen. After
this colon you can type **w** for writing to a file and/or **q** to quit
**vi**.

By default **vi** will not allow you to quit without saving the file,
this can be overruled by typing **:q!** .

This table gives an overview of **colon** commands.

<table style="width:80%;">
<caption>Writing and quitting</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:w</p></td>
<td style="text-align: left;"><p>write</p></td>
<td style="text-align: left;"><p>Write to current file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>:w fname</p></td>
<td style="text-align: left;"><p>write</p></td>
<td style="text-align: left;"><p>Write to the file named fname.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:wq</p></td>
<td style="text-align: left;"><p>write and quit</p></td>
<td style="text-align: left;"><p>Write to the current file and quit
<strong>vi</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>:q</p></td>
<td style="text-align: left;"><p>quit</p></td>
<td style="text-align: left;"><p>Quit <strong>vi</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:q!</p></td>
<td style="text-align: left;"><p>quit</p></td>
<td style="text-align: left;"><p>Quit <strong>vi</strong> without saving
changes to the file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ZZ</p></td>
<td style="text-align: left;"><p>write and quit</p></td>
<td style="text-align: left;"><p>Same as <strong>:wq</strong> .</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:w!</p></td>
<td style="text-align: left;"><p>write</p></td>
<td style="text-align: left;"><p>Try to write to a non-writable file
(see permissions chapter).</p></td>
</tr>
</tbody>
</table>

Writing and quitting

## Searching

When you are in command, then you can type a **forward slash /** to
start searching the current file. The **/** will appear at the bottom of
the screen, and you can search using strings or even using regular
expressions. Using the question mark **?** you can search backwards in
the current file.

<table style="width:80%;">
<caption>Searching</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/string</p></td>
<td style="text-align: left;"><p>search</p></td>
<td style="text-align: left;"><p>Case insensitive forward search for
<strong>string</strong> in the file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>?string</p></td>
<td style="text-align: left;"><p>search</p></td>
<td style="text-align: left;"><p>Case insensitive back search for
<strong>string</strong> .</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>n</p></td>
<td style="text-align: left;"><p>next</p></td>
<td style="text-align: left;"><p>Jump to next occurrence of
<strong>string</strong> .</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/^string</p></td>
<td style="text-align: left;"><p>search</p></td>
<td style="text-align: left;"><p>Search for lines starting with
<strong>string</strong> .</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/string$</p></td>
<td style="text-align: left;"><p>search</p></td>
<td style="text-align: left;"><p>Search for lines ending with
<strong>string</strong> .</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/br[aeio]l</p></td>
<td style="text-align: left;"><p>search</p></td>
<td style="text-align: left;"><p>Search for <strong>bral</strong>,
<strong>brel</strong>, <strong>bril</strong>, and
<strong>brol</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/\&lt;he\&gt;</p></td>
<td style="text-align: left;"><p>search</p></td>
<td style="text-align: left;"><p>Search for the word <strong>he</strong>
and not <strong>here</strong> or <strong>the</strong>.</p></td>
</tr>
</tbody>
</table>

Searching

## Search and replace

You may want to replace (all) occurrences of a string with another
string. You could do this with **sed -i** as we have seen before, or you
can do it from within **vi**. In **vi** you can type the **colon**
followed by the **s/foo/bar/** notation.

<table style="width:80%;">
<caption>Search and replace</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 12%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:s/foo/bar/</p></td>
<td style="text-align: left;"><p>replace</p></td>
<td style="text-align: left;"><p>Replace <strong>foo</strong> with
<strong>bar</strong> once, in the current line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>:s/foo/bar/g</p></td>
<td style="text-align: left;"><p>replace</p></td>
<td style="text-align: left;"><p>Replace all occurrences of
<strong>foo</strong> with <strong>bar</strong> in the current
line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:s/foo/bar/gi</p></td>
<td style="text-align: left;"><p>replace</p></td>
<td style="text-align: left;"><p>Do a case insensitive replace of all
<strong>foo</strong> with <strong>bar</strong> .</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>:4,8 s/foo/bar/g</p></td>
<td style="text-align: left;"><p>replace</p></td>
<td style="text-align: left;"><p>Replace all <strong>foo</strong> with
<strong>bar</strong> on lines 4 through 8.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:1,$ s/foo/bar/g</p></td>
<td style="text-align: left;"><p>replace</p></td>
<td style="text-align: left;"><p>Replace all <strong>foo</strong> with
<strong>bar</strong> in the whole file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>:%s/foo/bar/g</p></td>
<td style="text-align: left;"><p>replace</p></td>
<td style="text-align: left;"><p>Replace all <strong>foo</strong> with
<strong>bar</strong> in the whole file.</p></td>
</tr>
</tbody>
</table>

Search and replace

## Reading input

You can type text in **vi**, but you can also **read** input from other
files or read output from commands that you execute.

The first action is performed by typing **:r** followed by a space and a
filename. The content of that file will then be pasted, starting from
the next line. Make sure you import a text file!

The second action is to type **:r !** followed by a command. This
command will be executed in **bash** and the output (stdout and stderr)
will be transferred to the file you are editing, again starting from the
next line.

<table style="width:80%;">
<caption>Read</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:r fname</p></td>
<td style="text-align: left;"><p>read</p></td>
<td style="text-align: left;"><p>Read the file named
<strong>fname</strong> and insert its content after the current
line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>:r !ls</p></td>
<td style="text-align: left;"><p>read</p></td>
<td style="text-align: left;"><p>Put the output of <strong>ls</strong>
after the current line.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:r</p></td>
<td style="text-align: left;"><p>read</p></td>
<td style="text-align: left;"><p>Read the current file again, inserting
it after the current line.</p></td>
</tr>
</tbody>
</table>

Read

## Multiple files

You can edit multiple files in **vi**, just open them by typing **vi
textfile1 textfile2** at the command line. Here are some hints on
working with multiple files.

<table style="width:80%;">
<caption>Open multiple files</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:n</p></td>
<td style="text-align: left;"><p>next</p></td>
<td style="text-align: left;"><p>Go to the next file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>:rew</p></td>
<td style="text-align: left;"><p>rewind</p></td>
<td style="text-align: left;"><p>Go to the first file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>:args</p></td>
<td style="text-align: left;"><p>arguments</p></td>
<td style="text-align: left;"><p>List the open files, marking the active
one.</p></td>
</tr>
</tbody>
</table>

Open multiple files

## Digraphs

**Digraphs** are characters that are not present on your keyboard like
**omega** or **epsilon** . These characters can be formed in **vi** by
type **Ctrl-k** followed by a combination of two characters.

<table style="width:80%;">
<caption>Some digraphs</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>short</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-k-a-*</p></td>
<td style="text-align: left;"><p>alfa</p></td>
<td style="text-align: left;"><p>Writes α.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Ctrl-k-b-*</p></td>
<td style="text-align: left;"><p>beta</p></td>
<td style="text-align: left;"><p>Writes β.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-k-p-*</p></td>
<td style="text-align: left;"><p>pi</p></td>
<td style="text-align: left;"><p>Writes π.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Ctrl-k-m-*</p></td>
<td style="text-align: left;"><p>mu</p></td>
<td style="text-align: left;"><p>Writes μ.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-k-w-*</p></td>
<td style="text-align: left;"><p>omega</p></td>
<td style="text-align: left;"><p>Writes ω.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>Ctrl-k-W-*</p></td>
<td style="text-align: left;"><p>Omega</p></td>
<td style="text-align: left;"><p>Writes Ω.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-k-*-e</p></td>
<td style="text-align: left;"><p>epsilon</p></td>
<td style="text-align: left;"><p>Writes ε.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>:digraph</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Displays all digraphs and their
shortcut.</p></td>
</tr>
</tbody>
</table>

Some digraphs

## Macro’s

You can record several macro’s in **vi** by typing **q** followed by a
letter to name the macro. Anything you type will then be recorded until
you hit **q** again to end the macro. You can call on this macro by
typing **@** followed by the name of the macro. This **@** sign can be
preceded by a number for multiple executions of this macro.

For example **q a $ a e n d Esc j q** will record a macro named **a**
that adds **end** at the end of the line and then goes to the next line.

The **q b A e n d Esc j q** will create a macro named **b** that does
the same thing. Typing **400@b** afterwards will execute this macro 400
times (adding **end** at the end of 400 lines).

## Setting options

There are many options that you can set in **vi**. For example the **set
number** option will display line numbers and **syntax on** will
recognise syntax for most programming languages. Options can be set on
the fly by typing **:** followed by the option.

Most options, when setting them on the fly, can be abbreviated. For
example **se nu** is sufficient for **set number**. So is **sy on** for
**syntax on**.

<table style="width:60%;">
<caption>Some vim options</caption>
<colgroup>
<col style="width: 24%" />
<col style="width: 36%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>action</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>set number</p></td>
<td style="text-align: left;"><p>Display line numbers.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>set nonumber</p></td>
<td style="text-align: left;"><p>Remove line numbers.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>set relativenumber</p></td>
<td style="text-align: left;"><p>Display relative line numbers.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>syntax on</p></td>
<td style="text-align: left;"><p>Enable syntax highlighting.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>syntax off</p></td>
<td style="text-align: left;"><p>Disable syntax highlighting.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>set tabstop=4</p></td>
<td style="text-align: left;"><p>Tabs are four spaces wide.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>set nobackup</p></td>
<td style="text-align: left;"><p>Disable creating a backup
file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>set noswapfile</p></td>
<td style="text-align: left;"><p>Disable creating a swap file.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>set spell</p></td>
<td style="text-align: left;"><p>Enable spell checker.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>set nospell</p></td>
<td style="text-align: left;"><p>Disable spell checker.</p></td>
</tr>
</tbody>
</table>

Some vim options

## .vimrc

These options can be automatically set by typing them in the **.vimrc**
file. For example here is a simple **.vimrc** setting some options.

    paul@debian10~$ cat .vimrc
    set number
    syntax on

    set background=dark

    set nobackup
    set nowb
    set noswapfile

    paul@debian10~$

## Practice

1.  Read through this chapter and try most of the commands. Use the
    **tennis** and the **cities** file for practice. They can be
    downloaded again if required using **wget
    <http://linux-training.be/tennis>** and **wget
    <http://linux-training.be/cities>** .
