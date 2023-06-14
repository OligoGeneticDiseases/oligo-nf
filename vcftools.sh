#!/bin/bash
#SBATCH -J QTL_pca
#SBATCH -t 1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=5000

module load vcftools

vcftools --gzvcf "/gpfs/space/home/pata/output/merged.vcf.gz" --relatedness2 --out output/TSO_2020_relatedness2

