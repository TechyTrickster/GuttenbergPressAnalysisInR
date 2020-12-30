library(readr)
library(cluster)
library(fpc)
library(stringr)

normalize <- function(x){
  return ((x-min(x))/(max(x)-min(x)))
}

#poor quality token generation has hampered the accuracy of many of the data points, but we didn't have much time to write better token
#generation code, or the time to run it.  average run time for each book was already over 5 seconds.
#load and clean the data

theNames = c("inputBook", "processedBook", "wordFrequencyTable", "index", "countInBody", "countInTitle", "titleWordCount")
theLengthsA = c("lineCountA", "nonBlanksCountA", "wordCountA", "sentenceCountA", "bytesA", "averageWordLengthA", "averageSentenceLengthA", "averageLineLengthA", "averageWordsPerSentenceA", "largestWordA", "longestSentenceA")
theLengthsB = c("lineCountB", "nonBlanksCountB", "wordCountB", "sentenceCountB", "bytesB", "averageWordLengthB", "averageSentenceLengthB", "averageLineLengthB", "averageWordsPerSentenceB", "largestWordB", "longestSentenceB")
theTail = c("author", "title")
theColumns = c(theNames, theLengthsB, theLengthsA, theTail)
GrandColumns = read_delim("GrandColumns.csv", delim = ":", col_names = theColumns)
GrandColumns = GrandColumns[complete.cases(GrandColumns),]

#compare word count of all the books to their title word count
titleToBodyLengthModel = lm(GrandColumns$wordCountA ~ GrandColumns$titleWordCount)
print(summary(titleToBodyLengthModel))

#compare the number of country name mentions in a books body with its title
countryInTitleList = GrandColumns[which(GrandColumns$countInTitle > 0),]
countryNotInTitleList = GrandColumns[which(GrandColumns$countInTitle == 0),]
hasCountryProp = countryInTitleList$countInBody / countryInTitleList$wordCountA
hasNoCountryProp = countryNotInTitleList$countInBody / countryNotInTitleList$wordCountA
countryTests = t.test(hasCountryProp, hasNoCountryProp)
print(countryTests)

#a simple line to plot the distribution of word counts
hist(GrandColumns$lineCountB[which(GrandColumns$lineCountB < 40000)], main = "word counts of books", xlab = "word count", col = c(2,3))
hist(GrandColumns$longestSentenceB[which(GrandColumns$longestSentenceB < 2000)], main = "longest sentences", xlab = "sentence length", col = c(3,4))
hist(GrandColumns$largestWordB[which(GrandColumns$largestWordB < 200)], main = "largest words", xlab = "word length", col = c(4,5))

#give a panel of basic book statisitcs
#sentence lengths
authorTable = table(GrandColumns$author)
cat(paste0("number of books in the data set: ", dim(GrandColumns)[1], "\n"))
cat(paste0("number of columns: ", dim(GrandColumns)[2], "\n"))
#print(paste0("max sentence length in words: ", max(GrandColumns$longestSentenceB[which(GrandColumns$longestSentenceB < 10000)])))
cat(paste0("average words per sentence: ", round(mean(GrandColumns$averageWordsPerSentenceB)), "\n"))
cat(paste0("author with the most published books: ",  names(authorTable[-9222][-631][which.max(authorTable[-9222][-631] )]), " ", authorTable[-9222][-631][which.max(authorTable[-9222][-631] )], "\n"))
cat(paste0("the longest book: ", GrandColumns$title[which.max(GrandColumns$bytesA)], "\n"))
cat(paste0("average difference is file size between preprocessing steps: ", round(mean(GrandColumns$bytesA - GrandColumns$bytesB)), "\n"))
cat(paste0("average largest token (word-ish) size: ", round(mean(GrandColumns$largestWordB)), "\n"))
cat(paste0("average title length (in words): ", round(mean(GrandColumns$titleWordCount)), "\n"))
cat(paste0("total number of words in the set: ", sum(GrandColumns$wordCountB), "\n"))
cat(paste0("average number of words per book: ", round(sum(GrandColumns$wordCountB) / dim(GrandColumns)[1]), "\n"))
cat(paste0("number of books with an unknown author: ", sum(authorTable[order(authorTable, decreasing = TRUE)][c(1,2,4)]), "\n"))



countsO= data.frame(GrandColumns$countInBody, GrandColumns$countInTitle)
counts = data.frame(normalize(GrandColumns$countInBody), normalize(GrandColumns$countInTitle))
cat(paste0("min in adjusted set: ", min(counts), "\n"))
cat(paste0("max in adjusted set: ", max(counts), "\n"))
counts2 = counts[which(counts$normalize.GrandColumns.countInBody < 100),]
countsO2 = countsO[which(countsO$GrandColumns.countInBody < 100),]
countCluster= kmeans(as.matrix(counts2), centers = 10,  iter.max = 30)
plot(countsO2, ylab = "count in title", xlab = "count in body", col = countCluster$cluster)
plotcluster(counts2, countCluster$cluster, ylab = "count in title", xlab = "count in body")
#print(paste0("books without an author: ", ))





#authorPlusLength = kmeans(authorPlusLength, centers = 10, iter.max = 30)
theIndexes = c()
#turn author names into numbers
for(x in seq(1, dim(GrandColumns)[1], 1))
{
  index = which(row.names(authorTable) == GrandColumns[x,]$author)
  theIndexes = c(theIndexes, index)
}

cat("made index of authors\n")
authorPlusLength = data.frame(theIndexes, GrandColumns$wordCountB)
authorPlusLengthTrim = authorPlusLength[which(authorPlusLength$GrandColumns.wordCountB < 80000),]
authorPlusLengthTrim2 = authorPlusLengthTrim[unlist(lapply(authorPlusLengthTrim$theIndexes, is.element, set = authorTable[which(authorTable > 5)])),]
cat("subseted data\n")
authorCluster = kmeans(authorPlusLengthTrim2, centers = 40, iter.max = 50)
plot(authorPlusLengthTrim2, col = authorCluster$cluster, xlim = c(0, 100), main = "author vs word count", xlab = "author index", ylab = "word count")




titlePlusLength = data.frame(str_length(GrandColumns$title), GrandColumns$bytesB)
titleLengthCluster = kmeans(titlePlusLength, centers = 30, iter.max = 30)
plot(titlePlusLength, col = titleLengthCluster$cluster, xlim = c(0,30), ylim = c(0,99999), main = "title length vs file length", xlab = "title length", ylab = "file length")



sentenceLengthVsentenceCount = data.frame(GrandColumns$averageSentenceLengthB, GrandColumns$sentenceCountB)
sentenceCluster = kmeans(sentenceLengthVsentenceCount, centers = 30, iter.max = 30)
plot(sentenceLengthVsentenceCount, col = sentenceCluster$cluster, xlim = c(0,800), ylim = c(0, 10000), main = "average sentence length vs sentence count", xlab = "average sentence length", ylab = "sentence count")