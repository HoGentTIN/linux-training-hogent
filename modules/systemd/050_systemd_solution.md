## solution : systemd

1.determine on which target you are at the moment

`systemctl get-default` runlevel command should also work, but command
above provides

2.list all systemctl units with type of service

`systemctl -t service`

3.check what is the status of cron service.

`systemctl status cron.service`

4.disable cron service

``

5.1 on RedHat based system, disable networkmanager and enable networking
service.

`systemctl disable NetworkManager systemctl enable networking`

5.2 on Debian based system, disable networkmanager and enable netconf
serice

`systemctl disable NetworkManager systemctl enable netconf`

6.use one command, to eneable and start cron service

`systemctl enable --now cron`

