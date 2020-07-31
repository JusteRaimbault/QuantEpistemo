
setwd(paste0(Sys.getenv('CS_HOME'),'/QuantEpistemo/Models/UKMigration'))

library(lubridate)
library(ggplot2)

progress <- read.csv('progress.txt',sep=";",header = F)
names(progress)<- c('ts','nodes','links','remaining')
progress$ts <- as_datetime(as.character(progress$ts),tz = "UTC",format="%s")

ggplot(progress)+geom_line(aes(x=ts,y=remaining))

ggplot(progress)+geom_line(aes(x=ts,y=nodes))
