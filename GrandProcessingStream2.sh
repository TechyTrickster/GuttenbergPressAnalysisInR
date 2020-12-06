#make sure that the R packages readr, stringr, and stringi are loaded on whatever is running this processes
inputBook="$4"
bookBaseName="$(basename "$4")"
preprocessedDirectory="$1"
frequencyTableDirectory="$2"
countryNamesFile="$3"
preprocessedBook="$preprocessedDirectory/$bookBaseName.processed"
wordFreqTable="$frequencyTableDirectory/$bookBaseName.freq"


cat "$inputBook" |  tr "[:upper:]" "[:lower:]" | sed -r '1,/\*\*\* ?start of (this|the) project gutenberg ebook/d' | sed -r '/end of (this|the) project gutenberg ebook/q' | sed '/project gutenberg/d'  | sed '/^[[:space:]]*$/d'  > "$preprocessedBook"
Rscript wordFreqGenerator.R "$preprocessedBook" "$wordFreqTable"
title="$(grep -m 1 "Title: " "$inputBook" | sed 's/Title: //g' | sed 's///g' | sed 's/:/;/g')"
author="$(grep -m 1 "Author: " "$inputBook" | sed 's/Author: //g' | sed 's///g' | sed 's/:/;/g')"
counts1=$(Rscript lengths2.R $preprocessedBook)
counts2=$(Rscript lengths2.R $inputBook)
countryStuff="$(Rscript searchForCountries2.R "$title" "$countryNamesFile" "$wordFreqTable")"
echo "$inputBook:$preprocessedBook:$wordFreqTable:$countryStuff:$counts1:$counts2:$author:$title"
