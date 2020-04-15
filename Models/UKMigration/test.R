
setwd(paste0(Sys.getenv('CS_HOME'),'/QuantEpistemo/Models/UKMigration'))

library(dplyr)

# check seed corpus
corpus <- as.tbl(read.table('export/seedcorpus.csv',sep=';',quote = '"',header = T))

apply(apply(corpus[,8:18],2,unique),2,length)
# -> missing 4 refs for residential_mobility_UK ?
apply(apply(corpus[,8:18],2,unique),2,function(x){max(x,na.rm = T)})


