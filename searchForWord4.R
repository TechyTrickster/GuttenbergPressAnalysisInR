options(warn = -1)
options(readr.num_columns = 0)
args = commandArgs(trailingOnly = T)
#print(args[2])
table = read.table(args[2], sep = ",")


searchWord = tolower(args[1])
fileName = tools::file_path_sans_ext(basename(args[2])) #calculate the number of times the word appears in the title
index = stringr::str_replace_all(fileName, '-8', "")
index = stringr::str_replace_all(index, '-0', "")
index = stringr::str_replace_all(index, '-1', "")
index = stringr::str_replace_all(index, ".txt.processed", "")

countInBody = sum(as.integer(table$V2[which(table$V1 == searchWord)])) #the sum is there to make sure that we don't get a null result when the word isn't found in the body.
output = paste0(index, ":", countInBody) #reference a pre made frequency table to find the number of times the word appears in the body

cat(output, sep = "\n")

