#!/bin/python3 
configfile: "config.yml"
import re 
import csv 
import yaml 
import subprocess
import os


with open('config.yml', 'r') as config_file:
        config = yaml.safe_load(config_file)



home = os.path.expanduser("~")
fichier_csv = os.path.join(home, 'sra_list.csv')

SRA_LIST = []
with open(fichier_csv, 'rt') as f:
    for line in f:
        line = line.split()[0].strip()
        if re.match('[SED]RR\d+$', line): 
            SRA_LIST.append(line) 
            

            
rule all : 
     input: 
           expand(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz", sra=SRA_LIST),
           #config["RESULTS"] + "REINDEER/index_reindeer/reindeer_index.gz"

          
##### Modules #####

include: "rules/fastq.smk"
#include: "rules/trimming.smk"
#include: "rules/bcalm.smk"
#include: "rules/reindeer.smk"



##### End messages #####

onsuccess:
    print("Workflow finished, no error")

onerror:
    print("An error occurred")
