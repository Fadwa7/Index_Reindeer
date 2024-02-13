####### TODO : Add multiqc "pip install multiqc" 

#!/bin/bash -i

directory=$1

## BCALM
echo "####"
echo " "
echo "Installation des paquets essentiels"
echo " "
echo " "

sudo apt -y install make 
sudo apt-get -y install build-essential 
sudo apt -y install zlib1g-dev
sudo apt -y install git
sudo apt -y install cmake g++

### INSTALLATION de edirect
cd
home=$(pwd)

## INSTALLATION de CONDA
echo "####"
echo " "
echo "Installation de Conda"
echo " "
echo " "
cd
mkdir -p miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3/miniconda.sh
bash miniconda3/miniconda.sh -b -u -p miniconda3

echo 'export PATH='$home'/miniconda3/bin:$PATH'  >> ~/.bashrc
source ~/.bashrc

conda init bash  # Initialise Conda pour la prise en charge du terminal bash actuel
source ~/.bashrc

## INSTALLATION de CONDA
echo "####"
echo " "
echo "Installation de Esearch NCBI"
echo " "
echo " "

cd
sudo apt-get -y update
sudo apt -y install ncbi-entrez-direct
echo 'yes' | sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
echo 'export PATH="'$home'/edirect:$PATH"'  >> ~/.bashrc
cd 
source ~/.bashrc

echo "####"
echo " "
echo "Installation de mamba et création de l'environnement conda de snakemake"
echo " "


conda install -n base -c conda-forge -y mamba
mamba create -c conda-forge -c bioconda -n snakemake snakemake -y

## Conda environement : 

for file in "$directory"/*.yml; do 
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"
        conda env create -f $file 
done




conda activate sratoolkit 
conda install -y -c bioconda parallel-fastq-dump ##Installing parallel-fatq-dump inside sratoolkit conda environement

conda init
conda deactivate

echo " " 
echo "####"
echo " " 
echo "REINDEER Installation "
echo " " 
echo " "
conda init
conda activate bcalm 

cd 
sudo apt -y install zlib1g-dev
git clone --recursive https://github.com/kamimrcht/REINDEER.git
cd REINDEER
sh install.sh 

echo "Verfication"

sh test.sh 

cd
mamba activate snakemake
