## buses

### about buses

Hardware components communicate with the
`Central Processing Unit` or `cpu` over a
`bus`. The most common buses today are
`usb`, `pci`, `agp`,
`pci-express` and `pcmcia` aka
`pc-card`. These are all `Plag and Play` buses.

Older `x86` computers often had `isa` buses, which can be
configured using `jumpers` or `dip switches`.

### /proc/bus

To list the buses recognised by the Linux kernel on your computer, look
at the contents of the `/proc/bus/` directory (screenshot
from Ubuntu 7.04 and RHEL4u4 below).

    root@linux:~# ls /proc/bus/
    input  pccard  pci  usb
            

    [root@linux ~]# ls /proc/bus/
    input  pci  usb
            

Can you guess which of these two screenshots was taken on a laptop ?

### /usr/sbin/lsusb

To list all the usb devices connected to your system, you could read the
contents of `/proc/bus/usb/devices` (if it exists) or you
could use the more readable output of `lsusb`, which is
executed here on a SPARC system with Ubuntu.

    root@shaka:~# lsusb
    Bus 001 Device 002: ID 0430:0100 Sun Microsystems, Inc. 3-button Mouse
    Bus 001 Device 003: ID 0430:0005 Sun Microsystems, Inc. Type 6 Keyboard
    Bus 001 Device 001: ID 04b0:0136 Nikon Corp. Coolpix 7900 (storage)
    root@shaka:~#   
            

### /var/lib/usbutils/usb.ids

The `/var/lib/usbutils/usb.ids` file contains a gzipped
list of all known usb devices.

    student@linux:~$ zmore /var/lib/usbutils/usb.ids | head
    ------> /var/lib/usbutils/usb.ids <------
    #
    #   List of USB ID's
    #
    #   Maintained by Vojtech Pavlik <vojtech@suse.cz>
    #   If you have any new entries, send them to the maintainer.
    #   The latest version can be obtained from
    #       http://www.linux-usb.org/usb.ids
    #
    # $Id: usb.ids,v 1.225 2006/07/13 04:18:02 dbrownell Exp $
            

### /usr/sbin/lspci

To get a list of all pci devices connected, you could take a look at
`/proc/bus/pci` or run `lspci` (partial
output below).

    student@linux:~$ lspci
    ...
    00:06.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-139...
    00:08.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-816...
    00:09.0 Multimedia controller: Philips Semiconductors SAA7133/SAA713...
    00:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI 
    00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA ...
    00:0f.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A...
    00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1....
    00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1....
    ...
            

## interrupts

### about interrupts

An `interrupt request` or `IRQ` is a request
from a device to the CPU. A device raises an interrupt when it requires
the attention of the CPU (could be because the device has data ready to
be read by the CPU).

Since the introduction of pci, irq's can be shared among devices.

Interrupt 0 is always reserved for the timer, interrupt 1 for the
keyboard. IRQ 2 is used as a channel for IRQ's 8 to 15, and thus is the
same as IRQ 9.

### /proc/interrupts

You can see a listing of interrupts on your system in
`/proc/interrupts`.

    student@linux:~$ cat /proc/interrupts 
          CPU0     CPU1       
    0:  1320048     555  IO-APIC-edge      timer
    1:    10224       7  IO-APIC-edge      i8042
    7:        0       0  IO-APIC-edge      parport0
    8:        2       1  IO-APIC-edge      rtc
    10:     3062     21  IO-APIC-fasteoi   acpi
    12:      131      2  IO-APIC-edge      i8042
    15:    47073      0  IO-APIC-edge      ide1
    18:        0      1  IO-APIC-fasteoi   yenta
    19:    31056      1  IO-APIC-fasteoi   libata, ohci1394
    20:    19042      1  IO-APIC-fasteoi   eth0
    21:    44052      1  IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb2,...
    22:   188352      1  IO-APIC-fasteoi   ra0
    23:   632444      1  IO-APIC-fasteoi   nvidia
    24:     1585      1  IO-APIC-fasteoi   VIA82XX-MODEM, VIA8237
            

### dmesg

You can also use `dmesg` to find irq's allocated at boot
time.

    student@linux:~$ dmesg | grep "irq 1[45]"
    [ 28.930069] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x2090 irq 14
    [ 28.930071] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x2098 irq 15
            

## io ports

### about io ports

Communication in the other direction, from CPU to device, happens
through `IO ports`. The CPU writes data or control codes
to the IO port of the device. But this is not only a one way
communication, the CPU can also use a device's IO port to read status
information about the device. Unlike interrupts, ports cannot be shared!

### /proc/ioports

You can see a listing of your system's IO ports via
`/proc/ioports`.

    [root@linux ~]# cat /proc/ioports 
    0000-001f : dma1
    0020-0021 : pic1
    0040-0043 : timer0
    0050-0053 : timer1
    0060-006f : keyboard
    0070-0077 : rtc
    0080-008f : dma page reg
    00a0-00a1 : pic2
    00c0-00df : dma2
    00f0-00ff : fpu
    0170-0177 : ide1
    02f8-02ff : serial
    ...
            

## dma

### about dma

A device that needs a lot of data, interrupts and ports can pose a heavy
load on the cpu. With `dma` or `Direct Memory Access` a
device can gain (temporary) access to a specific range of the `ram`
memory.

### /proc/dma

Looking at `/proc/dma` might not give you the information
that you want, since it only contains currently assigned `dma` channels
for `isa` devices.

    root@linux:~# cat /proc/dma 
    1: parport0
    4: cascade
            

`pci` devices that are using dma are not listed in `/proc/dma`, in this
case `dmesg` can be useful. The screenshot below shows
that during boot the parallel port received dma channel 1, and the
Infrared port received dma channel 3.

    root@linux:~# dmesg | egrep -C 1 'dma 1|dma 3'
    [   20.576000] parport: PnPBIOS parport detected.
    [   20.580000] parport0: PC-style at 0x378 (0x778), irq 7, dma 1...
    [   20.764000] irda_init()
    --
    [   21.204000] pnp: Device 00:0b activated.
    [   21.204000] nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8...
    [   21.204000] nsc-ircc, chip->init
            

