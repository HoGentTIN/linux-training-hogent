## download a Linux CD image

Start by downloading a Linux CD image (an .ISO file) from the
distribution of your choice from the Internet. Take care selecting the
correct cpu architecture of your computer; choose `i386` if unsure.
Choosing the wrong cpu type (like x86_64 when you have an old Pentium)
will almost immediately fail to boot the CD.

![](images/vm1_download.png)

## download Virtualbox

Step two (when the .ISO file has finished downloading) is to download
Virtualbox. If you are currently running Microsoft Windows, then
download and install Virtualbox for Windows!

![](images/vm2_download.png)

## create a virtual machine

Now start Virtualbox. Contrary to the screenshot below, your left pane
should be empty.

![](images/vm3_virtualbox.png)

Click `New` to create a new virtual machine. We will walk together
through the wizard. The screenshots below are taken on Mac OSX; they
will be slightly different if you are running Microsoft Windows.

![](images/vm_wizard1.png)

Name your virtual machine (and maybe select 32-bit or 64-bit).

![](images/vm_wizard2.png)

Give the virtual machine some memory (512MB if you have 2GB or more,
otherwise select 256MB).

![](images/vm_wizard3.png)

Select to create a new disk (remember, this will be a virtual disk).

![](images/vm_wizard4.png)

If you get the question below, choose vdi.

![](images/vm_wizard5.png)

Choose `dynamically allocated` (fixed size is only useful in production
or on really old, slow hardware).

![](images/vm_wizard6.png)

Choose between 10GB and 16GB as the disk size.

![](images/vm_wizard7.png)

Click `create` to create the virtual disk.

![](images/vm_wizard8.png)

Click `create` to create the virtual machine.

![](images/vm_wizard9.png)

## attach the CD image

Before we start the virtual computer, let us take a look at some
settings (click `Settings`).

![](images/vm_settings1.png)

Do not worry if your screen looks different, just find the button named
`storage`.

![](images/vm_settings2.png)

Remember the .ISO file you downloaded? Connect this .ISO file to this
virtual machine by clicking on the CD icon next to `Empty`.

![](images/vm_settings4.png)

Now click on the other CD icon and attach your ISO file to this virtual
CD drive.

![](images/vm_settings5.png)

Verify that your download is accepted. If Virtualbox complains at this
point, then you probably did not finish the download of the CD (try
downloading it again).

![](images/vm_settings6.png)

It could be useful to set the network adapter to bridge instead of NAT.
Bridged usually will connect your virtual computer to the Internet.

![](images/vm_settings7.png)

## install Linux

The virtual machine is now ready to start. When given a choice at boot,
select `install` and follow the instructions on the screen. When the
installation is finished, you can log on to the machine and start
practising Linux!
