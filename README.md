# Génération d'index Reindeer à partir d'une liste de fichiers fastq sur Cloud ( Google Cloud Platform "GCP" et L'Institut Français de Bioinformatique "IFB")


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
Sur GCP , il est recommandé de redémarer le terminal pour activer "mamba init" et exécuter "mamba activate snakemake". 
Pas obligatoire dans le cas d'utilisation de VM IFB


### Exécution du Snakemake 
Naviguez vers le répertoire GCP, et avant d'exécuter le pipeline, veuillez modifier les paramètres sur le fichier "config.json".
Puis exécutez Snakemake :
```bash
cd GCP
snakemake -s snakefile --cores $nbcores 
```
## Résultats:
Une fois terminé, les résultats du traitement seront organisés de la manière suivante : 

```bash
.
├── BCALM
├── QC
│   ├── multiqc_data
│   └── multiqc_report.html
├── REINDEER
│   ├── files_path.txt
│   └── index_reindeer
├── Statistics
│   └── reads_count.txt
└── Supplementary_Data
    ├── Benchmark
    └── Logs
```
