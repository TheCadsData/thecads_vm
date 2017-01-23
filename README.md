# TheCADS virtual machine

## To create the virtual machine

To create this virtual machine you need

[Vagrant](https://www.vagrantup.com/downloads.html)

and

[VirtualBox](https://www.virtualbox.org/wiki/Downloads)

To improve reliability, you will also want to download the latest 64-bit version of Anaconda-3, rstudio server, and spark.

Rstudio: https://www.rstudio.com/products/rstudio/download-server/ (look for the web address under 64 bit for the latest version)
Anaconda-3: https://www.continuum.io/downloads#linux (64-bit)
Spark: http://spark.apache.org/downloads.html

Put all of these installers and the install_r_packages.R and jupyter-notebook.conf
into the single directory that you've cloned this from.  
Then change the variable SPARK, ANACONDA and RSTUDIO to the updated file names inside ```bootstrap.sh```.

Then run in the current directory (where there is your Vagrantfile and the installers)

```
vagrant up
vagrant ssh
```

Running $vagrant up should install Ubuntu 14.04 'trusty64' with Spark, Anaconda, and R.
If any parts fail, especially lines 28-29, just run them in the command line after to
fix the problem

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

The VM also launches jupyter notebook and Rstudio. You can access it from the host with:

Jupyter: http://localhost:2200
RStudio: http://localhost:8787

Password is ```vagrant```

The folder on the host ```./``` is synchronised with folder
```/home/vagrant/thecads``` on the guest.

On the guest, there a link ```/media/thecads -> /home/vagrant/thecads/```.

On the guest, jupyter home folder is ```/media/thecads/```. Thus it is synchronised with ```./thecads/``` on the
host.


Note: the file ```install_r_packages.R``` is not used anymore since R
is installed with conda.
