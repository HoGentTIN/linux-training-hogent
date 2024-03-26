# systemd logging

## About systemd journal


The executable that collects all messages and stores them in a binary
format is **systemd-journald**. The **systemd journal** has the same
functionality as **rsyslog** and may replace it in the future.

    root@debian10:# systemctl status systemd-journald | head -3 | cut -b-84
    * systemd-journald.service - Journal Service
       Loaded: loaded (/lib/systemd/system/systemd-journald.service; static; vendor pres
       Active: active (running) since Thu 2019-09-12 12:37:56 CEST; 6h ago
    root@debian10:# ps fax | grep journald
      240?        Ss     0:00 /lib/systemd/systemd-journald
     1266 pts/0    S+     0:00                      \_ grep journald
    root@debian10:~#

## Reading journals


The command to read the **systemd journal** is **journalctl**. You can
use commands like **grep** after it to filter the log, or you can use
one of the many arguments that **journalctl** supports.

    root@debian10:# journalctl | head -4 | cut -b-84
    -- Logs begin at Thu 2019-09-12 10:43:22 CEST, end at Thu 2019-09-12 10:44:15 CEST.
    Sep 12 10:43:22 debian10 kernel: Linux version 4.19.0-6-amd64 (debian-kernel@lists.d
    Sep 12 10:43:22 debian10 kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-4.19.0-6-amd
    Sep 12 10:43:22 debian10 kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 float
    root@debian10:#

### Boot messages

The **journalctl -b** command will display messages from this boot, and
is identical to **journalctl -b 0** . To see messages from the previous
boot type **journalctl -b 1** and from the boot before that it is
**journalctl -b 2** and so on. By default on Debian the **journalctl**
logs are volatile so unless you set the logs to be persistent you will
be greeted by the same message as this screenshot.

    root@debian10:# journalctl -b -1
    Specifying boot ID or boot offset has no effect, no persistent journal was found.
    root@debian10:#

### Recent messages

You can query the **systemd journal** to display recent messages, like
this screenshot shows.

    root@debian10:# journalctl --since "10 min ago" | cut -b-84
    -- Logs begin at Thu 2019-09-12 11:41:24 CEST, end at Thu 2019-09-12 12:52:51 CEST.
    Sep 12 12:46:40 debian10 dhclient[366]: DHCPREQUEST for 192.168.56.101 on enp0s3 to
    Sep 12 12:46:40 debian10 dhclient[366]: DHCPACK of 192.168.56.101 from 192.168.56.10
    Sep 12 12:46:40 debian10 dhclient[366]: bound to 192.168.56.101 -- renewal in 581 se
    Sep 12 12:52:51 debian10 systemd[1]: Starting Cleanup of Temporary Directories...
    Sep 12 12:52:51 debian10 systemd[1]: systemd-tmpfiles-clean.service: Succeeded.
    Sep 12 12:52:51 debian10 systemd[1]: Started Cleanup of Temporary Directories.
    root@debian10:#

### Messages since a timestamp

You can query the **systemd journal** for all messages since a certain
timestamp, as this screenshot shows.

    root@debian10:# journalctl --since "2019-09-12 19:00:00" | cut -b-84
    -- Logs begin at Thu 2019-09-12 12:37:38 CEST, end at Thu 2019-09-12 19:09:32 CEST.
    Sep 12 19:01:06 debian10 dhclient[366]: DHCPREQUEST for 192.168.56.101 on enp0s3 to
    Sep 12 19:01:06 debian10 dhclient[366]: DHCPACK of 192.168.56.101 from 192.168.56.10
    Sep 12 19:01:06 debian10 dhclient[366]: bound to 192.168.56.101 -- renewal in 506 se
    Sep 12 19:09:32 debian10 dhclient[366]: DHCPREQUEST for 192.168.56.101 on enp0s3 to
    Sep 12 19:09:32 debian10 dhclient[366]: DHCPACK of 192.168.56.101 from 192.168.56.10
    Sep 12 19:09:32 debian10 dhclient[366]: bound to 192.168.56.101 -- renewal in 590 se
    root@debian10:#

### Messages until a timestamp

And you can query messages that appeared before a certain timestamp with
**--until** . The screenshot combines the **--since** and **--until**
arguments.

    root@debian10:# journalctl --since "2019-09-12 19:08:00" --until "2019-09-12 19:12:00" | cut -b-84
    -- Logs begin at Thu 2019-09-12 12:37:38 CEST, end at Thu 2019-09-12 19:09:32 CEST.
    Sep 12 19:09:32 debian10 dhclient[366]: DHCPREQUEST for 192.168.56.101 on enp0s3 to
    Sep 12 19:09:32 debian10 dhclient[366]: DHCPACK of 192.168.56.101 from 192.168.56.10
    Sep 12 19:09:32 debian10 dhclient[366]: bound to 192.168.56.101 -- renewal in 590 se
    root@debian10:#

You can also use **--until "1 hour ago"** or **--since yesterday** .

### Messages concerning a PID

You can query for all messages that concern a certain process by
filtering by PID, as this screenshot shows.

    root@debian10:# journalctl _PID=490
    -- Logs begin at Thu 2019-09-12 11:41:24 CEST, end at Thu 2019-09-12 18:00:52 CEST. --
    Sep 12 12:37:56 debian10 sshd[490]: Server listening on 0.0.0.0 port 22.
    Sep 12 12:37:56 debian10 sshd[490]: Server listening on :: port 22.
    root@debian10:#

### Messages concerning a UID

You can filter messages bu UID (and combine this filter with all the
previous arguments to **journalctl**). In this screenshot 1000 is the
UID of the **paul** user account.

    root@debian10:# journalctl _UID=1000 | tail -2
    Sep 12 12:38:05 debian10 su[746]: (to root) paul on pts/0
    Sep 12 12:38:05 debian10 su[746]: pam_unix(su-l:session): session opened for user root by paul(uid=1000)
    root@debian10:#

You can also get a list of all UIDs that have an entry in the **systemd
journal** using the **-F** option of **journalctl**.

    root@debian10:# journalctl -F _UID
    1000
    0
    101
    root@debian10:#

### Messages concerning a unit

You can filter messages to a **systemd unit**. In this screenshot this
is combined with **-b** to only show messages from this boot concerning
**ssh.service** .

    root@debian10:# journalctl -b -u ssh
    -- Logs begin at Thu 2019-09-12 11:41:24 CEST, end at Thu 2019-09-12 18:00:52 CEST. --
    Sep 12 12:37:56 debian10 systemd[1]: Starting OpenBSD Secure Shell server...
    Sep 12 12:37:56 debian10 sshd[490]: Server listening on 0.0.0.0 port 22.
    Sep 12 12:37:56 debian10 systemd[1]: Started OpenBSD Secure Shell server.
    Sep 12 12:37:56 debian10 sshd[490]: Server listening on :: port 22.
    Sep 12 12:38:01 debian10 sshd[730]: Accepted password for paul from 192.168.56.1 port 419
    Sep 12 12:38:01 debian10 sshd[730]: pam_unix(sshd:session): session opened for user paul
    root@debian10:#

### Messages concerning a binary

There is a quick way now to see all the messages concerning **su** (or
rather **/usr/bin/su**), by giving the executable as an argument to
**journalctl**.

    root@debian10:# journalctl -b /usr/bin/su  | cut -b-84
    -- Logs begin at Thu 2019-09-12 12:37:38 CEST, end at Thu 2019-09-12 19:37:18 CEST.
    Sep 12 12:38:05 debian10 su[746]: (to root) paul on pts/0
    Sep 12 12:38:05 debian10 su[746]: pam_unix(su-l:session): session opened for user ro
    root@debian10:#

## Persistent journal


The **systemd journal** can be made persistent by changing its
configuration file **/etc/systemd/journald.conf** . Uncomment the
**Storage=** and set it to **persistent**. After restarting the service
there will be a **/var/log/journal** directory.

    root@debian10:# vi /etc/systemd/journald.conf
    root@debian10:# grep persistent /etc/systemd/journald.conf
    Storage=persistent
    root@debian10:# systemctl restart systemd-journald
    root@debian10:# ls /var/log/journal/
    0c7ce7595d4f4fcabe9b03cfac39a88c
    root@debian10:~#

## Priority level


The **systemd journal** uses the same priorities as **rsyslog** and
**syslog**, which are defined in RFC 5424.

<table style="width:60%;">
<caption>syslog priorities</caption>
<colgroup>
<col style="width: 6%" />
<col style="width: 53%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Code</p></td>
<td style="text-align: left;"><p>Priority</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>Emergency: system is unusable</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>1</p></td>
<td style="text-align: left;"><p>Alert: action must be taken
immediately</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>2</p></td>
<td style="text-align: left;"><p>Critical: critical conditions</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>3</p></td>
<td style="text-align: left;"><p>Error: error conditions</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>4</p></td>
<td style="text-align: left;"><p>Warning: warning conditions</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>5</p></td>
<td style="text-align: left;"><p>Notice: normal but significant
condition</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>6</p></td>
<td style="text-align: left;"><p>Informational: informational
messages</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>7</p></td>
<td style="text-align: left;"><p>Debug: debug-level messages</p></td>
</tr>
</tbody>
</table>

syslog priorities

### Messages of certain severity

And you can filter by syslog priority (or severity) using the
**journalctl -p** option followed by a priority, or followed by a range
as in this screenshot.

    root@debian10:# journalctl -p err..emerg
    -- Logs begin at Thu 2019-09-12 11:41:24 CEST, end at Thu 2019-09-12 18:00:52 CEST. --
    -- No entries --
    root@debian10:#

## Facilities


The **systemd journal** also uses the same facilities as **rsyslog** and
**syslog**, which are defined in the same section of RFC 5424.

<table style="width:70%;">
<caption>syslog facilities</caption>
<colgroup>
<col style="width: 7%" />
<col style="width: 15%" />
<col style="width: 46%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Code</p></td>
<td style="text-align: left;"><p>keyword</p></td>
<td style="text-align: left;"><p>Facility</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>kern</p></td>
<td style="text-align: left;"><p>kernel messages</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>1</p></td>
<td style="text-align: left;"><p>user</p></td>
<td style="text-align: left;"><p>user-level messages</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>2</p></td>
<td style="text-align: left;"><p>mail</p></td>
<td style="text-align: left;"><p>mail system</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>3</p></td>
<td style="text-align: left;"><p>daemon</p></td>
<td style="text-align: left;"><p>system daemons</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>4</p></td>
<td style="text-align: left;"><p>auth</p></td>
<td style="text-align: left;"><p>security/authorization
messages</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>5</p></td>
<td style="text-align: left;"><p>syslog</p></td>
<td style="text-align: left;"><p>messages generated internally</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>6</p></td>
<td style="text-align: left;"><p>lpr</p></td>
<td style="text-align: left;"><p>line printer subsystem</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>7</p></td>
<td style="text-align: left;"><p>news</p></td>
<td style="text-align: left;"><p>network news subsystem</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>8</p></td>
<td style="text-align: left;"><p>uucp</p></td>
<td style="text-align: left;"><p>UUCP subsystem</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>9</p></td>
<td style="text-align: left;"><p>cron</p></td>
<td style="text-align: left;"><p>clock daemon</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>10</p></td>
<td style="text-align: left;"><p>authpriv</p></td>
<td style="text-align: left;"><p>security/authorization
messages</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>11</p></td>
<td style="text-align: left;"><p>ftp</p></td>
<td style="text-align: left;"><p>FTP daemon</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>12</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>NTP subsystem</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>13</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>log audit</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>14</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>log alert</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>15</p></td>
<td style="text-align: left;"><p>cron</p></td>
<td style="text-align: left;"><p>clock daemon (on other OS)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>16</p></td>
<td style="text-align: left;"><p>local0</p></td>
<td style="text-align: left;"><p>local use 0 (local0)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>17</p></td>
<td style="text-align: left;"><p>local1</p></td>
<td style="text-align: left;"><p>local use 1 (local1)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>18</p></td>
<td style="text-align: left;"><p>local2</p></td>
<td style="text-align: left;"><p>local use 2 (local2)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>19</p></td>
<td style="text-align: left;"><p>local3</p></td>
<td style="text-align: left;"><p>local use 3 (local3)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>20</p></td>
<td style="text-align: left;"><p>local4</p></td>
<td style="text-align: left;"><p>local use 4 (local4)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>21</p></td>
<td style="text-align: left;"><p>local5</p></td>
<td style="text-align: left;"><p>local use 5 (local5)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>22</p></td>
<td style="text-align: left;"><p>local6</p></td>
<td style="text-align: left;"><p>local use 6 (local6)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>23</p></td>
<td style="text-align: left;"><p>local7</p></td>
<td style="text-align: left;"><p>local use 7 (local7)</p></td>
</tr>
</tbody>
</table>

syslog facilities

For example to query log entries concerning the **auth** facility use
**journactl SYSLOG\_FACILITY=4** as in this screenshot.

    root@debian10:# journalctl -b SYSLOG_FACILITY=4 | cut -b-84 | tail -5
    Sep 12 12:37:56 debian10 systemd-logind[387]: Watching system buttons on /dev/input/
    Sep 12 12:37:56 debian10 systemd-logind[387]: Watching system buttons on /dev/input/
    Sep 12 12:38:01 debian10 sshd[730]: Accepted password for paul from 192.168.56.1 por
    Sep 12 12:38:01 debian10 systemd-logind[387]: New session 1 of user paul.
    Sep 12 12:38:05 debian10 su[746]: (to root) paul on pts/0
    root@debian10:#

You can also query syslog for a list of all facilities for which it has
an entry in the **systemd journal** using the **-F** option of the
**journalctl** command.

    root@debian10:# journalctl -F SYSLOG_FACILITY
    4
    3
    10
    9
    root@debian10:#

## Cheat sheet

<table>
<caption>Systemd logging</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>command</p></td>
<td style="text-align: left;"><p>explanation</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>systemd-journald</p></td>
<td style="text-align: left;"><p>This is the <strong>systemd</strong>
logging daemon.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>journalctl</p></td>
<td style="text-align: left;"><p>Systemd tool to read log
files.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>journalctl -b</p></td>
<td style="text-align: left;"><p>Read the <strong>systemd</strong> boot
log.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>journalctl -S "ten min ago"</p></td>
<td style="text-align: left;"><p>Show only recent messages.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>journalctl -S "2020-01-01
19:00:00"</p></td>
<td style="text-align: left;"><p>Show messages since a certain
date-time.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>journalctl -U "2020-01-01
19:00:00"</p></td>
<td style="text-align: left;"><p>Show messages until a certain
date-time.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>journalctl _PID=42</p></td>
<td style="text-align: left;"><p>Show messages related to a
PID.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>journalctl _UID=42</p></td>
<td style="text-align: left;"><p>Show messages related to a
UID.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>journalctl -u foo</p></td>
<td style="text-align: left;"><p>Show messages related to a
<strong>systemd</strong> unit.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>journalctl SYSLOG_FACILITY=4</p></td>
<td style="text-align: left;"><p>Show messages related to a
<strong>syslog</strong> facility.</p></td>
</tr>
</tbody>
</table>

Systemd logging

## Practice

1.  Is the **systemd-journald.service** active?

2.  How many lines are there in the complete journal?

3.  Make the **systemd journal** persistent.

4.  Use **journalctl** to *list boots*.

5.  Display all messages of the last twenty minutes.

6.  Display all messages concerning your UID.

## Solution

1.  Is the **systemd-journald.service** active?

        systemctl status systemd-journald

2.  How many lines are there in the complete journal?

        journalctl | wc -l

3.  Make the **systemd journal** persistent.

        vi /etc/systemd/journald.conf
        Storage=persistent
        systemctl restart systemd-journald

4.  Use **journalctl** to *list boots*.

        journalctl --list-boots

5.  Display all messages of the last twenty minutes.

        journalctl --since "20 min ago"

6.  Display all messages concerning your UID.

        journalctl _UID=1000
