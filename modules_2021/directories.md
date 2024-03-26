# Directories

## Creating directories

### ls


Files are always stored in a **directory** and there is always a
**current directory**. To see the *list* of files in the current
directory type **ls**.

    paul@debian10:~$ ls
    paul@debian10:~$

There are likely no files yet in your **home directory**, so there is no
output to this command.

Later in this book we will look at the *hidden files* in this directory.

### mkdir


You can create a new empty directory with the **mkdir** command. In this
screenshot we create two directories.

    paul@debian10:~$ mkdir data
    paul@debian10:~$ mkdir backup
    paul@debian10:~$ ls
    backup  data
    paul@debian10:~$

The two new directories that you created are empty. You can verify this
by executing **ls** with the name of the directory as an argument (aka
parameter). Just like the two **mkdir** commands, there is no output
when entering these two **ls** commands.

    paul@debian10:~$ ls data
    paul@debian10:~$ ls backup
    paul@debian10:~$

In general, when there is no output to a Linux command, you may assume
that everything worked fine!

## Display the current directory


Your current directory can be displayed with the **pwd** (print working
directory) command.

    paul@debian10:~$ pwd
    /home/paul
    paul@debian10:~$

## Entering directories


The **cd** (change directory) command allows you to enter an existing
directory. This command will change your current directory.

    paul@debian10:~$ cd data
    paul@debian10:~/data$ pwd
    /home/paul/data
    paul@debian10:~/data$

put you back in your **home directory**.

    paul@debian10:~/data$ pwd
    /home/paul/data
    paul@debian10:~/data$ cd
    paul@debian10:~$ pwd
    /home/paul
    paul@debian10:~$

Here is another example of changing directories (to /etc) and then
getting back to the **home directory**.

    paul@debian10:~$ cd /etc
    paul@debian10:/etc$ pwd
    /etc
    paul@debian10:/etc$ cd
    paul@debian10:~$ pwd
    /home/paul
    paul@debian10:~$

## Current directory in prompt

You may have noticed by now that your current directory is shown in your
prompt. This is default behaviour on Debian Linux. We will see later on
this book how you change the appearance of your prompt.


Note that the **home directory** is abbreviated to a **~** (tilde). So
when we write **~/data** we mean the **data** directory in your home
directory.

Entering the **cd** command is identical to entering the **cd ~**
command.

## Path completion


Linux people are lazy, so they developed **path completion**. In this
case this means that you can type the first letter of a directory,
followed by the **tab key** when using the **cd** command.

Try this with the two directories in your home directory by typing **"cd
d tab key"** or **"cd b tab key"**.

    paul@debian10:~$ cd data/
    paul@debian10:~/data$ cd
    paul@debian10:~$ cd backup/
    paul@debian10:~/backup$

Notice how the **tab key** path completion puts a **"/"** at the end of
the directory. This is to indicate that it is a directory. Later we will
see **file completion** which lacks this trailing slash.

## Removing directories


You can remove *empty* directories with the **rmdir** command. In the
screenshot below we remove the **data** directory.

    paul@debian10:~$ rmdir data/
    paul@debian10:~$ ls
    backup
    paul@debian10:~$

Did you use the **tab key** when removing this directory?

For **rmdir** to work, the directory must be empty! In the following
screenshot we create a directory **"pictures"** inside the directory
**"data"**. This means the **"data"** directory is not empty, so the
**rmdir** command fails.

    paul@debian10:~$ mkdir data
    paul@debian10:~$ mkdir data/pictures
    paul@debian10:~$ ls
    backup  data
    paul@debian10:~$ ls data/
    pictures
    paul@debian10:~$ rmdir data/
    rmdir: failed to remove data/: Directory not empty
    paul@debian10:~$

## Case sensitive


The name of a directory is **case sensitive**! In the screenshot below
we create three different directories.

    paul@debian10:~$ mkdir music
    paul@debian10:~$ mkdir Music
    paul@debian10:~$ mkdir MUSIC
    paul@debian10:~$ ls
    backup  data  music  Music  MUSIC
    paul@debian10:~$

Let us quickly remove two of those three directories.

    paul@debian10:~$ rmdir MUSIC/ Music/
    paul@debian10:~$

## Creating the necessary parent directories

The following command fails because the parent directory **"cars"** does
not exist. <span class="indexterm"></span>

    paul@debian10:~$ mkdir cars/mercedes
    mkdir: cannot create directory ‘cars/mercedes’: No such file or directory
    paul@debian10:~$

But we can add the **"-p"** option to **mkdir** to force the creation of
the parent directory **cars**.

    paul@debian10:~$ mkdir -p cars/mercedes
    paul@debian10:~$ ls
    backup  cars  data  music
    paul@debian10:~$ ls cars
    mercedes
    paul@debian10:~$

## Searching for directories


By now we have forgotten where we put the **"pictures"** directory so we
have to search for it. The screenshot below uses the **find** command to
search for a directory named **pictures**.

    paul@debian10:~$ find -name pictures
    ./data/pictures
    paul@debian10:~$

The **find** command will by default look in the **current directory**
and in **all subdirectories** of the current directory.

## Entering a parent directory


You can use **cd ..** to enter the parent directory of the current
directory. In the example below we use **cd ..** to go from
**/home/paul/cars/mercedes** to **/home/paul/cars**.

    paul@debian10:~$ cd cars/mercedes/
    paul@debian10:~/cars/mercedes$ pwd
    /home/paul/cars/mercedes
    paul@debian10:~/cars/mercedes$ cd ..
    paul@debian10:~/cars$ pwd
    /home/paul/cars
    paul@debian10:~/cars$

Note that there is a space between **cd** and **..** !

## The root directory


What happens if we keep going to the parent directory? Let us test.

    paul@debian10:~/cars$ pwd
    /home/paul/cars
    paul@debian10:~/cars$ cd ..
    paul@debian10:~$ pwd
    /home/paul
    paul@debian10:~$ cd ..
    paul@debian10:/home$ pwd
    /home
    paul@debian10:/home$ cd ..
    paul@debian10:/$ pwd
    /
    paul@debian10:/$ cd ..
    paul@debian10:/$ pwd
    /
    paul@debian10:/$

You can see that we reach the end when we are in the **"/"** directory.
This **"/"** is called the **root directory**. The **root directory** is
the start of all files and directories on your Linux computer.

You cannot remove directories in the root directory, they are protected
by permissions (which we will discuss later).

    paul@debian10:~$ rmdir /etc
    rmdir: failed to remove /etc: Permission denied
    paul@debian10:~$ rmdir /bin
    rmdir: failed to remove /bin: Permission denied
    paul@debian10:~$

## Absolute and relative paths


### absolute path

Whenever you start the name of a directory (or a file) with a **"/"** ,
then the computer will look for that directory (or file) in the **root
directory**. In the example below we enter three directories using an
**absolute path**.

    paul@debian10:~$ cd /var
    paul@debian10:/var$ cd /etc
    paul@debian10:/etc$ cd /usr/bin
    paul@debian10:/usr/bin$

The commands will fail if you forget the starting **"/"** !

    paul@debian10:~$ cd var
    -bash: cd: var: No such file or directory
    paul@debian10:~$ cd etc
    -bash: cd: etc: No such file or directory
    paul@debian10:~$ cd usr/bin
    -bash: cd: usr/bin: No such file or directory
    paul@debian10:~$

### relative path

Whenever you use the name of a directory (or file) without a starting
**"/"** , then you are using a **relative** path. Using a **relative
path** only works if the target directory is in the current directory.

    paul@debian10:~$ ls
    backup  cars  data  music
    paul@debian10:~$ cd cars
    paul@debian10:~/cars$ cd data
    -bash: cd: data: No such file or directory
    paul@debian10:~/cars$ cd /home/paul/data
    paul@debian10:~/data$

## Cheat sheet

<table>
<caption>Directories</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ls</p></td>
<td style="text-align: left;"><p>list the contents of the current
directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ls foo</p></td>
<td style="text-align: left;"><p>list the contents of the
<strong>foo</strong> directory</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ls /bar</p></td>
<td style="text-align: left;"><p>list the contents of the
<strong>/bar</strong> directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>mkdir foo</p></td>
<td style="text-align: left;"><p>make (create) a new directory named
<strong>foo</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mkdir foo/bar</p></td>
<td style="text-align: left;"><p>create the <strong>bar</strong>
directory in the <strong>foo</strong> directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>mkdir -p foo/bar</p></td>
<td style="text-align: left;"><p>create both <strong>foo</strong> and
<strong>foo/bar</strong> if they don’t exist</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>pwd</p></td>
<td style="text-align: left;"><p>print the name of the current (working)
directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cd</p></td>
<td style="text-align: left;"><p>change into your home
directory</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>cd foo</p></td>
<td style="text-align: left;"><p>change into the <strong>foo</strong>
directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cd /bar</p></td>
<td style="text-align: left;"><p>change into the <strong>/bar</strong>
directory</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>cd</p></td>
<td style="text-align: left;"><p>change to the parent directory of the
current directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rmdir foo</p></td>
<td style="text-align: left;"><p>remove (delete) the
<strong>empty</strong> directory <strong>foo</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>find -name foo</p></td>
<td style="text-align: left;"><p>search for the directory (or file)
named <strong>foo</strong></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>find -type d -name foo</p></td>
<td style="text-align: left;"><p>search for the directory named
<strong>foo</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/</p></td>
<td style="text-align: left;"><p>/ is the name of the
<strong>root</strong> directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>cd /foo</p></td>
<td style="text-align: left;"><p>use an <strong>absolute</strong> path
to enter the <strong>/foo</strong> directory</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>cd foo</p></td>
<td style="text-align: left;"><p>use a <strong>relative</strong> path to
enter the <strong>foo</strong> directory</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>tab key</p></td>
<td style="text-align: left;"><p>complete the path you are
typing</p></td>
</tr>
</tbody>
</table>

Directories

## Practice

1.  Display the name of your current directory.

2.  Change your current directory to your home directory.

3.  Create the directories **~/data** and **~/backup** .

4.  Remove the directory **~/data** .

5.  In one command create the directory **~/data/payable/invoices** .

6.  Remove the **invoices** directory.

7.  Enter the **/var** directory and display its contents.

8.  Go back to your home directory using an **absolute path**.

9.  Enter the **~/data** directory using a **relative path**.

10. Enter your home directory and then search for the **payable**
    directory.

## Solution

1.  Display the name of your current directory.

        pwd

2.  Change your current directory to your home directory.

        cd

3.  Create the directories **~/data** and **~/backup** .

        mkdir ~/data ~/backup

    There are other solutions to this, for example:

        cd
        mkdir data
        mkdir backup

4.  Remove the directory **~/data** .

        rmdir ~/data

5.  In one command create the directory **~/data/payable/invoices** .

        mkdir -p ~/data/payable/invoices

6.  Remove the **invoices** directory.

        rmdir ~/data/payable/invoices

    Or you could also do it like this:

        cd data
        cd payable
        rmdir invoices

7.  Enter the **/var** directory and display its contents.

        cd /var
        ls

8.  Go back to your home directory using an **absolute path**.

        cd /home/paul

9.  Enter the **~/data** directory using a **relative path**.

        cd data/

10. Enter your home directory and then search for the **payable**
    directory.

        cd
        find -name payable
