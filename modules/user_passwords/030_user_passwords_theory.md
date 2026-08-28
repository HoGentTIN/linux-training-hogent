## passwd

Passwords of users can be set with the `passwd` command. Users will have to provide their old password before twice entering the new one.

```console
tania@linux:~$ passwd
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
```

As you can see, the passwd tool will do some basic verification to prevent users from using too simple passwords. The `root` user does not have to follow these rules (there will be a warning though). The `root` user also does not have to provide the old password before entering the new password twice.

```console
admin@linux:~$ sudo passwd tania
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
```

## shadow file

User passwords are encrypted and kept in `/etc/shadow`, and -despite the name- *not* in `/etc/passwd`. The second field of `/etc/passwd` used to contain the encrypted password, way back when computer systems still had a limited number of users and security was not a concern. The problem with this file is that it is readable by all users. Even if passwords are stored in an encrypted format, this is not acceptable, as techniques exist to crack them.

The `/etc/shadow` file has limited access rights and can only be read by the `root` user. The exact permissions depend on the Linux distribution: For example, Debian has the following permissions (640 in octal notation):

```console
student@debian:~$ ls -l /etc/shadow
-rw-r----- 1 root shadow 891 Aug 26 18:51 /etc/shadow
```

On Enterprise Linux, the shadow file even has all permissions removed (000 in octal notation):

```console
student@el:~$ ls -l /etc/shadow
----------. 1 root root 984 Aug 10 14:46 /etc/shadow
```

The `/etc/shadow` file contains nine colon separated columns (see man page `shadow(5)` for details):

```console
student@linux:~$ tail -4 /etc/shadow
paul:$6$ikp2Xta5BT.Tml.p$2TZjNnOYNNQKpwLJqoGJbVsZG5/Fti8ovBRd.VzRbiDSl7TEqIaSMH.TeBKnTS/SjlMruW8qffC0JNORW.BTW1:16338:0:99999:7:::
tania:$6$8Z/zovxj$9qvoqT8i9KIrmN.k4EQwAF5ryz5yzNwEvYjAa9L5XVXQu.z4DlpvMREHeQpQzvRnqFdKkVj17H5ST.c79HDZw0:16356:0:99999:7:::
laura:$6$glDuTY5e$/NYYWLxfHgZFWeoujaXSMcR.Mz.lGOxtcxFocFVJNb98nbTPhWFXfKWGSyYh1WCv6763Wq54.w24Yr3uAZBOm/:16356:0:99999:7:::
valentina:$6$jrZa6PVI$1uQgqR6En9mZB6mKJ3LXRB4CnFko6LRhbh.v4iqUk9MVreui1lv7GxHOUDSKA0N55ZRNhGHa6T2ouFnVno/0o1:16356:0:99999:7:::
```

The nine fields contain (from left to right):

1. the user name,
2. the encrypted password,
3. the day the password was last changed (day 1 is January 1, 1970),
4. the minimum number of days the password must be left unchanged,
5. the password expiry day,
6. number of days before the user gets password expiry warnings,
7. number of days after expiry before disabling the account,
8. the day the account was disabled (again, since 1970),
9. a field reserved for future use.

## password formats

The encrypted passwords in `/etc/shadow` look like a long string of random characters, but there is some structure to it. See the man page `crypt(5)` for detailed information about password hash formats.

A password hash consists of several parts, separated by the `$` character:

- prefix, i.e. the format of the password hash,
- options,
- salt
- hash

The following table shows some common formats that are supported on Linux systems.:

| Prefix | Description                             |
| ------ | --------------------------------------- |
| `$1$`  | MD5, should not be used anymore         |
| `$2b$` | Blowfish-based, developed for OpenBSD   |
| `$5$`  | SHA-2 with 256-bit output               |
| `$6$`  | SHA-2 with 512-bit output               |
| `$7$`  | Colin Percival's scrypt function        |
| `$y$`  | Yescrypt (currently recommended format) |

A **hash** is a type of cryptographic function that takes some input (in this case the password issued by the user) and produces a fixed-length output. A good hash function should have the following properties:

- it must be deterministic, meaning that the *same input* will always produce the *same output*,
- it must be *quick to compute* the hash for any given input,
- it must be infeasible to generate the original input from the hash output (*one-way function*),
- it must be infeasible to find two different inputs that produce the same output (*collision resistance*).

To validate a password, the system will take the password entered by the user, compute the hash and compare it with the hash stored in `/etc/shadow`. If this newly computed hash matches the hash stored in `/etc/shadow`, then the password can be safely assumed to be correct. That is, if the hash function is actually secure.

The MD5 hash function, for example, is no longer considered secure, as it is easy to find collisions with modern off-the-shelf hardware. Unfortunately, it is still widely used in many applications. If you manage a system that still uses MD5 for password hashing, the only responsible course of action is to upgrade to a more secure hash function like SHA-512 or yescrypt.

Even if we use a strong hash function, fact is that users often choose weak and predictable passwords. An attacker that knows which algorithm is used for hashing can precompute the hashes of a large number of common passwords and store them in a lookup table. This is called a **rainbow table**, which can be easily found online or created by the attacker. If an attacker can get access to user's password hashes, they can look up them up in this table and quickly find out what the original password was.

To avoid this, a random string of characters is added to the password before hashing. This string is called a **salt**. For example, in the password hash of user `paul` shown above, the salt is `ikp2Xta5BT.Tml.p`, a value generated at random when the user was created. In order to verify a password issued by the user, the system will combine the salt with the password and then compute the hash. The salt makes it infeasible to use precomputed rainbow tables, as the attacker would have to compute a new table for every possible salt.

This forces an attacker to use brute-force attacks, which are much slower than looking up a hash in a table. Now only the length and complexity of the password itself determines how long it may take to crack it.

It may sound counterintuitive, but a longer password is usually more secure than a shorter one with more complex characters. For example, the easier to remember password (or, rather, pass*phrase*) `correct horse battery staple` is much stronger than the more complex, but harder to remember password `Tr0ub4dor&3`, even though the latter contains uppercase letters, numbers and special characters. See Randall Munroe's webcomic [XKCD #936](https://xkcd.com/936/) for a humorous explanation of this. So, if you have to impose some password policy on your users, it is better to require a considerably higher minimum length than to require a mix of character types.

## encryption with passwd

The easiest (and recommended) way to add a user with a password to the system is to add the user with the `useradd -m user` command, and then set the user's password with `passwd`. Without superuser privileges, the `passwd` command will only allow you to change your own password. With superuser privileges, you can change the password of any user.

```console
student@el:~$ sudo useradd -m xavier
student@el:~$ passwd xavier
passwd: You may not view or modify password information for xavier.
student@el:~$ sudo passwd xavier
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: password updated successfully
student@el:~$ sudo tail -1 /etc/shadow
xavier:$y$j9T$YpV24uHnMMkUTK1y1iesG/$TuccsAiN1IpMtATGLqx0jL.84/JdS71J4o.Vgom95CB:20693:0:99999:7:::
```

## encryption with mkpasswd

Another way to create users with a password is to use the `-p` option of `useradd`, but that option requires an encrypted password. You can generate this encrypted password with the `mkpasswd` command. On Debian-based systems, this command is part of the `whois` package. On Enterprise Linux, it's a separate package called `mkpasswd`.

After installing the package, the `mkpasswd` command without options will prompt the user for a password and then generate a password hash using the default algorithm.

```console
student@el:~$ mkpasswd
Password: 
$y$j9T$10pq/4mSa1HyR8bof2Oa1/$AqBgxiCPj02sI.DS50.rySW.sHEbsr8koIebIDVhLsA
```

The `mkpasswd` command also supports other hashing algorithms, which can be specified with the `-m` option. With `-m help`, you can see a list of supported algorithms.

```console
student@debian:~$ mkpasswd -m help
Available methods:
yescrypt        Yescrypt
gost-yescrypt   GOST Yescrypt
scrypt          scrypt
bcrypt          bcrypt
bcrypt-a        bcrypt (obsolete $2a$ version)
sha512crypt     SHA-512
sha256crypt     SHA-256
sunmd5          SunMD5
md5crypt        MD5
bsdicrypt       BSDI extended DES-based crypt(3)
descrypt        standard 56 bit DES-based crypt(3)
nt              NT-Hash
student@el:~$ mkpasswd -m sha512crypt
Password: 
$6$OD2QX4hmSKVi2ZZf$1ZA0mbAU.tlleBWW0CMDaBAU2CQrRR2M6aPEj.Lesw6Bd6dzakJA/.oFhZNlIU3lwCTIyLnm7DUjKKKvp9ymF1
```

A password can be read on standard input with the `-s` option:

```console
student@el:~$ mkpasswd -m sha512crypt -s <<< 'hunter2'
$6$i4jpaXxPp8dNZiHh$oizmOC.WeNhYPeF6SQlXhNGZszMacVWgUyYin7dJwzmHevDTNvWP81BiJ3MRLgFuD.Jk514.2bRwjWjkvMD170
student@el:~$ mkpasswd -m sha512crypt -s <<< 'hunter2'
$6$EtkpRnKqO2xo5kgI$dcXZcYepbCZlC8AXgCW1OaWcloZnxV655z2YlQLOZZmrVyVa4CCX5Tgqgsw9m3lvGaSnD1xz5bj/WNfuxLMWW0
```

Be aware that the example above will put the plaintext password in your command history, so use this type of invocation with care. The `-s` option can be useful when you want to use the `mkpasswd` command in a script.

## encryption with openssl

You can also generate this encrypted password with the `openssl passwd <password>` command, e.g.:

```console
student@debian:~$ openssl passwd hunter2
$1$.R1ADav.$780NuEUlPbpSsWgpHDVKL.
student@debian:~$ openssl passwd hunter2
$1$YxeXfsqZ$hTDcPZRwGkoUBqOs9EKst.
student@debian:~$ openssl passwd hunter2
$1$OqSn5ZEM$78CqTsVNhAqRgO.4tlCPb1
```

You can see that the hash is different each time for the same password, because of the randomly generated salt. What is problematic about the default behaviour of `openssl passwd` is that it uses the MD5 algorithm, which is no longer considered secure. You can specify a different algorithm with e.g. the `-5`, or `-6` options. Yescrypt is not supported, though.

```console
student@debian:~$ openssl passwd -5 hunter2
$5$p3N2412OERVC3cEE$4ndBmZrszoUJVE5lpod0c8qm7K/qh2fXFMS5Dr53Bf3
student@debian:~$ openssl passwd -6 hunter2
$6$42q7KreV3ygmX0wc$y9cZxz9ZC1y38dQT20E6dGc2v56kZkl.PE.DesbsExoqt0i0eixLrmX9qZeSQ8PItG9mrlTPpQsS5WQsO0hY31
```

## encryption with python

Implementations of the most common hashing algorithms used for password encryption are also available in Python. For example, to generate a SHA-512 hash of the password `hunter2`, you can use the following Python code:

```console
student@linux:~$ python3
Python 3.14.7 (main, Aug 10 2026, 00:00:00) [GCC 16.1.1 20260515 (Red Hat 16.1.1-2)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from passlib.hash import sha512_crypt
>>> sha512_crypt.hash("hunter2")
'$6$rounds=656000$LmK9I4ShcFO6CqiU$N./ZC63aJ05yhHKLEXK7zsDAZdsa0A0xnpjrSENX0DSoV.sVueOlR.ffeaEJWLHk3g0CALxFJ3jhQtA/CDGbX/'
```

The Python `passlib` library supports many other hashing algorithms as well. You can find a list of supported algorithms in the [Passlib documentation](https://passlib.readthedocs.io/en/stable/lib/passlib.hash.html). Unfortunately, the `yescrypt` algorithm is not among them as of yet.

## encryption with crypt

Yet another is to use the C API for the supported cryptographic functions on Linux and to create a custom command. This is certainly not the most practical way to generate password hashes, but it is a nice example on how to use the program libraries that are available on Linux.

We basically need two C functions from the crypt library: `crypt_gensalt()` and `crypt()`. With the first function, we can select the hashing algorithm and generate a random salt. The second function will then combine the salt with the password and compute the hash.

The following C program will take exactly one parameter, the password, and will generate a SHA-512 hash of it with a random salt. The program will print the resulting hash to standard output.

```c
// my-crypt-simple.c
#include <stdio.h>
#include <crypt.h>
#include <string.h>

int main(int argc, char** argv) {

  // Check for the correct number of arguments
  if( argc != 2 ) {
    printf("Usage: %s PASSWORD\n", argv[0]);
    return 1;
  }

  // Generate a random salt for the SHA-512 algorithm ($6$)
  const char *salt = crypt_gensalt("$6$", 0, NULL, 0);

  // Generate the hashed password with the given salt.
  const char *hashed_password = crypt(argv[1], salt);
  printf("Hashed Password: %s\n", hashed_password);

  return 0;
}
```

This little program can be compiled with `gcc` and used like in this example:

```console
student@linux:~$ gcc -o my-crypt-simple my-crypt-simple.c -lcrypt
student@linux:~$ ./my-crypt-simple 
Usage: ./my-crypt-simple PASSWORD
student@linux:~$ ./my-crypt-simple hunter2
Hashed Password: $6$1epC51l.E7OPTijb$EX4jGMsuh5NUR7ZTlyWavml3GdW.rPwSWtWMk4ka7FhiYra.k02s2rRC2iBH1M96h7okMEBc8oY2pj8tm81js1
```

Let's extend the program to allow the user to specify the prefix of the hashing algorithm (e.g. `-y` for yescrypt, `-6` for SHA-512, `-1` for MD5, `-2a` for bcrypt, etc.). The program will then generate the hash using the specified algorithm and a random salt. When the user does not provide the password as a command line argument, the program will prompt for it on standard input. This program is a bit more complex, but most code is necessary for parsing the command line arguments. The real work is still done by the `crypt_gensalt()` and `crypt()` functions!

```c
// my-crypt.c
#include <stdio.h>
#include <crypt.h>
#include <string.h>

// Prints the usage message
void usage(char* cmd) {
  printf("Usage: %s [-TYPE] [PASSWORD]\n", cmd);
  printf("       %s -h (show this help message)\n", cmd);
  printf("\n     -TYPE: The hash type (will result in $TYPE$salt$hash)\n");
  printf("  PASSWORD: The password to hash (if not provided, will be read from stdin)\n");
}

int main(int argc, char** argv) {

  // Check for help flag
  if( argc == 2 && strcmp(argv[1], "-h") == 0 ) {
    usage(argv[0]);
    return 0;
  }

  // Check if the number of arguments is valid
  if( argc > 3 ) {
    printf("Error: Too many arguments provided.\n");
    usage(argv[0]);
    return 1;
  }

  // Check if the type option (any string starting with -) is provided
  // If so, set the variable type to the string after the dash
  const char *type = NULL;
  if( argc >= 2 && argv[1][0] == '-' ) {
    type = argv[1] + 1; // Skip the dash
    argc--; // Decrease argc to account for the type argument
    argv++; // Move the argument pointer to the next argument
  }
  // If no type is provided, default to SHA-512 ($6$)
  if( type == NULL ) {
    type = "6"; // Default to SHA-512
  }

  // Add leading and trailing $ to the type string
  char type_str[10];
  snprintf(type_str, sizeof(type_str), "$%s$", type);

  // Generate a random salt for the specified algorithm
  const char *salt = crypt_gensalt(type_str, 0, NULL, 0);

  // Raise an error if the function call failed.
  if( salt == NULL ) {
    printf("Generating salt failed. Maybe the hash type is not supported.\n");
    return -1;
  }

  // If no password is provided, read it from stdin
  char password[256];
  if( argc < 2 ) {
    printf("Enter password: ");
    if( fgets(password, sizeof(password), stdin) == NULL ) {
      printf("Error reading password from stdin\n");
      return -1;
    }
    // Remove the newline character from the password if present
    password[strcspn(password, "\n")] = 0;
  } else {
    // Use the password provided as an argument
    strcpy(password, argv[1]);
  }

  // Generate the hashed password with the given salt.
  const char *hashed_password = crypt(password, salt);

  printf("%s\n", hashed_password);

  return 0;
}
```

Compile the program with `gcc` and try it out:

```console
student@linux:~$ ./my-crypt -h
Usage: ./my-crypt [-TYPE] [PASSWORD]
       ./my-crypt -h (show this help message)

     -TYPE: The hash type (will result in $TYPE$salt$hash)
  PASSWORD: The password to hash (if not provided, will be read from stdin)
student@linux:~$ ./my-crypt
Enter password: hunter2
$6$iE8hpmBi570i30TN$5cj6.HcnooVgJaO6C1CpyjFbVjS.bb4KVaKN5ijXUkaaITlEQowkRWnSub2vixJAIgjJ4umISTWWvoedSdCB01
student@linux:~$ ./my-crypt hunter2
$6$SraxVmficcwMNSLs$Lys4vYFLN/FkEz2zZaTb5c6dKa2wbG5xSoIiPuPcVOjQehl054SBxjdOFdq7vpJd8RK3uci27J7jisttICacl1
student@linux:~$ ./my-crypt -1 hunter2
$1$LFbkqJWh$ODkMjYJQE/BKcbQOIDZvj.
student@linux:~$ ./my-crypt -5 hunter2
$5$yF.mLf/F1KXqNwIL$/YEmeV9KVw/f6Pl4KAcaKaGOfgxfFgPak1KAAP.i2SA
student@linux:~$ ./my-crypt -2a hunter2
$2a$05$m3Xivefntdodf3MDwieisuuqfZR2qeC3dYHCDwS9NNFseBkBcEkB6
student@linux:~$ ./my-crypt -y hunter2
$y$j9T$DJ8xql9fs0.kI.55aWkPn1$YwpUNvLA7y6xieM5N3WMPXOLqsvNz7o3gu742zd.u/A
```

You can now set the password of a user either with `usermod -p HASHED_PASSWORD USER_NAME`. You could also edit `/etc/shadow` directly, and paste the hash as the second field in the line for that user. Be careful, though, as it is easy to make a mistake when editing this file directly.

## /etc/login.defs

The `/etc/login.defs` file contains some default settings for user passwords like password aging and length settings. You will also find the numerical limits of user and group ids, whether or not a home directory should be created by default, which hashing algorithm to use by default, etc.

The file contains a lot of comments and empty lines, so the following command will filter those out. Let's look at the `login.defs` file of an Enterprise Linux system:

```console
student@el:~$ grep "^[^#$]" /etc/login.defs  | sort
CREATE_HOME     yes
ENCRYPT_METHOD YESCRYPT
GID_MAX                 60000
GID_MIN                  1000
HMAC_CRYPTO_ALGO SHA512
HOME_MODE       0700
MAIL_DIR        /var/spool/mail
PASS_ALWAYS_WARN        yes
PASS_CHANGE_TRIES       5
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   0
PASS_MIN_LEN    8
PASS_WARN_AGE   7
SUB_GID_COUNT               65536
SUB_GID_MAX             600100000
SUB_GID_MIN                524288
SUB_UID_COUNT               65536
SUB_UID_MAX             600100000
SUB_UID_MIN                524288
SYS_GID_MAX               999
SYS_GID_MIN               201
SYS_UID_MAX               999
SYS_UID_MIN               201
UID_MAX                 60000
UID_MIN                  1000
UMASK           022
USERGROUPS_ENAB yes
```

Debian also has this file:

```console
student@debian:~$ grep "^[^#$]" /etc/login.defs | sort
CHFN_RESTRICT           rwh
DEFAULT_HOME    yes
ENCRYPT_METHOD YESCRYPT
ENV_PATH        PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
ENV_SUPATH      PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ERASECHAR       0177
GID_MAX                 60000
GID_MIN                  1000
HOME_MODE       0700
HUSHLOGIN_FILE  .hushlogin
KILLCHAR        025
LOGIN_RETRIES           5
LOGIN_TIMEOUT           60
LOG_OK_LOGINS           no
LOG_UNKFAIL_ENAB        no
MAIL_DIR        /var/mail
NONEXISTENT     /nonexistent
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   0
PASS_WARN_AGE   7
SUB_GID_COUNT               65536
SUB_GID_MAX             600100000
SUB_GID_MIN                100000
SUB_UID_COUNT               65536
SUB_UID_MAX             600100000
SUB_UID_MIN                100000
TTYPERM         0600
UID_MAX                 60000
UID_MIN                  1000
USERGROUPS_ENAB yes
```

Compare both files. Some settings are exactly the same, some have different values, and some are only present in one of the two files. The `ENCRYPT_METHOD` setting is the same on both systems, i.e., `YESCRYPT`.

## chage

The `chage` command can be used to set an expiration date for a user account (`-E`), set a minimum (`-m`) and maximum (`-M`) password age, a password expiration date, and set the number of warning days before the password expiration date. Much of this functionality is also available from the `passwd` command. The `-l` option of chage will list these settings for a user.

```console
student@linux:~$ sudo chage -l paul
Last password change                                    : Mar 27, 2014
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 99999
Number of days of warning before password expires       : 7
```

## disabling a password

When the password field in `/etc/shadow` starts with an exclamation mark or asterisk, then the user cannot log in. Using this feature is often called *locking*, *disabling*, or
*suspending* a user account. You can accomplish this with `usermod`.

The first command in the next screenshot will show the hashed password of `laura` in `/etc/shadow`. The next command disables the password of `laura`, making it impossible for Laura to authenticate using this password. When we check the hashed password again, we can see that the hash is now preceded with an exclamation mark.

```console
student@el:~$ sudo grep laura /etc/shadow
laura:$y$j9T$Pq.GmmULSF/snNm/OEwhe.$pfAIMMl0AEmokcRfTxgEM/xHjQmHurZCsnxVmhn9HP1:20693:0:99999:7:::
student@el:~$ sudo usermod -L laura
student@el:~$ sudo grep laura /etc/shadow
laura:!$y$j9T$Pq.GmmULSF/snNm/OEwhe.$pfAIMMl0AEmokcRfTxgEM/xHjQmHurZCsnxVmhn9HP1:20693:0:99999:7:::
```

The root user (and users with `sudo` rights on `su`) still will be able to `su` into the `laura` account (because the password is not needed here). Also note that `laura` will still be able to login if she has set up passwordless ssh! If you want to completely block anyone from logging in as `laura`, you can additionally set the shell of the user to `/sbin/nologin` or `/bin/false` (or any other non-existent shell).

```console
student@el:~$ su - laura
Password: 
su: Authentication failure
student@el:~$ sudo su - laura
Last failed login: Fri Aug 28 23:26:22 UTC 2026 on pts/0
There was 1 failed login attempt since the last successful login.
```

You can unlock the account again with `usermod -U`.

```console
student@el:~$ sudo usermod -U laura
student@el:~$ sudo grep laura /etc/shadow
laura:$y$j9T$Pq.GmmULSF/snNm/OEwhe.$pfAIMMl0AEmokcRfTxgEM/xHjQmHurZCsnxVmhn9HP1:20693:0:99999:7:::
student@el:~$ su - laura
Password: 
Last login: Fri Aug 28 23:26:34 UTC 2026 on pts/1
```

Watch out for tiny differences in the command line options of `passwd`, `usermod`, and `useradd` on different Linux distributions. Verify the local files when using features like
*disabling*, *suspending*, or *locking* on user accounts and their passwords.

## editing local files

If you still want to manually edit the `/etc/passwd` or `/etc/shadow`, after knowing these commands for password management, then use `vipw` instead of vi(m) directly. The `vipw` tool will do proper locking of the file.

```console
student@el:~$ sudo vipw -h
Usage: vipw [options]

Options:
  -g, --group                   edit group database
  -h, --help                    display this help message and exit
  -p, --passwd                  edit passwd database
  -q, --quiet                   quiet mode
  -R, --root CHROOT_DIR         directory to chroot into
  -s, --shadow                  edit shadow or gshadow database

student@el:~$ sudo vipw /etc/passwd
vipw: the password file is busy (/etc/ptmp present)

student@el:~$ sudo vipw -s
vipw: /etc/shadow is unchanged
```

