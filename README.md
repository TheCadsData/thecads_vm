# TheCADS virtual machine

For courses at theCADS, we use a virtual machine.

One reason we do so is so that we can standardize the operating system across all participants, allowing us to debug problems more effectively.

The second reason is that code can damage or corrupt your normal operating system. Using a VM puts a box around the programs you create, isolating it and preventing it from touching and damaging the operating system you use most often. For those of you who are using company computers and do not have admin privileges, this also allows you to configure your programming environment as you like or require.

Please follow the steps below to install our programming environment on your computer.

## To create the virtual machine

To create this virtual machine you first need to download and install the following:

* [Vagrant](https://www.vagrantup.com/downloads.html)

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

NB: Some Windows computers require that you enable virtualization in your BIOS. How you enable this depends on the your laptop, but a good initial guide can be found [here.](http://helpdeskgeek.com/how-to/enable-virtualization-in-the-bios/)

When you have installed these, you will want to download or clone this repository to *somewhere convenient* on your computer - this will be where you will store all the files for the class.  You can do so using the green 'Clone or download' button in the top right corner of this page.

You will also want to download the latest 64-bit **_Linux_** versions of Anaconda-3, rstudio server, and spark, which can be found at the links below:

* [Rstudio, a graphical user interface (GUI) for R programming](https://www.rstudio.com/products/rstudio/download-server/).  
Look for the web address under 64 bit for the latest version).

* [Anaconda-3, a data science platform based on Python](https://www.continuum.io/downloads#linux) (Python 3)

* [Spark, an engine for large scale data processing](http://spark.apache.org/downloads.html)

Put all of these installers into thecads_vm folder on your computer that you cloned or downloaded.

Open ```bootstrap.sh``` in a text editor, and double check whether the filenames in the variables SPARK, ANACONDA and RSTUDIO match the installers you have just downloaded.

Then open your command line (OSX) or command prompt (Windows) and change directories such that your current directory is thecads_vm using the command ```cd```. ([OSX/Linux Tutorial](http://www.ee.surrey.ac.uk/Teaching/Unix/unix1.html), [Windows Tutorial](http://www.digitalcitizen.life/command-prompt-how-use-basic-commands))

Then run the following code:
```
vagrant up  
```

Running $vagrant up should install a Virtual Machine (VM) using an Ubuntu 14.04 'trusty64' operating system, with Spark, Scala, Anaconda, and RStudio installed. The process can take around 30 minutes.

Once the VM is created, it will be running, and you can access the VM through VirtualBox or easily with vagrant by running ```vagrant ssh``` on the command line on the same folder. The user name and password are both the same and is ```vagrant```.

## What is in the VM

- Ubuntu 64
- conda (Python3.5)
- R (from cran with apt)
- R studio server
- Spark

## On start-up

Running ```vagrant ssh``` will launch jupyter notebook and Rstudio. You can access these from your host computer (on your browser) with the following links:

Jupyter: http://localhost:2200
RStudio: http://localhost:8787

To shut down your VM, which you will want to do when you are done, you can type ```vagrant halt``` into your command line.  To start up your VM again, you can either navigate to the folder and type ```vagrant up``` again, or you can open VirtualBox and open the VM there.

The folder on the host ```./``` is synchronised with folder
```/home/vagrant/thecads``` on the guest (the VM).

## Troubleshouting

To connect directly on the VM with ssh without VirtualBox interface, you can run:

```
vagrant ssh
```

For this command, you need ```ssh``` on the computer, otherwise on Windows, you might get the following error:

```
`ssh` executable not found in any directories in the %PATH% variable.
Is an SSH client installed? Try installing Cygwin, MinGW or Git,
all of witch contain an SSH client. Or use your favorite SSH
client with the following authentication information shown below:
```

A solution to this problem is to install ssh with git:

https://git-scm.com/download/win

Then you need to specify where ssh executable is. For that, you will have to update the PATH environment variable.
You first have to figure out where ssh is. Usually, it is in this directory:
```
C:\Program Files\Git\usr\bin
```

Then you can update path, with a command in the command line interface or using the *Control panel*.

The command is:


```
set PATH=%PATH%;C:\Program Files\Git\usr\bin
```

With the Control Panel, follow this procedure:

1.    Open the Control Panel
1.    Go to System and Security
1.    Click on System, then on the Change Settings button
1.    Display the Advanced tab and click on Environment Variables...
1.    Look for the Path variable in the System variables list, select it then Edit...
1. At the end of the string, add the path to Git's bin (something like "C:\Program Files\Git\usr\bin") (don't forget to add a semicolon first to separate it from the previous path).

All this information was found here:  http://tech.osteel.me/posts/2015/01/25/how-to-use-vagrant-on-windows.html
