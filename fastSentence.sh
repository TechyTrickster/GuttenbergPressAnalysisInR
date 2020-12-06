Rscript sentenceLength.R $1 | sed 's/\[1\]//g' | sed 's/\"//g' | sed 's/\/home\/theCore\/first_Analysis_Step\///g' | sed 's/-8//g' | sed 's/.txt.processed//g' | sed 's/-0//g'
