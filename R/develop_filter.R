# This files is used for experimenting and evaluating the performance of potential filters
library(StructuralVariantAnnotation)
library(tidyverse)


colo829_truth="/Users/evanbiederstedt/cleansv/vcfs/colo829/truthset_somaticSVs_COLO829.vcf"
colo829_vcfs = c(
	"truth"=colo829_truth,
	"gridss"="/Users/evanbiederstedt/cleansv/vcfs/colo829/gridss/gridss294.colo829.somatic.vcf",
	"manta"="/Users/evanbiederstedt/cleansv/vcfs/colo829/manta/colo829_1/workspace/svHyGen/somaticSV.0000.vcf",
	"novobreak"="/Users/evanbiederstedt/cleansv/vcfs/colo829/novobreak/colo829_1/novoBreak.pass.flt.vcf",
	"svaba"="/Users/evanbiederstedt/cleansv/vcfs/colo829/svaba/colo829_1/colo829_1.svaba.somatic.sv.vcf")


load_breakpoints = function(caller, file) {
	vcf = readVcf(file)
	# make sure names are unique
	names(vcf)[duplicated(names(vcf))] = paste0("record_", seq_along(names(vcf)))[duplicated(names(vcf))]
	bpgr = breakpointRanges(vcf)
	bpgr$caller=caller
	return(bpgr)
}


bpgr = unlist(GRangesList(lapply(names(colo829_vcfs), function(caller) load_breakpoints(caller, colo829_vcfs[caller]))))
# calculate truthiness
truthbpgr=breakpointRanges(readVcf(colo829_truth))

bpgr$tp = FALSE
bpgr$tp[queryHits(findBreakpointOverlaps(bpgr, truthbpgr, maxgap=16, sizemargin=200, restrictMarginToSizeMultiple=0.25))] = TRUE


ggplot(as.data.frame(bpgr)) + 
	aes(x=caller, fill=tp) +
	geom_bar() +
	labs(title="Raw caller performance")

ggsave(filename="/Users/evanbiederstedt/downloads/raw_caller_performance.pdf", device="pdf")
dev.off()

ggplot(as.data.frame(bpgr)) + 
	aes(x=caller, fill=tp) +
	facet_wrap(~FILTER) +
	geom_bar() +
	labs(title="Caller-defined filter performance")

ggsave(filename="/Users/evanbiederstedt/downloads/calledDefinedFilters_performance.pdf", device="pdf")
dev.off()


# Filter #1: GRIDSS PON
harwig_hg19_pon = import("/Users/evanbiederstedt/cleansv/R/extdata/Hartwig/hg19/pon3792v1/gridss_pon_breakpoint.bedpe.gz", "bedpe")
harwig_hg19_pon_bpgr = pairs2breakpointgr(harwig_hg19_pon)

bpgr$Hartwig_PON = FALSE
bpgr$Hartwig_PON[queryHits(findBreakpointOverlaps(bpgr, harwig_hg19_pon_bpgr))] = TRUE

ggplot(as.data.frame(bpgr)) + 
	aes(x=caller, fill=tp) +
	facet_wrap(~ Hartwig_PON) +
	geom_bar() +
	labs(title="Performance: Filter with Hartwig panel of normals (PoN)")


ggsave(filename="/Users/evanbiederstedt/downloads/HartwigFilters_performance.pdf", device="pdf")
dev.off()


library(biomartr)
## rmskdf = read_rm("/Users/evanbiederstedt/Downloads/rmsk")
rmskdf = read_rm("/Users/evanbiederstedt/Downloads/rmsk.bed")


rmskgr = with(rmskdf, GRanges(
	seqnames=qry_id,
	ranges=IRanges(start=qry_start, end=qry_end),
	strand=ifelse(matching_repeat=="+", "+", "-"),
	repeatType=repeat_id,
	repeatClass=matching_class))

seqlevelsStyle(rmskgr) = "NCBI"
bpgr$rmsk = ""
hits = findOverlaps(rmskgr, bpgr)
bpgr$rmsk[subjectHits(hits)] = rmskgr$repeatClass[queryHits(hits)]

ggplot(as.data.frame(bpgr)) + 
	aes(x=caller, fill=tp) +
	facet_wrap(~ rmsk) +
	geom_bar() +
	labs(title="RepeatMasker classification performance")







rmskdf$sw_score = as.numeric(rmskdf$sw_score)
rmskdf$perc_div =as.numeric(rmskdf$perc_div)

rmskgr = with(rmskdf, GRanges(
	seqnames=qry_id,
	ranges=IRanges(start=sw_score, end=perc_div),
	strand=ifelse(matching_repeat=="+", "+", "-"),
	repeatType=repeat_id,
	repeatClass=matching_class))










