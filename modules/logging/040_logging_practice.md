## practice : logging

1\. Display the /var/run/utmp file with the proper command (not with cat
or vi).

2\. Display the /var/log/wtmp file.

3\. Use the lastlog and lastb commands, understand the difference.

4\. Examine syslog to find the location of the log file containing ssh
failed logins.

5\. Configure syslog to put local4.error and above messages in
/var/log/l4e.log and local4.info only .info in /var/log/l4i.log. Test
that it works with the logger tool!

6\. Configure /var/log/Mysu.log, all the su to root messages should go
in that log. Test that it works!

7\. Send the local5 messages to the syslog server of your neighbour.
Test that it works.

8\. Write a script that executes logger to local4 every 15 seconds
(different message). Use tail -f and watch on your local4 log files.

