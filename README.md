# oligo-nf
Simple Nextflow pipeline for a SLURM cluster. $PWD is not used to ensure user views shell scripts.
## Relatedness analysis
This workflow will view chr2 from all input files. Merge into single VCF, run vcftools --relatedness2 over the merged file. Outputs a relatedness table: phi > 0.34 is possibly from the same sample. 
Usage, edit paths to point to own folder:

sbatch ./nextflow_vcf.nf

sbatch ./run_merge.sh

sbatch ./vcftools.sh

## VEP annotations
This pipeline can be modified to run on the UT HPC to 1) install an Ensembl VEP singularity container. 
Modifiy paths and uncomment install-vep.sh

Run with sbatch ./install-vep.sh

Modify paths in nextflow_vep.sh to point to a folder containing .VCF files.

Run with sbatch ./nextflow_vep.sh

