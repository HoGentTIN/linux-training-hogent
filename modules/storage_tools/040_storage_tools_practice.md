## practice: troubleshooting tools

0. It is imperative that you practice these tools `before` trouble
arises. It will help you get familiar with the tools and allow you to
create a base line of normal behaviour for your systems.

1. Read the theory on `fuser` and explore its man page. Use this
command to find files that you open yourself.

2. Read the theory on `lsof` and explore its man page. Use this command
to find files that you open yourself.

3. Boot a live image on an existing computer (virtual or real) and
`chroot` into to it.

4. Start one or more disk intensive jobs and monitor them with `iostat`
and `iotop` (compare to `vmstat`).

