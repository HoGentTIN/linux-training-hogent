# Abstract {.unnumbered}

This book covers the topics introduced in the course "Computer Systems" for the Bachelor of Applied Computer Science at the HOGENT, Belgium. The course consists partly of a basic introduction to the Linux operating system. This book is not the official handbook of that course, but is targeted at students who need a refresher on the topics covered.

The content is based on the [Linux Training](https://linux-training.be) book series by Paul Cobbaut, with updates and additions written by the HOGENT Linux team.

More information and free .pdf available at <https://hogenttin.github.io/linux-training-hogent/>.

## Conventions used

The contributors to this work have taken great care that the examples with command line interactions are correct and work as expected. However, sometimes the output of a command may differ slightly from the examples in this book. This can be due to differences in the version of the software, the operating system, the environment in which the command is executed, or the specific state of the system at the time of execution.

Some Linux distributions may have commands that behave differently than their counterparts in other distributions. This is especially true for the package management commands.

Command line examples are shown in a monospaced font with a prompt that indicates the user and hostname in the form `user@hostname:current_directory$`. For example:

```console
student@debian:~$ ls
root@linux:~# ls
```

We follow the following conventions:

- Regular user vs root:
    - A regular user prompt is shown as `$`, the user name is generally `student`.
    - A root prompt (with elevated privileges) is shown as `#`.
- The linux distribution is indicated by the host name:
    - If the command should work on any Linux distribution, the hostname is `linux`.
    - If the command is specific to a certain distribution, the hostname is the name of that distribution, e.g. `debian`, `ubuntu`, `rhel`, etc.
    - If you see `el` as the host name (short for Enterprise Linux), you can assume that it was tested on an [Alma Linux](https://almalinux.org) machine and that it should work on any Red Hat-based distribution.
- Commands that are run on a prompt that is not necessarily a Linux system (e.g. you're running Linux in a VM on a Windows host) are shown with a generic `>` prompt, e.g. `> winget install Git.Git`.

## Reporting errors

Did you find an error in this book, or is the output of a command considerably different from what is shown? Please report it by creating an issue on the [linux-training-hogent GitHub repository](https://github.com/HoGentTIN/linux-training-hogent/issues).

