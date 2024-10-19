## solution: filters

1. Put a sorted list of all bash users in bashusers.txt.

    ```bash
    grep bash /etc/passwd | cut -d: -f1 | sort > bashusers.txt
    ```

2. Put a sorted list of all logged on users in onlineusers.txt.

    ```bash
    who | cut -d' ' -f1 | sort > onlineusers.txt
    ```

3. Make a list of all filenames in `/etc` that contain the string `conf` in their filename.

    ```bash
    ls /etc | grep conf
    ```

4. Make a sorted list of all files in `/etc` that contain the case insensitive string `conf` in their filename.

    ```bash
    ls /etc | grep -i conf | sort
    ```

5. Look at the output of `ip neigh` (ARP cache, listing other hosts on the same local network) and filter out the MAC addresses.

    ```bash
    ip n | cut -d' ' -f5
    ```

6. Write a line that removes all non-letters from a stream.

    ```console
    student@linux:~$ cat text
    This is, yes really! , a text with ?&* too many str$ange# characters ;-)
    student@linux:~$ tr -d ',!$?.*&^%#@;()-' < text
    This is yes really  a text with  too many strange characters
    ```

7. Write a line that receives a text file, and outputs all words on a separate line.

    ```console
    student@linux:~$ cat text2 
    it is very cold today without the sun

    student@linux:~$ tr ' ' '\n' < text2
    it
    is
    very
    cold
    today
    without
    the
    sun
    ```

8. Write a spell checker on the command line, i.e. list all words in a file that do not occur in a dictionary. There will probably be a dictionary in `/usr/share/dict/`.

    > We will use the Python 3 copyright notice as example input. The dictionary is `/usr/share/dict/words`. We will use `comm` to compare the two lists. To make the search case insensitive, we will convert both lists to lowercase.

    ```console
    student@linux:~/pipes$ tr 'A-Z' 'a-z' < /usr/share/dict/words | sort | uniq > lcase-words.txt
    ```

    > Next, we make a list of all words in the input file, removing all punctuation and digits.

    ```console
    student@linux:~/pipes$ tr -d '[:punct:][:digit:]' < /usr/share/doc/python3/copyright | tr '[A-Z] ' '[a-z]\n' | sort | uniq > words.txt
    ```

    > Finally, we compare the two lists.

    ```console
    student@debian:~/pipes$ comm -23 words.txt /usr/share/dict/words
    andor
    beopen
    beopencom
    bernd
    brentrup
    bsbunimuensterde
    centrum
    cnri
    [...some lines omitted...]
    tortious
    virginias
    zope
    ```

