

rule sra_prefetch:
    output: 
        temp(config["RESULTS"] + "Fastq_files/sra_prefetch/{sra}.sra")
    params:
        id = "{sra}",
        conda = "sratoolkit"
    threads : 2
    log: 
        config["RESULTS"] + "Supplementary_Data/Logs/prefetch/{sra}.prefetch.log"
    benchmark: 
        config["RESULTS"] + "Supplementary_Data/Benchmark/prefetch/{sra}.prefetch.txt"
    shell:
        """
        set +eu &&
        . $(conda info --base)/etc/profile.d/conda.sh &&
        conda activate {params.conda}
        prefetch {params.id} -o {output} &> {log}
        """



rule dump_sra:
    input: 
        config["RESULTS"] + "Fastq_files/sra_prefetch/{sra}.sra"
    output: 
        temp(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz")
    log: 
        config["RESULTS"] + "Supplementary_Data/Logs/dump_sra/{sra}.sratoolkit.log"
    benchmark: 
        config["RESULTS"] + "Supplementary_Data/Benchmark/dump_sra/{sra}.sratoolkit.txt"
    message: 
       "fetch fastq from NCBI"
    params:
       conda = "sratoolkit",
       outdir = config["RESULTS"] + "Fastq_Files" 
    threads: 2
    shell:
        """
        set +eu &&
        . $(conda info --base)/etc/profile.d/conda.sh &&
        conda activate {params.conda}
	fastq-dump \
		--split-spot \
		--skip-technical {wildcards.sra} \
		--stdout 2>{log} \
	| gzip -c > {output}
	"""
