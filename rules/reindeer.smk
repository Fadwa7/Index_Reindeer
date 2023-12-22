import os


rule files_path:
	input: 
		expand(config["RESULTS"] + "BCALM/{sra}_cutadapt.fastq.unitigs.fa", sra=SRA_LIST)
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
		config["RESULTS"] + "REINDEER/files_path.txt"
	output:
		config["RESULTS"] + "REINDEER/{sra}_index_reindeer/reindeer_index.gz"
	params:
		conda = "bcalm",
		dir = config["RESULTS"] + "REINDEER/{sra}_index_reindeer"
	message: 
		" RUNNING REINDEER "
	log:
		config["RESULTS"] + "Supplementary_Data/Logs/{sra}_reindeer.txt"
	benchmark : 
		config["RESULTS"] + "Supplementary_Data/Benchmark/{sra}_reindeer.txt" 
	shell:
		"set +eu && "
		". $(conda info --base)/etc/profile.d/conda.sh ;"
		" conda activate {params.conda} ;"
		"~/REINDEER/Reindeer --index -f {input} -o {params.dir} > {log} 2>&1" 
