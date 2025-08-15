## solution: vi(m)

1. Start the vimtutor and do some or all of the exercises. You might need to run `aptitude install vim` on xubuntu.

    ```
    vimtutor
    ```

2. What 3 key sequence in command mode will duplicate the current line.

    ```
    yyp
    ```

3. What 3 key sequence in command mode will switch two lines' place (line five becomes line six and line six becomes line five).

    ```
    ddp
    ```

4. What 2 key sequence in command mode will switch a character's place with the next one.

    ```
    xp
    ```

5. vi can understand macro's. A macro can be recorded with q followed by the name of the macro. So qa will record the macro named a. Pressing q again will end the recording. You can recall the macro with @ followed by the name of the macro. Try this example: i 1 'Escape Key' qa yyp 'Ctrl a' q 5@a (Ctrl a will increase the number with one).

6. Copy /etc/passwd to your ~/passwd. Open the last one in vi and press Ctrl v. Use the arrow keys to select a Visual Block, you can copy this with y or delete it with d. Try pasting it.

    ```
    cp /etc/passwd ~
    vi passwd
    (press Ctrl-V)
    ```

7. What does `dwwP` do when you are at the beginning of a word in a sentence ?

    `dwwP` can switch the current word with the next word.

