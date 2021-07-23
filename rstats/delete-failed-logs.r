#!/usr/bin/env Rscript

require(dplyr)


args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 1) {
  stop("\ngive log directory as sole argument", call. = FALSE)
}

dlog <- args[1]

flog <- dlog %>% dir(".log$", full.names = TRUE)
nlog <- flog %>% length()

log <- "character" %>% vector(nlog)

for (i in 1:nlog) {
    log[i] <- flog[i] %>%
        readLines() %>%
        paste(collapse = " ")
}


status <- rep("Error", nlog)
status[grep("Success", log)]      <- "Success"
status[grep("Skip", log)]         <- "Too cloudy"
status[grep("coreg failed", log)] <- "Coregistration failed"
status <- status %>% as.factor()
nfail <- sum(status == "Error")

print(nfail)

if (nfail > 0) {

    from <- flog[status == "Error"]
    to   <- gsub(".log$", ".fail", from)
    print(from)
    print(to)
    file.rename(from, to)

}
