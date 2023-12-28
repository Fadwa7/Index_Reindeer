rule bcalm: 
     input: 
       cut_fastq = config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz"
     output: 
       config["RESULTS"] + "BCALM/{sra}_cutadapt.fastq.unitigs.fa"
     shadow: "full" 
     message:
       " RUNNING BCALM "
     params: 
       dir= config["RESULTS"] + "BCALM",
       kmer_size = config["KMER_SIZE"],
       abundance = config["ABUNDANCE_MIN"], 
       conda= "bcalm"
     log: 
       config["RESULTS"] + "Supplementary_Data/Logs/{sra}_bcalm.log" 
     benchmark:
       config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}_bcalm.txt"
     shell: 
       "set +eu && "
       ". $(conda info --base)/etc/profile.d/conda.sh ;"
       " conda activate {params.conda} ;"
       " cd {params.dir} ;" 
       "bcalm -in {input.cut_fastq} -kmer-size {params.kmer_size} -abundance-min {params.abundance}  -out-dir {params.dir} > {log} 2>&1 "
