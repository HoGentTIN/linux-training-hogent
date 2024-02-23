# alien

`alien` is experimental software that converts between `rpm` and `deb`
package formats (and others).

Below an example of how to use `alien` to convert an `rpm` package to a
`deb` package.

    student@linux:~$ ls -l netcat*
    -rw-r--r-- 1 paul paul 123912 2009-06-04 14:58 netcat-0.7.1-1.i386.rpm
    student@linux:~$ alien --to-deb netcat-0.7.1-1.i386.rpm 
    netcat_0.7.1-2_i386.deb generated
    student@linux:~$ ls -l netcat*
    -rw-r--r-- 1 paul paul 123912 2009-06-04 14:58 netcat-0.7.1-1.i386.rpm
    -rw-r--r-- 1 root root 125236 2009-06-04 14:59 netcat_0.7.1-2_i386.deb

*In real life, use the `netcat` tool provided by your distribution, or
use the .deb file from their website.*

# downloading software outside the repository

First and most important, whenever you download software, start by
reading the README file!

Normally the readme will explain what to do after download. You will
probably receive a .tar.gz or a .tgz file. Read the documentation, then
put the compressed file in a directory. You can use the following to
find out where the package wants to install.

    tar tvzpf $downloadedFile.tgz

You unpack them like with `tar xzf`, it will create a
directory called applicationName-1.2.3

    tar xzf $applicationName.tgz

Replace the z with a j when the file ends in .tar.bz2. The `tar`, `gzip`
and `bzip2` commands are explained in detail in the Linux Fundamentals
course.

If you download a `.deb` file, then you\'ll have to use `dpkg` to
install it, `.rpm`\'s can be installed with the `rpm` command.

# compiling software

First and most important, whenever you download source code for
installation, start by reading the README file!

Usually the steps are always the same three : running
`./configure` followed by `make` (which is
the actual compiling) and then by `make install` to copy the files to
their proper location.

    ./configure
    make
    make install

