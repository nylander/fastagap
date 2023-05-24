#!/usr/bin/env -S Rscript

# Plot heatmap from the output of 'fastagap.pl -c -H *.fas'
# Last modified: ons maj 24, 2023  03:18
# Sign: JN
# Thanks to: Martin Sköld for code solutions.
# Source: https://github.com/nylander/fastagap
# License: Distributed under the MIT license

columns <- c(1, 4, 13)
column_names <- c("sample", "ratio", "locus")
low_col <- "darkblue"
high_col <- "white"
cex <- 0.9
plot_width <- 15
plot_height <- 10

packages <- c("ggplot2", "tidyr")
package.check <- lapply(
    packages,
    FUN = function(x) {
        if (!suppressPackageStartupMessages(require(x, character.only = TRUE))) {
            stop("Error: package ", x, " is not available")
        } else {
            suppressPackageStartupMessages(library(x, character.only = TRUE))
        }
    }
)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
    stop("Error: No input", call. = FALSE)
}

if ("-h" %in% args || "--help" %in% args) {
    cat("Plot missing data in output from fastagap.pl -c -H", "\n")
    cat("Usage: plot_missing_data.R infile.tsv", "\n")
    cat("Output: PDF file ending in .missing_data.pdf", "\n")
    quit(save = "no")
}

infile <- args[1]
outfile <- paste0(basename(infile), ".missing_data.pdf")

cat("Reading file ", infile, "... ", sep = "")

df <- read.table(infile, header = FALSE)[, columns]
colnames(df) <- column_names
df$locus <- as.character(df$locus)

df <- tidyr::complete(data = df, locus, sample, fill = list(ratio = 1))

pdf(outfile, width = plot_width, height = plot_height)

ggplot2::ggplot(data = df,
                aes(x = locus, y = sample, fill = ratio)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_gradient('Missing',
                                 limits = c(0, 1),
                                 low = low_col,
                                 high = high_col) +
    ggplot2::theme(axis.text.x = element_blank(),
                   axis.ticks.x = element_blank(),
                   axis.text.y = element_text(size = rel(cex))) +
    ggplot2::labs(x = "Locus",
                  y = "Sample name")

invisible(dev.off())

if (file.exists(outfile)) {
    cat("done.\nCheck output file: ", outfile, "\n", sep = "")
} else {
    stop("Error: could not write outfile\n")
}

q(status = 0)

