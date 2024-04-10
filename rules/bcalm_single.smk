rule bcalm: 
        input: 
                 cut_fastq = config["RESULTS"] + "Trimming/{sra}_cutadapt.fastq.gz"
        output: 
                 config["RESULTS"] + "BCALM/{sra}_cutadapt.unitigs.fa"
        threads : 16
        conda : "../envs/bcalm.yml" 
        message:
                 " RUNNING BCALM "
        params: 
                 dir= config["RESULTS"] + "BCALM",
                 kmer_size = config["KMER_SIZE"],
                 abundance = config["ABUNDANCE_MIN"], 
                 conda= "bcalm",
                 out = config["RESULTS"] + "BCALM/{sra}_cutadapt"     
        shell: 
                 #"set +eu && "
                 #". $(conda info --base)/etc/profile.d/conda.sh ;"
                 #" conda activate {params.conda} ;" 
                 " bcalm -in {input.cut_fastq} -kmer-size {params.kmer_size} -abundance-min {params.abundance} -out-dir {params.dir} -nb-cores 8 -out {params.out} "


