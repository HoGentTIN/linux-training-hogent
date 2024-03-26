# Links

## inode

Every file on an **ext4** filesystem, which is the default on Debian 10
Linux, has an **inode** in the **inode table**. Each **inode** on a
filesystem has a unique identification number, called the **inode
number**. In this **inode** there is meta-information about the file
like the permissions, the owners, the last access time, a pointer to the
content of the file; basically every piece of meta information about the
file, except for the file name (and the actual file contents).

Consider this example of a directory **/home/paul/links** with three
files.

    paul@debian10:~/links$ ls
    answer.txt  file42  question.txt
    paul@debian10:~/links$

The **inode** number of a file can be seen using **ls -li** . The
**inode** number of the **answer.txt** file is 393407 in this
screenshot.

    paul@debian10:~/links$ ls -li answer.txt
    393407 -rwx------ 2 paul paul 56 Aug 17 21:33 answer.txt
    paul@debian10:~/links$

The file name is located in the **directory**, together with its **inode
number**. A **directory** is in fact a list of filenames with **inode
numbers** as pointers to files. So in this case the
**/home/paul/links/** directory has an entry that reads **answer.txt
393407**.

<figure>
<img src="images/inodes_directory.svg"
alt="images/inodes_directory.svg" />
</figure>

Many fields in the **inode** can be seen with the **stat** command, only
some fields are shown in the drawing above.

    paul@debian10:~/links$ stat answer.txt
      File: answer.txt
      Size: 56              Blocks: 8          IO Block: 4096   regular file
    Device: 801h/2049d      Inode: 393407      Links: 2
    Access: (0700/-rwx------)  Uid: ( 1000/    paul)   Gid: ( 1000/    paul)
    Access: 2019-08-17 21:33:26.380957381 +0200
    Modify: 2019-08-17 21:33:26.380957381 +0200
    Change: 2019-08-17 21:35:28.096364280 +0200
     Birth: -
    paul@debian10:~/links$

The file named **file42** was created right after **answer.txt** and it
got the next available **inode**, as can be seen in this screenshot.

    paul@debian10:~/links$ ls -li file42
    393408 -rw-r--r-- 1 paul paul 0 Aug 17 23:10 file42
    paul@debian10:~/links$

<figure>
<img src="images/inodes_directory2.svg"
alt="images/inodes_directory2.svg" />
</figure>

As you can see here, the permissions **644** are stored in the **inode**
together with all the other meta-information.

## hard link

Every file has a unique **inode** number, except for hard links. When
two distinct filenames point to the same **inode**, then we call this
two hard links to the same file. Remember all the information about the
file is in the **inode**, so when two filenames point to the same
**inode**, then they share permissions, owners, content, access time
etcetera, only the filename is different.

Consider this example of two files with the same **inode**. These two
files share everything.

    paul@debian10:~/links$ ls -li answer.txt question.txt
    393407 -rwx------ 2 paul paul 56 Aug 17 21:33 answer.txt
    393407 -rwx------ 2 paul paul 56 Aug 17 21:33 question.txt
    paul@debian10:~/links$

In a drawing this looks like this in the directory, with two pointers
pointing to the same **inode**.

<figure>
<img src="images/inodes_directory3.svg"
alt="images/inodes_directory3.svg" />
</figure>

When we execute a **chmod** command on one of them, then the other will
also change, because it points to the same **inode** and the permissions
are inside the **inode**.

    paul@debian10:~/links$ chmod 640 question.txt
    paul@debian10:~/links$ ls -li answer.txt question.txt
    393407 -rw-r----- 2 paul paul 56 Aug 17 21:33 answer.txt
    393407 -rw-r----- 2 paul paul 56 Aug 17 21:33 question.txt
    paul@debian10:~/links$

There is also no difference between the two files. One is not pointing
to the other, they are both pointing to the same **inode**.

## ln


Hard links to an existing **inode** can be created with the **ln**
command. In the screenshot below we create a third hard link for the
existing **answer.txt** and **question.txt** files.

    paul@debian10:~/links$ ln answer.txt third
    paul@debian10:~/links$ ls -li answer.txt question.txt third
    393407 -rw-r----- 3 paul paul 56 Aug 17 21:33 answer.txt
    393407 -rw-r----- 3 paul paul 56 Aug 17 21:33 question.txt
    393407 -rw-r----- 3 paul paul 56 Aug 17 21:33 third
    paul@debian10:~/links$

It doesn’t matter whether we use **answer.txt** or **question.txt** to
create the new hard link, because all hard links are equal. Data added
to one of the three hard linked files will be added to all hard linked
files.

    paul@debian10:~/links$ echo "The quick brown fox jumped over the lazy dog." >> third
    paul@debian10:~/links$ ls -l answer.txt question.txt third
    -rw-r----- 3 paul paul 102 Aug 18 15:23 answer.txt
    -rw-r----- 3 paul paul 102 Aug 18 15:23 question.txt
    -rw-r----- 3 paul paul 102 Aug 18 15:23 third
    paul@debian10:~/links$

Did you notice that the number before the owners in **ls -l** is
counting the number of **hard links**? Let’s create a hard link to these
three files in another directory.

    paul@debian10:~/links$ ln question.txt /home/paul/backup/fourth_hardlink
    paul@debian10:~/links$ ls -li answer.txt question.txt third
    393407 -rw-r----- 4 paul paul 102 Aug 18 15:23 answer.txt
    393407 -rw-r----- 4 paul paul 102 Aug 18 15:23 question.txt
    393407 -rw-r----- 4 paul paul 102 Aug 18 15:23 third
    paul@debian10:~/links$

Voila, it says four hard links exist now to these files.

## find hard links


To **find** all hard links to a file, you can use the **find** command
with the **-inum** option, as this screenshot shows.

    paul@debian10:~/links$ find ~ -inum 393407
    /home/paul/links/question.txt
    /home/paul/links/answer.txt
    /home/paul/links/third
    /home/paul/backup/fourth_hardlink
    paul@debian10:~/links$

## . and ..


If you look at the contents of a (newly created) directory, then you
will notice two files named **.** and **..** are always there. We know
that **.** points to the current directory, and **..** points to the
parent directory. This works via hard links, as we can see when
executing **ls -lai**.

    paul@debian10:~/links$ ls -lai
    total 20
    393352 drwxr-xr-x  2 paul paul 4096 Aug 18 15:20 .
    393246 drwxr-xr-x 14 paul paul 4096 Aug 17 21:32 ..
    393407 -rw-r-----  4 paul paul  102 Aug 18 15:23 answer.txt
    393408 -rw-r--r--  1 paul paul    0 Aug 17 23:10 file42
    393407 -rw-r-----  4 paul paul  102 Aug 18 15:23 question.txt
    393407 -rw-r-----  4 paul paul  102 Aug 18 15:23 third
    paul@debian10:~/links$

So the **inode** of this directory is **393352** and the **inode** of
the parent directory named **/home/paul** is **393246**. All files and
directories form a giant tree of **inodes** and file names.

<figure>
<img src="images/inodes_directory4.svg"
alt="images/inodes_directory4.svg" />
</figure>

## symbolic link


There is a limitation to **hard links** in that they have to exist on
the same filesystem. To create links between different filesystems we
need the **ln -s** command to create a **symbolic link**. A **symbolic
link** is sometimes called a **symlink** or even a **soft link**.

In the screenshot below we create a **symbolic link** to the **file42**
file.

    paul@debian10:~/links$ ln -s file42 symlink.txt
    paul@debian10:~/links$ ls -l
    total 12
    -rw-r----- 4 paul paul 102 Aug 18 15:23 answer.txt
    -rw-r--r-- 1 paul paul   0 Aug 17 23:10 file42
    -rw-r----- 4 paul paul 102 Aug 18 15:23 question.txt
    lrwxrwxrwx 1 paul paul   6 Aug 18 15:38 symlink.txt -> file42
    -rw-r----- 4 paul paul 102 Aug 18 15:23 third
    paul@debian10:~/links$

Now we can say that **symlink.txt** is pointing to **file42**, and not
the other way around. Notice that **symbolic links** all have an **l**
as the first character in **ls -l**, and that permissions don’t apply,
the permissions of the target file apply.

## readlink -f


There is a simple tool called **readlink** that follows a **symbolic
link** to its target. But **readlink** becomes useful with the **-f**
switch to keep on following **symbolic links** to **symbolic links**
until it reaches the end file.

    paul@debian10:~/links$ readlink /usr/bin/rename
    /etc/alternatives/rename
    paul@debian10:~/links$ readlink -f /usr/bin/rename
    /usr/bin/file-rename
    paul@debian10:~/links$

## Cheat sheet

<table>
<caption>Links</caption>
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
<td style="text-align: left;"><p>ls -il</p></td>
<td style="text-align: left;"><p>Show <strong>i</strong>node number in
long listing output.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ln foo bar</p></td>
<td style="text-align: left;"><p>Create a hard link named
<strong>bar</strong> (linked with <strong>foo</strong>).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ln -s foo bar</p></td>
<td style="text-align: left;"><p>Create a symbolic link from
<strong>bar</strong> to <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>find / -inum 42</p></td>
<td style="text-align: left;"><p>Find all files with <strong>inode
number</strong> 42.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>.</p></td>
<td style="text-align: left;"><p>This is a hard link to the current
directory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>..</p></td>
<td style="text-align: left;"><p>This is a hard link to the parent
directory.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>readlink</p></td>
<td style="text-align: left;"><p>Follows a symbolic link.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>readlink -f</p></td>
<td style="text-align: left;"><p>Recursively follows all symbolic
links.</p></td>
</tr>
</tbody>
</table>

Links

## Practice

1.  Create a new directory, then create two empty files in it.

2.  Look at the inode numbers of the two files.

3.  Create a hard link to the second file.

4.  Change the permissions on one of the hard links, verify that both
    change.

5.  How many hard links are there to the parent directory? Explain.

6.  Find all hard links to the second file.

7.  Create a symbolic link to the second file.

## Solution

1.  Create a new directory, then create two empty files in it.

        mkdir ~/links
        cd ~/links
        > one
        > two

2.  Look at the inode numbers of the two files.

        ls -li

3.  Create a hard link to the second file.

        ln two three

4.  Change the permissions on one of the hard links, verify that both
    change.

        chmod 600 two
        ls -l

5.  How many hard links are there to the parent directory? Explain.

        ls -lid ..
        Each subdirectory of /home/paul has a .. entry.

6.  Find all hard links to the second file.

        find ~ -inum 393407

7.  Create a symbolic link to the second file.

        ln -s symlinkname two
