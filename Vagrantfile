# -*- mode: ruby -*-
# vi: set ft=ruby :
# Documentation.
# Running $vagrant up should install Ubuntu 14.04 'trusty64' with Spark, Anaconda, and R.
# Before running $ vagrant up, make sure to download the latest version of Anaconda-2
# the latest version of rstudio server, and spark.
# Put all of these installers and the install_r_packages.R and jupyter-notebook.conf
# into a single directory.  Make sure to run $ vagrant up  in that directory.
# Make sure to change lines 40, 42, 45, 64 and 71 to the updated file names.
# If any parts fail, especially lines 28-29, just run them in the command line after to
# fix the problem

$script = <<SCRIPT

# Set timezone
echo "Asia/Kuala_Lumpur" | sudo tee /etc/timezone

export DEBIAN_FRONTEND=noninteractive

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales

# R and RStudio Server keys
echo "deb https://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee /etc/apt/sources.list.d/r-project.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo add-apt-repository -y ppa:marutter/rdev

# APT-GET
sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get -y install libssl-dev build-essential libffi-dev libzmq-dev libcurl4-gnutls-dev \
libxml2-dev python-dev git-core python-pip sqlite3 r-base r-base-dev
sudo apt-get -y autoremove

# R Packages and Studio
cp /home/vagrant/thecads/install_r_packages.R .
cp /home/vagrant/thecads/rstudio-server-0.99.903-amd64.deb .
sudo Rscript install_r_packages.R
sudo dpkg -i rstudio-server-0.99.903-amd64.deb

# ANACONDA
cp /home/vagrant/thecads/Anaconda2-4.2.0-Linux-x86_64.sh .
anaconda=Anaconda2-4.2.0-Linux-x86_64.sh
if [[ ! -f $anaconda ]]; then
	wget --quiet https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/$anaconda
fi
chmod +x $anaconda
./$anaconda -b -p /home/vagrant/anaconda
cat >> /home/vagrant/.bashrc << END
export PATH=/home/vagrant/anaconda/bin:$PATH
END
source /home/vagrant/.bashrc
yes | /home/vagrant/anaconda/bin/conda update conda
chown -R vagrant:vagrant /home/vagrant/anaconda
# rm $anaconda

# JAVA
apt-get -y install openjdk-7-jdk

# APACHE SPARK
cp /home/vagrant/thecads/spark-2.0.1-bin-hadoop2.7.tgz .
spark=spark-2.0.1-bin-hadoop2.7.tgz
if [[ ! -f $spark ]]; then
	wget --quiet http://d3kbcqa49mib13.cloudfront.net/$spark
fi
tar xvf $spark
# rm $spark
mv spark-2.0.1-bin-hadoop2.7 spark

# Install findspark & seaborn
/home/vagrant/anaconda/bin/pip install findspark seaborn

echo 'SPARK_HOME=/home/vagrant/spark' >> /etc/environment
echo 'PYSPARK_PYTHON=/home/vagrant/anaconda/bin/python' >> /etc/environment

# Start ipython notebook
su vagrant -c '/home/vagrant/anaconda/bin/jupyter-notebook --generate-config'
cat >> /home/vagrant/.jupyter/jupyter_notebook_config.py << END
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
END

su vagrant -c 'ln -s /media /home/vagrant/media'

sudo cp /home/vagrant/thecads/jupyter-notebook.conf /etc/init
sudo service jupyter-notebook start

# install rpython magic
/home/vagrant/anaconda/bin/pip install rpy2

sudo apt-get -y autoremove

sudo usermod -aG vboxsf vagrant

SCRIPT


Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
	#ipython notebook
  config.vm.network "forwarded_port", guest: 8888, host: 8888, auto_correct: true
  #spark
  config.vm.network "forwarded_port", guest: 4040, host: 4040, auto_correct: true
	# rstudio server
  config.vm.network "forwarded_port", guest: 8787, host: 8787, auto_correct: true

  config.vm.provider :virtualbox do |v|
  	v.memory = 2048
  	v.cpus = 2
		#vb.gui = true
  end

  config.vm.provision :shell, inline: $script
  config.vm.synced_folder ".", "/home/vagrant/thecads"

end
