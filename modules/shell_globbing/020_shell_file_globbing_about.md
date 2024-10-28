This chapter will explain **file globbing**. Typing `man 7 glob` (on Debian) will tell you that long ago there was a program called `/etc/glob` that would expand *wildcard patterns*. Soon afterward, this became a shell built-in.

A string is a wildcard pattern if it contains `?`, `*` or `[`.  *Globbing* (or dynamic filename generation) is the operation that expands a wildcard pattern into a list of pathnames that match the pattern.

