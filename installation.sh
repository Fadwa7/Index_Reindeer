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


if ! which conda &> /dev/null; then
    # Si Conda n'est pas installé, télécharger et installer Miniconda
    echo "####"
    echo " "
    echo "Installation de Conda"
    echo " "
    echo " "
    cd "$HOME"
    mkdir -p miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3/miniconda.sh
    bash miniconda3/miniconda.sh -b -u -p miniconda3
    echo 'export PATH='$home'/miniconda3/bin:$PATH'  >> ~/.bashrc
    source ~/.bashrc
fi

# Initialiser Conda
conda init bash
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
conda install -y -c bioconda fastqc
yes | pip install multiqc

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


cd
mamba init
mamba activate snakemake
