#!/usr/bin/env Rscript
library(StructuralVariantAnnotation)
library(rtracklayer)
library(argparser)
argp = arg_parser("Filters a raw GRIDSS VCF into somatic call subsets.")
argp = add_argument(argp, "--truth", default="", help="Truth VCF")
argp = add_argument(argp, "--input", default="", help="Input VCF")
argp = add_argument(argp, "--output", help="Output VCF")
#argv = parse_args(argp, argv=c("--truth", "../vcfs/colo829/truthset_somaticSVs_COLO829.vcf", "--input", "../vcfs/colo829/manta/colo829_1/workspace/svHyGen/somaticSV.0000.vcf", "--output", "colo829_manta_fp.vcf"))
argv = parse_args(argp)

truthvcf = VariantAnnotation::readVcf(argv$truth)
truthbpgr = StructuralVariantAnnotation::breakpointRanges(truthvcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)
#truthbegr = breakpointRanges(vcf, unpartneredBreakends=TRUE)
remove(truthvcf)

vcf = VariantAnnotation::readVcf(argv$input)
vcfbpgr = StructuralVariantAnnotation::breakpointRanges(vcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

hits = findBreakpointOverlaps(truthbpgr, vcfbpgr, maxgap=16, sizemargin=200, restrictMarginToSizeMultiple=0.5)
writeVcf(vcf[names(vcf) %in% vcfbpgr$sourceId[subjectHits(hits)]], argv$output)