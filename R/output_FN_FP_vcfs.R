#!/usr/bin/env Rscript

library(StructuralVariantAnnotation)
library(rtracklayer)
library(argparser)


argp = arg_parser("Filters a raw GRIDSS VCF into somatic call subsets.")
argp = add_argument(argp, "--truth", default="", help="Truth VCF")
argp = add_argument(argp, "--input", default="", help="Input VCF")
argp = add_argument(argp, "--outputFP_VCF", default="", help="Output VCF with FPs")
argp = add_argument(argp, "--outputFN_VCF", default="", help="Output VCF with FNs")
argp = add_argument(argp, "--maxgap", default=16, help="See help(findBreakpointOverlaps)")
argp = add_argument(argp, "--sizemargin", default=100, help="See help(findBreakpointOverlaps)")
argp = add_argument(argp, "--restrictMarginToSizeMultiple", default=0.5, help="See help(findBreakpointOverlaps)")
#argv = parse_args(argp, argv=c("--truth", "../vcfs/colo829/truthset_somaticSVs_COLO829.vcf", "--input", "../vcfs/colo829/manta/colo829_1/workspace/svHyGen/somaticSV.0000.vcf"))
argv = parse_args(argp)

##truthVCF = "/Users/evanbiederstedt/cleanSV/vcfs/colo829/truthset_somaticSVs_COLO829.vcf"
##input_vcf = "/Users/evanbiederstedt/CleanSV/vcfs/colo829/manta/colo829_1/workspace/svHyGen/candidateSV.0000.vcf"
##outputFP_VCF = "/Users/evanbiederstedt/downloads/FPs_colo829_1_manta_candidateSV.0000.vcf"
##outputFN_VCF = "/Users/evanbiederstedt/downloads/FNs_colo829_1_manta_candidateSV.0000.vcf"

truthvcf = VariantAnnotation::readVcf(argv$truth)
truthbpgr = StructuralVariantAnnotation::breakpointRanges(truthvcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

vcf = VariantAnnotation::readVcf(argv$input)
vcfbpgr = StructuralVariantAnnotation::breakpointRanges(vcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

hits = findBreakpointOverlaps(vcfbpgr, truthbpgr, maxgap=argv$maxgap, sizemargin=argv$sizemargin, restrictMarginToSizeMultiple=argv$restrictMarginToSizeMultiple)

truthbpgr$vcfid = NA
truthbpgr$vcfid[subjectHits(hits)] = vcfbpgr$sourceId[queryHits(hits)]
vcfbpgr$truthid = NA
vcfbpgr$truthid[subjectHits(hits)] = vcfbpgr$sourceId[queryHits(hits)]

## FPs
## truthbpgr$vcfid

## FNs
## vcfbpgr$truthid

## output FP VCF
writeVcf(vcf[names(vcf) %in% truthbpgr$vcfid[!is.na(truthbpgr$vcfid)]], argv$outputFP_VCF)

## output FN VCF
writeVcf(vcf[names(vcf) %in% vcfbpgr$truthid[!is.na(vcfbpgr$truthid)]], argv$outputFN_VCF)


