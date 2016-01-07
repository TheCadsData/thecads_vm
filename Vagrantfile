# -*- mode: ruby -*-
# vi: set ft=ruby :

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

# APT-GET
sudo apt-get update
#sudo apt-get upgrade

sudo apt-get -y install libssl-dev build-essential libffi-dev libzmq-dev libcurl4-gnutls-dev \
libxml2-dev python-dev git-core python-pip sqlite3 r-base r-base-dev

sudo apt-get -y autoremove

# JAVA
# apt-get -y install openjdk-7-jdk

# ANACONDA
anaconda=/home/vagrant/thecads/Anaconda2-2.4.0-Linux-x86_64.sh

#if [[ ! -f $anaconda ]]; then
#  wget --quiet https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/$anaconda
#fi
chmod +x $anaconda
$anaconda -b -p /home/vagrant/anaconda
cat >> /home/vagrant/.bashrc << END
export PATH=/home/vagrant/anaconda/bin:$PATH
END
source /home/vagrant/.bashrc
yes | /home/vagrant/anaconda/bin/conda update conda
chown -R vagrant:vagrant /home/vagrant/anaconda

# Download all NLTK data
# sudo /home/vagrant/anaconda/bin/python -m nltk.downloader -d /usr/local/share/nltk_data all

# Install findspark & seaborn
/home/vagrant/anaconda/bin/pip install seaborn

# Start ipython notebook
su vagrant -c '/home/vagrant/anaconda/bin/ipython locate'
su vagrant -c 'cp /home/vagrant/thecads/ipython_notebook_config.py /home/vagrant/.ipython/profile_default'
sudo cp /home/vagrant/thecads/ipython-notebook.conf /etc/init
sudo service ipython-notebook start

sudo Rscript /home/vagrant/thecads/install_r_packages.R
sudo dpkg -i /home/vagrant/thecads/rstudio-server-0.99.491-amd64.deb

# install rpython magic
/home/vagrant/anaconda/bin/pip install rpy2

sudo apt-get -y autoremove

sudo usermod -aG vboxsf vagrant
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # ipython notebook
  config.vm.network "forwarded_port", guest: 8888, host: 8888, auto_correct: true
  # rstudio server
  config.vm.network "forwarded_port", guest: 8787, host: 8787, auto_correct: true

  # config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
    vb.cpus = 2
    #vb.gui = true
  end
  
  config.vm.provision :shell, inline: $script
  config.vm.synced_folder ".", "/home/vagrant/thecads"

end
