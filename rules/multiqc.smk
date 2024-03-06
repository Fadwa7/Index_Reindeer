
rule make_fastqc:
    input:
        config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz"
    output:
        temp(config["RESULTS"] + "QC/{sra}/{sra}_fastqc.zip"),
        temp(config["RESULTS"] + "QC/{sra}/{sra}_fastqc.html")
    log:
        config["RESULTS"] + "Supplementary_Data/Logs/{sra}.log"
    benchmark:
        config["RESULTS"] + "Supplementary_Data/Logs/{sra}_benchmark.txt"
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
         config["RESULTS"] + "Supplementary_Data/Logs/multifastqc/multifastqc.txt"
    params:
         outdir = config["RESULTS"] + "QC/",
         conda = "sratoolkit"
    shell:
      " set +eu &&"
      " . $(conda info --base)/etc/profile.d/conda.sh &&"
      "  conda activate {params.conda} && "
      " multiqc -f {input} -o {params.outdir} . > {log} 2>&1 "
