# Extracts a list of genes from a .vcf in the specified format and outputs
# them into a .gene file of the same directory as the input parameter file.
#
# ##fileformat=VCFv4.1
# ##GenomeAssembly=GRCh37/hg19
# ##INFO=<ID=GAD,Number=.,Type=Integer,Description="GAD id of the entries with overlapping chromsomal region.">
# ##PUBMED=<ID=PM,Number=.,Type=String,Description="Pubmed ids of the studies where GAD entries are reported.">
# ##DC=<ID=DC,Number=.,Type=String,Description="Distinct class of diseases for the reported entries.">
# ##GENE=<ID=GENE,Number=.,Type=String,Description="Genes associated with diseases.">
# #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    PUBMED  DC      GENE

class GeneListGenerator
  attr_reader :gene_list, :file
  
  def initialize(file)
    @file = file
    @gene_list = generate_gene_list(file)
  end
  
  def generate_gene_list(file)
    gene_list = File.read(file).split("\n").select{|line| !line.include?("#")}.map do |snp| 
      snp.split(" ").last.split("=").last.split(",").first
    end
    gene_list.uniq!
  end
  
  def to_f
    File.open(file + ".genes", 'w') {|f| f.write(gene_list.join("\n"))}
  end
end

gene_vcf_file = ARGV.first
gene_list_generator = GeneListGenerator.new(gene_vcf_file)
gene_list_generator.to_f