## solution : systemd

In this solution, we are working on a Debian-based system. Try it yourself on some other Linux distribution!

1. Determine on which target you are at the moment

    ```console
    student@debian:~$ systemctl get-default
    graphical.target
    ```

2. List all systemctl units with type of service.

    `systemctl list-unit-files --type=service`

    - Do the same for units with type of socket.

        `systemctl list-unit-files --type=socket`

    - In which man page can you find information about this type of unit?

        `systemd.unit(5)`

    - What does this type of unit do?

        Socket units may be used to implement on-demand starting of services, as well as parallelized starting of services.

    - What other types of units are there?

        - service, socket, target, device, mount, automount, timer, swap, path, slice, scope

3. Check the status of the cron service.

    ```console
    student@debian:~$ systemctl status cron.service 
    ● cron.service - Regular background program processing daemon
        Loaded: loaded (/usr/lib/systemd/system/cron.service; enabled; preset: enabled)
        Active: active (running) since Wed 2026-08-26 18:48:20 UTC; 13min ago
    Invocation: 007dbf61eac5476797f9c1fe6c843d7b
          Docs: man:cron(8)
      Main PID: 918 (cron)
        Tasks: 1 (limit: 3506)
        Memory: 424K (peak: 1.8M)
           CPU: 3ms
        CGroup: /system.slice/cron.service
                └─918 /usr/sbin/cron -f
    ```

4. Disable the cron service

    ```console
    student@debian:~$ sudo systemctl disable cron.service 
    Synchronizing state of cron.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
    Executing: /usr/lib/systemd/systemd-sysv-install disable cron
    Removed '/etc/systemd/system/multi-user.target.wants/cron.service'.
    ```

5. Install apache, and check the status. If necessary, enable and start the service (with a single command). Now install nginx. Check the status of both services right after installation. Try this both on a Debian based and a RedHat based system and observe the difference in behaviour. Can you start both services at the same time? Check the status. Disable and stop Apache, then enable and start nginx, using a minimum of commands.

A complete transcript of this exercise:

```console
student@debian:~$ sudo apt install -y apache2
Installing:                     
  apache2
[ ... output omitted ... ]
Enabling conf serve-cgi-bin.
Enabling site 000-default.
Created symlink '/etc/systemd/system/multi-user.target.wants/apache2.service' → '/usr/lib/systemd/system/apache2.service'.
Created symlink '/etc/systemd/system/multi-user.target.wants/apache-htcacheclean.service' → '/usr/lib/systemd/system/apache-htcacheclean.service'.
Processing triggers for man-db (2.13.1-1) ...
Processing triggers for libc-bin (2.41-12) ...
student@debian:~$ systemctl status apache2.service 
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/apache2.service; enabled; preset: enabled)
     Active: active (running) since Wed 2026-08-26 19:03:52 UTC; 28s ago
 Invocation: abafd65a9fe547a7a5539c483d4bb899
       Docs: https://httpd.apache.org/docs/2.4/
   Main PID: 3166 (apache2)
      Tasks: 55 (limit: 3506)
     Memory: 5.3M (peak: 5.8M)
        CPU: 16ms
     CGroup: /system.slice/apache2.service
             ├─3166 /usr/sbin/apache2 -k start
             ├─3167 /usr/sbin/apache2 -k start
             └─3168 /usr/sbin/apache2 -k start
student@debian:~$ sudo apt install -y nginx
Installing:                     
  nginx

[ ... output omitted ... ]

Created symlink '/etc/systemd/system/multi-user.target.wants/nginx.service' → '/usr/lib/systemd/system/nginx.service'.
Could not execute systemctl:  at /usr/bin/deb-systemd-invoke line 148.
Setting up nginx (1.26.3-3+deb13u7) ...
Not attempting to start NGINX, port 80 is already in use.
Processing triggers for man-db (2.13.1-1) ...
student@debian:~$ systemctl status nginx
× nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Wed 2026-08-26 19:04:40 UTC; 8s ago
 Invocation: ae86af3d71fa42d1841eb55e09fee82e
       Docs: man:nginx(8)
    Process: 3479 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, st>
    Process: 3480 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=1/FA>
   Mem peak: 1.9M
        CPU: 12ms
student@debian:~$ sudo systemctl disable --now apache2.service 
Synchronizing state of apache2.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install disable apache2
Removed '/etc/systemd/system/multi-user.target.wants/apache2.service'.
student@debian:~$ sudo systemctl start nginx
student@debian:~$ systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Wed 2026-08-26 19:05:31 UTC; 4s ago
 Invocation: 9dcd0b316d1442c3b78069d52390761f
       Docs: man:nginx(8)
    Process: 3715 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, st>
    Process: 3717 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SU>
   Main PID: 3718 (nginx)
      Tasks: 3 (limit: 3506)
     Memory: 2.9M (peak: 3.3M)
        CPU: 11ms
     CGroup: /system.slice/nginx.service
             ├─3718 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             ├─3719 "nginx: worker process"
             └─3720 "nginx: worker process"
```

Things to note:

- After installing Apache, the service is immediately started and enabled (which is not the case on EL!)
- After installing Nginx, the service can't be started because Apache is already using port 80. See the output: `Not attempting to start NGINX, port 80 is already in use`. Consequently, the service is now in a failed state.
- In order to start Nginx, we first have to disable and stop Apache. After that, we can start Nginx and the service is now running.


