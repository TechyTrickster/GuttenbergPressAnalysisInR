Rscript searchForWord2.R "$1" "$2" | sed 's/\[1\]//g' | sed 's/\"//g' | sed 's/\/home\/theCore\/second_Analysis_Step\///g' |sed 's/-8//g' | sed 's/.txt.processed.counted//g'
