# practice : process priorities

1\. Create a new directory and create six `pipes` in that directory.

2\. Bounce a character between two `pipes`.

3\. Use `top` and `ps` to display information (pid, ppid, priority, nice
value, \...) about these two cat processes.

4\. Bounce another character between two other pipes, but this time
start the commands `nice`. Verify that all `cat` processes are battling
for the cpu. (Feel free to fire up two more cats with the remaining
pipes).

5\. Use `ps` to verify that the two new `cat` processes have a `nice`
value. Use the -o and -C options of `ps` for this.

6\. Use `renice` te increase the nice value from 10 to 15. Notice the
difference with the usual commands.
