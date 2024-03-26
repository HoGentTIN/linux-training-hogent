# Password management

## passwd


The most common way to set a password for a user is to use the
**passwd** command as **root**. The screenshot below sets a password for
the user **tania**. The password is set to **hunter2**, this is not
displayed on the terminal window.

    root@debian10:~# passwd tania
    New password:
    Retype new password:
    passwd: password updated successfully
    root@debian10:~#

As a normal user you can change your password using the **passwd**
command, but then you need to know (and type) your old password,
otherwise you cannot change your password.

    tania@debian10:~$ passwd
    Changing password for tania.
    Current password:
    New password:
    Retype new password:
    passwd: password updated successfully
    tania@debian10:~$

## /etc/shadow


Passwords are encrypted and the encrypted string is kept in the
**/etc/shadow** file. The screenshot below shows that the users
**laura** and **valentina** do not have a password yet. These users
cannot login using a password (but there are other ways of logging in).

    root@debian10:~# tail -3 /etc/shadow
    laura:!:18119:0:99999:7:::
    valentina:!:18119:0:99999:7:::
    tania:$6$fG8oDKeooCJBfo5W$Mc.As85/mr3iblJku7n37yWaiwtWPj9EftfmX2VicrjPqE6NcX2qzSV7GOU/SzKHY6dcriYd0XWUrf2mgi1lF.:18120:0:99999:7:::
    root@debian10:~#

The fields in **/etc/shadow** are described in the table below. The
encrypted password starts with **$6$**, this identifies the SHA-512
algorithm.

<table style="width:60%;">
<caption>/etc/shadow fields</caption>
<colgroup>
<col style="width: 9%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>field</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>tania</p></td>
<td style="text-align: left;"><p>username</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>$6$…</p></td>
<td style="text-align: left;"><p>encrypted password</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>18120</p></td>
<td style="text-align: left;"><p>the day of last password
change</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>minimum password age</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>99999</p></td>
<td style="text-align: left;"><p>password expiry day</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>7</p></td>
<td style="text-align: left;"><p>warning days before expire</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>password inactivity period</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>account expiration date</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>reserved for future use</p></td>
</tr>
</tbody>
</table>

/etc/shadow fields

The numbers 18120 and 99999 represent days since the epoch. Which means
day 0 is January 1st, 1970 (hence day 18120 is August 12th, 2019).

    paul@debian10:~$ expr $(date +%s) / 86400
    18120
    paul@debian10:~$

## chage


The fields in the **/etc/shadow** file can also be viewed (and changed)
using the **chage** command. The example below shows how to list the
values for your own user. The **root** user can use **chage** to edit
all these values.

    paul@debian10:~$ chage -l paul
    Last password change                                    : Jul 24, 2019
    Password expires                                        : never
    Password inactive                                       : never
    Account expires                                         : never
    Minimum number of days between password change          : 0
    Maximum number of days between password change          : 99999
    Number of days of warning before password expires       : 7
    paul@debian10:~$

## /etc/login.defs


The **/etc/login.defs** file contains some default settings for user
passwords, like password aging and length. You can also find the
numerical limits for uid’s and gid’s and whether or not a home directory
should be created by default.

The screenshot shows some of the password settings available in
**/etc/login.defs** .

    paul@debian10:~$ grep PASS /etc/login.defs
    #       PASS_MAX_DAYS   Maximum number of days a password may be used.
    #       PASS_MIN_DAYS   Minimum number of days allowed between password changes.
    #       PASS_WARN_AGE   Number of days warning given before a password expires.
    PASS_MAX_DAYS   99999
    PASS_MIN_DAYS   0
    PASS_WARN_AGE   7
    #PASS_CHANGE_TRIES
    #PASS_ALWAYS_WARN
    #PASS_MIN_LEN
    #PASS_MAX_LEN
    # NO_PASSWORD_CONSOLE
    paul@debian10:~$

## openssl


You can set a password when adding the user with **useradd**, but the
**-p** option of this command requires an encrypted password. To
calculate the encrypted password, you can use **openssl** as shown in
this screenshot.

    paul@debian10:~$ openssl passwd hunter2
    cTpJqYxZIIR8g
    paul@debian10:~$ openssl passwd -6 hunter2
    $6$GSsWZvofqKRDYoql$Q5Z9tFFH3zvapvitzBFBK9.rp48zvQ4U5UEhbJwoQgV5ILAw4dUv.RoQlaUTBCZ9fqJxMC.zhQBjgiJGAtdMo/
    paul@debian10:~$

The first **openssl** command will generate a valid password hash, but
this is no longer considered secure. The second **openssl** command will
use SHA-512. Both are valid arguments to the **useradd -p** option.

The following statement is not very secure, because you have a password
in clear text in the process listing and in your bash history.

    root@debian10:~# useradd -m -s /bin/bash -p $(openssl passwd -6 hunter2) mohamed
    root@debian10:~#

## crypt

A third and final option to generate password hashes is to use the
**crypt** function. The screenshot below shows how to do this in
**Python**, then in **Perl** and then in **C**. The examples below use
**salt** as the salt, this can be changed!

    paul@debian10:~$ python -c 'import crypt; print crypt.crypt("hunter2", "$6$salt")
    $6$salt$wAH.7/lcHCMJGFjRlqUqFxcc7YA/UTYSAsXRVlygbexkXyhkV2uwiJtwTlie0Eo8qerF9f.eK6LEsR.Tlhp/k0
    paul@debian10:~$ perl -e \'print crypt("hunter2","\$6\$salt\$") . "\n"
    $6$salt$wAH.7/lcHCMJGFjRlqUqFxcc7YA/UTYSAsXRVlygbexkXyhkV2uwiJtwTlie0Eo8qerF9f.eK6LEsR.Tlhp/k0
    paul@debian10:~$ ./MyCrypt hunter2 '$6$salt'
    $6$salt$wAH.7/lcHCMJGFjRlqUqFxcc7YA/UTYSAsXRVlygbexkXyhkV2uwiJtwTlie0Eo8qerF9f.eK6LEsR.Tlhp/k0
    paul@debian10:~$

The **C** program looks like this, compiling can be done after an
**apt-get install gcc**.

    paul@debian10:~$ cat MyCrypt.c
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
    paul@debian10:~$ gcc MyCrypt.c -o MyCrypt -lcrypt
    paul@debian10:~$

## Generating good passwords

There are several tools available to generate a good password. In
general a good password is one that is not easy to guess, for example a
long password with uppercase and lowercase letters, some numbers and
some other characters.

Below are some Debian tools that generate passwords.

### pwgen

The **pwgen** tool (apt-get install pwgen) is a simple tool that
generates passwords of a given length using letters and numbers.

    paul@debian10:$ pwgen 20 1
    ooSah6jie6ab3OoPheer
    paul@debian10:$ pwgen 20 1
    Eesei7chahriiFaegeiT
    paul@debian10:~$

If these passwords are not complex enough, then you can use some options
to **pwgen** (read the manual) to add other characters besides letters
and numbers.

    paul@debian10:$ pwgen -ysBv 20 1
    (WW}cX]|%Xgx>c4.pKkx
    paul@debian10:$

### gpw

The **gpw** tool (apt-get install gpw) will generate *pronounceable*
passwords consisting of only lowercase letters.

    paul@debian10:$ gpw 1 40
    cationspingkostoickshagregriousightsomsc
    paul@debian10:$ gpw 1 40
    ttliciessalingolonstaticialomilleppribin
    paul@debian10:~$

### diceware

The **diceware** tool (apt-get install diceware) will generate
pronounceable passwords from a word list. These passwords are longer but
easier to remember.

    paul@debian10:$ diceware
    StatisticCoasterCaliberPlayhouseResaleWham
    paul@debian10:$ diceware
    CrossCoherenceSubsystemArmoredReveredObstacle
    paul@debian10:~$

### xkcdpass

The last honorable mention for a password generator goes to
<https://www.xkcd.com/936/> and the tool named **xkcdpass** which is
based on the comic.

    paul@debian10:$ xkcdpass
    unsterile jawed bagpipe froth moonshine discuss
    paul@debian10:$ xkcdpass
    buckshot undertake vowel radiance trodden crestless
    paul@debian10:~$

## Locking an account

A user account can be locked by **root** using the **passwd -l**
command. The screenshot below shows the locking of the **tania**
account, done by adding an **!** at the start of the encrypted password.

    root@debian10:~# passwd -l tania
    passwd: password expiry information changed.
    root@debian10:~# grep tania /etc/shadow | cut -b1-60
    tania:!$6$JyPEIqaSBpYgRZaW$lldoHK0bBHwUEywTnFTomLQ2kUhdCHIKD
    root@debian10:~#

The user **tania** can still log on using other means, for example with
**ssh-keys**.

Passwords can be **unlocked** again using the **passwd -u** or **usermod
-U** commands. The exclamation mark will then be removed and the old
password can be used again.

## Editing local files


Being **root** on the system allows you to edit any file, so this
includes **/etc/passwd** and **/etc/shadow**. This is not advised, but
just in case you do, always use **vipw** since it will verify that no
other **vipw** has the file open for editing.

## Cheat sheet

<table>
<caption>Passwords</caption>
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
<td style="text-align: left;"><p>passwd</p></td>
<td style="text-align: left;"><p>Change your password</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>passwd foo</p></td>
<td style="text-align: left;"><p>Change the password of the user named
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>chage -l foo</p></td>
<td style="text-align: left;"><p>List the fields in /etc/shadow (except
the hash) for user <strong>foo</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>openssl passwd hunter2</p></td>
<td style="text-align: left;"><p>Display a hash for the password
<strong>hunter2</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>openssl passwd -6 hunter2</p></td>
<td style="text-align: left;"><p>Display a strong hash for the password
<strong>hunter2</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>passwd -l <strong>foo</strong></p></td>
<td style="text-align: left;"><p>Lock the account
<strong>foo</strong>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>vipw</p></td>
<td style="text-align: left;"><p>Edit /etc/passwd or /etc/shadow,
knowing you are the only one using <strong>vipw</strong>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>pwgen</p></td>
<td style="text-align: left;"><p>Generates passwords.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>gpw</p></td>
<td style="text-align: left;"><p>Generates passwords.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>diceware</p></td>
<td style="text-align: left;"><p>Generates passwords consisting of
words.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>xkcdpass</p></td>
<td style="text-align: left;"><p>Generates passwords consisting of
words.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>/etc/shadow</p></td>
<td style="text-align: left;"><p>The file with all password
hashes.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>/etc/login.defs</p></td>
<td style="text-align: left;"><p>This file contains default settings for
new user accounts.</p></td>
</tr>
</tbody>
</table>

Passwords

## Practice

1.  Create a user named **tania** with bash shell and home directory.

2.  Verify in **/etc/shadow** that **tania** has no password.

3.  Set the password for **tania** to **hunter2** .

4.  As a normal user, verify that you can use **su - tania** with the
    password.

5.  As **root**, lock the **tania** account.

6.  Verify in **/etc/shadow** that the account is locked.

7.  Verify that **su - tania** as a normal user no longer works.

8.  Unlock the **tania** account.

## Solution

1.  Create a user named **tania** with bash shell and home directory.

        useradd -m -s /bin/bash tania

2.  Verify in **/etc/shadow** that **tania** has no password.

        grep tania /etc/shadow

3.  Set the password for **tania** to **hunter2** .

        passwd tania

4.  As a normal user, verify that you can use **su - tania** with the
    password.

        su - tania
        exit

5.  As **root**, lock the **tania** account.

        passwd -l tania

6.  Verify in **/etc/shadow** that the account is locked.

        grep tania /etc/shadow

7.  Verify that **su - tania** as a normal user no longer works.

        su - tania

8.  Unlock the **tania** account.

        passwd -u tania
