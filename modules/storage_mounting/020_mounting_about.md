Once you\'ve put a file system on a partition, you can
`mount` it. Mounting a file system makes it available for
use, usually as a directory. We say
`mounting a file system` instead of mounting a partition
because we will see later that we can also mount file systems that do
not exists on partitions.

On all `Unix` systems, every file and every directory is part of one big
file tree. To access a file, you need to know the full path starting
from the root directory. When adding a `file system` to your computer,
you need to make it available somewhere in the file tree. The directory
where you make a file system available is called a
`mount point`.
