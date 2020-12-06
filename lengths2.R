#estimates nonBlanks by disregarding any line with only one or two characters on it in the count.
args = commandArgs(trailingOnly = T)
options(warn = -1)
original = readr::read_file(args[1])
original = stringi::stri_enc_toutf8(original, validate = T)
#original = stringr::str_replace_all(original, pattern = '[_!\r;:?\n()+=<>\\]\"{}\\],]', replacement = "")
#get base variables
oLines = unlist(strsplit(original, split = '\n'))
oWords = unlist(strsplit(original, split = ' '))
oSentences = unlist(strsplit(original, split = '[.]'))
oBytes = stringr::str_length(original)

#manipulate the data
nonBlanks = oLines[which(lapply(oLines, nchar) > 2)]
lines = oLines[which(oLines != "")] #filter out empty elements
words = oWords[which(oWords != "")]
sentences = oSentences[which(oSentences != "")]
words = unlist(lapply(words, stringr::str_replace_all, pattern = '[_!.\r;:?\n()+=<>\\]\"{}\\],]', replacement = "")) #filter out extraneous characters
sentenceArrays = sapply(sentences, strsplit, split = " ")
sentenceLengths = unlist(unname(lapply(sentenceArrays, length))) #there might be some empty words left in sentence arrays
sentences = sentences[which(sentenceLengths > 1)]#but they're too hard to get at to be worth the effort.
sentenceLengths = sentenceLengths[which(sentenceLengths > 1)]
#filter out sentences with only one word, because more than likely, they are not actual sentences.

#get the lengths
lineCount = length(lines)
wordCount = length(words)
nonBlanksCount = length(nonBlanks)
sentenceCount = length(sentences)

#get the averages
wordLengths = unlist(lapply(words, nchar))
lineLengths = unlist(lapply(nonBlanks, nchar))
sentenceByteCounts = unlist(lapply(sentences, nchar))

averageWordLength = mean(wordLengths)
averageLineLength = mean(lineLengths)
averageSentenceLength = mean(sentenceByteCounts)
averageWordsPerSentence = mean(sentenceLengths)


#maxes
largestWord = max(wordLengths)
longestSentence = max(sentenceLengths)
#run distribution tests
#ks.test(
row = paste0(lineCount, ":", nonBlanksCount, ":", wordCount, ":", sentenceCount, ":", oBytes, ":", averageWordLength, ":", averageSentenceLength, ":", averageLineLength, ":", averageWordsPerSentence, ":", largestWord, ":", longestSentence)
#print(sentenceLengths)
cat(row)
