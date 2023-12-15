rule fetch_fastq:
    output: 
        config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz"
    log: 
        config["RESULTS"] + "Supplementary_Data/Logs/{sra}.sratoolkit.log"
    benchmark: 
        config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}.sratoolkit.txt"
    message: 
       "fetch fastq from NCBI"
    params:
       conda = "sratoolkit" 
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
