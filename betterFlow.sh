#assign variable names
bookRepo="$PWD/theData"
preprocessedDirectory="$PWD/preprocessed"
frequencyTableDirectory="$PWD/frequencyTables"
countryDoc="countryStuff.data"
countryData="countryNames.data"
fileParing1="input1.data"
fileParing2="input2.data"
fileParing3="input3.data"
fileParing4="fileStream.data"

echo "variables prepared"
rm -r preprocessed/
rm -r frequencyTables/
mkdir preprocessed/
mkdir frequencyTables/

echo "prepared folders"
#make fileList
grep -l -m 1 -r "Language: English" "$bookRepo" > $fileParing1
grep -HEl "START OF (THIS|THE) PROJECT GUTENBERG EBOOK" $(cat $fileParing1) > $fileParing2
cat $fileParing2 | sed '/readme/d' > $fileParing3
grep -Hal -m 1 "Title: " $(cat $fileParing3) > $fileParing4

echo "file stream generated"
#process country names
Rscript ProcessCountryTable.R "$countryDoc" > "$countryData"
echo "search terms generated"

#make GrandColumns.csv
echo "starting analysis"
cat $fileParing4 | parallel ./GrandProcessingStream2.sh  "$preprocessedDirectory" "$frequencyTableDirectory" "$countryData"  > GrandColumns.csv
#run analysis
##Rscript compareWordCountToTitleLength GrandColumns.csv
##Rscript countryAnalysis.R GrandColumns.csv
#it looks like i ran these two processes seperately, and i don't remember the inputs
#Rscript searchForCountriesAnalysis.R
#Rscript wordCountAnalysis.R
