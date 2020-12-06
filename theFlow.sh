#NOTE: file 18251-mac.txt was deleted due to encoding issues


fastSentence()
{
	Rscript sentenceLength.R $1 | sed 's/\[1\]//g' | sed 's/\"//g' | sed 's/\/home\/theCore\/first_Analysis_Step\///g' | sed 's/-8//g' | sed 's/.txt.processed//g' | sed 's/-0//g'
}

theTitles() #make sure to make a new version of this that appends the file name to each title
{
	echo $2
	cat $2 | grep -H "Title: " >> $1
}

theNames()
{
	base=$(basename "$2")
	newFileName="$1/$base.processed"
	echo $newFileName
}


theStack() #the first argument to this function is an output folder, and the second one is a full path for the input file
{
	newFileName="$(theNames $1 $2)"
	cat $2 |  tr "[:upper:]" "[:lower:]" | sed -r '1,/\*\*\* ?start of (this|the) project gutenberg ebook/d' | sed -r '/end of (this|the) project gutenberg ebook/q' | sed '/project gutenberg/d'  | sed '/^[[:space:]]*$/d'  >> "$newFileName"
	echo $2
	#this pipeline gets rid of most of the undesired text.  hopefully, there will be later iterations that do better
}


onlyOneFile() #the first and only arguement is a full directory path, but never a file
{ #this will return only one file per directory that matches the patern of .txt at the end
	find $1 -maxdepth 1 | grep ".*txt$" | head -n1
}


generateFileList()
{
	find $(pwd) -type d | xargs -d '\n' -I{} bash -c "onlyOneFile 0{}" | sed '/readme/d'
}


theCount()
{
	newFileName="$1/$(basename $2).counted"
	echo "$2"
	echo $newFileName
	Rscript statsProject.R "$2" "$newFileName"
}

export -f theTitles
export -f theStack
export -f generateFileList
export -f onlyOneFile
export -f theNames
export -f theCount
export -f fastSentence

outputFolder1="first_Analysis_Step"
outputFolder2="second_Analysis_Step"
outputFile1="title_analysis.txt"
outputFile2="wordCounts.txt"
outputFile3="wordCount.txt"
outputFile4="titleVSwordcount.txt" #this is a summary output
outputFile5="titleBodyProp.txt"
outputFile6="averageSentenceLength.txt"
inputFile1="English.data"
inputFile2="Compatible.data"
inputFile3="NoReadMe.data"
inputFile4="HasTitles.data"


rm $inputFile1
rm $inputFile2
rm $inputFile3
rm $inputFile4
rm $outputFile1
rm $outputFile2
rm $outputFile3
rm $outputFile4
rm $outputFile5
rm $outputFile6
touch $outputFile1
rm -r $outputFolder1
mkdir $outputFolder1
#rm -r $outputFolder2
#mkdir $outputFolder2
#extract the books from the mirror
#generateFileList | parallel theNames $outputFolder1 > theNames.txt
#sort theNames.txt | uniq -c > theList.txt #verify that there is only one file per directory

#parallel <command> | <commmand> only makes the first command run in parallel.  need to roll these long command chains into functions to speed up run times.  should be simple... right?
#there are some redundent calculations.  work to remove them

grep -l -m 1 -r "Language: English" "$(pwd)/theData/" > $inputFile1 #get a list of books in the english language.
echo "english files found"
#grep -HEL "START OF (THIS|THE) PROJECT GUTENBERG EBOOK" $(cat $inputFile1) | wc -l #count all the unprocessable books, only 410, WOW!
#grep -HEL "Title: " $(cat $inputFile1) | wc -l #count all the files that don't have a title.
grep -HEl "START OF (THIS|THE) PROJECT GUTENBERG EBOOK" $(cat $inputFile1) > $inputFile2 #make a list of files that are cutable
echo "stage1"
cat $inputFile2 | sed '/readme/d' > $inputFile3 #remove all of the readme files that went with the audio books
echo "stage2"
grep -Hal -m 1 "Title: "  $(cat $inputFile3) > $inputFile4 #filter for books that have title metadata
#need to add a line to filter out books that don't have a title line
cat $inputFile4 | parallel grep -Ha -m 1 "Title: " | sed 's/Title: //g' | sed 's/:/;/2g' | sed -E 's/^M$//g' | sed 's/\/home\/theCore\/theData\///g' | sed 's/\.txt/ /g' | sed 's/-8//g' | sed 's/-0//g' > $outputFile1 #needs to be parameterized! #make a table describing file names with their actual titles
echo "titles found"
cat "$inputFile4" | parallel theStack $outputFolder1 #preprocess all of the books
grep -Ha "Title: " $(cat $inputFile4) | sed 's/\/home\/theCore\/theData\//\/home\/theCore\/second_Analysis_Step\//g' | sed -E 's/Title: //1g' | sed 's/:/;/2g' | sed -E 's/^M$//g' | sed 's/.txt/.txt.processed.counted/g' > $outputFile5 #generates a list of files and titles for use by the titles body proportion test...  NOT PARAMETERIZED!
echo "preprocessing completed"


find "$(pwd)/$outputFolder1" | parallel wc > $outputFile2 #generate a file describing all the files with word counts
sed '1d' $outputFile2 | awk '{$1=$1};1' | sed 's/\/home\/theCore\/first_Analysis_Step\///g'  | sed 's/\.txt.processed/ /g' | sed 's/-8//g' | sed 's/-0//g'  > $outputFile3 #remove the first line of outputFile2, because it doesn't have relevent data, and remove leading and trailing whitespace
#find $(pwd)/$outputFolder1 | parallel theCount $outputFolder2 #generate frequency lists for all the books
Rscript wordCountAnalysis.R $outputFile1 $outputFile3 > $outputFile4 #compare title length and book length
echo "words counted"
#find "$(pwd)/second_Analysis_Step" > processedFiles.data #generate the file list to be used by the collation process.
#cat $outputFile5 | parallel Rscript searchForWord > 
#find "$PWD/second_Analysis_Step" | parallel Rscript searchForWord3.R title_anaylsis.txt "america" | sed 's/\[1\]//g' | sed 's/\"//g' | sed 's/\/home\/theCore\/second_An\///g' | sed 's/-8//g' | sed 's/.txt.processed.counted//g' > hasAmerica.txt
echo "processed file list"
#split -l 5000 processedFiles.data
echo "processed file list split"
#ls x* | parallel collateData.R #join the files in each split together.
#need another step to join the resulting joins into one last file
#find | head -n1000 | parallel grep -w -m 1 | "france" | sed 's/^.*,//g' | jq -s 'add'

#get average sentence lengths
find "$PWD/$outputFolder1" | parallel fastSentence.sh > $outputFile6
#find the number of appearances of a given word in the body of a book
#find "$PWD/$outputFolder2" | parallel ./wordSearch.sh "america"
#Rscript ProcessCountryTable.R countryStuff.data > countryNames.data
