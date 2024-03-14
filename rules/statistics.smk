if config["SAMPLE"] == "single":
        rule reads_count:
                input:
                   cut_fastq = expand(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz", sra=SRA_LIST)
                output:
                   config["RESULTS"] + "Statistics/reads_count.txt"
                shell:
                   'sh {config[SCRIPTS]}reads_count.sh {output} {input.cut_fastq}'


if config["SAMPLE"] == "paired":
	rule reads_count: 
                input: 
                   cut_fastq = expand(config["RESULTS"] + "Trimming/{sra}/{sra}_1_cutadapt.fastq.gz", sra=SRA_LIST)
                output:
                   config["RESULTS"] + "Statistics/reads_count.txt"
                shell: 
                   'sh {config[SCRIPTS]}reads_count.sh {output} {input.cut_fastq}'
