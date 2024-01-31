# GCP: Traitement des fichiers SRR

Ce projet se concentre sur le traitement des données SRR au sein d'une instance VM sur Google Cloud Platform.

## Importation du répertoire

Connectez-vous à votre instance VM.

Téléchargez le contenu du référentiel GitHub sur votre machine en utilisant la commande `git clone` :

```bash
git clone https://github.com/Fadwa7/GCP.git
```

## Installation des outils

Pour configurer les outils requis dans votre machine virtuelle, exécutez le script suivant en donnant le chemin vers le répertoire contenant les fichier yml.

```bash
source installation.sh  ~/GCP/envs
```

## Exécution de Snakemake 

### Activation de l'environnement conda pour Snakemake 

Activez l'environnement conda pour Snakemake en utilisant la commande :

```bash
source activate snakemake
```
### Exécution du Snakemake 
Naviguez vers le répertoire du projet, puis exécutez Snakemake :
```bash
cd GCP
snakemake -s snakefile --cores $nbcores --config sra_list=$path/to/sra_id_list/
```
## Résultats:
Une fois terminé, les résultats du traitement seront organisés de la manière suivante : 

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
