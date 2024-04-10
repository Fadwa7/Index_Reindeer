#!/bin/bash

############# input variables #############

reads_path="/home/ubuntu/GCP/Results/Trimming/"
desc="/home/ubuntu/GCP/Results/Trimming/trimmed_reads_total.tsv"
threads=20
output_dir="/home/ubuntu/GCP/Results/Trimming/"

###############################################

output_dir="${output_dir}/"
output_dir=$(echo $output_dir | sed 's/\/\//\//g')

if [ ! -d $output_dir ];then mkdir -p $output_dir ;fi

# Directory of scripts for each sample (to be run in parallel)
sample_scripts_dir="${output_dir}/sample_scripts/"
if [ -d $sample_scripts_dir ]; then rm -rf $sample_scripts_dir; fi 
mkdir $sample_scripts_dir

output_file=${output_dir}total_kmers.txt

>${output_file}

out_files=()

while read line; do
    # Original ID of the sample
    fastq_ID=$(echo "${line}"|cut -f1)
    # Custom name of the sample
    sample=$(echo "${line}"|cut -f2)
    
    # Find the FASTQ file with "_cutadapt"
    fastq_file=$(find $reads_path -name "*${fastq_ID}*_cutadapt*fastq.gz")
    
    # If FASTQ file is not found, exit
    if [[ ! -f $fastq_file ]]; then
        echo -e "Reads for $fastq_ID ($sample) are not found !\n"
        exit 1
    fi
    
    echo -e "#!/bin/bash\n\n" >${sample_scripts_dir}${sample}_subscript.sh
    
    # Compute total kmers
    echo -e "nb_kmers=\$(zcat ${fastq_file} | grep -A 1 \"^@\" | egrep \"^[ATGC]\" | awk 'BEGIN{a=0}{a=a+(length(\$1)-31+1)}END{print a}')\n" >>${sample_scripts_dir}${sample}_subscript.sh
    
    echo -e "echo -e \"${sample}\\\t\${nb_kmers}\" >${output_file}${sample}_tot_kmers.txt" >>${sample_scripts_dir}${sample}_subscript.sh
    
    chmod 755 ${sample_scripts_dir}${sample}_subscript.sh
    
    out_files+=(${output_file}${sample}_tot_kmers.txt)
done < $desc

# Run the scripts in parallel
find ${sample_scripts_dir} -name "*_subscript.sh" | xargs -n 1 -P $threads bash || { echo "executing tot kmer computing failure !" 1>&2; exit 1; }

# Concatenate the individual outputs into the total file
for i in ${out_files[*]}; do
    cat $i >>${output_file}
done

echo -e "\n\n-> check ${output_dir}total_kmers.txt\n\n"
