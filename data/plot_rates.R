
library(ggplot2)
library(data.table)

suppressPackageStartupMessages(library(argparser))

argp = arg_parser("Filters a raw GRIDSS VCF into somatic call subsets.")
argp = add_argument(argp, "--input", default="", help="*tsv with rates")
argp = add_argument(argp, "--pdf_percentage", default="", help="output pdf of barplot with percentages")
argp = add_argument(argp, "--pdf_counts", default="", help="output pdf of barplot with counts")
argv = parse_args(argp)

titlePlot = "GRIDSS somatic SVs: COLO829"

foo = fread(argv$input)

foobar = melt(foo, measure.vars = c("TP", "FN", "FP"))

# Stacked + percent
perc = ggplot(foobar, aes(fill=variable, y=value, x=1)) + geom_bar(position="fill", stat="identity") + 
    ggtitle(titlePlot) +  xlab("rates") + ylab("percentage")

pdf(argv$pdf_percentage)
print(perc)
dev.off()

# Minimal theme + blue fill color
p <- ggplot(data=foobar, aes(x=variable, y=value)) + 
geom_bar(stat="identity", fill="steelblue") + theme_minimal() + ggtitle(titlePlot) +
  xlab("rates") + ylab("events")


pdf(argv$pdf_counts)
print(p)
dev.off()