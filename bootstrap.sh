#to stop at first error
set -e

#VARIABLES
SPARK=spark-2.1.0-bin-hadoop2.7.tgz
ANACONDA_PATH=/home/vagrant/anaconda3
ANACONDA=Anaconda3-4.2.0-Linux-x86_64.sh
RSTUDIO=rstudio-server-1.0.136-amd64.deb

# Set timezone
echo "Asia/Kuala_Lumpur" | sudo tee /etc/timezone

export DEBIAN_FRONTEND=noninteractive

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales


# # R and RStudio Server keys
# echo "deb https://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee /etc/apt/sources.list.d/r-project.list
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
# sudo add-apt-repository -y ppa:marutter/rdev

# APT-GET
sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get -y install libssl-dev build-essential libffi-dev libzmq-dev libcurl4-gnutls-dev libxml2-dev \
 git-core sqlite3 
# python-dev python-pip sqlite3 r-base r-base-dev
sudo apt-get -y autoremove


# ANACONDA
if [[ -f /home/vagrant/thecads/$ANACONDA ]]; then
   cp /home/vagrant/thecads/$ANACONDA .
fi
if [[ ! -f $ANACONDA ]]; then
   wget -nv https://repo.continuum.io/archive/$ANACONDA -O ~vagrant/$ANACONDA
fi
chmod +x $ANACONDA
if [[ ! -f $ANACONDA_PATH/bin/conda ]]; then
   ./$ANACONDA -b -p $ANACONDA_PATH
fi
cat >> /home/vagrant/.bashrc << END
export PATH="$ANACONDA_PATH/bin:$PATH"
END
source /home/vagrant/.bashrc
export PATH="$ANACONDA_PATH/bin:$PATH"
chown -R vagrant:vagrant $ANACONDA_PATH

conda update -y conda

# R with conda
conda install -c r r-essentials -y
# Rstudio
#cp /home/vagrant/thecads/install_r_packages.R .
#sudo Rscript install_r_packages.R
# R Packages and Studio
if [[ ! -f $RSTUDIO ]]; then
   wget -nv https://download2.rstudio.org/$RSTUDIO
fi

sudo dpkg -i $RSTUDIO


# JAVA
sudo apt-get -y install openjdk-7-jdk

# APACHE SPARK
if [[ ! -f ${SPARK} ]]; then
	wget --quiet http://d3kbcqa49mib13.cloudfront.net/${SPARK}
fi
tar xvf $SPARK
mv $SPARK spark

pip install --upgrade pip

# Install findspark & seaborn
pip install findspark seaborn

sudo su -c "echo 'SPARK_HOME=/home/vagrant/spark' >> /etc/environment"
sudo su -c "echo 'PYSPARK_PYTHON='${ANACONDA_PATH}'/bin/python' >> /etc/environment"

# Start ipython notebook
/home/vagrant/anaconda3/bin/jupyter-notebook --generate-config
cat >> /home/vagrant/.jupyter/jupyter_notebook_config.py << END
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
# stands for 'vagrant'
c.NotebookApp.password = 'sha1:3364ac55916f:432094c0ee211c8c0e1681068c89ecd2ed23330e'
c.NotebookApp.password_required = False
END

sudo ln -s /home/vagrant/thecads /media/thecads
sudo chown -R vagrant /media
sudo chown -R vagrant /home/vagrant/thecads

sudo cp /home/vagrant/thecads/jupyter-notebook.conf /etc/init
sudo service jupyter-notebook start

sudo apt-get -y autoremove

sudo usermod -aG vboxsf vagrant
