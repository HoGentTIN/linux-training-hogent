## basic operation

### selinux modes

SELinux knows three modes: enforcing, permissive and disabled. The
*enforcing* mode will enforce policies, and may deny access based on *SELinux policies*. Any action that is denied is logged. The *permissive* mode will not enforce policies, but still log actions that would have been denied in *enforcing* mode. In the *disabled* mode, SELinux is inactive.

Use the `getenforce` command to see the current mode and `setenforce` (as superuser) to change it.

```console
[student@el ~]$ getenforce 
Permissive
[student@el ~]$ sudo setenforce 1
[student@el ~]$ getenforce 
Enforcing
```

More elaborate information about the current SELinux status can be found with the `sestatus` command.

```console
[student@el ~]$ sudo setenforce 0
[student@el ~]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   permissive
Mode from config file:          permissive
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
[student@el ~]$ sudo setenforce 1
[student@el ~]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          permissive
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

To make the change permanent, edit the `/etc/selinux/config` file and set the `SELINUX` variable to the desired value (which should of course be `enforcing`).

```console
[student@el ~]$ grep '^SELINUX' /etc/selinux/config 
SELINUX=permissive
SELINUXTYPE=targeted
[student@el ~]$ sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config 
[student@el ~]$ grep '^SELINUX' /etc/selinux/config 
SELINUX=enforcing
SELINUXTYPE=targeted
```

After permanently changing the SELinux mode to enforcing, a reboot is highly recommended. SELinux depends on objects being "labeled" correctly. While inactive, labeling is turned off, which may result in SELinux not behaving correctly after it is turned on. On the next boot, SELinux will relabel the entire system.

The `SELINUXTYPE` variable in the `/etc/selinux/config` file specifies the policy type in use and can take the values `targeted` or `mls`. The `targeted` policy is the most common policy type. It protects *targeted* (i.e. specified) processes, but allows some processes and users (e.g. `root`) to run unconfined. In some situations, like highly regulated environments with strict compliance requirements, or where highly sensitive data is managed, this is insuffficient. In these cases, the `mls` (Multi-Level Security) policy can be used. When this policy is applied, unconfined processes are not allowed, which would imply that even `root` can't access every object or perform every action they want.

### logging

When in *enforcing* mode, SELinux will log all denied actions. These logs can be found in `/var/log/audit/audit.log`. The `ausearch` command can be used to search these logs. You need root privileges to read the audit logs.

```console
[student@el ~]$ sudo ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts today
----
time->Fri Oct 11 14:44:22 2024
type=PROCTITLE msg=audit(1728657862.580:608): proctitle=2F7573722F62696E2F7368002F7573722F6C69622F4E6574776F726B4D616E616765722F646973706174636865722E642F32302D6368726F6E792D646863700065746831007570
type=SYSCALL msg=audit(1728657862.580:608): arch=c000003e syscall=257 success=yes exit=3 a0=ffffff9c a1=558e921a2790 a2=0 a3=0 items=0 ppid=620 pid=3395 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="20-chrony-dhcp" exe="/usr/bin/bash" subj=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 key=(null)
type=AVC msg=audit(1728657862.580:608): avc:  denied  { open } for  pid=3395 comm="20-chrony-dhcp" path="/etc/sysconfig/network-scripts/ifcfg-eth1" dev="sda2" ino=612 scontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tcontext=unconfined_u:object_r:user_tmp_t:s0 tclass=file permissive=1
type=AVC msg=audit(1728657862.580:608): avc:  denied  { dac_read_search } for  pid=3395 comm="20-chrony-dhcp" capability=2  scontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tcontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tclass=capability permissive=1
----
time->Fri Oct 11 16:22:01 2024
type=PROCTITLE msg=audit(1728663721.409:30): proctitle=2F7573722F62696E2F7368002F7573722F6C69622F4E6574776F726B4D616E616765722F646973706174636865722E642F32302D6368726F6E792D646863700065746831007570
type=SYSCALL msg=audit(1728663721.409:30): arch=c000003e syscall=257 success=no exit=-13 a0=ffffff9c a1=55e6dfb85790 a2=0 a3=0 items=0 ppid=617 pid=675 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="20-chrony-dhcp" exe="/usr/bin/bash" subj=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 key=(null)
type=AVC msg=audit(1728663721.409:30): avc:  denied  { dac_override } for  pid=675 comm="20-chrony-dhcp" capability=1  scontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tcontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tclass=capability permissive=0
type=AVC msg=audit(1728663721.409:30): avc:  denied  { dac_read_search } for  pid=675 comm="20-chrony-dhcp" capability=2  scontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tcontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tclass=capability permissive=0
----
[...some output omitted...]
```

Or, alternatively, you can search the `/var/log/audit/audit.log` file for the string `denied`:

```console
[student@el ~]$ sudo grep denied /var/log/audit/audit.log
type=AVC msg=audit(1728657862.580:608): avc:  denied  { dac_read_search } for  pid=3395 comm="20-chrony-dhcp" capability=2  scontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tcontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tclass=capability permissive=1
type=AVC msg=audit(1728657862.580:608): avc:  denied  { open } for  pid=3395 comm="20-chrony-dhcp" path="/etc/sysconfig/network-scripts/ifcfg-eth1" dev="sda2" ino=612 scontext=system_u:system_r:NetworkManager_dispatcher_chronyc_t:s0 tcontext=unconfined_u:object_r:user_tmp_t:s0 tclass=file permissive=1
```

### /sys/fs/selinux

When selinux is active, there is a new virtual file system (comparable to `/proc` and `/dev`) mounted at `/sys/fs/selinux`.


```console
[student@el ~]$ mount | grep selinux
selinuxfs on /sys/fs/selinux type selinuxfs (rw,nosuid,noexec,relatime)
[student@el ~]$ ls -l /sys/fs/selinux/
total 0
-rw-rw-rw-.   1 root root    0 Oct 11 16:22 access
dr-xr-xr-x.   2 root root    0 Oct 11 16:22 avc
dr-xr-xr-x.   2 root root    0 Oct 11 16:21 booleans
-rw-r--r--.   1 root root    0 Oct 11 16:22 checkreqprot
dr-xr-xr-x. 137 root root    0 Oct 11 16:21 class
--w-------.   1 root root    0 Oct 11 16:22 commit_pending_bools
-rw-rw-rw-.   1 root root    0 Oct 11 16:22 context
-rw-rw-rw-.   1 root root    0 Oct 11 16:22 create
-r--r--r--.   1 root root    0 Oct 11 16:22 deny_unknown
--w-------.   1 root root    0 Oct 11 16:22 disable
-rw-r--r--.   1 root root    0 Oct 11 16:22 enforce
dr-xr-xr-x.   2 root root    0 Oct 11 16:22 initial_contexts
-rw-------.   1 root root    0 Oct 11 16:22 load
-rw-rw-rw-.   1 root root    0 Oct 11 16:22 member
-r--r--r--.   1 root root    0 Oct 11 16:22 mls
crw-rw-rw-.   1 root root 1, 3 Oct 11 16:22 null
-r--r--r--.   1 root root    0 Oct 11 16:22 policy
dr-xr-xr-x.   2 root root    0 Oct 11 16:22 policy_capabilities
-r--r--r--.   1 root root    0 Oct 11 16:22 policyvers
-r--r--r--.   1 root root    0 Oct 11 16:22 reject_unknown
-rw-rw-rw-.   1 root root    0 Oct 11 16:22 relabel
dr-xr-xr-x.   2 root root    0 Oct 11 16:22 ss
-r--r--r--.   1 root root    0 Oct 11 16:22 status
-rw-rw-rw-.   1 root root    0 Oct 11 16:22 user
--w--w--w-.   1 root root    0 Oct 11 16:22 validatetrans
```

Although some files in `/sys/fs/selinux` appear wih size 0, they often contain a boolean value (or rather, a 0 to denote *false* or 1 to denote *true*). Check `/selinux/enforce` to see if selinux is running in enforced mode.

```console
[student@el ~]$ ls -l /sys/fs/selinux/enforce 
-rw-r--r--. 1 root root 0 Oct 11 16:22 /sys/fs/selinux/enforce
[student@el ~]$ cat !$
cat /sys/fs/selinux/enforce
1
```

## DAC vs MAC

Standard Unix permissions use **Discretionary Access Control** to set permissions on files. This means that a user that owns a file, can make it world readable and writeable by typing `chmod 777 $file`.

With SELinux the kernel will enforce **Mandatory Access Control** which strictly controls what processes or threads can do with files (superseding DAC). Processes are confined by the kernel to the minimum access they require.

SELinux MAC is about labeling and type enforcing! Files, processes, etc are all labeled with an **SELinux context**. For files, these are extended attributes, for processes this is managed by the kernel.

The format of the labels is as follows:

```text
user:role:type:(level)
```

We'll elaborate on these concepts in the following sections, but in short:

- The **user** may be e.g. `root`, `staff_u`, `user_u`, `system_u`, `guest_u`, etc. The policy maps each Linux user to one of these SELinux users.

- The **role** can be e.g. `unconfined_r`, `staff_r`, `user_r`, `system_r`, etc. The policy maps each Linux user to one of these SELinux roles.

- Each SELinux role corresponds to an SELinux **type**, which determines what access rights are given. Possible values are e.g. `unconfined_t`, `staff_t`, `user_t`, etc.

- The **level** is only used in `MLS` (Multi-Level Security) policies, where it denotes the security clearance level from the `s0` level (equivalent to *unclassified*) to `s15` (*top secret*). Users can only access objects at their own level or lower.

### ls -Z

To see the DAC permissions on a file, use `ls -l` to display user and group `owner` and permissions.

For MAC permissions there is a new option added to `ls`:  `-Z` or in the long form `--context`.

When a file is created on the filesystem, it is assigned a label according to some rules. The `ls -Z` command will show the label of the file. For example, if a normal user creates a file in their home directory, it will be labeled with the `user_home_t` type:

```console
[student@el ~]$ touch owned_by_student.txt
[student@el ~]$ ls -lZ
total 0
-rw-r--r--. 1 student student unconfined_u:object_r:user_home_t:s0 0 Oct 11 18:17 owned_by_student.txt
```

When you do the same as the root user in the `/root` directory, the file will be labeled with the `admin_home_t` type:

```console
[student@el ~]$ sudo touch /root/owned_by_root.txt
[student@el ~]$ sudo ls -lZ /root
total 0
-rw-r--r--. 1 root root unconfined_u:object_r:admin_home_t:s0 0 Oct 11 18:16 owned_by_root.txt
```

In `/tmp` the file will be labeled with the `user_tmp_t` type:

```console
[student@el ~]$ touch /tmp/tempfile.txt
[student@el ~]$ ls -lZ /tmp/tempfile.txt 
-rw-r--r--. 1 student student unconfined_u:object_r:user_tmp_t:s0 0 Oct 11 18:20 /tmp/tempfile.txt
```

... and so on! The rules are kept in `/etc/selinux/targeted/contexts/files/`. For example, the rule that determines the label for files in the home directory of a user can be found in `file_contexts.homedirs`:

```text
/home/[^/]+/.+  unconfined_u:object_r:user_home_t:s0
```

So paths that match the regular expression `/home/[^/]+/.+` will be labeled with the `user_home_t` type.

When selinux is not running, you can list SELinux labels by showing extended file attributes with the command `getfattr` (provided by the `attr` package on both Debian and EL systems):

```console
[student@el ~]$ sudo getfattr --dump --match . /root/owned_by_root.txt 
getfattr: Removing leading '/' from absolute path names
# file: root/owned_by_root.txt
security.selinux="unconfined_u:object_r:admin_home_t:s0"

[student@el ~]$ getfattr -d -m . ./owned_by_student.txt 
# file: owned_by_student.txt
security.selinux="unconfined_u:object_r:user_home_t:s0"

[student@el ~]$ getfattr -d -n security.selinux ./owned_by_student.txt 
# file: owned_by_student.txt
security.selinux="unconfined_u:object_r:user_home_t:s0"
```

The option `--dump` or `-d` will show all values selected by the option `--match` or `-m .` (matching pattern `.` which means *all*) or `--name` / `-n` (which selects only the named attribute).

### the -Z option

Other commands have also been extended with the `-Z` (with capital `Z`!) and `--context` option. For example:

- `mkdir -Z`: apply default SELinux context to each created directory
- `cp -Z`, `mv -Z`: set SELinux security context of destination file to default type
- `ps -Z`: show SELinux security context of processes
- `ss -Z`: show SELinux security context of processes (like `-p`, needs superuser privileges)
- ...

### identity

The **SELinux Identity** of a user is distinct from the user ID. An identity is part of a security context, and (via domains) determines what you can do. The screenshot shows user `student` having identity `unconfined_u`.

```console
[student@el ~]$ id -Z
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

### role

The **SELinux role** defines the domains that can be used. A `role` is denied to enter a domain, unless the `role` is explicitely authorized to do so.

To list  the mappings between SELinux identities/users and roles, execute the command `semanage user -l` as root:

```console
[student@el ~]$ sudo semanage user -l
                Labeling   MLS/       MLS/
SELinux User    Prefix     MCS Level  MCS Range       SELinux Roles
guest_u         user       s0         s0              guest_r
root            user       s0         s0-s0:c0.c1023  staff_r sysadm_r system_r unconfined_r
staff_u         user       s0         s0-s0:c0.c1023  staff_r sysadm_r system_r unconfined_r
sysadm_u        user       s0         s0-s0:c0.c1023  sysadm_r
system_u        user       s0         s0-s0:c0.c1023  system_r unconfined_r
unconfined_u    user       s0         s0-s0:c0.c1023  system_r unconfined_r
user_u          user       s0         s0              user_r
xguest_u        user       s0         s0              xguest_r
```

### type (or domain)

An **SELinux type** determines what a process can do. The example below shows the first ten processes running. The process with ID (PID) 1 is `systemd`, running in domain `init_t`. The other processes in the list are running in domain `kernel_t`.

```console
[student@el ~]$ ps -eZ | head
LABEL                          PID TTY      TIME CMD
system_u:system_r:init_t:s0      1 ?    00:00:00 systemd
system_u:system_r:kernel_t:s0    2 ?    00:00:00 kthreadd
system_u:system_r:kernel_t:s0    3 ?    00:00:00 rcu_gp
system_u:system_r:kernel_t:s0    4 ?    00:00:00 rcu_par_gp
system_u:system_r:kernel_t:s0    5 ?    00:00:00 slub_flushwq
system_u:system_r:kernel_t:s0    6 ?    00:00:00 netns
system_u:system_r:kernel_t:s0    8 ?    00:00:00 kworker/0:0H-events_highpri
system_u:system_r:kernel_t:s0   10 ?    00:00:00 mm_percpu_wq
system_u:system_r:kernel_t:s0   12 ?    00:00:00 rcu_tasks_kthre
```

The security context for processes visible in `/proc` defines both the type (of the file in `/proc`) and the domain (of the running process). Let's take a look at the `systemd` process and `/proc/1/`.

The init process runs in domain `init_t`.

```console
[student@el ~]$ ps -Zp 1
LABEL                         PID TTY       TIME CMD
system_u:system_r:init_t:s0     1 ?     00:00:01 systemd
```

The `/proc/1/` directory, which identifies the `init` process, also has type `init_t`. This is not a coincidence!

```console
[student@el ~]$ ls -Zd /proc/1/
system_u:system_r:init_t:s0 /proc/1/
```

The **SELinux type** is similar to an `selinux domain`, but refers to directories and files instead of processes.

Hundreds of binaries also have a type:

```console
[student@el ~]$ ls -lZ /usr/sbin/user* /usr/sbin/sem* /usr/sbin/ip
-rwxr-xr-x. 1 root root system_u:object_r:ifconfig_exec_t:s0 774136 Apr 30 20:24 /usr/sbin/ip
-rwxr-xr-x. 1 root root system_u:object_r:semanage_exec_t:s0  41614 Apr  3  2024 /usr/sbin/semanage
-rwxr-xr-x. 1 root root system_u:object_r:semanage_exec_t:s0  32928 Apr  3  2024 /usr/sbin/semodule
-rwxr-xr-x. 1 root root system_u:object_r:useradd_exec_t:s0  141144 Sep 26  2023 /usr/sbin/useradd
-rwxr-xr-x. 1 root root system_u:object_r:useradd_exec_t:s0   90968 Sep 26  2023 /usr/sbin/userdel
-rwxr-xr-x. 1 root root system_u:object_r:useradd_exec_t:s0  132784 Sep 26  2023 /usr/sbin/usermod
```

Ports also have a context, which can be queried with `ss` with option `-Z`. Just like with `-p`, you need superuser privileges to see the output. You don't need to pipe the output through `cut`, we do it here for brevity.

```console
[student@el ~]$ sudo ss -tlnZ | cut -c28-41,59-
Address:Port Process                                                                                                                               
0.0.0.0:22    users:(("sshd",pid=640,proc_ctx=system_u:system_r:sshd_t:s0-s0:c0.c1023,fd=3))                                                       
0.0.0.0:111   users:(("rpcbind",pid=533,proc_ctx=system_u:system_r:rpcbind_t:s0,fd=4),("systemd",pid=1,proc_ctx=system_u:system_r:init_t:s0,fd=31))
0.0.0.0:3306  users:(("mariadbd",pid=741,proc_ctx=system_u:system_r:mysqld_t:s0,fd=21))                                                            
   [::]:22    users:(("sshd",pid=640,proc_ctx=system_u:system_r:sshd_t:s0-s0:c0.c1023,fd=4))                                                       
   [::]:111   users:(("rpcbind",pid=533,proc_ctx=system_u:system_r:rpcbind_t:s0,fd=6),("systemd",pid=1,proc_ctx=system_u:system_r:init_t:s0,fd=34))
```

You can also get a list of ports that are managed by SELinux. In the example below, we show the ports 22 (SSH), 80 (HTTP), 443 (HTTPS), and 3306 (MySQL/MariaDB). Try it yourself without piping to `grep` to see all ports.

```console
[student@el ~]$ sudo semanage port -l | grep '\b\(22\|80\|443\|3306\)\b'
http_port_t    tcp  80, 81, 443, 488, 8008, 8009, 8443, 9000
mysqld_port_t  tcp  1186, 3306, 63132-63164
ssh_port_t     tcp  22
```

## managing file contexts

### chcon

Use `chcon` to change the selinux security context.

Let's say that you want to share a directory `/var/www/html/fileshare` both through Apache and FTP. Normally, the files in `/var/www/html` are labeled with the `httpd_sys_content_t` type. This type is not allowed to be shared through FTP. You can change the type of the directory and contents to `public_content_t` with the `chcon` command:

```console
[student@el ~]$ cd /var/www/html/
[student@el html]$ sudo mkdir fileshare
[student@el html]$ sudo touch fileshare/README.md
[student@el html]$ ls -ldZ fileshare/
drwxr-xr-x. 2 root root unconfined_u:object_r:httpd_sys_content_t:s0 23 Oct 14 07:43 fileshare/
[student@el html]$ ls -lZ fileshare/
-rw-r--r--. 1 root root unconfined_u:object_r:httpd_sys_content_t:s0 0 Oct 14 07:43 README.md
14 07:43 fileshare/
[student@el html]$ sudo chcon -R -t public_content_t fileshare/
[student@el html]$ ls -ldZ fileshare/
drwxr-xr-x. 2 root root unconfined_u:object_r:public_content_t:s0 23 Oct 14 07:43 fileshare/
[student@el html]$ ls -lZ fileshare/
total 0
-rw-r--r--. 1 root root unconfined_u:object_r:public_content_t:s0 0 Oct 14 07:43 README.md
```

Option `-t` specifies the new context, and `-R` makes the change recursive, i.e. will also change the context of all files and directories in the specified directory.

Be sure to read `man chcon`.

### an example

Let's elaborate on the previous example. The *Apache2 webserver* is by default targeted with *SELinux*. Any file created in `/var/www/html` will by
default get the `httpd_sys_content_t` type, as you could see in that example.

Files created elsewhere do not get this type. Let's say that you created an index page for the website running on this server in the home directory of a user, and then you move it to `/var/www/html`.

```console
[student@el ~]$ vi index.html
[student@el ~]$ sudo mv index.html /var/www/html/
```

If you would try to access the website served by Apache2, you would expect to see the contents of the file. However:

```console
[student@el ~]$ sudo systemctl is-active httpd
active
[student@el ~]$ curl http://localhost/
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>403 Forbidden</title>
</head><body>
<h1>Forbidden</h1>
<p>You don't have permission to access this resource.</p>
</body></html>
[student@el ~]$ ls -l /var/www/html/
total 4
drwxr-xr-x. 2 root    root    23 Oct 14 07:43 fileshare
-rw-r--r--. 1 student student 93 Oct 14 07:48 index.html
```

The index file is world readable, so it *should* be served, but we get the 403 error (permission denied). We can verify that it was in fact SELinux that caused this error by checking the audit log:

```console
[student@el ~]$ sudo grep denied /var/log/audit/audit.log | tail -1
type=AVC msg=audit(1728892181.505:929): avc:  denied  { read } for  pid=7887 comm="httpd" name="index.html" dev="sda2" ino=62351 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=0
```

The `httpd` process is running in context `system_u:system_r:httpd_t:s0`, and it is trying to read a file with context `unconfined_u:object_r:user_home_t:s0`. However, the `httpd_t` context does not have permission to read files with the `user_home_t` context.

The README file created in the previous example does in fact work:

```console
[student@el ~]$ curl http://localhost/fileshare/README.md
# README

Hello world!
```

The reason is that the file has the wrong SELinux context. You can see this with `ls -Z`:

```console
[student@el ~]$ ls -lZ /var/www/html/
total 4
drwxr-xr-x. 2 root    root    unconfined_u:object_r:public_content_t:s0 23 Oct 14 07:43 fileshare
-rw-r--r--. 1 student student unconfined_u:object_r:user_home_t:s0      93 Oct 14 07:48 index.html
```

The file has the `user_home_t` type, but Apache does not have the permission to access files with this context. You can change the type with `chcon`:

```console
[student@el ~]$ sudo chcon -t httpd_sys_content_t /var/www/html/index.html
[student@el ~]$ curl http://localhost/
<html>
<head>
        <title>Hello world</title>
</head>
<body>
        <h1>It works!</h1>
</body>
</html>
```

Now it does work!

### restorecon

Alternatively, you can fix the context of files with `restorecon`:

```console
[student@el ~]$ sudo restorecon -R /var/www/html
[student@el ~]$ ls -lZ /var/www/html
total 4
drwxr-xr-x. 2 root    root    unconfined_u:object_r:httpd_sys_content_t:s0 23 Oct 14 07:54 fileshare
-rw-r--r--. 1 student student unconfined_u:object_r:httpd_sys_content_t:s0 93 Oct 14 07:48 index.html
```

Now the `fileshare/` directory (and its contents) have also again received the `httpd_sys_content_t` context.

### semanage fcontext

If you want to specify the default context for a directory, you can use the `semanage` command. For example, to set the default context for the `/var/www/html/fileshare` directory to `public_content_t`:

```console
[student@el ~]$ sudo semanage fcontext -a -t public_content_t '/var/www/html/fileshare(/.*)?'
[student@el ~]$ sudo restorecon -R /var/www/html/fileshare/
[student@el ~]$ ls -lZ /var/www/html/
total 4
drwxr-xr-x. 2 root    root    unconfined_u:object_r:public_content_t:s0    23 Oct 14 07:54 fileshare
-rw-r--r--. 1 student student unconfined_u:object_r:httpd_sys_content_t:s0 93 Oct 14 07:48 index.html
```

## managing selinux booleans

**SELinux booleans** are on/off switches that can be used to enable or disable certain SELinux policies.

### getsebool

You can list all booleans and their state with the `getsebool -a` command. For example, here are a few booleans related to `httpd`:

```console
[student@el ~]$ getsebool -a | grep httpd | head
httpd_anon_write --> off
httpd_builtin_scripting --> on
httpd_can_check_spam --> off
httpd_can_connect_ftp --> off
httpd_can_connect_ldap --> off
httpd_can_connect_mythtv --> off
httpd_can_connect_zabbix --> off
httpd_can_manage_courier_spool --> off
httpd_can_network_connect --> off
httpd_can_network_connect_cobbler --> off
```

A boolean like `httpd_can_network_connect` determines whether the `httpd` process can initiate a network connection to another host. In most cirumstances, you may expect that a webserver does not need to connect to other hosts, so this boolean is set to `off` by default. If a webserver *does* initiate a connection over the network, this may be an indication that it has been compromised.

To get the value of a single boolean, just specify it as an argument to `getsebool`:

```console
[student@el ~]$ getsebool httpd_can_network_connect_db
httpd_can_network_connect_db --> off
```

### semanage boolean

The `getsebool` command only shows the names and states of the booleans. To get a more detailed description, use the `semanage boolean -l` command (with superuser privileges):

```console
[student@el ~]$ sudo semanage boolean -l | grep httpd | head
awstats_purge_apache_log_files (off  ,  off)  Determine whether awstats can purge httpd log files.
httpd_anon_write               (off  ,  off)  Allow Apache to modify public files used for public file transfer services. Directories/Files must be labeled public_content_rw_t.
httpd_builtin_scripting        (on   ,   on)  Allow httpd to use built in scripting (usually php)
httpd_can_check_spam           (off  ,  off)  Allow http daemon to check spam
httpd_can_connect_ftp          (off  ,  off)  Allow httpd to act as a FTP client connecting to the ftp port and ephemeral ports
httpd_can_connect_ldap         (off  ,  off)  Allow httpd to connect to the ldap port
httpd_can_connect_mythtv       (off  ,  off)  Allow http daemon to connect to mythtv
httpd_can_connect_zabbix       (off  ,  off)  Allow http daemon to connect to zabbix
httpd_can_manage_courier_spool (off  ,  off)  Allow httpd to manage the courier spool sock files.
httpd_can_network_connect      (off  ,  off)  Allow HTTPD scripts and modules to connect to the network using TCP.
```

### setsebool

You can enable or disable booleans with the `setsebool` command:

```console
[student@el ~]$ getsebool httpd_can_network_connect_db
httpd_can_network_connect_db --> off
[student@el ~]$ sudo setsebool httpd_can_network_connect_db on
[student@el ~]$ getsebool httpd_can_network_connect_db
httpd_can_network_connect_db --> on
```

Remark that this is not persistent over reboots. To make the change permanent with the `-P` option:

```console
[student@el ~]$ sudo setsebool -P httpd_can_network_connect_db on
```

To list which SELinux booleans were changed from their default settings, use `semanage boolean --list -C` (or `-l`) with superuser privileges:

```console
[student@el ~]$ sudo semanage boolean --list -C
SELinux boolean                State  Default Description

httpd_can_network_connect_db   (on   ,   on)  Allow HTTPD scripts and modules to connect to databases over the network.
```

## troubleshooting selinux

In this section, we start with a scenario of an Apache web server with an index file with the wrong SELinux context (`user_home_t`), as described above.

```console
[student@el html]$ ls -Z /var/www/html/
unconfined_u:object_r:user_home_t:s0 index.html
```

Accessing the website will result in a 403 error:

```console
[student@el html]$ curl http://localhost/
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>403 Forbidden</title>
</head><body>
<h1>Forbidden</h1>
<p>You don't have permission to access this resource.</p>
</body></html>
```

### the audit log

When SELinux denies access, it logs the event in the **audit log** `/var/log/audit/audit.log`. Looking for the string `denied` in this file is a way to show this.

```console
[student@el html]$ sudo grep denied /var/log/audit/audit.log
type=AVC msg=audit(1728979437.925:830): avc:  denied  { read } for  pid=3726 comm="httpd" name="index.html" dev="sda2" ino=62351 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=0
```

### ausearch

The preferred way to search the audit log for errors is using the `ausearch` command:

```console
[student@el html]$ sudo ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts recent
----
time->Tue Oct 15 08:03:57 2024
type=PROCTITLE msg=audit(1728979437.925:830): proctitle=2F7573722F7362696E2F6874747064002D44464F524547524F554E44
type=SYSCALL msg=audit(1728979437.925:830): arch=c000003e syscall=257 success=no exit=-13 a0=ffffff9c a1=7f7b04041498 a2=80000 a3=0 items=0 ppid=3724 pid=3726 auid=4294967295 uid=48 gid=48 euid=48 suid=48 fsuid=48 egid=48 sgid=48 fsgid=48 tty=(none) ses=4294967295 comm="httpd" exe="/usr/sbin/httpd" subj=system_u:system_r:httpd_t:s0 key=(null)
type=AVC msg=audit(1728979437.925:830): avc:  denied  { read } for  pid=3726 comm="httpd" name="index.html" dev="sda2" ino=62351 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=0
```

The output is more verbose, you can select the type of messages you want to see with the `-m` option and the timestamp with `-ts`. The latter option allows you to specify descriptive time ranges like `recent`, `yesterday`, `today`, etc.

### setroubleshootd

Finding out what SELinux denies is one thing, solving another. To help system administrators, `setroubleshoot` was created. This package contains a daemon (`setroubleshootd`) that listens for SELinux denials and, them in a more human-readable format and offers suggestions on how to fix them.

```console
[student@el html]$ dnf list available 'setroubleshoot*'
Last metadata expiration check: 0:00:09 ago on Tue 15 Oct 2024 08:14:37 AM UTC.
Available Packages
setroubleshoot.x86_64                  3.3.32-1.el9           appstream
setroubleshoot-plugins.noarch          3.3.14-4.el9           appstream
setroubleshoot-server.x86_64           3.3.32-1.el9           appstream
[student@el html]$ sudo dnf install -y setroubleshoot
[... output omitted ...]
Complete!
```

We restart the machine and try to access the website again. At this time, it will fail again with the same message. You can now use `journalctl` to look for `setroubleshoot` log messages:

```console
[student@el ~]$ sudo journalctl -t setroubleshoot
[... some output omitted ...]
Oct 15 08:20:33 el setroubleshoot[6355]: SELinux is preventing /usr/sbin/httpd from read access on the file index.html. For complete SELinux messages run: sealert -l ad1f25d6-6473-4af5-945a-2246b64eecf5
Oct 15 08:20:33 el setroubleshoot[6355]: SELinux is preventing /usr/sbin/httpd from read access on the file index.html.
                                         
            *****  Plugin catchall_boolean (89.3 confidence) suggests   ******************
            
            If you want to allow httpd to read user content
            Then you must tell SELinux about this by enabling the 'httpd_read_user_content' boolean.
            
            Do
            setsebool -P httpd_read_user_content 1
            
            *****  Plugin catchall (11.6 confidence) suggests   **************************
            
            If you believe that httpd should be allowed read access on the index.html file by default.
            Then you should report this as a bug.
            You can generate a local policy module to allow this access.
            Do
            allow this access for now by executing:
            # ausearch -c 'httpd' --raw | audit2allow -M my-httpd
            # semodule -X 300 -i my-httpd.pp
```

The log message already gives a lot of information and a suggestion on how to fix te problem. It also shows how to use `sealert` to get detailed information about the denial:

```console
[student@el ~]$ sealert -l ad1f25d6-6473-4af5-945a-2246b64eecf5
SELinux is preventing /usr/sbin/httpd from read access on the file index.html.

*****  Plugin catchall_boolean (89.3 confidence) suggests   ******************

If you want to allow httpd to read user content
Then you must tell SELinux about this by enabling the 'httpd_read_user_content' boolean.

Do
setsebool -P httpd_read_user_content 1

*****  Plugin catchall (11.6 confidence) suggests   **************************

If you believe that httpd should be allowed read access on the index.html file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'httpd' --raw | audit2allow -M my-httpd
# semodule -X 300 -i my-httpd.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                unconfined_u:object_r:user_home_t:s0
Target Objects                index.html [ file ]
Source                        httpd
Source Path                   /usr/sbin/httpd
Port                          <Unknown>
Host                          el
Source RPM Packages           httpd-core-2.4.57-11.el9_4.1.x86_64
Target RPM Packages           
SELinux Policy RPM            selinux-policy-targeted-38.1.35-2.el9_4.2.noarch
Local Policy RPM              selinux-policy-targeted-38.1.35-2.el9_4.2.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     el
Platform                      Linux el 5.14.0-427.26.1.el9_4.x86_64 #1 SMP
                              PREEMPT_DYNAMIC Wed Jul 17 15:51:13 EDT 2024
                              x86_64 x86_64
Alert Count                   1
First Seen                    2024-10-15 08:20:32 UTC
Last Seen                     2024-10-15 08:20:32 UTC
Local ID                      ad1f25d6-6473-4af5-945a-2246b64eecf5

Raw Audit Messages
type=AVC msg=audit(1728980432.972:544): avc:  denied  { read } for  pid=833 comm="httpd" name="index.html" dev="sda2" ino=62351 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=0


type=SYSCALL msg=audit(1728980432.972:544): arch=x86_64 syscall=openat success=no exit=EACCES a0=ffffff9c a1=7f75ac041498 a2=80000 a3=0 items=0 ppid=733 pid=833 auid=4294967295 uid=48 gid=48 euid=48 suid=48 fsuid=48 egid=48 sgid=48 fsgid=48 tty=(none) ses=4294967295 comm=httpd exe=/usr/sbin/httpd subj=system_u:system_r:httpd_t:s0 key=(null)

Hash: httpd,httpd_t,user_home_t,file,read
```

The output gives two suggestions on how to fix the problem:

- Allow `httpd` to read user content by enabling the `httpd_read_user_content` boolean.
- Generate a local policy module to allow this access.

Remark that in this case, it would be better to fix the file context of `index.html`, and this is not part of the suggestions! But for the sake of the exercise, let's enable the boolean:

```console
[student@el ~]$ sudo setsebool httpd_read_user_content on
[student@el ~]$ curl http://localhost/
<html>
<head>
        <title>Hello world</title>
</head>
<body>
        <h1>It works!</h1>
</body>
</html>
```

It works!

## creating a local selinux policy

Let's say that for a lab setup, we want to rebind Apache's server port to 8000 instead of the default 80. We change the configuration in `/etc/httpd/conf/httpd.conf` to:

```text
Listen 8000
```

and then check the config file syntax and restart the Apache service:

```console
[student@el ~]$ apachectl configtest
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Syntax OK
[student@el ~]$ sudo systemctl restart httpd
Job for httpd.service failed because the control process exited with error code.
See "systemctl status httpd.service" and "journalctl -xeu httpd.service" for details.
```

This fails, apparently, even though the syntax is OK. The error message is not very helpful, but the `journalctl` output is:

```console
[student@el ~]$ journalctl -u httpd.service 
Oct 15 08:17:31 el systemd[1]: Starting The Apache HTTP Server...
Oct 15 08:17:31 el httpd[733]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Oct 15 08:17:31 el httpd[733]: Server configured, listening on: port 80
Oct 15 08:17:31 el systemd[1]: Started The Apache HTTP Server.
Oct 15 08:44:12 el systemd[1]: Stopping The Apache HTTP Server...
Oct 15 08:44:13 el systemd[1]: httpd.service: Deactivated successfully.
Oct 15 08:44:13 el systemd[1]: Stopped The Apache HTTP Server.
Oct 15 08:44:13 el systemd[1]: httpd.service: Consumed 1.513s CPU time.
Oct 15 08:44:13 el systemd[1]: Starting The Apache HTTP Server...
Oct 15 08:44:13 el httpd[6504]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Oct 15 08:44:13 el httpd[6504]: (13)Permission denied: AH00072: make_sock: could not bind to address [::]:8000
Oct 15 08:44:13 el httpd[6504]: (13)Permission denied: AH00072: make_sock: could not bind to address 0.0.0.0:8000
Oct 15 08:44:13 el httpd[6504]: no listening sockets available, shutting down
Oct 15 08:44:13 el httpd[6504]: AH00015: Unable to open logs
Oct 15 08:44:13 el systemd[1]: httpd.service: Main process exited, code=exited, status=1/FAILURE
Oct 15 08:44:13 el systemd[1]: httpd.service: Failed with result 'exit-code'.
Oct 15 08:44:13 el systemd[1]: Failed to start The Apache HTTP Server.
```

The key message here is `(13)Permission denied: AH00072: make_sock: could not bind to address [::]:8000`. So, `httpd` is not allowed to open a server socket on port 8000. If it was another process already listening on this socket, the error message would include a phrasing like `Address already in use`.

These kinds of *permission denied* errors without an apparent other cause, can often be attributed to SELinux. Let's check:

```console
[student@el ~]$ sudo journalctl -t setroubleshoot
[... some output omitted ...]
Oct 15 08:44:14 el setroubleshoot[6506]: SELinux is preventing /usr/sbin/httpd from name_bind access on the tcp_socket port 8000. For complete SELinux messages run: sealert -l 8ea00061-30d7-4fd5-b2fe-601a94348aea
Oct 15 08:44:14 el setroubleshoot[6506]: SELinux is preventing /usr/sbin/httpd from name_bind access on the tcp_socket port 8000.

        *****  Plugin catchall (100. confidence) suggests   **************************
        
        If you believe that httpd should be allowed name_bind access on the port 8000 tcp_socket by default.
        Then you should report this as a bug.
        You can generate a local policy module to allow this access.
        Do
        allow this access for now by executing:
        # ausearch -c 'httpd' --raw | audit2allow -M my-httpd
        # semodule -X 300 -i my-httpd.pp

Oct 15 08:44:14 el setroubleshoot[6506]: SELinux is preventing /usr/sbin/httpd from name_bind access on the tcp_socket port 8000. For complete SELinux messages run: sealert -l 8ea00061-30d7-4fd5-b2fe-601a94348aea
Oct 15 08:44:14 el setroubleshoot[6506]: SELinux is preventing /usr/sbin/httpd from name_bind access on the tcp_socket port 8000.
        *****  Plugin catchall (100. confidence) suggests   **************************
        
        If you believe that httpd should be allowed name_bind access on the port 8000 tcp_socket by default.
        Then you should report this as a bug.
        You can generate a local policy module to allow this access.
        Do
        allow this access for now by executing:
        # ausearch -c 'httpd' --raw | audit2allow -M my-httpd
        # semodule -X 300 -i my-httpd.pp
```

Indeed, it is an *SELinux* issue. Services are not allowed to open a socket on any port. We can check this with `semanage port -l`:

```console
[student@el ~]$ sudo semanage port -l | grep http
http_cache_port_t       tcp    8080, 8118, 8123, 10001-10010
http_cache_port_t       udp    3130
http_port_t             tcp    80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t     tcp    5988
pegasus_https_port_t    tcp    5989
```

The line starting with `http_port_t` specifies which ports are allowed, and 8000 is not one of them.

The output of `setroubleshoot` suggests that we can create a policy module to allow this access using `audit2allow`. The `audit2allow` command takes the output of `ausearch` as input and converts it into code to define a policy module.

```console
[student@el ~]$ sudo ausearch -c 'httpd' --raw
[... some output omitted ...]
type=AVC msg=audit(1728981853.503:590): avc:  denied  { name_bind } for  pid=6504 comm="httpd" src=8000 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:soundd_port_t:s0 tclass=tcp_socket permissive=0
type=SYSCALL msg=audit(1728981853.503:590): arch=c000003e syscall=49 success=no exit=-13 a0=3 a1=556baceb2378 a2=10 a3=7ffda1498eec items=0 ppid=1 pid=6504 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="httpd" exe="/usr/sbin/httpd" subj=system_u:system_r:httpd_t:s0 key=(null)ARCH=x86_64 SYSCALL=bind AUID="unset" UID="root" GID="root" EUID="root" SUID="root" FSUID="root" EGID="root" SGID="root" FSGID="root"
type=PROCTITLE msg=audit(1728981853.503:590): proctitle=2F7573722F7362696E2F6874747064002D44464F524547524F554E44
```

Let's pipe this to `audit2allow` (and specify a name for the module with the `-M` option):

```console
[student@el ~]$ sudo ausearch -c 'httpd' --raw | audit2allow -M my-httpd
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i my-httpd.pp

```

This has created two files in the current directory:

```console
[student@el ~]$ ls -l
total 8
-rw-r--r--. 1 student student 1209 Oct 15 09:02 my-httpd.pp
-rw-r--r--. 1 student student  312 Oct 15 09:02 my-httpd.te
[student@el ~]$ file my-httpd.*
my-httpd.pp: SE Linux modular policy version 1, 1 sections, mod version 21, MLS, module name my-httpd\003
my-httpd.te: ASCII text
```

- `my-httpd.pp` is the compiled policy module in a binary format
- `my-httpd.te` is the source code of the policy module

```console
[student@el ~]$ cat my-httpd.te 

module my-httpd 1.0;

require {
        type httpd_t;
        type user_home_t;
        type soundd_port_t;
        class file read;
        class tcp_socket name_bind;
}

#============= httpd_t ==============
allow httpd_t soundd_port_t:tcp_socket name_bind;

#!!!! This avc is allowed in the current policy
allow httpd_t user_home_t:file read;
```

Remark that this policy module also contains solutions for the other problems we encountered earlier in this chapter, i.e. the `user_home_t` context of `index.html`. The comment on the second to last line even warns us that this is already allowed in the current policy.

Also remark that port 8000 is not mentioned literally. For SELinux, this is the standard port for the `soundd` service:

```console
[student@el ~]$ sudo semanage port -l | grep 8000
soundd_port_t                  tcp      8000, 9433, 16001
```

Let's remove all unnecessary lines:

```console
[student@el ~]$ cat my-httpd.te

module my-httpd 1.0;

require {
        type httpd_t;
        type soundd_port_t;
        class tcp_socket name_bind;
}

#============= httpd_t ==============
allow httpd_t soundd_port_t:tcp_socket name_bind;
```

We now need to recompile the policy module. This in fact is a two-step process. First, we need to convert the source code to a binary format with `checkmodule`, and then we need to package it with `semodule_package`:

```console
[student@el ~]$ checkmodule -M -m -o my-httpd.mod my-httpd.te
[student@el ~]$ semodule_package -o my-httpd.pp -m my-httpd.mod
```

Finally, we can install the policy module with `semodule`:

```console
[student@el ~]$ sudo semodule -i my-httpd.pp
```

And now, `httpd` should be able to bind to port 8000:

```console
[student@el ~]$ sudo systemctl start httpd
[student@el ~]$ sudo ss -tlnp
State  Recv-Q Send-Q Local Address:Port Peer Address:Port Process                                                   
LISTEN 0      80           0.0.0.0:3306      0.0.0.0:*     users:(("mariadbd",pid=753,fd=21))                       
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*     users:(("sshd",pid=639,fd=3))                            
LISTEN 0      4096         0.0.0.0:111       0.0.0.0:*     users:(("rpcbind",pid=532,fd=4),("systemd",pid=1,fd=31)) 
LISTEN 0      128             [::]:22           [::]:*     users:(("sshd",pid=639,fd=4))                            
LISTEN 0      4096            [::]:111          [::]:*     users:(("rpcbind",pid=532,fd=6),("systemd",pid=1,fd=34)) 
LISTEN 0      511                *:8000            *:*     users:(("httpd",pid=6734,fd=4),("httpd",pid=6733,fd=4),("httpd",pid=6732,fd=4),("httpd",pid=6730,fd=4))
[student@el ~]$ curl http://localhost:8000/
<html>
<head>
        <title>Hello world</title>
</head>
<body>
        <h1>It works!</h1>
</body>
</html>
```

It works!


