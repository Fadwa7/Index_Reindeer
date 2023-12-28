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
     params:
        conda = "cutadapt"
     threads: 8
     shell: 
        """
        set +eu &&
        . $(conda info --base)/etc/profile.d/conda.sh &&
        conda activate {params.conda} &&
        cutadapt \
        -j 1 -q 20 -m 20 --cores {threads} -o {output.cut_fastq} \
        -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA {input.fastq}  > {log} 2>&1 
        """
