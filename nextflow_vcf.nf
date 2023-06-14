nextflow.enable.dsl=2

params.vcf_files = "*.vcf"
params.destination = "output"
params.globals = ""
params.fasta = "$HOME/ref_fasta/ucsc.hg19.fasta"


//vcfsCh = Channel.fromPath(params.vcf_files, checkIfExists: true ).splitText(){ it -> [basename(it), it] }
def vcfCh = Channel.fromPath("${params.vcf_files}/*.vcf", checkIfExists: true , type: 'file').map ({ it -> [it.baseName, it] })
def fastaCh = Channel.value(params.fasta)

process create_vcf_gz { 
	tag { sample_name }
    module = "bcftools/1.16"
	publishDir("$params.destination/", mode: 'copy')
	debug = true
    input:
		tuple val(sample_name), path(vcf_path)
	output:
	//path("${sample_name}.annotated2.vcf")
		tuple val(sample_name), path("${sample_name}.chr2.vcf.gz"), path("${sample_name}.chr2.vcf.gz.csi")
	
    script:
    """
	bgzip -c ${sample_name}.vcf > ${sample_name}.vcf.gz
	bcftools index ${sample_name}.vcf.gz
	bcftools view ${sample_name}.vcf.gz --regions chr2 -Oz -o ${sample_name}.chr2.vcf.gz
	bcftools index  ${sample_name}.chr2.vcf.gz
	"""
}

process merge_vfcgz {
    //module = "any/bcftools/1.16"
	publishDir("$params.destination/", mode: 'copy')
	debug = true
	
	input:
		tuple val(group)
	output:
		path("merged.vcf.gz")
	
    script:
    """
	bcftools merge --file-list "${group}" -O b -o merged.vcf.gz
	"""

}
workflow { 
	//vcfCh.view()
	create_vcf_gz(vcfCh)
	//def combined_out = create_vcf_gz(vcfCh).collect()
	//combined_out.view()
	//chr2_files = combined_out.map { tuple ->
	//	tuple[1]
	//}
	//merge_vfcgz(chr2_files)
}