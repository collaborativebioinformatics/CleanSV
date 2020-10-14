#!/usr/bin/env Rscript

library(StructuralVariantAnnotation)
library(rtracklayer)
library(argparser)


truthVCF = "/Users/evanbiederstedt/CleanSV/vcfs/colo829/truthset_somaticSVs_COLO829.vcf"
input_vcf = "/Users/evanbiederstedt/CleanSV/vcfs/colo829/manta/colo829_1/workspace/svHyGen/candidateSV.0000.vcf"
outputFP_VCF = "/Users/evanbiederstedt/downloads/FPs_colo829_1_manta_candidateSV.0000.vcf"
outputFN_VCF = "/Users/evanbiederstedt/downloads/FNs_colo829_1_manta_candidateSV.0000.vcf"
outputTP_VCF = "/Users/evanbiederstedt/downloads/TPs_colo829_1_manta_candidateSV.0000.vcf"

truthvcf = VariantAnnotation::readVcf(truthVCF)
truthbpgr = StructuralVariantAnnotation::breakpointRanges(truthvcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

vcf = VariantAnnotation::readVcf(input_vcf)
# make sure names are unique
names(vcf)[duplicated(names(vcf))] = paste0("record_", seq_along(names(vcf)))[duplicated(names(vcf))]
vcfbpgr = StructuralVariantAnnotation::breakpointRanges(vcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

hits = findBreakpointOverlaps(vcfbpgr, truthbpgr, maxgap=16, sizemargin=100, restrictMarginToSizeMultiple=0.5)

truthbpgr$vcfid = NA
truthbpgr$vcfid[subjectHits(hits)] = vcfbpgr$sourceId[queryHits(hits)]
vcfbpgr$truthid = NA
vcfbpgr$truthid[queryHits(hits)] = truthbpgr$sourceId[subjectHits(hits)]

info(header(vcf)) = unique(as(rbind(as.data.frame(info(header(vcf))), data.frame(
	row.names=c("TP"),
	Number=c("1"),
	Type=c("String"),
	Description=c("VCF ID of matching record in the truth VCF"))),
	"DataFrame"))
info(vcf)$TP = NA
info(vcf[vcfbpgr$sourceId])$TP = vcfbpgr$truthid

## FPs
## truthbpgr$vcfid

## FNs
## vcfbpgr$truthid

## output FP VCF
writeVcf(vcf[names(vcf) %in% truthbpgr$vcfid[!is.na(truthbpgr$vcfid)]], argv$outputFP_VCF)

## output FN VCF
writeVcf(vcf[names(vcf) %in% vcfbpgr$truthid[!is.na(vcfbpgr$truthid)]], argv$outputFN_VCF)

## output TP VCF





