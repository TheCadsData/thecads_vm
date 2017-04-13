# -*- mode: ruby -*-
# vi: set ft=ruby :
# Documentation.
# Running $vagrant up should install Ubuntu 14.04 'trusty64' with Spark, Anaconda, and R.
# Before running $ vagrant up, make sure to download the latest version of Anaconda-3
# the latest version of rstudio server, and spark.
# Put all of these installers and the install_r_packages.R and jupyter-notebook.conf
# into a single directory.  Make sure to run $ vagrant up  in that directory.
# Make sure to change variable SPARK, ANACONDA and RSTUDIO to the updated file names.
# If any parts fail, just run them in the command line after to fix the problem

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  ENV['LC_ALL']="en_US.UTF-8"
	#ipython notebook
  config.vm.network "forwarded_port", guest: 8888, host: 2200, host_ip:"localhost", auto_correct: true
  #spark
  config.vm.network "forwarded_port", guest: 4040, host: 4040, host_ip:"localhost", auto_correct: true
	# rstudio server
  config.vm.network "forwarded_port", guest: 8787, host: 8787, host_ip:"localhost", auto_correct: true

  config.vm.provider :virtualbox do |v|
  	v.memory = 2048
  	v.cpus = 2
		#vb.gui = true
  end

  config.vm.provision :shell, privileged: false, path: "bootstrap.sh"
  config.vm.synced_folder ".", "/home/vagrant/thecads"

end
