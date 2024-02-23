## one time jobs with at

### at

Simple scheduling can be done with the `at` command. This
screenshot shows the scheduling of the date command at 22:01 and the
sleep command at 22:03.

    root@linux:~# at 22:01
    at> date
    at> <EOT>
    job 1 at Wed Aug  1 22:01:00 2007
    root@linux:~# at 22:03
    at> sleep 10
    at> <EOT>
    job 2 at Wed Aug  1 22:03:00 2007
    root@linux:~#

*In real life you will hopefully be scheduling more useful commands ;-)*

### atq

It is easy to check when jobs are scheduled with the `atq`
or `at -l` commands.

    root@linux:~# atq
    1       Wed Aug  1 22:01:00 2007 a root
    2       Wed Aug  1 22:03:00 2007 a root
    root@linux:~# at -l
    1       Wed Aug  1 22:01:00 2007 a root
    2       Wed Aug  1 22:03:00 2007 a root
    root@linux:~#

The at command understands English words like tomorrow and teatime to
schedule commands the next day and at four in the afternoon.

    root@linux:~# at 10:05 tomorrow
    at> sleep 100
    at> <EOT>
    job 5 at Thu Aug  2 10:05:00 2007
    root@linux:~# at teatime tomorrow
    at> tea
    at> <EOT>
    job 6 at Thu Aug  2 16:00:00 2007
    root@linux:~# atq
    6       Thu Aug  2 16:00:00 2007 a root
    5       Thu Aug  2 10:05:00 2007 a root
    root@linux:~#

### atrm

Jobs in the at queue can be removed with `atrm`.

    root@linux:~# atq
    6       Thu Aug  2 16:00:00 2007 a root
    5       Thu Aug  2 10:05:00 2007 a root
    root@linux:~# atrm 5
    root@linux:~# atq
    6       Thu Aug  2 16:00:00 2007 a root
    root@linux:~#

### at.allow and at.deny

You can also use the `/etc/at.allow` and
`/etc/at.deny` files to manage who can schedule jobs with
at.

The `/etc/at.allow` file can contain a list of users that are allowed to
schedule `at` jobs. When `/etc/at.allow` does not exist, then everyone
can use `at` unless their username is listed in `/etc/at.deny`.

If none of these files exist, then everyone can use `at`.

## cron

### crontab file

The `crontab(1)` command can be used to maintain the
`crontab(5)` file. Each user can have their own crontab
file to schedule jobs at a specific time. This time can be specified
with five fields in this order: minute, hour, day of the month, month
and day of the week. If a field contains an asterisk (\*), then this
means all values of that field.

The following example means : run script42 eight minutes after two,
every day of the month, every month and every day of the week.

    8 14 * * * script42

Run script8472 every month on the first of the month at 25 past
midnight.

    25 0 1 * * script8472

Run this script33 every two minutes on Sunday (both 0 and 7 refer to
Sunday).

    */2 * * * 0

Instead of these five fields, you can also type one of these: \@reboot,
\@yearly or \@annually, \@monthly, \@weekly, \@daily or \@midnight, and
\@hourly.

### crontab command

Users should not edit the crontab file directly, instead they should
type `crontab -e` which will use the editor defined in the EDITOR or
VISUAL environment variable. Users can display their cron table with
`crontab -l`.

### cron.allow and cron.deny

The `cron daemon` `crond` is reading the cron tables, taking into
account the `/etc/cron.allow` and
`/etc/cron.deny` files.

These files work in the same way as `at.allow` and `at.deny`. When the
`cron.allow` file exists, then your username has to be in it, otherwise
you cannot use `cron`. When the `cron.allow` file does not exists, then
your username cannot be in the `cron.deny` file if you want to use
`cron`.

### /etc/crontab

The `/etc/crontab` file contains entries for when to run
hourly/daily/weekly/monthly tasks. It will look similar to this output.

    SHELL=/bin/sh
    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

    20 3 * * *        root    run-parts --report /etc/cron.daily
    40 3 * * 7        root    run-parts --report /etc/cron.weekly
    55 3 1 * *        root    run-parts --report /etc/cron.monthly

### /etc/cron.\*

The directories shown in the next screenshot contain the tasks that are
run at the times scheduled in `/etc/crontab`. The
`/etc/cron.d` directory is for special cases, to schedule
jobs that require finer control than hourly/daily/weekly/monthly.

    student@linux:~$ ls -ld /etc/cron.*
    drwxr-xr-x 2 root root 4096 2008-04-11 09:14 /etc/cron.d
    drwxr-xr-x 2 root root 4096 2008-04-19 15:04 /etc/cron.daily
    drwxr-xr-x 2 root root 4096 2008-04-11 09:14 /etc/cron.hourly
    drwxr-xr-x 2 root root 4096 2008-04-11 09:14 /etc/cron.monthly
    drwxr-xr-x 2 root root 4096 2008-04-11 09:14 /etc/cron.weekly

### /etc/cron.\*

Note that Red Hat uses `anacron` to schedule daily, weekly and monthly
cron jobs.

    root@linux:/etc# cat anacrontab
    # /etc/anacrontab: configuration file for anacron

    # See anacron(8) and anacrontab(5) for details.

    SHELL=/bin/sh
    PATH=/sbin:/bin:/usr/sbin:/usr/bin
    MAILTO=root
    # the maximal random delay added to the base delay of the jobs
    RANDOM_DELAY=45
    # the jobs will be started during the following hours only
    START_HOURS_RANGE=3-22

    #period in days   delay in minutes   job-identifier   command
    1       5       cron.daily              nice run-parts /etc/cron.daily
    7       25      cron.weekly             nice run-parts /etc/cron.weekly
    @monthly 45     cron.monthly            nice run-parts /etc/cron.monthly
    root@linux:/etc#

