## solution: multipathing

1\. Find a partner and decide who will be iSCSI Target and who will be
iSCSI Initiator and Multipather. Set up Multipath as we did in the
theory.

    Look in the theory...

2\. Uncomment the big \'defaults\' section in /etc/multipath.conf and
disable friendly names. Verify that multipath can work. You may need to
check the manual for `/lib/dev/scsi_id` and for `multipath.conf`.

    vi multipath.conf

    remove # for the big defaults section
    add # for the very small one with friendly_names active
    add the --replace-whitespace option to scsi_id.

    defaults {
            udev_dir                /dev
            polling_interval        10
            path_selector           "round-robin 0"
            path_grouping_policy    multibus
            getuid_callout          "/lib/udev/scsi_id --whitelisted --replace\
    -whitespace --device=/dev/%n"
            prio                    const
            path_checker            readsector0
            rr_min_io               100
            max_fds                 8192
            rr_weight               priorities
            failback                immediate
            no_path_retry           fail
            user_friendly_names     no
    }

The names now (after service restart) look like:

    root@server2 etc]# multipath -ll
    1IET_00010001 dm-8 Reddy,VBOX HARDDISK
    size=1.0G features='0' hwhandler='0' wp=rw
    `-+- policy='round-robin 0' prio=1 status=active
      |- 17:0:0:1 sdh 8:112 active ready running
      |- 16:0:0:1 sdi 8:128 active ready running
      `- 15:0:0:1 sdn 8:208 active ready running
    1IET_00010003 dm-10 Reddy,VBOX HARDDISK
    size=1.0G features='0' hwhandler='0' wp=rw
    `-+- policy='round-robin 0' prio=1 status=active
      |- 17:0:0:3 sdl 8:176 active ready running
      |- 16:0:0:3 sdm 8:192 active ready running
      `- 15:0:0:3 sdp 8:240 active ready running
    1IET_00010002 dm-9 Reddy,VBOX HARDDISK
    size=1.0G features='0' hwhandler='0' wp=rw
    `-+- policy='round-robin 0' prio=1 status=active
      |- 17:0:0:2 sdj 8:144 active ready running
      |- 16:0:0:2 sdk 8:160 active ready running
      `- 15:0:0:2 sdo 8:224 active ready running

Did you blacklist your own devices ?

     vi multipath.conf
    --> search for blacklist:
    add
            devnode "^sd[a-g]"

