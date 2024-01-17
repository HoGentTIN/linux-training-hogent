# solution : scheduling

1\. Schedule two jobs with `at`, display the `at queue` and remove a
job.

    root@rhel55 ~# at 9pm today
    at> echo go to bed >> /root/todo.txt  
    at> <EOT>
    job 1 at 2010-11-14 21:00
    root@rhel55 ~# at 17h31 today
    at> echo go to lunch >> /root/todo.txt
    at> <EOT>
    job 2 at 2010-11-14 17:31
    root@rhel55 ~# atq
    2   2010-11-14 17:31 a root
    1   2010-11-14 21:00 a root
    root@rhel55 ~# atrm 1
    root@rhel55 ~# atq
    2   2010-11-14 17:31 a root
    root@rhel55 ~# date
    Sun Nov 14 17:31:01 CET 2010
    root@rhel55 ~# cat /root/todo.txt 
    go to lunch

2\. As normal user, use `crontab -e` to schedule a script to run every
four minutes.

    paul@rhel55 ~$ crontab -e
    no crontab for paul - using an empty one
    crontab: installing new crontab

3\. As root, display the `crontab` file of your normal user.

    root@rhel55 ~# crontab -l -u paul
    */4 * * * * echo `date` >> /home/paul/crontest.txt

4\. As the normal user again, remove your `crontab` file.

    paul@rhel55 ~$ crontab -r
    paul@rhel55 ~$ crontab -l
    no crontab for paul

5\. Take a look at the `cron` files and directories in `/etc` and
understand them. What is the `run-parts` command doing ?

    run-parts runs a script in a directory
