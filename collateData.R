searchAndAdd = function(list, input, start) #need to implement this with a sorted masterList and use a more efficient search algorithm than linear.
{#if a word is already on the masterList, update its value, otherwise, add a new word to the list
	found = FALSE
	inputWord = paste0(input$output, "")
	quantity = input$Freq
	last = 0
	
#	print(start)	
#	index = which(list$words[start:dim(list)[1]] == inputWord)[1] + start - 1 #faster search
	index = which(list$words == inputWord)[1]

	if(is.na(index) == TRUE)
	{#append new word to the end of the list
		newEntry = data.frame(words = c(inputWord), count = c(quantity))
		#newEntry = lapply(newEntry$words, as.character)
		list = rbind(list, newEntry)
#		list = list[order(as.character(list$words)),]
#		list = list[order(list$words),]
		last = 0
	}
	else
	{#the word is already in the list, increment its value
		#print(index)
		#print(list$count[index])
		list$count[index] = list$count[index] + quantity
		last = index
	}

	return(list(list, last))
}




#get a file list, put it in filesList
#there needs to be a master list of different words and their frequencies, call it masterList
#load in a frequency file, call it data
#the first loop will cycle through different files
#the second loop will cycle through words within those files
#the third loop will add thoses words and their frequencies to the master file
args = commandArgs(trailingOnly = T)
inputFile = args[1]
fileList = read.table(inputFile)
masterList = matrix(ncol = 2, nrow = 999999)
masterList = as.data.frame(masterList)
names(masterList) = c("words", "count")
masterList[1,] = c("", 0)
print(masterList[1,])
masterList = data.frame(words = c(""), count = c(0))
for(z in seq(1, dim(fileList)[1], 1))
{
	#print(fileList[z,])
	print(paste0(fileList[z,], ""))
	data = read.table(paste0(fileList[z,], ""), header = T, sep = ",")
	searchLimit = 0
	for(x in seq(1, dim(data)[1], 1))
	{
		returnResult = searchAndAdd(masterList, data[x,], searchLimit)
		masterList = returnResult[[1]]
		searchLimit = returnResult[[2]]
	}
}

write.csv(masterList, paste0(args[1], ".list", row.names = F))



