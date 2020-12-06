args = commandArgs(trailingOnly = T)
table = read.table(args[2], sep = ",")
output = paste0(args[2], ":", table$V2[which(table$V1 == args[1])])
print(output, max.levels=F)
