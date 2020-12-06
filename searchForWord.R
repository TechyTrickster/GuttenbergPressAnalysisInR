args = commandArgs(trailingOnly = T)
outputFolder = args[1]
#print(outputFolder)
input = unlist(strsplit(args[2], ":"))
theTitle = tolower(gsub("[\r]", "", input[2]))
wordFreq = read.table(input[1], sep = ",")

outputFile = unlist(strsplit(input[1], "/"))
homeFolder = paste0(paste0(outputFile[1:(length(outputFile) - 2)], "/"), collapse = '')
outputFile = outputFile[length(outputFile)]

outputFile = paste0(outputFile, ".grabed")

processed = stringr::str_replace_all(theTitle, '[_!.\r;:?\n()+=<>\\]\"{}\\[,]', " ")
processedMore = stringr::str_replace_all(processed, '--', " ")
titleStuff = strsplit(processedMore, " ")[[1]]

total = data.frame(matrix(ncol = 2, nrow = length(titleStuff)))
for(x in seq(1, length(titleStuff), 1))
{
	total[x,] =c(titleStuff[x], wordFreq$V2[which(wordFreq$V1 == titleStuff[x])])
}

write.csv(total, file = 
