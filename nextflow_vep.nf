nextflow.enable.dsl=2

params.vcf_files = "*.vcf"
params.destination = "output"
params.globals = ""
params.fasta = "$HOME/ref_fasta/ucsc.hg19.fasta"


//vcfsCh = Channel.fromPath(params.vcf_files, checkIfExists: true ).splitText(){ it -> [basename(it), it] }
def vcfCh = Channel.fromPath("${params.vcf_files}/*.vcf", checkIfExists: true , type: 'file').map ({ it -> [it.baseName, it] })
def fastaCh = Channel.value(params.fasta)

process readVCFs { 
	tag { sample_name }
    container = "file:///$HOME/singularity_img/vep.sif"
	publishDir("$params.destination/", mode: 'copy')
	debug = true
    input:
		tuple val(sample_name), path(vcf_path)
		path(f_a)
	output:
	//path("${sample_name}.annotated2.vcf")
		tuple val(sample_name), path("${sample_name}.annotated2.vcf")
	
    script:
    """
	vep --dir $HOME/vep_data \
	  --cache --offline --format vcf --vcf --force_overwrite \
	  --input_file ${vcf_path} \
	  --output_file ${sample_name}.annotated2.vcf \
	  --assembly GRCh37 \
	  --fasta ${params.fasta} \
	--cache_version 108 \
	  --MAX_AF \
	--no_stats \
	  --use_given_ref \
	 --pick \
	 --canonical \
	  --fields IMPACT,SYMBOL,HGNC_ID,MAX_AF,MAX_AF_POPS
	
	"""
}

workflow { 
	vcfCh.view()
	fastaCh.view()
	readVCFs(vcfCh, fastaCh.collect())
	//readVCFs.out.collect().view()
	//Channel.fromPath("${params.vcf_files}").collect().view()
}
