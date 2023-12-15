#!/bin/python3 
configfile: "config.yml"
import re 
import csv 
import yaml 
import subprocess
import os


with open('config.yml', 'r') as config_file:
	config = yaml.safe_load(config_file)


bioproject = config.get('BIOPROJECT')
home = os.path.expanduser("~")
fichier_csv = os.path.join(home, 'sra_list.csv')

commande = f"esearch -db sra -query {bioproject} | efetch -format runinfo | cut -f1 -d ',' > {fichier_csv}"
subprocess.run(commande, shell=True)

SRA_LIST = []
with open(fichier_csv, 'rt') as f:
    for line in f:
        line = line.split()[0].strip()
        if re.match('[SED]RR\d+$', line): 
            SRA_LIST.append(line) 
            
            
            
rule all : 
     input: 
          #expand(config["RESULTS"] + "BCALM/{sra}_trim.fastq.h5", sra=SRA_LIST)    
           expand(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz", sra=SRA_LIST)          

##### Modules #####

include: "rules/fastq.smk"
include: "rules/trimming.smk"
#include: "rules/bcalm.smk"



##### End messages #####

onsuccess:
    print("Workflow finished, no error")

onerror:
    print("An error occurred")
