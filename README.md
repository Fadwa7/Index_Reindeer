# GCP: Traitement des fichiers SRR

Projet du traitement des données SRR dans une instance VM sur Google Cloud Plateform.

## Importation de repertoire  
Connectez-vous sur votre VM.

Téléchargez le contenu du gitHub sur votre machine [git clone](https://github.com/Fadwa7/GCP.git).

```bash
https://github.com/Fadwa7/GCP.git
```

## Installation des outils

Pour installer les outils nécessaire dans votre machine virutelle, exécutez ce script, en respectant l'ordre des fichiers. 

```bash
./installation.sh   envs/bcalm.yml   envs/sratoolkit.yml   envs/cutadapt.yml   envs/snakemake.yml
```

## Exécution de Snakemake 

### Activation de l'environnement conda du Snakemake 

```bash
source activate snakemake
```
### Modification des paramètres sur config.yml 

Veuillez communiquer le numéro d'accesion de BioProject dont vous êtes intéressés ainsi que le chemin vers le dossier où les résultats seront stockés. 

```bash
nano config.yml
```
### Exécution du Snakemake 

```bash
cd GCP
snakemake -s snakefile --cores $nbcores
```
## Résultats:

```bash
.
├── BCALM
│   └── ${filename}_cutadapt.fastq.unitigs.fa
├── Fastq_Files
│   └── ${filename}.fastq.gz
├── REINDEER
|   └── ${filename}_index_reindeer
├── Supplementary_Data
│   ├── Benchmark
│   └── Logs
└── Trimming
    └── ${filename}_cutadapt.fastq.gz
```
