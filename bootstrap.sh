#to stop at first error
set -e

#VARIABLES
SPARK=spark-2.1.0-bin-hadoop2.7
SPARK_FILE=${SPARK}.tgz
ANACONDA_PATH=/home/vagrant/anaconda3
ANACONDA=Anaconda3-4.3.1-Linux-x86_64.sh
RSTUDIO=rstudio-server-1.0.136-amd64.deb

# Set timezone
echo "Asia/Kuala_Lumpur" | sudo tee /etc/timezone
export DEBIAN_FRONTEND=noninteractive

sudo dpkg-reconfigure -f noninteractive tzdata
#sudo update-grub

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo -E locale-gen "en_US.UTF-8"
#sudo -E apt-get install language-pack-UTF-8
sudo -E dpkg-reconfigure locales

# directories
mkdir -p /home/vagrant/thecads/eds
if [[ ! -e /media/thecads ]]; then
    sudo ln -s /home/vagrant/thecads /media/thecads
fi
sudo chown -R vagrant /media
sudo chown -R vagrant /home/vagrant/thecads


# R and RStudio Server keys
echo "deb https://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee /etc/apt/sources.list.d/r-project.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo add-apt-repository -y ppa:marutter/rdev

# APT-GET
sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get -y install libssl-dev build-essential libffi-dev libzmq-dev libcurl4-gnutls-dev libxml2-dev \
     git-core sqlite3  r-base r-base-dev

# python-dev python-pip sqlite3 r-base r-base-dev
sudo apt-get -y autoremove


# ANACONDA
if [[ ! -f ~vagrant/thecads/$ANACONDA ]]; then
   wget -nv https://repo.continuum.io/archive/$ANACONDA -O ~vagrant/thecads/$ANACONDA
fi
chmod +x ~vagrant/thecads/$ANACONDA
if [[ ! -f $ANACONDA_PATH/bin/conda ]]; then
   ~vagrant/thecads/$ANACONDA -b -p $ANACONDA_PATH
fi
cat >> /home/vagrant/.bashrc << END
export PATH="$ANACONDA_PATH/bin:$PATH"
END
source /home/vagrant/.bashrc
export PATH="$ANACONDA_PATH/bin:$PATH"
chown -R vagrant:vagrant $ANACONDA_PATH
conda update -y conda

# # R with conda
# conda install -c r r-essentials -y


# Rstudio
cp /home/vagrant/thecads/install_r_packages.R .
sudo Rscript install_r_packages.R
# R Packages and Studio
if [[ ! -f ~vagrant/thecads/$RSTUDIO ]]; then
   wget -nv https://download2.rstudio.org/$RSTUDIO -O ~vagrant/thecads/$RSTUDIO
fi

sudo -E dpkg -i ~vagrant/thecads/$RSTUDIO
#sudo cp thecads/rserver.conf /etc/rstudio/

# IRKernel
sudo R -e "devtools::install_github('IRkernel/IRkernel')"


# JAVA
sudo apt-get -y install openjdk-7-jdk


# APACHE SPARK
if [[ ! -f ~vagrant/thecads/${SPARK_FILE} ]]; then
	wget -nv http://d3kbcqa49mib13.cloudfront.net/${SPARK_FILE} -O ~vagrant/thecads/${SPARK_FILE}
fi
tar xvf ~vagrant/thecads/${SPARK_FILE} -C ~vagrant/
mv ~vagrant/$SPARK spark

cat >> /home/vagrant/.bashrc << END
export 'SPARK_HOME=/home/vagrant/spark'
END

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

# Add Scala kernel to jupyter
git clone https://github.com/alexarchambault/jupyter-scala.git
cd jupyter-scala/
curl -L -o coursier https://git.io/vgvpD && chmod +x coursier && ./coursier --help
chmod +x jupyter-scala
export PATH=$PATH:$PWD
./jupyter-scala
cd ..
rm -rf jupyter-scala

sudo cp /home/vagrant/thecads/jupyter-notebook.conf /etc/init
sudo service jupyter-notebook start

R -e "IRkernel::installspec()"

sudo apt-get -y autoremove

sudo usermod -aG vboxsf vagrant
