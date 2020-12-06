options(warn = -1)
options(readr.num_columns = 0)
args = commandArgs(trailingOnly = T)
table = read.table(args[3], sep = ",")
titles = readr::read_delim(args[1], ":", escape_double = F, trim_ws = T, col_names = F)

searchWord = tolower(args[2])
fileName = tools::file_path_sans_ext(basename(args[3])) #calculate the number of times the word appears in the title
index = stringr::str_replace_all(fileName, '-8', "")
index = stringr::str_replace_all(index, '-0', "")
index = stringr::str_replace_all(index, ".txt.processed", "")

title = titles$X2[which(titles$X1 == index)][1]
countInTitle = length(which(unlist(strsplit(tolower(as.character(title)), " ")) == as.character(args[2])))
countInBody = sum(as.integer(table$V2[which(table$V1 == searchWord)]))
output = paste0(args[3], ":", countInBody, ":", countInTitle, ":", searchWord, ":", title, ":", index) #reference a pre made frequency table to find the number of times the word appears in the body

print(output, max.levels=F)

