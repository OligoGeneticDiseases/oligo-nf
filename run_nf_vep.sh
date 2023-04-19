#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name="Nextflow based Ensembl VEP annotator (in a singularity container) of many .VCF files."
#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=4G
module load any/singularity/3.7.3
module load squashfs/4.4
module load nextflow


nextflow nextflow_vep.nf --resume \
    --vcf_files ~/study_data/TSO_2020/ \
    --destination output/study_data/TSO_2020/