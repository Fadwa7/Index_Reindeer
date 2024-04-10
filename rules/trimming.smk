if config['SAMPLE'] == "single":
	rule adapt_trimming:
                  input: 
                      fastq = config["RESULTS"] + "Fastq_Files/{sra}.fastq.gz"
                  output: 
                      cut_fastq = temp(config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz")
                  message: 
                      "Trimmig FASTQS" 
                  log: 
                      config["RESULTS"] + "Supplementary_Data/Logs/Trimming/{sra}_cutadapt.log"
                  benchmark: 
                      config["RESULTS"] + "Supplementary_Data/Benchmark/Trimming/{sra}_cutadapt.txt"
                  params:
                      #conda = "cutadapt",
                      adaptor= config["ADAPTER"]
                  threads: 8
                  conda: "../envs/cutadapt.yml"
                  shell: 
                      #set +eu &&
                      #. $(conda info --base)/etc/profile.d/conda.sh &&
                      #conda activate {params.conda} &&
                      """
                      cutadapt \
                      -j 8 -q 20 -m 20 --cores {threads} -o {output.cut_fastq} \
                      -a {params.adaptor} {input.fastq}  > {log} 2>&1 
                      """

if config['SAMPLE'] == "paired":
        rule adapt_trimming:
                  input:
                      R1 = config["RESULTS"] + "Fastq_Files/{sra}_1.fastq.gz",
                      R2 = config["RESULTS"] + "Fastq_Files/{sra}_2.fastq.gz"
                  output:
                      trim1 = temp(config["RESULTS"] + "Trimming/{sra}/{sra}_1_cutadapt.fastq.gz"),
                      trim2 = temp(config["RESULTS"] + "Trimming/{sra}/{sra}_2_cutadapt.fastq.gz")
                  message:
                      "Trimmig FASTQS"
                  log:
                      config["RESULTS"] + "Supplementary_Data/Logs/Trimming/{sra}_cutadapt.log"
                  benchmark:
                      config["RESULTS"] + "Supplementary_Data/Benchmark/Trimming/{sra}_cutadapt.txt"
                  #params:
                  #    conda = "cutadapt"
                  conda: "../envs/cutadapt.yml"                      
                  threads: 8
                  shell:
                      #set +eu &&
                      #. $(conda info --base)/etc/profile.d/conda.sh &&
                      #conda activate {params.conda} &&
                      """
                      cutadapt \
                      -j 8 -q 20 -m 20 --cores {threads} -o {output.trim1} -p {output.trim2} -a {config[ADAPTER_R1]} -A {config[ADAPTER_R2]} \
                      {input.R1} {input.R2}  > {log} 2>&1
                      """
