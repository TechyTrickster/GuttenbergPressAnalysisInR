#library(stringr) #loading an entire package in a script is not great for performance, especially when you only need to use one or two functions from it.
#library(readr)
args = commandArgs(trailingOnly = T)
#print(args[1])
input = readr::read_file(args[1]) #just use double colon notation to call the needed functions directly.
processed = stringr::str_replace_all(input, '[_!.\r;:?\n()+=<>\\]\"{}\\[,]', " ")
processedMore = stringr::str_replace_all(processed, '--', " ")
output = strsplit(processedMore, " ")[[1]]
write.csv(table(output), args[2], row.names = F)
