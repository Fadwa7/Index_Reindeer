#!/bin/bash

if [ $# -lt 2 ] ; then
    echo ""
    echo "usage: count_fastq.sh [output_file] [fastq_file1] <fastq_file2> ..|| *.fastq.gz"
    echo "counts the number of reads in a fastq file"
    echo ""
    exit 0
fi

output_file="$1"
shift

total_count=0  # Variable pour stocker la somme totale

echo "File Name | Reads Count" > "$output_file"

for i in "$@"; do
    if [ "$i" == *.gz ]; then
        lines=$(zcat "$i" | wc -l | cut -d " " -f 1)
    else
        lines=$(wc -l "$i" | cut -d " " -f 1)
    fi

    count=$((lines / 4))
    total_count=$((total_count + count))  # Ajouter le nombre de lectures de ce fichier à la somme totale

    echo "$i | $count" >> "$output_file"  # Écrire le nom du fichier et le nombre de lectures dans le fichier de sortie
done

echo "Total reads count is : $total_count" >> "$output_file"  # Écrire le nombre total de lectures à la fin du fichier de sortie
