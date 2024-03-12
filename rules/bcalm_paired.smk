rule path_trimmed:
         input: 
                trim_1 = config["RESULTS"] + "Trimming/{sra}/{sra}_1_cutadapt.fastq.gz",
                trim_2 = config["RESULTS"] + "Trimming/{sra}/{sra}_2_cutadapt.fastq.gz" 
         output:
                temp(config["RESULTS"] + "BCALM/{sra}/{sra}.txt")
         params:
                conda = "bcalm",
                dir = config["RESULTS"] + "BCALM/{sra}/"
         run:
                with open(output[0], 'w') as outfile:
                        for file in input:
                                full_path = os.path.abspath(file)
                                outfile.write(full_path + '\n')
rule bcalm:
         input:
                config["RESULTS"] + "BCALM/{sra}/{sra}.txt"
         output:
                config["RESULTS"] + "BCALM/{sra}_cutadapt.unitigs.fa"
         threads : 16
         message:
                " RUNNING BCALM "
         params:
                dir= config["RESULTS"] + "BCALM",
                kmer_size = config["KMER_SIZE"],
                abundance = config["ABUNDANCE_MIN"],
                conda= "bcalm",
                out = config["RESULTS"] + "BCALM/{sra}_cutadapt"
              #log: 
                 #config["RESULTS"] + "Supplementary_Data/Logs/{sra}_bcalm.log" 
         benchmark:
                config["RESULTS"] + "Supplementary_Data/Benchmark/BCALM/{sra}_bcalm.txt"
         shell:
                "set +eu && "
                ". $(conda info --base)/etc/profile.d/conda.sh ;"
                " conda activate {params.conda} ;"
                " bcalm -in {input} -kmer-size {params.kmer_size} -abundance-min {params.abundance} -out-dir {params.dir} -nb-cores 8 -out {params.out} "
