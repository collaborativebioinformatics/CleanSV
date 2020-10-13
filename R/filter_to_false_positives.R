#!/usr/bin/env Rscript

library(StructuralVariantAnnotation)
library(rtracklayer)

truthVCF = "/Users/evanbiederstedt/cleanSV/vcfs/colo829/truthset_somaticSVs_COLO829.vcf"
inputVCF = "/Users/evanbiederstedt/cleanSV/vcfs/colo829/svaba/colo829_1/colo829_1.svaba.somatic.sv.vcf"
outputVCF = "/Users/evanbiederstedt/downloads/hits_colo829_1.svaba.somatic.sv.vcf"

truthvcf = VariantAnnotation::readVcf(truthVCF)
truthbpgr = StructuralVariantAnnotation::breakpointRanges(truthvcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)
#truthbegr = breakpointRanges(vcf, unpartneredBreakends=TRUE)
remove(truthvcf)

vcf = VariantAnnotation::readVcf(inputVCF)
vcfbpgr = StructuralVariantAnnotation::breakpointRanges(vcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

hits = findBreakpointOverlaps(truthbpgr, vcfbpgr, maxgap=16, sizemargin=200, restrictMarginToSizeMultiple=0.5)
writeVcf(vcf[names(vcf) %in% vcfbpgr$sourceId[subjectHits(hits)]], outputVCF)