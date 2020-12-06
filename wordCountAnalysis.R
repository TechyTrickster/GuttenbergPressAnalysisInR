library(ngram)
library(readr)
print("loaded libraries")
args = commandArgs(trailingOnly = T)
titles = read_delim(args[1], ":", escape_double = F, trim_ws = T, col_names = F)
body = read.table(args[2], sep = " ")
print("files")
body2 = body[order(body$V4),]
titles2 = titles[order(titles$X1),]
body3 = body2
print("loaded")
#body3 = body2[-31030,] #had to be removed because this book did not appear in the title search
titleLengths = unlist(lapply(titles2$X2, wordcount))
#verified by
sum(which((titles2$X1 == body3$V4) == F))
#which searches for mismatched titles between the files.  there were none
#and
sum(which(is.na(titles2)))
#and
sum(which(is.na(body3[,-5])))
#both of which return zero
model2 = lm(body3$V2 ~ titleLengths)
model1 = lm(body3$V1 ~ titleLengths)
model3 = lm(body3$V3 ~ titleLengths)

#print out details of all of the models
print(summary(model1))
print(summary(model2))
print(summary(model3))



