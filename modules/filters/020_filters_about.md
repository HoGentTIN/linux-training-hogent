Filters are commands that take some text input, perform a very specific operation on it, and then output the result. Usually, you can specify a file as argument to take input from. However, they are also designed to be used with a *pipe* (`|`, see I/O redirection) to perform that task on the standard input. The combination of several filters in a *pipeline* allows you to automate quite complex text processing tasks.

This is the essence of the *Unix philosophy*: small, simple tools that do one thing well, and can be combined to perform more complex tasks. Most of the tools discussed in this chapter are in fact older than Linux and are standardised by the POSIX standard. This means that they are available on all Unix-like systems, like Free/Open/NetBSD and macOS.

This chapter will introduce you to the most common filter commands. Be sure to also read each command's `man` page to learn more about their options and features!

