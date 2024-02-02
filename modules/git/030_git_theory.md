## git

Linus Torvalds created `git` back in 2005 when Bitkeeper
changed its license and the Linux kernel developers where no longer able
to use it for free.

`git` quickly became popular and is now the most widely used
`distributed version control` system in the world.

Geek and Poke demonstrates why we need version control (image property
of Geek and Poke CCA 3.0).

![](images/version_control.jpg)

Besides `source code` for software, you can also find German and
Icelandic `law` on github (and probably much more by the time you are
reading this).

## installing git

We install `git` with `aptitude install git` as seen in
this screenshot on Debian 6.

    root@debian6:~# aptitude install git
    The following NEW packages will be installed:
      git libcurl3-gnutls{a} liberror-perl{a}
    0 packages upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
    ...
    Processing triggers for man-db ...
    Setting up libcurl3-gnutls (7.21.0-2.1+squeeze2) ...
    Setting up liberror-perl (0.17-1) ...
    Setting up git (1:1.7.2.5-3) ...

## starting a project

First we create a project directory, with a simple file in it.

    paul@debian6~$ mkdir project42
    paul@debian6~$ cd project42/
    paul@debian6~/project42$ echo "echo The answer is 42." >> question.sh

### git init

Then we tell `git` to create an empty git repository in this directory.

    paul@debian6~/project42$ ls -la
    total 12
    drwxrwxr-x  2 paul paul 4096 Dec  8 16:41 .
    drwxr-xr-x 46 paul paul 4096 Dec  8 16:41 ..
    -rw-rw-r--  1 paul paul   23 Dec  8 16:41 question.sh
    paul@debian6~/project42$ git init
    Initialized empty Git repository in /home/paul/project42/.git/
    paul@debian6~/project42$ ls -la
    total 16
    drwxrwxr-x  3 paul paul 4096 Dec  8 16:44 .
    drwxr-xr-x 46 paul paul 4096 Dec  8 16:41 ..
    drwxrwxr-x  7 paul paul 4096 Dec  8 16:44 .git
    -rw-rw-r--  1 paul paul   23 Dec  8 16:41 question.sh

### git config

Next we use `git config` to set some global options.

    paul@debian6$ git config --global user.name Paul
    paul@debian6$ git config --global user.email "paul.cobbaut@gmail.com"
    paul@debian6$ git config --global core.editor vi

We can verify this config in `~/.gitconfig`:

    paul@debian6~/project42$ cat ~/.gitconfig
    [user]
        name = Paul
        email = paul.cobbaut@gmail.com
    [core]
        editor = vi

### git add

Time now to add file to our project with `git add`, and verify that it
is added with `git status`.

    paul@debian6~/project42$ git add question.sh
    paul@debian6~/project42$ git status
    # On branch master
    #
    # Initial commit
    #
    # Changes to be committed:
    #   (use "git rm --cached <file>..." to unstage)
    #
    #   new file:   question.sh
    #

The `git status` tells us there is a new file ready to be committed.

### git commit

With `git commit` you force git to record all added files (and all
changes to those files) permanently.

    paul@debian6~/project42$ git commit -m "starting a project"
    [master (root-commit) 5c10768] starting a project
     1 file changed, 1 insertion(+)
     create mode 100644 question.sh
    paul@debian6~/project42$ git status
    # On branch master
    nothing to commit (working directory clean)

### changing a committed file

The screenshots below show several steps. First we change a file:

    paul@debian6~/project42$ git status
    # On branch master
    nothing to commit (working directory clean)
    paul@debian6~/project42$ vi question.sh 

Then we verify the status and see that it is modified:

    paul@debian6~/project42$ git status
    # On branch master
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #   modified:   question.sh
    #
    no changes added to commit (use "git add" and/or "git commit -a")

Next we add it to the git repository.

    paul@debian6~/project42$ git add question.sh
    paul@debian6~/project42$ git commit -m "adding a she-bang to the main script"
    [master 86b8347] adding a she-bang to the main script
     1 file changed, 1 insertion(+)
    paul@debian6~/project42$ git status
    # On branch master
    nothing to commit (working directory clean)

### git log

We can see all our commits again using `git log`.

    paul@debian6~/project42$ git log
    commit 86b8347192ea025815df7a8e628d99474b41fb6c
    Author: Paul <paul.cobbaut@gmail.com>
    Date:   Sat Dec 8 17:12:24 2012 +0100

        adding a she-bang to the main script

    commit 5c10768f29aecc16161fb197765e0f14383f7bca
    Author: Paul <paul.cobbaut@gmail.com>
    Date:   Sat Dec 8 17:09:29 2012 +0100

        starting a project

The log format can be changed.

    paul@debian6~/project42$ git log --pretty=oneline
    86b8347192ea025815df7a8e628d99474b41fb6c adding a she-bang to the main script
    5c10768f29aecc16161fb197765e0f14383f7bca starting a project

The log format can be customized a lot.

    paul@debian6~/project42$ git log --pretty=format:"%an: %ar :%s"
    Paul: 8 minutes ago :adding a she-bang to the main script
    Paul: 11 minutes ago :starting a project

### git mv

Renaming a file can be done with `mv` followed by a `git remove` and a
`git add` of the new filename. But it can be done easier and in one
command using `git mv`.

    paul@debian6~/project42$ git mv question.sh thequestion.sh
    paul@debian6~/project42$ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #   renamed:    question.sh -> thequestion.sh
    #
    paul@debian6~/project42$ git commit -m "improved naming scheme"
    [master 69b2c8b] improved naming scheme
     1 file changed, 0 insertions(+), 0 deletions(-)
     rename question.sh => thequestion.sh (100%)

## git branches

Working on the project can be done in one or more `git branches`. Here
we create a new branch that will make changes to the script. We will
`merge` this branch with the `master branch` when we are sure the script
works. (It can be useful to add `git status` commands when practicing).

    paul@debian6~/project42$ git branch
    * master
    paul@debian6~/project42$ git checkout -b newheader
    Switched to a new branch 'newheader'
    paul@debian6~/project42$ vi thequestion.sh 
    paul@debian6~/project42$ git add thequestion.sh
    paul@debian6~/project42$ source thequestion.sh 
    The answer is 42.

It seems to work, so we commit in this branch.

    paul@debian6~/project42$ git commit -m "adding a new company header"
    [newheader 730a22b] adding a new company header
     1 file changed, 4 insertions(+)
    paul@debian6~/project42$ git branch
      master
    * newheader
    paul@debian6~/project42$ cat thequestion.sh 
    #!/bin/bash
    #
    # copyright linux-training.be
    #

    echo The answer is 42.

Let us go back to the master branch and see what happened there.

    paul@debian6~/project42$ git checkout master
    Switched to branch 'master'
    paul@debian6~/project42$ cat thequestion.sh 
    #!/bin/bash
    echo The answer is 42.

Nothing happened in the master branch, because we worked in another
branch.

When we are sure the branch is ready for production, then we merge it
into the master branch.

    paul@debian6~/project42$ cat thequestion.sh 
    #!/bin/bash
    echo The answer is 42.
    paul@debian6~/project42$ git merge newheader
    Updating 69b2c8b..730a22b
    Fast-forward
     thequestion.sh |    4 ++++
     1 file changed, 4 insertions(+)
    paul@debian6~/project42$ cat thequestion.sh 
    #!/bin/bash
    #
    # copyright linux-training.be
    #

    echo The answer is 42.

The newheader branch can now be deleted.

    paul@debian6~/project42$ git branch
    * master
      newheader
    paul@debian6~/project42$ git branch -d newheader
    Deleted branch newheader (was 730a22b).
    paul@debian6~/project42$ git branch
    * master

## to be continued\...

The `git` story is not finished.

There are many excellent online tutorials for `git`. This list can save
you one Google query:

    http://gitimmersion.com/
    http://git-scm.com/book

## github.com

Create an account on `github.com`. This website is a
frontend for an immense git server with over two and a half million
users and almost five million projects (including Fedora, Linux kernel,
Android, Ruby on Rails, Wine, X.org, VLC\...)

    https://github.com/signup/free

This account is free of charge, we will use it in the examples below.

## add your public key to github

I prefer to use github with a `public key`, so it probably
is a good idea that you also upload your public key to github.com.

![](images/github_pubkey.png)

You can upload your own key via the web interface:

    https://github.com/settings/ssh

Please do not forget to protect your `private key`!
