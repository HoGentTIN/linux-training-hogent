## solution: filters

1\. Put a sorted list of all bash users in bashusers.txt.

    grep bash /etc/passwd | cut -d: -f1 | sort > bashusers.txt

2\. Put a sorted list of all logged on users in onlineusers.txt.

    who | cut -d' ' -f1 | sort > onlineusers.txt

3\. Make a list of all filenames in `/etc` that contain the string
`conf` in their filename.

    ls /etc | grep conf

4\. Make a sorted list of all files in `/etc` that contain the case
insensitive string `conf` in their filename.

    ls /etc | grep -i conf | sort

5\. Look at the output of `/sbin/ifconfig`. Write a line that displays
only ip address and the subnet mask.

    /sbin/ifconfig | head -2 | grep 'inet ' | tr -s ' ' | cut -d' ' -f3,5

6\. Write a line that removes all non-letters from a stream.

    student@linux:~$ cat text
    This is, yes really! , a text with ?&* too many str$ange# characters ;-)
    student@linux:~$ cat text | tr -d ',!$?.*&^%#@;()-'
    This is yes really  a text with  too many strange characters
        

7\. Write a line that receives a text file, and outputs all words on a
separate line.

    student@linux:~$ cat text2 
    it is very cold today without the sun

    student@linux:~$ cat text2 | tr ' ' '\n'
    it
    is
    very
    cold
    today
    without
    the
    sun
        

8\. Write a spell checker on the command line. (There may be a
dictionary in `/usr/share/dict/` .)

    student@linux ~$ echo "The zun is shining today" > text

    student@linux ~$ cat > DICT
    is
    shining
    sun
    the
    today

    student@linux ~$ cat text | tr 'A-Z ' 'a-z\n' | sort | uniq | comm -23 - DICT
    zun
        

You could also add the solution from question number 6 to remove
non-letters, and `tr -s ' '` to remove redundant spaces.

