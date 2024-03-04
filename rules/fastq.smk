rule fetch_fastq:
    output:
        temp(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz")
    log:
        config["RESULTS"] + "Supplementary_Data/Logs/{sra}.sratoolkit.log"
    benchmark:
        config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}.sratoolkit.txt"
    message:
       "fetch fastq from NCBI"
    params:
       conda = "sratoolkit",
       outdir = config["RESULTS"] + "Fastq_Files"
    threads: 16
    shell:
        """
        set +eu &&
        . $(conda info --base)/etc/profile.d/conda.sh &&
        conda activate {params.conda}
        prefetch {wildcards.sra}
        parallel-fastq-dump \
            --outdir {params.outdir} \
            --gzip \
            --sra-id {wildcards.sra} \
            --threads {threads}
        """

