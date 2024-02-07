rule multi_fastqc:
    input: 
         expand(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz", sra=SRA_LIST)
    output: 
         config["RESULTS"] + "QC/multiqc_report.html"
    log: 
         config["RESULTS"] + "Supplementary_Data/Logs/multifastqc/multifastqc.txt"
    params:
         outdir = config["RESULTS"] + "QC/"
    shell:
      " multiqc -f -o {params.outdir} . > {log} 2>&1 "
