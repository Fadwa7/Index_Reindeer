#!/bin/python3 
configfile: "config.yaml"
import re 
import csv 
import yaml
import subprocess
import os





print(r'   _____  _   _ ______  _____ __   __ ______  _____  _____  _   _ ______  _____  _____ ______ ')
print(r'  |_   _|| \ | ||  _  \|  ___|\ \ / / | ___ \|  ___||_   _|| \ | ||  _  \|  ___||  ___|| ___ \ ')
print(r'    | |  |  \| || | | || |__   \ V /  | |_/ /| |__    | |  |  \| || | | || |__  | |__  | |_/ / ')
print(r'    | |  | . ` || | | ||  __|  /   \  |    / |  __|   | |  | . ` || | | ||  __| |  __| |    / ')
print(r'   _| |_ | |\  || |/ / | |___ / /^\ \ | |\ \ | |___  _| |_ | |\  || |/ / | |___ | |___ | |\ \ ')
print(r'   \___/ \_| \_/|___/  \____/ \/   \/ \_| \_|\____/  \___/ \_| \_/|___/  \____/ \____/ \_| \_| ')
print(r'                                                                                                 ')
print(r'                                                                                                 ')







# register shared settings

#storage:
#        provider="gcs",
#        max_requests_per_second= None,
#        project= "arctic-carving-413109" ,
#        keep_local= False ,
#        stay_on_remote= False,
#        retries= 5, 


def extract_srr_list(config):
    fichier_csv = config.get("SRA_LIST")
    fastq_dir = config.get("FASTQ_FILES")
    SRA_LIST = []
    if fichier_csv:
        with open(fichier_csv, 'rt') as f:
            for line in f:
                line = line.split()[0].strip()
                if re.match(r'[SED]RR\d+$', line):
                    SRA_LIST.append(line)
    elif fastq_dir:
        for filename in os.listdir(fastq_dir):
            if re.match(r'SRR\d+', filename):
                srr = re.match(r'SRR\d+', filename).group(0)
                SRA_LIST.append(srr)
    else:
        print("Neither SRA list nor FASTQ files provided.")
        return None

    return SRA_LIST

# Extraction of config file
with open('config.yaml', 'r') as config_file:
    config = yaml.safe_load(config_file)

SRA_LIST = extract_srr_list(config)

if SRA_LIST:
    print("SRR List:", SRA_LIST)



if config['SAMPLE'] =="single":
	rule all : 
     		input: 
                         expand(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz", sra=SRA_LIST),
#                         config["RESULTS"] + "QC/multiqc_report.html",
                         expand(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz", sra=SRA_LIST),
                         config["RESULTS"] + "Statistics/reads_count.txt",
                         config["RESULTS"] + "REINDEER/index_reindeer/reindeer_index.gz",


if config['SAMPLE'] =="paired":
	rule all : 
                input: 
                         expand(config["RESULTS"] + "Fastq_Files/{sra}_1.fastq.gz", sra=SRA_LIST),
#                         storage.gcs(expand("gs://ssfa_project/{sra}_1.fastq.gz", sra=SRA_LIST)),
#                         storage.gcs(expand("gs://ssfa_project/{sra}_2.fastq.gz", sra=SRA_LIST))
                         expand(config["RESULTS"] + "Fastq_Files/{sra}_2.fastq.gz", sra=SRA_LIST),
#                         config["RESULTS"] + "QC/multiqc_report.html",
                         expand(config["RESULTS"] + "Trimming/{sra}/{sra}_{reads}_cutadapt.fastq.gz", sra=SRA_LIST, reads=config["READS"]),
                         config["RESULTS"] + "Statistics/reads_count.txt",
                         config["RESULTS"] + "REINDEER/index_reindeer/reindeer_index.gz",

          
##### Modules #####
if config["SRA_LIST"] != "":
	include: "rules/sra_prefetch.smk"
if config["FASTQ_FILES"] != "":
	include:"rules/fastq_folder.smk"
#include: "rules/multiqc.smk"
include: "rules/trimming.smk"
include: "rules/statistics.smk"
if config['SAMPLE'] =="single":
	include: "rules/bcalm_single.smk"
if config['SAMPLE'] =="paired":
	include: "rules/bcalm_paired.smk"
include: "rules/reindeer.smk"


##### End messages #####

onsuccess:
    print("Workflow finished, no error")

onerror:
    print("An error occurred")
