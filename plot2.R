url <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
currWd <- getwd()
tempFile <- paste0(currWd, '/NEI_data.zip')
download.file(url, destfile = tempFile, method = "curl")
unzip(tempFile)
file.remove(tempFile)

## Read the data frames
NEI <- readRDS("summarySCC_PM25.rds")
SCC <-
    readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(dplyr)

## Get data for Baltimore
baltimore <- filter(NEI, fips == '24510')

## Get total emission sum, by year, for Baltimore data
baltimoreTotalEmissionsByYear <-
    tapply(baltimore$Emissions, baltimore$year, sum)

## Convert to data frame for easy plotting, for Baltimore data
baltimoreTotalEmissionsByYearDF <-
    data.frame(key = names(baltimoreTotalEmissionsByYear),
               value = baltimoreTotalEmissionsByYear)

## plot total emissions (Y axis) by year (X axis), for Baltimore city
png('plot2.png')
plot(
    baltimoreTotalEmissionsByYearDF$key,
    baltimoreTotalEmissionsByYearDF$value,
    type = 'l',
    xlab = "Year",
    ylab = "Total Emissions in tons",
    main = "PM2.5 Emissions in Baltimore City"
)
dev.off()