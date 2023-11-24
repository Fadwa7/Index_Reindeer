#!/bin/python3 
configfile: "/home/fadwa_el_khaddar/config.yml"
import re 


SRA = config['SRA_FILE_ID']

SRA_LIST = []
with open(SRA, 'rt') as f:
    for line in f:
        line = line.split()[0].strip()
        if re.match('[SED]RR\d+$', line): 
            SRA_LIST.append(line) 
            
            
rule all : 
     input: 
          expand(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz", sra=SRA_LIST),
          expand(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz", sra=SRA_LIST),
          expand(config["RESULTS"] + "BCALM/{sra}_trim.fastq.h5", sra=SRA_LIST)          
rule fetch_fastq:
    output: 
        config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz"
    log: 
        config["RESULTS"] + "Supplementary_Data/Logs/{sra}.sratoolkit.log"
    benchmark: 
        config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}.sratoolkit.txt"
    message: 
       "fetch fastq from NCBI" 
    shell:
        """
        fastq-dump \
            --split-spot \
            --skip-technical {wildcards.sra} \
            --stdout 2>{log} \
        | gzip -c > {output}
        """

rule adapt_trimming:
     input: 
        fastq = config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz"
     output: 
        cut_fastq = config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz" 
     message: 
        "Trimmig FASTQS" 
     log: 
        config["RESULTS"] + "Supplementary_Data/Logs/{sra}_cutadapt.log"
     benchmark: 
        config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}_cutadapt.txt"
     shell: 
        """
        cutadapt \
        -j 1 -q 20 -m 20 -o {output.cut_fastq} \
        -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA {input.fastq} 2>{log} 
        """
rule bcalm: 
     input: 
       cut_fastq = config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz"
     output: 
       table = config["RESULTS"] + "BCALM/{sra}_trim.fastq.h5" 
     params: 
       config["RESULTS"] + "BCALM/{sra}",
       kmer_size = config["KMER_SIZE"],
       abundance = config["ABUNDANCE_MIN"]
     log: 
        config["RESULTS"] + "Supplementary_Data/Logs/{sra}_bcalm.log" 
     benchmark:
        config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}_bcalm.txt"
     shell: 
       ". $(conda info --base)/etc/profile.d/conda.sh ;"
       " source activate ;" 
       "bcalm -in {input.cut_fastq} -kmer-size {params.kmer_size} -abundance-min {params.abundance}"
