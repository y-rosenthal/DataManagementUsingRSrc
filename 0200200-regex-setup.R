# Shared data and setup for regex chapter (single source)
source("createData-vecFruit-v001.R")
source("createData-vecAddresses-v001.R")
source("createData-famousQuotesDf-v001.R")
if (!require(stringr)) { install.packages("stringr"); library(stringr) }
sentences <- c("He said hi. She said bye. We went to the park.",
               "I like ice cream! Do you? Sue likes pizza.")
