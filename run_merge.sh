#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name="Nextflow based bcftools index and filter down to chr2 of many .VCF files."
#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=16G

module load bcftools


bcftools merge -0 -o "/gpfs/space/home/pata/output/merged.vcf.gz" \
 --file-list "/gpfs/space/home/pata/output/study_data_chr2/TSO_2020_chr2/vcfs.list"
