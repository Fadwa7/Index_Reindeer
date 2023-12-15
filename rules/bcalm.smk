rule bcalm: 
     input: 
       cut_fastq = config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz"
     output: 
       table = config["RESULTS"] + "BCALM/{sra}_trim.fastq.h5" 
     params: 
       config["RESULTS"] + "BCALM/{sra}",
       kmer_size = config["KMER_SIZE"],
       abundance = config["ABUNDANCE_MIN"]
     params: 
       conda= "bcalm"
     log: 
       config["RESULTS"] + "Supplementary_Data/Logs/{sra}_bcalm.log" 
     benchmark:
       config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}_bcalm.txt"
     shell: 
       "set +eu && "
       ". $(conda info --base)/etc/profile.d/conda.sh ;"
       " conda activate {params.conda} ;" 
       "bcalm -in {input.cut_fastq} -kmer-size {params.kmer_size} -abundance-min {params.abundance}"
