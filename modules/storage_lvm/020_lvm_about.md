Most `lvm` implementations support
`physical storage grouping`, `logical volume resizing` and
`data migration`.

Physical storage grouping is a fancy name for grouping multiple block
devices (hard disks, but also iSCSI etc) into a logical mass storage
device. To enlarge this physical group, block devices (including
partitions) can be added at a later time.

The size of `lvm volumes` on this `physical group` is independent of the
individual size of the components. The total size of the group is the
limit.

One of the nice features of `lvm` is the logical volume resizing. You
can increase the size of an `lvm volume`, sometimes even without any
downtime. Additionally, you can migrate data away from a failing hard
disk device, create mirrors and create snapshots.
