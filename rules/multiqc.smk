if config['SAMPLE'] == "single":
	rule make_fastqc:
                  input:
                     config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz"
                  output:
                     temp(config["RESULTS"] + "QC/{sra}/{sra}_fastqc.zip"),
                     temp(config["RESULTS"] + "QC/{sra}/{sra}_fastqc.html")
                  log:
                     config["RESULTS"] + "Supplementary_Data/Logs/QC/{sra}_fastqc.log"
                  benchmark:
                     config["RESULTS"] + "Supplementary_Data/Benchmark/QC/{sra}_fastqc.txt"
                  params:
                     outdir = config["RESULTS"] + "QC/{sra}",
                     conda = "sratoolkit"
                  shell:
                     " set +eu &&"
                     " . $(conda info --base)/etc/profile.d/conda.sh &&"
                     "conda activate {params.conda} && "
                     " fastqc {input} --outdir {params.outdir} 2> {log}"

	rule multi_fastqc:
                  input: 
                     expand(config["RESULTS"] + "QC/{sra}/{sra}_fastqc.zip", sra=SRA_LIST)
                  output: 
                     config["RESULTS"] + "QC/multiqc_report.html"
                  log: 
                     config["RESULTS"] + "Supplementary_Data/Logs/QC/multifastqc.txt"
                  benchmark: 
                     config["RESULTS"] + "Supplementary_Data/Benchmark/QC/multifastqc.txt"
                  params:
                     outdir = config["RESULTS"] + "QC/",
                     conda = "sratoolkit"
                  shell:
                     " set +eu &&"
                     " . $(conda info --base)/etc/profile.d/conda.sh &&"
                     "  conda activate {params.conda} && "
                     " multiqc -f {input} -o {params.outdir} . > {log} 2>&1 "


if config['SAMPLE'] == "paired":
        rule make_fastqc:
                  input:
                     config["RESULTS"] + "Fastq_Files/{sra}_{reads}.fastq.gz",
                  output:
                     zip= temp(config["RESULTS"] + "QC/{sra}/{sra}_{reads}_fastqc.zip"),
                     html = temp(config["RESULTS"] + "QC/{sra}/{sra}_{reads}_fastqc.html")
                  log:
                     config["RESULTS"] + "Supplementary_Data/Logs/QC/{sra}_{reads}_fastqc.log"
                  benchmark:
                     config["RESULTS"] + "Supplementary_Data/Benchmark/QC/{sra}_{reads}.fastqc.txt"
                  params:
                     outdir = config["RESULTS"] + "QC/{sra}",
                     conda = "sratoolkit"
                  shell:
                     " set +eu &&"
                     " . $(conda info --base)/etc/profile.d/conda.sh &&"
                     "conda activate {params.conda} && "
                     " fastqc {input} --outdir {params.outdir} 2> {log}"

        rule multi_fastqc:
                  input:
                     expand(config["RESULTS"] + "QC/{sra}/{sra}_{reads}_fastqc.zip", sra=SRA_LIST, reads=config['READS'])
                  output:
                     config["RESULTS"] + "QC/multiqc_report.html"
                  log:
                     config["RESULTS"] + "Supplementary_Data/Logs/QC/multifastqc.txt"
                  benchmark: 
                     config["RESULTS"] + "Supplementary_Data/Benchmark/QC/multifastqc.txt"
                  params:
                     outdir = config["RESULTS"] + "QC/",
                     conda = "sratoolkit"
                  shell:
                     " set +eu &&"
                     " . $(conda info --base)/etc/profile.d/conda.sh &&"
                     "  conda activate {params.conda} && "
                     " multiqc -f {input} -o {params.outdir} . > {log} 2>&1 "
