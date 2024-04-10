if config['SAMPLE'] == "single":
	rule fetch_fastq:
                output:
                        temp(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz")
                log:
                        config["RESULTS"] + "Supplementary_Data/Logs/SRATOOLKIT/{sra}.sratoolkit.log"
                benchmark:
                        config["RESULTS"] + "Supplementary_Data/Benchmark/SRATOOLKIT/{sra}.sratoolkit.txt"
                message:
                        "fetch fastq from NCBI"
                params:
			outdir = config["RESULTS"] + "Fastq_Files"
                conda: 
                        "../envs/sratoolkit_parallel.yml"
                threads: 16
                shell:
                        #set +eu &&
                        #. $(conda info --base)/etc/profile.d/conda.sh &&
                        #conda activate {params.conda}
                        """              
                        prefetch {wildcards.sra}
                        parallel-fastq-dump \
                        --outdir {params.outdir} \
                        --gzip \
                        --sra-id {wildcards.sra} \
                        --threads {threads}
			"""


else:
	rule fetch_fastq:
                output:
#                         fastq_1 = storage.gcs(expand("gs://ssfa_project/{sra}_1.fastq.gz", sra=SRA_LIST)),
#                         fastq_2 = storage.gcs(expand("gs://ssfa_project/{sra}_2.fastq.gz", sra=SRA_LIST))
                        fastq_1 = temp(config["RESULTS"] + "Fastq_Files/{sra}_1.fastq.gz"),
                        fastq_2 = temp(config["RESULTS"] + "Fastq_Files/{sra}_2.fastq.gz")
                log:
                        config["RESULTS"] + "Supplementary_Data/Logs/SRATOOLKIT/{sra}.sratoolkit.log"
                benchmark:
                        config["RESULTS"] + "Supplementary_Data/Benchmark/SRATOOLKIT/{sra}.sratoolkit.txt"
                message:
                        "fetch fastq from NCBI"
                params:                        
                        outdir = config["RESULTS"] + "Fastq_Files"
                conda: 
                        "../envs/sratoolkit_parallel.yml"
                threads: 16
                shell:
                        #set +eu &&
                        #. $(conda info --base)/etc/profile.d/conda.sh &&
                        #conda activate {params.conda}
                        """
                        prefetch {wildcards.sra}
                        parallel-fastq-dump \
                        --outdir {params.outdir} \
                        --gzip \
			--split-3 \
                        --sra-id {wildcards.sra} \
                        --threads {threads}
                        """

