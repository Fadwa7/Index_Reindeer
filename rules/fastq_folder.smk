if config['SAMPLE'] == "single":
	rule fetch_fastq:
                input: 
                        config["FASTQ_FILES"]
                output:
                        temp(config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz")
                log:
                        config["RESULTS"] + "Supplementary_Data/Logs/SRATOOLKIT/{sra}.sratoolkit.log"
                benchmark:
                        config["RESULTS"] + "Supplementary_Data/Benchmark/SRATOOLKIT/{sra}.sratoolkit.txt"
                params:
                        config["RESULTS"] + "Fastq_Files/"
                shell:
                      " mkdir -p {params} ;"
                      "ln -s {input}/*.fastq.gz {params}"

else:
	rule fetch_fastq:
                input: 
                        config["FASTQ_FILES"]
                output:
#                         fastq_1 = storage.gcs(expand("gs://ssfa_project/{sra}_1.fastq.gz", sra=SRA_LIST)),
#                         fastq_2 = storage.gcs(expand("gs://ssfa_project/{sra}_2.fastq.gz", sra=SRA_LIST))
                        fastq_1 = temp(config["RESULTS"] + "Fastq_Files/{sra}_1.fastq.gz"),
                        fastq_2 = temp(config["RESULTS"] + "Fastq_Files/{sra}_2.fastq.gz")
                log:
                        config["RESULTS"] + "Supplementary_Data/Logs/SRATOOLKIT/{sra}.sratoolkit.log"
                benchmark:
                        config["RESULTS"] + "Supplementary_Data/Benchmark/SRATOOLKIT/{sra}.sratoolkit.txt"
                params: 
                        config["RESULTS"] + "Fastq_Files/"
                threads: 16
                shell:
                       "mkdir -p {params} ;"
                       " ln -s {input}/*_1.fastq.gz {params} ;"
                       " ln -s {input}/*_2.fastq.gz {params}"


