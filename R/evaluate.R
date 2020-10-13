#!/usr/bin/env Rscript
library(StructuralVariantAnnotation)
library(rtracklayer)
library(argparser)
argp = arg_parser("Filters a raw GRIDSS VCF into somatic call subsets.")
argp = add_argument(argp, "--truth", default="", help="Truth VCF")
argp = add_argument(argp, "--input", default="", help="Input VCF")
argp = add_argument(argp, "--maxgap", default=16, help="See help(findBreakpointOverlaps)")
argp = add_argument(argp, "--sizemargin", default=100, help="See help(findBreakpointOverlaps)")
argp = add_argument(argp, "--restrictMarginToSizeMultiple", default=0.5, help="See help(findBreakpointOverlaps)")
#argv = parse_args(argp, argv=c("--truth", "../vcfs/colo829/truthset_somaticSVs_COLO829.vcf", "--input", "../vcfs/colo829/manta/colo829_1/workspace/svHyGen/somaticSV.0000.vcf"))
argv = parse_args(argp)

truthvcf = VariantAnnotation::readVcf(argv$truth)
truthbpgr = StructuralVariantAnnotation::breakpointRanges(truthvcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

vcf = VariantAnnotation::readVcf(argv$input)
vcfbpgr = StructuralVariantAnnotation::breakpointRanges(vcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

hits = findBreakpointOverlaps(vcfbpgr, truthbpgr, maxgap=argv$maxgap, sizemargin=argv$sizemargin, restrictMarginToSizeMultiple=argv$restrictMarginToSizeMultiple)

truthbpgr$vcfid = NA
truthbpgr$vcfid[subjectHits(hits)] = vcfbpgr$sourceId[queryHits(hits)]
vcfbpgr$truthid = NA
vcfbpgr$truthid[subjectHits(hits)] = vcfbpgr$sourceId[queryHits(hits)]


cat("True Positive breakpoints:", sum(!is.na(truthbpgr$vcfid)) / 2, "\n", sep="\t")
cat("False Negatives breakpoints:", sum(is.na(truthbpgr$vcfid)) / 2, "\n", sep="\t")
cat("False Positive breakpoints:", sum(is.na(vcfbpgr$truthid)) / 2, "\n", sep="\t")
cat("Single breakends have been ignored.\n")
