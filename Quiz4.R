library('data.table')

##### Q1
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
data <- data.table::fread(fileUrl)
nameSplit <- strsplit(names(data),'wgtp')
nameSplit[[123]]

##### Q2
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
GDP <- data.table::fread(fileUrl
                         ,skip = 5
                         ,nrows = 190
                         ,select = c(1,2,4,5)
                         ,col.names = c('CountryCode','Rank','Country','GDP')
              )
GDPonly <- as.integer(gsub(pattern=',',replacement = '',GDP$GDP))
mean(GDPonly)

##### Q3
index <- grep('^United',GDP$Country)
GDP$Country[index]

##### Q4

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
fileUrlEdu <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'
download.file(fileUrl,'./GDP.csv', method = 'curl')
download.file(fileUrlEdu,'./Edu.csv', method = 'curl')

GDP <- fread('GDP.csv',skip = 5, nrows = 190
             , select = c(1,2,4,5)
             , col.names = c('CountryCode','Rank','Country','GDP')
             
             )
Edu <- fread('Edu.csv')

mergedGDPEdu <- merge(GDP,Edu,by = 'CountryCode')

fiscalJune <- grep('Fiscal year end: June', mergedGDPEdu$`Special Notes`)
NROW(fiscalJune)

##### Q5
install.packages('quantmod')
library(quantmod)
amz = getSymbols('AMZN',auto.assign = FALSE)
sampleTimes = index(amz)

amz2012 <-sampleTimes[grep('^2012',sampleTimes)]
NROW(amz2012)

amzMonday <- amz2012[weekdays(amz2012) == 'Monday']
NROW(amzMonday)
