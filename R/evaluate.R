#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(StructuralVariantAnnotation))
suppressPackageStartupMessages(library(argparser))
argp = arg_parser("Filters a raw GRIDSS VCF into somatic call subsets.")
argp = add_argument(argp, "--truth", default="", help="Truth VCF")
argp = add_argument(argp, "--input", default="", help="Input VCF")
argp = add_argument(argp, "--output", default="", help="Annotated input VCF")
argp = add_argument(argp, "--maxgap", default=16, help="Valid overlapping thresholds of a maximum gap position between breakend intervals. See help(findBreakpointOverlaps)")  
argp = add_argument(argp, "--sizemargin", default=100, help="Error margin in allowable size to prevent matching of events of different sizes, e.g. a 200bp event matching a 1bp event when maxgap is set to 200. See help(findBreakpointOverlaps)")
argp = add_argument(argp, "--restrictMarginToSizeMultiple", default=0.5, help="Size restriction multiplier on event size. The default value of 0.5 requires that the breakpoint positions can be off by at maximum, half the event size. See help(findBreakpointOverlaps)")
#argv = parse_args(argp, argv=c("--truth", "../vcfs/colo829/truthset_somaticSVs_COLO829.vcf", "--input", "../vcfs/colo829/novobreak/colo829_1/novoBreak.pass.flt.vcf", "--output", "test.vcf"))
argv = parse_args(argp)

truthvcf = VariantAnnotation::readVcf(argv$truth)
truthbpgr = StructuralVariantAnnotation::breakpointRanges(truthvcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

vcf = VariantAnnotation::readVcf(argv$input)
# make sure names are unique
names(vcf)[duplicated(names(vcf))] = paste0("record_", seq_along(names(vcf)))[duplicated(names(vcf))]
vcfbpgr = StructuralVariantAnnotation::breakpointRanges(vcf, unpartneredBreakends=FALSE, inferMissingBreakends=TRUE)

hits = findBreakpointOverlaps(vcfbpgr, truthbpgr, maxgap=argv$maxgap, sizemargin=argv$sizemargin, restrictMarginToSizeMultiple=argv$restrictMarginToSizeMultiple)

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

writeVcf(vcf, argv$output)
cat("True Positive breakpoints:", sum(!is.na(truthbpgr$vcfid)) / 2, "\n", sep="\t")
cat("False Negatives breakpoints:", sum(is.na(truthbpgr$vcfid)) / 2, "\n", sep="\t")
cat("False Positive breakpoints:", sum(is.na(vcfbpgr$truthid)) / 2, "\n", sep="\t")
cat("Single breakends have been ignored.\n")

