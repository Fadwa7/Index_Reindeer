rule compressed_bcalm:
     input:
       config["RESULTS"] + "BCALM/{sra}_cutadapt.unitigs.fa"
     output:
       config["RESULTS"] + "BCALM/{sra}_cutadapt.unitigs.fa.gz"
     message: 
       " Compressing Bcalm output file {input}"
     shell:
       " gzip -c {input} > {output} ;"
       " rm {input}"  
