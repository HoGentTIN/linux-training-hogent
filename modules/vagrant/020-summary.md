[Vagrant](https://www.vagrantup.com) is a tool that allows you to define an environment consisting of virtual machines that is entirely reproducible. It was originally developed by Mitchell Hashimoto and is now maintained by HashiCorp.

Vagrant is a command-line tool that talks to a hypervisor, such as VirtualBox, to create and manage virtual machines. It uses a configuration file called `Vagrantfile` to define the VMs and their settings. The `Vagrantfile` is written in Ruby, but you don't need to know Ruby to use Vagrant. One of the authors of this course has prepared a Vagrantfile that parses a YAML file to define the VMs and their settings, so you don't need to learn Ruby in order to be productive with Vagrant.

In order to create a VM, Vagrant will first download an initial VM image, called *base box* in Vagrant terminology, and then it will start the VM and configure it according to the settings in the `Vagrantfile`. This process is called *provisioning*.

The user can write a provisioning script in Bash or another infrastructure automation tool like Ansible, which will be executed inside the VM to install and configure software.

The entire definition of VMs is then comprised of the `Vagrantfile` and the provisioning scripts. This makes it easy to share the environment with other developers, and to version control the environment settings. It also makes it easy to recreate the environment on another machine, or to recreate the environment from scratch after it has been destroyed.

Vagrant is a great tool for developers who need to test their software in a local environment that is set up to resemble the acceptance/production environment. It is also useful for system administrators who need to test their infrastructure automation scripts locally before deploying on production infrastructure.

Learning goals:

- Installing Vagrant and creating a VirtualBox VM with it
- Knowing and using the basic Vagrant commands to manage VMs
- Writing a provisioning script in Bash to configure the VM

