library(readr)
countryFreq = read_delim("countryAnalysis.csv", delim = ":", col_names = c("file_index", "body_count", "title_count", "title", "wordCount", "titleWordCount"), quote = "")
countryInTitleList =  countryFreq[which(countryFreq$title_count > 0),]
noCountryInTitleList = countryFreq[which(countryFreq$title_count == 0),]
hasCountryProp = countryInTitleList$body_count / countryInTitleList$wordCount
hasNoCountryProp = noCountryInTitleList$body_count / noCountryInTitleList$wordCount
t.test(hasCountryProp, hasNoCountryProp)
#reject our null hypothesis, there is a substantial difference
#if a country name appears in the title of a book, it will
#appear with three times more frequency in the body 
