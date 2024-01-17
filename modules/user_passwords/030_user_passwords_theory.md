# passwd

Passwords of users can be set with the `passwd` command.
Users will have to provide their old password before twice entering the
new one.

    [tania@centos7 ~]$ passwd
    Changing password for user tania.
    Changing password for tania.
    (current) UNIX password:
    New password:
    BAD PASSWORD: The password is shorter than 8 characters
    New password:
    BAD PASSWORD: The password is a palindrome
    New password:
    BAD PASSWORD: The password is too similar to the old one
    passwd: Have exhausted maximum number of retries for service

As you can see, the passwd tool will do some basic verification to
prevent users from using too simple passwords. The `root` user does not
have to follow these rules (there will be a warning though). The `root`
user also does not have to provide the old password before entering the
new password twice.

    root@debian10:~# passwd tania
    Enter new UNIX password:
    Retype new UNIX password:
    passwd: password updated successfully

# shadow file

User passwords are encrypted and kept in `/etc/shadow`.
The /etc/shadow file is read only and can only be read by root. We will
see in the file permissions section how it is possible for users to
change their password. For now, you will have to know that users can
change their password with the `/usr/bin/passwd` command.

    [root@centos7 ~]# tail -4 /etc/shadow
    paul:$6$ikp2Xta5BT.Tml.p$2TZjNnOYNNQKpwLJqoGJbVsZG5/Fti8ovBRd.VzRbiDSl7TEq\
    IaSMH.TeBKnTS/SjlMruW8qffC0JNORW.BTW1:16338:0:99999:7:::
    tania:$6$8Z/zovxj$9qvoqT8i9KIrmN.k4EQwAF5ryz5yzNwEvYjAa9L5XVXQu.z4DlpvMREH\
    eQpQzvRnqFdKkVj17H5ST.c79HDZw0:16356:0:99999:7:::
    laura:$6$glDuTY5e$/NYYWLxfHgZFWeoujaXSMcR.Mz.lGOxtcxFocFVJNb98nbTPhWFXfKWG\
    SyYh1WCv6763Wq54.w24Yr3uAZBOm/:16356:0:99999:7:::
    valentina:$6$jrZa6PVI$1uQgqR6En9mZB6mKJ3LXRB4CnFko6LRhbh.v4iqUk9MVreui1lv7\
    GxHOUDSKA0N55ZRNhGHa6T2ouFnVno/0o1:16356:0:99999:7:::
    [root@centos7 ~]#

The `/etc/shadow` file contains nine colon separated columns. The nine
fields contain (from left to right) the user name, the encrypted
password (note that only inge and laura have an encrypted password), the
day the password was last changed (day 1 is January 1, 1970), number of
days the password must be left unchanged, password expiry day, warning
number of days before password expiry, number of days after expiry
before disabling the account, and the day the account was disabled
(again, since 1970). The last field has no meaning yet.

All the passwords in the screenshot above are hashes of `hunter2`.

# encryption with passwd

Passwords are stored in an encrypted format. This encryption is done by
the `crypt` function. The easiest (and recommended) way to
add a user with a password to the system is to add the user with the
`useradd -m user` command, and then set the user\'s
password with `passwd`.

    [root@RHEL4 ~]# useradd -m xavier
    [root@RHEL4 ~]# passwd xavier
    Changing password for user xavier.
    New UNIX password: 
    Retype new UNIX password: 
    passwd: all authentication tokens updated successfully.
    [root@RHEL4 ~]#

# encryption with openssl

Another way to create users with a password is to use the -p option of
useradd, but that option requires an encrypted password. You can
generate this encrypted password with the `openssl passwd`
command.

The `openssl passwd` command will generate several distinct hashes for
the same password, for this it uses a `salt`.

    paul@rhel65:~$ openssl passwd hunter2
    86jcUNlnGDFpY
    paul@rhel65:~$ openssl passwd hunter2
    Yj7mDO9OAnvq6
    paul@rhel65:~$ openssl passwd hunter2
    YqDcJeGoDbzKA
    paul@rhel65:~$

This `salt` can be chosen and is visible as the first two characters of
the hash.

    paul@rhel65:~$ openssl passwd -salt 42 hunter2
    42ZrbtP1Ze8G.
    paul@rhel65:~$ openssl passwd -salt 42 hunter2
    42ZrbtP1Ze8G.
    paul@rhel65:~$ openssl passwd -salt 42 hunter2
    42ZrbtP1Ze8G.
    paul@rhel65:~$

This example shows how to create a user with password.

    root@rhel65:~# useradd -m -p $(openssl passwd hunter2) mohamed

*Note that this command puts the password in your command history!*

# encryption with crypt

A third option is to create your own C program using the crypt function,
and compile this into a command.

    paul@rhel65:~$ cat MyCrypt.c
    #include <stdio.h>
    #define __USE_XOPEN
    #include <unistd.h>

    int main(int argc, char** argv)
    {
     if(argc==3)
       {
           printf("%s\n", crypt(argv[1],argv[2]));
       }
       else
       {
           printf("Usage: MyCrypt $password $salt\n" );
       }
      return 0;
    }

This little program can be compiled with `gcc` like this.

    paul@rhel65:~$ gcc MyCrypt.c -o MyCrypt -lcrypt

To use it, we need to give two parameters to MyCrypt. The first is the
unencrypted password, the second is the salt. The salt is used to
perturb the encryption algorithm in one of 4096 different ways. This
variation prevents two users with the same password from having the same
entry in `/etc/shadow`.

    paul@rhel65:~$ ./MyCrypt hunter2 42
    42ZrbtP1Ze8G.
    paul@rhel65:~$ ./MyCrypt hunter2 33
    33d6taYSiEUXI

Did you notice that the first two characters of the password are the
`salt`?

The standard output of the crypt function is using the DES algorithm
which is old and can be cracked in minutes. A better method is to use
`md5` passwords which can be recognized by a salt starting
with \$1\$.

    paul@rhel65:~$ ./MyCrypt hunter2 '$1$42'
    $1$42$7l6Y3xT5282XmZrtDOF9f0
    paul@rhel65:~$ ./MyCrypt hunter2 '$6$42'
    $6$42$OqFFAVnI3gTSYG0yI9TZWX9cpyQzwIop7HwpG1LLEsNBiMr4w6OvLX1KDa./UpwXfrFk1i...

The `md5` salt can be up to eight characters long. The salt is displayed
in `/etc/shadow` between the second and third \$, so never
use the password as the salt!

    paul@rhel65:~$ ./MyCrypt hunter2 '$1$hunter2'
    $1$hunter2$YVxrxDmidq7Xf8Gdt6qM2.

# /etc/login.defs

The `/etc/login.defs` file contains some default settings
for user passwords like password aging and length settings. (You will
also find the numerical limits of user ids and group ids and whether or
not a home directory should be created by default).

    root@rhel65:~# grep ^PASS /etc/login.defs
    PASS_MAX_DAYS   99999
    PASS_MIN_DAYS   0
    PASS_MIN_LEN    5
    PASS_WARN_AGE   7

Debian also has this file.

    root@debian10:~# grep PASS /etc/login.defs
    #  PASS_MAX_DAYS   Maximum number of days a password may be used.
    #  PASS_MIN_DAYS   Minimum number of days allowed between password changes.
    #  PASS_WARN_AGE   Number of days warning given before a password expires.
    PASS_MAX_DAYS   99999
    PASS_MIN_DAYS   0
    PASS_WARN_AGE   7
    #PASS_CHANGE_TRIES
    #PASS_ALWAYS_WARN
    #PASS_MIN_LEN
    #PASS_MAX_LEN
    # NO_PASSWORD_CONSOLE
    root@debian10:~#

# chage

The `chage` command can be used to set an expiration date
for a user account (-E), set a minimum (-m) and maximum (-M) password
age, a password expiration date, and set the number of warning days
before the password expiration date. Much of this functionality is also
available from the `passwd` command. The `-l` option of
chage will list these settings for a user.

    root@rhel65:~# chage -l paul
    Last password change                                    : Mar 27, 2014
    Password expires                                        : never
    Password inactive                                       : never
    Account expires                                         : never
    Minimum number of days between password change          : 0
    Maximum number of days between password change          : 99999
    Number of days of warning before password expires       : 7
    root@rhel65:~#

# disabling a password

Passwords in `/etc/shadow` cannot begin with an exclamation mark. When
the second field in `/etc/passwd` starts with an exclamation mark, then
the password can not be used.

Using this feature is often called `locking`, `disabling`, or
`suspending` a user account. Besides `vi` (or vipw) you can also
accomplish this with `usermod`.

The first command in the next screenshot will show the hashed password
of `laura` in `/etc/shadow`. The next command disables the password of
`laura`, making it impossible for Laura to authenticate using this
password.

    root@debian10:~# grep laura /etc/shadow | cut -c1-70
    laura:$6$JYj4JZqp$stwwWACp3OtE1R2aZuE87j.nbW.puDkNUYVk7mCHfCVMa3CoDUJV
    root@debian10:~# usermod -L laura

As you can see below, the password hash is simply preceded with an
exclamation mark.

    root@debian10:~# grep laura /etc/shadow | cut -c1-70
    laura:!$6$JYj4JZqp$stwwWACp3OtE1R2aZuE87j.nbW.puDkNUYVk7mCHfCVMa3CoDUJ
    root@debian10:~#

The root user (and users with `sudo` rights on `su`) still
will be able to `su` into the `laura` account (because the
password is not needed here). Also note that `laura` will still be able
to login if she has set up passwordless ssh!

    root@debian10:~# su - laura
    laura@debian10:~$ 

You can unlock the account again with `usermod -U`.

    root@debian10:~# usermod -U laura
    root@debian10:~# grep laura /etc/shadow | cut -c1-70
    laura:$6$JYj4JZqp$stwwWACp3OtE1R2aZuE87j.nbW.puDkNUYVk7mCHfCVMa3CoDUJV

Watch out for tiny differences in the command line options of `passwd`,
`usermod`, and `useradd` on different Linux distributions. Verify the
local files when using features like
`"disabling, suspending, or locking"` on user accounts and their
passwords.

# editing local files

If you still want to manually edit the `/etc/passwd` or
`/etc/shadow`, after knowing these commands for password
management, then use `vipw` instead of vi(m) directly. The
`vipw` tool will do proper locking of the file.

    [root@RHEL5 ~]# vipw /etc/passwd
    vipw: the password file is busy (/etc/ptmp present)
