#!/bin/bash 


bcalm=$1
sratoolkit=$2
cutadapt=$3
snakemake=$4


## BCALM 


echo "####"
echo " "
echo "Essential packages Installation"
echo " "
echo " " 

sudo apt -y install make 
sudo apt-get -y install build-essential 
sudo apt -y install zlib1g-dev
sudo apt -y install git
sudo apt -y install cmake g++


### INSTALL edirect 
cd
sudo apt -y install ncbi-entrez-direct
sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
export PATH=:$home/edirect:${PATH} >> ~/.bashrc

source ~/.bashrc


##INSTALL CONDA 
echo "####"
echo " "
echo "Conda Installation"
echo " "
echo " " 

home=$(pwd)
mkdir -p miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3/miniconda.sh
bash miniconda3/miniconda.sh -b -u -p miniconda3

export PATH=:$home/miniconda3/bin:$PATH >> ~/.bashrc

source ~/.bashrc

source activate 

echo "####"
echo " "
echo "BCALM Installation"
echo " "
echo " " 


conda env create -f $bcalm



## SRAtoolkit : 
echo "####"
echo " "
echo "SRAtoolkit Installation"
echo " "
echo " " 
 
conda env create -f $sratoolkit



## CUTADAPT
echo " " 
echo "####"
echo " " 
echo "CUTADAPT Installation "
echo " " 
echo " " 


conda env create -f $cutadapt


echo "Installation DONE !"


## Snakemake
echo " " 
echo "####"
echo " " 
echo "SNAKEMAKE Installation "
echo " " 
echo " " 


conda env create -f $snakemake


echo " " 
echo "####"
echo " " 
echo "REINDEER Installation "
echo " " 
echo " "

conda activate bcalm 

cd 
sudo apt -y install zlib1g-dev
git clone --recursive https://github.com/kamimrcht/REINDEER.git
cd REINDEER
sh install.sh 

echo "Verfication"

sh test.sh 

cd 

echo "Installation DONE !"
