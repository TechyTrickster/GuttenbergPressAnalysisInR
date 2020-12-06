options(warn = -1)
options(readr.num_columns = 0)
args = commandArgs(trailingOnly = T)
table = read.table(args[3], sep = ",", header = T)
countries = read.table(args[2])

fileName = tools::file_path_sans_ext(basename(args[3])) #calculate the number of times the word appears in the title
index = stringr::str_replace_all(fileName, '-8', "")
index = stringr::str_replace_all(index, '-0', "")
index = stringr::str_replace_all(index, '-1', "")
index = stringr::str_replace_all(index, ".txt", "")

title = args[1]
titleWords = unlist(strsplit(tolower(title), " "))
countInTitle = length(na.omit(unlist(lapply(titleWords, match, table = countries$V1))))
countInBody = sum( table$Freq[na.omit( unlist(lapply(countries$V1, match, table = table$output  )) )])
#wordCount = sum(table$Freq[-1])
titleWordCount = length(titleWords)
output = paste0(index, ":", countInBody, ":", countInTitle, ":", titleWordCount) #reference a pre made frequency table to find the number of times the word appears in the body
cat(output)

