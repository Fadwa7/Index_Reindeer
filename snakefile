#!/bin/python3 
configfile: "config.json"
import re 
import csv 
import json
import subprocess
import os





# Extraction of config file 

with open('config.json', 'r') as config_file:
        config = json.load(config_file)
fichier_csv = config.get("SRA_LIST")
if "SRA_LIST" in config:
    fichier_csv = config["SRA_LIST"]


SRA_LIST = []
with open(fichier_csv, 'rt') as f:
    for line in f:
        line = line.split()[0].strip()
        if re.match('[SED]RR\d+$', line): 
            SRA_LIST.append(line) 

rule all : 
     input: 
           #storage.gcs(expand("Fastq_Files/{sra}.fastq.gz", sra=SRA_LIST)),
#           expand(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz", sra=SRA_LIST),
#           config["RESULTS"] + "QC/multiqc_report.html",
           expand(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz", sra=SRA_LIST),
           config["RESULTS"] + "REINDEER/index_reindeer/reindeer_index.gz",
           expand(config["RESULTS"] + "BCALM/{sra}_cutadapt.unitigs.fa.gz", sra=SRA_LIST)

          
##### Modules #####

#include: "rules/fastq.smk"
#include: "rules/multiqc.smk"
include: "rules/trimming.smk"
include: "rules/bcalm.smk"
include: "rules/reindeer.smk"

##### End messages #####

onsuccess:
    print("Workflow finished, no error")

onerror:
    print("An error occurred")
