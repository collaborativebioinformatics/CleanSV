install.packages(c("tidyverse", "argparser"))
if (!requireNamespace("BiocManager", quietly = TRUE))
	install.packages("BiocManager")
BiocManager::install(c("StructuralVariantAnnotation", "rtracklayer"))