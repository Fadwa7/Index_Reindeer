#!/bin/bash

# Chemin du répertoire contenant les fichiers
reads_path="/home/ubuntu/GCP/Results/Trimming/"

# Nom du fichier TSV de sortie
output_tsv="/home/ubuntu/GCP/Results/Trimming/trimmed_reads_total.tsv"

# Supprimer le fichier TSV de sortie s'il existe déjà
rm -f "$output_tsv"

# Parcourir chaque nom de fichier et écrire dans le fichier TSV
for file in $reads_path*SRR*_cutadapt.fastq.gz; do
    # Extraire l'identifiant du fichier
    file_id=$(basename "$file" | cut -d '_' -f 1)

    # Écrire dans le fichier TSV
    echo "$file_id" >> "$output_tsv"
done

# Affichage du message lorsque le fichier TSV est créé
echo "Le fichier TSV $output_tsv a été créé avec succès !"
