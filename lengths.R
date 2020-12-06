args = commandArgs(trailingOnly = T)
original = readr::read_file(args[1])
preprocessed = readr::read_file(args[2])

oLines = strsplit(original, sep = '\n')
pLines = strsplit(preprocessed, sep = '\n')
oWords = strsplit(original, sep = ' ')
pWords = strsplit(preprocessed, sep = ' ')
oBytes = sum(nchar(oLines))
pBytes = sum(nchar(pLines))

row = paste0(oLines, ":", oWords, ":", oBytes, ":", pLines, ":", pWords, ":", pBytes)
cat(row)
