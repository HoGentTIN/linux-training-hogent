# Processing jobs

## sleep &

Any process that is managed by your current shell is called a job. Jobs
can be put in **background** by typing an **ampersand** at the end of
the command line. In this screenshot we put a **sleep 8472** command as
a job in the background.

    paul@debian10:$ sleep 8472 &
    [1] 4601
    paul@debian10:$

## jobs


You can see all your **jobs** with the **jobs** command.

    paul@debian10:$ jobs
    [1]+  Running                 sleep 8472 &
    paul@debian10:$

## Ctrl-z


Another way to put a job in the background is by typing **Ctrl-z** when
a foreground job is running. This will freeze the job in background. The
screenshot starts a process and then shows what happens when pressing
**Ctrl-z**.

    paul@debian10:$ sleep 31337
    ^Z
    [2]+  Stopped                 sleep 31337
    paul@debian10:$

## bg


With the **bg** command you can (re)start a job that is suspended in
background by **Ctrl-z**. Typing **bg %1** refers to job number one, and
**bg %2** refers to job number two, and so on.

    paul@debian10:$ jobs
    [1]-  Running                 sleep 8472 &
    [2]+  Stopped                 sleep 31337
    paul@debian10:$ bg %2
    [2]+ sleep 31337 &
    paul@debian10:$ jobs
    [1]-  Running                 sleep 8472 &
    [2]+  Running                 sleep 31337 &
    paul@debian10:$

Another way to (re)start a job in background is using the **%1 &**
notation. The result is the same as with **bg %1**.

    paul@debian10:$ jobs
    [1]+  Stopped                 sleep 8472
    paul@debian10:$ %1 &
    [1]+ sleep 8472 &
    paul@debian10:$ jobs
    [1]+  Running                 sleep 8472 &
    paul@debian10:$

## jobs -p


You can view the PIDs of the jobs in background with **jobs -p**, but
one may prefer to run **ps -o pid,cmd** to better distinguish the jobs.
Both commands are shown in this screenshot.

    paul@debian10:$ jobs -p
    4601
    4602
    paul@debian10:$ ps -o pid,cmd
      PID CMD
      464 -bash
     4601 sleep 8472
     4602 sleep 31337
     4618 ps -o pid,cmd
    paul@debian10:~$

## fg


Jobs that are running in background can be called to run in foreground
with the **fg** command. So **fg %1** will put job number one in
foreground.

    paul@debian10:$ jobs
    [1]-  Running                 sleep 8472 &
    [2]+  Running                 sleep 31337 &
    paul@debian10:$ fg %2
    sleep 31337

And here also you can just use **%1** to call a job to the foreground.

    paul@debian10:$ jobs
    [1]-  Running                 sleep 8472 &
    [2]+  Running                 sleep 31337 &
    paul@debian10:$ %1
    sleep 8472

## kill


Jobs can be killed by a regular **kill** command followed by the PID.
The shell will tell you the job is **terminated** when you next type
enter.

    paul@debian10:$ ps -o pid,cmd
      PID CMD
      464 -bash
     4601 sleep 8472
     4622 ps -o pid,cmd
    paul@debian10:$ kill 4601
    paul@debian10:$
    [1]+  Terminated              sleep 8472
    paul@debian10:$

The **kill** command will also accept the **job id** as an argument. In
this screenshot we kill job number one with **kill %1**.

    paul@debian10:$ jobs
    [1]-  Running                 sleep 8472 &
    [2]+  Running                 sleep 31337 &
    paul@debian10:$ kill %1
    paul@debian10:$
    [1]-  Terminated              sleep 8472
    paul@debian10:$

## nohup


Jobs that belong to your shell will stop running when you quit the
shell. You can prevent this by using **nohup** to start the job. The
sleep command in the following screenshot will get **init** as a foster
parent when the bash shell exits.

    paul@debian10:$ nohup sleep 9000 &
    [1] 4712
    paul@debian10:$ nohup: ignoring input and appending output to nohup.out

    paul@debian10:$ jobs
    [1]+  Running                 nohup sleep 9000 &
    paul@debian10:$

## disown


You can use **disown** to make sure that a running job is not killed
when exiting the shell. When you **disown** a job, then you can no
longer manage it with **fg** and **bg**, and it will no longer appear in
the **jobs** list.

    paul@debian10:$ sleep 9000 &
    [1] 4723
    paul@debian10:$ jobs
    [1]+  Running                 sleep 9000 &
    paul@debian10:$ disown %1
    paul@debian10:$ jobs
    paul@debian10:~$

## huponexit


There is a shell option called **huponexit** that will enable the
survival of all your jobs when properly exiting the shell (by typing
**exit** or **Ctrl-d**). This option is off by default, the screenshot
below turns it on.

    paul@debian10:$ shopt huponexit
    huponexit       off
    paul@debian10:$ shopt -s huponexit
    paul@debian10:$ shopt huponexit
    huponexit       on
    paul@debian10:$

## Cheat sheet

<table>
<caption>Jobs</caption>
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
<td style="text-align: left;"><p>foo &amp;</p></td>
<td style="text-align: left;"><p>Run the <strong>foo</strong> command in
background.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>jobs</p></td>
<td style="text-align: left;"><p>List all jobs in background.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>jobs -p</p></td>
<td style="text-align: left;"><p>List all jobs in background using their
PID.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>ps -o pid,cmd</p></td>
<td style="text-align: left;"><p>List all processes linked to this shell
(includes background jobs).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Ctrl-z</p></td>
<td style="text-align: left;"><p>Put the foreground process
<strong>suspended</strong> in background.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>bg %42</p></td>
<td style="text-align: left;"><p>Start job number 42 in
background.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>fg %42</p></td>
<td style="text-align: left;"><p>Start (or put) job number 42 in
foreground.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>kill %42</p></td>
<td style="text-align: left;"><p>Kill job number 42.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>disown %42</p></td>
<td style="text-align: left;"><p>Disown job number 42 from this shell
(it will not die with the shell).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>nohup foo &amp;</p></td>
<td style="text-align: left;"><p>Start the <strong>foo</strong> command
in background such that it will not die with the current shell.</p></td>
</tr>
</tbody>
</table>

Jobs

## Practice

1.  Execute **find / &gt;/dev/null 2&gt;&1** and immediately put it
    suspended in background.

2.  Execute **sleep 8472** directly in background.

3.  List you background jobs.

4.  List the PID of each background job.

5.  Put the **sleep** job in foreground.

6.  Send a keyboard interrupt to the **sleep** process.

7.  Start the **find** job in background.

8.  Terminate the find job (if it has not stopped already).

9.  Start a **sleep 9000** process that will not be killed when the
    shell exits.

10. Start a **sleep 9000** process in background. Then decide to not
    have it killed when you exit the shell.

11. Verify whether the **huponexit** shell option is active.

## Solution

1.  Execute **find / &gt;/dev/null 2&gt;&1** and immediately put it
    suspended in background.

        find / >/dev/null 2>&1  # followed by Ctrl-z

2.  Execute **sleep 8472** directly in background.

        sleep 8472 &

3.  List you background jobs.

        jobs
        ps

4.  List the PID of each background job.

        jobs -p
        ps

5.  Put the **sleep** job in foreground.

        fg %2

6.  Send a keyboard interrupt to the **sleep** process.

        Ctrl-c

7.  Start the **find** job in background.

        bg

8.  Terminate the find job (if it has not stopped already).

        kill %1

9.  Start a **sleep 9000** process that will not be killed when the
    shell exits.

        nohup sleep 9000 &

10. Start a **sleep 9000** process in background. Then decide to not
    have it killed when you exit the shell.

        sleep 9000 &
        disown %1

11. Verify whether the **huponexit** shell option is active.

        shopt huponexit
