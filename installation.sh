#!/bin/bash 


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

export PATH=:$home/miniconda3/bin:$PATH

source activate 

echo "####"
echo " "
echo "BCALM Installation"
echo " "
echo " " 

conda install -c conda-forge -c bioconda bcalm -y

## SRAtoolkit : 
echo "####"
echo " "
echo "SRAtoolkit Installation"
echo " "
echo " " 
 
cd 
wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz

tar -vxzf sratoolkit.tar.gz  > /dev/null 2>&1

export PATH=$PATH:$home/sratoolkit.3.0.7-ubuntu64/bin  > /dev/null 2>&1 

echo "Verfication"

which fastq-dump

echo "Installation DONE ! "

rm sratoolkit.tar.gz


## CUTADAPT
echo " " 
echo "####"
echo " " 
echo "CUTADAPT Installation "
echo " " 
echo " " 
sudo apt -y install cutadapt > /dev/null 2>&1 

echo "Verification"

which cutadapt 

echo "Installation DONE !"

echo " " 
echo "####"
echo " " 
echo "REINDEER Installation "
echo " " 
echo " "


cd 
git clone --recursive https://github.com/kamimrcht/REINDEER.git
cd REINDEER
sh install.sh 

echo "Verfication"

sh test.sh 

cd 

echo "Installation DONE !"


