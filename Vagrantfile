# -*- mode: ruby -*-
# vi: set ft=ruby :

ipython_guest = 8888
ipython_host = 8888

$script = <<SCRIPT
# Set timezone
echo "Asia/Kuala_Lumpur" | sudo tee /etc/timezone


# APT-GET
sudo apt-get update
#sudo apt-get upgrade

sudo apt-get -y install libssl-dev build-essential libffi-dev libzmq-dev
sudo apt-get -y install libcurl4-gnutls-dev
sudo apt-get -y install libxml2-dev
sudo apt-get -y install python-dev
sudo apt-get -y install git-core

# PIP
sudo apt-get -y install python-pip

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
#rm $anaconda

# JAVA
# apt-get -y install openjdk-7-jdk

# Install findspark & seaborn
/home/vagrant/anaconda/bin/pip install seaborn

# Start ipython notebook
IPYTHON_CMD=su vagrant -c 'cd /home/vagrant && /home/vagrant/anaconda/bin/ipython notebook --ip=* --no-browser'
sudo sed -i "1i $IPYTHON_CMD" /etc/rc.local
sudo $IPYTHON_CMD

# R and RStudio Server
echo "deb https://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee /etc/apt/sources.list.d/r-project.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update
sudo apt-get -y install r-base r-base-dev
sudo Rscript /home/vagrant/thecads/install_r_packages.R
sudo dpkg -i /home/vagrant/thecads/rstudio-server-0.99.489-amd64.deb

SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # ipython notebook
  config.vm.network "forwarded_port", guest: 8888, host: 8888, auto_correct: true
  # rstudio server
  config.vm.network "forwarded_port", guest: 8787, host: 8787, auto_correct: true

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
    vb.cpus = 2
    #vb.gui = true
  end
  
  config.vm.provision :shell, inline: $script
  config.vm.synced_folder ".", "/home/vagrant/thecads"

end
