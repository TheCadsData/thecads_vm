# TheCADS virtual machine

## To create the virtual machine

To create this virtual machine you need

[Vagrant](https://www.vagrantup.com/downloads.html)

and

[VirtualBox](https://www.virtualbox.org/wiki/Downloads)


Then run in current directory (where there is your Vagrantfile)

```
vagrant init
vagrant ssh
```

It creates the VM. The process can take around 20 minutes.


Once the VM is created, you can access is through VirtualBox or easily
with vagrant.

## What is in the VM

- Ubuntu 64
- conda (Python3.5)
- R (with conda)
- R studio server
- Spark

## On start-up

The VM also launches jupyter notebook. You can access it from the host with:

http://localhost:2200

Password is ```vagrant```

The folder on the host ```./``` is synchronised with folder
```/home/vagrant/thecads``` on the guest.

On the guest, there a link ```/media/thecads -> /home/vagrant/thecads/```.

On the guest, jupyter home folder is ```/media/thecads/```. Thus it is synchronised with ```./thecads/``` on the
host.


Note: the file ```install_r_packages.R``` is not used anymore since R
is installed with conda.


