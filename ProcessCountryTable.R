args = commandArgs(trailingOnly = T)
options(readr.num_columns = 0)
options(warn = -1)
countryStuff = readr::read_delim(args[1], "\t", col_names= c("name", "adjective", "denomyn")) 

test = lapply(lapply(lapply(countryStuff, as.character), stringr::str_replace_all, pattern = "\\[.\\]", replacement = ""), stringr::str_replace_all, pattern = "/", replacement = " ")
test = lapply(test, tolower)
lengths = lapply(test, strsplit, split = " ")
aLength = which(lapply(lengths$adjective, length) != 1)
dLength = which(lapply(lengths$denomyn, length) != 1)
nLength = which(lapply(lengths$name, length) != 1)


names = test$name[-nLength]
denomyns = test$denomyn[-dLength]
adjectives = test$adjective[-aLength]
additionals = c("america", "americans", "usa", "britain", "uk")
theList = c(names, denomyns, adjectives, additionals)

theList = row.names(table(theList))
cat(theList, sep = "\n")
