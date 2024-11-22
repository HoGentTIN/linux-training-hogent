## practice: raid

Create your own VM with *four* extra virtual disks of *8GB* each. If you use the Vagrant environment from the theory section, you can copy the entry for the `raidsrv` machine in `vagrant-hosts.yml`, give it a different name (e.g. `raidlab`) and change the size of the extra disks. In the `provisioning/` directory, copy `raidsrv.sh` to `raidlab.sh`. Then run `vagrant up raidlab` to create the new VM.

1. Boot the VM and log in, verify that the disks are present.

2. Create *raid* partitions on each of the four disks that take up the whole disk. Verify the result.

3. Create a software *raid 5* array with three active disks and one spare (find in the man page how to do this). Verify that the *raid* array exists. How much space is available on the array?

4. Format the *raid 5* array with a filesystem of your choice and mount it (e.g. under `/srv/` or `/mnt/`). Add to `/etc/fstab` to make the mount persistent.

5. Create a big file on the new filesystem, for example by downloading an ISO image from the internet, or with `dd` (filled with zeroes or with random data). Calculate a checksum of the file.

6. Halt the VM and remove one of the active disks by commenting out the corresponding lines in `vagrant-hosts.yml`. Boot the VM and verify that the `raid 5` array is still present and that the filesystem is mounted. Observe how the spare disk is used to rebuild the array. After the rebuild is complete, verify that the file you created is still there and has the same checksum.

7. Halt the VM again and remove another disk. Will the array (and the data) survive? How many disks can you remove before the array is no longer operational?

(Optional) Do the same exercise with a `raid 1`, `raid 0` or `raid 10` array.

