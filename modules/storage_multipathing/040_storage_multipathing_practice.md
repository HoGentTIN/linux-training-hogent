## practice: multipathing

1\. Find a partner and decide who will be iSCSI Target and who will be
iSCSI Initiator and Multipather. Set up Multipath as we did in the
theory.

2\. Uncomment the big \'defaults\' section in /etc/multipath.conf and
disable friendly names. Verify that multipath can work. You may need to
check the manual for `/lib/dev/scsi_id` and for `multipath.conf`.

