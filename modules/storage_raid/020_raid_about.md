
Setting up a Redundant Array of Independent (originally Inexpensive) Disks or **RAID** usually has two main goals:

- **Redundancy**: if a physical disk fails, no data is lost
- **Performance**: data can be read from and written to the RAID array in speeds that are higher than individual disks by using multiple disks at the same time

Depending on the configuration or RAID level, you can have either of them, or a combination of both.

RAID can be set up using hardware or software. Hardware RAID is more expensive, is usually either included in server systems for enterprises, or can be purchased as a PCI card. Theoretically, it offers better performance because disk operations are performed by a dedicated controller. Software RAID is provided by the operating system and therefore cheaper, but it uses your CPU and your memory. Software RAID is generally easier to manage, since hardware RAID is vendor-specific.

Where ten years ago nobody was arguing about the best choice being hardware RAID, this has changed since technologies like `mdadm`, LVM and even next-gen filesystems like ZFS or BtrFS focus more on managability. The workload on the cpu for software RAID used to be high, but cpu's have gotten a lot faster.

Be aware that a RAID array is not a substitute for a backup strategy, nor for a disaster recovery plan!

