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
                config["RESULTS"] + "REINDEER/files_path.txt"
        output:
                config["RESULTS"] + "REINDEER/index_reindeer/reindeer_index.gz"
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
                "~/REINDEER/Reindeer --index -f {input} -o {params.dir} > {log} 2>&1" 


dossier_local = config["RESULTS"] + "REINDEER/index_reindeer"

# Chemin du bucket GCS et du dossier de destination
bucket_gcs = config["BUCKETS"]

# Commande gsutil pour copier le contenu du dossier local vers GCS
commande_gsutil = f"gsutil -m cp -r {dossier_local}/* {bucket_gcs}"

# Exécution de la commande via subprocess
try:
    subprocess.run(commande_gsutil, shell=True, check=True)
    print(f"Le contenu de '{dossier_local}' a été copié avec succès vers '{bucket_gcs}'.")
except subprocess.CalledProcessError as e:
    print(f"Une erreur s'est produite : {e}")
