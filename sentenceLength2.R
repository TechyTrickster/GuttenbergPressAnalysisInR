args = commandArgs(trailingOnly = T)
book = readr::read_file(args[1])
processed = stringr::str_replace_all(book, '[_!\r;:?\n()+=<>\\]\"{}\\[,]', " ")
output = unlist(strsplit(processed, "[.]"))
sentenceArrays = sapply(output, strsplit, split = " ")
lengths = unlist(unname(lapply(sentenceArrays, length)))
count = length(lengths)
summed = sum(lengths)
average = summed / count
print(lengths)
cat(average)

