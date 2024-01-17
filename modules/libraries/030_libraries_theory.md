# introduction

With `libraries` we are talking about dynamically linked
libraries (aka shared objects). These are binaries that contain
functions and are not started themselves as programs, but are called by
other binaries.

Several programs can use the same library. The name of the library file
usually starts with `lib`, followed by the actual name of the library,
then the chracters `.so` and finally a version number.

# /lib and /usr/lib

When you look at the `/lib` or the
`/usr/lib` directory, you will see a lot of symbolic
links. Most `libraries` have a detailed version number in their name,
but receive a symbolic link from a filename which only contains the
major version number.

    root@rhel53 ~# ls -l /lib/libext*
    lrwxrwxrwx 1 root root   16 Feb 18 16:36 /lib/libext2fs.so.2 -> libext2fs.so.2.4
    -rwxr-xr-x 1 root root 113K Jun 30  2009 /lib/libext2fs.so.2.4

# ldd

Many programs have dependencies on the installation of certain
libraries. You can display these dependencies with `ldd`.

This example shows the dependencies of the `su` command.

    paul@RHEL5 ~$ ldd /bin/su
        linux-gate.so.1 =>  (0x003f7000)
        libpam.so.0 => /lib/libpam.so.0 (0x00d5c000)
        libpam_misc.so.0 => /lib/libpam_misc.so.0 (0x0073c000)
        libcrypt.so.1 => /lib/libcrypt.so.1 (0x00aa4000)
        libdl.so.2 => /lib/libdl.so.2 (0x00800000)
        libc.so.6 => /lib/libc.so.6 (0x00ec1000)
        libaudit.so.0 => /lib/libaudit.so.0 (0x0049f000)
        /lib/ld-linux.so.2 (0x4769c000)

# ltrace

The `ltrace` program allows to see all the calls made to
library functions by a program. The example below uses the -c option to
get only a summary count (there can be many calls), and the -l option to
only show calls in one library file. All this to see what calls are made
when executing `su - serena` as root.

    root@deb106:~# ltrace -c -l /lib/libpam.so.0 su - serena
    serena@deb106:~$ exit
    logout
    % time     seconds  usecs/call     calls      function
    ------ ----------- ----------- --------- --------------------
     70.31    0.014117       14117         1 pam_start
     12.36    0.002482        2482         1 pam_open_session
      5.17    0.001039        1039         1 pam_acct_mgmt
      4.36    0.000876         876         1 pam_end
      3.36    0.000675         675         1 pam_close_session
      3.22    0.000646         646         1 pam_authenticate
      0.48    0.000096          48         2 pam_set_item
      0.27    0.000054          54         1 pam_setcred
      0.25    0.000050          50         1 pam_getenvlist
      0.22    0.000044          44         1 pam_get_item
    ------ ----------- ----------- --------- --------------------
    100.00    0.020079                    11 total

# dpkg -S and debsums

Find out on Debian/Ubuntu to which package a library
belongs.

    paul@deb106:/lib$ dpkg -S libext2fs.so.2.4 
    e2fslibs: /lib/libext2fs.so.2.4

You can then verify the integrity of all files in this package using
`debsums`.

    paul@deb106:~$ debsums e2fslibs
    /usr/share/doc/e2fslibs/changelog.Debian.gz                               OK
    /usr/share/doc/e2fslibs/copyright                                         OK
    /lib/libe2p.so.2.3                                                        OK
    /lib/libext2fs.so.2.4                                                     OK

Should a library be broken, then reinstall it with
`aptitude reinstall $package`.

    root@deb106:~# aptitude reinstall e2fslibs
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Reading extended state information      
    Initializing package states... Done
    Reading task descriptions... Done  
    The following packages will be REINSTALLED:
      e2fslibs 
    ...

# rpm -qf and rpm -V

Find out on Red Hat/Fedora to which package a library
belongs.

    paul@RHEL5 ~$ rpm -qf /lib/libext2fs.so.2.4 
    e2fsprogs-libs-1.39-8.el5

You can then use `rpm -V` to verify all files in this
package. In the example below the output shows that the `S`ize and the
`T`ime stamp of the file have changed since installation.

    root@rhel53 ~# rpm -V e2fsprogs-libs
    prelink: /lib/libext2fs.so.2.4: prelinked file size differs
    S.?....T    /lib/libext2fs.so.2.4

You can then use `yum reinstall $package` to overwrite the
existing library with an original version.

    root@rhel53 lib# yum reinstall e2fsprogs-libs
    Loaded plugins: rhnplugin, security
    Setting up Reinstall Process
    Resolving Dependencies
    --> Running transaction check
    ---> Package e2fsprogs-libs.i386 0:1.39-23.el5 set to be erased
    ---> Package e2fsprogs-libs.i386 0:1.39-23.el5 set to be updated
    --> Finished Dependency Resolution
    ...

The package verification now reports no problems with the library.

    root@rhel53 lib# rpm -V e2fsprogs-libs
    root@rhel53 lib#

# tracing with strace

More detailed tracing of all function calls can be done with
`strace`. We start by creating a read only file.

    root@deb106:~# echo hello > 42.txt
    root@deb106:~# chmod 400 42.txt 
    root@deb106:~# ls -l 42.txt 
    -r-------- 1 root root 6 2011-09-26 12:03 42.txt

We open the file with `vi`, but include the `strace`
command with an output file for the trace before `vi`. This will create
a file with all the function calls done by `vi`.

    root@deb106:~# strace -o strace.txt vi 42.txt

The file is read only, but we still change the contents, and use the
`:w!` directive to write to this file. Then we close `vi` and take a
look at the trace log.

    root@deb106:~# grep chmod strace.txt 
    chmod("42.txt", 0100600)                = -1 ENOENT (No such file or directory)
    chmod("42.txt", 0100400)                = 0
    root@deb106:~# ls -l 42.txt 
    -r-------- 1 root root 12 2011-09-26 12:04 42.txt

Notice that `vi` changed the permissions on the file twice. The trace
log is too long to show a complete screenshot in this book.

    root@deb106:~# wc -l strace.txt 
    941 strace.txt
