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

## grep for data for coal combustion
index1 <- with(SCC, grepl("coal", Short.Name, ignore.case = TRUE))
index2 <-
    with(SCC, grepl("combustion", Short.Name, ignore.case = TRUE))
index3 <-
    with(SCC, grepl('coal', EI.Sector, ignore.case = TRUE))

## get valid SCCs
coalCombustion1 <- SCC[index1 & index2,]
coalCombustion2 <- SCC[index3,]

## filter NEI set on these SCCs
coalCombustionData <-
    filter(NEI, SCC %in% coalCombustion1$SCC |
               SCC %in% coalCombustion2$SCC)

png('plot4.png')
print(
    qplot(
        year,
        Emissions,
        data = coalCombustionData,
        xlab = "Year",
        ylab = "Emissions in tons",
        main = "PM2.5 Emissions in USA (for coal combustion emission sources)"
    ) + geom_smooth(method = "lm")
)
dev.off()