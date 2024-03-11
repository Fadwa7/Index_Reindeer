import os
import subprocess

rule files_path:
        input: 
                expand(config["RESULTS"] + "BCALM/{sra}_cutadapt.unitigs.fa", sra=SRA_LIST) 
        output:
                config["RESULTS"] + "REINDEER/files_path.txt"
        params:
                conda = "bcalm",
                dir = config["RESULTS"] + "BCALM/"
        run:
                with open(output[0], 'w') as outfile:
                        for file in input:
                                full_path = os.path.abspath(file)
                                outfile.write(full_path + '\n')

rule reindeer: 
        input:
                paths = config["RESULTS"] + "REINDEER/files_path.txt"
        output:
                index = config["RESULTS"] + "REINDEER/index_reindeer/reindeer_index.gz"
        params:
                conda = "bcalm",
                dir = config["RESULTS"] + "REINDEER/index_reindeer"
        message: 
                " RUNNING REINDEER "
        log:
                config["RESULTS"] + "Supplementary_Data/Logs/reindeer.txt"
        benchmark : 
                config["RESULTS"] + "Supplementary_Data/Benchmark/reindeer.txt" 
        shell:
                "set +eu && "
                ". $(conda info --base)/etc/profile.d/conda.sh ;"
                " conda activate {params.conda} ;"
                "~/REINDEER/Reindeer --index -f {input.paths} -o {params.dir} > {log} 2>&1 ;"
