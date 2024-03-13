if config["SAMPLE"] == "single":
        rule reads_count:
                input:
                   cut_fastq = expand(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz", sra=SRA_LIST)
                output:
                   config["RESULTS"] + "Statistics/statistics.txt"
                shell:
                   'sh {config[SCRIPTS]}reads_count.sh {output} {input.cut_fastq}'


if config["SAMPLE"] == "paired":
	rule reads_count: 
                input: 
                   cut_fastq = expand(config["RESULTS"] + "Trimming/{sra}/{sra}_{reads}_cutadapt.fastq.gz", sra=SRA_LIST, reads=config["READS"])
                output:
                   config["RESULTS"] + "Statistics/statistics.txt"
                shell: 
                   "./scripts/reads_count.sh {output} {input.cut_fastq}" 
